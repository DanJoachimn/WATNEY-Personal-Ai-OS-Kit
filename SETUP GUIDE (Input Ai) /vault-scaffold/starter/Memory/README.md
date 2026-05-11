---
type: memory-layer-readme
generated_by: claude-code
---

# Memory Layer — how [AI_NAME] remembers

This folder is [AI_NAME]'s working memory. Two files, two roles.

## `daily-memory.md` — the rolling buffer

A flat append-only log. Every meaningful exchange between [PARTNER_NAME] and [AI_NAME] gets a 1-line entry here. Format:

```
YYYY-MM-DD HH:MM — [one-line summary of what mattered]
```

**What "meaningful" means:**
- A decision was made
- A fact was confirmed (about a person, a project, a brand rule)
- A preference was articulated
- A piece of work shipped
- A thread was opened or closed

**What does NOT go here:**
- Casual chat
- "Hi" / "thanks" / pleasantries
- Iterations on a single draft (one entry for the *outcome*, not each turn)

**Length:** strictly one line per entry. The goal is a high-signal trail, not a transcript.

**Who writes:** [AI_NAME], at session-end (via wrap-up skill) or when [PARTNER_NAME] says "remember this" / "add to notes."

## `long-term.md` — the synthesized state

A single file holding [AI_NAME]'s compiled understanding. Sections:

- **Active threads** — what's in flight right now
- **Settled facts** — things known, with citations to daily-memory entries
- **Patterns** — recurring themes (what types of work [PARTNER_NAME] enjoys, what types they bail on, etc.)
- **People** — light bios of who matters, with most recent context
- **Open questions** — things [AI_NAME] doesn't yet have an answer to

**Who writes:** the `dreaming` skill, fired by launchd at 02:00 nightly. Reads recent daily-memory entries, integrates new signal into long-term.md, marks daily entries processed.

## Why the two-file structure

Without it: [AI_NAME] either remembers nothing (every session resets) or remembers everything (long-term.md becomes a 10MB file Claude can't load efficiently).

With it: daily-memory captures fresh signal cheaply. Long-term holds the synthesized canon, kept compact by overnight compression. The dreaming routine is the bridge.

## Hard rules

- **Daily-memory is append-only.** Never delete entries. If something is wrong, mark it: `~~strikethrough~~ — corrected to [new info] on YYYY-MM-DD`.
- **Long-term gets rewritten nightly.** The dreaming routine integrates rather than appends. Old facts get superseded, not deleted — they move to a "Superseded" section at the bottom with date.
- **One line per daily entry, no exceptions.** If something needs more than a line, it goes into the appropriate folder (Projects, People, Notes) — daily-memory just notes that it was discussed.
- **Both files must have `generated_by: claude-code` frontmatter.**
- **Re-read before edit.** If [AI_NAME] is mid-update and the file has changed since last read, abort and re-read. Multi-agent etiquette.
