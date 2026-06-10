# SETUP GUIDE (Input Ai) — The Under-the-Hood Files

> If you're a non-developer reading this folder: you can ignore everything in here. It's the implementation layer that an AI installer reads to actually do an install. The numbered guides at the parent level (01–08) explain what these things do conceptually.

---

## What's in here

| File / folder | What it is |
|---|---|
| **`playbook.md`** | The full canonical playbook (~6,000 words). Every phase, every step, every decision point, written for the AI installer. The numbered guides 05–08 in the parent folder are the user-friendly versions of this. |
| **`claude-md-template.md`** | Template for the `CLAUDE.md` file every partner AI gets. Has placeholders like `[AI_NAME]`, `[PARTNER_NAME]` that get filled in during install. |
| **`user-manual-template.md`** | Template for the `USER_MANUAL.md` every partner gets. Includes the portability/recovery section. |
| **`kick-off-pattern-reference.md`** | Quick-reference doc on the kick-off flow. The numbered guide `06 - The Kick-off Flow` is the user-facing version. |
| **`subagent-templates/`** | Five generic subagent templates: **content** (drafting), **research** (web/sources), **assistant** (admin/inbox), **developer** (technical work — optional), **design** (visual/UX work — Refero-grounded, anti-slop). Get copied into a new partner's `.claude/agents/` and tuned to their domain. |
| **`telegram-kit/`** | Standalone Telegram poller (for power users with multi-session setups). Includes the bash poller, the launchd plist template, and the check-telegram skill. |
| **`vault-scaffold/`** | Simplified Obsidian vault starter (6 folders + Brand/ templates). Copy into a new partner's vault to give them a working structure. |
| **`voice-io-kit/`** | Whisper transcription script + voice-io skill template. For Phase 7 voice setup. |

---

## How to use this folder for a new partner setup

1. **Read `playbook.md`** for the full setup methodology (12 phases).
2. **Build the partner's folder** at `~/[ai-name]/` (lowercase, no spaces, INSIDE Documents for iCloud backup).
3. **Copy the templates in:**
   - `claude-md-template.md` → `~/[ai-name]/CLAUDE.md`
   - `user-manual-template.md` → `~/[ai-name]/USER_MANUAL.md`
   - `subagent-templates/` → `~/[ai-name]/.claude/agents/` (rename to .md files; pick which agents to include — typically content/research/assistant/design, add developer for technical users)
4. **Find-replace placeholders:** `[AI_NAME]`, `[PARTNER_NAME]`, `[BUSINESS]`, `[BRAND]` etc. with the partner's specifics.
5. **Adapt the brand sections** in CLAUDE.md to the partner's actual voice/positioning/banned-words. The kick-off flow will refine this further on first run.
6. **Add the kick-off + wrap-up skills** at `~/[ai-name]/.claude/skills/` so the partner gets the auto-onboarding + auto-learnings-sweep behavior from day one.
7. **Optionally copy in:** `vault-scaffold/` into the partner's Obsidian vault location (Phase 9), `telegram-kit/` for Phase 6 power-user path, `voice-io-kit/` for Phase 7.
8. **AirDrop** the folder to the partner's Mac, drag into `~/Documents/`.
9. **They open Claude Code** → kick-off auto-runs → 15 min later they're live.

---

## Why this folder is named with leading characters that sort after numbers

The numbered guides (01–08) at the parent level are user-facing — those appear first in Finder. This kit folder appears after them, signaling "system / internal — the AI reads this; the user can usually ignore."

When this whole `WATNEY` folder gets shipped to someone new, they see:

```
WATNEY/
├── README.md                              ← they read this
├── 01 - Hyperframes/                      ← they read these
├── 02 - Video Use/
├── ...
├── 08 - The Learnings Loop/
└── SETUP GUIDE (Input Ai) /               ← AI reads this; user can ignore
```

The user-facing layer is generic and pristine. The kit underneath is what gets adapted and copied during a new partner install.
