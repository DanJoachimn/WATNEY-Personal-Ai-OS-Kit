---
name: dreaming
description: Overnight memory-compression routine. Reads unprocessed entries from `vault/Memory/daily-memory.md`, integrates new signal into `vault/Memory/long-term.md`, marks daily entries processed. Fires automatically at 02:00 nightly via launchd. Can also be invoked manually with "run dreaming", "compress memory", "consolidate today's memory". The job that makes [AI_NAME] sharper while [PARTNER_NAME] sleeps.
---

# Dreaming Skill — overnight memory compression

## Purpose

Without this skill: [AI_NAME] accumulates a long list of 1-line daily-memory entries that compound forever. Eventually the file is too big to read efficiently, and the signal is buried in noise.

With this skill: every night at 02:00, [AI_NAME] reads what was logged that day (and any prior unprocessed days), distills the new signal, integrates it into `long-term.md`, and marks the daily entries as processed. [AI_NAME] gets sharper while [PARTNER_NAME] sleeps.

The wrap-up skill is the manual day-end version of this. Dreaming is the automated, can't-be-forgotten version. **Both exist:** wrap-up handles per-skill learnings (where [PARTNER_NAME] approves changes), dreaming handles the working-memory layer (which is fully autonomous).

## When this fires

### Auto-trigger (the default — 95% of runs)

A launchd job at `~/Library/LaunchAgents/com.[user].[ai-name].dreaming.plist` fires at 02:00 nightly. The plist runs:

```bash
claude -p "Run the dreaming skill — compress today's daily memory into long-term memory."
```

The Mac must be powered on at 02:00 (or close to it; launchd's `StartCalendarInterval` catches up if the Mac was asleep). If the Mac was off all night, the run is skipped and dreaming runs the next night with two days of accumulated daily-memory.

### Manual trigger

[PARTNER_NAME] says any of:
- "run dreaming"
- "compress memory"
- "consolidate today's memory"
- "process the daily-memory"

Run the same flow as the auto-trigger.

## How it works (the four-step compression)

### Step 1 — Read inputs

Read both:
- `~/Documents/[ai-name]/vault/Memory/daily-memory.md` — full file
- `~/Documents/[ai-name]/vault/Memory/long-term.md` — full file

If `daily-memory.md` has nothing under `## Active (unprocessed)` — exit with a one-line log entry: *"YYYY-MM-DD HH:MM — Nothing to process."* and stop. Don't fabricate.

### Step 2 — Synthesize

Look at the unprocessed daily-memory entries. For each, decide:

1. **Does this update an Active thread?** → modify the relevant entry in `long-term.md` → Active threads.
2. **Does this confirm or change a Settled fact?** → if confirm, update with new date + cite the daily-memory line. If change, move the old fact to "Superseded" with date, add the new fact citing the daily-memory line.
3. **Does this surface a Pattern?** → look for repetition across the unprocessed entries AND the existing Patterns. If a 3rd instance of a recurring theme appears, promote it to Patterns. Otherwise note it as "watching" if 2 instances exist.
4. **Does this introduce a new Person?** → only if they appear 2+ times across daily-memory OR with substantive content once. Otherwise skip; not every name becomes a long-term entry.
5. **Does this open an Open question?** → if [PARTNER_NAME] explicitly raised something unresolved, add it.

**Citation discipline:** every fact in `long-term.md` must cite its source as `[from daily-memory YYYY-MM-DD HH:MM]`. This makes the trail auditable.

### Step 3 — Rewrite long-term.md

Rewrite the file in full, with:
- All five sections (Active threads / Settled facts / Patterns / People / Open questions)
- Updated entries integrated
- Superseded entries moved to the bottom
- `updated:` frontmatter bumped
- `last_dreaming_run:` set to current ISO timestamp

**Keep it compact.** Aim for the file to stay under 500 lines. If it's growing past that, the synthesis is too verbose — tighten next run. Long-term memory is a *summary*, not an archive.

### Step 4 — Move processed daily-memory entries

In `daily-memory.md`:
1. Move all entries from `## Active (unprocessed)` to `## Processed` with a date marker:
   ```
   ## Processed YYYY-MM-DD
   ```
2. Bump `updated:` frontmatter.
3. If `## Processed YYYY-MM-DD` already exists for today (re-run), append to the existing day's section.

**Never delete daily-memory entries.** History is permanent. Long-term.md is the synthesis; daily-memory.md is the audit trail.

### Step 5 — Log the run

Append one line to `~/Documents/[ai-name]/logs/dreaming.log`:
```
YYYY-MM-DD HH:MM — Processed N entries. Long-term updated: [list of sections changed]. Runtime: Xs.
```

If anything went wrong, log the error and exit non-zero so launchd knows.

## Failure modes

| Symptom | Likely cause | Fix |
|---|---|---|
| Skill runs but produces no changes | No unprocessed entries since last run | Expected — log "nothing to process" and exit. Not a bug. |
| Long-term.md grows past 500 lines | Synthesis too verbose | Next run: tighten by consolidating older Patterns + moving stale Active threads to Settled facts. |
| Same daily-memory entries get processed twice | The "Processed" move didn't write | Check filesystem permissions on Memory/. Check `dreaming.log` for write errors. |
| Mac was off at 02:00 | Normal | launchd fires at next opportunity if `RunAtLoad` is true; otherwise dreaming runs next night with 2 days accumulated. Both fine. |
| `claude -p` returns nothing | API rate limit or auth issue | Log error, exit non-zero, retry next night. |
| Long-term.md got hand-edited by [PARTNER_NAME] | Multi-agent etiquette violation by user | Re-read and integrate respectfully. Don't overwrite user edits. |

## Hard rules

- **Citations on every fact.** Every line in long-term.md that asserts something cites the daily-memory line it came from. Without citations, [PARTNER_NAME] can't audit what [AI_NAME] thinks it knows.
- **Don't fabricate.** If today's daily-memory was empty or trivial, log "nothing to process" and stop. Empty days are valid.
- **Never delete daily-memory entries.** Always move to Processed.
- **Long-term.md is rewritten in full each run, but Superseded section accumulates.** Old facts move down rather than vanish.
- **Compact > complete.** A long-term.md that holds 80% of the signal in 200 lines beats one that holds 100% in 800 lines. Token efficiency matters at session-load time.
- **Re-read before edit.** Multi-agent vault rule. Bump `updated:` on every write.

## Setup checklist (the AI installs this — user just confirms)

When this skill is first installed during the kit's Phase 11 setup, the AI:

1. **Creates the launchd plist** at `~/Library/LaunchAgents/com.[user].[ai-name].dreaming.plist`. See `dreaming.plist.template` in this skill folder for the template.
2. **Loads it:** `launchctl load ~/Library/LaunchAgents/com.[user].[ai-name].dreaming.plist`
3. **Verifies it's scheduled:** `launchctl list | grep dreaming`
4. **Creates the log file:** `mkdir -p ~/Documents/[ai-name]/logs && touch ~/Documents/[ai-name]/logs/dreaming.log`
5. **Confirms with [PARTNER_NAME]:** *"Dreaming is wired up. Every night at 02:00, your AI will compress that day's memory into long-term memory while you sleep. You can also run it manually anytime by saying 'run dreaming.' First real run happens tonight if your Mac is on at 02:00 — otherwise the next available night."*

## Smoke test

1. Manually add 2-3 test entries to `daily-memory.md` under `## Active (unprocessed)`:
   ```
   2026-05-09 14:23 — TEST: Decided coffee at noon is the productivity peak.
   2026-05-09 14:24 — TEST: Sam from HYROX confirmed Q3 retention dashboard scope.
   ```
2. Manually invoke: *"run dreaming"*
3. Verify:
   - `long-term.md` got updated with the relevant sections (Patterns or Settled facts)
   - `daily-memory.md` moved the entries to `## Processed 2026-05-09`
   - `dreaming.log` got a line
   - `updated:` frontmatter bumped on both files
4. Run again immediately. Should log "nothing to process" and exit cleanly.
