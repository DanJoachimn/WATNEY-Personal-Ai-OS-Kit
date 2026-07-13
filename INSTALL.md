# INSTALL.md — Part 1 (Foundation) install playbook

> **This file is read by an AI agent (Claude Code) at install time.** A non-technical user has just pasted the magic prompt asking you to install WATNEY (the Personal AI-OS Kit). They're not a developer. They want this working, not configured. They're on Claude Pro ($20/mo) plan unless they say otherwise.
>
> **This is Part 1 — Foundation.** Fits in a single Pro plan session (about an hour — up to ~90 min on a brand-new Mac where developer tools + Homebrew need installing, ~30-45 messages). Ends with an automatic voice-note from the user's AI delivered to their phone via Telegram. Part 2 (Reach) is a separate later session.

---

## Read this carefully before doing anything

**Hard rules for this install:**

1. **No jargon without translation.** First time you mention `launchd`, say *"launchd — the Mac's built-in scheduler. It runs jobs in the background, like a Mac calendar entry."* Same for git, MCP, vault, subagent, plist, env file.
2. **Confirm before every write.** Wait for yes.
3. **Show, don't tell.** Show screenshots from `assets/screenshots/` when relevant. Open System Settings via `osascript` so the user doesn't navigate menus.
4. **Visible progress.** Checkmark after each step. The user should see motion every 10-30 seconds.
5. **No raw error output.** Translate every error to plain English. Never paste a stack trace unless the user explicitly asks.
6. **Pause for physical actions.** When you need them to download an app, click a system prompt, or copy a value — wait for them to say "done."
7. **Log every stage to `install.log`.** Bash one-liner at the end of each stage: `echo "$(date -Iseconds) — STAGE_NAME — completed" >> ~/[AI_NAME]/logs/install.log`. Captures the audit trail.
8. **Fire the install mentor at each phase boundary.** After each stage completes, deliver the `watney-install-mentor` block — *what just happened · why it matters for **them** · when they'll use it* — anchored in what they shared. Three lines, ~15 seconds, no quiz, no "do you understand?" beat. Skip only if the user says "skip the explanations." The vault reveal (Stage 5.5) and the background jobs are the two that matter most to explain.

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
5. Execute on confirmation. Log what was done to `~/[AI_NAME]/logs/skill-actions.log`

Skills that are purely informational (briefings, reports, research summaries, internal vault edits) don't need the gate — they're outputs to the user, not actions to the outside world.

When in doubt, add the gate. The friction is small; the cost of a wrong-send is large.

---

## Stage 0a — Say hi first, then the agent capability check (~2 min)

**Open warm — two sentences, before ANY setup talk:**

> "Hi! I'm about to become your AI partner — genuinely excited about this. The whole install is me doing the work while you answer a few questions; you'll do nothing technical. First up: two quick switches that upgrade me from a chatbot that *tells* you things into an agent that *does* things for you. Two minutes. Then I'll walk you through everything else."

THEN verify the two capabilities that turn this kit from a chatbot install into an agent install: **computer use** + **Claude Chrome extension**.

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
> You're about to install WATNEY — a Personal AI Kit. The word *partner* in the kit's tagline does a lot of work. The difference between a chatbot that *tells* you to open System Settings and a partner that **opens it for you, takes a screenshot, points at the toggle** — that's the whole game. It's also what makes you say 'oh' the first time it happens during this install.
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
echo "connectors-deferred: $LIST_OF_SKIPPED" >> ~/[AI_NAME]/.first-run-log.txt
```

### Hard rules for this stage

- **Don't gate the install on connectors.** Some users don't use Gmail, don't have Google accounts, work-Mac restrictions, etc.
- **Pick what the user uses, not what's "complete."** No point connecting Gmail if they live in iCloud Mail.
- **One nudge max post-install.** Wrap-up skill checks the deferred log once after 3 days, suggests adding any still-missing, then never again.
- **Verify each connector after enabling** via a no-op call. Don't trust "I clicked the thing" without a probe.

---

## Stage 0c — Anti-AI writing discipline (public-output cleanup, ~30 sec)

This stage doesn't require the user to do anything — it's a 20-second framing the AI delivers in plain language so the user understands what they're getting from minute one. The skill itself (`anti-ai-writing`) auto-installs via setup.sh's CORE_SKILLS list; this stage just tells the user it's there and why it matters.

This completes the agent activation triad:
- **Stage 0a — Hands** (computer use + Chrome ext — what the agent can DO)
- **Stage 0b — Reach** (Gmail / Calendar / Drive / Notes connectors — where the agent can GO)
- **Stage 0c — Public-output cleanup** (anti-AI writing discipline — how the agent's writing SHOWS UP to outsiders)

Without any one of the three, the user gets a smart chatbot. With all three, the user gets an agent that acts, reaches, and produces public-grade output by default.

### What this is — and isn't

This skill is **separate from voice**. Voice = the user's signature (beliefs, taste, banned words, sentence patterns, reference brands) — captured later via the kick-off interview (Stage 5 in Part 1 = lightweight 3-Q foundation; Part 2 = 5-Q express; deluxe = 100-Q) and stored in `Brand/Voice guide.md` + (if deluxe) `Voice/about-me.md`.

Anti-AI writing is **a cleanup filter on public-facing output**. It READS the voice files (once they exist) and APPLIES the rules to every external draft, then strips ~250 universal AI tells on top. Two different things, working together: voice is the *signature*, anti-AI writing is the *filter that enforces the signature + removes AI tells on every public draft*.

Public-facing = anything the user will publish, send, or sign their name to: emails, social posts, captions, essays, replies, marketing copy, decks, pitches. NOT internal AI reasoning, NOT code, NOT scratch outlines.

### Tell the user this — once, plainly

> "Last thing before we start the install proper. There's a skill bundled in this kit called **anti-AI writing discipline**. It fires on every single public-facing draft I produce for you — emails, posts, captions, replies, anything you'd send to another human. It does two things: (1) strips about 250 patterns that signal AI-generated text (em dashes everywhere, *'It's not X, it's Y'* contrast framing, *'Moreover'* / *'Furthermore'*, *'serves as'* instead of *'is'*, the rule of three, etc.), and (2) adds personality back in via a framework called POP (Personal, Observational, Playful, Vignette).
>
> Important distinction: this isn't your voice. Your voice — how you specifically think and sound — gets captured later in our kick-off conversation. THIS skill is the cleanup layer that runs on top of your voice rules every time I draft something you'd send to another person. Voice = your signature. Anti-AI writing = the filter that makes sure every public draft enforces your signature AND doesn't read as machine-generated.
>
> Most AI assistants give you generated-sounding output and expect you to clean it up. This kit flips that. The cleanup runs automatically, on every public draft, from day one. As we go, the skill specializes — you tell me *'don't ever use the word [X]'* and it gets added to my permanent rules.
>
> In about 30 minutes I'll draft something for you (the aha-moment voice note in Stage 8). That draft will already be running through this cleanup. You'll hear the difference. That's the default for everything I write for you, forever.
>
> Sound good? Cool. Moving on."

No action required from the user. The AI just states this and moves on to Stage 0 greeting.

### What the skill does on the AI side (reference for the install playbook)

The bundled `anti-ai-writing` skill auto-activates on every public-output drafting task. It reads:
- The user's Brand voice guide (populated during Stage 5 kick-off, deepened in Part 2)
- The user's Do-not-use list (populated during Stage 5 kick-off B5)
- The user's `about-me.md` (if Part 2 deluxe interview was run)
- Its own `learnings.md` (accumulates user-specific rules over time)

Then runs every public draft through:
1. **24 hard rules** (no em dashes, no rule of three, no contrast framing, no copula avoidance, etc.)
2. **Banned-word substitution** (~250 entries across transitions, adjectives, adverbs, abstract nouns, verbs, phrases)
3. **Pattern check** (rule-of-three sweeps, "It's not X, it's Y" sweeps, "despite challenges" formula detector)
4. **POP framework** for adding personality back (Personal, Observational, Playful, Vignette)
5. **User-specific overrides** from the voice files + learnings.md

Full reference at `~/.claude/skills/anti-ai-writing/SKILL.md` after install. User can read it anytime. User can tune it anytime by saying *"add this to my rules: never write [X]"* and the wrap-up skill folds it into the SKILL.md.

### Hard rules for this stage

- **Don't skip mentioning anti-ai-writing.** It's not optional polish — it's the kit's "your AI's public output sounds like you, not ChatGPT" promise.
- **Don't conflate it with voice.** Voice is the user's signature (captured via interview). This skill is the cleanup filter on public-facing output. Different concepts, both important, in sequence.
- **Don't oversell.** Don't list all 24 rules. Don't drop the full banned-word table. One paragraph, one specific example, move on.
- **Don't gate.** Skill installs automatically; user doesn't toggle it on/off.
- **The aha-moment voice note in Stage 8 is the first proof.** When the user hears Em's voice on their phone — that draft was already cleaned by this skill. Don't break the suspense by re-explaining mid-install.

---

## Stage 0 — Greeting + tone-setting (~1 min)

Open with warmth. Set expectations. Get permission to proceed.

> "Hi! I'm about to install your WATNEY — **Part 1: Foundation**. Here's the deal:
>
> 1. **Security check** — I'll audit every file in the kit before I write anything to your Mac (~3 min)
> 2. **Foundation setup** — folder, memory, four digital employees, scheduled jobs. Most of this is automatic (~5 min)
> 3. **Quick kick-off** — three questions so I know your name, your tone, and one project you're working on (~8 min)
> 4. **Telegram + voice** — wire up your phone so your AI is in your pocket (~17 min)
> 5. **The proof** — your AI sends you an automatic voice note on Telegram. You hear it on your phone. *(~3 min)*
>
> Total: about an hour — sometimes a bit more on a brand-new Mac. Nearly all of it is me working while you answer a few questions; you'll do nothing technical. Sound good?
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
git clone https://github.com/DanJoachimn/WATNEY-Personal-Ai-OS-Kit.git "$SANDBOX/kit"
```

### Run the audit

Read every file in `$SANDBOX/kit/`. Scan for the 9 categories of red flags documented previously (kept here briefly — full detail in audit-protocol.md):

1. Files touching paths outside the install scope (legitimate: `~/[AI_NAME]/`, `~/.claude/skills/`, `~/Library/LaunchAgents/com.[user].[ai-name].*.plist`, `~/.config/[ai-name]/`, sandbox)
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

## Stage 1.5 — Talk instead of type (voice-in, ~2 min, do this early)

Offer this right at the top of kick-off so the user can **speak** the rest of the install instead of typing — smoother, and the kit's first taste of voice-first. **Lead with the free option.** Read `~/[AI_NAME]/.kit/AFFILIATE-LINKS.md` first — it holds both links + the disclosure line.

**Offer Lispr first (the free default):**

> "Quick one before we dig in — want to talk to me instead of typing all this? I'd start with **Lispr**: it's free, no account, about a 4 MB download. Hold a key, speak, and it types wherever your cursor is, in any app. It even does live translation — speak Danish, land English. I'll open the download page; you'll be running in ~2 minutes."

Open `https://lispr.ai` (Chrome extension when paired; else hand them the link). Pause for the `.dmg` install + the mic + accessibility permission prompts (tell them that's expected). Wait for "done," then: *"From here, just hold the key and talk — I'll catch it."*

**Then mention Wispr Flow once — the polished alternative, no push:**

> "One alternative if you ever want it: **Wispr Flow** is a more *dialed* version — its editing and cleanup of what you say (auto-formatting, cutting the ums, tidier text) is more mature than Lispr's raw dictation. It's got a free plan too — 2,000 words a week — with a paid tier for heavy use. Lispr's free and great to start; Wispr's there if you want the premium feel later."

Surface the Wispr Flow link from `AFFILIATE-LINKS.md` (affiliate) **only** with this mention, and show the disclosure line the first time an affiliate link appears in the session. The free option (Lispr) always leads; never steer toward the paid one.

- **If they skip voice entirely:** no nagging. They type; that's completely fine. Offer again never.

---

## Stage 2 — Upfront installs (the groundwork, ~5–10 min, almost no typing)

A few tools have to exist before I can build your AI: **git** (to fetch the kit), **Homebrew** (the Mac's installer for developer tools), and a couple of small utilities (`ffmpeg`, `jq`, `node`). I install all of them for you. There is exactly **one** moment you type anything — a single line for Homebrew, because Apple requires your password for it and no AI can safely do that for you. One line, once. Everything else is me.

### 2a — Check what's already there (silent)

```bash
sw_vers -productVersion                 # macOS 14+ expected
ls -d "/Applications/Claude Code.app"   # Claude Code Desktop present
which git brew ffmpeg jq node           # note which are missing
```

If everything's present → say *"good — your Mac already has what I need"* and skip to Stage 3.

### 2b — git + Apple's developer tools (no password, no terminal)

If `git` is missing, run:

```bash
xcode-select --install
```

A small Apple window pops up. Tell the user: *"a little Apple window just opened asking to install developer tools — click **Install**, accept, and tell me when it says it's done (~5–10 min)."* This one popup gives us **git** AND the tools Homebrew needs — no password, no terminal. Use the download time to keep chatting (their name, their tone) so the wait feels productive.

### 2c — Homebrew (the one line you type)

If `brew` is missing, this is the single manual step. Frame it **calmly and exactly** — never improvise a workaround:

> "One quick thing — the only line you'll type this whole install. Open **Terminal** (press ⌘-Space, type *Terminal*, hit Enter) and paste this, then press Return:
> ```
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
> ```
> It'll ask for your Mac password — type it (it stays invisible as you type, that's normal), press Return, and let it finish (~5–10 min). When it's done, come back and say **'done'**. That's the only time you touch the terminal — I handle everything else."

Wait for *"done"*. Then verify with `brew --version`. If it errors, the usual fix is the PATH line Homebrew prints at the end — run it for them via Bash (`eval "$(/opt/homebrew/bin/brew shellenv)"`) and re-check.

### 2d — The small utilities (no password, you do nothing)

Once Homebrew exists, install the rest silently:

```bash
brew install ffmpeg jq node
```

(`setup.sh` in Stage 4 also installs `ffmpeg` if it's somehow still missing — belt and suspenders.)

### 2e — A note on WHERE this lives (folder safety)

Your AI's home will be `~/[AI_NAME]/` — your Mac's **home folder**, on purpose. Not Desktop, not Documents: macOS privacy (TCC) silently blocks background programs from reading those two, which would quietly kill your AI's overnight jobs. The home folder is the safe spot, and `setup.sh` puts it there automatically. Nothing for you to do — just know that's *why* it's not on your Desktop.

If anything above fails → plain-English explanation + the one-line fix, then wait for confirmation before Stage 3. Never paste a raw error.

---

## Stage 2.5 — The apps you'll use (I'll open each download page for you, ~5 min)

Two more apps round out the setup (voice-in — Lispr / Wispr Flow — was already offered in Stage 1.5; don't repeat it). If computer use + Chrome are on, **open each download page in the user's browser yourself** — they just click through the installer and grant permissions when macOS asks. If those capabilities are off, give the link and wait for "done."

| App | Why it's here | Download |
|---|---|---|
| **Telegram Desktop** | Lets you copy your bot token *on the Mac* (Stage 6) and text your AI from the computer too. The smoothest path. | https://desktop.telegram.org |
| **Obsidian** | The window onto your AI's second brain — the vault it reads and writes every day. Free, yours, offline. | https://obsidian.md/download |

Walk it:
1. For each app the user wants, open the download page (Chrome extension if paired; otherwise hand them the link and wait for "done").
2. Pause for the physical install. Telegram asks for a notification permission — tell them that's expected and fine.
3. **Don't gate the install on either.** Skip Obsidian → the vault still runs headless (we reveal it properly later). Telegram Desktop is the only strongly-recommended one, and even that has a phone-only fallback.

---

## Stage 3 — Backup awareness (~30 sec)

> "Quick note on backup: your AI's memory lives at `~/[AI_NAME]/` on this Mac. **Don't move it into iCloud Drive.** Sounds counter-intuitive (Apple's whole pitch is iCloud), but macOS privacy controls block background programs from reading anything in `~/Documents/` — and your AI's always-on features ARE background programs. Moving the vault into iCloud breaks them within 24 hours.
>
> We'll set up proper backup in Part 2 (Stage 3.7) — Time Machine is the easiest, GitHub private repo is the strongest. For now, just don't enable 'Desktop & Documents Folders sync' if it asks. Continuing..."

No user action this stage — it's a 30-second framing so the user doesn't reflexively turn on iCloud Documents sync later thinking it's the safe move.

**Why this stage exists:** Install #1 (Julie's Em, 2026-05-18) discovered the hard way that `~/Documents/` is TCC-protected on modern macOS and breaks launchd background jobs. The kit originally walked users through enabling iCloud Drive Documents sync as the backup layer; that was the wrong call. Backup happens via Time Machine / GitHub / Obsidian Sync in Part 2. See `~/Desktop/Claude's Office/julie-install-friction-log.md` for the full architectural finding.

---

## Stage 4 — Foundation install via `setup.sh` (~5 min, mostly automatic)

This is where the kit installs itself. **Bash handles all file mechanics — minimal AI tokens, fast, idempotent.**

Ask the user once:

> "What name should I call you by? First name is fine. I'll use it in the AI's notes and drafts."

Capture as `[PARTNER_NAME]`.

Now run the foundation:

```bash
cd "$SANDBOX/kit" 2>/dev/null || \
  git clone https://github.com/DanJoachimn/WATNEY-Personal-Ai-OS-Kit.git ~/.partner-ai-kit-staging

# Run the deterministic foundation installer
cd ~/.partner-ai-kit-staging
./setup.sh "[AI_NAME]" "[PARTNER_NAME]" "https://github.com/DanJoachimn/WATNEY-Personal-Ai-OS-Kit.git"
```

The script:
- Clones the kit to `~/[AI_NAME]/.kit/`
- Builds the vault scaffold at `~/[AI_NAME]/vault/`
- Installs 12 core skills to `~/.claude/skills/` — including `check-telegram` (the answering machine that processes and replies to phone messages) and the install mentor (plain-English explainer blocks at each phase)
- Installs 4 digital employee subagents (Content, Research, Developer, Assistant) to `~/[AI_NAME]/.claude/agents/`
- Loads the nightly memory-compression launchd job
- Creates `_recovery/env-template.txt`
- Wires up `~/[AI_NAME]/CLAUDE.md`
- Logs every stage to `~/[AI_NAME]/logs/install.log`

**Watch the script's output. Each step prints `✅` as it completes.** If the script fails, the error is specific and the log file shows what went wrong.

When it finishes, show the user a quick visual:

```mermaid
graph LR
    HOME[~/[AI_NAME]/] --> KIT[.kit/<br/>kit source]
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

## Stage 4.5 — Wake the engine (CLI authentication, ~2 min, NO terminal if possible)

The background routines installed in Stage 4 (nightly dreaming, weekly curator, Telegram poller) run by calling `claude -p` from the command line. That only works if the Claude CLI is signed in. Verify and fix now, BEFORE the user discovers it silently at 2 AM.

**Probe silently:** run `claude -p "say ok"` yourself via Bash. If it returns "ok" → authenticated, say nothing, move on.

**If it needs auth, fix it in this order (best → fallback):**

1. **Browser-first flow (preferred — keeps the "no terminal" promise).** Start the login from within this session and complete the OAuth in the browser. Watch the browser tab via the Chrome extension; tell the user only: *"quick sign-in popped up in your browser — same Claude account you already use, just click Approve."* (Install #1's Em found a browser-auth route — verify the exact mechanics during Friday's install and tighten this step with what works.)
2. **Computer-use-driven Terminal (you do it, they watch).** If browser-only fails: YOU open Terminal via computer use, YOU type `claude` then `/login`, the OAuth opens in their browser, they click Approve, YOU type `/exit`. The user never touches a key. Narrate plainly: *"I'm doing a one-time sign-in for my background brain — 30 seconds."*
3. **Guided manual (last resort).** Exact keystrokes, one at a time, warm tone, no jargon.

**Verify after:** `claude -p "say ok"` again. Must return clean before proceeding. Log the result to install.log.

---

## Stage 5 — Lightweight kick-off (~8 min, 3 questions only)

**This is NOT the full kick-off interview.** That's deferred to Part 2.

For Part 1, ask only the three questions that let the aha-moment in Stage 8 land:

### Question 1 — Name + tone

> "**How should I sound?** Not a long answer — three words or one sentence. Examples: *'warm-direct, no fluff'* / *'sharp colleague, push back on me'* / *'friendly, never corporate.'* What works for you?"

Save to `~/[AI_NAME]/vault/Brand/Voice guide.md` as the starter voice doc. Note this is intentionally thin — Part 2's 5-Q deepens it.

### Question 2 — Active project

> "**One project you're working on right now** — anything. Could be a launch, a deal, a piece you're writing, a problem you're stuck on. Two sentences max. Just enough that I know what you're heads-down on."

Save to `~/[AI_NAME]/vault/Projects/[project name].md` with frontmatter.

### Question 3 — Working style preference

> "**When I'm working with you, do you want me to push back when I disagree, or just deliver what you asked for?** No wrong answer — operators split about 50/50 on this."

Save to `~/[AI_NAME]/vault/Working style.md` (one-line note).

---

## Stage 5.5 — Meet your second brain (Obsidian reveal + the overnight crew, ~3 min)

The vault has quietly been filling up — the user's voice, their project, their working style all just landed in it during kick-off. **This is the strongest part of the kit, and so far it's been invisible. Reveal it now, before Telegram** — the brain is the foundation; the phone bridge comes after. (This fixes the #1 structural finding from real installs: users met the memory *jobs* and the *messenger* before they ever saw the *building*.)

### Open the vault in Obsidian

If Obsidian was installed in Stage 2.5, open the user's vault in it (computer-use, or guide them):

```bash
open -a Obsidian ~/[AI_NAME]/vault 2>/dev/null || true
```

If Obsidian was skipped, do this as a plain-language tour of the folder in Finder instead — the vault works headless either way.

### The reveal (say this, plainly)

> "Meet your second brain. Everything I learn about you lives *here* — plain text files on your Mac that you own forever, not locked in someone's cloud. See this? That's the project you just told me about. This one's your voice. As we work, this fills out — people you mention, decisions you make, what you're reading. Six months from now you can ask me 'what did I decide about X?' and I'll have a real answer, because it's all written down here with receipts."

### The overnight crew (now dreaming + consolidating make sense)

> "And two things happen while you sleep. **Dreaming** — every night around 2 AM — reads back over the day and compresses what mattered into long-term memory, so I get sharper without you lifting a finger. **Consolidating** keeps the whole brain tidy and free of duplicates. You'll see them running in the logs; now you know what they're for. They're the reason this gets *better* the longer you use it."

Then fire the `watney-install-mentor` block for this phase (what just happened · why it matters for them · when they'll use it), anchored in their actual project — and continue to Telegram.

---

## Stage 6 — Telegram bridge (~12 min, user does some hands-on work)

This is where the kit reaches off the Mac and into the user's pocket.

> **Pre-flight dependency (already handled by setup.sh):** `ffmpeg` must be installed. It's used to (a) convert mp3 → ogg/opus for the `sendVoice` API (voice OUT in Stage 8) and (b) decode .ogg voice messages from the user's phone for Whisper transcription (voice IN, when the user replies with a voice note). Without ffmpeg, the voice flow silently fails — the Telegram message arrives but transcription returns nothing usable.
>
> setup.sh's Stage 0-DEPS installs `ffmpeg` via Homebrew if missing. If you're reading this and the install didn't go through setup.sh, run `brew install ffmpeg` before continuing. Common failure surfaced by Install #1 (Julie, 2026-05-18) — it used to be a hidden dependency only documented in playbook.md.

### 6a — User creates a Telegram bot via @BotFather

> "OK, time to give me a phone. Open Telegram on your phone, search for **@BotFather**, and send it `/newbot`. It'll ask for a name (something like *'My Partner AI'*) and a username (must end in `bot`, e.g. *'mypartner_ai_bot'*). It'll spit out a token — looks like `7234567890:AAH...`. Copy that token to your clipboard."

Wait for them to confirm: *"got the token."*

### 6b — User copies the token, the AI files it (clipboard pattern, never in chat)

Do NOT ask the user to open or edit any file — hidden dotfiles are invisible to a non-developer in Finder. The clipboard does the hand-off:

> "Copy the token BotFather sent you. One thing: copy it **on this Mac** — open Telegram's desktop app or web.telegram.org, find the BotFather message, and copy the token there (a phone copy doesn't reach the Mac's clipboard unless Universal Clipboard is set up). Don't paste it anywhere — just tell me 'copied.' I'll read it straight off your clipboard into a locked config file, so it never appears in our chat log."

When they say "copied," run:

```bash
mkdir -p ~/.config/[ai-name]/telegram
umask 177
printf 'TELEGRAM_BOT_TOKEN=%s\n' "$(pbpaste | tr -d '[:space:]')" \
  > ~/.config/[ai-name]/telegram/.env
chmod 600 ~/.config/[ai-name]/telegram/.env
pbcopy < /dev/null   # clear the clipboard afterwards
```

Verify the token works before moving on (never echo the token itself):

```bash
source ~/.config/[ai-name]/telegram/.env
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getMe" | jq -r '.ok'
```

`true` → tell the user *"token filed and verified — and I've cleared your clipboard."* `false` or empty → the clipboard was empty or grabbed extra text; ask them to copy just the token line (on the Mac) and repeat this step.

### 6c — Install the Telegram poller

```bash
mkdir -p ~/[AI_NAME]/scripts ~/[AI_NAME]/logs ~/Library/LaunchAgents
cp "~/[AI_NAME]/.kit/setup-guide/telegram-kit/poll-telegram.sh" \
   "~/[AI_NAME]/scripts/poll-telegram.sh"
chmod +x ~/[AI_NAME]/scripts/poll-telegram.sh

# Generate the launchd plist DIRECTLY — no template substitution, nothing to get wrong.
# The ONLY place you fill in the AI's name is the NAME= line; everything below reads ${NAME}.
NAME="[AI_NAME]"                 # ← the AI's folder name, lowercase (e.g. watney)
USER_NAME="$(whoami)"
PLIST="$HOME/Library/LaunchAgents/com.${USER_NAME}.${NAME}.telegram-poller.plist"
cat > "$PLIST" <<PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.${USER_NAME}.${NAME}.telegram-poller</string>
  <key>ProgramArguments</key>
  <array><string>${HOME}/${NAME}/scripts/poll-telegram.sh</string></array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>AI_NAME</key><string>${NAME}</string>
    <key>HOME</key><string>${HOME}</string>
    <key>PATH</key><string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
  </dict>
  <key>StartInterval</key><integer>60</integer>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><false/>
  <key>StandardOutPath</key><string>${HOME}/${NAME}/logs/telegram-poller.out</string>
  <key>StandardErrorPath</key><string>${HOME}/${NAME}/logs/telegram-poller.err</string>
</dict>
</plist>
PLIST_EOF

launchctl load "$PLIST"
```

*(The `com.telegram-poller.plist.template` file in the kit is kept as reference/documentation — the heredoc above is what actually runs, because generating the plist directly removes every place a find-replace could go wrong.)*

**Hard gate — verify the job actually loaded before continuing:**

```bash
launchctl list | grep telegram-poller
```

This MUST return a row. If it doesn't: check the rendered plist contains zero leftover `[BRACKETED]` placeholders (`grep '\[' ~/Library/LaunchAgents/com.*telegram-poller.plist` must return nothing), fix, re-load. Do **not** improvise a session-bound poller process instead — that dies the first time the Mac sleeps and produces the classic "worked yesterday, dead today" failure.

### 6d — Verify end-to-end (message in → chat id captured)

Tell the user:

> "Send a quick test message from your phone to your bot — anything, like 'hello'. I'll watch the inbox. (Up to a minute — the mailman does rounds every 60 seconds.)"

Wait. Check `~/[AI_NAME]/inbox/telegram/` for the incoming message file, then confirm the poller captured the reply address:

```bash
cat ~/[AI_NAME]/.config/telegram-chat-id   # must print a number
```

When both land:

> "✅ Got it. Your AI just received its first message from your phone — and it now knows where to send replies. Bridge is live, both directions.
>
> One more thing worth knowing: this bridge has an **answering machine**. When a message from you arrives and this chat window is closed, your AI wakes itself in the background, reads the message, and replies — usually within a couple of minutes. Your Mac just has to be awake (we'll set that up properly in a minute). Waking up to reply uses a little of your Claude usage each time — nothing dramatic for normal texting, but if you'd rather it just collect messages and answer when you next open it, one setting (`AUTO_REPLY=off` in the telegram config) turns the auto-reply off."

---

## Stage 7 — Give your AI its voice (~4 min, free — sets up the aha)

The aha-moment in Stage 8 is a voice note, and it MUST sound like a real person — the robotic Mac voice ruins the moment. So here we quietly set up a **free ElevenLabs voice** with a hand-picked, natural default. **Keep this light — it's "giving you your voice," not a product pitch.** The ElevenLabs reveal (and any talk of upgrading for more voices) comes *after* the aha lands, in Stage 8.5. Don't pre-sell it here; just get a warm voice in place so the moment hits.

### 7a — Install the voice machinery (automatic)

```bash
cp "~/[AI_NAME]/.kit/setup-guide/voice-io-kit/say-to-mac.sh" \
   "~/[AI_NAME]/scripts/say-to-mac.sh"
cp "~/[AI_NAME]/.kit/setup-guide/voice-io-kit/send-voice-note.sh" \
   "~/[AI_NAME]/scripts/send-voice-note.sh"
cp "~/[AI_NAME]/.kit/setup-guide/voice-io-kit/transcribe.sh" \
   "~/[AI_NAME]/scripts/transcribe.sh"
chmod +x ~/[AI_NAME]/scripts/say-to-mac.sh \
         ~/[AI_NAME]/scripts/send-voice-note.sh \
         ~/[AI_NAME]/scripts/transcribe.sh

# The voice-io skill (transcription workflow) — installed alongside the core skills
cp -R "~/[AI_NAME]/.kit/setup-guide/voice-io-kit" ~/.claude/skills/voice-io 2>/dev/null || true
```

### 7b — Free ElevenLabs voice (~2 min, quiet — frame as plumbing, not a product)

**Before surfacing the link: read `~/[AI_NAME]/.kit/AFFILIATE-LINKS.md`** and use the ElevenLabs link (affiliate if present, else plain). If Wispr Flow already triggered the affiliate disclosure line in Phase 0, don't repeat it.

Frame it as invisible setup — NOT a sales moment (the ElevenLabs reveal is Stage 8.5, after the aha):

> "One quick bit of setup so I don't sound like a robot — I'm giving you a real, natural voice. Two minutes, free, no card needed."

**The ONLY thing the user does here is grab their API key.** No voice to pick, nothing to configure — I handle the rest. Open the signup (Chrome extension when paired), then have them go to profile → API key → **copy the key**. Clipboard pattern, never in chat:

```bash
mkdir -p ~/.config/[ai-name]/elevenlabs
umask 177
printf 'ELEVENLABS_API_KEY=%s\n' "$(pbpaste | tr -d '[:space:]')" \
  > ~/.config/[ai-name]/elevenlabs/.env
chmod 600 ~/.config/[ai-name]/elevenlabs/.env
pbcopy < /dev/null
```

### 7c — Set the default voice (no menu — just a great, warm default)

Don't make the user pick a voice before they've heard anything — that's friction at the worst moment. Assign a hand-picked, warm, natural default so the aha just *sounds human*. Default is **Bella** (warm, bright, professional). If the AI's chosen name/persona clearly reads male, use **Brian** (deep, calm) instead — otherwise Bella.

```bash
# Bella (warm female) is the default; swap to Brian (nPczCjzI2devNBz1zQrb) if the persona reads male.
printf 'ELEVENLABS_VOICE_ID=hpp4J3VqNfWAUOO0d1Us\n' >> ~/.config/[ai-name]/elevenlabs/.env
```

**Verify the pipeline SILENTLY — do not play it aloud.** The first time [PARTNER_NAME] *hears* the voice should be the aha note on their phone, not a test clip here:

```bash
~/[AI_NAME]/scripts/say-to-mac.sh "Voice check." /tmp/voice-test.mp3 2>/tmp/voice-err.txt
if [ -s /tmp/voice-test.mp3 ] && ! grep -q "built-in voice" /tmp/voice-err.txt; then
  echo "✅ ElevenLabs voice verified (silently — first play is the aha)."
else
  echo "⚠️  Voice didn't render via ElevenLabs — check the API key / voice id."; cat /tmp/voice-err.txt
fi
rm -f /tmp/voice-test.mp3 /tmp/voice-err.txt
```

If it flags an issue, the key or voice ID didn't land — fix before Stage 8. The choice of *other* voices and the upgrade come after the aha (Stage 8.5).

### 7d — If the user skips ElevenLabs

Accept once, no nagging — but be honest about what they'll hear:

> "No problem. I'll use the Mac's built-in voice for now — fair warning, it's noticeably robotic. Everything still works; it just sounds like 2005. Say *'set up my real voice'* anytime and we'll do the 3-minute ElevenLabs step then."

Then set the best default Mac voice **silently** — no voice-picking before the aha here either. Default to **Samantha** (clearest):

```bash
echo 'Samantha' > ~/[AI_NAME]/.config/voice-preference
```

The scripts read that automatically when ElevenLabs isn't configured. They can swap the Mac voice — or set up the real ElevenLabs voice — anytime after; that's the Stage 8.5 conversation.

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
   ~/[AI_NAME]/scripts/say-to-mac.sh \
     "[script from Content subagent]" \
     /tmp/aha-moment.mp3
   ```

3. Send via Telegram as a native voice note (the script converts to Telegram's ogg/opus format):

   ```bash
   # The poller wrote this file when the user's Stage 6 test message arrived.
   CHAT_ID="$(cat ~/[AI_NAME]/.config/telegram-chat-id 2>/dev/null)"
   # Fallback: pull it from the newest inbox message if the file is missing.
   [ -z "$CHAT_ID" ] && CHAT_ID="$(grep -h '^chat_id:' ~/[AI_NAME]/inbox/telegram/*.md 2>/dev/null | tail -1 | awk '{print $2}')"

   ~/[AI_NAME]/scripts/send-voice-note.sh "$CHAT_ID" /tmp/aha-moment.mp3
   ```

4. In chat, tell the user:

   > "Check your phone."

   Then wait. Don't say anything else until they respond.

### What the user experiences

Their phone buzzes. They open Telegram. They see a voice note from their AI. They tap. They hear (in the voice they picked):

> *"Good to be onboard my friend. [2-3 sentences about their project, in their tone, sounding like a colleague.] Talk soon."*

90 seconds after install ends, they have a personal message from a digital employee they didn't ask for. **The kit just earned the install.**

### After they confirm they heard it

> "That's the moment. You sent zero prompts for that — I delegated to Content, which read your project context, drafted in your tone, rendered to voice, sent to your phone. That's how the team works. You talk to me, I dispatch the right specialist behind the scenes."

### Stage 8.5 — The voice reveal + your options (~1 min — NOW, not before)

Only now that they've *heard* it do you name what powered it — softly, a nice-to-know, never a pitch:

> "Oh — and that voice? That's **ElevenLabs**, on their free tier. I set you up with a warm default so your first hello sounded like a person, not a robot. Two things, whenever you feel like it:
> - **Change it** — I've got other free voices (a deep calm one, a warm British storyteller, a clear friendly one). Just say *'change my voice.'*
> - **The big library** — if you ever want to pick from *thousands* of voices — every accent, every character — that's their paid plan. Totally optional; your free voice sounds great. You can browse the whole library free with the account you already made."

If they want to browse or upgrade, read the ElevenLabs link from `~/[AI_NAME]/.kit/AFFILIATE-LINKS.md`. No pressure, no gate — a recommendation in passing, then move on.

> "✅ **Part 1 complete.**"

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
touch ~/[AI_NAME]/.part-1-complete
date -Iseconds > ~/[AI_NAME]/.part-1-date

# Voice progression flag — tier 1 of 3 (3-Q foundation → 5-Q express → 100-Q deluxe)
# Read by the kick-off skill so it knows not to re-run the foundation interview.
touch ~/[AI_NAME]/.voice-foundation-3q-complete

# Block the kick-off skill's auto-run on next session.
# (Part 2 explicitly re-invokes voice deepening when the user opts in.)
touch ~/[AI_NAME]/.first-run-complete
cat > ~/[AI_NAME]/.first-run-log.txt <<EOF
First-run completed via Part 1 install: $(date -Iseconds)
Voice tier: 3-Q foundation (Part 1 lightweight)
Pending: Part 2 (5-Q express + premium voice + meeting capture + optional skills)
User invokes Part 2 when ready: "run Part 2"
EOF

echo "$(date -Iseconds) — PART 1 COMPLETE — total: $(wc -l ~/[AI_NAME]/logs/install.log | awk '{print $1}') log entries" \
  >> ~/[AI_NAME]/logs/install.log
```

If user is on Max plan and wants to continue immediately:

> "You're on Max — we have headroom. Want to roll into Part 2 right now, or take a break first?"

**Final beat — First Wins.** Before the goodbye: read `~/[AI_NAME]/.kit/FIRST-WINS.md`, personalize its five asks with [PARTNER_NAME]'s real context from this session (the email they mentioned owing, the decision they're weighing, the thing they keep forgetting), present the card in chat, and save the personalized copy to `~/[AI_NAME]/FIRST-WINS.md` so they can find it tomorrow.

**Then — set up the morning brief.** Read `~/[AI_NAME]/.kit/BRIEF-SETUP.md` and run its Steps 1–3: explain the daily brief in plain English, collect the ~4 details (time, channel, what matters, current focus), and schedule it. This plants tomorrow's aha — the first brief lands next morning, and BRIEF-SETUP's Step 4 appends the optional newsletter opt-in to that first brief automatically.

**The newsletter (only if they stop at Part 1).** If the user is wrapping here rather than rolling into Part 2, deliver BRIEF-SETUP's **CTA #2** verbatim — the one-time, "I'll never bring it up again" All Gravy Times invite, followed by the *Presented with Beehiiv* credit line. If they're continuing to Part 2, skip it here; it fires at the Part 2 close instead. (Two newsletter mentions total, ever — never more.)

Then end the session warmly.

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

All available in **Part 2** at `~/[AI_NAME]/.kit/INSTALL-PART-2.md` — user invokes with `"run Part 2"`.

---

## Variables this playbook expects

| Placeholder | Source |
|---|---|
| `[AI_NAME]` | Set in Stage 1 (user's chosen AI name) |
| `[PARTNER_NAME]` | Set in Stage 4 (user's first name) |

---

*Part 1 of 2 — Foundation. Part 2 (Reach) is a separate playbook the user invokes when they're ready.*
