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
#   ./setup.sh watney Dani https://github.com/DanJoachimn/Partner-Ai-Kit-Personal.git
#
# Idempotent: safe to re-run if it failed partway.
# Logs every step to ~/Documents/[AI_NAME]/logs/install.log

set -euo pipefail

# ---------- Inputs ----------

AI_NAME="${1:-}"
PARTNER_NAME="${2:-}"
REPO_HTTPS_URL="${3:-https://github.com/DanJoachimn/Partner-Ai-Kit-Personal.git}"

if [ -z "$AI_NAME" ] || [ -z "$PARTNER_NAME" ]; then
    echo "ERROR: setup.sh requires AI_NAME and PARTNER_NAME arguments." >&2
    echo "Usage: ./setup.sh AI_NAME PARTNER_NAME [REPO_HTTPS_URL]" >&2
    exit 1
fi

# Lowercase + dash-clean the AI name for filesystem use
AI_NAME_LOWER="$(echo "$AI_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

# ---------- Constants ----------

HOME_DIR="$HOME"
AI_HOME="$HOME_DIR/Documents/$AI_NAME_LOWER"
KIT_DIR="$AI_HOME/.kit"
VAULT_DIR="$AI_HOME/vault"
LOGS_DIR="$AI_HOME/logs"
LOG_FILE="$LOGS_DIR/install.log"
RECOVERY_DIR="$AI_HOME/_recovery"
SKILLS_DIR="$HOME_DIR/.claude/skills"
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
    local SCAFFOLD_SRC="$KIT_DIR/SETUP GUIDE (Input Ai) /vault-scaffold/starter"

    if [ ! -d "$SCAFFOLD_SRC" ]; then
        bail "5-VAULT" "vault scaffold source not found at $SCAFFOLD_SRC"
    fi

    if [ ! -d "$VAULT_DIR" ]; then
        cp -R "$SCAFFOLD_SRC/" "$VAULT_DIR/"
    fi

    # Substitute placeholders in copied vault files
    find "$VAULT_DIR" -type f \( -name "*.md" -o -name "*.txt" \) -print0 | \
        xargs -0 perl -i -pe "
            s/\[AI_NAME\]/$AI_NAME/g;
            s/\[PARTNER_NAME\]/$PARTNER_NAME/g;
        "

    log_stage "5-VAULT" "vault scaffold built at $VAULT_DIR with placeholders substituted"
}

# ---------- Stage 6: User-level skills ----------

stage_skills() {
    local SKILL_SRC="$KIT_DIR/SETUP GUIDE (Input Ai) /skill-templates"
    mkdir -p "$SKILLS_DIR"

    # Core skills installed for every Partner AI. anti-ai-writing is the
    # voice discipline that fires on every written output — core to the kit's
    # "your AI sounds like you, not generated" promise. Don't move it to
    # optional; it's foundational.
    local CORE_SKILLS="anti-ai-writing kick-off wrap-up dreaming consolidating voice-compile update auto-update-check llm-council regenerate-doc"

    for skill in $CORE_SKILLS; do
        if [ -d "$SKILL_SRC/$skill" ]; then
            cp -R "$SKILL_SRC/$skill" "$SKILLS_DIR/$skill"
            # Substitute placeholders
            find "$SKILLS_DIR/$skill" -type f -name "*.md" -print0 | \
                xargs -0 perl -i -pe "
                    s/\[AI_NAME\]/$AI_NAME/g;
                    s/\[PARTNER_NAME\]/$PARTNER_NAME/g;
                "
        fi
    done

    log_stage "6-SKILLS" "$CORE_SKILLS installed to $SKILLS_DIR"
}

# ---------- Stage 6b: Subagents ----------

stage_agents() {
    local AGENT_SRC="$KIT_DIR/SETUP GUIDE (Input Ai) /subagent-templates"
    mkdir -p "$AGENTS_DIR"

    if [ ! -d "$AGENT_SRC" ]; then
        bail "6b-AGENTS" "subagent-templates folder not found at $AGENT_SRC"
    fi

    cp -R "$AGENT_SRC"/*.md "$AGENTS_DIR/" 2>/dev/null || true

    # Substitute placeholders in agent files
    find "$AGENTS_DIR" -type f -name "*.md" -print0 | \
        xargs -0 perl -i -pe "
            s/\[AI_NAME\]/$AI_NAME/g;
            s/\[PARTNER_NAME\]/$PARTNER_NAME/g;
        "

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

    log_stage "9-CLAUDEMD" "CLAUDE.md wired up at $AI_HOME/CLAUDE.md"
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
# stages never fail with a cryptic "command not found." Verified by Install #1
# (Julie, 2026-05-18) where ffmpeg was a silent hidden dependency for Telegram
# voice transcription — symptom was Whisper failing to decode .ogg files.

stage_deps() {
    # Homebrew — non-negotiable. Installed before this script runs in a clean
    # macOS, but verify.
    if ! command -v brew >/dev/null 2>&1; then
        bail "0-DEPS" "Homebrew not installed. Install first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi

    # ffmpeg — required for Telegram voice notes (voice IN: decoding .ogg from
    # Telegram for transcription; voice OUT: mp3 → ogg/opus conversion for
    # sendVoice API). Without it, the voice-note aha-moment in Stage 8 silently
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
stage_recovery
stage_claude_md
stage_complete

exit 0
