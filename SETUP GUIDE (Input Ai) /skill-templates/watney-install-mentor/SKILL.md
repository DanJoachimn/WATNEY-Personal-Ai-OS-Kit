---
name: watney-install-mentor
description: Sibling to pacer-install-mentor. Fires at the end of each install phase during a Partner AI Kit (personal) install — the variant for individuals (creators, consultants, solo founders, professionals) installing a personal AI companion on their own Mac. Default companion name is PACER per the naming convention; users typically rename at first-run (Dani's instance is Watney; Julie's is likely her own choice). The skill itself stays named "watney-install-mentor" because the (personal) flavor is the lineage descendant of Watney's original architecture. Same three-section block as PACER's mentor — what just happened, why it matters for THEM, when they'll use it. Zero quizzes. Zero friction. Read or skip. Triggered automatically at every phase boundary in the (personal) kick-off, OR manually with "explain what we just installed" / "what did that do" / "value prop on [feature]".
---

# watney-install-mentor

## Purpose

Charlie Warren (YC): *"The humans in the loop also need to enjoy the software. They are your users."*

The (personal) variant of the Partner AI Kit gives an individual — a creator, a consultant, a solo founder, a professional juggling business and life — a personal AI companion that runs on their own Mac. The kit installs in roughly an hour. By the end, they have a working orchestrator, four subagents, a Telegram bridge, voice I/O, and the start of a skill library.

What they often don't have: an understanding of what they just got. They know they installed something. They know it cost an hour. They can't yet explain it to themselves, let alone to a friend asking "what's that AI thing you set up?"

This skill closes that gap without adding friction. At the end of each install phase, the new owner gets a tight three-line block:

1. **What just happened** — plain English, what got wired
2. **Why this matters for you** — value prop, anchored in their specific context (their craft, their pain points, the way their week actually runs)
3. **You'll use this when** — one or two concrete situations where they'll touch this feature

That's it. No quiz. No "do you understand?" beat. No "click here to continue." The owner reads or skips. Either way, the install advances.

If they read, they leave the kick-off able to explain their new companion to a friend. If they skip, they still have the working install. The skill is invisible upside.

## When to Use

**Automatic triggers:** PACER (personal) kick-off invokes this skill at every phase boundary. No human decision required.

**Manual triggers:**
- "Explain what we just installed"
- "What did that do?"
- "Value prop on [feature]"
- "Why do I have this?"
- Any time the owner pauses or looks confused

**Do NOT use when:**
- The owner explicitly says "skip the explanation" or "just install it"
- Mid-phase (during the actual install work) — only at phase boundaries
- For features the owner is already expert on — surface check first

## The mentor pattern

For each install phase, produce a block in this EXACT shape:

```markdown
### 🛠 What just happened
{One sentence. Plain English. No jargon. What got wired or set up. Avoid "we configured the webhook" — use "your Telegram is now wired so you can voice-note your AI from anywhere."}

### ⚡ Why this matters for you
{One sentence. Anchored in their specific context. Use what they shared in the kick-off interview — their work, their friction points, the moments in their week when they wish they had a co-pilot. Make it personal.}

### 🌒 You'll use this when
- {Concrete use case 1 — a moment in their actual week when this feature lights up}
- {Concrete use case 2 — a second, different moment, ideally one they didn't expect}
```

Three sections. Three sentences (plus the bullet list, max two bullets). Total reading time: 15 seconds.

## Quality bar per section

### "What just happened"

- **Plain English.** Non-developer. If a 55-year-old consultant who's never used a webhook reads this, they understand it.
- **Specific.** Don't say "we set up the voice system." Say "your AI can now hear you when you talk to it and reply with a real voice through your phone."
- **Visual when possible.** Use mental imagery. "Pings", "wakes up", "watches", "listens" — concrete verbs.
- **Past tense.** Recap of what just happened, not what will happen.

### "Why this matters for you"

- **Personalized.** Reference the owner by name. Reference what they told you about their work, their week, their friction points.
- **Anchored in their pain.** From the kick-off interview, you know what they complained about wanting AI for. Tie this feature to that.
- **One concrete benefit.** Pick ONE clear benefit and land it. Don't pile up.
- **Mode 2 voice.** No corporate filler. Talk like a friend who installed the same thing last month and wants you to actually use it.

### "You'll use this when"

- **Real moments.** Anchor each use case to a specific weekly moment they'll recognize. "Wednesday 9pm when you're on the couch and have an idea for a newsletter section but don't want to open the laptop."
- **One expected, one unexpected.** First bullet = the obvious use case. Second bullet = a use case they didn't realize this feature covered. The second one is the dopamine hit.
- **Max two bullets.** Don't pad.

## The phase-by-phase template

For the (personal) variant's standard install phases, here are pre-drafted mentor blocks. Tune at install time using the owner's specific context (the name they chose for their AI, their craft, their pain points).

### Phase: Persona / brand voice extraction completed

```
### 🛠 What just happened
{AI_NAME} just spent 20 minutes learning how YOU talk — your phrasing, your tone when you're excited vs. tired, the words you actually use, the ones you'd never use. That voice is saved.

### ⚡ Why this matters for you
Every email, message, caption, and document {AI_NAME} ever drafts for you will sound like YOU wrote it. Not like ChatGPT wrote it. Your audience, your friends, your clients can't tell. They just hear you.

### 🌒 You'll use this when
- The Sunday-night email you owe a client and you're already in bed — voice-note the gist, {AI_NAME} drafts it in your voice, you wake up to a finished email to send
- The LinkedIn post you've had in your head for three days but can't make yourself sit down and write — describe it in 60 seconds, {AI_NAME} returns three drafts in your voice
```

### Phase: Telegram bridge connected

```
### 🛠 What just happened
{AI_NAME} now lives in your Telegram. You can text or send a voice note from anywhere — between meetings, on the school run, in bed — and {AI_NAME} hears you and replies.

### ⚡ Why this matters for you
The window of "I have a thought I want to act on but I'm not at my laptop" closes. {AI_NAME} works the same whether you're at your desk or three time zones away.

### 🌒 You'll use this when
- Walking the dog at 7am, voice-noting "remind me to follow up with Sarah about the proposal" — {AI_NAME} queues it and pings you at 10am when you're at your desk
- Saturday afternoon, "draft a 200-word newsletter intro for next week" — by the time you check your phone again, three drafts are waiting
```

### Phase: Voice I/O (Whisper in, ElevenLabs out)

```
### 🛠 What just happened
{AI_NAME} can hear you and talk back. Whisper transcribes your voice into text {AI_NAME} can act on. ElevenLabs lets {AI_NAME} reply with a real voice through your phone or your Mac speakers.

### ⚡ Why this matters for you
Talking is faster than typing — for most people about 3× faster — and it works in moments when typing doesn't (driving, cooking, walking). Voice closes the gap between "I had a thought" and "I made it real."

### 🌒 You'll use this when
- Cooking dinner, hands wet, "{AI_NAME}, what's on my calendar tomorrow morning?" — spoken reply through your kitchen speaker
- Mid-walk, you have a sudden idea for a project — voice-note it, by the time you're home it's a structured note with three follow-up questions {AI_NAME} thought of for you
```

### Phase: First four subagents installed (Research / Content / Ops / Developer)

```
### 🛠 What just happened
{AI_NAME} now has four specialist helpers on call. Research goes hunting for information online. Content drafts in your voice. Ops handles inbox/calendar coordination. Developer touches code and files. {AI_NAME} routes the work to whichever one fits.

### ⚡ Why this matters for you
You stop having one assistant who's mediocre at everything. You get four specialists who are sharp at their lane, with one orchestrator (the named {AI_NAME}) deciding which one handles what. The asymmetry is real: one of you, four of them, 24/7 availability.

### 🌒 You'll use this when
- Monday morning, "find me three articles on X topic and draft me a LinkedIn post connecting them" — Research finds, Content drafts, you approve
- Friday afternoon, "triage my unread email from this week" — Ops sorts it into action-needed, waiting-on, reference — you make decisions instead of reading 200 subject lines
```

### Phase: First skill enabled

```
### 🛠 What just happened
{AI_NAME}'s first add-on is live. Skills are like apps for your AI — the base {AI_NAME} works for anything; skills make it sharp for specific recurring jobs. This one is wired for {SPECIFIC_USE_CASE_FROM_KICKOFF}.

### ⚡ Why this matters for you
{AI_NAME} gets stronger every time you (or whoever you got this kit from) builds a new skill. New skills land on your install without you doing anything. Most software stays what it was on day one. {AI_NAME} is what it grows into.

### 🌒 You'll use this when
- Next month, when a new skill ships that matches something you've been doing manually — it shows up on your install ready to use, no install dance required
- Six months from now, when {AI_NAME} has compounded into something you can't imagine working without
```

## Format constraints

- **15 seconds to read max.** If it's longer, cut.
- **No headings beyond the three section markers.** No `####` subsections. No bullet lists inside the "What just happened" or "Why this matters" sections.
- **Bold sparingly.** Maybe one bold phrase per block, and only if it does real work.
- **Light emoji at section starts is fine** (🛠 ⚡ 🌒 are the defaults). Don't carpet-bomb the body.
- **No questions.** Period. Not "make sense?" — not "any questions?" — not anything that asks the owner to do work.
- **No "click here to continue."** The next phase just starts. The mentor block is fire-and-forget.
- **Use the AI's actual name everywhere** ({AI_NAME} placeholder). If they renamed PACER to Pip, Cooper, Maple, Watney — use that name. Their AI has an identity from day one and the mentor block reinforces it.

## What this skill is NOT

- **Not a quiz.** No verification, no "did you understand?" The owner is an adult. Trust them.
- **Not documentation.** Documentation is searchable, deep, complete. This is the just-in-time micro-explanation.
- **Not a tutorial.** A tutorial says "now click here." This says "here's what happened, here's why you care." Past tense, not imperative.
- **Not for re-installs or upgrades.** When a new skill ships to an existing install, the same three-section pattern fires via Telegram as a notification — but that's the upgrade-mentor pattern, not this skill.

## Difference from pacer-install-mentor

| Axis | pacer-install-mentor (training club) | watney-install-mentor (personal) |
|---|---|---|
| Owner archetype | HTC owner — coach + operator + accidental marketer | Creator / consultant / solo founder / professional |
| Pain anchor | Time bleed running a gym; lead response gaps; coach content extraction; member retention | Time bleed running solo work; ideas-without-action friction; voice consistency across channels; the always-on-laptop trap |
| Use case framing | Tuesday 9pm during evening class · Saturday morning lead form | Walking the dog · Sunday night in bed · cooking dinner |
| Default skills mentioned | Wodify webhook, member onboarding, programming generator | Voice I/O, Telegram bridge, four subagents, first skill |
| Voice in examples | "Your gym down the road takes 47 hours to answer" | "The idea that lives in your head for three days because you can't make yourself open the laptop" |

The pattern is identical. The anchoring is different.

## Hybrid Rule compliance

- Reads: kick-off interview answers from the same session, the AI's chosen name, the owner's stated context
- Writes: nothing persistent during the install itself. Mentor blocks output in-line.
- If the owner wants a written record of all the mentor blocks (some do, especially the type-A consultants), save to `~/Desktop/{AI_NAME} install notes.md` — outside any vault, theirs to own and revisit.

## Self-annealing notes

- If owners consistently ask follow-up questions about a specific phase, that phase's mentor block is failing — tune it up.
- If owners explicitly skip the block ("just install it"), that's data: they want even less. Track and shorten.
- If owners ask "wait, what was that thing?" 30 minutes after a phase, the use-cases weren't sticky enough — punch them up.
- The Personal (vs Training Club) audience tends to have MORE varied first-use cases — they're not all running the same business shape. Push the use-case bullets toward universal weekly moments (cooking, walking, bed, commute) rather than role-specific ones.

## Companion skills

- **pacer-install-mentor** — the sibling skill for the (training club) variant. Same pattern, different anchoring.
- **PACER kick-off (personal flavor)** — the parent skill. watney-install-mentor fires at its phase boundaries.
- **anti-ai-writing** — every mentor block runs through these rules before output.

## First real test

The natural first test: Julie's install (the trial in Dani's network). Julie isn't a developer, isn't a gym owner — she's a target archetype for the (personal) variant. Have watney-install-mentor fire at each phase boundary of her install. After the install, ask her one question only: "If a friend asked you tomorrow what you set up today, what would you tell them?" If the answer is fluent and specific, the skill earned its keep. If the answer is hazy, tune the mentor blocks.
