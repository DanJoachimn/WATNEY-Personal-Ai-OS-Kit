# How to Work With [AI_NAME]

*A short manual for [PARTNER_NAME]. Reference it whenever you've forgotten how something works. Your AI also reads this file, so keep it accurate.*

---

## First, the mindset shift

[AI_NAME] is not Google. It's not a search box. It's not Siri.

It's closer to: **a smart, tireless colleague who just joined your team, read everything you handed them, and is waiting for instructions.**

That frame changes how you talk to it. Instead of typing three keywords, you write a full sentence. Instead of asking "what's X?" you say "help me think through X for this client." The more context you give it, the better the answer. Always.

---

## How to talk to [AI_NAME]

### Start every conversation with context

Bad: *"Draft an email."*
Better: *"Draft a short email to my client Lisa at Studio Halo letting her know the logo options will be ready Thursday instead of Wednesday. Warm but professional. Not apologetic."*

The better version takes 20 seconds to type. The answer is 10x more useful.

### Say the tone you want

Bad: *"Write me a LinkedIn post."*
Better: *"Write me a LinkedIn post about the new project. Short, dry, no emojis, no 'excited to announce.' Sound like me when I'm slightly tired."*

[AI_NAME] can sound many ways. Tell it which one.

### Ask for options when you're unsure

*"Give me three different versions, each with a different angle: one funny, one sincere, one short and brutal."*

Picking between three is easier than editing one. Use this constantly.

### Push back when the answer is wrong

[AI_NAME] doesn't have ego. If a draft is off, say so and explain why. It adjusts.

*"This is too corporate. Try again. Sound like a human being who's actually met this client."*

---

## What [AI_NAME] can do

### Drafting

Emails, LinkedIn posts, newsletters, proposals, responses, captions, briefs, meeting summaries. Give context, give tone, get a draft.

### Research

Ask a question, get a researched answer with sources. Example:

*"What are three independent Copenhagen studios that do branding for restaurants? Give me their websites and what makes each one different."*

It will search the web and report back. Ask follow-ups.

### Thinking through decisions

Sometimes you don't need a deliverable — you need a sparring partner. Try:

*"I'm trying to decide whether to take on this client. Ask me five sharp questions before I commit."*

### Turning mess into order

Hand it a messy transcript, a long email thread, a dump of raw thoughts — ask it to summarise, extract action items, or reformat.

*"Here's a transcript from yesterday's call. Pull the three decisions we made and the five things I said I'd do."*

### Remembering things for you

If you tell it something important — a preference, a decision, a new client's quirk — ask it to save it:

*"Add to notes.md: Lisa at Studio Halo hates the word 'synergy.' Never use it in her drafts."*

Next session, it'll remember. That's how you build a colleague who gets you.

---

## What [AI_NAME] can't do (yet)

- **Remember yesterday automatically.** Each new conversation starts fresh unless you've written things down in `notes.md`. Not a bug — it's how AIs work today.
- **Send emails on its own.** It can draft. You send. (This changes in a future setup if you want.)
- **Make phone calls or show up to meetings.** Obviously. But it can prep you for both.
- **Know things that happened in the last few hours.** Its knowledge about the world runs on a slight lag. For breaking news, it'll search.

---

## Five prompts to try in your first week

Steal these. Paste them in. Adapt.

### 1. The morning standup

> *"Good morning [AI_NAME]. Today is [day]. I've got [list what's on your plate]. What would you tackle first if you were me, and what am I probably forgetting?"*

### 2. The draft-and-tear-down

> *"Draft a [email/post/update] about [topic]. Then, in a separate section, tell me what's weak about your own draft and how you'd rewrite it."*

### 3. The brain dump cleanup

> *"Here are my raw thoughts about [project]. Read them, find the three strongest ideas, and toss the rest. [paste]"*

### 4. The research scout

> *"Find me three examples of [thing] that I could learn from. For each one, give me the URL, one sentence on what it is, and one sentence on why it's interesting."*

### 5. The end-of-day close-out

> *"End-of-day check-in. I did [X, Y, Z]. What should I put on tomorrow's list, and is there anything I said I'd follow up on that I haven't?"*

---

## When something feels off

Tell [AI_NAME]. Exactly:

> *"[AI_NAME], something feels wrong. [Describe what's happening.] Let's troubleshoot."*

It can read its own files, check its own setup, and walk you through fixes in plain language. Most issues resolve in one or two back-and-forths.

If it genuinely can't help: **ping the human who set you up.** That's the escape hatch.

---

## Where your files live + recovering [AI_NAME] on a new Mac

[AI_NAME] is just a folder of text files. As long as those files are safe, [AI_NAME] is recoverable on any Mac in ~15 minutes.

**Where to keep the folder:** `~/[ai-name]/`

This matters because **`~/Documents/` syncs to iCloud Drive automatically** (if iCloud Drive is on in System Settings → Apple ID → iCloud). Anything inside iCloud-synced folders is backed up to your Apple ID, replicated across every Mac you sign into, and recoverable after a factory reset.

**What's inside [AI_NAME]'s folder (so you know what you're protecting):**

- `CLAUDE.md` — [AI_NAME]'s identity & voice rules
- `USER_MANUAL.md` — this file
- `notes.md` — long-term memory (decisions, customers, suppliers, brand notes)
- `.claude/agents/` — subagents
- `.claude/skills/` — skills you build over time, plus their `learnings.md` files
- `drafts/`, `inbox/` — working files

**API keys exception:** [AI_NAME]'s tokens for OpenAI, ElevenLabs, Telegram (when you set those up) live at `~/.config/[ai-name]/.env` — NOT inside the iCloud-synced folder. To protect them, keep a copy at `~/[ai-name]/_recovery/env-template.txt` (without the actual secret values — just the structure). On a new Mac, you re-paste the secrets from your password manager / where you originally saved them.

### Recovering [AI_NAME] on a new (or reset) Mac

1. **Sign in to iCloud** with your Apple ID. Wait for `~/Documents/` to fully sync (~5–15 min).
2. **Install Claude Code Desktop** from claude.com/code.
3. **Install Command Line Developer Tools** when macOS prompts (or open Terminal and type `xcode-select --install`).
4. **Open Claude Code** → choose "Open folder" → navigate to `~/[ai-name]/`.
5. **Re-paste your API keys** into `~/.config/[ai-name]/.env` (using the recovery template + your saved secrets).
6. **Type "Hi [AI_NAME]"** in chat. They reply in character with full memory of who they are, who you are, and what you've built together.

That's it. Same [AI_NAME]. Same notes. Same voice rules. Same skills. Same learnings. Nothing lost.

### Belt-and-suspenders (optional)

Turn on **Time Machine** with an external drive. Time Machine backs up everything (including hidden config dirs like `~/.config/[ai-name]/`). Plug the drive in once a week.

iCloud + Time Machine = effectively impossible to lose [AI_NAME].

## Making [AI_NAME] yours over time

After a few weeks, you'll notice patterns. [AI_NAME] does some things brilliantly and some things in a way that grates. That's the signal to edit your `CLAUDE.md`:

- Tone isn't quite right? Rewrite the voice section.
- Missing a skill you keep wanting? Add it to "How you help."
- Doing something you don't want? Add a line to "Things to never do."

Your AI is a living draft. Treat it like one. Every 2–3 weeks, re-read `CLAUDE.md`, tune one thing, save. It gets sharper every time.

---

## The one-liner that makes this work

**Talk to [AI_NAME] like a colleague, not a machine.**

Full sentences. Real context. Actual feedback. Take it seriously and it takes you seriously back.

---

*This manual lives in `~/[ai-name]/USER_MANUAL.md`. Update it when you discover something worth teaching a future version of yourself.*
