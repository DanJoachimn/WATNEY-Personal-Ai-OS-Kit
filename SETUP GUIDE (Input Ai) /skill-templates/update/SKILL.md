---
name: update
description: Fetches the latest version of WATNEY (the Personal AI Kit) from GitHub, compares it to what's installed, and reconciles changes — applying skill updates, offering new skills/vault layers, preserving the user's tunings. Triggered by `/update`, "update my kit", "update my AI", "check for kit updates", "are there new skills?", or any equivalent. Reads the live UPDATE.md playbook from the repo so reconciliation logic is always fresh.
---

# Update Skill — fetch and reconcile WATNEY updates

## Purpose

The kit is hosted on a public GitHub repo. New skills, bug fixes, and visual improvements get pushed there over time. Without this skill, users would have to manually pull and figure out what changed. With it, they say `/update` and their AI does the work.

The skill is intentionally thin — most of the reconciliation logic lives in `UPDATE.md` in the repo itself. This skill fetches that file, reads it, and runs the playbook. That way, the *reconciliation logic itself* can evolve over time without needing the user to update the update skill.

## When this fires

### User says any of:

- `/update`
- "update my AI"
- "update my kit"
- "update WATNEY"
- "check for kit updates"
- "are there new skills available?"
- "anything new in the kit?"

### Auto-trigger (optional, off by default):

If the user enables it via `touch ~/Documents/[ai-name]/.auto-update-weekly`, this skill fires automatically once a week (via a launchd job at Sunday 09:00). Most users prefer manual updates so they're aware of changes.

## How it works (the four-step flow)

### Step 1 — Announce + check

Tell the user what's about to happen, in plain English:

> "Checking for kit updates from GitHub. I'll pull the latest version, compare to what you have, and walk you through anything new. Nothing changes on your end without you confirming."

Then run the snapshot + fetch:

```bash
cd "$HOME/Documents/[AI_NAME]/.kit"
CURRENT_COMMIT=$(git rev-parse HEAD)
git fetch origin main
NEW_COMMIT=$(git rev-parse origin/main)

if [ "$CURRENT_COMMIT" = "$NEW_COMMIT" ]; then
  echo "Already on latest."
fi
```

If already on latest → tell user:

> "✅ You're already on the latest version of the kit. Last update fetched: [timestamp]. Nothing to do."

Exit cleanly.

If new commits exist → continue.

### Step 2 — Fetch the live UPDATE.md playbook

The reconciliation logic lives in `UPDATE.md` inside the repo. Fetch the latest version of that file:

```bash
UPDATE_PLAYBOOK="$HOME/Documents/[AI_NAME]/.kit/UPDATE.md"
# After git fetch above, this file is already up to date
cat "$UPDATE_PLAYBOOK"
```

Read it. Follow it. It walks through:
- Snapshot creation (rollback marker)
- Change categorization (which file changes need what action)
- Skill update application (with consent for tuned skills)
- New skill offers
- New vault layer offers
- Local checkout fast-forward
- Summary + announcement

### Step 3 — Execute the playbook conversationally

Don't dump the playbook contents into chat. Translate each step into a plain-English conversation with the user. The playbook is your instructions; the user just sees the outcomes.

Per UPDATE.md's rules:
- **Tuned skills:** ask before replacing. Show the diff in a readable shape.
- **New skills:** offer once, accept yes/skip/show-me-details.
- **New vault folders:** offer once, accept yes/skip.
- **Documentation-only changes (guides, playbook.md):** mention in summary, no action needed.
- **Bug fixes to untouched skills:** apply by default, tell user what was fixed.

### Step 4 — Announce + offer next step

After reconciliation, summarize:

```markdown
✅ Update complete.

**What changed:**
- [N] skills updated: [list with one-line summaries]
- [N] new skills installed: [list]
- [N] new vault folders added: [list]

**What stayed the same:**
- Your tuned skills (preserved)
- Your vault content (untouched)

**Now running:** kit version [SHORT_HASH] (was [OLD_SHORT_HASH])
```

Offer follow-up:

> "Want me to walk you through any of the new skills, or pick up where we were?"

## Failure modes

| Symptom | Cause | Recovery |
|---|---|---|
| `git fetch` fails | No internet, GitHub down, or repo URL broken | Tell user in plain English. Don't roll back — nothing changed yet. Suggest re-trying later. |
| `git pull` fails with conflict | User has modified files inside `.kit/` (they shouldn't have) | Stash their changes to `_recovery/kit-stash-[date]/`, pull clean, surface what was stashed. |
| New skill fails to install | Skill file malformed or permissions issue | Skip that skill, continue with rest, log failure to `_recovery/update-log.txt`, tell user one skill didn't install. |
| Launchd plist rendering fails | Placeholder substitution broke | Log the raw error, tell user one scheduled job didn't get wired up, give them the manual command to install it later. |
| Something else | Unknown | Roll back to `pre-update-snapshot.txt` commit. Tell user in plain English. Log to `_recovery/`. |

**Hard rule:** every failure path leaves the system in either (a) the pre-update state or (b) a partially-updated-but-functional state. Never leave the kit half-broken.

## Hard rules

- **Never silently overwrite a tuned skill.** If `learnings.md` has content, ask before replacing the SKILL.md.
- **Never modify the user's vault content.** Updates only add new scaffold folders if user consents.
- **Always snapshot before pulling.** The rollback marker is non-negotiable.
- **Plain English only.** No raw git output, no diffs unless the user explicitly asks ("show me the diff").
- **Read the live UPDATE.md.** Don't hardcode reconciliation logic here — it's in the repo so it can evolve.

## Setup checklist (the AI installs this — user just confirms)

When this skill is first installed during the kit's main install (Stage 6 of INSTALL.md), the AI:

1. Copies the skill to `~/.claude/skills/update/`
2. Substitutes `[AI_NAME]` placeholder
3. (Optional) Creates `~/Documents/[ai-name]/.auto-update-weekly` flag file if user opted in
4. (If opted in) Installs the launchd job for weekly auto-update at Sunday 09:00

Tell the user:

> "Installed the `/update` skill. Anytime you want to check for new versions of the kit, just say `/update` or 'update my kit.' I'll fetch the latest from GitHub and walk you through anything new."

## Smoke test

1. Confirm `~/Documents/[ai-name]/.kit/` is a valid git checkout: `cd .kit && git status` should not error
2. Confirm the remote is reachable: `git fetch origin` should succeed
3. Confirm `UPDATE.md` exists in the repo: `ls .kit/UPDATE.md`
4. Run `/update` manually. With no upstream changes, output should be the "already on latest" message.
5. To test reconciliation paths: have an upstream commit that touches a skill, then run `/update`. Verify the consent flow works.

## Why this exists

Without `/update`: kit improvements stall on users' machines. The first install captures whatever the kit looked like that day; bug fixes shipped a month later never reach existing users. Every user becomes a fork.

With `/update`: improvements compound across the user base. Bug fixes propagate. New skills become available organically. The kit evolves and so does every install.

This is the same shape as `brew update` or `npm update` — except WATNEY is the dependency. The mental model the user has: *"I run /update once a month, my AI gets new tricks."*
