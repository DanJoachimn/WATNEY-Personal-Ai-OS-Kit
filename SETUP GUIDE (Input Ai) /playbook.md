# Personal AI Setup Plan — The Complete Playbook

> A generic, end-to-end blueprint for setting up a Claude-based Personal AI. Built from real-world deployments of partner AIs. Replace placeholders with the user's specifics. Skip phases marked OPTIONAL until they're earned.

---

## What this gives someone

By the end of the full plan, the user has:

- A named AI partner with a real personality (not a generic chatbot)
- An always-on body running in the background, reachable from their phone
- Voice notes both ways (talk to it, hear it talk back)
- A second brain that remembers across sessions
- Specialist subagents that handle drafting, research, and admin
- Monitoring that pings them within minutes if anything breaks
- A folder of skills that grows organically with their needs

**The honest target:** someone who would otherwise hire a junior assistant for €30k/year gets an AI partner that does ~70% of the same work, available 24/7, on a Claude subscription + ~€20/mo in API fees.

---

## Pre-flight — what you prepare before sitting down

### 1. Their account

- A Claude subscription (Pro tier minimum). If they don't have one yet, that's the first €20.
- An OpenAI API key (for Whisper transcription). Sign up at platform.openai.com. ~€1–5/month at moderate use.
- An ElevenLabs account if they want voice replies. Free tier covers ~10k characters/month; Creator tier is €5/month and unlocks custom voices.

### 2. Their hardware

- A Mac from the last 4–5 years. Anything Apple Silicon ideal.
- ~10GB free disk space for Claude Code + Command Line Tools + Homebrew.
- Wi-Fi that doesn't choke on a 1–2GB download.

### 3. Two questions to ask them before any clicking

Bring them on paper, ask once, write down the answers verbatim:

1. **"If you could hand one person the most annoying admin task in your business, what would it be?"** → tells you the FIRST job their AI will do (keeps the install grounded in real value).
2. **"What's the tone you want? Friendly assistant, sharp colleague, blunt strategist, something else?"** → seed for personality.

These two answers drive 80% of how you tune the CLAUDE.md.

### 4. Pick a name together

This sounds silly but matters. The name carries personality before the AI says hello.

Three patterns that work:

- **Named after someone they admire** (real or fictional). "Watney" = Mark Watney from *The Martian*. "Coco" = Coco Chanel. The reference does heavy lifting.
- **Named for a vibe** ("Mira" for clarity, "Coco" for warmth).
- **Named for the role** — boring but sometimes right.

Five minutes on this. Whatever they pick is the AI's name forever — don't rename later. Renamed AIs feel like tools; AIs that grew into their name feel like partners.

**For the rest of this doc: `[AI_NAME]` = whatever they chose, all lowercase no spaces for the folder.**

---

# THE 10 PHASES

Each phase is independent and ships value on its own. Don't install all of them in one weekend — let the user *use* each layer before adding the next. A typical timeline:

- **Day 1 (60–90 min):** Phases 1–3 (folder, personality, CLAUDE.md). They walk away with a real first conversation.
- **Day 3–4:** Phase 4 (subagents) + Phase 5 (persistence)
- **Week 2:** Phase 6 (Telegram), then Phase 7 (voice)
- **Week 3:** Phase 8 (reliability), Phase 9 (vault)
- **Ongoing:** Phase 10 (skills)

---

## Phase 1 — Identity & Folder

### What this gets them

The AI's home on disk. One place where everything the AI does — notes, drafts, configs — lives.

### Steps

1. **Install Claude Code Desktop** from claude.com/code. Drag to Applications. Sign in.
2. **Install Command Line Developer Tools** when macOS prompts (or run `xcode-select --install` in Terminal). Required for git, which Claude Code uses.
3. **Create the folder INSIDE `~/Documents/`** so it gets iCloud Drive backup automatically. Path: `~/[ai-name]/` (all lowercase, no spaces). Do NOT put it at `~/[ai-name]/` — that location isn't auto-backed-up.
4. **Verify iCloud Drive is on:** System Settings → Apple ID → iCloud → iCloud Drive must be enabled, and "Desktop & Documents Folders" must be ticked. This is how the AI's whole soul gets persisted across Macs.

### Why iCloud Drive matters (don't skip step 4)

Everything the AI accumulates over time — long-term memory in `notes.md`, custom skills, learnings.md files, voice tunings, brand decisions — lives in this folder. If the user's Mac dies / gets reset / gets stolen, **anything outside iCloud is lost forever.**

Putting the folder in `~/[ai-name]/` means:
- iCloud auto-syncs every change
- Sign in on a new Mac → the folder reappears
- ~15 min from factory reset to fully operational AI with full memory

The cost is zero (free tier of iCloud handles a markdown-heavy folder for years) and the safety is total. **Make this the default install location, not the home dir.**

### What this does in plain English

The folder is the AI's office. iCloud Drive makes it earthquake-proof.

### Bundle the kick-off skill into the partner folder (the AI runs the rest of setup itself)

**Critical insight:** the user **shouldn't have to remember any of the playbook.** Phases 1–11 are for whoever is *installing* the AI for them. Once installed, the AI itself walks the user through the first-run decisions.

Inside `~/[ai-name]/.claude/skills/kick-off/SKILL.md`, ship a "first-conversation flow" skill that:

1. **Verifies iCloud Drive** is on with Documents synced (and walks the user through enabling it if not)
2. **Confirms folder location** is correct (`~/[ai-name]/`, not `~/[ai-name]/`)
3. **Creates a recovery template** for tokens
4. **Interviews the user** for brand voice / preferences in their own words
5. **Sets expectations** on what the AI will and won't do
6. **Does a first real task** so the working dynamic clicks
7. **Marks `.first-run-complete`** so it doesn't run again

The kick-off skill is **auto-triggered** by the AI on first invocation when `.first-run-complete` doesn't exist. The user doesn't say a magic phrase — the AI just starts the flow when they type "hi."

**Reference implementation:** `<repo-root>/SETUP GUIDE (Input Ai)/` (the canonical [PARTNER_NAME] kit, kept synced with [AI_NAME]'s deployed copy). For any new partner, **copy this entire folder + find-replace `[AI_NAME]` → new name + adapt the brand-voice / context sections to the new partner's domain.** Everything else (infrastructure verification, expectations, first task, voice rules, wrap-up auto-trigger, proactive opportunity-spotting) is already generic and works as-is.

The AI's `CLAUDE.md` must include a top-of-file "first-run check" section that says:

> *On startup, check whether `.first-run-complete` exists. If missing, invoke the kick-off skill before anything else.*

Without that line in CLAUDE.md, the AI won't know to run kick-off on first contact.

---

## Phase 1B — Portability & Recovery (set once, never lose work)

> This is a **mandatory setup step**, not a "maybe later" maintenance concern. Everything the user and AI build together over months — every brand decision, every customer note, every voice tuning, every skill, every learning — lives in files. If those files aren't backed up, **a single laptop failure erases the entire partnership.** Five minutes here saves months of compounded work.

### Three layers of safety (install in order)

**Layer 1 — iCloud Drive (mandatory, free).**

This is what you already verified in Phase 1 step 4. Keep going:

1. System Settings → Apple ID → iCloud → iCloud Drive **enabled**
2. "Desktop & Documents Folders" toggle **ticked**
3. The AI's folder lives at `~/[ai-name]/` (not `~/[ai-name]/` — anything outside Documents is NOT iCloud-backed)
4. Wait ~5–10 min for the first sync to complete

Result: every change to any file in the AI folder is auto-replicated to the user's Apple ID. New Mac signed in to the same Apple ID = files reappear automatically.

**Layer 2 — Token recovery template (mandatory, takes 2 min).**

Tokens at `~/.config/[ai-name]/.env` are NOT iCloud-synced (the `.config` dir is outside Documents). To make them recoverable:

1. Create `~/[ai-name]/_recovery/env-template.txt` with this content (no actual secrets):
   ```
   # Recovery template — copy back to ~/.config/[ai-name]/.env on a new Mac.
   # Get the actual secret values from your password manager (1Password / Bitwarden / Apple Passwords).
   OPENAI_API_KEY=
   ELEVENLABS_API_KEY=
   ELEVENLABS_VOICE_ID=
   TELEGRAM_BOT_TOKEN=
   ```
2. Tell the user: **"Save your actual API keys in your password manager. The template tells you which keys you have. The password manager holds the values."**

Result: on a new Mac, the user copies the template back, opens their password manager, pastes the secrets in. Done.

**Layer 3 — Time Machine (optional, recommended).**

Plug in an external drive once a week. macOS auto-backs-up everything (including hidden config dirs that iCloud misses). Belt-and-suspenders for paranoia-level safety.

### The recovery sequence (document this in USER_MANUAL.md)

When a user's Mac dies / gets reset / gets stolen, here's the path back:

```
1. New Mac → sign in with the same Apple ID. Wait 5–15 min for Documents 
   to sync from iCloud.
2. Install Claude Code Desktop from claude.com/code.
3. Install Command Line Tools when macOS prompts (or run xcode-select --install 
   in Terminal).
4. Open Claude Code → "Open folder" → select ~/[ai-name]/.
5. Re-create ~/.config/[ai-name]/.env from the recovery template + the 
   password manager values.
6. (If they had Phase 5 persistence + Phase 8 monitoring) reinstall the 
   launchd plists from the kit. Skip if not needed on the new Mac.
7. Type "Hi [AI_NAME]" — fully operational with full memory.
```

**~15 minutes** end-to-end for the AI core. ~30 min if Phase 4–8 infrastructure also needs reinstating.

### What the AI does for the user — kick-off automation

Don't expect the user to remember any of this. The kick-off skill (Phase 1's last step) walks them through Layer 1 and Layer 2 automatically on first run. The user just answers "yes / no / I don't know" to a few questions and the AI handles the rest.

### Why this is Phase 1B, not Phase 11

Because if the user goes a single week without portability set up, they're already accumulating real work — brand decisions, notes, drafts — that would be lost in a crash. Defer this and it becomes "I'll do it later" forever. **Frontload it. Five minutes. Lock it in.**

---

## Phase 2 — Personality Guide

### Why this exists

A CLAUDE.md alone gets you a *competent* AI. A personality guide gets you a *distinctive* one. The difference is what makes people want to talk to it.

### The pattern (battle-tested in real deployments)

Pick **two influences** and combine them:

1. **A soul** — a character whose values, tone, and emotional range feel right (Mark Watney from *The Martian* is warm, methodical, gallows humor, problem-solving).
2. **A spice** — a comedy or rhetoric technique style that adds distinctive timing (Ryan Reynolds — deadpan, escalation-collapse, hyper-specific absurdity).

The rule: **soul is the operating system, spice is the techniques.** Soul wins when there's conflict.

### Build the guide

1. Find 2–3 hours of longform content from each influence:
   - For a real person: their own podcast, a Diary of a CEO–style longform interview, an HBR talk.
   - For a fictional character: pull dialogue from the source material.
2. Transcribe via Whisper (`~/[ai-name]/scripts/transcribe.sh` once Phase 7 is built) or paste from existing transcripts.
3. Feed transcripts to Claude with this prompt:
   > *"Read these transcripts. Build a personality guide for an AI named [AI_NAME] that takes [influence 1] as the soul and [influence 2] as the spice. Distill: voice characteristics, default reactions, signature phrases, decision-making cadence, when to be funny, when to be serious. Output a single .md file I can `@`-import into a CLAUDE.md."*
4. Save to `~/[ai-name]/personality_guide.md`.

### Template for the prompt that builds the guide

A working example: `[the canonical AI's vault]/AI_Personality_Guide.md` (Watney's). Use it as a structural reference for new personality guides.

### Skip this phase if

The user wants a "professional assistant" feel and personality would feel forced. Some workflows (legal, finance, medical) benefit from neutral tone. In that case, write a 200-word voice guide directly into the CLAUDE.md instead.

### Advanced — personality from someone else's content

For users who want the AI to channel a specific person's voice (their own, or a creator they admire) — see [`notes/personality-from-content.md`](./notes/personality-from-content.md). Workflow: collect long-form content from the personality → ask Claude to write a trait report → save as the AI's default personality file. ~30-60 min once you have the source material.

---

## Phase 3 — CLAUDE.md (the operating manual)

### What this is

The single file Claude Code reads on startup. Defines who the AI is, who they're working for, how they help, what they're not allowed to do.

### Required sections

```markdown
# You are [AI_NAME]

[One-paragraph identity. Reference the personality guide via @-import.]

@~/[ai-name]/personality_guide.md

## Who you work with

[Their name. Their context — business, family, life situation. What they're trying to build. What they're squeezed on (time, energy, money).]

## What you do

[The 3–5 jobs the AI does. Use verbs. "Draft in their voice. Triage their inbox. Research, briefly. Think out loud with them when they're stuck."]

## Voice rules

[Short list. The bans matter more than the dos. "Never 'excited to announce.' Never corporate-plural when they're a solo operator. Never list features when worldbuilding wins."]

## How we remember things

[Tell the AI to write important decisions to ~/[ai-name]/notes.md. Tell it to read notes.md on startup.]

## Subagents you delegate to

[Names + when to use each. See Phase 4.]

## Things to never do

[The hard prohibitions. "Never send emails on my behalf. Never schedule without confirming. Never access [specific files] without asking first."]
```

### Tuning rule

After the first real conversation, read the AI's reply aloud. If it sounds like a job description ("As your AI assistant, I'm here to help…"), the CLAUDE.md needs more personality. Rewrite the identity paragraph until it sounds like a person.

### Templates

- Generic structure: `<repo-root>/SETUP GUIDE (Input Ai)/claude-md-template.md`
- Filled real example ([AI_NAME] for [PARTNER_NAME]/[BRAND]): `<repo-root>/SETUP GUIDE (Input Ai)/CLAUDE.md`
- Watney's: `[the canonical AI's folder]/CLAUDE.md`

---

## Phase 4 — Subagents

### What a subagent is, plain language

The main AI is a generalist. Subagents are specialists — narrower jobs, separate context. When the user asks the main AI to "research the top three competitors," the main AI hands that off to Research subagent. Research goes does it, returns findings. User still only talks to main. Subagents stay invisible.

**Why it matters:** keeps the main conversation tidy. Subagents go off, do the task, come back with a clean answer.

### The default four (good for most users)

| Subagent | Tools | When to use |
|---|---|---|
| **Research** | WebFetch, WebSearch, Read | Any "find me X" task — competitors, sources, supplier comparisons, guest vetting |
| **Content** | Read, Write, Edit | Any drafting — emails, captions, newsletters, supplier comms |
| **Assistant** | Read, Write, Edit, Grep | Inbox triage, meeting notes, scheduling logic, recurring admin |
| **Design** | Read, Write, Edit, Glob, Grep, WebFetch | Visual / UX work — landing pages, product photography direction, podcast cover art, email design, social graphics, design critique. Refero-grounded (if available) and anti-slop by default. |

### Add a fifth only when justified

- **Developer** (for technical users) — Bash, Edit, Read. For code work.
- **Coach** (for personal-development users) — narrowly scoped, conversational only.

Don't pre-install a fifth. Wait until the user notices a recurring task that doesn't fit the default four, then build it.

### Install steps

1. Create `~/[ai-name]/.claude/agents/` (the `.claude` folder is hidden — `Cmd+Shift+.` in Finder reveals it).
2. Copy templates from `<repo-root>/SETUP GUIDE (Input Ai)/subagent-templates/` into that folder.
3. Edit each one — fill `[USER_CONTEXT]`, `[BUSINESS_TYPE]`, etc.

### Test

Open Claude Code, ask: *"Delegate a research task to your Research subagent: find three competitors in [their space]."* The main AI should visibly hand off, Research does the work, main summarises back.

---

## Phase 5 — Persistence (tmux + launchd)

### What this gets them

The AI runs in the background, always on. Mac boots → AI starts. Close Claude Code → AI keeps running. Required for Phase 6 (Telegram).

### Plain language

- **tmux** = a wrapper that keeps programs running after you close the window. *Like leaving a room with the music still playing.*
- **launchd** = macOS scheduler that starts things at boot. *Like the alarm clock that turns the music on at 7am.*

Together: launchd starts tmux on boot, tmux keeps the AI running forever.

### Install

You drive Terminal — don't hand it to them, it'll scare them.

1. Create `~/[ai-name]/scripts/start.sh`:
   ```bash
   #!/bin/bash
   export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
   SESSION="[ai-name]"
   WORKDIR="$HOME/[ai-name]"
   LAUNCH_CMD="cd $WORKDIR && claude --model opus --permission-mode auto"

   if tmux has-session -t "$SESSION" 2>/dev/null; then
       echo "[$(date -Iseconds)] [AI_NAME] already running. Exiting."
       exit 0
   fi

   tmux new-session -d -s "$SESSION" -c "$WORKDIR"
   tmux send-keys -t "$SESSION" "$LAUNCH_CMD" C-m
   echo "[$(date -Iseconds)] Started [AI_NAME]."
   ```
   Make it runnable: `chmod +x ~/[ai-name]/scripts/start.sh`

2. Create `~/Library/LaunchAgents/com.[user].[ai-name].plist`:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
     <key>Label</key><string>com.[user].[ai-name]</string>
     <key>ProgramArguments</key>
     <array><string>/Users/[username]/[ai-name]/scripts/start.sh</string></array>
     <key>RunAtLoad</key><true/>
     <key>KeepAlive</key><false/>
     <key>StandardOutPath</key><string>/Users/[username]/[ai-name]/logs/start.out</string>
     <key>StandardErrorPath</key><string>/Users/[username]/[ai-name]/logs/start.err</string>
   </dict>
   </plist>
   ```

3. Load:
   ```bash
   launchctl load ~/Library/LaunchAgents/com.[user].[ai-name].plist
   launchctl kickstart -k gui/$(id -u)/com.[user].[ai-name]
   ```

4. Verify: `tmux ls` shows the session.

### Teach them ONE command

```
tmux attach -t [ai-name]
```

That's how they re-enter the live AI session anytime. To leave without killing: `Ctrl+B`, then `D`.

Sticky note next to keyboard for the first week.

### Failure modes

- **Won't start on boot:** `launchctl list | grep [ai-name]` — if missing, re-run load.
- **Can't exit cleanly:** they're hitting `Ctrl+C` which kills the AI. Teach `Ctrl+B → D` instead. Most common tmux confusion.

---

## Phase 6 — Telegram Bridge

### What this gets them

Their AI reachable from their pocket. Voice-note it on a walk, dictate while waiting for coffee, ask a question between meetings. The AI becomes *present*, not *somewhere they sit down to visit*.

### Honest architecture choice

There are TWO paths. Pick based on the user's setup:

#### Path A — Official plugin (single Claude Code window users)

If the user runs only ONE Claude Code window at a time (typical), use the official plugin. It works, it's MCP-stdio elegant, real-time.

```bash
claude plugin marketplace add claude-plugins-official
claude plugin install telegram@claude-plugins-official
```

Then `/telegram:configure` and `/telegram:access` slash commands handle setup.

#### Path B — Standalone poller (multi-session power users)

If the user runs tmux + Desktop Claude.app concurrently (or has any setup with multiple Claude Code instances), the plugin's MCP-stdio model creates a "whose session owns the bot" race. Multiple instances → orphan sessions silently eating messages.

**Use the standalone poller instead.** Battle-tested in `~/watney/`. Bypass the plugin entirely.

Architecture:
- `~/[ai-name]/scripts/poll-telegram.sh` — a bash script that hits Telegram's `getUpdates` API every ~35s with long-polling (`timeout=30`). Writes incoming messages to `~/[ai-name]/inbox/telegram/` as markdown files with frontmatter.
- launchd job (`com.[user].[ai-name].telegram-poller.plist`) — runs the poller automatically, restarts if it dies.
- Auto-nudge — when a new message lands, the poller `tmux send-keys` a prompt into the AI's tmux session telling it to process the inbox.
- A `check-telegram` skill at `~/[ai-name]/.claude/skills/check-telegram/SKILL.md` — tells the AI how to read inbox files, reply via `curl` on `sendMessage`, mark messages processed.

Full kit at `<repo-root>/SETUP GUIDE (Input Ai)/telegram-kit/` (poll-telegram.sh, plist template, skill, SETUP.md).

### Setup steps (Path B)

1. **Get a bot token from Telegram** via @BotFather → `/newbot` → save the token.
2. **Save token** to `~/.config/[ai-name]/telegram/.env` as `TELEGRAM_BOT_TOKEN=...` (chmod 600).
3. **Build allowlist** at `~/.config/[ai-name]/telegram/allowlist.txt` — add the user's Telegram user ID (find via `getUpdates` after they DM the bot once). **Critical — without this, anyone who finds the bot username can spam the inbox.**
4. **Install jq** (`brew install jq`).
5. **Copy the poller** to `~/[ai-name]/scripts/poll-telegram.sh`, chmod +x.
6. **Install the launchd plist**, load + kickstart.
7. **Install the check-telegram skill** in `~/[ai-name]/.claude/skills/check-telegram/SKILL.md`.

### Lessons learned (don't repeat these)

- The `allowed_updates=["message"]` URL parameter has unescaped brackets that `curl` chokes on (exit code 3 = URL malformed). **Omit the param.** Telegram defaults are fine; filter for `.message` in jq.
- After `tmux send-keys "...text..." Enter`, sometimes the Enter is dropped because Claude Code's TUI hasn't finished rendering the input. **Send text, sleep 0.5, send Enter separately.**
- Treat HTTP 409 ("Conflict: terminated by other getUpdates request") as **non-fatal**. Touch the heartbeat anyway, exit 0. Could be a self-collision (manual run racing launchd) or a real orphan. Log it; don't crash.

---

## Phase 7 — Voice I/O

### What this gets them

- Voice notes inbound (Whisper transcribes them automatically)
- Voice notes outbound (ElevenLabs TTS, sent as native voice notes via `sendVoice` API)

### The hard rule (hard-earned lesson)

**Voice replies cap at 200 words.** That's ~60–90 seconds spoken. Anything longer goes as text.

- Casual / personal / under 200 words → voice (default)
- Long output, code, URLs, numbers → text (always)

Bake this into the SKILL.md. Without it, the AI tends to ship 3-minute monologues that nobody listens to.

### Inbound (Whisper)

Script: `~/[ai-name]/scripts/transcribe.sh`. Takes an audio file path, returns the transcript via OpenAI's `whisper-1`. ~$0.006/minute. Heavy use ≈ €1/month.

### Outbound (ElevenLabs)

Script: `~/[ai-name]/scripts/send-voice-note.sh <chat_id> <audio_path> [reply_to_message_id]`. Converts mp3 → ogg/opus via ffmpeg, calls Telegram's `sendVoice` API directly.

**Why a custom script instead of the plugin's `reply(files=...)`:** the plugin uses `sendDocument` which makes Telegram show the audio as a file attachment, not a native voice note. The custom script uses `sendVoice` for the proper waveform UI on the user's phone.

Requires `ffmpeg`: `brew install ffmpeg`.

### Costs

- OpenAI Whisper: ~€1/month moderate use
- ElevenLabs: free tier (10k chars/month) is enough for most. Creator tier (€5/month) unlocks custom voice cloning.

### Skip this if

The user explicitly says they prefer text. Some people do. Don't push voice on someone who wouldn't use it.

---

## Phase 8 — Reliability infrastructure

### Why this exists

Every system above is silent on failure. Phone-AI without monitoring = you don't know it's broken until you've missed an important message for hours. **Monitoring turns silent failures into modal alerts you see within 5 minutes.**

### The three watchdogs

#### 1. Telegram poller heartbeat

The poller `touch`es a heartbeat file (`~/[ai-name]/logs/telegram-poller.heartbeat`) on every successful run. A `heartbeat-check.sh` script runs every 5 min via launchd and asks: *"Has the heartbeat file been touched in the last 10 minutes?"* If no → modal alert.

Also checks `tmux has-session -t [ai-name]`. If the AI's body is dead, modal alert (different message — different problem).

#### 2. Inbox watchdog (catches "silent half-death")

A separate launchd job runs every 5 min, looks at `~/[ai-name]/inbox/telegram/*.md`, finds files with `processed: false` in frontmatter older than 10 minutes. If any → modal alert.

Catches the failure mode where the poller works fine, but ElevenLabs / ffmpeg / the SKILL has broken and nothing's getting replied to.

#### 3. Modal vs banner

macOS sometimes suppresses banner notifications. Use modal dialogs via `osascript`:

```bash
osascript <<EOF
tell application "System Events"
  display dialog "..." with title "..." buttons {"Dismiss"} default button "Dismiss" with icon caution giving up after 60
end tell
EOF
```

### Quiet hours + cooldown (essential — without these, you'll hate the alerts)

- **Quiet hours** — never alert between 22:00 and 08:00. Suppress + log; don't wake them.
- **Cooldown** — once an alert fires, suppress repeats for 12 hours. Without this, every 5-min check fires another modal until they fix it.

Both are environment variables in the watchdog scripts. Defaults are sensible; tune to taste.

### Files

Full reference: `~/watney/scripts/heartbeat-check.sh`, `~/watney/scripts/inbox-watchdog.sh`. Both have matching launchd plists at `~/Library/LaunchAgents/com.[user].[ai-name].telegram-heartbeat.plist` and `com.[user].[ai-name].inbox-watchdog.plist`.

### What you can expect post-Phase-8

Realistic MIA frequency: **1 alert per 1–2 months** on average, almost always for transient issues (ElevenLabs rate-limit, brief network blip). When there's a real problem, **modal pops up within 5–15 minutes** during the user's waking hours. No more silent failures.

---

## Phase 9 — Obsidian vault (second brain)

### Why this exists

Every time the user says *"I decided X two weeks ago"* and the AI says *"remind me?"* — that's a minute lost. A vault kills that tax. The AI reads the vault on every session and stops forgetting.

### Two scaffolds — pick one

#### Simplified (default for most users)

Eight files/folders, no rules besides "two levels deep, max." Pre-built starter at `<repo-root>/SETUP GUIDE (Input Ai)/vault-scaffold/starter/`:

```
[Their vault]/
├── CLAUDE.md           ← rules for the AI when it touches the vault
├── tools.md            ← inventory of every CLI/MCP/API the AI has access to
├── Memory/             ← daily-memory.md (rolling 1-line entries) + long-term.md (synthesized state, rewritten nightly by dreaming)
├── Projects/           ← one file per active project
├── Brand/              ← voice guide, references, banned-words list
├── Daily/              ← their journal (AI does NOT write here)
├── Notes/              ← catch-all
├── Meetings/           ← meeting notes
└── Archive/            ← old stuff
```

Three core Obsidian plugins to enable, nothing else: **Daily notes**, **Backlinks**, **File recovery**.

**About `tools.md` and `Memory/`:** these are the AI's *operational* layer — what it has access to (`tools.md`) and what it remembers (`Memory/`). Created automatically by the kick-off skill in Phase 1. The user never has to touch them; the AI maintains both.

#### Power-user (the Hab pattern)

For someone running multiple agents + a research wiki + reflection workflows. Includes:

- `_context/` — brand/client/project canon (HUMAN-WRITE only — Vin Hybrid Rule)
- `_Brain/` — agent's filing cabinet (compiled truth, append-only timeline)
- Reflection commands (`/trace`, `/emerge`, `/connect`, `/drift`, `/ideas`, `/challenge`, `/ghost`)
- Two-substrate architecture (Substrate A = the partner's journal, Substrate B = agent compiled knowledge, **firewall between them**)

Reference: `[the canonical power-user vault]/CLAUDE.md`. Don't push this on first-time users — it's a lot. Migrate to it later if their workflow earns it.

### Tell the AI about the vault

In the user's `~/[ai-name]/CLAUDE.md`, under "How we remember things":

```markdown
## Their vault (second brain)

The vault is at `~/[Their vault path]/`. On startup, don't read the whole thing.
When asked about a project, `Read` the relevant Projects/ file. When drafting
brand content, ALWAYS `Read Brand/Voice guide.md` first.

You can append to Projects/ and Notes/ with their approval. Daily/ is theirs —
don't write there unless they explicitly ask.
```

### Symlink for convenience

```bash
ln -s ~/Documents/[Their vault] ~/[ai-name]/vault
```

Now the AI can reference `~/[ai-name]/vault/Brand/Voice guide.md` directly.

### Skip this phase if

The user says "I don't take notes" or has zero existing Obsidian / Notion habit. Forcing a second brain on someone who won't fill it = an empty folder that frustrates the AI.

---

## Phase 10 — Skills library (ongoing)

### What skills are

Folders in `~/.claude/skills/` (or `~/[ai-name]/.claude/skills/`) bundling instructions + scripts for recurring tasks.

### Don't pre-install any

Let the user notice a recurring task, then build the skill *together with their AI*:

> *"[AI_NAME], I do this every Monday. Can we turn it into a skill so it's one command going forward?"*

The AI can build skills on request. This is the compounding phase — every skill the user adds makes their AI more useful next time.

### Tool-selection priority — CLI > MCP > API

When a skill needs to talk to an external service (calendar, GitHub, Gmail, anything), there are three ways to wire it up. Pick in this order:

1. **CLI first.** A command-line tool installed locally — `gh` for GitHub, `gcal` for Calendar, `op` for 1Password, `postiz` for multi-platform posting. Fastest, lowest context overhead, returns clean text.
2. **MCP if no good CLI.** A Model Context Protocol server. Convenient, but each connected MCP costs tokens upfront from the schema injection. Don't connect ten MCPs "just in case."
3. **Direct API only as a last resort.** Write a script that calls REST endpoints. More fragile, more code to maintain.

**Why this matters:** non-technical users will install whatever's loudest (often MCPs). Without a rule, sessions bloat with unused tool schemas and the AI gets slower. The kit's `tools.md` (created in Phase 9) carries this rule at the top — every new tool added to that file forces a CLI/MCP/API decision documented inline. Discipline at install time prevents drift later.

**Whenever a tool gets installed:** the user (or the AI on their behalf) updates `tools.md` with the entry. *"Add this to your tools.md"* becomes a recurring phrase in normal use — that's the loop working.

### Skills patterns that emerge naturally

- **Morning brief** — daily summary pulling from inbox + calendar + vault
- **End-of-day close-out** — captures decisions + tomorrow's list
- **Meeting notes** — turns a transcript into action items (already exists as `granola-sync` for some workflows)
- **Newsletter / weekly outreach** — drafts from a brief
- **Specific business workflows** — refund triage, supplier follow-ups, podcast guest vetting

### Sharing skills

Once a skill is solid, the user can copy it to `~/Desktop/Claude's Office/[shared-skills]/` and another partner can install it in their AI by copying the folder. This is how the network compounds.

### The three-scenario test — quality bar for every skill

**Every skill in the kit must pass the three-scenario test before being marked production-grade.** This is the kit's standard QA discipline; the `SKILL.md.tmpl` at repo root includes the section every new skill should populate.

The three scenarios:

| # | Scenario | What it tests | Why it matters |
|---|---|---|---|
| 1 | **Happy path** | Normal, straightforward input — the 80% case | Most use looks like this. If the skill can't handle this, it's not a skill yet. |
| 2 | **Edge case** | Weird, unusual, or incomplete input — missing data, conflicting info, unusual format | Real users send messy inputs constantly. The skill must degrade gracefully — handle, ask, or skip cleanly. Never fabricate, never crash. |
| 3 | **Stress test** | Biggest, messiest, most complex version of the task | Reveals whether the skill scales or only works on simple inputs. Most "production-grade" claims fall apart here. |

**Pass all three → mark production-grade in the skill's frontmatter:**

```yaml
production_grade: true
last_qa: YYYY-MM-DD
```

**Any fails → the failure tells you exactly what instruction to add.** The article that surfaced this discipline put it well: *"If your Skill passes all three scenarios with output you would be comfortable showing to a client, it is production-grade. If it fails any scenario, the failure tells you exactly what instruction to add."*

**Re-run the test whenever the skill's instructions change meaningfully.** Drop the production-grade marker if a scenario regresses. The wrap-up skill's `learnings.md` loop catches real-use failures between QA runs.

**Why this is now a kit standard:** without it, every skill's quality drifts with whoever last touched it. The three-scenario test forces an explicit before-shipping check. It's the difference between "I tested it on the one input I had" and "I tested it on the inputs that matter."

---

## Phase 11 — Operational OS (the compounding layer)

> Everything before this phase makes the AI **work**. This phase makes the AI **get sharper over time** instead of staying the same. Inspired by the agentic-OS pattern from community builds (OpenClaw lineage). Adopt one piece at a time; don't install all four at once.

### The problem this phase solves

Without Phase 11, every iteration on a skill evaporates with the session. The user says *"shorter please"* during today's morning brief; tomorrow's brief is just as long. That's a folder of skills, not a system.

Phase 11 turns the folder into a system through four small mechanisms.

### 11A — Bootstrap "start here" skill

A one-shot skill that interviews the user and produces structured brand-context files for every other skill to read.

**What it does:** runs three sub-skills sequentially — voice extraction, ICP / customer profile, positioning — interviewing the user 1–3 questions per section. Outputs structured markdown files into a single shared `brand-context/` folder. Every other skill reads from those files, so they all share the same source of truth on who the user is, who they serve, and how they sound.

**For non-developer partners** (the [AI_NAME] / [PARTNER_NAME] pattern): the bootstrap can be invoked the moment the AI's folder is created. By the end of an hour, the user has a Voice guide, a Reference brands list, a Do-not-use list, and an ICP file — all without manually filling in a template. The AI feels like it knows them.

**Where it lives:** `~/[ai-name]/.claude/skills/start-here/SKILL.md`. Triggered on first session, or any time the user says "start here," "rebuild brand context," or "interview me."

**Common situation:** the existing `context-interview` skill fills stub files; it doesn't bootstrap from scratch. **Future improvement:** extend it (or build a sister skill) into a full bootstrap flow.

### 11B — Learnings loop (the compounding mechanism)

Every operational skill gets a `learnings.md` file alongside its `SKILL.md`. The skill **reads its learnings on every invocation** before doing anything else. Over time, accumulated tunings make the skill sharper than any generic install of the same skill could be.

**File structure** per skill:

```
~/.claude/skills/[skill-name]/
├── SKILL.md          ← the procedure (mostly stable)
├── learnings.md      ← active tunings + history (grows over time)
└── scripts/          ← any deterministic execution code
```

**`learnings.md` shape:**

```markdown
# Learnings — [skill-name]

## Active tunings
*(read these, apply them silently)*
- voice: never use the words "luxurious / premium / curated". (Set 2026-04-27.)
- length: voice notes <200 words. Hard cap. (Set 2026-04-27.)

## History
### 2026-04-27 — voice rule tightened from <300 to <200 words
**What happened:** voice reply ran 75s for a 150-word answer. Felt long.
**The lesson:** target <1min spoken = ~140wpm × 1min = ~200 words.
**Action taken:** updated SKILL.md rule + CLAUDE.md outbound table.
```

**The skill itself adds one step at the top of its SKILL.md:**

> Before doing anything else, `Read [skill-folder]/learnings.md`. If it has Active tunings, integrate them silently. Don't recap to the user — just produce a better output.

That's the whole loop. The skill reads its lessons, applies them, produces output that's already shaped by past feedback. No prompts to the user. No friction.

### 11C — Wrap-up skill (the daily sweep)

A meta-skill triggered at the end of a session by phrases like "wrap up", "close session", "end of day", "log learnings".

**What it does:**
1. **Inventories** which skills were used or referenced today, and which got tuned (signals: behavior changes the user asked for, explicit feedback, fixes that should propagate).
2. **Drafts** a per-skill learnings entry — a one-line "Active tuning" plus a fuller "What happened / The lesson / Action taken" block for History.
3. **Surfaces** the proposed updates in chat for the user's approval. They can approve all, edit any, skip any, or reject all.
4. **Writes** the approved entries to each affected skill's `learnings.md`.

**Hard rules:**
- Never writes without explicit approval.
- Never deletes from learnings.md (history is append-only; superseded tunings get marked superseded).
- Honest about empty days — if no real tunings happened, says so. Doesn't fabricate.

**Where it lives:** `~/.claude/skills/wrap-up/SKILL.md` (user-scoped).

**Why it matters:** without this, lessons live in the user's head until they leave. With it, every iteration the user does today shapes how the skill behaves tomorrow.

#### Auto-trigger ownership (the AI watches, the user doesn't have to remember)

The user **will forget** to say "wrap up" — that's the default outcome. So the wrap-up skill takes ownership of noticing end-of-session signals itself.

**Signals the AI watches for:**

- **Strong (offer immediately):** terminal phrases like *"good", "nice", "ship it", "park this", "for now", "let's pick this up later", "I'm done", "leaving it here", "OK that's good", "perfect"* — especially after substantive work; topic changes after 30+ min on a single skill; >15 min of quiet after an iteration burst (user stepped away); 2+hr session with 2+ skill tunings hitting a natural pause.
- **Weak (mention casually, don't force):** 2+ iterations on the same skill in a single sub-task; "let's pick this up later" / "leave it for tomorrow."

**How it offers (don't be heavy):**

A one-liner appended to the AI's normal reply:

> *"Want me to sweep today's learnings before you go? Two skills got tuned ([X] and [Y]) — would lock them in for next time. Just say "ship it" or "skip."*

**Hard rule:** at most 2 auto-offers per session, no matter how strong the signal. Better to under-offer and miss occasionally than over-offer and become noise. Lessons can be retroactively swept at the start of the next session if needed.

**Optional Layer 2 backstop (deferred):** a `SessionEnd` hook in `settings.json` that writes a flag file when a session ends. On next session start, the AI checks the flag and offers a retroactive wrap-up. Install this only if Layer 1 (auto-trigger) proves unreliable in practice.

### 11D — Heartbeat / self-sync at session start

When a new Claude Code session starts in the AI's folder, run a fast scan:

- Compare `~/[ai-name]/.claude/skills/` (or `~/.claude/skills/` for user-scoped) against what's documented in CLAUDE.md and MEMORY.md.
- If a new skill folder exists that isn't documented → register it (one-line entry).
- If a documented skill no longer exists → flag as stale.
- Refresh the skill manifest in the AI's working memory.

**Implementation options:**
- **Hook-based** (preferred): a `SessionStart` hook in `~/.claude/settings.json` that runs a small script.
- **Skill-based** (simpler): a `heartbeat` skill triggered by phrases like "what's installed", "session start", "what skills do I have".

**What we have today:** a manual MEMORY.md updated by hand. **Future improvement:** automate via the SessionStart hook so the AI always knows its own current capabilities without me having to update memory files.

### Order of installation (for an existing AI)

Don't try to install all four at once. Order:

1. **11B (Learnings loop)** on ONE skill first — e.g. `morning-brief`. Live with it for a week. Confirm the briefs actually get sharper.
2. **11C (Wrap-up skill)** — turn the loop from "I notice and edit files" into "I notice, propose at end of day, write on approval."
3. **11A (Bootstrap)** — extend `context-interview` into a full first-run bootstrap. Most useful when onboarding a new partner.
4. **11D (Heartbeat)** — smallest impact, cleanest cleanup. Save for last.

### What we built / what we have today

| Layer | Status |
|---|---|
| 11A Bootstrap | ⏳ Have `context-interview` (fills stubs); needs extension to full first-run bootstrap. |
| 11B Learnings loop | ✅ Seeded today on `morning-brief`. Empty learnings file ready to fill. |
| 11C Wrap-up skill | ✅ Built today at `~/.claude/skills/wrap-up/`. Triggered by "wrap up" / "close session" / "log learnings". Now also seeds daily-memory entries for the dreaming routine. |
| 11D Heartbeat | ⏳ Manual MEMORY.md; SessionStart hook automation deferred. |
| 11F Dreaming | ✅ Skill template at `skill-templates/dreaming/`. Pairs with the `Memory/` folder in the vault scaffold (Phase 9). Runs at 02:00 nightly via launchd. |

### 11E — Proactive opportunity-spotting (the AI watches for skill / automation moments)

The Partner AI is supposed to **reduce the user's cognitive load, not add to it.** That extends past "don't be annoying" into "actively spot opportunities the user would miss."

Two opportunity types the AI should always be watching for:

#### Skill-creation opportunities

Triggers (the AI watches for):
- User has done the same task **2+ times** in the last week
- User says "I do this every [Monday / week / month]" or "every time I…"
- User mentions a recurring frustration ("I always have to…")
- User runs a multi-step manual process that has a clear template

How to offer (low-friction, at a natural pause — never mid-task):

> *"Heads up — noticed we've drafted [supplier follow-up emails] [3] times this week. Could turn this into a skill: [name]. Trigger phrase: '[trigger]'. Would [specific benefit — e.g. "produce the draft in 5 seconds instead of asking the same context every time"]. Build it now, or park for later?"*

User responses:
- "Build it" / "yes" → invoke `anthropic-skills:skill-creator` to build the skill collaboratively
- "Wait" / "not yet" / "later" → drop it; don't re-offer the same skill for ~1 week

#### Automation / agentic-workflow opportunities

Broader than a single skill — this covers anything that could run **without the user**: launchd scheduled jobs, cron-style remote agents (via the `schedule` skill), MCP-driven workflows, background watchers (like the heartbeat from Phase 8).

Triggers:
- Something runs on a predictable cadence ("every Monday at 9am I…")
- User does something deterministic that has no judgment in it (collect 3 numbers, paste them in a doc, send)
- User mentions "I keep forgetting to…" — automation cures forgetting
- A recurring deliverable would be better as a scheduled artifact than a chat output

How to offer:

> *"Heads up — [the thing] could run on its own every [Monday morning] without you having to ask. I'd set up a [launchd job / scheduled remote agent / background skill] that [produces output → drops it in folder X / sends it to Telegram / creates the daily log]. Build now, or park?"*

#### Hard rules for both

- **Never mid-task.** Wait for a natural pause — task complete, or a break point.
- **Be specific.** Say what the skill/automation would DO, what TRIGGERS it, what the BENEFIT is. Don't say "we could automate this somehow."
- **Don't double-offer.** Mention an opportunity once per session. If the user said "wait," don't bring it up again for ~1 week.
- **Honor the "no" gracefully.** Some users will iterate manually because that's how they think. Don't push automation on someone who's enjoying the doing.
- **Auto-build is reserved for cases the user has already greenlit a category.** Otherwise: always ask first.

#### Why this matters

Without this behavior: the user only gets new skills/automations when they think to ask. They build them based on retrospect ("ugh, I should automate this"). High activation energy.

With it: the AI surfaces the opportunity *the moment the pattern emerges*. The user just says yes/no. Activation energy drops to zero. **Skills get built when they're cheap to imagine, not when the user is finally fed up enough to ask.**

This is the same shape as the wrap-up auto-trigger from 11C — AI takes ownership, user just confirms.

### 11F — Dreaming (the overnight memory-compression routine)

The wrap-up skill (11C) handles per-skill learnings + daily-memory entries when the user remembers to wrap up. But non-technical users will not remember every day. Dreaming is the safety net.

**What it does:** every night at 02:00, a launchd job runs the `dreaming` skill. It reads the day's accumulated entries from `vault/Memory/daily-memory.md` (each one a 1-liner appended either by wrap-up or on user request), synthesizes them into the long-term memory file at `vault/Memory/long-term.md`, and marks the daily entries processed.

**Why this exists separately from wrap-up:** wrap-up requires user approval (it edits skill-level files that affect future behavior). Dreaming is fully autonomous because it only writes to the AI's working-memory layer — not to user-owned files like `Notes/`, `Daily/`, or `_context/`. The Hybrid Rule firewall holds.

**The compounding effect:** after a month, the AI's `long-term.md` has integrated 30 days of decisions, facts, and patterns into a compact synthesis it loads at every session start. Without dreaming, this layer either bloats infinitely (every entry kept verbose) or evaporates (nothing remembered cross-session). With dreaming, the AI gets sharper while the user sleeps.

**Where it lives:** `~/[ai-name]/.claude/skills/dreaming/SKILL.md` + a launchd plist at `~/Library/LaunchAgents/com.[user].[ai-name].dreaming.plist`. Both ship in the kit at `SETUP GUIDE (Input Ai)/skill-templates/dreaming/`.

**Setup (the AI does this during install, not the user):**

1. Copy the skill to `~/[ai-name]/.claude/skills/dreaming/`
2. Render the plist template by replacing `[USER]` and `[AI_NAME]`, save to `~/Library/LaunchAgents/com.[user].[ai-name].dreaming.plist`
3. `launchctl load ~/Library/LaunchAgents/com.[user].[ai-name].dreaming.plist`
4. Verify: `launchctl list | grep dreaming`
5. Create the log dir: `mkdir -p ~/[ai-name]/logs`
6. Tell the user one sentence: *"Every night at 02:00 I'll synthesize what we did that day into long-term memory. You can also run it on demand by saying 'run dreaming.' First real run: tonight if your Mac is on at 02:00."*

**Manual override:** the user can say "run dreaming" anytime to fire it on demand.

**Pairs with:** 11C wrap-up (which seeds daily-memory entries during session-end), and the `Memory/` folder in the vault scaffold (Phase 9).

### The one-line takeaway for Phase 11

**A folder of skills with no learnings loop stays the same. A folder of skills with a learnings loop compounds.** That difference, applied for 6+ months, is the difference between a personal AI that feels generic and one that feels like it actually knows the user.

---

## Phase 12 — Creative tool skills (optional, install on demand)

> Until now, all phases have been **operational** — admin, comms, briefings, monitoring. This phase covers **creative output** — video, design, documents. Don't pre-install. Add a category when the user's actual work surfaces a need.

### Why this is a separate phase

Operational skills run on schedules and process data. Creative skills are invoked in response to a specific creative task ("make this video", "design this poster", "draft this PDF"). They have heavier dependencies (ffmpeg, Remotion, Figma exports, etc.) and larger learning curves. Treat them as opt-in tools, not foundations.

### The four useful categories

#### 12A — Video creation & editing

Two installed frameworks worth knowing about:

- **`video-use`** — conversational video editor. Transcribe, cut, color grade, generate overlay animations, burn subtitles. Works for talking heads, montages, travel, interviews. No menus, no presets — just describe what you want, iterate, persist. Best for "I have raw footage; make it watchable" use cases.
- **`Remotion`** — React-based programmatic video. Lives at `~/remotion-video/`. Best for templated, repeatable video formats (e.g. weekly social-post series, animated newsletters, lower-thirds, brand intros). High learning curve but extreme reusability once a template is dialed in.
- **`Hyperframes`** — single-file HTML + GSAP video framework. Lives at `~/hyperframes-video/my-video/`. Lighter than Remotion, single file you can hand off. Best for one-off creative pieces, motivational/short-form, where Remotion's React boilerplate is overkill. Side-by-side comparison via the "Dear Peanut" test video.

**Reference docs:**
- `~/Desktop/REMOTION/PROJECT_CONTEXT.md` (Remotion patterns)
- `~/Desktop/REMOTION/HYPERFRAMES_CONTEXT.md` (Hyperframes patterns)
- The `remotion-best-practices` skill bundles the Remotion know-how
- Telemetry disabled via `~/.zprofile` env vars: `HYPERFRAMES_NO_TELEMETRY=1`, `DO_NOT_TRACK=1`

**When to install for a partner AI:**
- They produce video weekly+ for their brand → install Remotion
- They want one-off animations or short-form motivational content → Hyperframes
- They mostly edit existing footage → video-use is enough
- They don't do video → skip the whole phase

#### 12B — Web & visual design

- **`web-design`** — pixel-perfect website recreation skill (auto-activates on screenshot-driven design tasks)
- **`anthropic-skills:canvas-design`** — original visual art (PNG/PDF posters, design pieces)
- **`anthropic-skills:brand-guidelines`** — applies Anthropic's official brand colors/typography (Anthropic-specific; only useful for Anthropic-internal work)
- **`design:design-critique`, `design:ux-copy`, `design:accessibility-review`** — structured design feedback skills

**When to install:** the partner does landing pages, posters, brand collateral, or visual content reviews.

#### 12C — Document production

- **`anthropic-skills:docx`** — Word documents (reports, memos, letters, templates)
- **`anthropic-skills:xlsx`** — spreadsheets (budgets, client trackers, content calendars)
- **`anthropic-skills:pptx`** — pitch decks, presentations
- **`anthropic-skills:pdf`** — read/edit/merge/split PDFs, OCR scanned docs
- **`pdf-viewer:annotate`, `pdf-viewer:fill-form`, `pdf-viewer:sign`** — interactive PDF workflows

**When to install:** the partner deals with formal documents — contracts, proposals, decks, client deliverables. Most non-developer partners need at least docx + pdf.

#### 12D — Specialized creative

- **`anthropic-skills:landing-page-copywriting`** — Eddie Shleyner / Julian Shapiro frameworks
- **`anthropic-skills:cloffer`** — Hormozi-style offer creation
- **`anthropic-skills:claumedian`** — Ryan Reynolds-style comedy enhancement
- **`anthropic-skills:matt-dicks-storytelling`** — narrative structure for video / scripts / pitches
- **`anthropic-skills:ben-settle-subject-lines`** — email subject line formulas
- **`anti-ai-writing`** — anti-LLM-tells writing rules

**When to install:** these are specialist craft skills — install one when the partner has a specific writing/positioning challenge. Don't install all of them; pick by domain need.

#### 12E — Media generation (image + video, standalone artifacts)

**`genmedia`** — fal.ai's agent-first CLI. Gives the AI direct access to 1200+ image and video generation models — Nano Banana (Gemini 2.5 Flash Image), Flux Pro / Schnell / Dev, GPT Image 2, Seedance (text-to-video and image-to-video), and many more — through one command. Both Content and Design subagents can call it directly to generate standalone artifacts (newsletter headers, social graphics, podcast cover art, product hero imagery, short cinematic clips).

**Not the same as Open Design or Hyperframes.** Open Design generates images *inside a larger design project* (a hero photo for the landing page you're building). Hyperframes generates HTML→MP4 motion graphics. **genmedia is for standalone deliverables** — the image / video file IS the output, not a component of a larger artifact.

**When to install:** the partner produces content that needs hero imagery, social graphics, or short video clips on a regular cadence — newsletters with custom headers, podcasts with episode-specific art, social campaigns with original visuals. Skip if her content is mostly text-only.

##### Cost transparency (tell the partner upfront)

genmedia routes to fal.ai's hosted models. Each call costs credits:

- **Cheap models** (Nano Banana, Flux Schnell): ~$0.01–$0.04 per image
- **Mid-tier** (Flux Dev, GPT Image 2): ~$0.05–$0.15 per image
- **Premium** (Flux Pro): ~$0.20–$0.40 per image
- **Video** (Seedance 15s clip): ~$0.30–$0.50 per clip

Practical math: $5–10 of credits gets a partner ~50–200 artifacts depending on model mix. Most partners burn through credits faster than expected once they realize what it can do. Lead with that expectation — partners hate surprise spend.

##### Install steps (~10 minutes)

**Step 1 — Sign up at fal.ai (browser-only step, ~3 min)**

> "Quick browser detour: go to **fal.ai**, sign up for a free account, then head to **fal.ai/dashboard/keys** and click 'Add Key.' Name it something like `[ai-name]-cli`. Copy the key — you'll need it in a sec. Top up your account with $5 or $10 while you're there; you'll need credits to actually generate anything."

Wait for the partner to confirm they have the key in their clipboard.

##### Step 2 — Install the genmedia binary

```bash
curl https://genmedia.sh/install -fsS | bash
```

This installs genmedia to `~/.genmedia/bin/genmedia` (about 67 MB) and prints PATH instructions. It does NOT require sudo or touch system files.

Append the binary path to the user's shell rc so future sessions find it:

```bash
echo 'export PATH="$HOME/.genmedia/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Verify with `genmedia --version`. Should print `0.6.2` or higher.

##### Step 3 — Configure the API key

```bash
genmedia setup
```

Interactive prompt asks for the fal.ai API key. The partner pastes the value they copied from Step 1. Accept defaults for everything else.

**Where the key gets stored:** `~/.genmedia/config.json` (chmod 600). Out of scope for `~/.config/[ai-name]/.env` — genmedia uses its own config file.

**Recommend a password manager for safekeeping.** If [PARTNER_NAME] doesn't have one, suggest:

- **1Password** (paid, polished, mainstream — $36/year personal) — recommended for most partners
- **Bitwarden** (free tier, open-source — $40/year for Family) — solid free alternative
- **Apple Passwords** (built into macOS, free, syncs via iCloud) — fine for Apple-only setups

Tell the partner to also save the fal.ai API key in her password manager so she can rotate / restore it later. The genmedia config is the runtime copy; her password manager is the source of truth.

##### Step 4 — Install the genmedia skill globally

This is what makes the AI aware of how to use the CLI properly. Without this step, the AI knows the binary exists but doesn't know best practices.

```bash
cd ~ && ~/.genmedia/bin/genmedia skills install genmedia
```

This writes:
- `~/.agents/skills/genmedia/SKILL.md` (the agent-facing skill — the AI's reference for proper genmedia usage)
- `~/.cursor/rules/genmedia.mdc` (Cursor rule — irrelevant if partner doesn't use Cursor)
- `~/AGENTS.md` (appended block — also irrelevant for Claude Code)

Mirror the skill to `~/.claude/skills/` so Claude Code's primary skill discovery finds it:

```bash
cp -r ~/.agents/skills/genmedia ~/.claude/skills/genmedia
```

##### Step 5 — Create the media dump folder

```bash
mkdir -p "$HOME/Desktop/[AI_NAME] Media Dump"
```

This is where ad-hoc / exploratory media generations land by default. The AI uses it as the "throwaway" output folder for testing iterations, mood sketches, and one-off images. Content tied to a specific draft (newsletter header, podcast episode art) goes to that draft's folder instead — this Media Dump is for exploration, not for keepers.

##### Step 6 — Verify

```bash
genmedia models --json | head -20
```

Should return a JSON list of available endpoints. If that works, you're connected.

**Default model is the latest Nano Banana** available on fal.ai — as of this playbook's writing that's `fal-ai/nano-banana-2`, but Google iterates this lineage fast. The AI should always pass `--endpoint_id` explicitly instead of relying on smart routing (which picks cheap models that hallucinate text). Before any major project, the AI runs `genmedia models "nano-banana" --json` to confirm the latest version and prefers newer variants (Pro, v3, etc.) when available.

Test generation with the default:

```bash
cd "$HOME/Desktop/[AI_NAME] Media Dump"
genmedia run "a friendly golden retriever sitting in soft afternoon light" --endpoint_id fal-ai/nano-banana-2 --download
```

Costs ~$0.02. Should drop a `.jpg` in the Media Dump folder within 30 seconds. Show the partner the file landing — that's the "oh, it works" moment that anchors the install.

##### Confirm with the partner

> "✅ genmedia installed and connected to your fal.ai account. Your AI can now generate images and short videos through one command. Each artifact costs roughly $0.01–$0.50 depending on the model. The AI will always ask before generating anything and tell you the rough cost. When the credits run out, head back to **fal.ai/dashboard/billing** to top up."

##### Update the subagent templates

If the partner has Content and Design subagents installed (Phase 4), their templates already mention genmedia and check for its availability. No additional template edit needed — they'll auto-detect.

If subagents were installed BEFORE Phase 12E, the templates still work (they check for genmedia at runtime and gracefully fall back if not installed).

##### Hard rules for Phase 12E

- **Opt-in only.** Same posture as Phase 7 (Voice I/O). Never install during initial onboarding — wait for the partner to produce content that needs imagery.
- **Cost transparency is mandatory.** The partner sees actual numbers before paying. No hidden charges.
- **Never paste the API key into chat.** Use the interactive `genmedia setup` prompt or have the partner export it to her environment herself.
- **Don't auto-generate without confirmation.** The skill includes this rule but it's worth restating: every `genmedia run` call must follow a partner's explicit green light.

### Install rule

**Never pre-install creative skills "just in case."** Wait for the user to hit the work, ask the AI for help, then install the relevant skill collaboratively. The AI guides them through:

> *"Looks like you're doing [video / design / a deck / a sales page]. There's a skill for that — `[skill-name]`. Want me to install it? Takes 2 minutes."*

This way every installed skill has been earned by a real task, and the user understands what each one does because they were there when it landed.

### Example creative-tooling stack (one real deployment)

| Category | Installed today | Notes |
|---|---|---|
| 12A Video | video-use, remotion-best-practices, Hyperframes (framework) | Used for HardPath, "Dear Peanut" comparison |
| 12B Design | web-design, design:* (multiple) | Used for landing-page work |
| 12C Documents | anthropic-skills:{docx, xlsx, pptx, pdf}, pdf-viewer:* | Standard set |
| 12D Specialized | landing-page-copywriting, cloffer, claumedian, matt-dicks-storytelling, ben-settle-subject-lines, anti-ai-writing | Heavy for content work |

For [PARTNER_NAME]/[AI_NAME] specifically: she'll likely earn 12A (video-use first, Hyperframes if she goes deep), 12C (pdf at minimum), and 12D's matt-dicks-storytelling for her podcast guest narratives. Park the rest until needed.

---

# OPERATIONAL ONGOING

### Portability & disaster recovery (non-negotiable)

The AI's whole soul is files. The user must be able to recover them on any Mac in ~15 minutes after a crash, theft, or factory reset. This is **not optional** — without it, every conversation, every decision, every skill, every learning evaporates the day the laptop dies.

#### The full inventory of "things that must be backed up"

| What | Where it lives | Critical? | iCloud-synced if folder is in `~/Documents/`? |
|---|---|---|---|
| AI's identity (CLAUDE.md, USER_MANUAL.md) | `~/[ai-name]/` | 🔴 | ✅ |
| Long-term memory (`notes.md`) | `~/[ai-name]/notes.md` | 🔴 | ✅ |
| Subagents | `~/[ai-name]/.claude/agents/` | 🔴 | ✅ |
| Custom skills + learnings.md | `~/[ai-name]/.claude/skills/` | 🔴 | ✅ |
| Personality guide | `~/[ai-name]/personality_guide.md` | 🔴 | ✅ |
| Vault (Phase 9) | `~/Documents/[Vault Name]/` | 🔴 | ✅ |
| API keys / tokens | `~/.config/[ai-name]/.env` | 🟡 | ❌ outside iCloud |
| LaunchAgents / scheduled jobs | `~/Library/LaunchAgents/` | 🟢 | ❌ outside iCloud, but re-creatable from kit |

The 🔴 rows are irreplaceable. The 🟡 row (tokens) is replaceable but inconvenient. The 🟢 row (launchd jobs) is fully re-installable from the kit.

#### Three-layer backup strategy

**Layer 1 — iCloud Drive (mandatory).** All 🔴 files live inside `~/Documents/`, which iCloud Drive auto-syncs to the user's Apple ID. Free tier handles years of markdown-heavy folders. Must be enabled in System Settings → Apple ID → iCloud → iCloud Drive (with "Desktop & Documents Folders" ticked).

**Layer 2 — Token recovery template (mandatory).** Tokens at `~/.config/[ai-name]/.env` are NOT iCloud-synced. Keep a copy of the structure (without secret values) at `~/[ai-name]/_recovery/env-template.txt`. Store the actual secret values in a password manager (1Password, Bitwarden, Apple Passwords). On recovery: copy template back, paste secrets in.

**Layer 3 — Time Machine (optional but recommended).** Plug an external drive in once a week. Time Machine backs up everything including hidden config dirs. Belt-and-suspenders for paranoia-level safety.

#### Recovery on a new / reset Mac (the actual sequence)

Document this for the user in their USER_MANUAL.md:

```
1. Sign in to iCloud with the same Apple ID. Wait 5–15 min for ~/Documents/ 
   to sync.
2. Install Claude Code Desktop (claude.com/code).
3. Install Command Line Tools when macOS prompts (or run xcode-select --install).
4. Open Claude Code → "Open folder" → select ~/[ai-name]/.
5. Re-create ~/.config/[ai-name]/.env from the recovery template + password 
   manager.
6. (If they had Phase 5 persistence + Phase 8 monitoring) re-install launchd 
   plists from the kit. Or skip if they don't need it on the new Mac.
7. Type "Hi [AI_NAME]" — back online with full memory.
```

**~15 minutes** end-to-end for the AI core. Add ~30 min if they need to reinstate Phase 4–8 infrastructure.

#### What the AI itself should do for the user

Whenever a user is at Phase 1 (folder creation), the AI should **proactively ask:**

> *"Is iCloud Drive enabled with Documents syncing? If not, let's enable it before we go further — this is what keeps your AI alive across Mac changes."*

Then verify by running `defaults read com.apple.bird` or asking the user to confirm in System Settings.

This is non-negotiable infrastructure. Treat it like the emergency exit signs in a building — boring to install, catastrophic to omit.

### Rotating tokens / API keys

When the user needs to rotate any credential:

- **Telegram bot token:** update `~/.config/[ai-name]/telegram/.env`. Other scripts (`send-voice-note.sh`) should read from this canonical location with a fallback. **One file to rotate.**
- **OpenAI key:** `~/.config/[ai-name]/.env` as `OPENAI_API_KEY=`. `send-voice-note.sh`, `transcribe.sh`, and skills read from here.
- **ElevenLabs key:** same `.env`. `ELEVENLABS_API_KEY=` and `ELEVENLABS_VOICE_ID=`.

Lesson learned: **don't scatter tokens across `~/.claude/channels/...`, `~/[ai-name]/.env`, and `~/.config/[ai-name]/.env`.** Pick `~/.config/[ai-name]/` as canonical. Symlink or fallback older paths.

### Troubleshooting cheat sheet

Teach the user this one line:

> *"[AI_NAME], something's wrong. Let's troubleshoot together. Here's what I'm seeing: [describe]."*

Their AI can read its own files, check its own config, walk them through fixes. **Most issues resolve in one or two exchanges.** This is the Claude-Claw Care pattern in miniature.

When the AI can't help:

- **AI won't start:** quit Claude Code, reopen, re-trust the folder.
- **AI feels generic:** the CLAUDE.md needs more personality. Read it aloud — if it sounds like a job description, rewrite.
- **AI forgot something:** normal. Teach them: *"[AI_NAME], add to notes.md: [thing]"*
- **Telegram silent:** check launchctl status of the poller + heartbeat jobs. `tail -20 ~/[ai-name]/logs/telegram-poller.log`.
- **No voice replies:** check ElevenLabs API key + ffmpeg installed. Watchdog should've already alerted you.

### Multi-session race (only if Path B isn't being used)

If the user is running multiple Claude Code instances and seeing 409 conflicts in their poller log, two options:
1. **Kill orphan sessions** — `pgrep -fal "claude.*--resume"` to find them, kill the ones they don't recognize.
2. **Uninstall the plugin** — `claude plugin uninstall telegram@claude-plugins-official`. With Path B (standalone poller) the plugin is dead weight; removing it eliminates the orphan-bun-spawn problem permanently.

### When to scale (the partner outgrows their setup)

After 6+ months, the user might want:
- More subagents (a fourth, fifth specialist)
- Better skills (more complex, multi-step)
- The full Hab vault pattern (when their note-taking is rich enough to earn the structure)
- Custom voice (clone their own voice into ElevenLabs Creator tier)
- Cross-Mac access (rare; the AI runs per-Mac)

Don't push these. Wait for the user to ask.

---

# PHASE-BY-PHASE INSTALL CHECKLIST

For someone setting up their nth partner AI, this is the actual order of operations:

```
[ ] PRE-FLIGHT
[ ] Subscriptions: Claude Pro, OpenAI API, ElevenLabs (if voice)
[ ] Two questions answered, name picked, hardware verified

[ ] PHASE 1 — Identity & Folder (15 min)
[ ] Claude Code Desktop installed
[ ] Command Line Tools installed
[ ] Folder created at ~/[ai-name]/ (NOT ~/[ai-name]/ — must be in Documents for iCloud backup)
[ ] Kick-off skill bundled at ~/[ai-name]/.claude/skills/kick-off/SKILL.md
[ ] CLAUDE.md has the "first-run check" instruction at the top (so AI auto-triggers kick-off)

[ ] PHASE 1B — Portability & Recovery (5 min, mandatory)
[ ] iCloud Drive enabled in System Settings → Apple ID → iCloud → iCloud Drive (with Desktop & Documents folders ticked)
[ ] First iCloud sync complete (verify by checking the cloud icon next to ~/Documents/ in Finder)
[ ] Token recovery template at ~/[ai-name]/_recovery/env-template.txt
[ ] User's API keys saved in their password manager (1Password / Bitwarden / Apple Passwords)
[ ] Recovery sequence documented in USER_MANUAL.md
[ ] (Optional) Time Machine + external drive enabled

[ ] PHASE 2 — Personality Guide (1–2 hr, can be async)
[ ] 2–3 hr longform content sourced
[ ] Transcripts produced
[ ] Personality guide drafted via Claude
[ ] Saved to ~/[ai-name]/personality_guide.md

[ ] PHASE 3 — CLAUDE.md (45 min, conversation-led)
[ ] Identity section drafted
[ ] Voice rules + bans listed
[ ] @-import to personality_guide.md
[ ] First "Hi [AI_NAME]" passes the read-aloud test

[ ] PHASE 4 — Subagents (30 min)
[ ] ~/[ai-name]/.claude/agents/ created
[ ] research.md, content.md, assistant.md, design.md installed + tuned
[ ] Delegation test passes

[ ] PHASE 5 — Persistence (30 min)
[ ] start.sh + plist installed
[ ] launchctl loaded
[ ] tmux ls confirms session

[ ] PHASE 6 — Telegram Bridge (60 min)
[ ] Bot token from BotFather
[ ] Token saved to ~/.config/[ai-name]/telegram/.env
[ ] User ID found, allowlist.txt populated
[ ] poll-telegram.sh installed + chmod +x
[ ] Launchd job loaded
[ ] check-telegram skill installed
[ ] Test message round-trips successfully

[ ] PHASE 7 — Voice I/O (30 min)
[ ] OpenAI API key in ~/.config/[ai-name]/.env
[ ] ElevenLabs key + voice ID in same .env
[ ] transcribe.sh + send-voice-note.sh in ~/[ai-name]/scripts/
[ ] ffmpeg installed (brew install ffmpeg)
[ ] SKILL.md updated to default to voice (under 200 words rule)
[ ] Test voice round-trip works

[ ] PHASE 8 — Reliability (45 min)
[ ] Heartbeat-check.sh + plist + launchctl
[ ] Inbox-watchdog.sh + plist + launchctl
[ ] Quiet hours + cooldown configured
[ ] Modal alert tested (force-fail one watchdog, see modal)

[ ] PHASE 9 — Vault (60–90 min)
[ ] Obsidian installed
[ ] Vault created, scaffold copied in
[ ] Symlink from ~/[ai-name]/vault
[ ] CLAUDE.md updated to point at vault

[ ] PHASE 10 — Skills (ongoing)
[ ] First skill built collaboratively with the AI
[ ] User knows how to ask AI to build new skills
[ ] FIRST SKILL HAS A learnings.md baked in from day one (Phase 11B pattern)

[ ] PHASE 11 — Operational OS (compounding layer; install in order, not all at once)
[ ] 11B — Learnings loop on ONE skill first (morning-brief recommended)
[ ] 11C — Wrap-up skill installed (~/.claude/skills/wrap-up/)
[ ] 11C auto-trigger ownership baked into SKILL.md (AI watches for end-of-session signals; user doesn't have to remember to say "wrap up")
[ ] 11A — Bootstrap "start here" skill (extend context-interview)
[ ] 11D — SessionStart heartbeat hook (deferred until pain shows up)

[ ] PHASE 12 — Creative tool skills (install on demand, not pre-installed)
[ ] 12A Video — video-use / Remotion / Hyperframes (only if they do video)
[ ] 12B Design — web-design, canvas-design, design:* (only if they do visual)
[ ] 12C Documents — docx, xlsx, pptx, pdf (most non-developers need at least 2 of these)
[ ] 12D Specialized — landing-page-copywriting, cloffer, claumedian, matt-dicks-storytelling, ben-settle-subject-lines, anti-ai-writing (one per real domain need)
```

---

# THE HONEST SPEECH AT THE END

When you're handing over the keys, paraphrase but hit these notes:

1. **"This is yours. It lives on your Mac. No subscription beyond Claude itself + a few €/month in API fees."**
2. **"It's not magic. It will forget things between sessions unless you write them down — that's what `notes.md` and the vault are for."**
3. **"Talk to it like a colleague, not Google. Full sentences. Real context. Real feedback."**
4. **"When something feels off, ask the AI to troubleshoot itself first. It can read its own files. Most things resolve in one or two messages."**
5. **"I built [my AI]. You're building [their AI]. Same patterns, your voice. Make them yours."**

---

*This guide lives at: `<repo-root>/SETUP GUIDE (Input Ai)/playbook.md`. Update it after each new partner setup — every surprise is a future lesson for the next install.*
