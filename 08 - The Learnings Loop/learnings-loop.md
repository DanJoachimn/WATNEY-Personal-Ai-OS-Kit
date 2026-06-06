# 08 — The Learnings Loop

> The mechanism that makes your AI sharper every week. Without it, every iteration you do today evaporates the moment the conversation resets. With it, lessons compound.

---

## The problem this solves

Every time you tell your AI:

- *"Stop opening with 'excited to announce'"*
- *"Voice notes should stay under a minute"*
- *"Never use the word 'luxury' in [BRAND] copy"*
- *"Shorter please"*
- *"This was perfect — do more like this"*

…the AI adjusts in the moment. The draft gets better. You ship it.

Then the conversation ends. **The next day, the AI starts fresh.** Same mistakes. Same back-and-forth. Same re-tuning.

That's a folder of skills. **A learnings loop turns it into a system.**

---

## How it works

Every operational skill (e.g. `morning-brief`, `wrap-up`, `check-telegram`) gets a `learnings.md` file alongside its instructions. The skill **reads its learnings BEFORE running**. Over months, accumulated tunings shape the skill in ways no generic install of the same skill can match.

### File structure

```
~/Documents/[ai-name]/.claude/skills/morning-brief/
├── SKILL.md          ← the procedure (mostly stable)
├── learnings.md      ← active tunings + history (grows over time)
└── scripts/          ← any deterministic execution code
```

### What `learnings.md` looks like

```markdown
# Learnings — morning-brief

## Active tunings
*(read these, apply them silently — don't recap to the user)*

- voice: never use the words "luxurious / premium / curated". (Set 2026-04-27.)
- length: voice notes <200 words. Hard cap. (Set 2026-04-27.)
- structure: always lead with the most actionable item, not the calendar. (Set 2026-05-02.)

## History

### 2026-04-27 — voice rule tightened from <300 to <200 words
**What happened:** Voice reply ran 75s for a 150-word answer. Felt long.
**The lesson:** Target <1min spoken = ~140wpm × 1min = ~200 words.
**Action taken:** Updated SKILL.md + CLAUDE.md.
```

The skill itself adds **one step at the top of its instructions**:

> *Before doing anything else, read `learnings.md`. If it has Active tunings, integrate them silently. Don't recap to the user — just produce a better output.*

That's the whole loop. The skill reads its own lessons, applies them, produces output already shaped by past feedback. **Zero friction.**

---

## How tunings get logged — the wrap-up skill

You're not going to remember to say *"hey, log this lesson."* So the AI watches for end-of-session signals and offers automatically.

**Triggers it watches for:**

- You say something terminal: *"good", "ship it", "park this", "I'm done", "perfect"*
- You change topics after long focused work
- You go quiet for 15+ minutes after iterating
- A 2+ hour session has produced 2+ skill tunings

**At a natural pause, the AI says:**

> *"Want me to sweep today's learnings before you go? Two skills got tuned — would lock them in for next time. Just say 'ship it' or 'skip.'"*

You say:
- **"Ship it"** → AI proposes per-skill entries, you approve, they get written
- **"Skip"** → no nag, AI drops it, can be done retroactively next session
- *Nothing* → AI mentions once more next natural pause, then stays quiet

**Hard rules:**
- Max 2 offers per session — you'd rather lose a day's learnings than feel nagged
- Never write without your explicit approval
- History is append-only; superseded tunings get marked superseded but don't get deleted

---

## What you actually feel as a user

**Day 1:** AI drafts something off-tone. You say *"shorter and less corporate."* AI adjusts. You ship.

**Day 30:** AI drafts something already short and human-sounding on the first try. You ship without edit. **You don't know why it's better — but it is.**

That's the learnings loop. Invisible from your side, accumulating tunings underneath, showing up as fewer rounds of feedback over time.

---

## The compounding math

A skill without a learnings loop:
- Stays the same forever
- Every session = re-tune from scratch
- Generic outputs that need editing every time

A skill WITH a learnings loop, after 6 months of normal use:
- Has 30–50 active tunings specific to you
- Knows your preferences in ways no other user's same skill knows
- Outputs land on first try most of the time

**That's the difference between "an AI on my Mac" and "my AI."**

---

## How to use it without thinking about it

You literally don't have to do anything except:

1. Iterate normally — say what you like and don't like
2. When the AI offers a wrap-up sweep at end of session, say "ship it"
3. Trust that the skills are getting sharper underneath

That's it. The loop runs itself.

---

## Resetting / editing tunings (if a tuning becomes wrong)

If a tuning was useful in April but is now outdated, just tell the AI:

> *"That 'never use the word luxury' rule is too strict — sometimes I do want to use it. Update the morning-brief learnings."*

The AI will:
1. Read the current `learnings.md`
2. Move the old tuning to History with "Superseded YYYY-MM-DD" note
3. Replace it with a more nuanced rule
4. Confirm in chat

Your wrap-up skill respects history-is-append-only — old tunings don't get deleted, just marked superseded so you can see the evolution if you ever look.

---

## Skills that should have a learnings loop

Not every skill needs one. Good candidates:

- **High-output skills** that you give feedback on regularly (drafting, briefings)
- **Tone-sensitive skills** where your preferences evolve (writing, customer replies)
- **Workflow skills** with edge cases worth remembering (inbox triage, meeting summaries)

Skills that probably don't need one:

- One-shot lookups
- Reflection / journaling commands
- Pure automation that runs without your feedback

When the AI catches a tuning for a skill that doesn't have a `learnings.md` yet, it'll surface: *"This skill doesn't have a learnings file yet — should I create one?"* You say yes/no.

---

## See also

- [05 - Setting Up Your Partner AI](../05%20-%20Setting%20Up%20Your%20Partner%20AI/setting-up.md) — Phase 11B is where the learnings loop gets installed
- [06 - The Kick-off Flow](../06%20-%20The%20Kick-off%20Flow/kick-off.md) — first-run setup that the loop builds on top of
