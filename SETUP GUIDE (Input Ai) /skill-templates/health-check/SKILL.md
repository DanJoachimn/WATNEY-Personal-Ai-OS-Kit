---
name: health-check
description: Weekly automated check that [AI_NAME]'s whole setup is actually working — scheduled jobs, capture pipelines, memory hygiene, vault structure. Catches SILENT failures (a job that "runs" but writes nothing, a sync that broke when an app updated, memory quietly bloating). Runs weekly via launchd; reports by severity (🔴 broken / 🟡 degraded / 🟢 working / ⚪ unused) and pings [PARTNER_NAME] only if something needs attention. Trigger: "health check", "is everything working?", "audit my setup".
---

# Health Check — catch silent failures before they cost you

## Purpose (plain English)

Automations rot quietly. A scheduled job keeps "running" but stops producing anything (the app it reads from changed). A sync breaks and nobody notices for weeks. Memory files quietly balloon until recall degrades. None of this announces itself — it just silently stops helping.

This skill is a **weekly check-up for [AI_NAME]'s entire setup.** Once a week it inspects everything, sorts findings by severity, and pings [PARTNER_NAME] *only* if something actually needs attention. A clean week = silence.

> **Why this matters (real lesson):** the single most dangerous failure mode for a Partner AI is the *invisible* one — a job that exits "successfully" while doing nothing. [PARTNER_NAME] isn't a developer and can't be expected to notice. This skill is the safety net that makes invisible failures visible.

## When it runs

- **Auto:** weekly via launchd (suggested: Sunday morning). See `health-check.plist.template`.
- **Manual:** [PARTNER_NAME] says "health check", "is everything working?", "audit my setup".

## What it checks (the operator's Claude Code session builds `scripts/audit.py` to cover these)

1. **Scheduled jobs (launchd).** Parse `launchctl list | grep com.[user]`. For each job: get its last exit code. Exit 0 = ok-on-paper; non-zero = failed → read its error log and surface the actual error. ALSO flag jobs that exit 0 but haven't produced fresh output (the silent-failure pattern).
2. **Capture pipelines.** For each input source [AI_NAME] depends on (meeting notes, highlights, inbox captures, daily briefs), check: is there recent output? When did it last produce something? Flag anything stale.
3. **Memory hygiene.** If [AI_NAME] uses memory files, measure their size. Flag if they've grown past a healthy budget (creeping bloat degrades recall — see the `dreaming` / curator skills for the fix).
4. **Vault structure.** Expected folders present? Any stray/empty files at the vault root? Any obvious clutter?
5. **Privacy / hygiene.** Any plaintext secrets (API keys, tokens) sitting in files that shouldn't have them? Any reflective-area contamination if you follow the human-only/agent-writable split?

## Output

- A markdown report sorted by severity: **🔴 broken** (fix now) / **🟡 degraded** (works, but worse than designed) / **🟢 working** / **⚪ unused** (exists, no activity).
- Each 🔴/🟡 finding includes: what's wrong, the evidence, and a suggested fix.
- An at-a-glance index line appended each week, so trends show over time (chronic vs. one-off).
- **Notify [PARTNER_NAME] only if action is needed** (🔴 or 🟡 present). Clean week → write the report, stay silent. Use a modal dialog or your normal notification channel.

## Critical build note — Full Disk Access

If the report is written to a macOS-protected folder (`~/Desktop`, `~/Documents`, `~/Downloads`), a launchd job running plain `/usr/bin/python3` will **silently fail to write there** — and ironically the health-check itself becomes an invisible failure. Two fixes: (a) write the report somewhere unprotected, or (b) run the job via a Python binary granted Full Disk Access in System Settings. Pick one and verify the job exits 0 after install.

## Discipline: this skill REPORTS, it never auto-fixes

It measures, flags, and suggests. It does NOT silently repair things — an auto-fix during an audit makes a problem vanish before [PARTNER_NAME] sees it, defeating the point. Surface; let [PARTNER_NAME] (or a follow-up session) act.

## Smart-8th-grader explainer to give [PARTNER_NAME] after install

*"I set up a weekly check-up for [AI_NAME]'s whole system — like a car that runs its own diagnostics every Sunday. If everything's fine, you hear nothing. If something quietly broke (a daily job stopped working, a sync died after an app update), you get one message telling you what and how to fix it. It means nothing important can break for weeks without you knowing."*

## Companion skills
- `dreaming` / curator — health-check tells you memory is bloating; those skills trim it.
- `session-storage` — health-check confirms its index is fresh.
