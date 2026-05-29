---
name: consolidating
description: Weekly curator pass that keeps [AI_NAME]'s memory lean and clean — the periodic-cleanup rhythm that stops memory files from quietly bloating over time. Measures memory size against a healthy budget and flags when it's creeping; surfaces stale or duplicate entries; reports what needs a trim. REPORTS only — never silently rewrites memory. Runs weekly via launchd. Trigger: "run the curator", "check memory budget", "is memory bloating?".
---

# Consolidating — the weekly memory curator

## Purpose (plain English)

[AI_NAME]'s long-term memory (`vault/Memory/long-term.md`) gets loaded into context often, so it needs to stay lean. But memory naturally fattens: every session adds a line, and nothing prunes it. Left alone, it bloats — and a bloated memory file actually makes recall WORSE (the model reads it but the important facts get buried; this is the "lost in the middle" effect).

The `dreaming` skill compresses each day's notes into long-term memory (nightly). **This skill is the weekly weigh-in on top of that:** it checks whether long-term memory has crept past a healthy size, flags stale or duplicated entries, and tells [PARTNER_NAME] when a trim is due. It doesn't diet *for* you — it tells you when you're creeping up so you can.

> **Why a weekly curator instead of a hard size cap?** Some agent frameworks (e.g. Hermes) enforce a hard character cap on memory. That works for their generic, no-vault design. A vault-backed Partner AI can hold more (the memory file is an index into a bigger vault), so instead of a rigid cap, the discipline comes from a periodic curation rhythm — this skill. Same goal (lean, high-signal memory), gentler mechanism.

## When it runs

- **Auto:** weekly via launchd (suggested: Sunday, right after `health-check`). See `consolidating.plist.template`.
- **Manual:** [PARTNER_NAME] says "run the curator", "check memory budget", "consolidate the memory".

## What it checks (the operator's Claude Code session builds `scripts/curate.py`)

1. **Memory budget.** Measure the size of `long-term.md` (and any always-loaded memory files). Compare to a healthy budget. Green (lean) / Yellow (creeping — suggest a trim) / Red (bloated — trim now). Pick the budget to match the install; the point is to catch *regression* (sudden growth), not to nitpick.
2. **Stale entries.** Flag memory entries that reference dates/projects now long past, or that haven't been touched in a long time — candidates to archive or drop.
3. **Duplicates / near-duplicates.** Flag entries that say the same thing twice (a common drift when memory is appended to over months).
4. **(If used) pending/candidate items.** If [AI_NAME] keeps a "pending" area for un-promoted facts, list what's waiting for [PARTNER_NAME]'s review.

## Output

- A short markdown report: budget status (🟢/🟡/🔴) + any stale/duplicate flags + suggested trims.
- Notify [PARTNER_NAME] only if action is needed (yellow/red budget, or items to review). Clean week → stay silent.
- The fix, when budget is yellow/red: run the memory-consolidation pass (have [AI_NAME] dedupe + tighten `long-term.md`, with [PARTNER_NAME]'s approval).

## Discipline: REPORTS, never auto-rewrites memory

This skill measures and flags. It does NOT silently rewrite memory — memory is [PARTNER_NAME]'s reflective layer, and silent rewrites would erase nuance + can't be reviewed. It surfaces the need; [PARTNER_NAME] (or an approved consolidation pass) does the actual trim.

## Full Disk Access note

If the report writes to a macOS-protected folder (`~/Desktop`, `~/Documents`, `~/Downloads`), a launchd job running plain `/usr/bin/python3` silently fails to write there. Write the report to an unprotected path, or run via a Python binary granted Full Disk Access. Verify the job exits 0 after install.

## Smart-8th-grader explainer to give [PARTNER_NAME] after install

*"[AI_NAME]'s memory notebook quietly gets fatter over time, and a too-fat notebook actually makes it harder to find the important stuff. I set up a weekly weigh-in: once a week it checks if the notebook's getting bloated and tells you when it's time for a tidy-up. It never tidies behind your back — it just flags it, so you stay in control of what [AI_NAME] remembers."*

## Companion skills
- `dreaming` — nightly: compresses the day into long-term memory. consolidating is the weekly check that the result stays lean.
- `health-check` — runs the same morning; "is everything working" vs. this skill's "is memory clean".
