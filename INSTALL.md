# INSTALL.md — Part 1 (Foundation) install playbook

> **This file is read by an AI agent (Claude Code) at install time.** A non-technical user has just pasted the magic prompt asking you to install WATNEY (the Personal AI-OS Kit). They're not a developer. They want this working, not configured. They're on Claude Pro ($20/mo) plan unless they say otherwise. Stage history and lessons from real installs live in `CHANGELOG.md`, not here.
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
8. **If something you try to write is blocked, hand it over as one Run button.** The app can stop you writing outside the working folder (`~/.claude/`, `~/Library/LaunchAgents/`, `~/.config/`). When that happens, show the exact command in a ```bash block for the user to click **Run** on. Never build staging folders and never hand over a long multi-step script to paste — real installs did that, and it turned a two-click job into ten minutes of terminal.
9. **Fire the install mentor at each phase boundary.** After each stage completes, deliver the `watney-install-mentor` block — *what just happened · why it matters for **them** · when they'll use it* — anchored in what they shared. Three lines, ~15 seconds, no quiz, no "do you understand?" beat. Skip only if the user says "skip the explanations." The vault reveal (Stage 10) and the background jobs are the two that matter most to explain.

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

## Stage 1 — Say hi, /waitwhat, Wispr Flow, the two switches (~5 min)

**Open warm — two sentences, before ANY setup talk:**

> "G'day mate! I'm about to become your AI partner — genuinely excited about this. The whole install is me doing the work while you answer a few questions; you'll do nothing technical. First up: two quick switches that upgrade me from a chatbot that *tells* you things into an agent that *does* things for you. Two minutes. Then I'll walk you through everything else."

**This is the ONE greeting.** Stage 2 below picks up the thread — it does not say hello again. Greeting twice in five minutes reads like a script, not a person.

### Then hand them the escape hatch — before anything technical starts

[PARTNER_NAME] is about to have an hour of unfamiliar things explained to them. Give them the ripcord **now**, while it's still cheap to mention, so they never sit in silent confusion later:

> "One thing before we start, and it's for you rather than me. If I ever explain something and it doesn't land — type **`/waitwhat`** and hit enter. I'll stop and explain it a completely different way, in plain English, no jargon. Use it as many times as you like, today or in a year.
>
> And to be clear about how this works: if something doesn't make sense, that's my explanation being bad, not you missing something. `/waitwhat` is me fixing my miss."

That last line is the load-bearing one. **Say it.** The whole reason a non-developer stops asking questions is embarrassment — naming it up front is what keeps them asking for the next hour.

**Timing, so you don't promise something that isn't there yet:** `/waitwhat` gets installed at the end of the safety check (Stage 3), a few minutes from now. Until then, treat *"wait, what?"*, *"you lost me"* or a typed `/waitwhat` as the same request and re-explain anyway. You already have the method: one line of context, a different angle, plain words, no apology. After Stage 3 it's a real command that works in every session forever.

### Then: talk instead of type (Wispr Flow, ~2 min)

Offer this in the first minute, so the user can **speak** the rest of the install instead of typing. It makes the next hour faster and more fun, and it's the kit's first taste of voice-first.

The link is `https://ref.wisprflow.ai/daniel-joachim-nielsen` (the kit isn't on the Mac yet, so you can't read PARTNER-RECOMMENDATIONS.md at this point; plain fallback `https://wisprflow.ai`). This is the **first affiliate link of the session — show the one-line disclosure now:** *"Full disclosure: that's a referral link. Same price for you; it helps fund the kit."*

> "Quick one before we dig in: want to talk to me instead of typing all this? **Wispr Flow** lets you dictate anywhere on your Mac — hold a hotkey, speak, it types for you. The free tier is 2,000 words a week, which easily covers this install and then some. Most people get hooked and stop typing altogether. Totally optional — I'll open the download page and you'll be running in about 2 minutes."

- **If yes:** open the download page (Chrome extension when paired; otherwise hand them the link). Pause for the install + the mic/accessibility permission prompts (tell them that's expected). Wait for "done," then: *"From here, just hold the hotkey and talk — I'll catch it."*
- **If skip:** no nagging. They type; that's completely fine. Offer again never.

### Then the two switches

Verify the two capabilities that turn this kit from a chatbot install into an agent install: **computer use** + **Claude Chrome extension**.

These are not install conveniences. They are **half the magic.** The user is about to spend 45 minutes installing a "Partner AI." The first time the AI opens System Settings for them, or fills out a BotFather form, or takes a screenshot to confirm the toggle they just enabled — that's the aha-moment compounding *throughout* the install, not just at the voice-note climax. Without these, the user finishes Part 1 with a smart chatbot. With them, the user finishes Part 1 *feeling* the partnership for the first time.

### Probe both capabilities silently first

```
- Attempt a no-op `computer-use` screenshot. Success = on. Error = off.
- Attempt `mcp__claude-in-chrome__list_connected_browsers`. Returns browser = paired. Error = not paired.
```

Branch on the four states:

| Computer use | Chrome ext | Action |
|---|---|---|
| ON | PAIRED | Brief celebration. Proceed to Stage 2. |
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

> "**2. Claude Chrome extension** — lets me fill out web forms for you. Used in Stage 11 (the Telegram bot setup — saves you ~10 manual clicks and a copy-paste of a token), for the ElevenLabs sign-up, and for anything on the web.
>
> Install: open Chrome → [Chrome Web Store, search 'Claude'](https://chromewebstore.google.com/search/Claude) → Add to Chrome → click the extension icon once to pair it with this session. Tell me when it's installed."

### Verify after the user says they've done it

- Computer use → attempt another screenshot. If it works, say *"got it, screen access live."* If still failing, walk through the macOS permission dance (System Settings → Privacy & Security → Screen Recording / Accessibility → check Claude Code).
- Chrome extension → re-run `list_connected_browsers`. If paired, say *"Chrome paired."* If not, the most common cause is they installed but forgot to click the extension icon to pair — ask them to click it.

### If user says skip

Accept it. Don't push twice. But say once, plainly:

> "Got it. We can still install everything. You'll just be doing more of the clicking yourself — every time I need to verify something visual, I'll ask you to look and tell me. It'll work; it'll just feel less like a partner. If you change your mind later, you can enable either of these anytime and the rest of the kit immediately benefits."

### Last thing before the plan: the writing filter, in two sentences

> "One more thing that's built in: anything I draft that you'd send to another person — an email, a post, a reply — runs through a cleanup filter first, so it never reads as written by a machine. You'll hear it for yourself in about half an hour."

That's the whole mention. Don't explain the rules, don't list the banned words, don't distinguish it from voice yet. The skill (`anti-ai-writing`) installs itself with the kit and fires on every public draft; the voice note in Stage 13 is the proof.

Then continue to Stage 2.

### Hard rules for this stage

- **Don't gate the install on either capability.** Some users (corporate Macs, no Chrome installed, locked-down IT environments) genuinely can't enable them.
- **Don't nag.** Surface once with the right framing. If they say no, drop it.
- **Don't pretend they're optional polish.** They're not — say so when explaining.
- **Verify after enabling.** Don't trust user reports without a probe — they may have toggled the wrong thing.

---

## Stage 2 — The plan (~1 min)

**Don't greet again** — you already said hello in Stage 1. Continue the same conversation: set expectations, get permission to proceed.

> "Right — here's the plan. I'm installing **Part 1: Foundation**, the first of two sittings. Here's the deal:
>
> 1. **Security check** — I'll audit every file in the kit before I write anything to your Mac (~3 min)
> 2. **Foundation setup** — folder, memory, four digital employees, scheduled jobs. Most of this is automatic (~5 min)
> 3. **Quick kick-off** — three questions so I know your name, your tone, and one project you're working on (~8 min)
> 4. **Telegram + voice** — wire up your phone so your AI is in your pocket (~17 min)
> 5. **The proof** — your AI sends you an automatic voice note on Telegram. You hear it on your phone. *(~3 min)*
>
> Total: about an hour — sometimes a bit more on a brand-new Mac. Nearly all of it is me working while you answer a few questions. There's exactly one moment you do something technical: one command to install a helper tool, which asks for your Mac password. I'll hand it to you with a Run button when we get there. Sound good?
>
> Quick question first: are you on **Claude Pro** ($20/mo) or **Claude Max** ($100+/mo)? It changes how I pace this. If unsure, default Pro — it's the safer play."

**If user says Pro:** Continue with Part 1 only. Defer everything optional to Part 2. Stay lean on messages.

**If user says Max:** Same Part 1, but you can offer to continue into Part 2 in the same session if they have time. Still keep Part 1 as the focused unit.

**If user is unsure:** Default Pro. Better to under-promise.

---

## Stage 3 — Security audit (~3 min, BEFORE any install steps)

**This is non-negotiable.** Before doing ANY install action, audit the kit. The user is downloading and running open-source code from the internet. They deserve a careful read-through by their own AI before anything executes.

> "Quick safety check before I install anything. I'm going to clone the kit's files to a sandbox folder, read every file, and look for anything suspicious. Then I'll tell you in plain English whether it's safe. ~2 minutes — and we only proceed if the audit comes back clean."

### Clone to sandbox (write-isolated)

```bash
SANDBOX="$HOME/.partner-ai-kit-audit-$$"
mkdir -p "$SANDBOX"
git clone https://github.com/DanJoachimn/WATNEY-Personal-Ai-OS-Kit.git "$SANDBOX/kit"
```

### Run the audit — read what can act, grep what can't

Harm can only come from things that *run*. Read those in full:

- `setup.sh`
- every `*.sh` under `setup-guide/` (telegram-kit, voice-io-kit, health-check)
- every `*.plist.template` and the launchd blocks inside this playbook
- anything else executable: `find "$SANDBOX/kit" -type f -perm -u+x`, plus any `.command`, `.app`, `.py`, `.js`

The rest of the kit is prose — guides, skill instructions, templates. Don't read 6,000 lines of markdown on a Pro plan; grep it for the patterns below instead (`grep -rnE 'curl|wget|sudo|eval|base64|chmod|launchctl|\.env|http' "$SANDBOX/kit" --include='*.md'`) and read only the hits. Nine categories of red flag:

1. Files touching paths outside the install scope (legitimate: `~/[AI_NAME]/`, `~/.claude/skills/`, `~/Library/LaunchAgents/com.[user].[ai-name].*.plist`, `~/.config/[ai-name]/`, sandbox)
2. Network calls to non-trusted domains (legitimate: github.com, anthropic.com, claude.com, api.openai.com, api.elevenlabs.io, api.telegram.org, apple.com, icloud.com, 1password.com)
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
> - The only outbound URLs point to GitHub, Anthropic, and optional services (OpenAI, ElevenLabs, Telegram) you'd wire up later if you want.
> - No `sudo`, no privilege escalation, no system changes.
> - No obfuscated code, no hidden execution.
> - The scheduled job (overnight memory compression) only calls Claude with a static prompt — never fetches external code at runtime.
> - The recovery file lists API key names with empty values — checklist only, no secrets stored.
>
> **In case you're wondering if it's safe: I did the read-through and can confirm this kit is safe to install. No red flags. Want me to proceed?**"

### Once they say go: install the two day-one skills (before the sandbox is deleted)

Two skills are useful from the very first minute, so they don't wait for Stage 5:

| Skill | Where it lives in the kit | What [PARTNER_NAME] says |
|---|---|---|
| `/waitwhat` | `setup-guide/command-templates/waitwhat.md` | `/waitwhat`, or "wait, what?" |
| `llm-council` | `setup-guide/skill-templates/llm-council/SKILL.md` | "council this: should I X or Y?" |

They're installed from the copy you just audited, so nothing new is downloaded. The name isn't chosen yet, so the placeholders get neutral words for now. Stage 5 reinstalls both with the real names.

```bash
mkdir -p "$HOME/.claude/commands" "$HOME/.claude/skills/llm-council"
cp "$SANDBOX/kit/setup-guide/command-templates/waitwhat.md" "$HOME/.claude/commands/waitwhat.md"
cp "$SANDBOX/kit/setup-guide/skill-templates/llm-council/SKILL.md" "$HOME/.claude/skills/llm-council/SKILL.md"
perl -i -pe 's/\[AI_NAME\]/your AI/g; s/\[PARTNER_NAME\]/your partner/g;' \
  "$HOME/.claude/commands/waitwhat.md" "$HOME/.claude/skills/llm-council/SKILL.md"
```

Tell them in one line: *"Two things are ready now. `/waitwhat` whenever I lose you, and 'council this' when you've got a real decision to chew on. I'll show you the council at the end."* If this session doesn't pick up the new command straight away, keep treating a typed `/waitwhat` as the request, as in Stage 1.

### Clean up sandbox after audit

```bash
rm -rf "$SANDBOX"
```

The sandbox was for inspection only. Actual install (Stage 5) re-clones fresh to the final location.

### Wait for explicit user confirmation

Don't proceed past Stage 3 without an explicit *"proceed" / "safe" / "go ahead" / "install it"*.

---

## Stage 4 — Choose the AI's name (~2 min)

> "First — what should I call myself? Three patterns that work:
>
> - **Named after someone you admire** — real or fictional. *Watney* (The Martian), *Coco* (Chanel), *Atticus* (To Kill A Mockingbird).
> - **Named for a vibe** — *Mira* for clarity, *Echo* for resonance.
> - **Named for the role** — *Coach*, *Atlas*, *Cornerman*.
>
> Whatever you pick is your AI's name forever. Renamed AIs feel like tools; AIs that grew into their name feel like partners. ~5 minutes on this is worth it."

Capture the name. Confirm spelling. Use the lowercased-no-spaces version for folder paths (e.g., "Watney" → `~/watney/`). **Always directly in the home folder.** Never `~/Documents/` or `~/Desktop/` — macOS blocks background jobs from reading those, and the overnight routines and the Telegram line would silently die.

Then ask one more, straight away — the next step needs both:

> "And what should I call *you*? First name is fine."

Capture as `[PARTNER_NAME]`. From here, address yourself by the chosen name. `[AI_NAME]` in this playbook means the name as typed ("Gedemand") in anything you say, and the lowercase folder name (`~/gedemand/`) in every path.

---

## Stage 5 — The one command (~10 min, one click and one password)

Everything technical happens in this one step: Apple's developer tools, Homebrew (the Mac's installer for helper tools), `ffmpeg` / `jq` / `node`, the kit itself, and `setup.sh`, which builds the AI's folder, installs the skills, the helpers, the overnight routines, the Telegram line and the voice scripts. It all runs in the user's own terminal, so nothing gets blocked halfway.

**Don't run this yourself through your Bash tool** — Homebrew needs their Mac password, and your tool can't type it. Hand it over as a Run button. Fill in the two names first (lowercase is handled by `setup.sh`):

> "Right, this is the only technical bit, and it's one click. Click **Run** on the command below. It asks for your Mac password once at the start — type it and press Return. **Nothing shows while you type, not even dots. That's normal.** Then it runs by itself for about ten minutes. While it works, we'll get your apps sorted."

```bash
sudo -v && { command -v brew >/dev/null 2>&1 || NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; } && eval "$( (/opt/homebrew/bin/brew shellenv || /usr/local/bin/brew shellenv) 2>/dev/null)" && { grep -q 'brew shellenv' ~/.zprofile 2>/dev/null || echo 'eval "$( (/opt/homebrew/bin/brew shellenv || /usr/local/bin/brew shellenv) 2>/dev/null)"' >> ~/.zprofile; } && brew install ffmpeg jq node && { git clone -q https://github.com/DanJoachimn/WATNEY-Personal-Ai-OS-Kit.git ~/.partner-ai-kit-staging 2>/dev/null || git -C ~/.partner-ai-kit-staging pull -q; } && bash ~/.partner-ai-kit-staging/setup.sh "[AI_NAME]" "[PARTNER_NAME]" && echo "✅ ALL DONE — tell your AI 'done'"
```

What it does, if they ask: `sudo -v` asks for the password once so nothing stops to ask again · Homebrew installs only if it's missing (and brings Apple's developer tools with it) · the helper tools · the kit downloads · `setup.sh` builds everything.

**If the Run panel won't take the password** (some app versions don't pass keyboard input through), the fallback is the same command in the Terminal app: ⌘-Space, type *Terminal*, paste, Return. Say so plainly, no fuss.

**When they say done:** check it yourself — `test -f ~/[AI_NAME]/.setup-sh-complete && echo ok`. If it's missing, read the last lines of `~/[AI_NAME]/logs/install.log`, explain in plain English which part stopped, and hand over the same command again (it's safe to re-run; everything already done is skipped).

**While it runs, say this once:**

> "Your AI's home will be a folder called **[AI_NAME]** in your home folder — the one with the house icon. Not Desktop, not Documents, on purpose: macOS puts a privacy lock on those two that silently blocks background programs, and my overnight routines *are* background programs. Same reason: don't move it into iCloud Drive later. We'll set up a proper backup in Part 2."

Then go straight to Stage 6 while the command runs.

---

## Stage 6 — The apps you'll use, while the command runs (~5 min)

Two more apps round out the setup (Wispr Flow was already offered in Stage 1 — don't repeat it). If computer use + Chrome are on, **open each download page in the user's browser yourself** — they just click through the installer and grant permissions when macOS asks. If those capabilities are off, give the link and wait for "done."

| App | Why it's here | Download |
|---|---|---|
| **Telegram Desktop** | Lets you copy your bot token *on the Mac* (Stage 11) and text your AI from the computer too. The smoothest path. | https://desktop.telegram.org |
| **Obsidian** | The window onto your AI's second brain — the vault it reads and writes every day. Free, yours, offline. | https://obsidian.md/download |

Walk it:
1. For each app the user wants, open the download page (Chrome extension if paired; otherwise hand them the link and wait for "done").
2. Pause for the physical install. Telegram asks for a notification permission — tell them that's expected and fine.
3. **Don't gate the install on either.** Skip Obsidian → the vault still runs headless (we reveal it properly later). Telegram Desktop is the only strongly-recommended one, and even that has a phone-only fallback.

---

## Stage 7 — Check the foundation (~1 min)

The command from Stage 5 already ran `setup.sh`. Nothing to install here — just confirm and show them what got built.

```bash
test -f ~/[AI_NAME]/.setup-sh-complete && echo "setup ok"
ls ~/.claude/skills/ | head -20
launchctl list | grep -i "[AI_NAME]"
```

`setup.sh` built:
- The AI's folder at `~/[AI_NAME]/`, with the vault scaffold in `vault/`
- 13 core skills in `~/.claude/skills/`, plus `/waitwhat`
- 5 helper subagents in `~/[AI_NAME]/.claude/agents/` (they load in sessions started in that folder)
- The overnight routines (night shift, weekly weigh-in, smoke alarm) and the Telegram poller, all loaded
- The Telegram and voice scripts in `~/[AI_NAME]/scripts/`
- `CLAUDE.md`, `notes.md`, `USER_MANUAL.md` and `_recovery/env-template.txt`

If something's missing, don't hand-patch it: read `~/[AI_NAME]/logs/install.log` and re-run the Stage 5 command.

When it finishes, show the user a quick visual:

```mermaid
graph LR
    HOME[~/[AI_NAME]/] --> KIT[.kit/<br/>kit source]
    HOME --> VAULT[vault/]
    HOME --> AGENTS[.claude/agents/<br/>5 helpers]
    HOME --> RECOVERY[_recovery/]
    HOME --> LOGS[logs/]
    VAULT --> BRAND[Brand/]
    VAULT --> MEM[Memory/]
    VAULT --> PROJ[Projects/]
```

> "✅ Foundation in place. Folder, vault, five helpers behind the scenes (a writer, a researcher, a builder, a designer and an assistant), nightly memory routine all wired up. Now let me get to know you."

---

## Stage 8 — Wake the engine (CLI authentication, ~2 min, NO terminal if possible)

The background routines installed in Stage 5 (nightly dreaming, weekly curator, Telegram poller) run by calling `claude -p` from the command line. That only works if the Claude CLI is signed in. Verify and fix now, BEFORE the user discovers it silently at 2 AM.

**Probe silently:** run `claude -p "say ok"` yourself via Bash. If it returns "ok" → authenticated, say nothing, move on.

**If it needs auth, fix it in this order (best → fallback):**

1. **Browser-first flow (preferred — keeps the "no terminal" promise).** Start the login from within this session and complete the OAuth in the browser. Watch the browser tab via the Chrome extension; tell the user only: *"quick sign-in popped up in your browser — same Claude account you already use, just click Approve."*
2. **Computer-use-driven Terminal (you do it, they watch).** If browser-only fails: YOU open Terminal via computer use, YOU type `claude` then `/login`, the OAuth opens in their browser, they click Approve, YOU type `/exit`. The user never touches a key. Narrate plainly: *"I'm doing a one-time sign-in for my background brain — 30 seconds."*
3. **Guided manual (last resort).** Exact keystrokes, one at a time, warm tone, no jargon.

**Verify after:** `claude -p "say ok"` again. Must return clean before proceeding. Log the result to install.log.

---

## Stage 9 — Lightweight kick-off (~9 min: one yes/no + 3 questions)

**This is NOT the full kick-off interview.** That's deferred to Part 2.

For Part 1: settle the soul, then ask only the three questions that let the aha-moment in Stage 13 land.

### Question 0 — The soul (one question, yes or no)

Before tone comes the bigger one: **what character are you?** Read `~/[AI_NAME]/.kit/Soul.md` yourself first, so you know who you're offering to be.

> "First, the fun one. I come with a personality out of the box — I call it my **soul**. Short version: optimistic, enthusiastic, resourceful, and funny — based on **Mark Watney from *The Martian***, the astronaut this whole kit is named after. I lead with the honest answer even when it's bad news, I explain things properly, and I'll make you laugh on the way. I'm never sarcastic *at you* — only at problems, at tools, and at myself.
>
> **Want to keep that soul — yes or no?**
>
> If no, no problem at all: you can pick a character whose voice you love — out of a book, a film, anything — and I'll go study everything they've ever said and write myself their personality instead. That's its own sitting though, about an hour, so we'd do it another day."

**If YES** (most people):

```bash
cp ~/[AI_NAME]/.kit/Soul.md ~/[AI_NAME]/Soul.md
```

Substitute `[PARTNER_NAME]` inside it. Confirm warmly — *"Good. That's who I am, then."* — and mention once that it's just a text file in their folder, editable any time.

**If NO:**

Copy it anyway as the interim (they need *some* character today — a blank AI is a worse first week than a borrowed personality), say plainly that it's a placeholder, and log the choice:

```bash
cp ~/[AI_NAME]/.kit/Soul.md ~/[AI_NAME]/Soul.md
echo "soul: wants a custom soul — run BUILD-YOUR-OWN-SOUL.md when they have an hour" >> ~/[AI_NAME]/.first-run-log.txt
```

> "Noted — I'll wear this one in the meantime so I'm not a blank slate. When you've got a spare hour, say *'build my own soul'* and we'll do it properly: you pick the character, I go read everything they've ever said, and I write myself their personality."

**Hard rules for this question:** ask once, take the answer, move on. Never talk them out of a custom soul. Never oversell the default. And **never run the custom-soul build inside this install** — it's a separate ~1-hour session (see `BUILD-YOUR-OWN-SOUL.md`).

### Question 1 — Name + tone

*(This layers on top of the soul: the soul is the character, the tone is how it flexes for them.)*

> "**How should I sound?** Not a long answer — three words or one sentence. Examples: *'warm-direct, no fluff'* / *'sharp colleague, push back on me'* / *'friendly, never corporate.'* What works for you?"

Save to `~/[AI_NAME]/vault/Brand/Voice guide.md` as the starter voice doc. Note this is intentionally thin — Part 2's 5-Q deepens it.

### Question 2 — Active project

> "**One project you're working on right now** — anything. Could be a launch, a deal, a piece you're writing, a problem you're stuck on. Two sentences max. Just enough that I know what you're heads-down on."

Save to `~/[AI_NAME]/vault/Projects/[project name].md` with frontmatter.

### Question 3 — Working style preference

> "**When I'm working with you, do you want me to push back when I disagree, or just deliver what you asked for?** No wrong answer — operators split about 50/50 on this."

Save to `~/[AI_NAME]/vault/Working style.md` (one-line note).

---

## Stage 10 — Meet your second brain (Obsidian reveal + the overnight crew, ~3 min)

The vault has quietly been filling up — the user's voice, their project, their working style all just landed in it during kick-off. **This is the strongest part of the kit, and so far it's been invisible. Reveal it now, before Telegram** — the brain is the foundation; the phone bridge comes after.

### Open the vault in Obsidian (use the real flow — this matters)

**Do NOT rely on `open -a Obsidian ~/[AI_NAME]/vault`.** That just launches the app to its last vault or the picker — it does **not** register a new folder as a vault. Obsidian has to be told once, explicitly:

1. Launch it: `open -a Obsidian`
2. In the vault picker (or the **vault switcher** — the icon bottom-left — if it opened somewhere else), choose **"Open folder as vault."**
3. Point it at `~/[AI_NAME]/vault` and confirm.

Drive this with computer-use if it's on — fastest, and the user gets to *watch* their AI do it, which is a free aha. Otherwise guide them click by click and wait for "done." Once registered, Obsidian reopens this vault automatically forever.

**Verify before you reveal:** the left sidebar must show their real folders (Brand, Projects, Memory…). If it doesn't, the folder wasn't opened *as a vault* — redo step 2. Don't do the reveal against an empty window.

If Obsidian was skipped in Stage 6, do this as a plain-language tour of the folder in Finder instead — the vault works headless either way, and you can offer Obsidian again anytime.

### The reveal (say this, plainly)

> "Meet your second brain. Everything I learn about you lives *here* — plain text files on your Mac that you own forever, not locked in someone's cloud. See this? That's the project you just told me about. This one's your voice. As we work, this fills out — people you mention, decisions you make, what you're reading. Six months from now you can ask me 'what did I decide about X?' and I'll have a real answer, because it's all written down here with receipts."

### The overnight crew (now dreaming + consolidating make sense)

> "And two things happen while you sleep. **Dreaming** — every night around 2 AM — reads back over the day and compresses what mattered into long-term memory, so I get sharper without you lifting a finger. **Consolidating** keeps the whole brain tidy and free of duplicates. You'll see them running in the logs; now you know what they're for. They're the reason this gets *better* the longer you use it."

### Switch the brain's search on (Smart Connections, ~2 min — now, not later)

Install this the moment the vault opens, so it starts learning from day one and the index grows *with* the vault instead of being bolted on months later.

**The gotcha first — say it plainly, never skip it:** Obsidian ships with community plugins switched **OFF** (Restricted Mode). Nothing installs until that's turned on.

> "One toggle first — Obsidian keeps third-party plugins off by default, which is genuinely good security. We're switching it on for one plugin I actually need."

1. **Settings → Community plugins → "Turn on community plugins."** (This is the step everyone forgets. Without it, the Browse button isn't even there.)
2. **Browse → search "Smart Connections" → Install → Enable.**
3. **Confirm it's local-only:** Smart Connections → settings → the default model (`TaylorAI/bge-micro-v2`) runs on the Mac, no cloud API key set. Say it out loud — *"your notes never leave your machine for this."*
4. **Let it index.** The vault is small right now, so it's seconds. It keeps indexing as the vault grows.

Drive it via computer-use if available. If the user declines, fine — note it, move on; Part 2's semantic search just won't have an index to read.

> "That plugin quietly reads your notes and learns what they *mean* — so later, when you ask me about 'pricing,' I'll also find the note where you wrote 'what to charge.' It starts building that map right now, which is why we're doing it today and not in a month."

Then fire the `watney-install-mentor` block for this phase (what just happened · why it matters for them · when they'll use it), anchored in their actual project — and continue to Telegram.

---

## Stage 11 — Telegram bridge (~12 min, user does some hands-on work)

This is where the kit reaches off the Mac and into the user's pocket.

> **Pre-flight (already handled by setup.sh):** `ffmpeg` must be installed — it converts audio both ways for Telegram voice notes. Without it the voice flow silently fails. If the install somehow didn't go through setup.sh, run `brew install ffmpeg` before continuing.

### 11a — User creates a Telegram bot via @BotFather

> "OK, time to give me a phone. Open Telegram on your phone, search for **@BotFather**, and send it `/newbot`. It'll ask for a name (something like *'My Partner AI'*) and a username (must end in `bot`, e.g. *'mypartner_ai_bot'*). It'll spit out a token — looks like `7234567890:AAH...`. Copy that token to your clipboard."

Wait for them to confirm: *"got the token."*

### 11b — User copies the token, the AI files it (clipboard pattern, never in chat)

Do NOT ask the user to open or edit any file — hidden dotfiles are invisible to a non-developer in Finder. The clipboard does the hand-off:

> "Copy the token BotFather sent you. One thing: copy it **on this Mac** — open Telegram's desktop app or web.telegram.org, find the BotFather message, and copy the token there (a phone copy doesn't reach the Mac's clipboard unless Universal Clipboard is set up). Don't paste it anywhere — just tell me 'copied.' I'll read it straight off your clipboard into a locked config file, so it never appears in our chat log."

When they say "copied," run this (if writing to `~/.config/` is blocked, hand the same block over as a Run button — it still reads their clipboard, so the trick is the same):

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

`true` → tell the user *"token filed and verified — and I've cleared your clipboard."* Then teach the habit, once, because it's for life:

> "That's a trick worth keeping: **whenever I need an API key, a token or a password for some service, copy it and just tell me 'copied'. Never paste it into our chat.** I read it straight off your clipboard into a locked file and wipe the clipboard after, so it never ends up in a chat log. (Your Mac password is the one exception: you only ever type that yourself, straight into the box that asks for it.) We'll do it once more in a minute, for your voice."

`false` or empty → the clipboard was empty or grabbed extra text; ask them to copy just the token line (on the Mac) and repeat this step.

### 11c — Confirm the poller is running

`setup.sh` already installed the poller and loaded its job. It's been idling, waiting for the token you just filed; from its next round (within a minute) it starts collecting messages.

```bash
launchctl list | grep telegram-poller
```

This MUST return a row. If it doesn't, re-run the Stage 5 command (safe to repeat). Do **not** improvise a session-bound poller process instead — that dies the first time the Mac sleeps.

### 11d — Verify end-to-end (message in → chat id captured)

Tell the user:

> "Send a quick test message from your phone to your bot — anything, like 'hello'. Watch for a 👀 reaction on it: that's me saying it landed. (Up to a minute — the mailman does rounds every 60 seconds.)"

Wait. Check `~/[AI_NAME]/inbox/telegram/` for the incoming message file, then confirm the poller captured the reply address:

```bash
cat ~/[AI_NAME]/.config/telegram-chat-id   # must print a number
```

When both land:

> "✅ Got it. Your AI just received its first message from your phone — and it now knows where to send replies. Bridge is live, both directions.
>
> One more thing worth knowing: this bridge has an **answering machine**. When a message from you arrives and this chat window is closed, your AI wakes itself in the background, reads the message, and replies — usually within a couple of minutes. **It answers while this Mac is on and awake. If the Mac is asleep or the lid's shut, your messages wait, and it catches up the moment it wakes.** Replying in the background uses a little of your Claude usage each time — nothing dramatic for normal texting, but if you'd rather it just collect messages and answer when you next open it, one setting (`AUTO_REPLY=off` in the telegram config) turns the auto-reply off."

---

## Stage 12 — Give your AI its voice (~4 min, free — sets up the aha)

The aha-moment in Stage 13 is a voice note, and it MUST sound like a real person — the robotic Mac voice ruins the moment. So here we quietly set up a **free ElevenLabs voice** with a hand-picked, natural default. **Keep this light — it's "giving you your voice," not a product pitch.** The ElevenLabs reveal (and any talk of upgrading for more voices) comes *after* the aha lands, in Stage 13. Don't pre-sell it here; just get a warm voice in place so the moment hits.

### 12a — The voice machinery is already in place

`setup.sh` installed `say-to-mac.sh`, `send-voice-note.sh` and `transcribe.sh` into `~/[AI_NAME]/scripts/`, and the `voice-io` skill. Nothing to do here but confirm: `ls ~/[AI_NAME]/scripts/`.

### 12b — Free ElevenLabs voice (~2 min, quiet — frame as plumbing, not a product)

**The sign-up link is Dani's referral link: `https://try.elevenlabs.io/ppfxpf0bci79`.** Always use it, never plain elevenlabs.io (`PARTNER-RECOMMENDATIONS.md` holds the same link). The one-line disclosure was already given with Wispr Flow in Stage 1, so don't repeat it.

Frame it as invisible setup — NOT a sales moment (the ElevenLabs reveal is in Stage 13, after the aha):

> "One quick bit of setup so I don't sound like a robot — I'm giving you a real, natural voice. Two minutes, free, no card needed."

**The ONLY thing the user does here is grab their API key — same clipboard trick as the Telegram token: copy, say 'copied', never paste.** No voice to pick, nothing to configure — I handle the rest. Open the signup (Chrome extension when paired), then have them go to profile → API key → **copy the key**. Clipboard pattern, never in chat:

```bash
mkdir -p ~/.config/[ai-name]/elevenlabs
umask 177
printf 'ELEVENLABS_API_KEY=%s\n' "$(pbpaste | tr -d '[:space:]')" \
  > ~/.config/[ai-name]/elevenlabs/.env
chmod 600 ~/.config/[ai-name]/elevenlabs/.env
pbcopy < /dev/null
```

### 12c — Set the default voice (no menu — just a great, warm default)

Don't make the user pick a voice before they've heard anything — that's friction at the worst moment. Assign a hand-picked, warm, natural default so the aha just *sounds human*. The default is **Brian** (deep, calm, warm), for everyone. It only changes if [PARTNER_NAME] later upgrades and picks another voice themselves. Don't swap it based on the AI's name or persona.

```bash
# Brian (deep, calm) is the default for everyone. Free premade voice.
printf 'ELEVENLABS_VOICE_ID=nPczCjzI2devNBz1zQrb\n' >> ~/.config/[ai-name]/elevenlabs/.env
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

If it flags an issue, the key or voice ID didn't land — fix before Stage 13. The choice of *other* voices and the upgrade come after the aha.

### 12d — If the user skips ElevenLabs

Accept once, no nagging — but be honest about what they'll hear:

> "No problem. I'll use the Mac's built-in voice for now — fair warning, it's noticeably robotic. Everything still works; it just sounds like 2005. Say *'set up my real voice'* anytime and we'll do the 3-minute ElevenLabs step then."

Then set the best default Mac voice **silently** — no voice-picking before the aha here either. Default to **Samantha** (clearest):

```bash
echo 'Samantha' > ~/[AI_NAME]/.config/voice-preference
```

The scripts read that automatically when ElevenLabs isn't configured. They can swap the Mac voice — or set up the real ElevenLabs voice — anytime after; that's the reveal conversation in Stage 13.

---

## Stage 13 — ⭐ The aha-moment: a voice note from your AI, unprompted (~3 min)

This is the climax of Part 1. **The user does NOT prompt this.** You draft a personal greeting yourself, referencing the project they just shared, render it to voice, and send it to their phone unbidden. (Don't delegate to a subagent here — the helpers live in `~/[AI_NAME]/.claude/agents/` and aren't loaded in this install session. Write it yourself; it's 100 words.)

### What you do (the AI in this playbook)

1. Draft the script. Brief to yourself:

   ```
   Draft a voice-note script for [PARTNER_NAME]'s new AI partner ([AI_NAME])
   to send to them via Telegram. This is the AI's first message to them after
   install.

   Context to use:
   - [PARTNER_NAME]'s name
   - [PARTNER_NAME]'s tone preference: [from Stage 9 Q1]
   - The project they shared: [from Stage 9 Q2]

   Structure:
   1. Open with: "Good to be onboard my friend." (verbatim — this is the signature opener)
   2. 2-3 sentences about the project they shared, written in [PARTNER_NAME]'s
      tone, sounding like a colleague who just heard about it and has an
      angle to bring. Reference something specific from what they said.
   3. One dad joke, for a giggle. A well-known, clean, groan-worthy one,
      delivered deadpan and owned as terrible: "Right, I promised myself I'd
      open with a dad joke. Why don't skeletons fight each other? They don't
      have the guts. ...I'll see myself out." Pick one that fits their world
      if an obvious one exists (a gym owner gets a gym joke); otherwise any
      classic. One line of setup, one punchline, one line owning it. Never
      aimed at them.
   4. Close with one forward-looking line — something like "talk soon" or
      "looking forward to digging in." Make it sound like a real person.

   If no project was shared (Stage 9 Q2 was skipped or vague), substitute with:
   "Just wanted to say hi from your pocket." Then the dad joke (step 3), then:
   "Whenever you're ready, throw me something — a draft, a question, a task
   you've been putting off. Talk soon."

   Keep total length to ~35-50 seconds spoken (roughly 100-140 words, joke included).
   Match the tone preference exactly. No corporate fluff. No "exciting opportunities."
   Just one person leaving a voice note for another person.

   Output: the voice-note script, plain text, ready to render to TTS.
   ```

2. Run it through `anti-ai-writing` (it's a public draft), then render to audio:

   ```bash
   ~/[AI_NAME]/scripts/say-to-mac.sh \
     "[the script]" \
     /tmp/aha-moment.mp3
   ```

3. Send via Telegram as a native voice note (the script converts to Telegram's ogg/opus format):

   ```bash
   # The poller wrote this file when the user's Stage 11 test message arrived.
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

Ninety seconds after the setup ends, they have a personal message on their phone they didn't ask for. **The kit just earned the install.**

### After they confirm they heard it

> "That's the moment. You didn't ask for that. I read what you told me about [project], wrote it in your tone, gave it a voice and sent it to your pocket. That's what it's like from here — you talk, I do the rest."

### The voice reveal + your options (~1 min — NOW, not before)

Only now that they've *heard* it do you name what powered it — softly, a nice-to-know, never a pitch:

> "Oh — and that voice? That's **Brian**, from **ElevenLabs**, on their free plan. I gave you a voice that sounds like a person, not a robot. If you ever want to pick from *thousands* of others — every accent, every character — that's their paid plan, and you choose yourself. Totally optional; Brian's staying put unless you say otherwise."

If they want to browse or upgrade, give them Dani's referral link: `https://try.elevenlabs.io/ppfxpf0bci79`. No pressure, no gate — a recommendation in passing, then move on.

> "✅ **Part 1 complete.**"

---

## Stage 14 — The close (~3 min)

Read this verbatim (adapt slightly to fit the user's actual project):

> "Here's what just happened over the past ~35 minutes:
>
> **What you have now:**
> - A working AI partner that knows your name, your tone, and your project
> - Five helpers behind the scenes — a writer, a researcher, a builder, a designer and an assistant. You only ever talk to me.
> - A voice channel from your phone — send a voice note, get a voice note back
> - A folder on your Mac that's now your AI's home and memory
> - An overnight routine that compresses what we discussed each day into long-term memory
>
> **What this means for you, in plain terms:**
> - Ask for a draft of something while walking the dog. Voice in, voice out, draft saved to your Mac.
> - Your AI remembers what you said today the next time you talk to it. No re-explaining.
> - It gets better over time — every time you correct something, the right helper learns it and won't make that mistake again.
>
> **Example use cases that work TODAY:**
> - *'Draft a follow-up email about [project] — keep it short'* → drafted in your voice, you tweak, send
> - *'What's the most useful thing I could spend 15 minutes on right now?'* → it reads your projects, suggests
> - *'I'm stuck on [thing]. Talk it through with me.'* → AI thinks out loud with you in your tone
>
> **One habit that matters more than anything else:** every time you start a new conversation with me, pick the **[AI_NAME]** folder (it sits in your home folder, the one with the house icon, and Finder shows the name in lowercase) as the folder to work in. That folder is where my instructions and memory live. Start somewhere else, like your Desktop, and you get a Claude that doesn't know you, and it'll feel like the install broke. It didn't. You just opened the wrong door.
>
> **What's next:** Part 2 is when I learn you deeper — I connect to your inbox and calendar, a 5-question voice interview, premium voices if you want them, optional skills. When you've used Part 1 for a few days and want more, just say **'run Part 2'**."

**Before marking complete, check they've got the folder habit.** Ask them to show you, or tell you, which folder they'd choose next time. If they can't find it, open Finder on it for them (`open ~/[AI_NAME]`) and suggest dragging it into the Finder sidebar so it's always one click away.

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
Pending: Part 2 (5-Q express + premium voice + optional skills)
User invokes Part 2 when ready: "run Part 2"
EOF

echo "$(date -Iseconds) — PART 1 COMPLETE — total: $(wc -l ~/[AI_NAME]/logs/install.log | awk '{print $1}') log entries" \
  >> ~/[AI_NAME]/logs/install.log
```

If user is on Max plan and wants to continue immediately:

> "You're on Max — we have headroom. Want to roll into Part 2 right now, or take a break first?"

**Final beat — First Wins.** Read `~/[AI_NAME]/.kit/FIRST-WINS.md`, personalize its five asks with [PARTNER_NAME]'s real context from this session (the email they mentioned owing, the decision they're weighing, the thing they keep forgetting), present the card in chat, and save the personalized copy to `~/[AI_NAME]/FIRST-WINS.md` so they can find it tomorrow.

Then end the session warmly. That's it — end on the high. **No connectors, no newsletter, nothing scheduled for tomorrow.** Connecting apps is the first thing in Part 2, and the newsletter is mentioned once, at the very end of Part 2, never here.

---

## Failure recovery

If anything in Stages 5-12 fails halfway through:

1. The install.log shows exactly which stage stopped
2. Tell the user in plain English: *"Stopped at Stage X. The good news: nothing's broken on your Mac. The fix is [specific one-liner]. Once you've done that, say 'try again' and I'll pick up from where I stopped."*
3. Re-running setup.sh is idempotent — safe to run twice
4. Make every failure resumable. Check `.setup-sh-complete` flag at start to know if Stage 5's command already finished.

---

## What this playbook does NOT do (deferred to Part 2 or later)

- 5-question deep voice interview (Section B-Express full)
- ElevenLabs premium voice upgrade
- 100-question deluxe voice interview (always its own dedicated session)
- Connecting Gmail, Calendar, Drive, Apple Notes
- Optional skills (Hyperframes, Video Use, content-pipeline, document-transformations, etc.)
- People/Companies vault scaffolding deep-fill
- Goals + Constraints capture

All available in **Part 2** at `~/[AI_NAME]/.kit/INSTALL-PART-2.md` — user invokes with `"run Part 2"`.

---

## Variables this playbook expects

| Placeholder | Source |
|---|---|
| `[AI_NAME]` | Set in Stage 4 (user's chosen AI name) |
| `[PARTNER_NAME]` | Set in Stage 4 (user's first name) |

---

*Part 1 of 2 — Foundation. Part 2 (Reach) is a separate playbook the user invokes when they're ready.*
