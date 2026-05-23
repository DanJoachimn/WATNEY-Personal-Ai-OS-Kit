# INSTALL-PART-2.md — Part 2 (Reach) install playbook

> **This file is read by an AI agent when the user says "run Part 2" or "continue install" after completing Part 1.** Days, weeks, or months after Part 1 — doesn't matter. The kit's already in place; this playbook deepens it.

---

## When this fires

User says any of:
- "run Part 2"
- "continue install"
- "let's do Part 2"
- "deepen the setup"
- "more setup"
- "expand my partner"

OR: the AI offers it after the user has been using Part 1 for a few days and seems ready for more (proactive opportunity-spotting moment).

---

## Stage 0 — Greeting + check Part 1 is in place

```bash
test -f ~/Documents/[AI_NAME]/.part-1-complete || { echo "Part 1 not complete; redirect to INSTALL.md"; exit 1; }
```

If Part 1 isn't done → tell user, route them to `INSTALL.md` first.

If done → continue:

> "Good to see you back. Part 2 is where I learn you deeper. Here's what we'll do (~30 min, ~30 messages, fits comfortably in one Pro session):
>
> 1. **5-question voice interview** — sharper voice profile than Part 1's lightweight one (~10 min)
> 2. **ElevenLabs upgrade** — premium voices if you want them (~5 min, optional)
> 3. **Granola meeting capture** — auto-record + transcribe meetings (~5 min, optional)
> 4. **Optional skills** — Hyperframes, Video Use, content pipeline, document transformations, others (~varies)
> 5. **Siri & Apple Watch** — last because it's least essential and requires iOS work (~10 min, optional)
>
> Ready to start with the voice interview, or want to pick a different stage to go to first?"

---

## Stage 1 — 5-question voice interview (~10 min)

This is the **Section B-Express** from the original kick-off skill — kit-known-good, captures voice with real fidelity.

Invoke the kick-off skill's `B-Express` path directly:

```
Section B — Voice (5 questions)

B1. The one-line principle
> "If [BRAND/YOUR WORK] were a person walking into a room, what's
   the energy? One sentence."

B2. Target customer / audience
> "Tell me about the actual person reading [BRAND]'s output. Where
   do they shop? What do they aspire to? What do they fear?"

B3. Reference brands — tone
> "Three brands whose copy you'd genuinely kill for. Reading their
   stuff, you think 'yes — that's the world I should live in.'"

B4. Direct competitors — what NOT to do
> "Two brands in your direct space whose tone is wrong. What
   specifically grates?"

B5. Banned words / tropes
> "Words, phrases, or patterns that — if I ever wrote them in a
   draft for you — would make you reject the whole draft."
```

Capture answers verbatim. Write to:
- `~/Documents/[AI_NAME]/vault/Brand/Voice guide.md` (overwrite the Part 1 lightweight version)
- `~/Documents/[AI_NAME]/vault/Brand/Reference brands.md`
- `~/Documents/[AI_NAME]/vault/Brand/Do-not-use list.md`

Mark complete: `touch ~/Documents/[AI_NAME]/.voice-express-complete`

---

## Stage 2 — ElevenLabs upgrade (optional, ~5 min)

> "You've been using Mac's built-in voices since Part 1. ElevenLabs offers premium voices — more natural, more personality. Free tier covers ~10K characters per month at no cost. Want to set it up?
>
> If yes: I'll walk you through making a free account at elevenlabs.io, getting an API key, and pasting it into your config. ~5 min.
>
> If skip: stay on Mac voices. They work fine; this is purely a quality upgrade."

If yes:
1. Open https://elevenlabs.io in browser (via `osascript`)
2. Walk through signup
3. Get API key from Settings → API Keys
4. Use clipboard-transfer pattern: AI runs `pbpaste > ~/.config/[AI_NAME]/.env.tmp`, user copies key, AI moves to `.env` with proper formatting
5. Test: voice the user just heard renders via ElevenLabs voice instead

Mark complete: `touch ~/Documents/[AI_NAME]/.elevenlabs-configured`

---

## Stage 3 — Granola meeting capture (optional, ~5 min)

For users who take meetings (coaching calls, client calls, sales calls, internal). Auto-records, transcribes, syncs to vault.

Full setup in repo's `guides/10-meeting-capture-with-granola.md`. Quick steps:

1. User downloads Granola from granola.ai (if not already installed)
2. Grant microphone + system audio permissions
3. AI clones/installs `granola-sync` skill (already in `~/.claude/skills/` from Part 1)
4. Configure `granola-sync/scripts/config.py` with user's vault path + tag rules
5. Test sync — manual run produces files in `vault/Meeting Notes/`
6. Schedule via launchd (12:30 + 17:00 daily)

Mark complete: `touch ~/Documents/[AI_NAME]/.granola-configured`

---

## Stage 3.5 — Obsidian Web Clipper (browser → vault, ~3 min)

Vault feeder #2. Granola pumps meetings into the vault automatically. The Obsidian Web Clipper pumps the open web — articles, blog posts, YouTube pages, anything readable in a browser — into the vault as clean markdown, in one click.

Combined with the AI's vault-awareness, this means *"summarize what I've clipped this week"*, *"find the article I clipped about retention"*, or *"pull the strongest arguments from my last 3 clippings on X"* all just work — without the user ever copy-pasting an article body into chat.

> "Want to add the Obsidian Web Clipper? It's the cleanest way to feed articles, transcripts, and pages from the open web straight into your vault. ~3 min to install."

If yes:

1. Open Chrome (or Edge / Firefox / Safari) → install the **Obsidian Web Clipper** extension from the browser's store. Direct link: https://obsidian.md/clipper
2. Click the extension icon → it asks where your vault is. Point it at `~/Documents/[AI_NAME]/vault/`.
3. Recommend a folder inside the vault for clips: `vault/Clippings/` (Web Clipper creates it if missing). This matches the Hab schema convention for raw source material.
4. Pick the default template — the bundled "Default" template handles most cases (articles, blog posts, news). Templates for recipes, papers, and YouTube exist for users with specific use cases.
5. Test: open any article in the browser, click the Web Clipper icon, save. Confirm a new markdown file appears in `~/Documents/[AI_NAME]/vault/Clippings/`.

Mark complete:

```bash
touch ~/Documents/[AI_NAME]/.obsidian-clipper-configured
```

After install: the AI reads everything in `vault/Clippings/` as context — same way it reads the rest of the vault. User clips, AI absorbs, queries spanning "what's in my head + what I've been reading" become trivial.

---

## Stage 3.7 — Vault backup (~5 min, strongly recommended)

The vault has been collecting Julie's voice, projects, memory, brand rules, clipped articles, and (if Granola is wired) meeting notes. It's the second brain. **Without backup, a Mac failure means starting over.**

Three options ranked easiest first. Pick at least one. Picking two is the right answer for anyone who values what they're building.

### Easiest: Time Machine

Plug in an external drive. macOS Time Machine backs up hourly, automatically, covers your whole Mac (not just the vault). ~3 min setup.

- ✅ Mac-native, fully automatic
- ✅ Covers everything (vault + skills + system + photos + whatever else)
- ✅ Version history — scroll back through any state of any file
- ⚠️ External drive required (one-time ~$60 for a small SSD)

Walk-through: System Settings → General → Time Machine → Add Backup Disk → pick the plugged-in drive. macOS handles the rest.

### Strongest (recommended): Private GitHub repo

Off-platform backup. Full version history. Restore from any commit. Works even if Apple or Obsidian disappear tomorrow.

- ✅ Disaster recovery + complete version history
- ✅ Free (private repos are unlimited)
- ✅ Works alongside Time Machine — two layers, not exclusive
- ⚠️ Requires GitHub account (free if not already) + ~5 min setup

Walk-through:
1. If user has no GitHub account, open https://github.com/signup via Chrome extension, help them through signup
2. Create a private repo named `[ai-name]-vault` via `gh repo create [ai-name]-vault --private --description "Backup of my AI's vault"`
3. Inside the vault folder, init git + add the right `.gitignore` (exclude `_recovery/`, any `.env` files, anything secret) + initial commit + push
4. Schedule via launchd: nightly `git add . && git commit -m "vault backup $(date)" && git push` from `~/[AI_NAME]/.kit/scripts/git-vault-backup.sh`. The script lives at `~/[AI_NAME]/` (unprotected) so launchd can run it without TCC issues. The git push is a network call that doesn't touch `~/Documents/`.

Mark complete:

```bash
touch ~/[AI_NAME]/.github-vault-backup-configured
```

### Alternative: Obsidian Sync ($5–10/mo)

Vault-only sync with version history (1 year) and end-to-end encryption. Best if Julie wants her vault on multiple devices (Mac + iPad + iPhone via Obsidian Mobile).

- ✅ Multi-device + versioned + encrypted (not even Obsidian can read your notes)
- ⚠️ Paid subscription
- ⚠️ Vault-only — doesn't back up [AI_NAME]'s skills, scripts, config, recovery template

Walk-through in Obsidian app: Settings → Core plugins → Sync → enable → log in → pick which folders to sync. Point at `~/[AI_NAME]/vault/`.

### Don't: iCloud Drive

We deliberately don't recommend iCloud Drive for the vault. iCloud auto-sync requires moving files into `~/Documents/`, but macOS privacy controls (TCC) block background programs from reading or writing there — which includes [AI_NAME]'s Telegram poller and nightly dreaming routine. Picking this option would break [AI_NAME]'s always-on features within 24 hours.

If a user insists on iCloud (e.g., for cross-device access), the right answer is **Obsidian Sync** instead — same multi-device benefit, doesn't fight macOS TCC.

(We learned this the hard way during Install #1 — see `~/Desktop/Claude's Office/julie-install-friction-log.md` for the gory architectural details.)

---

## Stage 4 — Optional skills menu (varies)

### Optional skills

> "These are skills you can install now or anytime later. Each is independent. Tell me which interest you and I'll install just those — or say 'skip' and we move on.
>
> - **Hyperframes** — animated explainer videos by conversation (~5 min install). Need an animation? Tell me the script, I draft, you tweak.
> - **Video Use** — cut filler words + dead air from recordings (~5 min). For talking-head videos, podcasts, course content.
> - **Content pipeline** — multi-stage content production (research → draft → quality → distribute). For users producing newsletter/long-form regularly (~10 min).
> - **Document transformations** — mines meeting transcripts for case-study material. Pairs with Granola (~5 min).
> - **Book mirror** — turns books you've read (via Readwise highlights) into chapter-by-chapter synthesis docs (~5 min)."

Install only what user picks. Each installs via the standard skill pattern — copy template, substitute placeholders, optionally load launchd job.

### Optional MCP server additions

MCPs are different from skills — they're external servers that expose tools to the AI. One MCP server, one capability. Installed via Claude Code Settings → MCP servers → Add new → paste the server's command from its README.

> "Two MCP servers worth considering at this stage:
>
> - **youtube-transcript MCP** — fetches transcripts from any YouTube video by URL. Lets your AI summarize a video, fact-check claims in it, or pull quotes — without copy-paste. Pairs nicely with the Obsidian Web Clipper (clip the video page, fetch the transcript, ask for a synthesis). ~3 min to install. Search the Anthropic MCP registry or upstream for the current canonical package."

If the user adds youtube-transcript MCP, verify it works:

```
Test query: "Pull the transcript of this video: https://www.youtube.com/watch?v=<id>"
```

The AI should return the full transcript text without scraping issues.

Mark complete:

```bash
touch ~/Documents/[AI_NAME]/.youtube-transcript-mcp-configured
```

---

## Stage 5 — Siri & Apple Watch (EXPERIMENTAL — untested by kit author, ~10 min, LAST)

🚧 **Honest disclosure up front:** this stage has **not been verified by the kit author**.

- The **Siri path** is based on Apple's documented Shortcuts patterns and reads like it should work, but it hasn't been tested end-to-end on a real install yet. Scheduled for first real verification soon.
- The **Apple Watch path** is fully untested. The kit author does not own an Apple Watch. The instructions here are extrapolated from Shortcuts documentation, not from a working install.

If you try this stage, you're beta-testing it. Capture anything that breaks and we'll fold it into the kit's Common Failures section.

### Tell the user this — once, plainly

> "Last optional step, and I want to be straight with you: this one is experimental. The Siri integration looks like it should work based on how Apple's Shortcuts framework is designed, but I haven't tested it end-to-end yet on a real install. The Apple Watch piece is even less verified — the kit's author doesn't own a Watch, so those instructions are based on Apple's docs, not on a working setup.
>
> If you want to try it, great — you're beta-testing. If something breaks, tell me what you saw and we'll feed it back to the kit. If you'd rather skip until this is verified, totally fine — everything else in your install works without it. Want to try, or skip?"

If user wants to try → walk through `guides/09-siri-apple-watch-integration.md`. Pause at every step. If anything fails, **log it and stop** — don't push through with workarounds that haven't been verified either.

If user skips → mark deferred:

```bash
touch ~/Documents/[AI_NAME]/.siri-deferred-until-verified
```

If user successfully completes the setup (rare until first verified install lands):

```bash
touch ~/Documents/[AI_NAME]/.siri-configured
echo "$(date -Iseconds) — Siri configured (UNVERIFIED PATH, user is first-mover)" >> ~/Documents/[AI_NAME]/logs/install.log
```

### Kit author's commitment

Siri path will be tested by the kit author "soon" (commit date 2026-05-18). Once verified, this stage gets downgraded from EXPERIMENTAL to "tested on macOS X / iOS Y." The Watch path stays EXPERIMENTAL until someone with a Watch contributes a verified walkthrough.

### Hard rules for this stage

- **Never present this stage as a "feature" the user is getting.** It's an experiment they're opting into.
- **Never claim "Apple Watch hands-free" works** — the author can't promise that. Frame as theoretical.
- **If something fails, stop and log.** Don't improvise workarounds that haven't been verified.
- **Capture friction in detail** — this is the highest-value friction log entry possible because it's the first real test of an untested stage.

---

## Stage 6 — Part 2 close

```bash
touch ~/Documents/[AI_NAME]/.part-2-complete
date -Iseconds > ~/Documents/[AI_NAME]/.part-2-date
echo "$(date -Iseconds) — PART 2 COMPLETE" >> ~/Documents/[AI_NAME]/logs/install.log
```

Read the end-of-Part-2 value-prop close:

> "Now I really know you.
>
> **What you have now:**
> - A voice profile from the 5-question interview — drafts will land closer to how you'd actually write them
> - Premium voice replies (if you upgraded to ElevenLabs)
> - Meeting auto-capture (if you wired up Granola) — every call you take, your AI gets the notes within hours
> - The optional skills you added
> - Siri & Apple Watch (if you set them up)
>
> **What this means for you:**
> - Drafts get sharper week over week — the learnings loop is running
> - Your meetings stop disappearing. Your AI can answer 'what did Sam and I decide last Tuesday?' three weeks later.
> - You can talk to your AI from your watch hands-free (if Siri's set up)
>
> **Example use cases now possible:**
> - *'Mine my client meetings this week for case study material'* → Research pulls verbatim moments from transcripts
> - *'What's the pattern in what my members keep asking?'* → Research synthesizes across captured meetings
> - *'Hey Siri, [AI_NAME] — what's on my plate tomorrow?'* → Voice reply from your watch while you're cooking
>
> **What's next:** the kit gets better over time. Run `/update` to pull new skills as they ship. The 100-question deep voice interview is still on the table when you want it — that's a separate 90-min sitting. For now, just use what you have. It compounds."

---

## What's still in your back pocket after Part 2

| Skill / Feature | When to invoke |
|---|---|
| 100-Q deluxe voice interview | When you've used the AI for a few weeks and want maximum voice fidelity. Separate 90-min session. Best done on a quiet afternoon. |
| New skills shipping via `/update` | The kit gets new skills over time. `/update` (or "check for updates") pulls them. |
| `create-skill` (when shipped) | Meta-skill that walks you through creating new skills from the kit's template + the three-scenario test. |
| LLM Council | "council this" / "pressure-test this" for any locked decision with real stakes. |

---

*Part 2 of 2 — Reach. Part 1 (Foundation) is the prerequisite — see INSTALL.md.*
