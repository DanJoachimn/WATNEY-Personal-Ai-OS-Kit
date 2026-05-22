# Kick-off — The Partner AI's First-Conversation Flow

> The single document explaining what a Partner AI does the first time their user opens Claude Code. Anyone deploying a new partner reads this once, then trusts the AI to handle the rest.

---

## The principle

**The user shouldn't have to know any of the playbook exists.**

They shouldn't memorize iCloud Drive settings. They shouldn't remember to confirm voice rules. They shouldn't know that there's such a thing as a token recovery template. They shouldn't have to learn to say "wrap up" at the end of a session.

The Partner AI does all of that **for them**, in plain language, on the first conversation. The user just answers a few questions and chats with their new partner.

---

## What "Kick-off" means

The first time the user opens Claude Code in their AI's folder, the AI auto-detects that no `.first-run-complete` flag exists → invokes the **kick-off skill** → walks the user through 5 sections, ~15 min, all conversational. Then writes the flag and never runs again unless explicitly asked.

---

## The 5 sections of the kick-off flow

| Section | Time | Covers |
|---|---|---|
| **A. Infrastructure & safety** | 3 min | iCloud Drive verification → folder location check → token recovery template creation. **Mandatory.** Without this, the user loses everything the day their laptop dies. |
| **B. Brand voice confirmation** | 5–7 min | 3 quick questions to capture the user's voice in their own words. Confirms reference brands, banned words, default vibe. Drafts updates to `Brand/Voice guide.md` (or `notes.md` if no vault yet). |
| **C. What I won't do** | 2 min | Sets expectations on prohibitions: never sends on user's behalf, never invents facts, never crosses domain-specific brand rules. Tells the user how to push back when the AI is off. |
| **D. First real task** | ~4 min | Picks the user's most-annoying current admin task and does it together. Real output, not a demo. Establishes the working dynamic. |
| **E. Going forward** | 1 min | Three takeaways: talk like a colleague, tell the AI when something matters, tell it when something is recurring. |

After all five → the AI writes `.first-run-complete` and a short log. Never re-runs unless the user explicitly asks ("kick off again", "let's onboard").

---

## What the kick-off automates (so the user never has to know)

- **iCloud Drive** is enabled, Documents folder is synced, the AI's folder is in `~/Documents/[ai-name]/`
- **A token recovery template** lives at `~/Documents/[ai-name]/_recovery/env-template.txt` so a new Mac can be brought back online in 15 min
- **The user's voice** is captured in their own words and integrated into the AI's drafting behavior
- **Voice reply rules** (cap <200 words, voice = default for short/casual, text for long/technical) are in CLAUDE.md, ready when Phase 7 voice I/O gets installed
- **The wrap-up skill** is partner-scoped and auto-triggers at end-of-session signals — the user doesn't have to remember to say "wrap up"
- **Proactive opportunity-spotting** is baked into CLAUDE.md — the AI surfaces skill-creation and automation moments without being asked

---

## Why this is non-negotiable for every new partner

Without kick-off:

- User is expected to remember playbook items they've never seen
- iCloud not enabled → factory reset = total loss of everything ever built together
- Voice rules unset → AI drafts feel generic, user has to re-tune every session
- No `.first-run-complete` flag → every session feels like starting from scratch

With kick-off:

- 15 minutes of warm conversation instead of 90 minutes of technical setup
- Infrastructure invisible to the user, fully protected
- Voice rules locked in and applied silently
- AI takes ownership of session-end + opportunity-spotting → user never has to remember
- New Mac recovery: 15 min, zero data loss

---

## How to install kick-off for a new partner

The kick-off skill ships **inside every partner kit**. It's not optional infrastructure — it's the front door.

### Files involved

```
~/Documents/[ai-name]/
├── CLAUDE.md                            ← top of file: "first-run check"
├── USER_MANUAL.md                       ← includes portability/recovery section
├── notes.md
├── _recovery/                           ← created during kick-off Section A
│   └── env-template.txt
├── .first-run-complete                  ← created at end of kick-off, never deleted
├── .first-run-log.txt                   ← short audit trail
├── .claude/
│   ├── agents/
│   │   ├── content.md
│   │   ├── research.md
│   │   └── ops.md
│   └── skills/
│       ├── kick-off/SKILL.md            ← the flow itself
│       └── wrap-up/SKILL.md             ← end-of-session auto-trigger sweep
```

### Install steps for a new partner

1. **Copy the canonical kit:** `cp -R ~/Desktop/Claude's\ Office/Partner\ AI\ Setup/partner-kits/[PARTNER_NAME]\ Personal\ AI\ —\ [BRAND]/ ~/Desktop/[new-ai-name]/`
2. **Find-replace** `[AI_NAME]` → new name, `[PARTNER_NAME]` → new partner name, `[BRAND]` → new business name (or generic "[BUSINESS]")
3. **Adapt** the brand-voice section in `CLAUDE.md` to the new domain
4. **Adapt** the kick-off skill's Section B (brand voice questions) to the new domain
5. **AirDrop** the folder to the user's Mac, drag into `~/Documents/`
6. **They open Claude Code** in the folder, type "Hi [AI_NAME]" → kick-off auto-runs

That's the whole install. ~10 minutes of prep on the deployer's side, ~15 minutes of conversation on the user's side, and the AI is fully online with full memory + safety + behavior baked in.

---

## What runs automatically after kick-off

Once `.first-run-complete` exists, the AI is in **normal mode** but with these auto-behaviors active:

| Behavior | Trigger | What it does |
|---|---|---|
| **Read learnings.md** | Every skill invocation | Skill reads its own accumulated tunings before running. Compounding sharpness over time. |
| **Wrap-up auto-trigger** | Terminal phrases ("good", "ship it", "park this", "I'm done", topic shift after long work, >15 min quiet) | AI offers an end-of-session learnings sweep without being asked. Max 2 offers per session. |
| **Skill-creation suggestions** | User does the same task 2+ times in a week, says "I do this every [cadence]", or mentions a recurring frustration | At a natural pause, AI offers to turn the task into a skill. Build now or park. |
| **Automation suggestions** | Predictable cadence, deterministic process, "I keep forgetting to..." | At a natural pause, AI offers a launchd / scheduled / background skill. Build now or park. |
| **Proactive housekeeping** | After finishing a task | AI scans for stale files, dead code, deferred reorganizations in the affected area; surfaces with do/defer/skip recommendations. |

The user does **none** of this consciously. They just see the AI being thoughtful at the right moments.

---

## Related canonical files

- **The full playbook:** `00_Personal_AI_Setup_Plan_GENERIC.md` (Phase 1 → Phase 12 + Operational Ongoing)
- **CLAUDE.md template:** `02_CLAUDE_template.md` (with first-run check baked in)
- **User manual template:** `03_user_manual_for_partner.md` (with portability/recovery section)
- **Canonical working kit:** the template files (`claude-md-template.md`, `user-manual-template.md`, `subagent-templates/`) ([AI_NAME]'s deployed kit, source-of-truth for new partner installs)
- **Kick-off skill source:** `kit templates.claude/skills/kick-off/SKILL.md`
- **Wrap-up skill source:** `kit templates.claude/skills/wrap-up/SKILL.md`

---

## The one-line takeaway

**Kick-off is the difference between "an AI on the user's Mac" and "an AI the user actually trusts and depends on by week 2."**

Skip it for any partner and they'll never lean in fully. Install it, and they're a working partnership in under 30 minutes from the first "hi."

---

*This file lives at `~/Desktop/WATNEY/_kit/kick-off-pattern-reference.md`. Update it whenever the kick-off pattern evolves — keep it the canonical reference for the first-run experience.*
