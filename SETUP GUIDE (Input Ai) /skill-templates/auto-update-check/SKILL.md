---
name: auto-update-check
description: Silent background check for kit updates from GitHub. Runs at the start of each Claude Code session in `~/[ai-name]/`, throttled to once every 8 hours. Fetches upstream changes, categorizes them (safe-to-apply vs needs-consent), auto-applies bug fixes to untouched files, surfaces a one-line notice for anything that needs the user's attention. NEVER touches user-customized skills, vault content, or recovery files. Pairs with the manual `/update` skill for full reconciliation when the user requests it.
---

# Auto-Update Check — silent kit refresh, safety-bounded

## Purpose

WATNEY gets better over time. Without auto-update, every installer is frozen at whatever version they pulled on install day. Bug fixes shipped a month later never reach them. Every user becomes a fork.

This skill keeps the kit current automatically — with strict safety bounds so the user's work is never broken.

## When this fires

### Auto-trigger

Every time Claude Code starts a session in `~/[AI_NAME]/`, this skill runs FIRST — before greeting the user — and silently:

1. Checks the throttle file `~/[AI_NAME]/.last-update-check`
2. If <8 hours since last check → exit immediately (no network calls, no output)
3. If ≥8 hours OR file doesn't exist → run the check (continues below)

The user never sees the check itself. They might see a one-line notice at the start of their first reply *only if there's something worth surfacing.*

### Manual trigger

User says `/update` → this fires the FULL update flow (the existing `update` skill), not this lightweight check.

## What this check does (the 4-step flow)

### Step 1 — Throttle check

```bash
THROTTLE_FILE="$HOME/[AI_NAME]/.last-update-check"
NOW=$(date +%s)
LAST=0
if [ -f "$THROTTLE_FILE" ]; then
    LAST=$(stat -f "%m" "$THROTTLE_FILE" 2>/dev/null || echo 0)
fi
AGE_HOURS=$(( (NOW - LAST) / 3600 ))

if [ "$AGE_HOURS" -lt 8 ]; then
    exit 0  # Silent. No-op.
fi
```

### Step 2 — Fetch + diff

```bash
cd "$HOME/[AI_NAME]/.kit"

# Touch the throttle file IMMEDIATELY — even if the fetch fails, we don't want
# to retry on every session. Wait the full 8 hours.
touch "$THROTTLE_FILE"

CURRENT_COMMIT=$(git rev-parse HEAD)

# Fetch with a short timeout. If network's slow or offline, bail silently.
if ! timeout 10 git fetch origin main 2>/dev/null; then
    exit 0  # Silent. Network not available. Try next session.
fi

NEW_COMMIT=$(git rev-parse origin/main)

if [ "$CURRENT_COMMIT" = "$NEW_COMMIT" ]; then
    exit 0  # Silent. Already on latest.
fi
```

### Step 3 — Categorize changes (the safety layer)

For each file changed between `$CURRENT_COMMIT` and `$NEW_COMMIT`:

```bash
git diff --name-status "$CURRENT_COMMIT..$NEW_COMMIT"
```

Apply categorization rules. **Hard rule: when in doubt, classify as NEEDS_CONSENT.**

| File path pattern | Category | Action |
|---|---|---|
| `SETUP GUIDE (Input Ai)/skill-templates/[skill]/SKILL.md` modified, AND user has `~/.claude/skills/[skill]/learnings.md` with active tunings | NEEDS_CONSENT | Don't auto-apply. Add to surface-notice. |
| `SETUP GUIDE (Input Ai)/skill-templates/[skill]/SKILL.md` modified, AND user's `~/.claude/skills/[skill]/learnings.md` is empty or doesn't exist | SAFE_TO_APPLY | Copy new SKILL.md to user's skill folder. Substitute `[AI_NAME]` / `[PARTNER_NAME]` placeholders. |
| `SETUP GUIDE (Input Ai)/skill-templates/[NEW_SKILL]/` (new folder) | NEW_SKILL_AVAILABLE | Don't auto-install. Add to surface-notice. |
| `SETUP GUIDE (Input Ai)/vault-scaffold/starter/[file]` modified | SCAFFOLD_DRIFT | Don't touch user's vault. Mention in surface-notice that the starter template evolved (informational only). |
| `SETUP GUIDE (Input Ai)/vault-scaffold/starter/[NEW_FOLDER]/` (new) | NEW_VAULT_LAYER | Don't auto-add. Add to surface-notice. |
| `guides/*.md` modified | DOCS_ONLY | No action needed. Optionally mention in surface-notice. |
| `assets/screenshots/*`, `assets/snippets/*`, `assets/diagrams/*` modified | ASSETS_ONLY | Auto-applies to `.kit/` checkout (the git pull handles it). Used by AI at install time only. No surface-notice needed. |
| `playbook.md`, `INSTALL.md`, `UPDATE.md`, `README.md` modified | DOCS_ONLY | No action needed. |

**Anything else → NEEDS_CONSENT (default to safe).**

### Step 4 — Apply safe changes + surface anything needing attention

**For SAFE_TO_APPLY items:**

```bash
# For each modified skill the user has but hasn't tuned:
USER_SKILL="$HOME/.claude/skills/[skill-name]/SKILL.md"
KIT_SKILL="$HOME/[AI_NAME]/.kit/SETUP GUIDE (Input Ai)/skill-templates/[skill-name]/SKILL.md"

cp "$KIT_SKILL" "$USER_SKILL"
perl -i -pe 's/\[AI_NAME\]/[AI_NAME]/g; s/\[PARTNER_NAME\]/[PARTNER_NAME]/g;' "$USER_SKILL"

# Log it
echo "$(date -Iseconds) — auto-applied update to [skill-name]" >> "$HOME/[AI_NAME]/logs/auto-update.log"
```

**Then fast-forward the local kit checkout:**

```bash
cd "$HOME/[AI_NAME]/.kit"
git pull origin main 2>/dev/null
```

**Surface to user (only if something happens):**

If anything was auto-applied OR anything needs consent, surface a SHORT one-line notice at the START of the AI's first reply this session. Format:

> *"💡 Kit update: [N safe fixes applied silently] + [M items need your call — say 'show updates' to review]."*

If nothing was auto-applied and nothing needs consent → no notice. Silent.

If ONLY safe fixes were applied → optional terse one-liner:

> *"💡 Kit auto-updated 2 skills with bug fixes (logged to ~/[ai-name]/logs/auto-update.log)."*

User can ignore. Or say "show updates" → invoke the full `/update` skill which reads the log + lists what changed in plain English.

## Hard safety rules

The whole point of this skill is **not breaking the user's work.** These rules are absolute:

1. **Never modify a tuned skill.** A skill is "tuned" if its `learnings.md` exists AND has non-empty content under the `## Active tunings` section. Even one user tuning = NEEDS_CONSENT.
2. **Never modify the user's vault.** `~/[AI_NAME]/vault/` is off-limits to this skill. Always.
3. **Never modify `_recovery/`.** That's the user's backup template.
4. **Never modify launchd plists that are loaded.** Re-rendering a plist while it's loaded could cause job duplication. Plist updates require manual `/update` flow.
5. **Never modify the user's `.env` or any file in `~/.config/[ai-name]/`.** Secrets territory. Off-limits.
6. **Touch the throttle file FIRST, before anything else.** Even if fetch fails. Even if categorization errors. The next session waits 8 hours regardless.
7. **Silent on no-change.** If nothing's new, no output. The user shouldn't even know this skill ran.
8. **Silent on network failure.** Don't surface "couldn't reach GitHub" — it's a background check. Try again in 8 hours.
9. **Log everything that gets auto-applied.** `~/[AI_NAME]/logs/auto-update.log` is the audit trail. User can read it to see what changed.
10. **When in doubt, classify as NEEDS_CONSENT.** Don't be clever. Err on the side of asking.

## Wiring it in

This skill is invoked by Claude Code on session start. The mechanism is a session-start hook in the user's CLAUDE.md (or a SessionStart hook in `settings.json`).

**In the kit-installed `CLAUDE.md` at `~/[AI_NAME]/CLAUDE.md`:**

```markdown
## Session start protocol

At the very start of each session — BEFORE responding to [PARTNER_NAME]'s first message — silently:

1. Invoke the `auto-update-check` skill. It self-throttles to once per 8 hours; most sessions it's a no-op.
2. Read `tools.md` if you haven't this session.
3. Read `Memory/long-term.md` for current context.

The auto-update-check might surface a one-line notice. Include it at the top of your first reply if so.
```

## When the user explicitly wants more control

The user can:

- **Run `/update` manually** any time → full reconciliation flow (the existing `update` skill). More thorough than this background check.
- **Disable auto-updates** by creating `~/[AI_NAME]/.auto-update-disabled`. This skill checks for it and exits immediately if present.
- **Force a check now** by deleting `~/[AI_NAME]/.last-update-check`. Next session re-checks regardless of timing.

## Smoke test

1. Manually delete the throttle file: `rm ~/[AI_NAME]/.last-update-check`
2. Open a new Claude Code session in the AI's folder
3. AI should silently run the check
4. If upstream has nothing new → no notice, silent operation
5. If upstream has new commits → either auto-applies (logged) or surfaces a notice
6. Check `~/[AI_NAME]/logs/auto-update.log` for the audit trail
7. Throttle file should now exist with current timestamp
8. Run a second session within 8 hours → check should no-op (verify by tailing the log file: nothing new)

## Why 8 hours

- Long enough that the check doesn't fire on every session-restart
- Short enough that fixes land same-day (typical user has 1-2 sessions per day)
- Network-cost-aware: a quick `git fetch` is cheap but not free
- Aligns with natural work rhythms: morning session does the check; afternoon session is silent
