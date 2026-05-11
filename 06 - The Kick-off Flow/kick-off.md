# 06 — The Kick-off Flow

> What your AI does the first time you say "hi." A 15-minute conversation that handles all the setup decisions you shouldn't have to remember.

---

## The problem this solves

You're a creative person with a million things on your plate. You're not going to remember to:

- Verify iCloud Drive is enabled
- Confirm where your AI's folder lives
- Save a token recovery template
- Walk through your brand voice rules
- Set up expectations on what the AI will and won't do

So **the AI does it for you**, on the first conversation, in plain language. You answer a few questions and chat. By the end of 15 minutes you have:

- Infrastructure that survives a laptop crash
- Brand voice rules the AI will enforce
- Clear expectations
- One real task already shipped together
- An AI that's ready to work

---

## What happens, second by second

When you open Claude Code in your AI's folder for the first time and type "Hi":

The AI checks for a hidden file (`.first-run-complete`). It's missing → you're new. The AI takes over the conversation:

> *"Hi [your name]. Before we dive into work, I want to walk you through 5 quick things — none of them technical. Just decisions you should make once and never think about again. Should take ~15 min. Sound good?"*

You say yes (or skip — that's allowed too). Then five sections happen:

### Section A — Infrastructure & safety (3 min)

The AI checks:
1. **Is iCloud Drive on?** It walks you through System Settings if not. Without iCloud, anything you and the AI build together can be lost in a crash. Mandatory.
2. **Where does my folder live?** If you put it at `~/em/` (your home), the AI tells you to drag it into `~/Documents/em/` — that's what iCloud syncs.
3. **Token recovery template.** The AI creates a small `_recovery/env-template.txt` listing what API keys you'll have, without the secret values. Tells you to save the actual secrets in your password manager. New Mac = re-paste from the manager.

### Section B — Brand voice confirmation (5–7 min)

Three quick questions:

1. *"If [your brand] were a person walking into a room, what's the energy?"*
2. *"What's a brand whose copy you'd kill for?"*
3. *"What word or phrase, if I ever wrote it in a draft, would make you immediately reject it?"*

You answer in your own words. The AI captures your answers and bakes them into how it drafts going forward. If you have an Obsidian vault by then, it drafts updates to `Brand/Voice guide.md` for you to paste in.

### Section C — What I won't do (2 min)

The AI sets clear expectations:
- *"I draft, you ship. Never sending emails, posting to Instagram, or publishing on your behalf."*
- *"I won't invent facts. If I don't know something, I'll ask or leave a placeholder."*
- *"Domain-specific bans" — e.g. for [BRAND]/[AI_NAME]: "I never speak to the baby. Always to the mother."*

You hear them once. The AI enforces them silently after.

### Section D — First real task (~4 min)

> *"What's the most annoying admin task you've got right now?"*

Whatever you name — drafting a customer email, summarizing a meeting, captioning a photo, replying to a supplier — the AI does it with you. Real output, not a demo. You see how the working dynamic feels.

### Section E — Going forward (1 min)

Three takeaways:

1. **Talk to me like a colleague, not Google.** Full sentences, full context.
2. **Tell me when something matters.** Brand decisions, customer notes, supplier preferences — say *"add to notes"* and I remember next session.
3. **Tell me when something is recurring.** *"Can we make this a one-button thing?"* turns it into a skill. The system gets sharper every time.

The AI then writes `.first-run-complete`, you're handed off to normal mode, and that conversation never repeats unless you say *"start over"* or *"kick off again."*

---

## What this gives you, by week 2

Without the kick-off:
- iCloud not enabled → factory reset = total loss
- Voice rules unset → drafts feel generic, you re-tune every session
- No expectations → you discover prohibitions by accident, frustrated
- 90 minutes of fumbling spread across 4 sessions

With the kick-off:
- Infrastructure is invisible and protected
- Voice rules are locked in and applied silently
- You know exactly what the AI does and doesn't do
- 15 minutes of warm conversation, done forever

---

## How to skip a section if you want

The AI is allowed to honor "skip this" / "later" / "I don't want to right now." It marks the kick-off complete with notes about what you skipped. You can come back to any skipped section later by saying *"finish onboarding"* or *"let's do the brand voice section now."*

---

## How this gets installed for you

The kick-off skill is part of the canonical partner kit. When someone (the human installer) sets you up, they:

1. Copy a pre-built kit folder onto your Mac
2. Find-replace the AI's name (or ship [AI_NAME]-pre-named for [PARTNER_NAME])
3. Drop it in `~/Documents/`
4. You open Claude Code → kick-off auto-runs

You never see the kit folder structure, the YAML frontmatter, or the SKILL.md instructions. From your side it's: open Claude Code, type "Hi," have a 15-min conversation, you have an AI partner.

---

## See also

- [05 - Setting Up Your Partner AI](../05%20-%20Setting%20Up%20Your%20Partner%20AI/setting-up.md) — the full 12-phase setup
- [07 - Portability and Recovery](../07%20-%20Portability%20and%20Recovery/portability.md) — what the kick-off Section A protects
- [08 - The Learnings Loop](../08%20-%20The%20Learnings%20Loop/learnings-loop.md) — the compounding system that activates after kick-off
