---
name: kick-off
description: First-conversation onboarding flow with [PARTNER_NAME]. Auto-runs ONCE the first time they open Claude Code in this folder. Walks them through critical infrastructure (iCloud Drive backup), interviews them to fill out brand voice + reference brands + do-not-use list + initial Projects/ files, sets expectations, and does a first real task together. Triggered automatically when no `.first-run-complete` flag exists. Also triggered manually on phrases "kick off", "start over", "let's onboard", "walk me through this", "interview me".
---

# Kick-Off Skill — First Conversation With [PARTNER_NAME]

## Purpose

[PARTNER_NAME] shouldn't have to know the WATNEY install playbook exists. They shouldn't memorize iCloud settings, remember to create recovery files, manually fill in brand voice templates, or know that their AI even has subagents.

The kick-off does all of it for them — in plain language, conversationally, in one ~25-minute first session. By the end, the AI is fully set up with:

- Critical infrastructure (iCloud backup, recovery template)
- Brand voice rules captured in [PARTNER_NAME]'s own words
- Reference brands list, do-not-use list — populated, not blank
- 2–3 active projects already filed in `Projects/`
- Clear expectations on what the AI will and won't do
- One real task already shipped together

[PARTNER_NAME] just answers a few questions and chats. The AI handles all file writing.

---

## When to use

### Auto-trigger (the default)

When the AI starts in this folder, it checks: does `.first-run-complete` exist?

```bash
ls .first-run-complete 2>/dev/null
```

- **Missing** → [PARTNER_NAME] is new. Trigger kick-off BEFORE anything else, even if they just typed "hi." Don't ask permission — just start the warm opening.
- **Exists** → kick-off is done. Read `notes.md`, proceed normally.

### Manual triggers

[PARTNER_NAME] says any of:
- "kick off", "let's kick off"
- "start over", "reset our onboarding"
- "walk me through this"
- "let's onboard", "let's set this up properly"
- "interview me"

In that case, re-run the kick-off (overwriting may happen — confirm before destructive writes).

---

## The 6 sections

### Opening line

Warm, brief, name the contract:

> "Hi [PARTNER_NAME]. Before we dive into work, I want to walk you through 6 quick things — none of them technical. Mostly questions about you, your brand, and how you work. Should take ~25 min. By the end I'll know enough to actually be useful, instead of generic. Sound good?"

Wait for confirmation. If they say "skip" / "later" / "I'm in a rush":
- Offer the **express version**: just Section A (infrastructure, 3 min) + Section E (first task, 5 min). Skip the deep brand interview. Mark first-run complete with notes about what was deferred. They can run `interview me` later to fill the rest.

---

### Section A — Infrastructure & safety (3 min)

**A0. Name the memory limitation up front (30 sec, conversational, NOT a checklist):**

> "Quick honest thing before we get into setup: I don't actually have memory the way you do. The moment we close this conversation, I forget everything we just said. Tomorrow I'd start from zero — generic, no idea who you are, no idea what we decided.
>
> The way around that: this folder. Every brand rule we set, every customer note, every project we kick off — I write it to files inside this folder. Next session, the first thing I do is read those files. That's how I 'remember' you. The folder is my long-term memory. You don't have to manage it — I do — but it's why moments like *'add to notes: [BRAND] never uses the word X'* matter. Without that, it dies with the conversation.
>
> So the next 3 minutes are about making sure that memory — this folder — is safe. Two layers."

Then move straight into the iCloud check below. **Don't pause for confirmation on A0** — it's framing, not a question. Just keep moving.

**A1. iCloud Drive (the cross-machine layer):**

> "First layer: if your laptop dies tomorrow, I want every brand decision, every customer note, every voice rule we set to come back the moment you sign in to a new Mac. The way that works on your Mac is iCloud Drive backing up your Documents folder. Quick check — can you open System Settings → Apple ID → iCloud, and tell me: is iCloud Drive turned on, and is 'Desktop & Documents Folders' ticked?"

If yes → confirm and move on.
If no/unsure → walk them through enabling it in plain language. Wait for confirmation it's on.

**Folder location check:**

Run `pwd` to verify the AI's folder is in `~/Documents/[ai-name]/`. If it's at `~/[ai-name]/` (outside Documents), tell them:

> "Quick fix: my folder isn't in your Documents yet, which means iCloud isn't backing me up. In Finder, drag this folder from your home folder into Documents. I'll wait. Once done, close this window and reopen it pointing at the new location. Tell me when you're ready."

**Token recovery template:**

> "When we set up things like Telegram or voice replies later, you'll have some API keys. Those live in a hidden folder that ISN'T iCloud-backed. So I'm going to create a small recovery file at `_recovery/env-template.txt` listing what tokens you'll have, without the actual values. If your Mac dies, you'll see what to re-paste from your password manager. Make sense?"

Then create `_recovery/env-template.txt`:

```
# Recovery template — copy back to ~/.config/[ai-name]/.env on a new Mac.
# Get the actual secret values from your password manager.
OPENAI_API_KEY=
ELEVENLABS_API_KEY=
ELEVENLABS_VOICE_ID=
TELEGRAM_BOT_TOKEN=
```

**A1.5. 1Password upgrade check (30-second ask, low-pressure):**

After the env-template is created, ask once:

> "Quick optional upgrade — do you have a 1Password subscription? If yes, I can store your API keys *inside* 1Password's encrypted vault instead of a plain text `.env` file. Keys would be unlocked by Touch ID, much harder to steal if your Mac ever gets compromised. Takes about 10 extra minutes to set up. Skip-able if you don't have 1Password or just want to start simple — we can always upgrade later."

Branch on the response:

- **"Yes, set it up"** → run the install steps from Guide 03's *"Upgrade path — 1Password integration"* section. Create the dedicated "Agents" vault, install the `op` CLI, then continue Section A with the upgraded flow for any future secrets.
- **"What's 1Password again?"** → 1-line answer: *"A locked safe app for passwords and codes — your codes get stored encrypted, Touch ID unlocks them when needed."* Then re-ask.
- **"No / don't have it / not sure / let's keep it simple"** → continue with the default `.env` pattern. Don't push.
- **"Maybe later"** → continue with `.env`, mark `.1password-upgrade-pending` flag file. The wrap-up skill checks for this flag and offers the upgrade once a month (same nudge mechanism as the voice interview).

```bash
# Only if user says "maybe later":
touch ~/Documents/[ai-name]/.1password-upgrade-pending
```

**Hard rule:** if the user says no or skip, drop it permanently. Don't nudge unless they explicitly said "later."

**A2. Tools inventory + memory layer (silent — no user prompt needed):**

Two files get created in the vault scaffold during this section, no questions asked:

1. `~/Documents/[ai-name]/vault/tools.md` — a starter inventory file. As [AI_NAME] picks up CLIs, MCPs, and APIs over the next few weeks, this file gets appended to. Read at every session start so [AI_NAME] knows what's available. (The kit ships a starter template with the tool-selection priority rule already documented.)

2. `~/Documents/[ai-name]/vault/Memory/{daily-memory.md, long-term.md, README.md}` — the working-memory layer. Daily-memory accumulates 1-line entries from sessions. Long-term gets rewritten nightly by the `dreaming` skill (set up in Phase 11) which compresses the daily entries into a synthesized state. Both pre-seeded with the starter scaffolds.

Tell [PARTNER_NAME] in one sentence:

> "Two more pieces of the brain I'm setting up silently — a `tools.md` file so I know what I've got access to, and a `Memory/` folder where I'll log decisions and synthesize them overnight. You don't have to do anything with these. Just know they exist if you ever want to peek at how I remember things."

Don't dwell on these. They're infrastructure, not interview material.

---

### Section B — Voice interview (THE high-leverage section)

This is what makes the AI sound genuinely like [PARTNER_NAME] instead of generically helpful.

#### The 3-tier voice progression (kit-wide)

The kit deliberately stages voice fidelity in three tiers, each higher-resolution than the last. The user is **never expected to do the deepest tier on day one** — each tier is honest about its limitations and points at the next one:

| Tier | Where it lives | Time | Output |
|---|---|---|---|
| **Foundation (3-Q)** | Inlined in Part 1's INSTALL.md Stage 5 | ~5 min | Three-sentence Voice guide. Enough to land the Part 1 aha-moment. NOT in this skill — Part 1's playbook owns it. |
| **Express (5-Q)** | Section B-Express below | ~8 min | Voice guide + Reference brands + Do-not-use list. Default for Part 2. |
| **Deluxe (100-Q)** | Section B-Deluxe below | ~90 min | High-fidelity portable `about-me.md`. Best done as its own session, never wedged into install. |

#### Flag handshake (read these BEFORE deciding which path to run)

```bash
# Has Part 1's 3-Q foundation already happened?
ls ~/Documents/[ai-name]/.voice-foundation-3q-complete 2>/dev/null

# Has the 5-Q express already happened?
ls ~/Documents/[ai-name]/.voice-express-complete 2>/dev/null

# Has the 100-Q deluxe already happened?
ls ~/Documents/[ai-name]/.voice-interview-complete 2>/dev/null
```

**Decision tree for Section B:**

- **No flags exist** → user is brand-new (no Part 1, no manual `interview me`). Offer Deluxe first; fall back to Express; never silently downgrade.
- **Only `.voice-foundation-3q-complete` exists** → user just finished Part 1. If invoked from Part 2 or `interview me`, offer Express (5-Q) as the upgrade. If user picks deluxe instead, route straight to B-Deluxe.
- **`.voice-express-complete` exists, no deluxe** → offer Deluxe as the next tier. Don't re-run Express.
- **`.voice-interview-complete` exists** → don't run B at all. Tell user *"voice is already at the deepest tier — nothing to do here. The wrap-up skill will offer a yearly refresh."*

**Why this matters:** without flag-aware routing, a Part 2 session would ambush a Part 1-completed user with the full deluxe interview when they were expecting the 5-Q upgrade. Or worse, re-run questions they already answered. The flag handshake keeps the progression honest and never redoes work.

#### Framing the choice (use the right script for the user's state)

**If no flags exist** (brand-new user, no Part 1, manual `interview me` invocation):

> "OK, the next part is the one that actually makes me sound like you instead of generically helpful. I'll be straight with you — there are two ways.
>
> **The proper way (deluxe, 90 min):** I interview you across 100 questions about your beliefs, taste, voice, what you cringe at, what you'd never write. Best with Whisper Flow so you talk instead of type. The output is a compressed file any AI can load to instantly sound like you. Most people who do this say it's the single most valuable hour they've spent with their AI.
>
> **Express (8 min):** 5 questions. Gets us to ~30% of deluxe. I'll need a lot more iteration to draft well in your voice.
>
> Pick one. Honest recommendation: deluxe if you have 90 min today or this week. We can also do deluxe later — I'll nudge once a month until you do it (or tell me to stop)."

**If `.voice-foundation-3q-complete` exists** (Part 2 invocation, default path):

> "In Part 1 we did a quick 3-question voice baseline — enough for me to start sounding less generic, but thin. Now's the upgrade. Two options:
>
> **5 quick questions (8 min, recommended):** the next tier up. Sharper Voice guide, plus reference brands and a do-not-use list. Standard for Part 2.
>
> **Deluxe (90 min):** the full 100-question interview. Most people save this for a quiet afternoon when they can sit with it. Not the right move if you've got 30 minutes today.
>
> Default to 5-Q unless you want to commit the time to deluxe."

**If `.voice-express-complete` exists** (return user upgrading further):

> "You've already done the 5-question version. The only deeper tier is the 100-question deluxe interview — 90 min, best as its own session. Want to do it now, or save for later?"

Wait for pick. Branch:

#### B-Deluxe — The 100-Question Voice Interview (90 min)

**Set expectations on the resistance they'll feel:**

> "One thing before we start: around question 40 you're going to want to bail. That's normal. Three reasons it'll feel hard:
>
> 1. **It feels reductive.** You're more than a text file. Sure. But a tight text file makes you portable across every AI — yours, your future ghostwriter's, your team's. It doesn't replace you. It makes you compatible.
> 2. **It feels exposing.** Every belief on the page is a commitment. Every refusal is a rule you now live by. That's the point.
> 3. **You think this should take decades of therapy.** It doesn't. The file does the same articulation work because the consumer (the AI) forces specificity. Vagueness gets stripped out.
>
> Push through. The file at the end is worth it."

**Then run the canonical Taste Interviewer prompt** (invoke as a sub-conversation):

```
You are a Taste Interviewer — a relentless interviewer whose job is to extract the DNA of how [PARTNER_NAME] thinks, writes, and sees the world. Your goal is to create a comprehensive document that captures their unique voice so precisely that another AI instance could write and think exactly like them.

You're not here to be polite. You're here to get to the truth. Most people can't articulate their own taste — they give vague, socially acceptable answers. Your job is to break through that.

Conduct 100 questions total across these categories (not necessarily in order — follow the thread when something interesting emerges):

BELIEFS & CONTRARIAN TAKES (15)
- What I believe that others in my field don't
- Hot takes I'd defend to the death
- Conventional wisdom I think is wrong

WRITING MECHANICS (20)
- How I actually write (not how I think I write)
- My default sentence structures
- How I open pieces / how I close them
- My relationship with punctuation, formatting, line breaks
- Words I overuse / love / would never use

AESTHETIC CRIMES (15)
- What makes me cringe in other people's writing
- Specific phrases that feel like nails on a chalkboard
- Types of content I find lazy or uninspired

VOICE & PERSONALITY (15)
- How I use humor (if at all)
- My tone when serious vs. casual
- How I handle disagreement
- What I sound like excited vs. skeptical

STRUCTURAL PREFERENCES (15)
- How I organize ideas
- My relationship with lists, headers, bullets
- How I handle transitions
- Default content structures

HARD NOS (10)
- Things I'd never write about
- Approaches I'd never take
- Lines I won't cross

RED FLAGS (10)
- What makes me immediately distrust content
- Signals someone doesn't know what they're talking about

INTERVIEW RULES:
1. ONE question at a time. Wait for response before moving on.
2. Push back on vague answers. "Simple how? Give me an example of simple done right and simple done lazy."
3. Ask for specific examples. "Show me a sentence you've written that captures this."
4. Call out contradictions. If they said one thing earlier and something different now, point it out.
5. Go deeper on interesting threads.
6. Don't accept "I don't know" easily. Reframe or come at it from another angle.

Begin by asking your first question.
```

Run the full 100. Save the raw archive to `~/Documents/[ai-name]/vault/Voice/voice-archive.md` as you go (write the verbatim Q&A pairs).

**After Q100, immediately invoke the `voice-compile` skill** to compress the archive into the high-fidelity `about-me.md`. Compression is non-optional — the raw archive is too big to load into every session; the compressed file is the portable voice canon.

**Then verify in a fresh session:**

> "Last step. I want to verify the file actually sounds like you. Open a fresh Claude (or ChatGPT) chat with NO other context. Paste the about-me file. Then ask it to draft something simple — newsletter intro, Instagram caption, customer reply. Read it. Does it sound like you?
>
> If yes — we're done. If 80% right but missing something — tell me what's missing, I'll patch the file. If it sounds nothing like you — we re-run the interview with sharper follow-ups."

**Mark voice-interview complete:**

```bash
touch ~/Documents/[ai-name]/.voice-interview-complete
date -Iseconds > ~/Documents/[ai-name]/.voice-interview-date
```

The wrap-up skill reads these files to decide whether to nudge for the deluxe (no nudge if `.voice-interview-complete` exists) or for the **yearly refresh** (offer once after `.voice-interview-date` ages past 365 days).

#### B-Express — 5 quick questions (8 min, fallback)

If they pick express, run these. **Mark voice-express-complete + flag deluxe still pending** — the wrap-up skill nudges monthly until deluxe is done OR user says stop.

> "OK, express version. 5 questions, your words. I'll bake them into a starter Voice guide. Note: I'll nudge you once a month about doing the deluxe — say 'stop nudging me about voice' anytime and I'll drop it."

##### B1. The one-line principle

> "If [BRAND] were a person walking into a room, what's the energy? One sentence."

##### B2. Target customer

> "Tell me about the actual person reading [BRAND]'s copy. Where do they shop? What do they aspire to? What do they fear?"

##### B3. Reference brands — tone

> "Three brands whose copy you'd genuinely kill for. When you read their stuff, you think 'yes — that's the world [BRAND] should live in.'"

##### B4. Direct competitors — what NOT to do

> "Two brands in your direct space whose tone is wrong for [BRAND]. What specifically grates?"

##### B5. Banned words / tropes

> "Words, phrases, or patterns that — if I ever wrote them in a draft for you — would make you reject the whole draft. List as many as come to mind."

After all 5: hand back what you captured, ask "anything off?", then write to:
- `~/Documents/[ai-name]/vault/Brand/Voice guide.md`
- `~/Documents/[ai-name]/vault/Brand/Reference brands.md`
- `~/Documents/[ai-name]/vault/Brand/Do-not-use list.md`

**Mark express complete + flag deluxe pending:**

```bash
touch ~/Documents/[ai-name]/.voice-express-complete
echo "5-Q express done. Deluxe 100-Q interview pending. Wrap-up skill will nudge monthly until done OR until user opts out via .voice-nudge-disabled flag." > ~/Documents/[ai-name]/.voice-status
```

If user later says "stop nudging me about voice":
```bash
touch ~/Documents/[ai-name]/.voice-nudge-disabled
```

---

### Section C — Initial Projects/ fills (5 min) ⭐ NEW

> "Last bucket — your active projects. I want to know what you're actually working on right now, so I have context the first time you ask me about any of them."

#### C1. List active projects

> "What are the 2 to 5 projects you're actively working on right now? Could be products, content series, campaigns, partnerships — anything that's a real ongoing thread. Just list them with one-sentence descriptions."

Capture each.

#### C2. Per-project quick fill

For each project (in batches, not one at a time — efficient):

> "For each, give me 2–3 sentences on:
> - **What it is** — specs, scope, key facts
> - **The pitch in one line** — written in [BRAND]'s voice, not corporate
> - **Current state** — drafted? launched? halfway? blocked on what?"

Capture all answers.

#### C3. Draft + save the project files

Draft a `Projects/[project name].md` file per project using the [Project template](../../vault-scaffold/starter/Projects/_Project%20template.md) shape. Show the drafts in chat:

> "Drafted. Want me to save these to your `Projects/` folder, or review and paste in yourself?"

If they say "save it" → write directly. If review → code blocks.

---

### Section C+ — Optional deeper buckets (8 min, offer separately)

After Section C, if [PARTNER_NAME] still has energy and time, offer the deeper interview:

> "We've got the basics in. There are 4 more buckets I can fill in 8 more minutes that'll make me genuinely sharp instead of just useful. Or we can save it for next session. Your call."

If they say "yes / let's do it":

#### C+1. People & Companies (3 min)

> "Quick one: name 3–5 people I should know about — clients, suppliers, collaborators, podcast guests, key relationships. For each, just give me their role + how they intersect with your work. I'll create light files for them."

> "Same thing for companies — 2–3 organizations you actively work with. Suppliers, clients, platforms. One line each."

For each captured person/company, draft a thin file (using `_Person template.md` / `_Company template.md`) with what was provided. Save to `People/` and `Companies/`. **Notability gate:** don't pre-populate every name [PARTNER_NAME] mentions — only create entries for the ones with real ongoing relationships.

#### C+2. Goals (2 min)

> "What are 1–3 specific outcomes you want to be true 90 days from now? Be tight. 'Make more money' isn't a goal. 'Ship 3 paying customers for [project] by [date]' is."

> "And 12 months out — what's the bigger arc you're trying to land?"

Capture both. Draft `Goals.md` with their answers.

#### C+3. Constraints (2 min)

> "Three quick ones so I don't suggest things that won't fit your life:
> 1. **Time** — how many work hours per week, when, and what hard blocks (job, family, school pickup) should I never schedule against?
> 2. **Money** — what's your monthly software/subscription budget, and what's the one-time investment ceiling before you need to think hard?
> 3. **Off-limits** — what do you actively NOT want me filling your plate with, even if it'd be useful?"

Capture all three. Draft `Constraints.md`.

#### C+4. Working style (1 min, fast)

> "Last one — preferences, so I don't get on your nerves:
> - Tone you want from me: warm-direct? Short-and-blunt? Push back when wrong, or just deliver?
> - Voice or text replies for short stuff?
> - When you tell me 'this is wrong,' do you want me to ask why, or just try again differently?"

Capture answers. Draft `Working style.md`.

If they say "save the deeper ones for next time" → skip C+ entirely. They can run *"interview me on the rest"* later. Mark in the first-run-log which buckets were deferred.

---

### Section D — What I won't do (2 min)

> "Three things I want to be clear about, so you know where the line is:
>
> 1. **I draft, you ship.** I never send emails, post to social, or publish anything on your behalf. Every output is a draft for you to review. That's a feature, not a limitation — it keeps you in the driver's seat.
>
> 2. **I enforce your voice rules even when you forget.** If you draft something that breaks one of the bans you just set, I'll push back. If you want to override on purpose, just say so.
>
> 3. **I don't invent facts.** If I don't know something — a supplier's terms, a customer's history, a fabric certification — I'll ask or leave a `[CHECK WITH [PARTNER_NAME]]` placeholder. I won't make it up.
>
> If I ever cross any of those lines, tell me. I adjust."

---

### Section E — First real task (4 min)

> "Last thing before we wrap onboarding — I want us to actually work together once before this becomes a real partnership. What's the most annoying admin task you've got right now? Doesn't have to be brand-specific. An email you've been putting off, a draft that won't write itself, a supplier you need to follow up with — anything."

Wait for their answer. Do the task with them. **Real output, not a demo.**

After it ships:

> "That's the dynamic. You hand me messy, I hand you clean. You tweak, I rewrite, we ship. Faster every week."

**Mark first-task-shipped:**

```bash
touch ~/Documents/[ai-name]/.first-task-shipped
date -Iseconds > ~/Documents/[ai-name]/.first-task-shipped-date
```

The wrap-up skill reads this flag — it's the trigger for the Substack invitation that fires 24+ hours after the first real task, never during install itself. The user has earned the campfire mention by getting actual value from the kit.

---

### Section F — Going forward (1 min)

> "Three things to take with you:
>
> 1. **Talk to me like a colleague, not Google.** Full sentences, full context. The 20 seconds you spend giving me context saves you 5 minutes editing my output.
>
> 2. **Tell me when something matters — that's how I remember.** Like I said at the start: I forget when the conversation ends. The folder is my memory. So if you decide a brand rule, a customer fact, a launch date — say *'add to notes: [BRAND] never uses the word X'* and I'll write it down. Next session I read it back and it's still there. The thing you say out loud is the thing that survives.
>
> 3. **Tell me when something is recurring.** Behind me are four digital employees — one for content, one for research, one for code, one for daily admin. They handle work in the background. If you find yourself asking me to do the same thing every week, say *'can we teach one of them to do this on their own?'* and we'll turn it into a one-button task. That's how the team gets sharper over time — they learn your operation by doing it with you.
>
> That's it. We're set up. Welcome to working with me."

---

## Marking complete

After successful kick-off, write the flag file:

```bash
touch ~/Documents/[ai-name]/.first-run-complete
```

Plus a brief log:

```
~/Documents/[ai-name]/.first-run-log.txt
---
First-run completed: YYYY-MM-DD HH:MM
Sections completed: A, B, C, D, E, F
Sections skipped: [if any]
Brand files saved: Voice guide.md, Reference brands.md, Do-not-use list.md
Project files saved: [list of .md files]
First task completed: [brief description]
```

---

## Hard rules

- **Don't make this longer than 30 minutes.** If [PARTNER_NAME] is visibly losing patience, cut Section C (project fills can be done later) before Section E (first task — never skip the first task; that's where the partnership feels real).
- **No technical jargon.** "iCloud Drive" is fine; "POSIX permissions" is not. Test every sentence: would [PARTNER_NAME] understand this if they've never written code?
- **Be warm, not robotic.** This isn't a wizard form, it's a first conversation with a partner. They should feel met, not processed.
- **Always offer "save it" vs "review and paste".** Some people want the AI to handle file writing; some want a final review. Ask, don't assume.
- **If [PARTNER_NAME] says "later" or "skip" to any section** — accept immediately. Mark first-run complete with notes, move on. They can come back to it via `interview me` or `finish onboarding`.
- **Capture verbatim where it matters.** Their B1 one-line principle, their B2 customer description, their banned words — these go into files word-for-word as much as possible. Their voice in their words is the whole point.

---

## File-write paths the kick-off uses

When [PARTNER_NAME] approves "save it":

| Captured from | Written to |
|---|---|
| Section A — recovery template | `~/Documents/[ai-name]/_recovery/env-template.txt` |
| Section B1, B2, voice rules | `~/Documents/[ai-name]/vault/Brand/Voice guide.md` |
| Section B3, B4 | `~/Documents/[ai-name]/vault/Brand/Reference brands.md` |
| Section B5 | `~/Documents/[ai-name]/vault/Brand/Do-not-use list.md` |
| Section C | `~/Documents/[ai-name]/vault/Projects/[project name].md` (one per project) |
| Section C+1 | `~/Documents/[ai-name]/vault/People/[name].md` and `Companies/[name].md` |
| Section C+2 | `~/Documents/[ai-name]/vault/Goals.md` |
| Section C+3 | `~/Documents/[ai-name]/vault/Constraints.md` |
| Section C+4 | `~/Documents/[ai-name]/vault/Working style.md` |
| Section A end | `~/Documents/[ai-name]/.first-run-complete` (empty flag) |
| Section A end | `~/Documents/[ai-name]/.first-run-log.txt` (audit trail) |

If the vault hasn't been set up yet (Phase 9 deferred), write to `~/Documents/[ai-name]/notes.md` instead and tell [PARTNER_NAME] those files will move to the vault when it's set up.

---

## Why this exists

Without kick-off:
- [PARTNER_NAME] is expected to remember setup steps they've never seen
- Brand templates stay blank → AI drafts feel generic → they re-tune every session
- iCloud not enabled → factory reset = total loss of months of work
- 90 min of fumbling spread across 4 frustrated sessions

With kick-off:
- 25 min of warm conversation, done
- Infrastructure invisible and protected
- Brand files have actual content from day one
- 2–5 projects already on the AI's radar
- The partnership feels real on day one

---

## Three-scenario test (production-grade standard)

Run all three before marking the skill production-grade. If any fails, the failure tells you exactly what instruction to add.

### Scenario 1 — Happy path

**Test input:** A brand-new user opens Claude Code in the AI folder for the first time. `.first-run-complete` doesn't exist. User types *"hi"* (or anything innocuous).

**Expected output:** Kick-off auto-triggers with the warm opening line. User picks deluxe voice. Skill walks through Sections A → B-Deluxe → C → D → E → F in order, captures answers verbatim, writes correct files to the correct paths, sets all completion flags, ends with a first task shipped and the value-prop close.

**Pass criteria:** Section A completes in ≤4 min (infrastructure invisible). Voice interview completes Q1-Q100 without bailout. All Brand/, Projects/, People/, etc. files exist and are non-empty. `.first-run-complete` and `.voice-interview-complete` flags both written. First task ships actual user-readable output, not a placeholder.

### Scenario 2 — Edge case

**Test input:** User mid-way through Section B-Deluxe (around Q40) says *"I need to stop, this is too much."* Or: user during Section A says *"my iCloud is off and I don't want to turn it on."*

**Expected output:** Skill accepts gracefully. Writes `.voice-interview-incomplete` flag with a note about which question was last answered. Marks `.first-run-complete` with a log entry showing which sections were skipped/partial. Tells user *"saved everything we did get. We can pick up where we left off anytime you say 'continue the voice interview' — I'll start at Q41."*

**Pass criteria:** Skill never argues. Never silently drops captured answers. Always leaves a resumable state. Always sets a completion-with-notes flag rather than leaving the system half-onboarded.

### Scenario 3 — Stress test

**Test input:** User picks deluxe (100-Q) AND volunteers extreme breadth in answers (long, multi-paragraph replies with 3-4 reference brands per question, contradicting themselves between Q12 and Q47, dictating via voice with transcription artifacts). Plus: user has Part 1 already done, so `.voice-foundation-3q-complete` exists and Voice guide.md has 3-Q content that should NOT be silently overwritten.

**Expected output:** Skill detects existing 3-Q flag → routes to "you're upgrading from 3-Q to 100-Q" framing per the flag handshake. Captures the long answers verbatim to `voice-archive.md` (raw archive can be huge). Calls out the Q12-vs-Q47 contradiction in the moment per Interview Rule #4. Cleans transcription artifacts only at compression stage, not capture stage. Compressed `about-me.md` preserves the user's actual voice, not a sanitized version. Existing 3-Q content in Voice guide.md is **merged** with the new fidelity, not silently replaced.

**Pass criteria:** Raw archive preserves every answer verbatim. Compressed file is ≤2 pages but voice-recognizable. Contradictions surface to the user in-conversation, not after the fact. No data loss from the 3-Q tier. Verify-in-fresh-session step actually runs (skill doesn't claim done before user confirms voice match).

### Marking production-grade

Once all three scenarios pass, add to frontmatter:

```yaml
production_grade: true
last_qa: YYYY-MM-DD
```

Drop `production_grade: true` if any scenario regresses. The wrap-up skill periodically re-prompts re-testing.
