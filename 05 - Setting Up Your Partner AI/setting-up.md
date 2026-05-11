# 05 — Setting Up Your Partner AI

> The full journey from "I want an AI partner" to "I have an AI partner who knows my voice, my work, and my preferences." 12 phases, ~6 hours total spread across 3–4 weeks. Don't do it all at once.

---

## What you're actually building

Not a chatbot. A **partner**. Something that:

- Knows your voice well enough to draft in it
- Remembers your decisions across sessions
- Watches for opportunities to take work off your plate
- Improves the more you use it
- Lives on your Mac, syncs across devices, recoverable in 15 minutes after a crash

The setup is in **phases** because cognitive load matters. A 6-hour weekend marathon = burnout + you forget what's where. One phase per sit-down + a day or two between = you build mental model of your own AI.

---

## The 12 phases at a glance

| Phase | What it gets you | Time | When |
|---|---|---|---|
| **1** | Identity & folder | 15 min | Day 1 |
| **1B** | Portability & recovery (iCloud) | 5 min | Day 1 (mandatory) |
| **2** | Personality guide | 1–2 hr | Day 1–2 (optional) |
| **3** | CLAUDE.md (operating manual) | 45 min | Day 1 |
| **4** | Subagents (specialists) | 30 min | Day 2–3 |
| **5** | Persistence (always-on body) | 30 min | Day 3–4 |
| **6** | Telegram bridge (phone access) | 60 min | Week 2 |
| **7** | Voice I/O | 30 min | Week 2 |
| **8** | Reliability monitoring | 45 min | Week 3 (power users) |
| **9** | Obsidian vault (second brain) | 60–90 min | Week 3 |
| **10** | Skills library | Ongoing | Week 4+ |
| **11** | Operational OS (compounding) | 1 hr setup | Week 4+ |
| **12** | Creative tool skills | On demand | When needed |

---

## What you do (mostly conversational)

**Phase 1 — Identity & folder.**
Install Claude Code Desktop. Install Command Line Tools when prompted. Create `~/Documents/[ai-name]/` (lowercase, no spaces, INSIDE Documents — this is critical for backup).

**Phase 1B — Portability.**
Verify iCloud Drive is on (System Settings → Apple ID → iCloud → Desktop & Documents Folders ticked). This is what makes the AI recoverable on a new Mac. Don't skip. See [07 - Portability & Recovery](../07%20-%20Portability%20and%20Recovery/portability.md).

**Phase 2 — Personality guide (optional but powerful).**
Pick two influences: a "soul" (a character whose tone fits your AI) and a "spice" (a comedy/rhetoric style for distinctiveness). Feed 2–3 hours of their longform content (transcripts) to Claude with a "build me a personality guide" prompt. Save the result. The AI reads it on every startup.

**Phase 3 — CLAUDE.md.**
The single file that tells the AI who it is. Copy the template, fill in:
- Your name + business + what you're squeezed on
- Voice rules (the bans matter more than the dos)
- Hard prohibitions ("never send emails on my behalf," "never invent facts")
- A pointer to the personality guide via `@`-import

**Phase 4 — Subagents.**
Three specialists baked into the kit: **content** (drafting), **research** (web/sources), **ops** (admin/inbox). The main AI delegates to them, you only talk to the main one.

**Phase 5 — Persistence.**
Make the AI run in the background, always on, even when Claude Code is closed. Required for Phase 6. Uses tmux + macOS launchd. Your installer drives the Terminal — you just watch.

**Phase 6 — Telegram bridge.**
Reach the AI from your phone. Voice-note it on a walk. Get drafts back. The standard "official plugin" path works for most users (single Claude Code window). The "standalone poller" path is for power users running multiple Claude bodies — only install if you have that setup.

**Phase 7 — Voice I/O.**
Whisper transcribes voice notes inbound. ElevenLabs gives the AI a voice for replies. Hard rule: voice replies cap at **<200 words** (~1 minute spoken). Long stuff goes as text.

**Phase 8 — Reliability monitoring (power users only).**
Heartbeat monitor + inbox watchdog + tmux liveness check. Catches silent failures (poller dies, voice replies stop, AI's "body" disappears) and pops a modal alert. Quiet hours 22:00–08:00 + 12-hour cooldown so you're not nagged.

**Phase 9 — Obsidian vault.**
Single place where everything you build together accumulates: brand decisions, project briefs, customer notes, meeting summaries, daily journal. The AI reads it on every session. Two scaffold options: **simplified** (6 folders, default for most) or **power-user Hab pattern** (40+ folders, only for multi-agent workflows).

**Phase 10 — Skills library.**
Reusable capabilities. The AI watches for recurring tasks and offers to turn them into one-button commands. *"Heads up — we've drafted this kind of email 3 times. Want me to make it a skill?"* You say yes or park.

**Phase 11 — Operational OS.**
The compounding layer:
- **Bootstrap kick-off** — AI walks you through setup decisions on first run (see [06 - The Kick-off Flow](../06%20-%20The%20Kick-off%20Flow/kick-off.md))
- **Learnings loop** — every skill has a `learnings.md` it reads before running, so accumulated feedback compounds (see [08 - The Learnings Loop](../08%20-%20The%20Learnings%20Loop/learnings-loop.md))
- **Wrap-up skill** — at end of session, AI offers to log the day's lessons; you don't have to remember to ask
- **Heartbeat hook** — auto-sync of installed skills (deferred until needed)

**Phase 12 — Creative tool skills (on demand).**
Pre-built skills for common creative work: video editing (`video-use`, Remotion, Hyperframes — see [01 - Hyperframes](../01%20-%20Hyperframes/hyperframes.md) and [02 - Video Use](../02%20-%20Video%20Use/video-use.md)), web design, document generation. Don't pre-install — wait for the work to surface the need.

---

## The honest part — what you don't have to do

You **don't** need to:
- Memorize this guide. The AI walks you through Phase 1 + 1B itself via the kick-off flow on first run.
- Install all 12 phases. Most people stop at Phase 4–6 and are happy.
- Remember any commands. The AI handles all infrastructure conversationally.
- Worry about what breaks if the launchd job fails (Phase 8 catches it, or you'll just notice and ping me).

You **do** need to:
- Verify iCloud Drive is on before you start (Phase 1B). One-time, 30 seconds.
- Save your API keys (OpenAI, ElevenLabs, Telegram bot token) in a password manager.
- Talk to the AI like a colleague, not a Google search bar. Full sentences. Real context.

---

## When something breaks

Tell the AI:

> *"[AI_NAME], something's wrong. Let's troubleshoot. Here's what I'm seeing: [describe]."*

It can read its own files, check its own config, and walk you through fixes. Most issues resolve in one or two messages. If it genuinely can't help, ping the human who set you up.

---

## Where to find more detail

- **Full canonical playbook** (developer-friendly, exhaustive): `~/Desktop/Partner AI Kit/_kit/playbook.md`
- **Filled example kit** ([AI_NAME] for [PARTNER_NAME]/[BRAND]): `~/Desktop/Partner AI Kit/_kit/`
- **Per-topic deep dives:** the other folders in this Partner AI Kit directory.
