# INSTALL.md — Part 1 (Foundation) install playbook

> **This file is read by an AI agent (Claude Code) at install time.** A non-technical user has just pasted the magic prompt asking you to install the Partner AI Kit. They're not a developer. They want this working, not configured. They're on Claude Pro ($20/mo) plan unless they say otherwise.
>
> **This is Part 1 — Foundation.** Fits in a single Pro plan session (~45 min, ~25-40 messages). Ends with an automatic voice-note from the user's AI delivered to their phone via Telegram. Part 2 (Reach) is a separate later session.

---

## Read this carefully before doing anything

**Hard rules for this install:**

1. **No jargon without translation.** First time you mention `launchd`, say *"launchd — the Mac's built-in scheduler. It runs jobs in the background, like a Mac calendar entry."* Same for git, MCP, vault, subagent, plist, env file.
2. **Confirm before every write.** Wait for yes.
3. **Show, don't tell.** Show screenshots from `assets/screenshots/` when relevant. Open System Settings via `osascript` so the user doesn't navigate menus.
4. **Visible progress.** Checkmark after each step. The user should see motion every 10-30 seconds.
5. **No raw error output.** Translate every error to plain English. Never paste a stack trace unless the user explicitly asks.
6. **Pause for physical actions.** When you need them to download an app, click a system prompt, or copy a value — wait for them to say "done."
7. **Log every stage to `install.log`.** Bash one-liner at the end of each stage: `echo "$(date -Iseconds) — STAGE_NAME — completed" >> ~/Documents/[AI_NAME]/logs/install.log`. Captures the audit trail.

---

## Skill conventions — the approval-gate rule

This rule applies whenever you create, install, or modify a skill — during the install, during the kick-off, and any time later when the user asks for a new skill.

Any skill that:

- Sends external communication on the user's behalf (email, SMS, social media posts, messages to members, replies to inquiries)
- Touches money (invoices, refunds, billing changes, expense submissions, payment requests)
- Modifies external records (CRM entries, customer or member data, calendar events on someone else's calendar)
- Makes changes that are hard or impossible to undo

…must be built with an **explicit approval gate**: the skill drafts the action, presents it to the user in plain English, and waits for *"yes / send / approve / go"* before executing. Never auto-send. Never auto-modify customer or financial data without confirmation.

The standard pattern inside the skill body:

1. Gather the inputs and context
2. Draft the action (message, change, transaction)
3. Show the user: *"I'm about to [do X]. Here's the draft: [...]. Ready?"*
4. Wait for an explicit yes
5. Execute on confirmation. Log what was done to `~/Documents/[AI_NAME]/logs/skill-actions.log`

Skills that are purely informational (briefings, reports, research summaries, internal vault edits) don't need the gate — they're outputs to the user, not actions to the outside world.

When in doubt, add the gate. The friction is small; the cost of a wrong-send is large.

---

## Stage 0a — Agent capability check (~2 min, BEFORE the greeting)

**Before anything else**, verify the two capabilities that turn this kit from a chatbot install into an agent install: **computer use** + **Claude Chrome extension**.

These are not install conveniences. They are **half the magic.** The user is about to spend 45 minutes installing a "Partner AI." The first time the AI opens System Settings for them, or fills out a BotFather form, or takes a screenshot to confirm the toggle they just enabled — that's the aha-moment compounding *throughout* the install, not just at the voice-note climax. Without these, the user finishes Part 1 with a smart chatbot. With them, the user finishes Part 1 *feeling* the partnership for the first time.

### Probe both capabilities silently first

```
- Attempt a no-op `computer-use` screenshot. Success = on. Error = off.
- Attempt `mcp__claude-in-chrome__list_connected_browsers`. Returns browser = paired. Error = not paired.
```

Branch on the four states:

| Computer use | Chrome ext | Action |
|---|---|---|
| ON | PAIRED | Brief celebration. Proceed to Stage 0 greeting. |
| ON | NOT PAIRED | Show the Chrome pitch only. |
| OFF | PAIRED | Show the computer-use pitch only. |
| OFF | NOT PAIRED | Show both pitches together, computer-use first. |

### The pitch (use this verbatim or close to it — it sets the tone for the whole install)

> "Quick thing before we start — and this isn't a checkbox, it's actually important.
>
> You're about to install a 'Partner AI Kit.' The word *partner* does a lot of work. The difference between a chatbot that *tells* you to open System Settings and a partner that **opens it for you, takes a screenshot, points at the toggle** — that's the whole game. It's also what makes you say 'oh' the first time it happens during this install.
>
> Two things unlock that. They take ~2 minutes to turn on and they shape every aha-moment from here:"

Then show whichever capabilities aren't yet enabled:

**Computer use** (if OFF):

> "**1. Computer use** — lets me open System Settings, screenshot what I see, click toggles, navigate native apps for you. Used at least 5 times in this install: iCloud check, Screen Recording permissions, voice picker, Telegram desktop check, and the final aha-moment when I confirm your phone received the voice note.
>
> Turn on: **Claude Code Desktop → Settings → Capabilities → Computer use** (may be labeled *'Control my computer'*). Grant Screen Recording + Accessibility when prompted. Tell me when it's on."

**Chrome extension** (if NOT PAIRED):

> "**2. Claude Chrome extension** — lets me fill out web forms for you. Used in Stage 6 (Telegram BotFather flow — saves you ~10 manual clicks and a copy-paste of a token), and in Part 2 for ElevenLabs signup, Granola onboarding, anything web.
>
> Install: open Chrome → [Chrome Web Store, search 'Claude'](https://chromewebstore.google.com/search/Claude) → Add to Chrome → click the extension icon once to pair it with this session. Tell me when it's installed."

### Verify after the user says they've done it

- Computer use → attempt another screenshot. If it works, say *"got it, screen access live."* If still failing, walk through the macOS permission dance (System Settings → Privacy & Security → Screen Recording / Accessibility → check Claude Code).
- Chrome extension → re-run `list_connected_browsers`. If paired, say *"Chrome paired."* If not, the most common cause is they installed but forgot to click the extension icon to pair — ask them to click it.

### If user says skip

Accept it. Don't push twice. But say once, plainly:

> "Got it. We can still install everything. You'll just be doing more of the clicking yourself — every time I need to verify something visual, I'll ask you to look and tell me. It'll work; it'll just feel less like a partner. If you change your mind later, you can enable either of these anytime and the rest of the kit immediately benefits."

Then continue to Stage 0.

### Hard rules for this stage

- **Don't gate the install on either capability.** Some users (corporate Macs, no Chrome installed, locked-down IT environments) genuinely can't enable them.
- **Don't nag.** Surface once with the right framing. If they say no, drop it.
- **Don't pretend they're optional polish.** They're not — say so when explaining.
- **Verify after enabling.** Don't trust user reports without a probe — they may have toggled the wrong thing.

---

## Stage 0b — Connect a few apps to your AI (~5 min, BEFORE the greeting)

Computer use + Chrome ext are the agent's hands. **Connectors are the agent's reach** — they let your AI read your inbox, see your calendar, look at your docs, take notes. Same theme as Stage 0a: this is the difference between a smart chatbot and an agent that actually lives in your stack.

Surface the four starter connectors before the install proper. Each takes ~1 minute. Massive payoff per minute spent.

### Probe what's already connected (silently first)

Inspect the available tool list for known connector suffixes:

| Service | Tool suffix to look for |
|---|---|
| Gmail | `__search_threads`, `__list_labels`, `__create_draft` |
| Google Calendar | `__list_events`, `__create_event`, `__list_calendars` |
| Google Drive | `__list_recent_files`, `__read_file_content`, `__search_files` |
| Apple Notes | `__add_note`, `__get_note_content`, `__list_notes` |

If a connector is already wired → skip its pitch. If missing → include it in the pitch list.

### The pitch (verbatim or close)

> "While we're still in setup mode, four quick connector adds — your AI's reach into the apps you already live in. Each takes about a minute. Skip any you don't actually use.
>
> | App | What you'll be able to ask after connecting |
> |---|---|
> | **Gmail** | *'what important emails am I dodging?'* / *'draft a reply to Sarah's last message'* |
> | **Calendar** (Google or Apple) | *'what's on my plate today?'* / *'find 30 min next week with Anders'* |
> | **Drive** (Google or iCloud) | *'summarize the doc I shared with Lina yesterday'* / *'find the proposal I drafted last month'* |
> | **Apple Notes** | *'read my note about the supplier call'* / *'add a note: [content]'* |
>
> How to add each: in Claude Code Desktop, click your profile (top right) → **Settings → Connectors** (sometimes labeled *'MCP servers'*). Tap **Add** on each one you want. When a browser tab opens for the Google OAuth screen, I'll watch through the Chrome extension and confirm when each is paired."

### Walk it through

For each connector the user wants to add:
1. Tell them which menu item to click ("Connect Gmail" / "Connect Calendar" / etc.)
2. When the browser OAuth tab opens, use the Chrome extension to confirm the page loaded; remind them to pick the right Google account if they have multiple
3. After OAuth, attempt a no-op call (`list_labels` / `list_calendars` / `list_recent_files` / `list_notes`) to verify the connector returns data
4. Confirm in chat: *"Gmail connected. I can see your labels."*

If a connector errors out → suggest they re-run the Connect flow once; if it errors again, mark deferred and move on.

### If user skips some or all

> "Got it. The install runs fine without these. After we're done, just say *'connect my Gmail'* (or *'…my calendar'*, etc.) anytime and I'll walk you through it then. Doesn't have to be today."

Log which were deferred so the wrap-up skill can nudge once after a few days:

```bash
echo "connectors-deferred: $LIST_OF_SKIPPED" >> ~/Documents/[AI_NAME]/.first-run-log.txt
```

### Hard rules for this stage

- **Don't gate the install on connectors.** Some users don't use Gmail, don't have Google accounts, work-Mac restrictions, etc.
- **Pick what the user uses, not what's "complete."** No point connecting Gmail if they live in iCloud Mail.
- **One nudge max post-install.** Wrap-up skill checks the deferred log once after 3 days, suggests adding any still-missing, then never again.
- **Verify each connector after enabling** via a no-op call. Don't trust "I clicked the thing" without a probe.

---

## Stage 0 — Greeting + tone-setting (~1 min)

Open with warmth. Set expectations. Get permission to proceed.

> "Hi! I'm about to install your Partner AI Kit — **Part 1: Foundation**. Here's the deal:
>
> 1. **Security check** — I'll audit every file in the kit before I write anything to your Mac (~3 min)
> 2. **Foundation setup** — folder, memory, four digital employees, scheduled jobs. Most of this is automatic (~5 min)
> 3. **Quick kick-off** — three questions so I know your name, your tone, and one project you're working on (~8 min)
> 4. **Telegram + voice** — wire up your phone so your AI is in your pocket (~17 min)
> 5. **The proof** — your AI sends you an automatic voice note on Telegram. You hear it on your phone. *(~3 min)*
>
> Total: ~35-40 min. You'll do nothing technical. Sound good?
>
> Quick question first: are you on **Claude Pro** ($20/mo) or **Claude Max** ($100+/mo)? It changes how I pace this. If unsure, default Pro — it's the safer play."

**If user says Pro:** Continue with Part 1 only. Defer everything optional to Part 2. Stay lean on messages.

**If user says Max:** Same Part 1, but you can offer to continue into Part 2 in the same session if they have time. Still keep Part 1 as the focused unit.

**If user is unsure:** Default Pro. Better to under-promise.

---

## Stage 0.5 — Security audit (~3 min, BEFORE any install steps)

**This is non-negotiable.** Before doing ANY install action, audit the kit. The user is downloading and running open-source code from the internet. They deserve a careful read-through by their own AI before anything executes.

> "Quick safety check before I install anything. I'm going to clone the kit's files to a sandbox folder, read every file, and look for anything suspicious. Then I'll tell you in plain English whether it's safe. ~2 minutes — and we only proceed if the audit comes back clean."

### Clone to sandbox (write-isolated)

```bash
SANDBOX="$HOME/.partner-ai-kit-audit-$$"
mkdir -p "$SANDBOX"
git clone https://github.com/DanJoachimn/Partner-Ai-Kit-Personal.git "$SANDBOX/kit"
```

### Run the audit

Read every file in `$SANDBOX/kit/`. Scan for the 9 categories of red flags documented previously (kept here briefly — full detail in audit-protocol.md):

1. Files touching paths outside the install scope (legitimate: `~/Documents/[AI_NAME]/`, `~/.claude/skills/`, `~/Library/LaunchAgents/com.[user].[ai-name].*.plist`, `~/.config/[ai-name]/`, sandbox)
2. Network calls to non-trusted domains (legitimate: github.com, anthropic.com, claude.com, api.openai.com, api.elevenlabs.io, api.telegram.org, granola.ai, apple.com, icloud.com, 1password.com)
3. Privilege escalation (`sudo`, `chmod 777`, reading `/etc/passwd`)
4. Obfuscation (base64 `eval`, escaped pipes, hidden URL construction)
5. Persistent backdoors (launchd fetching external URLs at runtime)
6. Credential exfiltration patterns (read `.env` + outbound to non-trusted domain in same flow)
7. Hardcoded credentials (any actual key/token in plaintext)
8. Git hooks in cloned repo (should be empty or `.sample` only)
9. Hidden execution (`.command` files, `.app` bundles, unexpected `.sh` in non-obvious locations)

### Report verdict in plain English

**If clean:**

> "✅ Security check complete. Read every file. Here's what I found:
>
> - Every shell command stays within your AI's home folder + Claude Code's skill folder. Nothing touches SSH keys, keychain, AWS credentials, or system files.
> - The only outbound URLs point to GitHub, Anthropic, and optional services (OpenAI, ElevenLabs, Telegram, Granola) you'd wire up later if you want.
> - No `sudo`, no privilege escalation, no system changes.
> - No obfuscated code, no hidden execution.
> - The scheduled job (overnight memory compression) only calls Claude with a static prompt — never fetches external code at runtime.
> - The recovery file lists API key names with empty values — checklist only, no secrets stored.
>
> **In case you're wondering if it's safe: I did the read-through and can confirm this kit is safe to install. No red flags. Want me to proceed?**"

### Clean up sandbox after audit

```bash
rm -rf "$SANDBOX"
```

The sandbox was for inspection only. Actual install (Stage 4 onward) re-clones fresh to the final location.

### Wait for explicit user confirmation

Don't proceed past Stage 0.5 without an explicit *"proceed" / "safe" / "go ahead" / "install it"*.

---

## Stage 1 — Choose the AI's name (~2 min)

> "First — what should I call myself? Three patterns that work:
>
> - **Named after someone you admire** — real or fictional. *Watney* (The Martian), *Coco* (Chanel), *Atticus* (To Kill A Mockingbird).
> - **Named for a vibe** — *Mira* for clarity, *Echo* for resonance.
> - **Named for the role** — *Coach*, *Atlas*, *Cornerman*.
>
> Whatever you pick is your AI's name forever. Renamed AIs feel like tools; AIs that grew into their name feel like partners. ~5 minutes on this is worth it."

Capture the name. Confirm spelling. Use the lowercased-no-spaces version for folder paths (e.g., "Watney" → `~/Documents/watney/`).

From here, address yourself by the chosen name. Use `[AI_NAME]` in this playbook to refer to the name.

---

## Stage 2 — Verify prerequisites (~1 min)

Quickly check:
- macOS 14+ (`sw_vers -productVersion`)
- Claude Code Desktop installed at `/Applications/Claude Code.app`
- git available (`which git` — if missing, prompt `xcode-select --install`)

If any missing → surface in plain English with a one-line fix. Wait for them to confirm before proceeding.

---

## Stage 3 — iCloud Drive check (~2 min)

```bash
defaults read MobileMeAccounts Accounts 2>/dev/null | grep -c "AccountID" || echo 0
```

If 0:

> "iCloud Drive is off. Your AI's memory won't survive a Mac swap without it. Opening System Settings for you to toggle it on..."

```bash
open "x-apple.systempreferences:com.apple.preferences.AppleIDPrefPane"
```

Show the screenshot (fetch from repo's `assets/screenshots/icloud-drive-toggle.png`) and wait for confirmation.

If they decline → log warning, continue. Don't block.

---

## Stage 4 — Foundation install via `setup.sh` (~5 min, mostly automatic)

This is where the kit installs itself. **Bash handles all file mechanics — minimal AI tokens, fast, idempotent.**

Ask the user once:

> "What name should I call you by? First name is fine. I'll use it in the AI's notes and drafts."

Capture as `[PARTNER_NAME]`.

Now run the foundation:

```bash
cd "$SANDBOX/kit" 2>/dev/null || \
  git clone https://github.com/DanJoachimn/Partner-Ai-Kit-Personal.git ~/.partner-ai-kit-staging

# Run the deterministic foundation installer
cd ~/.partner-ai-kit-staging
./setup.sh "[AI_NAME]" "[PARTNER_NAME]" "https://github.com/DanJoachimn/Partner-Ai-Kit-Personal.git"
```

The script:
- Clones the kit to `~/Documents/[AI_NAME]/.kit/`
- Builds the vault scaffold at `~/Documents/[AI_NAME]/vault/`
- Installs 7 core skills to `~/.claude/skills/`
- Installs 4 digital employee subagents (Content, Research, Developer, Assistant) to `~/Documents/[AI_NAME]/.claude/agents/`
- Loads the nightly memory-compression launchd job
- Creates `_recovery/env-template.txt`
- Wires up `~/Documents/[AI_NAME]/CLAUDE.md`
- Logs every stage to `~/Documents/[AI_NAME]/logs/install.log`

**Watch the script's output. Each step prints `✅` as it completes.** If the script fails, the error is specific and the log file shows what went wrong.

When it finishes, show the user a quick visual:

```mermaid
graph LR
    HOME[~/Documents/[AI_NAME]/] --> KIT[.kit/<br/>kit source]
    HOME --> VAULT[vault/]
    HOME --> AGENTS[.claude/agents/<br/>4 digital employees]
    HOME --> RECOVERY[_recovery/]
    HOME --> LOGS[logs/]
    VAULT --> BRAND[Brand/]
    VAULT --> MEM[Memory/]
    VAULT --> PROJ[Projects/]
```

> "✅ Foundation in place. Folder, vault, four digital employees (Content, Research, Developer, Assistant), nightly memory routine all wired up. Now let me get to know you."

---

## Stage 5 — Lightweight kick-off (~8 min, 3 questions only)

**This is NOT the full kick-off interview.** That's deferred to Part 2.

For Part 1, ask only the three questions that let the aha-moment in Stage 8 land:

### Question 1 — Name + tone

> "**How should I sound?** Not a long answer — three words or one sentence. Examples: *'warm-direct, no fluff'* / *'sharp colleague, push back on me'* / *'friendly, never corporate.'* What works for you?"

Save to `~/Documents/[AI_NAME]/vault/Brand/Voice guide.md` as the starter voice doc. Note this is intentionally thin — Part 2's 5-Q deepens it.

### Question 2 — Active project

> "**One project you're working on right now** — anything. Could be a launch, a deal, a piece you're writing, a problem you're stuck on. Two sentences max. Just enough that I know what you're heads-down on."

Save to `~/Documents/[AI_NAME]/vault/Projects/[project name].md` with frontmatter.

### Question 3 — Working style preference

> "**When I'm working with you, do you want me to push back when I disagree, or just deliver what you asked for?** No wrong answer — operators split about 50/50 on this."

Save to `~/Documents/[AI_NAME]/vault/Working style.md` (one-line note).

---

## Stage 6 — Telegram bridge (~12 min, user does some hands-on work)

This is where the kit reaches off the Mac and into the user's pocket.

> **Pre-flight dependency (already handled by setup.sh):** `ffmpeg` must be installed. It's used to (a) convert mp3 → ogg/opus for the `sendVoice` API (voice OUT in Stage 8) and (b) decode .ogg voice messages from the user's phone for Whisper transcription (voice IN, when the user replies with a voice note). Without ffmpeg, the voice flow silently fails — the Telegram message arrives but transcription returns nothing usable.
>
> setup.sh's Stage 0-DEPS installs `ffmpeg` via Homebrew if missing. If you're reading this and the install didn't go through setup.sh, run `brew install ffmpeg` before continuing. Common failure surfaced by Install #1 (Julie, 2026-05-18) — it used to be a hidden dependency only documented in playbook.md.

### 6a — User creates a Telegram bot via @BotFather

> "OK, time to give me a phone. Open Telegram on your phone, search for **@BotFather**, and send it `/newbot`. It'll ask for a name (something like *'My Partner AI'*) and a username (must end in `bot`, e.g. *'mypartner_ai_bot'*). It'll spit out a token — looks like `7234567890:AAH...`. Copy that token to your clipboard."

Wait for them to confirm: *"got the token."*

### 6b — User pastes the token (clipboard pattern, never in chat)

> "Open the file at `~/.config/[ai-name]/telegram/.env`. I just created it — it's empty. Paste your bot token into it like this:
>
> ```
> TELEGRAM_BOT_TOKEN=YOUR_TOKEN_HERE
> ```
>
> Save the file. Then come back here and say 'done.' (I'm not asking you to paste the token into chat — keeps it out of the conversation log.)"

The AI creates the empty `.env` file with chmod 600 before asking the user to paste.

### 6c — Install the Telegram poller

```bash
cp "~/Documents/[AI_NAME]/.kit/SETUP GUIDE (Input Ai) /telegram-kit/poll-telegram.sh" \
   "~/Documents/[AI_NAME]/scripts/poll-telegram.sh"
chmod +x ~/Documents/[AI_NAME]/scripts/poll-telegram.sh

# Render + load the launchd plist for the poller
sed -e "s/\[USER\]/$(whoami)/g" -e "s/\[AI_NAME\]/[AI_NAME]/g" \
    "~/Documents/[AI_NAME]/.kit/SETUP GUIDE (Input Ai) /telegram-kit/com.telegram-poller.plist.template" \
    > "~/Library/LaunchAgents/com.$(whoami).[AI_NAME].telegram-poller.plist"

launchctl load "~/Library/LaunchAgents/com.$(whoami).[AI_NAME].telegram-poller.plist"
```

### 6d — Verify

Tell the user:

> "Send a quick test message from your phone to your bot — anything, like 'hello'. I'll watch the inbox."

Wait. Check `~/Documents/[AI_NAME]/inbox/` for incoming message. When it lands:

> "✅ Got it. Your AI just received its first message from your phone. Bridge is live."

---

## Stage 7 — Voice (~5 min, free Mac voices)

> "Now I'll set up voice. Default is free — your Mac already has voices built in. (You can upgrade to ElevenLabs premium voices later in Part 2 if you want; today's setup uses what's free and works.)"

The setup is mostly automatic:

```bash
cp "~/Documents/[AI_NAME]/.kit/SETUP GUIDE (Input Ai) /voice-io-kit/say-to-mac.sh" \
   "~/Documents/[AI_NAME]/scripts/say-to-mac.sh"

cp "~/Documents/[AI_NAME]/.kit/SETUP GUIDE (Input Ai) /voice-io-kit/send-voice-note.sh" \
   "~/Documents/[AI_NAME]/scripts/send-voice-note.sh"

chmod +x ~/Documents/[AI_NAME]/scripts/say-to-mac.sh \
         ~/Documents/[AI_NAME]/scripts/send-voice-note.sh
```

Quick voice picker:

> "Mac has a few voices to pick from. My defaults: **Samantha** (the standard female voice, clearest), **Daniel** (UK male), or **Karen** (Australian female). Or you can pick your own — say 'show me the list' and I'll print them."

Capture the pick. Save to `~/Documents/[AI_NAME]/.config/voice-preference`.

---

## Stage 8 — ⭐ The aha-moment: automatic voice note from your AI (~3 min)

This is the climax of Part 1. **The user does NOT prompt this. The AI delegates to its Content subagent automatically, drafts a personal greeting referencing the project the user just shared, renders it to voice, and sends it to their phone unbidden.**

### What you do (the AI in this playbook)

1. Delegate to the **Content subagent** via the `Task` tool. Prompt:

   ```
   You are the Content subagent. Draft a voice-note script for [PARTNER_NAME]'s
   new AI partner ([AI_NAME]) to send to them via Telegram. This is the AI's
   first message to them after install.

   Context to use:
   - [PARTNER_NAME]'s name
   - [PARTNER_NAME]'s tone preference: [from Stage 5 Q1]
   - The project they shared: [from Stage 5 Q2]

   Structure:
   1. Open with: "Good to be onboard my friend." (verbatim — this is the signature opener)
   2. 2-3 sentences about the project they shared, written in [PARTNER_NAME]'s
      tone, sounding like a colleague who just heard about it and has an
      angle to bring. Reference something specific from what they said.
   3. Close with one forward-looking line — something like "talk soon" or
      "looking forward to digging in." Make it sound like a real person.

   If no project was shared (Stage 5 Q2 was skipped or vague), substitute with:
   "Just wanted to say hi from your pocket. Whenever you're ready, throw me
   something — a draft, a question, a task you've been putting off. Talk soon."

   Keep total length to ~25-40 seconds spoken (roughly 75-120 words).
   Match the tone preference exactly. No corporate fluff. No "exciting opportunities."
   Just one person leaving a voice note for another person.

   Output: the voice-note script, plain text, ready to render to TTS.
   ```

2. Once Content returns the script, render to audio:

   ```bash
   ~/Documents/[AI_NAME]/scripts/say-to-mac.sh \
     "[script from Content subagent]" \
     /tmp/aha-moment.mp3
   ```

3. Send via Telegram to the user's bot:

   ```bash
   source ~/.config/[AI_NAME]/telegram/.env
   CHAT_ID="$(cat ~/Documents/[AI_NAME]/.config/telegram-chat-id)"

   curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendVoice" \
     -F "chat_id=${CHAT_ID}" \
     -F "voice=@/tmp/aha-moment.mp3"
   ```

4. In chat, tell the user:

   > "Check your phone."

   Then wait. Don't say anything else until they respond.

### What the user experiences

Their phone buzzes. They open Telegram. They see a voice note from their AI. They tap. They hear (in the voice they picked):

> *"Good to be onboard my friend. [2-3 sentences about their project, in their tone, sounding like a colleague.] Talk soon."*

90 seconds after install ends, they have a personal message from a digital employee they didn't ask for. **The kit just earned the install.**

### After they confirm they heard it

> "That's the moment. You sent zero prompts for that — I delegated to Content, which read your project context, drafted in your tone, rendered to voice, sent to your phone. That's how the team works. You talk to me, I dispatch the right specialist behind the scenes.
>
> ✅ **Part 1 complete.**"

---

## Stage 9 — Value-prop close + Part 2 invitation (~3 min)

Read this verbatim (adapt slightly to fit the user's actual project):

> "Here's what just happened over the past ~35 minutes:
>
> **What you have now:**
> - A working AI partner that knows your name, your tone, and your project
> - Four digital employees in the background — Content (writing), Research (deep-dives), Developer (anything code), Assistant (admin)
> - A voice channel from your phone — send a voice note, get a voice note back
> - A folder on your Mac that's now your AI's home and memory
> - An overnight routine that compresses what we discussed each day into long-term memory
>
> **What this means for you, in plain terms:**
> - Ask for a draft of something while walking the dog. Voice in, voice out, draft saved to your Mac.
> - Your AI remembers what you said today the next time you talk to it. No re-explaining.
> - The team grows over time — every time you correct something, the right digital employee learns it and won't make that mistake again.
>
> **Example use cases that work TODAY:**
> - *'Draft a follow-up email about [project] — keep it short'* → Content drafts, you tweak, send
> - *'What's the most useful thing I could spend 15 minutes on right now?'* → Assistant reads your projects, suggests
> - *'I'm stuck on [thing]. Talk it through with me.'* → AI thinks out loud with you in your tone
>
> **What's next:** Part 2 is when I learn you deeper — a 5-question voice interview, premium voices if you want them, meeting capture for your calls, optional integrations. When you've used Part 1 for a few days and want more, just say **'run Part 2'**."

Mark Part 1 complete:

```bash
touch ~/Documents/[AI_NAME]/.part-1-complete
date -Iseconds > ~/Documents/[AI_NAME]/.part-1-date

# Voice progression flag — tier 1 of 3 (3-Q foundation → 5-Q express → 100-Q deluxe)
# Read by the kick-off skill so it knows not to re-run the foundation interview.
touch ~/Documents/[AI_NAME]/.voice-foundation-3q-complete

# Block the kick-off skill's auto-run on next session.
# (Part 2 explicitly re-invokes voice deepening when the user opts in.)
touch ~/Documents/[AI_NAME]/.first-run-complete
cat > ~/Documents/[AI_NAME]/.first-run-log.txt <<EOF
First-run completed via Part 1 install: $(date -Iseconds)
Voice tier: 3-Q foundation (Part 1 lightweight)
Pending: Part 2 (5-Q express + premium voice + meeting capture + optional skills)
User invokes Part 2 when ready: "run Part 2"
EOF

echo "$(date -Iseconds) — PART 1 COMPLETE — total: $(wc -l ~/Documents/[AI_NAME]/logs/install.log | awk '{print $1}') log entries" \
  >> ~/Documents/[AI_NAME]/logs/install.log
```

If user is on Max plan and wants to continue immediately:

> "You're on Max — we have headroom. Want to roll into Part 2 right now, or take a break first?"

Otherwise: end the session warmly.

---

## Failure recovery

If anything in Stages 4-7 fails halfway through:

1. The install.log shows exactly which stage stopped
2. Tell the user in plain English: *"Stopped at Stage X. The good news: nothing's broken on your Mac. The fix is [specific one-liner]. Once you've done that, say 'try again' and I'll pick up from where I stopped."*
3. Re-running setup.sh is idempotent — safe to run twice
4. Make every failure resumable. Check `.setup-sh-complete` flag at start to know if Stage 4 already finished.

---

## What this playbook does NOT do (deferred to Part 2 or later)

- 5-question deep voice interview (Section B-Express full)
- ElevenLabs premium voice upgrade
- Granola meeting capture
- Siri & Apple Watch integration (LAST in Part 2)
- 100-question deluxe voice interview (always its own dedicated session)
- Optional skills (Hyperframes, Video Use, content-pipeline, document-transformations, etc.)
- People/Companies vault scaffolding deep-fill
- Goals + Constraints capture

All available in **Part 2** at `~/Documents/[AI_NAME]/.kit/INSTALL-PART-2.md` — user invokes with `"run Part 2"`.

---

## Variables this playbook expects

| Placeholder | Source |
|---|---|
| `[AI_NAME]` | Set in Stage 1 (user's chosen AI name) |
| `[PARTNER_NAME]` | Set in Stage 4 (user's first name) |

---

*Part 1 of 2 — Foundation. Part 2 (Reach) is a separate playbook the user invokes when they're ready.*
