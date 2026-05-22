# 04 — Pre-Production Rules

## What this is (for the user, 1 sentence)

Decisions to lock in BEFORE you record — aspect ratio, format, length, audio — because most of them can't be reversed in post.

---

## Install prompt (paste this into your agent)

Nothing to install. Tell your agent to follow these rules:

```
Adopt the pre-production rules in ~/Desktop/WATNEY/04 - Pre-Production Rules.md. Before I record anything for video output, ask me about format and target platform. If I want output for a platform that doesn't match my source format, flag the constraint and offer alternatives.
```

---

## The rules (for the agent enforcing this)

### Rule 1 — Aspect ratio is destiny

Source aspect ratio determines which platforms the output can ship to. **It cannot be meaningfully reversed in post.**

| Source format | Native distribution | Acceptable repurpose | Don't try |
|---|---|---|---|
| **Horizontal 16:9** (1920×1080) | LinkedIn, X, YouTube long-form, email | Square 1:1 (with crop) | Vertical 9:16 |
| **Square 1:1** (1080×1080) | Instagram feed, LinkedIn | Vertical 9:16 (with letterbox) | n/a |
| **Vertical 9:16** (1080×1920) | Instagram Reels, TikTok, YouTube Shorts | Square 1:1 (with crop) | Horizontal 16:9 |

**The asymmetry:** going from more space to less = lose content (cropping). Going from less space to more = waste canvas (letterboxing). Neither produces good social-platform results when forced.

**Before any recording session, the agent must ask:**

> What's the target platform for this? That decides what aspect ratio you should record in.

If the user says "I'm not sure," default to:
- **Vertical 9:16** if any answer mentions Instagram, TikTok, or short-form
- **Horizontal 16:9** if any answer mentions YouTube long-form, LinkedIn primary, or email
- **Square 1:1** if hedging across multiple platforms

### Rule 2 — Recording-format checklist (before user hits record)

Run this checklist with the user:

- [ ] **Aspect ratio confirmed** for target platform (see Rule 1)
- [ ] **Resolution:** 1080p minimum. 4K only if final delivery is 4K (huge files, slow processing otherwise).
- [ ] **Frame rate:** 30fps for social, 24fps for cinematic, 60fps only for sports/motion.
- [ ] **Audio:** dedicated mic if possible. Built-in laptop mic = OK for test, never for ship.
- [ ] **Lighting:** face-cam content needs key light. Diffused window light works.
- [ ] **Length target:** know the platform max (Reels 90s, TikTok 10min, Shorts 60s). Record with buffer for trimming.
- [ ] **Take strategy:** plan to do 2-3 takes per beat. Easier to cut a winner than fix a single bad one.

### Rule 3 — Screen recordings of decks/slides are horizontal-only output

Decks designed in 16:9 cannot be repurposed to 9:16 vertical via crop or letterbox without:
- Cropping (cuts off slide content) → loses message, OR
- Letterboxing (60% black bars) → looks amateur

**If user wants to publish deck content as social shorts**, the right play is:
1. **Re-design the slides in 9:16** before recording (most slide tools support 1080×1920 canvas), OR
2. **Re-record the message as a vertical face-cam talking head** without the deck, OR
3. **Accept the content is for horizontal-friendly platforms only** (LinkedIn, YouTube, email)

Don't silently produce a vertical version with letterboxed deck. Flag the constraint and offer the three options above.

### Rule 4 — Captions are platform-specific

Default styling decisions for caption burn-in vary by platform:

| Platform | Caption convention |
|---|---|
| TikTok / Reels / Shorts | Karaoke 2-word chunks UPPERCASE bold OR longer Netflix-style — tribal split. Both work. |
| LinkedIn / YouTube long-form | Longer Netflix-style chunks, natural casing, bottom-third. |
| Native subtitle file (no burn-in) | Generate `.srt` sidecar; let platform handle rendering. Most platforms support this and let viewers toggle. |

Default to **longer chunks + natural casing + soft yellow tint (`#F8E5B5`)** unless user specifies otherwise. Platforms that need karaoke can override.

**Caption position:** ALWAYS account for platform UI overlay. TikTok/Reels/Shorts UI covers ~25-30% of the bottom of vertical canvas (caption, username, music, right-rail actions). Position captions at MarginV ≥ 75 in libass PlayRes units, or roughly 30% up from bottom. Don't bury them under the UI.

### Rule 5 — Length targets per platform (2026)

| Platform | Sweet spot | Hard max |
|---|---|---|
| Instagram Reels | 30-60s | 90s |
| TikTok | 21-34s (highest engagement) | 10 minutes |
| YouTube Shorts | 30-45s | 60s |
| LinkedIn video | 60-90s | 10 minutes |
| YouTube long-form | depends entirely on content | 12 hours |

Rule of thumb: **the platform's "hard max" is not the target.** Cut tighter than max. Better short and watched-through than long and scrolled-past.

### Rule 6 — Always shoot more than you need

The cost of one extra take is ~30 seconds. The cost of having to re-record because you cut too aggressively is the entire session. Default to **3 takes per beat** + handle pickups for any line you stuttered on.

In editing, the trim tool (see `02 - Video Use.md`) makes deciding take strategy trivial — just record everything and let the agent pick the cleanest delivery.

---

## What the user can do once this is in place

- Save themselves an entire production cycle by getting format right up front.
- Trust that the agent will catch aspect-ratio mismatches before they become unfixable.
- Get platform-specific advice without having to remember it themselves.

---

## Notes for the agent

- **These rules apply BEFORE any recording, not after.** If user shows up with already-recorded content, work with what exists. The rules are for the next session.
- **When user says "make it for [platform]" without specifying source format**, ask before assuming. Don't burn render time on the wrong aspect ratio.
- **Vertical reformat from horizontal source is the most common failure mode.** This has caused real iteration losses in past projects. Always flag it.
- **For decks specifically:** if the user asks to repurpose a screen-recorded deck into vertical short-form, refuse-and-redirect. Show them Rule 3 in this file.
- **Update this guide** when a new platform spec changes (durations, aspect ratios, caption conventions). Platform UIs and length sweet-spots drift every 6-12 months.
