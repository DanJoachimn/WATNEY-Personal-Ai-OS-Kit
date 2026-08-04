# Skills index — route first, search second

> **What this is:** the routing map for [AI_NAME]'s skills. Read *this* to find the right skill, then open only that skill's `SKILL.md`. Don't scan every skill to answer one question — that's slow and expensive.
>
> **Who reads it:** [AI_NAME] (any harness). Claude Code also auto-discovers skills by description, but this index is cheaper and works even where auto-discovery doesn't.
>
> **The rule:** route from this file → open the one relevant `SKILL.md` → act. Only fall back to searching the whole folder when the route isn't here or looks stale.

---

## Always on — these fire by themselves

| Skill | Fires when | What [PARTNER_NAME] gets |
|---|---|---|
| **anti-ai-writing** | every external-facing draft, automatically | Writing that doesn't read as machine-generated — ~250 AI tells stripped, their voice enforced |
| **dreaming** | nightly, 02:00 (launchd) | Yesterday's conversations harvested and compressed into long-term memory — they never re-explain themselves |
| **consolidating** | weekly (launchd) | Memory stays lean; bloat and duplicates flagged. **Reports only — never rewrites memory silently** |
| **auto-update-check** | session start, throttled to 8h | Quiet heads-up when the kit has updates worth taking |
| **health-check** | daily, 09:15 (launchd) | **The deadman switch.** Catches background jobs that died quietly. Pops a dialog only when something's actually wrong |
| **watney-install-mentor** | each install phase boundary | A plain-English "what just happened, why it matters to you" — during install only |

## Conversational — [PARTNER_NAME] asks, or [AI_NAME] offers

| Skill | Trigger | What [PARTNER_NAME] gets |
|---|---|---|
| **check-telegram** | *"check my Telegram"* · or the poller wakes it after a phone message | Phone messages read, acted on, and replied to |
| **wrap-up** | *"wrap up"*, *"that's good"*, end-of-session signals | Today's friction turned into permanent learnings, so the same mistake doesn't repeat |
| **kick-off** | automatically, the very first session | Onboarding: their voice, projects, working style, backup — captured once |
| **llm-council** | *"council this"*, *"pressure-test this"* | A real decision run past 5 independent advisors, then synthesized |
| **voice-compile** | after a voice interview (auto), or *"compile my voice"* | A long interview compressed into a high-fidelity voice file [AI_NAME] actually reads |
| **regenerate-doc** | *"regenerate [doc]"*, *"rebuild this from what we've learned"* | A stale doc rebuilt from accumulated source material instead of hand-patched |
| **update** | *"check for updates"*, *"update the kit"* | New kit version reconciled — their tunings preserved |

## Specs — shipped, but NOT working yet

These are **instructions without their scripts.** They don't function until the scripts are built (Part 2, or on request).

**If [PARTNER_NAME] asks for one of these, say plainly that it isn't set up yet and offer to build it. Never pretend to search something you can't.**

| Skill | Needs before it works | What it would give |
|---|---|---|
| **session-storage** | `scripts/ingest.py` + `query.py`, plus an hourly job | *"What did we discuss about X?"* answered from every past conversation |
| **vault-semantic-search** | Smart Connections plugin (Part 1 Stage 5.5) + `scripts/search.py` | Vault search by meaning — *"pricing"* also finds *"revenue"* and *"what to charge"* |

### A note on health-check — why it runs on nothing

`health-check` is the one skill deliberately built to depend on **no part of this kit**. Pure `/bin/bash` + `osascript`, no Python, no venv, no `claude` call, and it reads only unprotected paths so no permission change can silence it.

That's not fussiness — it's a scar. A previous version ran on the same Python environment as the jobs it watched. One `brew` upgrade killed that environment, every maintenance job died at once **including the watchdog**, and nobody noticed for a week because everything still *looked* fine.

**The alarm has to live on a different substrate than the things it watches.** If you ever "improve" this skill by rewriting it in Python or having it call the AI, you have reintroduced the exact bug it exists to catch.

---

## Rules for this folder

- **Skills stay pure markdown.** No skill in this kit ships executable scripts as a hard dependency. That's what keeps them readable by any AI, on any harness. Protect it.
- **Every skill has YAML frontmatter** with `name` and a `description` that states its triggers. That description is what auto-discovery matches on — keep it specific.
- **Update this index when a skill is added, removed, or changes its trigger.** A stale route is worse than no route.
- **Placeholders:** `[AI_NAME]` and `[PARTNER_NAME]` are substituted at install time by `setup.sh`.

## Which of these actually install

`setup.sh` installs **12** of these automatically (everything above except the three specs). The specs ship as templates so the scripts can be built later without re-downloading the kit.
