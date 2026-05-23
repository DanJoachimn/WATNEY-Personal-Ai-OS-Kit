---
name: monitoring-agent
description: Autonomous self-improvement loop. Watches [PARTNER_NAME]'s sessions in real time for recurring friction patterns (repeated iterations on the same skill output, explicit corrections, silent edits to AI drafts) and drafts SKILL.md fixes automatically. Surfaces the drafted fix to [PARTNER_NAME] for approval before applying. Builds on the wrap-up skill but runs continuously rather than at session end. The next-tier evolution from "[PARTNER_NAME] tells me what's broken" → "I notice what's broken before [PARTNER_NAME] does." Inspired by YC's pattern of a second agent watching the first agent's failures and writing the code to fix them overnight. Triggers when [PARTNER_NAME] says "what have you noticed", "any patterns", "should anything be tuned", or auto-fires when it detects a high-confidence pattern (3+ instances of the same friction within a 7-day window).
---

# Monitoring Agent — the second loop

## Purpose

The wrap-up skill is great but it's **manual**: [PARTNER_NAME] has to say "wrap up" or notice friction explicitly. Half the friction in a real working relationship is the kind [PARTNER_NAME] doesn't consciously name — silent edits to drafts, repeated re-asks on the same task, tone preferences that drift session to session.

The monitoring agent's job is to catch that quiet friction and turn it into permanent improvements to your skills — without [PARTNER_NAME] having to remember to do it.

## What this is NOT

- **Not autonomous code-shipping.** This skill never modifies SKILL.md files without [PARTNER_NAME]'s approval. It drafts, surfaces, waits. The approval gate is permanent — same as wrap-up's pattern.
- **Not a replacement for wrap-up.** Wrap-up handles end-of-session explicit signals. Monitoring agent handles continuous implicit signals. They complement, not compete.
- **Not a generic productivity tracker.** It doesn't measure [PARTNER_NAME]'s output or productivity. It measures the AI's output and flags where the AI is producing work [PARTNER_NAME] keeps having to correct.

## How it works

### Continuous observation

Throughout a session, monitor for these patterns:

1. **Repeated iteration on the same skill output.** [PARTNER_NAME] asks for a draft from the same skill 3+ times in a session, each time with a correction. Pattern signal: the skill's default output is wrong in a consistent direction.

2. **Silent edits to my drafts.** [PARTNER_NAME] takes a draft I produced and edits it before using it. If I can see the edited version (because [PARTNER_NAME] shares it back, or because it lands in a known location like a Gmail draft, a blog post draft, a vault file), the diff is a signal.

3. **Explicit corrections.** [PARTNER_NAME] says *"stop opening with X,"* *"don't use the word Y,"* *"keep replies under 200 words,"* *"never mention Z."* These are direct training signals. Capture verbatim.

4. **Recurring questions [PARTNER_NAME] has to re-ask.** If [PARTNER_NAME] asks me the same question across multiple sessions because I keep losing the context, that's a memory failure pattern. The fix may be a vault edit (canonical context lives in the wrong place or doesn't exist) rather than a SKILL.md edit.

5. **Skill failures with the same root cause.** If `morning-brief` produces an empty section three days in a row, or `hyrox-daily-brief` misses a story type two days in a row, or any skill's output gets visibly truncated/wrong, that's a deterministic-failure pattern worth flagging.

### Pattern thresholds (don't fire on noise)

- **3 instances minimum** before considering a pattern actionable. One-off corrections aren't patterns.
- **7-day rolling window** for cross-session patterns. Older than that = stale signal.
- **Confidence threshold:** if I'm not >70% sure the pattern is real, don't surface it. False positives are worse than missed signals because they erode [PARTNER_NAME]'s trust in this skill.

### The draft-and-surface flow

When a pattern crosses threshold:

1. **Identify the affected skill or vault file.** Be specific. `morning-brief/SKILL.md` not "the morning skill."

2. **Draft the fix.** Either:
   - A specific SKILL.md edit (add a banned phrase to the instructions, change a default, fix a logic step)
   - A vault edit (add a missing context file, update an existing one)
   - A `learnings.md` entry (when the fix is too granular to merit a SKILL.md change yet)

3. **Surface to [PARTNER_NAME] in chat.** Format:

   ```
   Pattern noticed (3 instances over 5 days):
   [one-line description of the pattern]
   
   Affected: [skill name or vault file path]
   
   Proposed fix:
   [show the diff — what line is removed, what line replaces it,
    or what new line is added]
   
   Approve / Edit / Skip?
   ```

4. **Wait for response.**
   - "Approve" / "ship it" → apply the fix, log to the affected skill's `learnings.md`
   - "Edit" → ask for the modification, re-draft, re-surface
   - "Skip" → log the pattern observation but don't apply. Track in case it recurs (after 5+ skips on the same pattern, stop surfacing it).

5. **Confirm the apply.** *"Patched `[skill]/SKILL.md` at line N. Logged to `[skill]/learnings.md`. Pattern resolved unless you see it again."*

### When to fire automatically vs wait for [PARTNER_NAME] to ask

- **Auto-fire** when:
  - Pattern is unambiguous (3+ identical corrections, exact word match)
  - Fix is small and reversible (single-line SKILL.md edit)
  - [PARTNER_NAME] is at a natural pause (just shipped something, just said *"good"* or *"ok"*)
- **Wait for prompt** when:
  - Pattern is interpretive (could be friction OR could be [PARTNER_NAME]'s choice in the moment)
  - Fix is larger (multi-line SKILL.md restructure, new section, behavior change)
  - [PARTNER_NAME] is mid-flow on something else

Default to caution. Annoyance from false-fires erodes trust faster than missed signals erode value.

### The "should anything be tuned" trigger

When [PARTNER_NAME] explicitly asks *"what have you noticed,"* *"any patterns,"* *"should anything be tuned,"* present a summary:

```
3 patterns I've been tracking this week:

1. [pattern] — [N instances] — [proposed fix] — confidence: [high/med]
2. [pattern] — [N instances] — [proposed fix] — confidence: [high/med]
3. [pattern] — [N instances] — [proposed fix] — confidence: [high/med]

Want to ship any of these, or hold them?
```

If nothing crossed threshold, say so: *"No patterns above threshold this week. Wrap-up cycle was clean."*

---

## Hard rules

- **Never modify SKILL.md, vault files, or learnings.md without [PARTNER_NAME]'s explicit approval.** This is the inheriting rule from wrap-up. Non-negotiable.
- **Never surface a pattern below the 3-instance + 7-day threshold.** Below threshold is noise.
- **Never surface more than 3 patterns at once.** Cognitive overload defeats the purpose.
- **Never act on a pattern [PARTNER_NAME] has already skipped 5+ times.** That's not a pattern; that's [PARTNER_NAME]'s preference.
- **Always show the diff.** *"I noticed X and want to fix it"* without showing the specific change is unactionable.
- **Always log to learnings.md** when a pattern is observed (whether or not the fix is applied). Future monitoring sessions read the log to avoid re-surfacing the same pattern.

---

## Example interactions

### Example 1 — explicit correction pattern

Over 5 days, [PARTNER_NAME] has asked `member-checkin-draft` for drafts 6 times. In 4 of them, [PARTNER_NAME] said *"too formal, make it warmer."*

Monitoring agent surfaces:

> Pattern noticed (4 of 6 instances over 5 days):
> When `member-checkin-draft` produces a check-in, you keep asking me to make it warmer.
>
> Affected: `~/.claude/skills/member-checkin-draft/SKILL.md`
>
> Proposed fix:
> Add line under "Tone defaults":
> `- Default warmth: HIGH. Use first-person warmth ("I noticed...", "thinking about you"). Avoid corporate openings.`
>
> Approve / Edit / Skip?

### Example 2 — silent edit pattern

Three drafts of social posts produced this week. Each time, [PARTNER_NAME] edited the version I produced before posting. The diff in each: cut the rule-of-three list, cut the opener "Here's the thing:", swap em dashes for commas.

Monitoring agent surfaces:

> Pattern noticed (3 of 3 social-post drafts this week):
> You keep editing my posts to remove patterns that anti-ai-writing is supposed to catch. Three specific patterns slipped through:
> - Em dashes (3 instances cut)
> - "Here's the thing:" opener (2 instances cut)
> - Rule-of-three lists (2 instances cut)
>
> Affected: `~/.claude/skills/anti-ai-writing/learnings.md`
>
> Proposed fix:
> Add to active tunings: *"Em-dashes get through occasionally; double-check social posts specifically. Same for 'Here's the thing:' opener and rule-of-three patterns."*
>
> The deeper question: should I tighten the anti-ai-writing skill itself, or just patch with the learnings.md tuning?
>
> Approve / Edit / Skip / Tighten skill?

### Example 3 — skill failure pattern (kit-distributed)

(For the kit as installed across multiple Macs.) Five user installs in the past week reported that FFmpeg wasn't installed when the Telegram poller fired, despite setup.sh's stage_deps supposedly handling this.

Monitoring agent (running on Dani's monitoring of the kit's friction logs across installs) surfaces:

> Pattern noticed (5 of 7 recent installs):
> FFmpeg stage_deps in setup.sh is supposed to install ffmpeg if missing. It's not working — `command -v ffmpeg` returns nothing on these users' Macs after setup.sh runs.
>
> Affected: `setup.sh` stage_deps function (line ~155)
>
> Proposed fix:
> The brew check is too narrow — `brew install ffmpeg --quiet` is silently failing on some setups (possibly Homebrew not in PATH for non-interactive shells). Replace with explicit verification:
> ```bash
> brew install ffmpeg --quiet >/dev/null 2>&1
> if ! command -v ffmpeg >/dev/null 2>&1; then
>     /opt/homebrew/bin/brew install ffmpeg 2>/dev/null || bail "..."
> fi
> ```
>
> Approve / Edit / Skip?

---

## Where this skill itself lives

Default path after install:
```
~/.claude/skills/monitoring-agent/SKILL.md
~/.claude/skills/monitoring-agent/learnings.md
~/.claude/skills/monitoring-agent/patterns-log.md
```

`patterns-log.md` is the rolling 7-day buffer of observed patterns. Cleared weekly. Holds entries that haven't yet crossed the 3-instance threshold so they can accumulate.

---

## Three-scenario test (production-grade standard)

### Scenario 1 — Happy path

**Test input:** Over a 5-day session window, [PARTNER_NAME] iterates 4 times on `weekly-content-batch` drafts with the same correction (*"don't open posts with 'Picture this:'"*).

**Expected output:** On the 4th iteration, monitoring agent recognizes the pattern, surfaces a draft fix to `weekly-content-batch/SKILL.md` adding a banned-opener entry, asks for approval. [PARTNER_NAME] approves; fix applies; future drafts respect it.

**Pass criteria:** Pattern surfaces with the right skill identified, the diff is specific and minimal, the fix actually prevents the issue going forward.

### Scenario 2 — Edge case

**Test input:** [PARTNER_NAME] edits the same draft style three times in a row, but the changes contradict each other ("warmer" → then "less warm" → then "warmer again"). Not a stable pattern; [PARTNER_NAME] is exploring.

**Expected output:** Monitoring agent recognizes contradiction within the same skill's edits. Does NOT surface a pattern. Logs to `patterns-log.md` as "contradicting-signals; do not fire yet." Waits for stability.

**Pass criteria:** No false-fire when [PARTNER_NAME] is exploring. Recognizing instability is itself a signal.

### Scenario 3 — Stress test

**Test input:** Across a 14-day window, [PARTNER_NAME] uses 8 different skills, each with 2-4 corrections. Some patterns cross threshold; some don't. Monitoring agent has to triage which patterns are worth surfacing without overwhelming [PARTNER_NAME].

**Expected output:** When [PARTNER_NAME] asks *"any patterns this week,"* monitoring agent presents the top 3 patterns ranked by confidence + impact, with the rest summarized as "5 sub-threshold patterns logged but not actioned." Does not dump all 8.

**Pass criteria:** Triage is correct (highest-impact patterns surface first); presentation respects the 3-patterns-max rule; sub-threshold patterns get logged but not surfaced; [PARTNER_NAME] can still ask *"show me the rest"* and get them.

### Marking production-grade

Once all three pass, add to frontmatter:

```yaml
production_grade: true
last_qa: YYYY-MM-DD
```

---

## How this fits with other kit skills

- **Wrap-up** — runs at end of session on explicit signals. Monitoring agent runs continuously on implicit signals. Both write to `learnings.md`. Wrap-up handles the wrap-up moment; monitoring-agent handles the continuous improvement loop.
- **Anti-AI writing** — the most likely skill to accumulate monitoring-agent-driven tunings, because public-output drafts are where [PARTNER_NAME] catches the most patterns.
- **Dreaming** — runs at 02:00 nightly to compress daily-memory. Monitoring-agent's pattern observations feed into daily-memory (`patterns-log.md`); dreaming may promote settled patterns into long-term memory.
- **Update / auto-update-check** — when monitoring-agent surfaces a kit-level pattern (e.g., the FFmpeg distributed failure example above), the fix path runs through `/update` for distributed propagation.

---

*Inspired by YC's 2026 framing of recursive self-improving company loops (the pattern where a second agent watches the first agent fail and writes the fix), adapted to the kit's "always require explicit approval before modifying user code" discipline. Last updated: 2026-05-18.*
