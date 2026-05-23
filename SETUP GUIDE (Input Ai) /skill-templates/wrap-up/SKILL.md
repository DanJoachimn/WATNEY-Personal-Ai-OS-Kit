---
name: wrap-up
description: End-of-session sweep that turns observed friction + iterations during the day into persistent learnings for the affected skills, PLUS a pattern-observation pass that catches recurring friction across multiple sessions ([PARTNER_NAME] doesn't have to notice; the skill notices). Use when [PARTNER_NAME] says "wrap up", "wrap up the session", "close session", "end of day", "log learnings", "let's sweep", "any patterns", "what have you noticed", "should anything be tuned". Reviews what was used, what got tuned in this session, scans patterns-log for cross-session patterns crossing the 3-instances-over-7-days threshold, drafts a per-skill update for each, asks [PARTNER_NAME] to approve, then appends to each skill's learnings.md and (if approved) updates the SKILL.md. Never writes without approval. The recursive self-improvement loop for [PARTNER_NAME]'s kit — runs on [PARTNER_NAME]'s own Mac, observes only [PARTNER_NAME]'s own work, never sends data anywhere.
---

# Wrap-Up Skill — The Learnings Sweep (with Pattern Observation)

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

### Step 0.5 — Pattern observation pass (cross-session friction)

This is the recursive-improvement loop the kit ships with. [PARTNER_NAME] doesn't have to notice friction — this pass notices it across sessions and surfaces what's worth fixing.

**Where the patterns live:** `~/.claude/skills/wrap-up/patterns-log.md` — an append-only rolling 7-day buffer of observed friction. Read this at the start of every wrap-up.

**What counts as a pattern observation:**

1. **Repeated iteration on the same skill output.** [PARTNER_NAME] asks for a draft from the same skill, then corrects it, then asks again. If this happens 3+ times across the rolling window with the same correction direction, that's a pattern.

2. **Silent edits to drafts.** [PARTNER_NAME] takes a draft I produced and edits it before using it. If I can see the edited version (in chat, in a Gmail draft, in a vault file), the diff is a signal.

3. **Explicit corrections.** *"Stop opening with X,"* *"don't use the word Y,"* *"keep replies under 200 words."* Direct training signals. Capture verbatim.

4. **Skill output failures with the same root cause.** Same skill produces empty / wrong / truncated output multiple times. Pattern signal.

5. **Recurring questions [PARTNER_NAME] has to re-ask across sessions.** Memory failure pattern — the fix may be a vault edit, not a SKILL.md edit.

**Pattern thresholds (don't fire on noise):**

- **3 instances minimum** before considering a pattern actionable. One-off corrections aren't patterns.
- **7-day rolling window** for cross-session patterns. Older = stale signal.
- **Confidence threshold:** if <70% sure the pattern is real, log it but don't surface. False positives erode [PARTNER_NAME]'s trust in the sweep faster than missed signals erode value.

**Patterns-log entry format (append-only):**

```markdown
### YYYY-MM-DD HH:MM — [skill or domain]
[1-2 line description of what happened]
Signal type: [iteration | silent-edit | explicit | failure | recurring-question]
Confidence: [low | medium | high]
```

When a pattern crosses threshold (3+ instances of the same signal in the window), it gets promoted from observation to candidate-fix in Step 2 below. Sub-threshold observations stay in the log; cycle out after 7 days.

**What this pass does NOT do:**

- **Never sends data anywhere.** This is local-only. The patterns-log lives in `~/.claude/skills/wrap-up/` on [PARTNER_NAME]'s Mac and never leaves it.
- **Never runs continuously during a session.** Observation happens only during wrap-up runs (at session end or when [PARTNER_NAME] explicitly invokes). This keeps the token cost negligible (~200-500 tokens per wrap-up).
- **Never modifies skills autonomously.** Cross-session patterns surface as candidate fixes in Step 2, alongside the in-session learnings. Same approval gate.
- **Never accumulates indefinitely.** Patterns older than 7 days roll off the log unless they've been promoted to an active learnings.md entry.

### Step 1 — Inventory what happened

Look back across this session. Identify:

1. **Which skills were used or referenced.** Both directly invoked
   (any drafting or brief-generating skill) and indirectly informed
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

Present the sweep in this shape, in chat. **Two sections** — in-session tunings (from this session's friction) and cross-session patterns (from the patterns-log threshold pass). Either or both can be empty; surface only what's real.

```
Wrap-up sweep — [N] in-session tunings + [M] cross-session patterns

== In-session tunings (from today's friction) ==

1. [skill-name] — [one-line summary of what got tuned today]
   Active tuning: "[the one-liner]"
   Full entry: [show the YYYY-MM-DD section content]

2. [skill-name] — ...

== Cross-session patterns (3+ instances over rolling 7 days) ==

P1. [skill-name] — pattern crossed threshold
    Pattern: [one-line description] (N instances, confidence: high/medium)
    Proposed fix: [show the diff — what line is added/changed/removed]
    
P2. [skill-name] — ...

Approve all? Edit any? Skip any?
```

Wait for [PARTNER_NAME]'s response. [PARTNER_NAME] can:
- "approve all" / "ship it" / "yes" → write everything (both sections)
- "skip P2" / "drop the second pattern" → skip that pattern, keep others
- "skip #1" / "drop the first tuning" → skip in-session tuning, keep others
- "edit P1: change [X] to [Y]" → tweak then write
- "approve in-session, skip patterns" → write in-session only
- "approve patterns, skip in-session" → write patterns only
- "no, drop everything" → write nothing (but pattern observations stay in patterns-log for next sweep)

**Max 3 patterns surfaced at once.** Cognitive overload defeats the purpose. If more than 3 patterns are above threshold, present the top 3 by impact (most-used skill first, highest-confidence next) and note *"M more sub-threshold patterns logged but not surfaced."* [PARTNER_NAME] can ask *"show me the rest"* and get them.

**Patterns [PARTNER_NAME] has skipped 5+ times** stop surfacing — those aren't patterns, those are [PARTNER_NAME]'s preference. Skill quietly retires that pattern from future sweeps.

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

For project-scoped skills (e.g. a partner AI's `~/[ai-name]/.claude/skills/[skill-name]/`),
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
  operational outputs (drafting skills, brief generators, sync skills, etc.).
- **Don't re-edit a SKILL.md** the wrap-up doesn't own. If the SKILL.md was
  already updated during the session, note it in action_taken and move on.

## Tools-cache companion file (new tools that emerged during the session)

If a new CLI / MCP / API was used during the session that isn't already in
`vault/tools.md`, the wrap-up sweep handles it in two parts:

1. **Inventory entry** — add a row to `vault/tools.md` under the right section
   (CLIs / MCP servers / APIs direct). Use the standard entry format:
   - Installed date
   - Path
   - Auth
   - What [AI_NAME] uses it for (1-2 lines, based on actual session usage)
   - Common commands (2-5 examples [PARTNER_NAME] actually ran)
   - Failure modes (if any surfaced this session)

2. **Compressed reference** — also create `vault/tools/[tool-name].md` with
   the compressed-docs template (see `vault/tools/README.md` for the shape).
   Populate the "commands [PARTNER_NAME] actually uses" section from this
   session's usage. Leave failure-modes empty unless something surfaced
   today.

Surface both in the sweep:

```
New tool detected — used [tool-name] this session.

Drafting:
- vault/tools.md row (inventory entry)
- vault/tools/[tool-name].md (compressed reference)

[show both drafts]

Approve / Edit / Skip?
```

If [PARTNER_NAME] approves, write both. If they approve the row but skip the
compressed file, write just the row + log that the compressed reference is
pending (the wrap-up skill will re-nudge next session the tool is used).

## Smoke test

Run wrap-up at the end of a real session. The output should be:
- Compact (under ~30 lines for a normal day)
- Specific (real file paths, real one-liners, no vague handwaving)
- Approval-gated (no writes until [PARTNER_NAME] confirms)
- Honest about empty days (don't fabricate lessons)

## Skills that should have a learnings.md (audit, not a mandate)

The skills most likely to benefit from a learnings loop, based on output
frequency + how often [PARTNER_NAME] iterates on them:

- **anti-ai-writing** — Cross-cutting rules. Picks up [PARTNER_NAME]'s
  banned-word additions and personal voice rules as they emerge.
- **kick-off** — Edge cases [PARTNER_NAME] encounters during a partial
  re-run of onboarding (e.g. *"don't ask about projects this time, I
  already filed them"*).
- Any high-output skill [PARTNER_NAME] runs frequently (e.g. drafting
  skills, brief generators, sync skills). The pattern: if [PARTNER_NAME]
  iterates on a skill's output more than twice in a week, that skill
  earns a learnings.md.

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

### No Substack nudge — intentional

The wrap-up skill does **not** pitch any specific Substack or community subscription. The kit's free-distribution model means anyone running it could be a non-developer, a Training Club operator, a consultant deploying for a client, or someone forking the kit for a different purpose. Embedding an active subscribe pitch into the install/wrap-up flow would be inappropriate across that range of users.

The builder's Substack (if any) is mentioned **passively only** — in the repo's `README.md` and `STAY_IN_TOUCH.md`. Anyone who wants to know what the builder publishes can read those files. The kit's job is to install and tune the Partner AI cleanly. It is not a promotional vehicle.
