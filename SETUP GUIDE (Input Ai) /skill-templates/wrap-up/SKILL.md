---
name: wrap-up
description: End-of-session sweep that turns observed friction + iterations during the day into persistent learnings for the affected skills. Use when [PARTNER_NAME] says "wrap up", "wrap up the session", "close session", "end of day", "log learnings", or "let's sweep". Reviews what was used, what got tuned, drafts a per-skill update, asks [PARTNER_NAME] to approve, then appends to each skill's learnings.md and (if approved) updates the SKILL.md. Never writes without approval.
---

# Wrap-Up Skill — The Learnings Sweep

## Purpose

Today, the way [PARTNER_NAME]'s skills get sharper is: he iterates in conversation,
I notice, I update files in the moment. That works — but the lessons evaporate
when the session resets. **The wrap-up skill makes those lessons persistent.**

It runs at the end of a session. Reviews what was used and tuned during the
day. Drafts a per-skill learnings entry. Surfaces it for approval. Writes the
approved updates to each skill's `learnings.md` (and, when warranted, updates
the `SKILL.md` itself).

## When to use

### Explicit triggers ([PARTNER_NAME] says it)

- "wrap up", "wrap up the session"
- "close session", "close the session"
- "end of day"
- "log learnings", "sweep the learnings"
- "let's sweep"

### Auto-triggers — I OWN THESE, [PARTNER_NAME] won't remember

This is critical. [PARTNER_NAME] will forget to say "wrap up." My job is to notice
end-of-session signals and run the sweep myself, without being asked.

**Strong signals (offer wrap-up immediately):**

- [PARTNER_NAME] says any terminal phrase: *"good", "nice", "ship it", "park this",
  "for now", "let's pick this up later", "I'm done", "leaving it here",
  "OK that's good", "perfect", "noice"* — especially after substantive work
- [PARTNER_NAME] changes topic mid-session after 30+ min of focused skill work
- [PARTNER_NAME] goes quiet for >15 min after an active iteration burst (looks like he
  stepped away)
- A session has been live >2hr AND produced 2+ skill tunings AND we just hit
  a natural pause

**Weaker signals (mention it casually, don't force it):**

- [PARTNER_NAME] has iterated on the same skill 2+ times in a single sub-task
- [PARTNER_NAME] says "let's pick this up later" / "leave it for tomorrow"

### How to offer (don't be heavy)

When an auto-trigger fires, I append a one-liner at the end of my normal reply:

> *"Want me to sweep today's learnings before you go? Two skills got tuned
> ([X] and [Y]) — would lock them in for next time. Just say "ship it" or
> "skip."*

If [PARTNER_NAME] says "yes / ship it / approve" → run the sweep.
If [PARTNER_NAME] says "skip / not now" → drop it, don't re-ask for at least 30 min.
If [PARTNER_NAME] ignores it and keeps working → mention it once more at the next
natural pause; after that, just stay quiet.

**Hard rule on auto-triggers:** offer at most 2 times per session, no matter
how strong the signal. [PARTNER_NAME] would rather lose a day's learnings than feel
nagged. Better to under-offer and miss occasionally than over-offer and
become noise.

## How it works (the five-step sweep)

### Step 0 — Append to daily-memory (always — even on empty learnings days)

Before the per-skill learnings sweep, append a 1-line entry per meaningful decision/fact/shipped-thing from this session to `~/Documents/[ai-name]/vault/Memory/daily-memory.md` under `## Active (unprocessed)`.

Format: `YYYY-MM-DD HH:MM — [one-line summary of what mattered]`

**What counts as "meaningful":**
- A decision was made
- A fact was confirmed (about a person, project, brand rule)
- A preference was articulated
- Work shipped
- A thread opened or closed

**What does NOT go here:**
- Casual chat / pleasantries
- Iterations on a single draft (one entry for the *outcome*, not each turn)
- Failed experiments unless [PARTNER_NAME] wants the failure remembered

If the session genuinely produced nothing memorable, log nothing here. Empty days are valid for both daily-memory AND the learnings sweep.

The `dreaming` skill (fires at 02:00 nightly via launchd) will pick these entries up and integrate them into long-term memory while [PARTNER_NAME] sleeps. This is the working-memory layer; the learnings sweep below is the per-skill-tuning layer. They run in series, share a session, but write to different files.

### Step 1 — Inventory what happened

Look back across this session. Identify:

1. **Which skills were used or referenced.** Both directly invoked
   (`morning-brief`, `clauefi`, etc.) and indirectly informed
   (`anti-ai-writing` rules applied to a draft).
2. **Which skills were tuned.** Tunings are signals like:
   - [PARTNER_NAME] asked for a behavior change ("under 200 words", "stop opening with X")
   - [PARTNER_NAME] gave explicit feedback ("this was too long", "this missed the mark")
   - I made a fix that should propagate (bug fixed, edge case handled, default changed)
   - [PARTNER_NAME] noticed a pattern across runs ("you keep doing X — stop")
3. **Which deliverables shipped** that weren't tied to a specific skill —
   note these separately, they don't go into a learnings.md.

### Step 2 — Draft per-skill updates

For each affected skill, draft a candidate `learnings.md` entry in this shape:

```markdown
## YYYY-MM-DD — [one-line summary of the tuning]

**What happened:** [2-3 lines of context. What did [PARTNER_NAME] do, what did I produce,
what was the friction or the approval signal.]

**The lesson:** [1-2 lines. What should this skill do differently going
forward.]

**Action taken:** [What got changed. Reference specific files/lines if SKILL.md
itself was edited. "No SKILL.md change — kept as a tuning to apply at runtime"
is also valid.]
```

Then propose, for the **active tunings** section at the top of `learnings.md`,
a one-line entry like:

```
- [domain]: [the rule]. (Set 2026-05-04.)
```

### Step 3 — Surface to [PARTNER_NAME] for approval

Present the sweep in this shape, in chat:

```
Wrap-up sweep — N skills affected today:

1. [skill-name] — [one-line summary]
   Active tuning: "[the one-liner]"
   Full entry: [show the YYYY-MM-DD section content]

2. [skill-name] — ...

Approve all? Edit any? Skip any?
```

Wait for [PARTNER_NAME]'s response. [PARTNER_NAME] can:
- "approve all" / "ship it" / "yes" → write everything
- "skip #2" / "drop the second one" → skip that entry
- "edit #1: change [X] to [Y]" → tweak then write
- "no, drop everything" → write nothing

### Step 4 — Write the approved updates

For each approved skill:

1. **Append** the full YYYY-MM-DD section to the skill's `learnings.md`, under
   the `## History` heading.
2. **Update** the `## Active tunings` section at the top of `learnings.md`
   with the new one-liner. If the new tuning supersedes an older one, **move
   the older one to History** with a note ("Superseded YYYY-MM-DD by [new]").
3. **If the SKILL.md itself was edited during the session**, note that in the
   action_taken — don't re-edit. Just record what changed and why.
4. **Confirm in chat:** "Logged. N entries written to [skill]/learnings.md."

## Where learnings.md lives per skill

Default: `~/.claude/skills/[skill-name]/learnings.md`

For project-scoped skills (e.g. the partner AI's `~/watney/.claude/skills/check-telegram/`),
write to that skill's directory.

If the file doesn't exist yet, create it with this seed:

```markdown
# Learnings — [skill-name]

> Append-only log of feedback [PARTNER_NAME] has given on this skill. Read on every run
> BEFORE invoking the skill — apply any relevant tuning from "Active tunings".
>
> Format: `YYYY-MM-DD — [observation/feedback] → [what to do differently]`
> The wrap-up skill appends here at end-of-session after [PARTNER_NAME] approves.

## Active tunings

*— No active tunings yet. Loop seeded YYYY-MM-DD. —*

## History

*— Empty. —*
```

## Hard rules

- **Never write to a skill's learnings.md without [PARTNER_NAME]'s explicit approval.**
  Drafts in chat, writes only on confirmation.
- **Never delete from learnings.md.** History is append-only. Superseded tunings
  get marked superseded in History; they don't get removed.
- **Don't pad.** If a session had no real tuning signals, say so:
  *"Sweep complete — no skill tunings worth logging from today's session."*
  Empty days are valid.
- **Respect skills that aren't yours to touch.** Some skills (`/closeday`,
  `/graduate`, `/today`, etc. — Vin's reflection commands) are reflective, not
  operational. Don't append learnings there. Only add learnings to skills with
  operational outputs (clauefi, morning-brief, hyrox-daily-brief, granola-sync,
  check-telegram, etc.).
- **Don't re-edit a SKILL.md** the wrap-up doesn't own. If the SKILL.md was
  already updated during the session, note it in action_taken and move on.

## Smoke test

Run wrap-up at the end of a real session. The output should be:
- Compact (under ~30 lines for a normal day)
- Specific (real file paths, real one-liners, no vague handwaving)
- Approval-gated (no writes until [PARTNER_NAME] confirms)
- Honest about empty days (don't fabricate lessons)

## Skills that should have a learnings.md (audit, not a mandate)

The skills most likely to benefit from a learnings loop, based on output
frequency + [PARTNER_NAME]'s iteration patterns:

- **morning-brief** — Already seeded. First experiment.
- **clauefi** — High-output, frequent iteration on tone/sections
- **hyrox-daily-brief** — High-output, frequent feedback on sources/angles
- **granola-sync** — Quieter; only log when something actually changes
- **check-telegram** (in `~/watney/`) — Voice rules, reply length, etc.
- **ingest-meeting** — Notability gate tuning, citation format
- **anti-ai-writing** — Cross-cutting rules, evolves slowly

Don't pre-seed all of these. Let the wrap-up surface "this skill needs a
learnings.md but doesn't have one — should I create it?" the first time it
catches a tuning for that skill.

## Why this matters

Without the loop: every time [PARTNER_NAME] says "stop doing X" or "shorter please" or
"that landed perfectly," the lesson lives in his head until it leaves. The
skill gets re-tuned every session.

With the loop: each lesson lands in `learnings.md`, the skill reads it on
next invocation, the tuning compounds. After a month, the skill knows things
no other partner's instance of the same skill knows. **That's the moat.**

---

## Voice-interview nudges (the second job of this skill)

Beyond the per-skill learnings sweep, this skill also handles two voice-interview nudges. Both are checked at the start of every wrap-up run, BEFORE the learnings sweep. Max one voice-related nudge per run.

### Monthly nudge — incomplete deluxe interview

**Condition:** `.voice-express-complete` exists AND `.voice-interview-complete` does NOT exist AND `.voice-nudge-disabled` does NOT exist AND last nudge was >30 days ago (or never).

```bash
EXPRESS_DONE="$HOME/Documents/[ai-name]/.voice-express-complete"
DELUXE_DONE="$HOME/Documents/[ai-name]/.voice-interview-complete"
NUDGE_DISABLED="$HOME/Documents/[ai-name]/.voice-nudge-disabled"
LAST_NUDGE="$HOME/Documents/[ai-name]/.voice-nudge-last"

if [ -f "$EXPRESS_DONE" ] && [ ! -f "$DELUXE_DONE" ] && [ ! -f "$NUDGE_DISABLED" ]; then
    NUDGE_AGE=999  # default: nudge if file doesn't exist
    if [ -f "$LAST_NUDGE" ]; then
        NUDGE_AGE=$(( ($(date +%s) - $(stat -f "%m" "$LAST_NUDGE")) / 86400 ))
    fi
    if [ "$NUDGE_AGE" -gt 30 ]; then
        # Offer the nudge
    fi
fi
```

**The offer:**

> "Quick monthly check-in: a month ago we did the 5-question express version of your voice setup. The deluxe 100-question interview is still on the table — about 90 minutes, produces a high-fidelity portable voice file that genuinely sounds like you across any AI. Want to schedule it this week, or push another month? Or say 'stop nudging me about voice' and I'll drop it permanently."

**User responses:**
- "Let's do it now / this week / [day]" → schedule via the kick-off skill's B-Deluxe path. After completion, auto-invoke `voice-compile`.
- "Push another month" / "not yet" / "later" → `touch "$LAST_NUDGE"` (resets the 30-day clock).
- "Stop nudging" / "drop it" / "no never again" → `touch "$NUDGE_DISABLED"`. Confirm: *"Got it — I won't bring up the deluxe interview again unless you ask. You can always reverse this by saying 'set up my voice file properly'."*

### Yearly refresh nudge — stale about-me file

**Condition:** `.voice-interview-complete` exists AND `.voice-interview-date` is >365 days old AND last nudge was >30 days ago (or never).

```bash
DELUXE_DONE="$HOME/Documents/[ai-name]/.voice-interview-complete"
INTERVIEW_DATE_FILE="$HOME/Documents/[ai-name]/.voice-interview-date"

if [ -f "$DELUXE_DONE" ] && [ -f "$INTERVIEW_DATE_FILE" ]; then
    INTERVIEW_TS=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$(cat "$INTERVIEW_DATE_FILE")" +%s 2>/dev/null || echo 0)
    AGE_DAYS=$(( ($(date +%s) - INTERVIEW_TS) / 86400 ))
    # Same 30-day re-nudge throttle as above using $LAST_NUDGE
    if [ "$AGE_DAYS" -ge 365 ] && [ "$NUDGE_AGE" -gt 30 ]; then
        # Offer the refresh
    fi
fi
```

**The offer:**

> "It's been a year since you did the deep voice interview. Your taste evolves — beliefs you held last year may have shifted. Want to do a focused 30-minute refresh? Just the sections most likely to have changed: beliefs, taste-loves, taste-disgusts, hard nos. I'll recompile the about-me file after. Or let it ride another year."

**User responses:**
- "Yes / let's do it" → run a focused 30-min refresh (4 sections only), then auto-invoke `voice-compile` to rebuild the about-me file.
- "Not yet" → `touch "$LAST_NUDGE"` (resets 30-day clock).
- "It still sounds like me" → confirm: *"OK, parking. I'll bring it up again next year. If you ever notice it feels stale before then, just say 'refresh my voice' and we'll do it on demand."*

### Hard rules for voice nudges

- **Max one voice-related nudge per wrap-up run.** Don't stack monthly + yearly.
- **Never nudge mid-task.** Wait for the natural pause that the wrap-up sweep is happening at anyway.
- **Always honor `.voice-nudge-disabled`.** If it exists, never bring up the deluxe interview unsolicited. Period.
- **Yearly refresh is opt-in even when it fires.** Defer or decline both work; "not yet" resets the timer.
- **Reverse opt-out is opt-in.** If [PARTNER_NAME] says "set up my voice file properly" after disabling nudges, treat that as re-enabling and proceed.

### 1Password upgrade nudge (the third job)

**Condition:** `.1password-upgrade-pending` exists AND `.1password-upgrade-complete` does NOT exist AND `.1password-nudge-disabled` does NOT exist AND last nudge was >30 days ago (or never).

This fires only if [PARTNER_NAME] said "maybe later" during kick-off's 1Password question (Section A1.5). If they said "no" or "skip" at kick-off, the pending flag was never created, so this nudge never fires.

```bash
PENDING="$HOME/Documents/[ai-name]/.1password-upgrade-pending"
DONE="$HOME/Documents/[ai-name]/.1password-upgrade-complete"
DISABLED="$HOME/Documents/[ai-name]/.1password-nudge-disabled"
LAST_NUDGE="$HOME/Documents/[ai-name]/.1password-nudge-last"

if [ -f "$PENDING" ] && [ ! -f "$DONE" ] && [ ! -f "$DISABLED" ]; then
    NUDGE_AGE=999
    if [ -f "$LAST_NUDGE" ]; then
        NUDGE_AGE=$(( ($(date +%s) - $(stat -f "%m" "$LAST_NUDGE")) / 86400 ))
    fi
    if [ "$NUDGE_AGE" -gt 30 ]; then
        # Offer the nudge
    fi
fi
```

**The offer:**

> "Quick monthly check-in: a month ago you said 'maybe later' on the 1Password upgrade — storing your API keys in an encrypted vault instead of the `.env` file. Want to do it this week, push another month, or drop it permanently? Takes about 10 minutes."

**Responses:**
- "Let's do it" → run the 1Password install steps from Guide 03's *"Upgrade path"* section. After completion: `touch "$DONE"` and `rm "$PENDING"`.
- "Push another month" / "not yet" → `touch "$LAST_NUDGE"` (resets 30-day clock).
- "Drop it" / "stop nudging" → `touch "$DISABLED"` and `rm "$PENDING"`. Confirm: *"Got it — won't bring up the 1Password upgrade again unless you ask. Default `.env` pattern stays."*

**Cap:** max one 1Password nudge per wrap-up run. If a voice nudge already fired this run, skip the 1Password one. (Hard rule: never stack two upgrade nudges in the same sweep — feels nagging.)

### Substack nudge (the fourth job — SAFETY NET ONLY)

A safety-net invitation that **only fires if the kick-off's end-of-setup popup never happened** (e.g., osascript permissions blocked it, the user was on a mid-install Mac restart, or the popup got dismissed without engagement).

**Most users will never see this nudge** — they'll have already encountered the popup at the end of kick-off (Section F+) and either subscribed, picked "remind me in a week" (which fires a one-shot launchd reminder), or skipped permanently. This wrap-up nudge is the rare-edge-case fallback.

**Condition:** `.first-run-complete` exists AND `.first-task-shipped` exists AND `.substack-shared` does NOT exist (means NO popup ever fired or completed) AND `.substack-nudge-disabled` does NOT exist AND at least 48 hours have passed since `.first-task-shipped` was created.

(Note: the threshold is now 48 hours, not 24 — gives the launchd-scheduled follow-up at 7 days room to fire first if it was scheduled. If a user picked "remind me in a week," that popup fires on day 7 and sets `.substack-shared` — this wrap-up nudge will then skip permanently. The wrap-up nudge only catches users who got NO popup at all.)

The 24-hour delay matters. Pitching the Substack immediately after the first task ships feels transactional — *"thanks for using me, now sign up."* Waiting until the NEXT wrap-up sweep means the user has had at least one more productive session, has more reason to want updates, and the invitation lands as *"now that you're flowing"* rather than *"as a closing pitch."*

```bash
FIRST_RUN="$HOME/Documents/[ai-name]/.first-run-complete"
FIRST_TASK="$HOME/Documents/[ai-name]/.first-task-shipped"
SHARED="$HOME/Documents/[ai-name]/.substack-shared"
DISABLED="$HOME/Documents/[ai-name]/.substack-nudge-disabled"

if [ -f "$FIRST_RUN" ] && [ -f "$FIRST_TASK" ] && [ ! -f "$SHARED" ] && [ ! -f "$DISABLED" ]; then
    AGE_HOURS=$(( ($(date +%s) - $(stat -f "%m" "$FIRST_TASK")) / 3600 ))
    if [ "$AGE_HOURS" -ge 24 ]; then
        # Offer the nudge
    fi
fi
```

**The offer:**

> "One last thing before you go — and then I'll drop it for good either way. There's a Substack called *The ROXIE Stacked* you might actually want:
>
> - First word when new skills ship to your kit
> - Tactical playbooks for retention, content batching, race-anchored programming, member onboarding
> - Real reports from other operators — what's working, what's not, what you can copy
> - New ways to grow + operate a modern training club
>
> Free, weekly-ish. If you'd like to see it, say *'show me'* and I'll open it. If not, say *'skip'* and I'll never bring it up again. Either way, the kit's yours."

**Responses:**
- "Show me" / "yes" / "open it" → `open "https://theroxiestacked.substack.com"` AND `touch "$SHARED"`. Confirm: *"Opened in your browser. Subscribing is a single click on their page — totally up to you."*
- "Skip" / "no" / "not interested" → `touch "$SHARED"` AND `touch "$DISABLED"`. Confirm: *"Got it. Won't bring it up again."*
- "Maybe later" → just `touch "$SHARED"`. Confirm: *"OK — won't auto-surface again, but if you ever want it, the link's in `STAY_IN_TOUCH.md` at the root of your kit folder."*

**Hard rules for the Substack nudge:**
- **Fires exactly once.** Either the user sees it (and either subscribes or skips) or they explicitly opt out. After that, the file flag stops it from re-surfacing.
- **Never fire during install.** The kick-off skill is for getting set up, not for being pitched. This nudge only fires AFTER first-task-shipped + 24 hours.
- **Cap (combined with other nudges):** max one upgrade-or-substack nudge per wrap-up run. Priority order: voice > 1Password > Substack. If any earlier nudge already fired this sweep, skip Substack — don't stack.
- **Honor the flag forever.** `.substack-shared` means the invitation happened. We don't re-invite. If the user wants the link later, they read `STAY_IN_TOUCH.md` directly.
- **The link opens in the browser.** Don't try to paste subscribe forms into chat. The Substack subscribe flow is one click on their site.
