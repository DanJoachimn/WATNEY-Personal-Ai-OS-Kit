# Vault rules

This file lives at the root of the Obsidian vault, `[VAULT]`. It is the **schema**: it tells the AI how the vault is structured, what the conventions are, and which workflows to follow. Read it before touching anything.

The core of the vault is an LLM wiki, following Andrej Karpathy's pattern ("LLM Wiki": https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Instead of re-reading raw documents every time the user asks something, the AI reads each source once, files what matters into a wiki of linked pages, and keeps that wiki current as new sources arrive. The knowledge is compiled once and kept up to date, not rediscovered on every question.

In Karpathy's words: Obsidian is the IDE, the LLM is the programmer, the wiki is the codebase. The user has the AI open on one side and Obsidian on the other, and browses the results as they change.

## The three layers

1. **Raw sources: `Clippings/`.** Articles, papers, transcripts, images, data files that the user chose. **Immutable.** The AI reads them and never modifies, renames or moves them. The only thing the AI may do here is save a *new* file when the user hands over a link or text to file. This is the source of truth.
2. **The wiki: `wiki/`.** Markdown pages written by the AI: source summaries, entity pages, concept pages, comparisons, syntheses. **The AI owns this layer entirely.** It creates pages, updates them when new sources arrive, maintains the links, and keeps everything consistent. The user reads it; the AI writes it.
3. **The schema: this file.** The user and the AI evolve it together (see "Changing this file" at the bottom).

Division of labour: **The user curates sources, directs the analysis, asks good questions, and decides what it all means. The AI does everything else**: summarising, cross-referencing, filing and bookkeeping.

## The wiki's focus

Karpathy leaves the details to "your domain". This section is where the user's domain gets written down, so every session files things the same way. **Read it before every ingest and every lint.**

**Status: not filled in yet.** Until it is, run the setup conversation below before the first ingest.

- **What this wiki is for:** *(one or two sentences)*
- **Main topics:** *(the 3 to 6 areas most sources will be about)*
- **Questions the user wants it to answer:** *(the real questions, in the user's words)*
- **What to pull out of every source:** *(e.g. practical takeaways, the evidence behind a claim, numbers worth remembering)*
- **Sources the user trusts, and ones to treat with care:**
- **Tags to use:** *(a short fixed list, so pages stay findable. Add new tags only with the user's OK.)*
- **Ingest style:** *(one at a time with discussion, or batches)*

### The setup conversation

Run it when this section says "not filled in yet", or when the user says "let's set up the wiki" or "let's rethink what the wiki is for".

1. Tell the user in one sentence what's about to happen: a few questions so the wiki fits what the user actually wants from it.
2. Ask the questions **one at a time**, in plain words, and let the user answer in the user's own words before offering any suggestions:
   - What do you want this wiki to help you with?
   - What will you mostly be clipping?
   - What questions do you hope to ask it in three months?
   - When you read something useful, what's the part you want to keep?
   - Any sources you rely on, or ones you're sceptical of?
   - One article at a time with a chat about it, or drop a pile and let me work through it?
3. Draft the filled-in section in chat, including a first tag list (8 to 15 tags) built from the user's answers.
4. Change it until the user is happy, then write it into this file, set the status to "filled in (date)", and log it in `wiki/log.md` as `## [YYYY-MM-DD] setup | Wiki focus`.
5. Add one `## Topic name` heading per main topic to `wiki/overview.md`, each saying "Nothing filed yet."
6. Offer to ingest the first clipping together.

Revisit it when a lint shows the wiki drifting away from these topics, or every few months.

## The layout

```
[VAULT]/
├── CLAUDE.md          this file, the schema
├── Clippings/         raw sources. Never edited.
│   └── assets/        images downloaded from clippings
├── wiki/              the personal wiki the AI builds from Clippings
│   ├── index.md       the table of contents. Always read first.
│   ├── log.md         what was added, and when
│   ├── overview.md    what the wiki currently believes, on one page
│   ├── sources/       one summary page per clipping
│   ├── entities/      people, organisations, places, works that appear in the clippings
│   ├── concepts/      ideas, methods, patterns
│   └── explorations/  good answers worth keeping: comparisons, analyses, syntheses
├── _Brain/            the AI's filing cabinet about the user's real world, every fact cited
│   └── people/ companies/ concepts/ sources/ _pending/
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

The wiki (Clippings, wiki, this schema) is Karpathy's pattern. Everything below the wiki in the tree is the rest of the user's setup, and the rules for it are further down.

Read `tools.md` and `Memory/long-term.md` at the start of every session.

## What the user says, and what the AI does

The user won't use the operation names. Match what the user says to the job:

| The user says something like | The AI does |
|---|---|
| "ingest this", "add this to the wiki", "read this and file it" | **Ingest** that one source |
| pastes a link or a chunk of text and says "file this" | Save it as a **new** file in `Clippings/`, then **Ingest** it |
| "ingest everything new", "catch up on my clippings" | **Batch ingest**: every clipping that no `wiki/sources/` page points to yet |
| asks any question about a topic the user has been reading about | **Query** |
| "save that", "keep that", "put that in the wiki" | File the last answer as an exploration |
| "check the wiki", "tidy up", "what's missing?" | **Lint** |
| "what's been added lately?" | Read the last entries of `wiki/log.md` and summarise |
| "have I read anything about X?", "find anything on X" | **Search by meaning** across the vault, then read the best matches |
| "what have we learned so far?", "what does the wiki think about X?" | Answer from `wiki/overview.md`, linking to the pages behind it |
| tells the AI about a real person, company or event in the user's life | Update `_Brain/` (with a citation) |
| "what patterns do you see in my thinking?", "challenge my ideas" | **Reflection**: read only the user's own writing (see the firewall rule) |
| "change how you do X from now on" | Propose the exact edit to this file, make it once the user agrees |
| "let's set up the wiki", "let's rethink what the wiki is for" | Run the **setup conversation** |

When it's unclear which job the user means, ask one short question.

## Wiki operations

### Ingest: the user adds a source to `Clippings/` and says "ingest this"

1. Read `wiki/index.md` first, so you update existing pages instead of creating duplicates. Check "The wiki's focus" so you know what to pull out and which tags to use.
2. Read the source in full. Then **search by meaning** for its main topics, to find existing pages that cover the same thing under different words ("pricing" and "what to charge" are one page, not two). Update those instead of creating near-duplicates. If it has images in `Clippings/assets/`, read the text first, then look at the images that matter.
3. Discuss it with the user: 3 to 5 key takeaways, and ask what to emphasise. The user's steer decides what gets filed.
4. File it:
   - write a summary page in `wiki/sources/`
   - create or update the relevant pages in `wiki/entities/` and `wiki/concepts/`, revising their summaries to take in the new source. One source often touches 10 to 15 pages; that is normal.
   - where the new source contradicts an existing page, keep both claims, each with its source, and flag the contradiction on the page
   - add `[[wikilinks]]` in both directions: source page to entity/concept pages, and back
   - add each new page to `wiki/index.md`
   - **update `wiki/overview.md`** so it reflects everything filed so far (see below). If this source changed what the wiki believes, add a line to "How the thinking has changed".
   - append an entry to `wiki/log.md`
5. Tell the user which pages were created or changed, and in one sentence what (if anything) changed in the overview.

A clipping counts as ingested once a page in `wiki/sources/` points to it in its `clipping:` field. That's how batch ingest finds what's new.

Default: **one source at a time, with the user involved.** Batch ingest (several sources, less discussion) only when the user asks for it.

Source pages stay factual. Interpretation belongs in concept pages and explorations.

### Query: the user asks a question

1. Read `wiki/overview.md` for the big picture and `wiki/index.md` to find the relevant pages, then read those pages. If that doesn't turn up enough, or the user's question uses different words than the pages do, **search by meaning** before concluding the wiki doesn't know.
2. Answer with `[[wikilinks]]` to the pages used. Pick the form that fits the question: a few paragraphs, a comparison table, a new page, a chart.
3. **Good answers get filed back into the wiki.** If the answer is a comparison, an analysis or a connection worth keeping, offer to save it as a page in `wiki/explorations/`, add it to the index, and log it. Explorations compound in the wiki just like sources do; they shouldn't disappear into chat history.
4. If the wiki doesn't have enough to answer, say so and suggest what to clip or look up.

### Lint: the user says "check the wiki" (worth doing every few weeks)

Look for:
- contradictions between pages
- stale claims that newer sources have superseded
- orphan pages with no inbound links
- near-duplicate pages about the same thing under different names (search by meaning for each concept page's title)
- important concepts or entities mentioned but lacking their own page
- missing cross-references
- data gaps a web search could fill
- an overview that no longer matches the pages behind it

Also check the wiki still matches "The wiki's focus", and suggest new questions worth investigating and new sources worth clipping. Report everything; fix what the user approves; log the pass.

## index.md and log.md

**`wiki/index.md` is about content.** A catalog of every page in the wiki, grouped under `## Sources`, `## Entities`, `## Concepts`, `## Explorations`. One line per page, with a link, a one-line summary and, where useful, metadata:

```
- [[Page name]]: one-line summary (2026-09-16, 3 sources)
```

Update it on every ingest and every filed exploration. Read it first for every query. At this size it replaces any search engine.

**`wiki/log.md` is about time.** Append-only; never edit old entries. Record every ingest, every filed query, every lint pass. Every entry starts with the same prefix so it can be searched with simple tools:

```
## [2026-09-16] ingest | Article title
One short paragraph: what was added, which pages were created or updated.

## [2026-09-18] query | How do the two pricing models compare?
Filed as [[Pricing models compared]].

## [2026-10-01] lint | Monthly check
2 contradictions flagged, 3 orphans linked, suggested 2 new sources.
```

Last five entries: `grep "^## \[" wiki/log.md | tail -5`

## overview.md: what the wiki currently believes

One page that sums up everything the wiki knows, organised by the main topics in "The wiki's focus". This is where the user can see the wiki getting smarter.

- **Rewritten, not appended.** On every ingest, revise the parts the new source affects so the page always shows the current best understanding. Keep it to roughly one screen per topic.
- **Every claim links** to the source, entity or concept pages behind it. No claim without a page.
- **Say how sure the wiki is.** Label each topic's view as *solid* (several sources agree), *emerging* (one or two sources) or *contested* (sources disagree).
- **"How the thinking has changed" is the exception: only ever add to it**, newest at the top, one dated line each time a source shifts a view. Never rewrite or delete old lines. This is the record of the wiki learning.

Shape:

```
---
type: overview
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: 0
generated_by: claude-code
---

# What the wiki knows so far

## The big picture
3 to 6 sentences: the current best understanding across all topics.

## Topic name
Current view, in a few sentences with [[links]]. Confidence: solid | emerging | contested.

## Where sources disagree
- The disagreement, with [[links]] to each side.

## Open questions
- What the wiki can't answer yet, and what to clip to find out.

## How the thinking has changed
- 2026-10-02: View on annual pricing moved from "always discount" to "discount only for commitment" after [[Source page]].
```

## Page conventions

Every wiki page starts with frontmatter (Obsidian's Dataview plugin can turn this into tables):

```yaml
---
type: source | entity | concept | exploration
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [from the tag list]
sources: 1            # how many sources this page draws on
clipping: "[[File name]]"   # source pages only: the clipping this summarises
generated_by: claude-code
---
```

- **File names:** Title Case, spaces are fine. One page per thing.
- **Link generously.** Every mention of something that has its own page gets a `[[wikilink]]`. The links are what make the wiki more than a pile of notes; Obsidian's graph view shows hubs and orphans.
- **Prefer updating over creating.** A richer page beats a duplicate.
- **`generated_by` is always `claude-code`,** even though the AI has a name. It's the fixed label that marks a file as AI-written, so anything filtering out AI-written files catches them all. Bump `updated:` on every edit.

## Two kinds of people and organisations: keep them apart

- `wiki/entities/`: people and organisations **from things the user clipped**. An author, a founder the user read about, a brand in an article.
- `_Brain/people/` and `_Brain/companies/`: people and organisations **in the user's actual life**. Colleagues, clients, friends, the supplier the user emails.

If someone is both, they get a `_Brain` page that links to their wiki entity page.

## Who writes where (the rest of the vault)

| Folder | The AI may |
|---|---|
| `Clippings/` | read; save a new file only when the user hands over a link or text. Never change an existing one. |
| `wiki/` | write, through the operations above |
| `_Brain/` | write, following the Brain rules below |
| `Memory/`, `tools/`, `tools.md` | write |
| `Projects/`, `Meetings/` | read, and add to them when the user asks |
| `Archive/` | move things in. Never delete. |
| `Notes/`, `_context/`, `Source material/`, `Daily logs/` (if it exists) | **read only. Never write, append to, or create files here.** |
| `Goals.md`, `Constraints.md`, `Working style.md` | read only |

When the user wants something changed in a read-only area, write the new text in chat and let the user paste it in. Those folders stay 100% the user's own words.

**Why this matters:** Notes, _context and any journal are the mirror of the user's thinking. If the AI writes there, then later, when the user asks "what patterns keep showing up in my thinking?", nobody can tell the user's ideas apart from the AI's.

**The user's own writing is not a raw source.** Karpathy's pattern allows filing personal notes and journal entries into the wiki. This vault deliberately doesn't: only `Clippings/` feeds the wiki, so the user's own thinking never gets rewritten into AI pages. If the user wants one of those notes in the wiki, the user copies it into `Clippings/` on purpose.

**Daily journal: optional.** If the vault has a `Daily logs/` folder, it is the user's journal and it is read only, exactly like `Notes/`. If it doesn't, the user doesn't keep one: never create daily notes. Either way, the AI's own session trail goes in `Memory/daily-memory.md`, never in the journal.

## The Brain: `_Brain/`

This is not part of Karpathy's pattern. It's the AI's notebook about the user's real world, kept separate from the wiki.

1. **Every fact gets an inline citation.** No source, no fact. Formats:
   - `[Source: user, {context}, YYYY-MM-DD]` for things the user said
   - `[Source: meeting transcript, YYYY-MM-DD]` for captured material
   - `[Source: compiled from X + Y]` for things the AI pieced together
2. **Notability gate.** Only create a `people/` or `companies/` page for someone mentioned twice, or once with real substance. Single mentions go in `_Brain/_pending/` until a second mention promotes them.
3. **The divider.** Above `<!-- ↑ COMPILED TRUTH ABOVE · APPEND-ONLY TIMELINE BELOW ↓ -->` is the current truth, which may be rewritten. Below it is the timeline: add to it, never delete from it.
4. **Re-read before editing.** Another session may have changed the page.

Page shape is in `_Brain/README.md`.

### The reflection firewall

`_Brain/` holds the AI's inferences, not the user's thinking. When the user asks the AI to find patterns in the user's thinking, reflect on the user's ideas or mirror the user's worldview, read **only** the user's own writing: `Notes/`, `_context/`, `Daily logs/` if it exists, project files. **Never read `_Brain/` for that.** Otherwise the AI's guesses come back to the user dressed up as the user's own thoughts.

Operational work (meeting capture, briefings, drafting, research) may read `_Brain/`. Reflection may not.

## General rules

1. **Never delete.** Move to `Archive/`, following the Archive rules below.
2. **Re-read before editing.** The user may have changed the file. Never silently overwrite the user's edits.
3. **Two folder levels max** inside any area. Use tags and wikilinks, not deeper folders.
4. **Before drafting anything in the user's voice,** read `_context/` and 2 to 3 files from `Source material/`.
5. **Search, don't remember.** When the user asks "what did we decide about X", search the vault (`grep -rn "X" [VAULT]/`). The vault is the source of truth, not session memory.
6. **The vault lives in the home folder on purpose.** Never look for it in `~/Documents/`; macOS privacy protection silently blocks background jobs from reading there.

## Archive: what it's for

`Archive/` is where files go when they should leave the active vault but must not be lost. Moving a file there changes nothing about the file itself.

**When the AI moves something to Archive (and only then):**
- The user asks ("archive the X project", "put that away").
- Two wiki pages turn out to be the same thing. Merge the content into the better page first, then archive the other one with a line at the top: `Merged into [[Better page]] on YYYY-MM-DD.`
- A one-time setup or restructure leaves template files that nobody filled in.

The AI never archives something just because it looks old or unused. If it thinks a file has run its course, it says so and asks.

**How to archive a file:**
1. Move it to `Archive/` inside a folder named after where it came from, keeping the file name: `wiki/concepts/X.md` goes to `Archive/wiki/concepts/X.md`.
2. Add `archived: YYYY-MM-DD` and `archived_reason: "..."` to its frontmatter.
3. If it was a wiki page, remove its line from `wiki/index.md`, update `wiki/overview.md` if it was linked there, and log it in `wiki/log.md` as `## [YYYY-MM-DD] archive | Page name`.

Links to an archived page keep working: Obsidian finds a `[[Page name]]` by its file name wherever it lives.

**Never archived:** anything in `Clippings/` (wiki pages cite those sources forever), old entries in `wiki/log.md`, and the timeline part of `_Brain/` pages.

**Using the archive:** ignore `Archive/` results when searching, unless the user asks about old material. To bring a file back, move it to its original folder, remove the `archived` fields, and add it back to the index.

## Search by meaning

Keyword search only finds the exact words. Search by meaning finds pages about the same idea in different words: "pricing" also finds "what to charge". It uses the Smart Connections plugin's on-device index of the vault. Nothing leaves the Mac.

```
~/.claude/skills/vault-semantic-search/.venv/bin/python ~/.claude/skills/vault-semantic-search/scripts/search.py "what the user is asking about" --limit 8 --vault "[VAULT]"
```

Add `--json` for machine-readable output. Results are vault paths with a similarity score (higher is closer; below about 0.5 is usually noise) and a preview line. Always open and read the pages before using them.

When to use which:
- **`wiki/index.md` and `wiki/overview.md`**: first, for anything in the wiki.
- **Keyword search (`grep`)**: exact names, numbers, quotes.
- **Search by meaning**: when those miss, when checking for duplicates during ingest and lint, and when the user asks "have I read anything about X?"

Things to know:
- **It searches the whole vault,** including `_Brain/` and `Archive/`. For reflection questions, ignore any `_Brain/` results (see the reflection firewall). Ignore `Archive/` results unless the user asks about old material.
- **The index updates while Obsidian is open.** Pages written in the last minutes, or while Obsidian was closed, may be missing until the user opens Obsidian for a moment. If a page you just wrote doesn't show up, that's why.
- **If it errors with "embedding store not found",** Smart Connections isn't installed or hasn't finished indexing. Tell the user; don't pretend the search ran.
- **The model must match.** The script uses `TaylorAI/bge-micro-v2`, Smart Connections' default. If the user changes the model in Smart Connections' settings, the script needs the same change.

Karpathy's gist points to a tool called qmd for this. This vault uses Smart Connections instead, because it also gives the user search by meaning inside Obsidian and keeps its index current by itself.

## Changing this file

This schema is meant to evolve. When the user and the AI settle on a better way of doing something (a new page type, a different ingest rhythm, a new output format), the AI proposes the exact change to this file in chat and makes it once the user agrees. Never change it silently: say what changed and why.
