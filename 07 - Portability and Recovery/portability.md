# 07 — Portability & Recovery

> Your AI is just text files. As long as those files are safe, your AI follows you to any Mac, recoverable in 15 minutes after a crash, theft, or factory reset.

---

## Why this matters

Every brand decision you make. Every customer note. Every voice rule you tighten. Every draft. Every skill you build. Every learning the AI accumulates over months. **All of it lives in files on your Mac.**

If those files aren't backed up, a single laptop death erases the entire partnership. Months of compounded work, gone. **Five minutes of setup here saves all of it.**

---

## The three layers

### Layer 1 — iCloud Drive (mandatory, free, works for ~95% of users)

This is what your AI's kick-off flow walks you through automatically. Once it's on, your AI's folder is auto-synced to your Apple ID and replicated across every Mac you sign into.

**One-time setup:**

1. **System Settings** → **Apple ID** → **iCloud**
2. **iCloud Drive** → enabled
3. **"Desktop & Documents Folders"** toggle → ticked
4. Wait ~5–10 min for the first sync to complete

**Where the AI lives:**

`~/[ai-name]/`

NOT `~/[ai-name]/` (that's outside Documents and won't be backed up).

If your AI is currently at `~/[ai-name]/`, drag it into `~/Documents/` in Finder. iCloud picks it up automatically. Tell your AI in chat — it'll re-detect the new path.

### Layer 2 — Token recovery template (mandatory, takes 2 min)

Your API keys (OpenAI, ElevenLabs, Telegram bot token) live at `~/.config/[ai-name]/.env` — which is **outside** your Documents folder, so iCloud doesn't back it up.

**Fix:**

1. Create a file at `~/[ai-name]/_recovery/env-template.txt` with this content (no actual secrets):
   ```
   # Recovery template — copy back to ~/.config/[ai-name]/.env on a new Mac.
   # Get the actual secret values from your password manager.
   OPENAI_API_KEY=
   ELEVENLABS_API_KEY=
   ELEVENLABS_VOICE_ID=
   TELEGRAM_BOT_TOKEN=
   ```
2. Save the actual API keys in **1Password / Bitwarden / Apple Passwords** (whatever you use).

The template tells future-you what keys you have. The password manager holds the values.

### Layer 3 — Time Machine (optional, recommended for paranoia-level safety)

Plug an external drive in once a week. macOS auto-backs-up everything (including hidden config dirs that iCloud misses). If iCloud has a bad sync day or your Apple ID gets compromised, Time Machine is the fallback.

**Setup:**

1. Plug in a USB external drive (~$30 for 1TB)
2. macOS asks if you want to use it for Time Machine → yes
3. Plug it in once a week, let it run

That's it.

---

## The recovery sequence — when (not if) something dies

**Scenario:** Your Mac dies / gets stolen / you factory-reset / you upgrade to a new Mac. You want your AI back.

**Steps:**

1. **New Mac** → sign in with the same Apple ID. Wait 5–15 minutes for `~/Documents/` to sync from iCloud.
2. **Install Claude Code Desktop** from claude.com/code.
3. **Install Command Line Developer Tools** when macOS prompts (or open Terminal and type `xcode-select --install`).
4. **Open Claude Code** → "Open folder" → select `~/[ai-name]/`.
5. **Re-create your `.env` file** at `~/.config/[ai-name]/.env` — copy structure from your `_recovery/env-template.txt`, paste actual values from your password manager.
6. **Type "Hi [AI_NAME]"** — your AI is back, with full memory: every brand decision, every customer note, every voice tuning, every skill, every learning. Nothing lost.

**~15 minutes** end-to-end. Maybe ~30 if you're also restoring background services (launchd jobs, monitoring) — but most users don't need those.

---

## What happens if you skip this

Real scenarios that have happened to people:

- "My laptop died and I lost a year of customer notes I'd been building with my AI." 🪦
- "My new Mac doesn't have any of the brand decisions we made together." 🪦
- "I had to retrain my AI on my voice from scratch." 🪦

Don't be that person. **Five minutes of setup. Saves you months of work.**

---

## How your AI helps

The kick-off flow (see [06 - The Kick-off Flow](../06%20-%20The%20Kick-off%20Flow/kick-off.md)) walks you through Layer 1 and Layer 2 automatically. You just answer "yes / no / I don't know" to a few questions and the AI handles the rest.

If you skipped the kick-off OR want to verify everything is set up correctly, ask your AI:

> *"[AI_NAME], can you verify my portability setup? Check iCloud Drive, my folder location, and whether my recovery template exists."*

The AI will run the checks and tell you what's missing.

---

## See also

- [05 - Setting Up Your Partner AI](../05%20-%20Setting%20Up%20Your%20Partner%20AI/setting-up.md) — the full 12-phase setup (Phase 1B is portability)
- [06 - The Kick-off Flow](../06%20-%20The%20Kick-off%20Flow/kick-off.md) — what runs Layer 1 + 2 for you automatically
- [03 - API Key Hygiene](../03%20-%20API%20Key%20Hygiene/api-key-hygiene.md) — where your secrets live and how to handle them
