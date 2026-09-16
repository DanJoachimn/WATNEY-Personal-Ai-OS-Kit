#!/bin/bash
# setup.sh — WATNEY deterministic foundation installer
#
# Runs the mechanical file-system work that previously consumed AI tokens
# in Stages 4-9 of INSTALL.md. Bash handles it deterministically.
#
# Usage:
#   ./setup.sh AI_NAME PARTNER_NAME [REPO_HTTPS_URL]
#
# Example:
#   ./setup.sh watney Dani https://github.com/DanJoachimn/WATNEY-Personal-Ai-OS-Kit.git
#
# Idempotent: safe to re-run if it failed partway.
# Logs every step to ~/[AI_NAME]/logs/install.log

set -euo pipefail

# ---------- Inputs ----------

AI_NAME="${1:-}"
PARTNER_NAME="${2:-}"
REPO_HTTPS_URL="${3:-https://github.com/DanJoachimn/WATNEY-Personal-Ai-OS-Kit.git}"

if [ -z "$AI_NAME" ] || [ -z "$PARTNER_NAME" ]; then
    echo "ERROR: setup.sh requires AI_NAME and PARTNER_NAME arguments." >&2
    echo "Usage: ./setup.sh AI_NAME PARTNER_NAME [REPO_HTTPS_URL]" >&2
    exit 1
fi

# Lowercase + dash-clean the AI name for filesystem use
AI_NAME_LOWER="$(echo "$AI_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

# ---------- Constants ----------

HOME_DIR="$HOME"
AI_HOME="$HOME_DIR/$AI_NAME_LOWER"
KIT_DIR="$AI_HOME/.kit"
VAULT_DIR="$AI_HOME/vault"
LOGS_DIR="$AI_HOME/logs"
LOG_FILE="$LOGS_DIR/install.log"
RECOVERY_DIR="$AI_HOME/_recovery"
SKILLS_DIR="$HOME_DIR/.claude/skills"
COMMANDS_DIR="$HOME_DIR/.claude/commands"
AGENTS_DIR="$AI_HOME/.claude/agents"
LAUNCHAGENTS_DIR="$HOME_DIR/Library/LaunchAgents"
USER_NAME="$(whoami)"

# ---------- Logging helper ----------

log_stage() {
    local stage="$1"
    local detail="$2"
    mkdir -p "$LOGS_DIR"
    echo "$(date -Iseconds) — $stage — $detail" >> "$LOG_FILE"
    echo "✅ $stage — $detail"
}

# Fill the name placeholders in files. Paths need the lowercase folder name
# ("~/gedemand/inbox"), prose needs the name as typed ("Gedemand"). The first
# real installs substituted the display name into paths, so the headless
# Telegram reply went looking in a folder that didn't exist.
fill_placeholders() {
    [ "$#" -gt 0 ] || return 0
    AI_NAME="$AI_NAME" AI_LOWER="$AI_NAME_LOWER" PARTNER="$PARTNER_NAME" WHO="$USER_NAME" \
    perl -i -pe '
        s{/\[AI_NAME\]}{/$ENV{AI_LOWER}}g;
        s/\[ai-name\]/$ENV{AI_LOWER}/g;
        s/\[AI_NAME\]/$ENV{AI_NAME}/g;
        s/\[PARTNER_NAME\]/$ENV{PARTNER}/g;
        s/\[user\]/$ENV{WHO}/gi;
    ' "$@"
}

bail() {
    local stage="$1"
    local detail="$2"
    mkdir -p "$LOGS_DIR" 2>/dev/null || true
    echo "$(date -Iseconds) — $stage — FAILED: $detail" >> "$LOG_FILE" 2>/dev/null || true
    echo "❌ $stage — FAILED: $detail" >&2
    exit 1
}

# ---------- Stage 4: Folder + git clone ----------

stage_clone() {
    mkdir -p "$AI_HOME" "$LOGS_DIR"
    cd "$AI_HOME"

    if [ -d "$KIT_DIR/.git" ]; then
        # Already cloned — pull latest
        cd "$KIT_DIR"
        git pull --quiet origin main 2>/dev/null || true
        log_stage "4-CLONE" "kit checkout already present at $KIT_DIR — pulled latest"
    else
        # Fresh clone
        if ! git clone --quiet "$REPO_HTTPS_URL" "$KIT_DIR" 2>/dev/null; then
            bail "4-CLONE" "git clone failed. Is git installed? Try: xcode-select --install"
        fi
        log_stage "4-CLONE" "cloned $REPO_HTTPS_URL → $KIT_DIR"
    fi
}

# ---------- Stage 5: Vault scaffold ----------

stage_vault() {
    local SCAFFOLD_SRC="$KIT_DIR/setup-guide/vault-scaffold/starter"

    if [ ! -d "$SCAFFOLD_SRC" ]; then
        bail "5-VAULT" "vault scaffold source not found at $SCAFFOLD_SRC"
    fi

    if [ ! -d "$VAULT_DIR" ]; then
        cp -R "$SCAFFOLD_SRC/" "$VAULT_DIR/"
    fi

    # Substitute placeholders in copied vault files
    find "$VAULT_DIR" -type f \( -name "*.md" -o -name "*.txt" \) -print0 | \
        while IFS= read -r -d '' f; do fill_placeholders "$f"; done

    log_stage "5-VAULT" "vault scaffold built at $VAULT_DIR with placeholders substituted"
}

# ---------- Stage 6: User-level skills ----------

stage_skills() {
    local SKILL_SRC="$KIT_DIR/setup-guide/skill-templates"
    mkdir -p "$SKILLS_DIR"

    # Core skills installed for every Partner AI. anti-ai-writing is the
    # voice discipline that fires on every written output — core to the kit's
    # "your AI sounds like you, not generated" promise. Don't move it to
    # optional; it's foundational.
    local CORE_SKILLS="anti-ai-writing kick-off wrap-up dreaming consolidating voice-compile update auto-update-check health-check llm-council regenerate-doc check-telegram watney-install-mentor"

    for skill in $CORE_SKILLS; do
        if [ -d "$SKILL_SRC/$skill" ]; then
            # Copy the folder's CONTENTS. `cp -R src dst` onto an existing dst nests
            # it (dst/skill/skill), which is what happens on a re-run or when Stage
            # 0.5 already installed waitwhat + llm-council early. This form
            # overwrites kit files and keeps anything extra, like learnings.md.
            mkdir -p "$SKILLS_DIR/$skill"
            cp -R "$SKILL_SRC/$skill/." "$SKILLS_DIR/$skill/"
            # Fill placeholders in instructions and scripts. Plist templates are
            # left alone: stage_launchd renders those with the lowercase name.
            find "$SKILLS_DIR/$skill" -type f \( -name "*.md" -o -name "*.sh" \) -print0 | \
                while IFS= read -r -d '' f; do fill_placeholders "$f"; done
        fi
    done

    # The routing index — lets the AI find the right skill without scanning them
    # all. Lives beside the installed skills, not just in the kit.
    if [ -f "$SKILL_SRC/_index.md" ]; then
        cp "$SKILL_SRC/_index.md" "$SKILLS_DIR/_index.md"
        fill_placeholders "$SKILLS_DIR/_index.md"
    fi

    # Slash commands — user-typed escape hatches. /waitwhat is the big one:
    # it lets a non-developer say "that didn't land" without feeling awkward.
    local CMD_SRC="$KIT_DIR/setup-guide/command-templates"
    if [ -d "$CMD_SRC" ]; then
        mkdir -p "$COMMANDS_DIR"
        cp "$CMD_SRC"/*.md "$COMMANDS_DIR/" 2>/dev/null || true
        for f in "$CMD_SRC"/*.md; do fill_placeholders "$COMMANDS_DIR/$(basename "$f")"; done
        log_stage "6-COMMANDS" "slash commands installed to $COMMANDS_DIR (/waitwhat)"
    fi

    log_stage "6-SKILLS" "$CORE_SKILLS + _index.md installed to $SKILLS_DIR"
}

# ---------- Stage 6b: Subagents ----------

stage_agents() {
    local AGENT_SRC="$KIT_DIR/setup-guide/subagent-templates"
    mkdir -p "$AGENTS_DIR"

    if [ ! -d "$AGENT_SRC" ]; then
        bail "6b-AGENTS" "subagent-templates folder not found at $AGENT_SRC"
    fi

    cp -R "$AGENT_SRC"/*.md "$AGENTS_DIR/" 2>/dev/null || true

    # Substitute placeholders in agent files
    find "$AGENTS_DIR" -type f -name "*.md" -print0 | \
        while IFS= read -r -d '' f; do fill_placeholders "$f"; done

    local AGENT_COUNT=$(ls -1 "$AGENTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
    log_stage "6b-AGENTS" "$AGENT_COUNT digital employees installed at $AGENTS_DIR"
}

# ---------- Stage 7: Scheduled jobs (launchd) ----------

stage_launchd() {
    mkdir -p "$LAUNCHAGENTS_DIR"

    # Dreaming — overnight memory compression at 02:00
    local DREAMING_PLIST_SRC="$SKILLS_DIR/dreaming/dreaming.plist.template"
    local DREAMING_PLIST_DST="$LAUNCHAGENTS_DIR/com.${USER_NAME}.${AI_NAME_LOWER}.dreaming.plist"

    if [ -f "$DREAMING_PLIST_SRC" ]; then
        sed \
            -e "s/\[USER\]/$USER_NAME/g" \
            -e "s/\[AI_NAME\]/$AI_NAME_LOWER/g" \
            "$DREAMING_PLIST_SRC" > "$DREAMING_PLIST_DST"

        # Unload first in case it was already loaded
        launchctl unload "$DREAMING_PLIST_DST" 2>/dev/null || true
        launchctl load "$DREAMING_PLIST_DST" 2>/dev/null || true

        log_stage "7-LAUNCHD" "dreaming scheduled job loaded (fires nightly at 02:00)"
    else
        log_stage "7-LAUNCHD" "dreaming plist template not found — skipped"
    fi

    # Consolidating — weekly memory curator (keeps long-term memory lean).
    # The nightly dreaming job compresses each day; this weekly job is the
    # weigh-in that flags when long-term.md is bloating. REPORTS only.
    local CURATOR_PLIST_SRC="$SKILLS_DIR/consolidating/consolidating.plist.template"
    local CURATOR_PLIST_DST="$LAUNCHAGENTS_DIR/com.${USER_NAME}.${AI_NAME_LOWER}.consolidating.plist"

    if [ -f "$CURATOR_PLIST_SRC" ]; then
        sed \
            -e "s/\[USER\]/$USER_NAME/g" \
            -e "s/\[AI_NAME\]/$AI_NAME_LOWER/g" \
            "$CURATOR_PLIST_SRC" > "$CURATOR_PLIST_DST"

        launchctl unload "$CURATOR_PLIST_DST" 2>/dev/null || true
        launchctl load "$CURATOR_PLIST_DST" 2>/dev/null || true

        log_stage "7-LAUNCHD" "consolidating (weekly memory curator) loaded"
    else
        log_stage "7-LAUNCHD" "consolidating plist template not found — skipped"
    fi

    # Health-check — the deadman switch. Daily 09:15, pure /bin/bash.
    # Deliberately runs on NOTHING but macOS built-ins: if Python, a venv, or
    # Claude itself breaks, this still fires and says so. Never "upgrade" it to
    # python3 or `claude -p` — that's the bug it exists to catch.
    local HEALTH_SH="$SKILLS_DIR/health-check/health-check.sh"
    local HEALTH_PLIST_SRC="$SKILLS_DIR/health-check/health-check.plist.template"
    local HEALTH_PLIST_DST="$LAUNCHAGENTS_DIR/com.${USER_NAME}.${AI_NAME_LOWER}.health-check.plist"

    if [ -f "$HEALTH_SH" ] && [ -f "$HEALTH_PLIST_SRC" ]; then
        chmod +x "$HEALTH_SH"

        sed \
            -e "s/\[USER\]/$USER_NAME/g" \
            -e "s/\[AI_NAME\]/$AI_NAME_LOWER/g" \
            "$HEALTH_PLIST_SRC" > "$HEALTH_PLIST_DST"

        launchctl unload "$HEALTH_PLIST_DST" 2>/dev/null || true
        launchctl load "$HEALTH_PLIST_DST" 2>/dev/null || true

        log_stage "7-LAUNCHD" "health-check deadman loaded (daily 09:15, bash-only)"
    else
        log_stage "7-LAUNCHD" "health-check script/template not found — skipped"
    fi
}

# ---------- Stage 7b: Telegram + voice scripts, poller job ----------
#
# Installed here, not by the AI mid-conversation. On the first real installs the
# AI couldn't write to ~/Library/LaunchAgents from inside the app, so it built
# staging folders and handed the user long scripts to paste. setup.sh runs in
# the user's own terminal, so it can put everything where it belongs in one go.
# The poller exits quietly until the Telegram token exists (Stage 11).

stage_telegram_voice() {
    local SCRIPTS_DIR="$AI_HOME/scripts"
    mkdir -p "$SCRIPTS_DIR" "$LOGS_DIR" "$LAUNCHAGENTS_DIR"

    local f
    for f in "$KIT_DIR/setup-guide/telegram-kit/poll-telegram.sh" \
             "$KIT_DIR/setup-guide/telegram-kit/send-telegram-text.sh" \
             "$KIT_DIR/setup-guide/voice-io-kit/say-to-mac.sh" \
             "$KIT_DIR/setup-guide/voice-io-kit/send-voice-note.sh" \
             "$KIT_DIR/setup-guide/voice-io-kit/transcribe.sh"; do
        [ -f "$f" ] || bail "7b-SCRIPTS" "missing kit script: $f"
        cp "$f" "$SCRIPTS_DIR/"
        chmod +x "$SCRIPTS_DIR/$(basename "$f")"
    done

    mkdir -p "$SKILLS_DIR/voice-io"
    cp -R "$KIT_DIR/setup-guide/voice-io-kit/." "$SKILLS_DIR/voice-io/"
    find "$SKILLS_DIR/voice-io" -type f -name "*.md" -print0 | \
        while IFS= read -r -d '' f; do fill_placeholders "$f"; done

    local LABEL="com.${USER_NAME}.${AI_NAME_LOWER}.telegram-poller"
    local PLIST="$LAUNCHAGENTS_DIR/${LABEL}.plist"
    cat > "$PLIST" <<PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array><string>${SCRIPTS_DIR}/poll-telegram.sh</string></array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>AI_NAME</key><string>${AI_NAME_LOWER}</string>
    <key>HOME</key><string>${HOME_DIR}</string>
    <key>PATH</key><string>${HOME_DIR}/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
  </dict>
  <key>StartInterval</key><integer>60</integer>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><false/>
  <key>StandardOutPath</key><string>${LOGS_DIR}/telegram-poller.out</string>
  <key>StandardErrorPath</key><string>${LOGS_DIR}/telegram-poller.err</string>
</dict>
</plist>
PLIST_EOF
    launchctl unload "$PLIST" 2>/dev/null || true
    launchctl load "$PLIST" 2>/dev/null || true

    log_stage "7b-TELEGRAM-VOICE" "poller + voice scripts in $SCRIPTS_DIR; poller job loaded (idle until the bot token exists)"
}

# ---------- Stage 8: Recovery file ----------

stage_recovery() {
    mkdir -p "$RECOVERY_DIR"

    if [ ! -f "$RECOVERY_DIR/env-template.txt" ]; then
        cat > "$RECOVERY_DIR/env-template.txt" <<EOF
# Recovery template — copy back to ~/.config/$AI_NAME_LOWER/.env on a new Mac.
# Get the actual secret values from your password manager or 1Password vault.
# This file is intentionally placeholder-only — no real secrets ever live here.
OPENAI_API_KEY=
ELEVENLABS_API_KEY=
ELEVENLABS_VOICE_ID=
TELEGRAM_BOT_TOKEN=
EOF
    fi

    log_stage "8-RECOVERY" "recovery template at $RECOVERY_DIR/env-template.txt"
}

# ---------- Stage 9: CLAUDE.md symlink at AI home root ----------

stage_claude_md() {
    local CLAUDE_MD_TARGET="$VAULT_DIR/CLAUDE.md"
    local CLAUDE_MD_LINK="$AI_HOME/CLAUDE.md"

    if [ -f "$CLAUDE_MD_TARGET" ] && [ ! -e "$CLAUDE_MD_LINK" ]; then
        ln -sf "$CLAUDE_MD_TARGET" "$CLAUDE_MD_LINK"
    fi

    # notes.md is a signpost to vault/Memory/ (the one real memory); USER_MANUAL.md is
    # what CLAUDE.md points the partner at. Both must exist. Idempotent — never overwrites.
    if [ ! -e "$AI_HOME/notes.md" ]; then
        cat > "$AI_HOME/notes.md" <<NOTES_EOF
# Memory lives in vault/Memory/

This file is only a signpost. ${AI_NAME}'s memory has two files:

- vault/Memory/daily-memory.md — one line per thing worth keeping, written during the day
- vault/Memory/long-term.md   — the short summary, rewritten nightly by the dreaming job, read every session

Don't add memory here. It won't reach the night shift.

NOTES_EOF
    fi

    local MANUAL_SRC="$KIT_DIR/setup-guide/user-manual-template.md"
    if [ -f "$MANUAL_SRC" ] && [ ! -e "$AI_HOME/USER_MANUAL.md" ]; then
        cp "$MANUAL_SRC" "$AI_HOME/USER_MANUAL.md"
        fill_placeholders "$AI_HOME/USER_MANUAL.md"
    fi

    log_stage "9-CLAUDEMD" "CLAUDE.md wired up; notes.md + USER_MANUAL.md present at $AI_HOME"
}

# ---------- Stage marker: setup.sh complete ----------

stage_complete() {
    touch "$AI_HOME/.setup-sh-complete"
    log_stage "SETUP-SH-COMPLETE" "deterministic foundation installed in $(($(date +%s) - START_TIME)) seconds"
    echo ""
    echo "==============================================="
    echo "✅ setup.sh complete."
    echo ""
    echo "AI home:        $AI_HOME"
    echo "Vault:          $VAULT_DIR"
    echo "Skills:         $SKILLS_DIR"
    echo "Subagents:      $AGENTS_DIR"
    echo "Logs:           $LOGS_DIR"
    echo "Install log:    $LOG_FILE"
    echo ""
    echo "Next: AI continues with the kick-off conversation."
    echo "==============================================="
}

# ---------- Stage 0: System dependencies ----------
#
# Hard dependencies the kit needs in Part 1. Checked + installed first so later
# stages never fail with a cryptic "command not found." ffmpeg was once a silent
# hidden dependency for Telegram voice transcription (see CHANGELOG.md).

stage_deps() {
    # Homebrew — non-negotiable. Installed before this script runs in a clean
    # macOS, but verify.
    if ! command -v brew >/dev/null 2>&1; then
        bail "0-DEPS" "Homebrew not installed. Install first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi

    # ffmpeg — required for Telegram voice notes (voice IN: decoding .ogg from
    # Telegram for transcription; voice OUT: mp3 → ogg/opus conversion for
    # sendVoice API). Without it, the voice-note aha-moment in Stage 13 silently
    # fails. Hyperframes / Video Use need the heavier `ffmpeg-full` (subtitle
    # support); they swap it themselves if/when those skills are installed.
    if ! command -v ffmpeg >/dev/null 2>&1; then
        log_stage "0-DEPS" "ffmpeg not found — installing via Homebrew (~30 sec)"
        brew install ffmpeg --quiet >/dev/null 2>&1 || bail "0-DEPS" "ffmpeg install failed — try 'brew install ffmpeg' manually then re-run setup.sh"
    fi

    log_stage "0-DEPS" "system dependencies verified (brew, ffmpeg)"
}

# ---------- Stage 5b: Tools cache scaffold ----------
#
# Scaffold a starter `tools/[name].md` per installed CLI dependency. These get
# read on-demand when the AI is about to use the tool — separate from
# `tools.md` which is the inventory read every session. Pattern inspired by
# Nate Herk's tools.md + /tools/ approach (and YC's "make everything legible
# to AI" framing).

stage_tools_cache() {
    local TOOLS_DIR="$VAULT_DIR/tools"
    mkdir -p "$TOOLS_DIR"

    # Auto-scaffold tools/ffmpeg.md if ffmpeg was just installed and the file
    # doesn't already exist. AI fills it in over time as $PARTNER_NAME actually
    # uses ffmpeg patterns.
    if command -v ffmpeg >/dev/null 2>&1 && [ ! -f "$TOOLS_DIR/ffmpeg.md" ]; then
        cat > "$TOOLS_DIR/ffmpeg.md" <<'EOF'
---
type: tool-reference
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# ffmpeg

## What it is

The free audio/video swiss-army knife. Used by [AI_NAME] primarily for Telegram voice
(converting .ogg ↔ mp3, decoding voice notes for Whisper transcription) and by
Hyperframes/Video Use skills if those are installed.

## Auth + setup

No auth required. Installed via Homebrew during setup.sh stage_deps. Plain
`ffmpeg` is sufficient for Telegram voice. Hyperframes/Video Use need
`ffmpeg-full` (subtitle filter support) and swap if/when installed.

## The commands [PARTNER_NAME] actually uses

*— Empty starter. [AI_NAME] fills this in as it uses ffmpeg in real sessions. Examples
that will land here:*
- `ffmpeg -i in.mp3 -c:a libopus -b:a 32k -f ogg out.ogg` (Telegram voice-out conversion)
- Specific scale/crop/concat patterns [PARTNER_NAME] uses

## Failure modes [PARTNER_NAME] has hit

*— Empty starter. Append-only as failures surface.*

## When to use ffmpeg vs alternatives

- For Telegram voice (in or out) — ffmpeg is the only choice
- For video editing — Hyperframes (animations) and Video Use (cuts) wrap ffmpeg
  with task-specific logic; reach for those rather than raw ffmpeg unless the
  job is one-off
- For audio extraction from video — raw ffmpeg is fine

## Upstream

- Official: https://ffmpeg.org/documentation.html
- Cheatsheet: https://gist.github.com/protrolium/e0dbd4bb0f1a396fcb55
EOF
        fill_placeholders "$TOOLS_DIR/ffmpeg.md"
        log_stage "5b-TOOLS" "scaffolded tools/ffmpeg.md (compressed reference)"
    fi
}

# ---------- Run all stages ----------

START_TIME=$(date +%s)

stage_deps
stage_clone
stage_vault
stage_skills
stage_agents
stage_tools_cache
stage_launchd
stage_telegram_voice
stage_recovery
stage_claude_md
stage_complete

exit 0
