# Vault rules

This file lives at the root of the Obsidian vault, `[VAULT]`. It is the **schema**: it tells the AI how the vault is structured, what the conventions are, and which workflows to follow. Read it before touching anything.

The core of the vault is a brain the AI builds and keeps current, following Andrej Karpathy's LLM Wiki pattern ("LLM Wiki": https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Instead of re-reading raw material every time the user asks something, the AI reads each source once, files what matters into linked pages, and keeps those pages current as new material arrives. The knowledge is compiled once and kept up to date, not rediscovered on every question.

In Karpathy's words: Obsidian is the IDE, the LLM is the programmer, the wiki is the codebase. Here the "wiki" is `_Brain/`.

## The three layers

1. **Raw material.** `Clippings/` (articles, papers, transcripts, images the user saved) and the user's own conversations with the AI. **Immutable.** The AI reads clippings and never modifies, renames or moves them. The only thing the AI may do in `Clippings/` is save a *new* file when the user hands over a link or text to file.
2. **The brain: `_Brain/`.** Markdown pages written by the AI: source summaries, people, organisations, ideas, saved answers, plus an index, a log and an overview. **The AI owns this layer.** It creates pages, updates them when new material arrives, maintains the links, and keeps everything consistent. The user reads it; the AI writes it.
3. **The schema: this file.** The user and the AI evolve it together (see "Changing this file" at the bottom).

Division of labour: **The user lives, works, reads and decides. The AI does the filing**: summarising, cross-referencing and bookkeeping, **without being asked**. The user should never have to remember to say "file this".

## The brain's focus

Karpathy leaves the details to "your domain". This section is where the user's domain gets written down, so every session and every night files things the same way. **Read it before every filing run and every lint.**

**Status: not filled in yet.** Until it is, run the setup conversation below before the first filing.

- **What this brain is for:** *(one or two sentences)*
- **Main topics:** *(the 3 to 6 areas most material will be about)*
- **Questions the user wants it to answer:** *(the real questions, in the user's words)*
- **What to pull out of every source:** *(e.g. practical takeaways, the evidence behind a claim, numbers worth remembering)*
- **Sources the user trusts, and ones to treat with care:**
- **Tags to use:** *(a short fixed list, so pages stay findable. Add new tags only with the user's OK.)*
- **Never file:** *(topics, people or private matters the user doesn't want in the brain)*

### The setup conversation

Run it when this section says "not filled in yet", or when the user says "let's set up the brain" or "let's rethink what the brain is for".

1. Tell the user in one sentence what's about to happen: a few questions so the brain fits what the user actually wants from it.
2. Ask the questions **one at a time**, in plain words, and let the user answer in the user's own words before offering any suggestions:
   - What do you want your second brain to help you with?
   - What will you mostly be clipping or working on?
   - What questions do you hope to ask it in three months?
   - When you read something useful, what's the part you want to keep?
   - Any sources you rely on, or ones you're sceptical of?
   - Anything you'd never want filed? (topics, people, private matters)
3. Draft the filled-in section in chat, including a first tag list (8 to 15 tags) and any "never file" topics.
4. Change it until the user is happy, then write it into this file, set the status to "filled in (date)", and log it in `_Brain/log.md` as `## [YYYY-MM-DD] setup | Brain focus`.
5. Add one `## Topic name` heading per main topic to `_Brain/overview.md`, each saying "Nothing filed yet."

Revisit it when a lint shows the brain drifting away from these topics, or every few months.

## The layout

```
[VAULT]/
├── CLAUDE.md          this file, the schema
├── Clippings/         raw sources. Never edited.
│   └── assets/        images downloaded from clippings
├── _Brain/            the brain the AI builds and keeps current
│   ├── index.md       the catalogue of every page. Always read first.
│   ├── overview.md    what the brain currently believes, on one page
│   ├── log.md         what was filed, and when
│   ├── sources/       one summary page per clipping
│   ├── people/        one page per person
│   ├── companies/     one page per organisation
│   ├── concepts/      ideas, methods, patterns, and works (books, films, products)
│   ├── explorations/  good answers worth keeping: comparisons, analyses, syntheses
│   └── _pending/      mentioned once, waiting for a second mention
├── Notes/             the user's own thinking
├── Daily logs/        optional: the user's journal, if they keep one
├── _context/          the user's canon: who they are, how they write, what they're working on
├── Projects/          one file per active project
├── Meetings/          meeting notes
├── Source material/   the user's best past writing, for learning the voice
├── Memory/            the AI's working memory (daily-memory.md, long-term.md)
├── tools/ + tools.md  what the AI can use, and how
├── Goals.md, Constraints.md, Working style.md
└── Archive/           old stuff. Nothing is deleted; it moves here.
```

Read `tools.md` and `Memory/long-term.md` at the start of every session. At the first session of a day, check `_Brain/log.md` for entries marked `(nightly)` since the last session and mention them in one line ("Last night I filed 4 things: ...").

## What the user says, and what the AI does

The user won't use the operation names. Match what the user says to the job:

| The user says something like | The AI does |
|---|---|
| saves a clipping and says nothing | Nothing now. **Nightly filing** picks it up. |
| "file this now", "ingest this", "add this to my brain" | **File** that source now, with a short chat about what matters |
| pastes a link or a chunk of text and says "file this" | Save it as a **new** file in `Clippings/`, then **File** it |
| asks any question about something they've read or worked on | **Query** |
| "save that", "keep that", "put that in my brain" | File the last answer as an exploration |
| "check my brain", "tidy up", "what's missing?" | **Lint** |
| "what did you file last night?", "what's been added lately?" | Read the latest entries in `_Brain/log.md` and summarise |
| "undo last night's filing", "that page is wrong, put it back" | **Undo** (see Nightly filing) |
| "have I read anything about X?", "find anything on X" | **Search by meaning** across the vault, then read the best matches |
| "what have we learned so far?", "what does my brain think about X?" | Answer from `_Brain/overview.md`, linking to the pages behind it |
| tells the AI about a real person, company or event | File it into `_Brain/` now, with a citation |
| "what patterns do you see in my thinking?", "challenge my ideas" | **Reflection**: read only the user's own writing (see the firewall rule) |
| "don't file anything about X" | Add X to "never file" in the brain's focus, after confirming |
| "change how you do X from now on" | Propose the exact edit to this file, make it once the user agrees |
| "let's set up the brain", "let's rethink what the brain is for" | Run the **setup conversation** |

When it's unclear which job the user means, ask one short question.

## Nightly filing (automatic)

The brain grows without the user asking. The nightly `dreaming` job runs this after its conversation harvest. Only run it if `_Brain/index.md` exists.

**What gets filed:**
1. **Yesterday's conversations.** The durable points the harvest found: decisions, new facts about people, organisations, projects and money, insights worth keeping. Skip routine chatter, debugging, half-thoughts and anything under "never file". **Skip every point from a conversation whose working folder, or any folder above it, contains a file named `.private`**: that's how the user keeps client or other people's data out of the brain.
2. **New clippings.** Any clipping no `_Brain/sources/` page points to yet. At most 3 per night; oldest first.

**How:**
1. Read `_Brain/index.md` and "The brain's focus".
2. For each point or clipping, find the page it belongs on: index first, then grep. (The nightly run can't use search by meaning; don't try.) **Update the existing page; create a new one only if none exists.**
3. **Before changing any existing page, snapshot it:** write an exact copy to `[HOME]/_recovery/brain-snapshots/YYYY-MM-DD/`, keeping its path inside `_Brain/` (the Write tool creates missing folders). **Read the copy back and confirm it matches. If you can't confirm it, don't touch that page tonight**: log it as skipped and move on. A page changed without a confirmed snapshot can't be undone.
4. Write the change, following the page rules below: every new fact cited, a timeline line on people, company and concept pages, contradictions kept and flagged, the notability gate for new people and companies.
5. For a clipping: write its summary page in `_Brain/sources/`, then update the pages it touches, exactly as a manual file would, minus the chat.
6. Update `_Brain/overview.md` if a view changed; update `_Brain/index.md` for new pages.
7. Log every page touched in `_Brain/log.md` as `## [YYYY-MM-DD] file (nightly) | Page name`, adding `(new)` after the name for pages created tonight, with one line on what changed.

**Limits:** at most 15 pages touched per night. If more qualifies, file decisions and new facts from conversations first, then clippings (oldest first), and log what was left over so the next night picks it up. Never write outside `_Brain/`, `Clippings/` (read only) and `[HOME]/_recovery/brain-snapshots/`. If anything errors, stop filing, log it, and let the rest of dreaming run.

**Undo:** when the user asks, find the night's `file (nightly)` entries in `_Brain/log.md`. For each page:
- **It has a snapshot:** overwrite the live page with the snapshot copy.
- **The log says it was created that night:** archive it with the full "How to archive a file" procedure below (frontmatter, index, overview, log), not a bare move.
- **Neither:** don't guess. Leave the page as it is and tell the user.

Log the undo as `## [YYYY-MM-DD] undo | Page name`. Log entries for pages created at night must say `(new)` so undo can tell them apart: `## [YYYY-MM-DD] file (nightly) | Page name (new)`.

## Operations on request

### File: the user says "file this now"

1. Read `_Brain/index.md` and "The brain's focus".
2. Read the source in full. Search by meaning for its main topics, to find existing pages that cover the same thing under different words ("pricing" and "what to charge" are one page, not two). If it has images in `Clippings/assets/`, read the text first, then look at the images that matter.
3. Discuss it with the user: 3 to 5 key takeaways, and ask what to emphasise.
4. File it exactly as in Nightly filing steps 4 to 7, but log it as `## [YYYY-MM-DD] file | Page name`.
5. Tell the user which pages were created or changed, and in one sentence what (if anything) changed in the overview.

A clipping counts as filed once a page in `_Brain/sources/` points to it in its `clipping:` field.

### Query: the user asks a question

1. Read `_Brain/overview.md` for the big picture and `_Brain/index.md` to find the relevant pages, then read those pages. If that doesn't turn up enough, or the question uses different words than the pages do, **search by meaning** before concluding the brain doesn't know.
2. Answer with `[[wikilinks]]` to the pages used. Pick the form that fits: a few paragraphs, a comparison table, a new page, a chart.
3. **Good answers get filed back.** If the answer is a comparison, an analysis or a connection worth keeping, offer to save it in `_Brain/explorations/`, add it to the index, and log it.
4. If the brain doesn't have enough to answer, say so and suggest what to clip or look up.

### Lint: the user says "check my brain" (worth doing every few weeks)

Look for:
- contradictions between pages
- stale claims that newer material has superseded
- orphan pages with no inbound links
- near-duplicate pages about the same thing under different names (search by meaning for each concept page's title)
- important people, organisations or ideas mentioned often but lacking their own page
- missing cross-references
- data gaps a web search could fill
- an overview that no longer matches the pages behind it
- pages in `_pending/` that now pass the notability gate
- snapshot folders in `[HOME]/_recovery/brain-snapshots/` older than 14 days: offer to move them to `Archive/brain-snapshots/`

Also check the brain still matches "The brain's focus", and suggest new questions and sources. Report everything; fix what the user approves; log the pass.

## index.md, log.md and overview.md

**`_Brain/index.md` is about content.** A catalogue of every page, grouped under `## Sources`, `## People`, `## Companies`, `## Concepts`, `## Explorations`. One line per page:

```
- [[Page name]]: one-line summary (2026-09-16, 3 sources)
```

Update it whenever a page is created. Read it first for every query and every filing.

**`_Brain/log.md` is about time.** Append-only; never edit old entries. Every entry starts with the same prefix so it can be searched with simple tools:

```
## [2026-09-16] file (nightly) | Pricing models
Added the annual-discount decision from yesterday's conversation.

## [2026-09-18] query | How do the two pricing models compare?
Filed as [[Pricing models compared]].

## [2026-10-01] lint | Monthly check
2 contradictions flagged, 3 orphans linked, suggested 2 new sources.
```

Last five entries: `grep "^## \[" _Brain/log.md | tail -5`

**`_Brain/overview.md` is what the brain currently believes.** One page, organised by the main topics in "The brain's focus". This is where the user sees the brain getting smarter.

- **Rewritten, not appended.** When filing changes a view, revise that part so the page always shows the current best understanding. Roughly one screen per topic.
- **Every claim links** to the pages behind it.
- **Say how sure the brain is.** Label each topic's view as *solid* (several sources agree), *emerging* (one or two sources) or *contested* (sources disagree).
- **"How the thinking has changed" only ever grows**, newest at the top, one dated line each time a view shifts. Never rewrite or delete old lines.

```
# What the brain knows so far

## The big picture
3 to 6 sentences: the current best understanding across all topics.

## Topic name
Current view, in a few sentences with [[links]]. Confidence: solid | emerging | contested.

## Where sources disagree
- The disagreement, with [[links]] to each side.

## Open questions
- What the brain can't answer yet, and what to clip to find out.

## How the thinking has changed
- 2026-10-02: View on annual pricing moved from "always discount" to "discount only for commitment" after [[Source page]].
```

## Page rules

**Frontmatter** on every page:

```yaml
---
type: source | person | company | concept | exploration
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [from the tag list]
relation: knows | read-about     # people and companies only
clipping: "[[File name]]"        # source pages only
generated_by: claude-code
---
```

**Citations.** Every fact carries its source inline:
- `[Source: user, {context}, YYYY-MM-DD]` for things the user said
- `[Source: conversation, YYYY-MM-DD]` for the nightly harvest
- `[Source: [[Clipping or source page]]]` for reading material
- `[Source: compiled from X + Y]` for things the AI pieced together

**Page shape for people, companies and concepts.** Current understanding on top, rewritten as it changes. Below the divider, a timeline that only grows:

```
Current best understanding, every fact cited.

<!-- ↑ COMPILED TRUTH ABOVE · APPEND-ONLY TIMELINE BELOW ↓ -->

## Timeline
- YYYY-MM-DD: what happened [Source: ...]
```

**Notability gate.** Create a `people/` or `companies/` page only for someone mentioned twice, or once with real substance. Single mentions go in `_pending/` until a second mention promotes them.

- **File names:** Title Case, spaces are fine. One page per thing.
- **Link generously.** Every mention of something that has its own page gets a `[[wikilink]]`.
- **Prefer updating over creating.** A richer page beats a duplicate.
- **`generated_by` is always `claude-code`,** even though the AI has a name. It's the fixed label that marks a file as AI-written. Bump `updated:` on every edit.

## Who writes where (the rest of the vault)

| Folder | The AI may |
|---|---|
| `Clippings/` | read; save a new file only when the user hands over a link or text. Never change an existing one. |
| `_Brain/` | write, through filing, queries and lint |
| `Memory/`, `tools/`, `tools.md` | write |
| `Projects/`, `Meetings/` | read, and add to them when the user asks |
| `Archive/` | move things in. Never delete. |
| `Notes/`, `_context/`, `Source material/`, `Daily logs/` (if it exists) | **read only. Never write, append to, or create files here.** |
| `Goals.md`, `Constraints.md`, `Working style.md` | read only |

When the user wants something changed in a read-only area, write the new text in chat and let the user paste it in. Those folders stay 100% the user's own words.

**Why this matters:** Notes, _context and any journal are the mirror of the user's thinking. If the AI writes there, then later, when the user asks "what patterns keep showing up in my thinking?", nobody can tell the user's ideas apart from the AI's.

**The user's own writing is not filed into the brain.** Karpathy's pattern allows filing journal entries. This vault deliberately doesn't: the brain is built from clippings and conversations, never by rewriting `Notes/`, `_context/` or the journal. If the user wants one of their notes in the brain, they copy it into `Clippings/` on purpose.

**Daily journal: optional.** If the vault has a `Daily logs/` folder, it is the user's journal and it is read only, exactly like `Notes/`. If it doesn't, never create daily notes. Either way, the AI's own session trail goes in `Memory/daily-memory.md`, never in the journal.

### The reflection firewall

`_Brain/` holds the AI's compiled understanding, not the user's thinking. When the user asks the AI to find patterns in the user's thinking, reflect on the user's ideas or mirror the user's worldview, read **only** the user's own writing: `Notes/`, `_context/`, `Daily logs/` if it exists, project files. **Never read `_Brain/` for that.** Otherwise the AI's summaries come back to the user dressed up as the user's own thoughts.

Operational work (filing, questions about sources, meeting capture, briefings, drafting, research) may read `_Brain/`. Reflection may not.

## General rules

1. **Never delete.** Move to `Archive/`, following the Archive rules below.
2. **Re-read before editing.** The user, or another session, may have changed the file. Never silently overwrite someone else's edits.
3. **Two folder levels max** inside any area. Use tags and wikilinks, not deeper folders.
4. **Before drafting anything in the user's voice,** read `_context/` and 2 to 3 files from `Source material/`.
5. **Search, don't remember.** When the user asks "what did we decide about X", search the vault (`grep -rn "X" [VAULT]/`). The vault is the source of truth, not session memory.
6. **The vault lives in the home folder on purpose.** Never look for it in `~/Documents/`; macOS privacy protection silently blocks background jobs from reading there.

## Archive: what it's for

`Archive/` is where files go when they should leave the active vault but must not be lost. Moving a file there changes nothing about the file itself.

**When the AI moves something to Archive (and only then):**
- The user asks ("archive the X project", "put that away").
- Two brain pages turn out to be the same thing. Merge the content into the better page first, then archive the other one with a line at the top: `Merged into [[Better page]] on YYYY-MM-DD.`
- Undo removes a page that nightly filing created.
- A one-time setup or restructure leaves template files that nobody filled in.

The AI never archives something just because it looks old or unused. If it thinks a file has run its course, it says so and asks.

**How to archive a file:**
1. Move it to `Archive/` inside a folder named after where it came from, keeping the file name: `_Brain/concepts/X.md` goes to `Archive/_Brain/concepts/X.md`.
2. Add `archived: YYYY-MM-DD` and `archived_reason: "..."` to its frontmatter.
3. If it was a brain page, remove its line from `_Brain/index.md`, update `_Brain/overview.md` if it was linked there, and log it as `## [YYYY-MM-DD] archive | Page name`.

Links to an archived page keep working: Obsidian finds a `[[Page name]]` by its file name wherever it lives.

**Never archived:** anything in `Clippings/` (brain pages cite those sources forever), old entries in `_Brain/log.md`, and the timeline part of brain pages.

**Using the archive:** ignore `Archive/` results when searching, unless the user asks about old material. To bring a file back, move it to its original folder, remove the `archived` fields, and add it back to the index.

## Search by meaning

Keyword search only finds the exact words. Search by meaning finds pages about the same idea in different words: "pricing" also finds "what to charge". It uses the Smart Connections plugin's on-device index of the vault. Nothing leaves the Mac.

```
~/.claude/skills/vault-semantic-search/.venv/bin/python ~/.claude/skills/vault-semantic-search/scripts/search.py "what the user is asking about" --limit 8 --vault "[VAULT]"
```

Add `--json` for machine-readable output. Results are vault paths with a similarity score (higher is closer; below about 0.5 is usually noise) and a preview line. Always open and read the pages before using them.

When to use which:
- **`_Brain/index.md` and `_Brain/overview.md`**: first, for anything in the brain.
- **Keyword search (`grep`)**: exact names, numbers, quotes.
- **Search by meaning**: when those miss, when checking for duplicates during filing and lint, and when the user asks "have I read anything about X?"

Things to know:
- **It searches the whole vault,** including `Archive/`. Ignore `Archive/` results unless the user asks about old material. For reflection questions, ignore `_Brain/` results (see the reflection firewall).
- **The index updates while Obsidian is open.** Pages written overnight may be missing until the user opens Obsidian for a moment. If a page you just wrote doesn't show up, that's why.
- **If it errors with "embedding store not found",** Smart Connections isn't installed or hasn't finished indexing. Fall back to the index and grep, and tell the user once.
- **The model must match.** The script uses `TaylorAI/bge-micro-v2`, Smart Connections' default. If the user changes the model in Smart Connections' settings, the script needs the same change.

Karpathy's gist points to a tool called qmd for this. This vault uses Smart Connections instead, because it also gives the user search by meaning inside Obsidian and keeps its index current by itself.

## Changing this file

This schema is meant to evolve. When the user and the AI settle on a better way of doing something (a new page type, a different filing rhythm, a new output format), the AI proposes the exact change to this file in chat and makes it once the user agrees. Never change it silently: say what changed and why.
