# UPDATE.md — Live update playbook for WATNEY (Personal AI Kit)

> **This file is read by an AI agent when the user says "update my WATNEY" or invokes the `/update` skill.** It walks the AI through fetching the latest version of the kit from GitHub, reconciling changes, and announcing what's new — without breaking the user's existing setup.

---

## When this fires

The user says any of:
- `/update`
- "update my AI"
- "update WATNEY"
- "check for kit updates"
- "are there new skills available?"

Or the `/update` skill fires this automatically when invoked.

---

## The update flow (the AI runs these steps conversationally)

### Step 1 — Announce the intent

Tell the user what's about to happen, in plain English:

> "Checking for kit updates from the GitHub repo. I'll pull the latest version, compare it to what you have, and walk you through anything new. Nothing changes on your end without you confirming. ~30 seconds."

---

### Step 2 — Snapshot the current state

Record what version of the kit the user is currently running, before pulling:

```bash
cd "$HOME/Documents/[AI_NAME]/.kit"
CURRENT_COMMIT=$(git rev-parse HEAD)
echo "Current kit version: $CURRENT_COMMIT" > "$HOME/Documents/[AI_NAME]/_recovery/pre-update-snapshot.txt"
echo "Timestamp: $(date -Iseconds)" >> "$HOME/Documents/[AI_NAME]/_recovery/pre-update-snapshot.txt"
```

This is the rollback marker. If anything breaks, we can `git checkout $CURRENT_COMMIT` to get back.

---

### Step 3 — Fetch and compare

```bash
cd "$HOME/Documents/[AI_NAME]/.kit"
git fetch origin main
NEW_COMMIT=$(git rev-parse origin/main)

if [ "$CURRENT_COMMIT" = "$NEW_COMMIT" ]; then
  echo "Already on latest. Nothing to update."
  exit 0
fi

# What's new
git log --oneline "$CURRENT_COMMIT..$NEW_COMMIT"

# What files changed
git diff --name-status "$CURRENT_COMMIT..$NEW_COMMIT"
```

If `git fetch` fails (no internet) → surface in plain English:
> "Couldn't reach GitHub to check for updates. Check your internet and try again."

If on latest → tell user:
> "✅ You're already on the latest version of the kit. Nothing to update. Last updated: [date of CURRENT_COMMIT]."

---

### Step 3.5 — Refresh the upstream plugin marketplace

In parallel with the kit-level fetch, refresh the Anthropic-maintained `knowledge-work-plugins` marketplace. This pulls the latest manifest from `https://github.com/anthropics/knowledge-work-plugins` — doesn't auto-install anything, just makes new versions and new plugins visible.

```bash
claude plugin marketplace update knowledge-work-plugins 2>/dev/null || true
```

If the marketplace isn't installed yet (user skipped Stage 0.5 during install, or hasn't run Part 2), this command no-ops gracefully. Don't error.

Then check which installed plugins from this marketplace have updates available:

```bash
# List installed plugins from the kw marketplace
claude plugin list 2>/dev/null | grep "knowledge-work-plugins" || true
```

For each installed plugin, note:
- Current installed version
- Latest available version
- Whether an upgrade is available

Also check for **new plugins** added to the upstream marketplace since the user's last update. The marketplace manifest at `~/.claude/plugins/marketplaces/knowledge-work-plugins/.claude-plugin/marketplace.json` (or equivalent path) lists all available plugins. Diff against the plugins the user has installed to identify new ones.

Categorize for Step 9:
- **External plugin updates available** — plugins user has installed that have a new version upstream
- **New external plugins available** — plugins added to upstream marketplace that user doesn't have

Both get surfaced in Step 9. Neither auto-installs.

---

### Step 4 — Categorize the changes

Look at the changed files. Classify them:

| Change type | What it means | How to apply |
|---|---|---|
| `INSTALL.md` modified | Install flow changed — affects new installs only, not existing users | Skip — only matters for fresh installs |
| `UPDATE.md` modified | This file changed — affects future updates | Skip — already running the new version after pull |
| `kit/skill-templates/[skill]/SKILL.md` modified | A skill the user has installed got an update | **Apply** — see Step 5 |
| `kit/skill-templates/[new-skill]/` added | A brand new skill is available | **Offer** — see Step 6 |
| `kit/vault-scaffold/starter/[file]` modified | The starter scaffold for new files changed | **Skip in most cases** — only matters for new installs. Note in summary that the template evolved. |
| `kit/vault-scaffold/starter/[new-folder]` added | A new vault layer is recommended | **Offer** — ask user if they want to add the new folder |
| `guides/[guide].md` modified | A user-facing guide was updated | **Skip** — guides are reference material. Mention in summary. |
| `assets/screenshots/`, `assets/snippets/` modified | Visual references updated | **Skip** — used by AI at install/update time only |
| `playbook.md` modified | The kit's master playbook changed | **Skip** — reference doc only |

---

### Step 5 — Apply skill updates (with consent)

For each modified skill the user has installed:

```bash
USER_SKILL="$HOME/.claude/skills/[skill-name]/SKILL.md"
KIT_SKILL="$HOME/Documents/[AI_NAME]/.kit/SETUP GUIDE (Input Ai)/skill-templates/[skill-name]/SKILL.md"
```

**Check for local edits.** If the user has tuned their copy of the skill (via wrap-up or manually), don't silently overwrite:

```bash
diff -q "$USER_SKILL" "$KIT_SKILL"
```

If files differ AND the user's copy has a `learnings.md` with active tunings → preserve the user's tunings, surface the kit-side changes for review:

> "The kit's `[skill-name]` got an update. You've already tuned your copy with [N] active tunings. Want me to:
> - **(a)** Show you the kit's changes and let you decide what to merge into your tuned version
> - **(b)** Replace your tuned copy with the kit version (your tunings move to `[skill-name]/learnings.md` under 'History — superseded by upstream update')
> - **(c)** Skip this skill's update (you stay on your tuned version)"

If files differ AND no local tunings → safe to replace:

```bash
cp "$KIT_SKILL" "$USER_SKILL"
# Also substitute placeholders
perl -i -pe "s/\[AI_NAME\]/[AI_NAME]/g; s/\[PARTNER_NAME\]/[PARTNER_NAME]/g;" "$USER_SKILL"
echo "✅ Updated [skill-name]"
```

After applying skill updates, **re-load any launchd jobs** that reference updated skills:

```bash
# If dreaming SKILL.md changed, the launchd job still works (it just calls 'claude -p'), so no re-load needed.
# Re-load only if the plist itself changed.
```

---

### Step 6 — Offer new skills (with consent)

For each new skill in the kit that the user doesn't have:

> "New skill available: **[skill-name]**. [One-line description from the skill's frontmatter `description:` field]. Install it? (yes / show me details / skip)"

If yes:

```bash
cp -R "$HOME/Documents/[AI_NAME]/.kit/SETUP GUIDE (Input Ai)/skill-templates/[new-skill]/" \
      "$HOME/.claude/skills/[new-skill]/"
perl -i -pe "s/\[AI_NAME\]/[AI_NAME]/g; s/\[PARTNER_NAME\]/[PARTNER_NAME]/g;" \
  "$HOME/.claude/skills/[new-skill]/SKILL.md"

# If the skill has a launchd plist template, install + load it
if [ -f "$HOME/.claude/skills/[new-skill]/[new-skill].plist.template" ]; then
  # Render plist with placeholders
  USER=$(whoami)
  sed -e "s/\[USER\]/$USER/g" -e "s/\[AI_NAME\]/[AI_NAME]/g" \
    "$HOME/.claude/skills/[new-skill]/[new-skill].plist.template" \
    > "$HOME/Library/LaunchAgents/com.${USER}.[AI_NAME].[new-skill].plist"
  launchctl load "$HOME/Library/LaunchAgents/com.${USER}.[AI_NAME].[new-skill].plist"
fi
echo "✅ Installed [new-skill]"
```

---

### Step 7 — Offer new vault layers (with consent)

For each new top-level folder added to the kit's vault-scaffold:

> "The kit now ships with a new vault folder: **[folder-name]**. [One-line description from its README]. Want me to add it to your vault? (yes / show me what's in it / skip)"

If yes, copy the folder into the user's existing vault.

---

### Step 8 — Update the local .kit checkout

After all reconciliation is done, fast-forward the local kit checkout to the new commit:

```bash
cd "$HOME/Documents/[AI_NAME]/.kit"
git pull origin main
```

If the user has somehow modified files inside `.kit/` directly (they shouldn't have, but sometimes happens), `git pull` will error with conflict. In that case:

> "Your local `.kit/` folder has changes that conflict with the upstream update. I'm going to:
> 1. Stash your changes to `~/Documents/[ai-name]/_recovery/kit-stash-[date]/`
> 2. Pull the clean upstream version
> 3. Show you what was stashed in case you want to recover any of it
>
> OK to proceed?"

If yes, run the stash + reset + pull sequence. Log everything to `_recovery/`.

---

### Step 9 — Summary + announcement

Tell the user what changed, in plain English:

```markdown
✅ Update complete.

**What's new:**
- 2 skills updated: morning-brief (faster startup), wrap-up (better daily-memory phrasing)
- 1 new skill installed: weekly-retention-review (Sunday-night member-risk dashboard)
- 1 new vault folder added: Members/

**Knowledge Work Plugins (Anthropic-maintained, upstream):**
- 2 plugin updates available: `productivity` 1.2 → 1.4, `brand-voice` 0.8 → 1.0 — install?
- 1 new plugin upstream: `engineering` (code review, standups, incidents) — install?

**What didn't change:**
- Your tuned copy of `anti-ai-writing` stayed as-is (you have 3 active tunings)
- 4 guides got minor edits — none affect your active skills

**Now running kit version:** [NEW_COMMIT short hash]
```

Surface the **Knowledge Work Plugins** block only if there's something to report. If everything upstream is current and no new plugins shipped, skip the block entirely — don't show "nothing to report" noise.

If the user says "install" to any of the offered plugin updates / new plugins, run:

```bash
claude plugin install [name]@knowledge-work-plugins
```

For version-pinned updates, use whatever syntax the user's Claude Code version supports.

Then ask:

> "Want me to walk you through any of the new stuff, or pick up what we were doing before?"

---

## Failure recovery

If anything goes sideways during update:

1. Restore from the snapshot:
   ```bash
   cd "$HOME/Documents/[AI_NAME]/.kit"
   git checkout $(cat "$HOME/Documents/[AI_NAME]/_recovery/pre-update-snapshot.txt" | grep "Current kit version:" | cut -d' ' -f4)
   ```
2. Restore any skills that were partially overwritten from the snapshot timestamp
3. Tell the user in plain English:
   > "Something didn't go to plan during the update. I rolled everything back to where you were before the update started. Your AI is exactly where it was 2 minutes ago. The update can wait — try again later, or tell me to investigate."

---

## Hard rules

- **Never silently overwrite a tuned skill.** If `learnings.md` exists with content, ask before replacing the SKILL.md.
- **Never delete the user's vault content.** Updates only add new scaffold folders if user consents. Existing folders + files are untouched.
- **Always create a snapshot before pulling.** The `pre-update-snapshot.txt` is the rollback path.
- **Plain English for everything.** No raw git output, no diffs in chat unless user explicitly asks.
- **Updates are opt-in for additions, opt-out for fixes.** New skills require user yes. Bug fixes to existing skills apply by default (with user notified).

---

## Variables this playbook expects

| Placeholder | Source |
|---|---|
| `[AI_NAME]` | Read from `~/Documents/*/CLAUDE.md` frontmatter, or ask user if ambiguous |
| `[PARTNER_NAME]` | Same as above |
| Repo URL | Already baked into `~/Documents/[ai-name]/.kit/.git/config` after install (`https://github.com/DanJoachimn/Partner-Ai-Kit-Personal.git`) |

---

*Update playbook — read fresh from GitHub at every update so users always get the latest reconciliation logic, even if their kit checkout is stale.*
