---
name: health-check
description: The deadman switch. A daily check that [AI_NAME]'s background jobs are actually alive — the overnight memory routine, the weekly tidy-up, the phone bridge. Catches SILENT failures (a job that "runs" but writes nothing, a job that stopped loading after an OS or app update). Runs daily via launchd on pure bash — deliberately depending on nothing else in this kit. Stays silent when everything's fine; fires a dialog only when something's actually broken. Trigger: "health check", "is everything working?", "are your jobs running?".
---

# Health check — the deadman switch

## Purpose (plain English)

Automations rot quietly. A scheduled job keeps "running" but stops producing anything. A job stops loading entirely after a system update. None of this announces itself — it just silently stops helping, and [PARTNER_NAME] carries on assuming their AI is working.

This skill is the **safety net that makes invisible failures visible.** It runs every morning, checks that [AI_NAME]'s background jobs are genuinely alive, and says nothing at all unless something is wrong.

## The rule that shapes this entire skill

> **THE ALARM MUST LIVE ON A DIFFERENT SUBSTRATE THAN THE THINGS IT WATCHES.**

This is not a design preference. It was learned from a real outage:

An earlier version of this check ran on Python, using the same environment as the jobs it monitored. A routine `brew` upgrade deleted that Python's framework. Every maintenance job crashed at once — **including the health check itself.** Everything still *looked* fine day to day, so the failure went unnoticed for a week.

So `health-check.sh` depends on **nothing but `/bin/bash` and `/usr/bin/osascript`** — both shipped with macOS, never touched by brew, pip, npm, a venv, or Claude. It reads only unprotected paths, so no permission change can silence it. And it asks `launchd` itself for each job's exit code rather than trusting any of the kit's own logging.

**If you ever "improve" this skill by rewriting it in Python, or by having it call the AI, you have reintroduced the exact bug it exists to catch.** Don't.

## When it runs

- **Auto:** daily at 09:15 via launchd. See `health-check.plist.template` — `setup.sh` renders and loads it automatically.
- **Manual:** [PARTNER_NAME] says *"health check"* / *"is everything working?"* → run `~/.claude/skills/health-check/health-check.sh` and report what it prints.
- **Testing:** `HEALTH_DRYRUN=1 ~/.claude/skills/health-check/health-check.sh` prints findings without firing the dialog.

## What it checks — and the three kinds of check

For every job it asks `launchd` two things first: **is it loaded**, and **did its last run exit clean?** Then, depending on the job's shape:

| Check | Used for | What it adds |
|---|---|---|
| `check_loaded` | jobs that run often and are legitimately silent when idle (the Telegram poller writes nothing on a quiet cycle) | nothing more — freshness here would cry wolf |
| `check` | jobs with a visible artifact (dreaming writes long-term memory) | the artifact must actually be recent |
| `check_marker` | jobs whose real output is hard to stat | fresh log **and** the success marker the job prints only after genuinely writing — this is what catches *"exit 0 but produced nothing"* |

Currently watched: **dreaming** (30h tolerance), **consolidating** (9 days), **telegram bridge** (loaded + clean exit).

It also writes its own heartbeat to `~/[AI_NAME]/.heartbeats/health-check`. If *that* goes stale, the watchman is the thing that died — and you can see it.

## Why the thresholds are generous

A laptop that sleeps overnight or spends a weekend closed will legitimately skip runs. Thresholds are deliberately loose (30h for a nightly job, 9 days for a weekly one) so normal life doesn't trigger alarms.

**A watchdog that cries wolf gets ignored, which defeats the entire point of having one.** It still catches a genuinely dead job within about a day.

## Why a dialog, not a Telegram message

The alert is a **modal dialog** via `osascript`. Two reasons: banners are easy to miss and are silently suppressed under some notification settings — and a missed alarm is no alarm. More importantly, **the Telegram bridge may be the thing that's dead.** An alarm must never depend on the system it's monitoring.

## Discipline: this skill REPORTS, it never auto-fixes

It measures, flags, and stops. It does not silently repair anything — an auto-fix makes a problem vanish before [PARTNER_NAME] ever sees it, which defeats the point. Surface it; let [PARTNER_NAME] (or a follow-up session) act.

## Smart-8th-grader explainer to give [PARTNER_NAME]

*"I set up a smoke alarm for the parts of me that run on their own. Every morning it checks that the overnight memory job, the weekly tidy-up, and your phone connection are all actually working. If everything's fine, you hear nothing — that's the point. If something quietly broke, you get one popup telling you what. The clever bit: it's built so it can't break at the same time as everything else. A smoke alarm wired into the same fuse box as the house isn't much of a smoke alarm."*

## Companion skills
- `dreaming` / `consolidating` — health-check notices when they stop; those skills do the actual memory work.
- `check-telegram` — health-check confirms the bridge that feeds it is still loaded.
