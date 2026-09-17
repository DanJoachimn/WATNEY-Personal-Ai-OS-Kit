# Set up a second brain that files itself: instructions for the AI

You are the user's AI. This job turns the user's Obsidian vault into a second brain that you build and keep current (Andrej Karpathy's LLM Wiki pattern), filed automatically every night, with clear rules about who writes where, plus search by meaning. Do it in order. Show the user the plan before you move anything.

## Safety rules for this job

- **Nothing gets deleted.** Anything no longer needed moves to `Archive/`. The one exception: macOS `.DS_Store` junk files, which you may remove so empty folders can be cleared.
- **Back up first.** If the backup fails or doesn't check out, stop.
- **Move with `mv`.** Never copy and then delete the original.
- **Don't edit `.obsidian/`.** The user changes Obsidian settings themselves.
- **If anything looks different from what this prompt expects, stop** and explain it to the user in plain words before going on.

## Step 1: Find the vault and back it up

1. Find the vault. A WATNEY kit install keeps it at `~/<your-name>/vault/`; your own `CLAUDE.md` or `tools.md` usually says where. If you can't find it, ask the user. **Everywhere below, `[VAULT]` means the vault's full path and `[HOME]` means your home folder, the folder that contains the vault.** When you write files from this prompt, replace every `[VAULT]` and `[HOME]` with the real paths.
2. Ask the user to quit Obsidian while you work, so it doesn't fight the moves.
3. Make a full copy:
   `cp -R "[VAULT]" "[VAULT]-backup-$(date +%F)"`
4. Compare file counts. They must match:
   `find "[VAULT]" -type f | wc -l`
   `find "[VAULT]-backup-$(date +%F)" -type f | wc -l`
   If they differ, stop.

## Step 2: Look before you plan

1. **Check how your instructions file is wired.** Run `ls -la "$(dirname "[VAULT]")/CLAUDE.md"`. On a WATNEY kit install it's a link (`->`) to `[VAULT]/CLAUDE.md`: the vault's rules file is also the file you read at the start of every session. That's expected. **Leave the link alone.** Step 6 replaces the file's contents, and the link then points at the new rules by itself. Never turn the link into a copy: a copy would freeze the old rules, and every session would read those instead of the new ones. If it's a normal file instead (not a kit install, or set up by hand), that's fine too: Step 6 only replaces the vault's `CLAUDE.md` and never touches the one in your home folder. Mention it in the plan so the user knows where each file is.
2. Read the vault's current `CLAUDE.md` (if any) and every `README.md`. List the top-level folders.
3. Note which of these exist: `Daily/`, `Daily logs/`, `Brand/`, `People/`, `Companies/`, `_Brain/`, `_context/`, `Clippings/`, `wiki/`. For every file in `Brand/`, `People/` and `Companies/`, note whether it has real content or is still an untouched template (placeholders like `[BRAND]`, `YYYY-MM-DD`, `*[...]*`).
4. Look for daily notes sitting at the top of the vault (files named like `2026-09-16.md`).
5. Note anything in the current `CLAUDE.md` that isn't about vault folders: how you work, rules or preferences the user added. The new file replaces it, so those need carrying over.
6. Search your skills and scripts for the old folder names, since some may read or write there:
   `grep -rn -e 'Daily/' -e 'Brand/' -e 'People/' -e 'Companies/' ~/.claude "$(dirname "[VAULT]")" --include='*.md' --include='*.sh' --include='*.py' --include='*.json' 2>/dev/null | grep -v -F "[VAULT]"`
   Write down every hit. Don't change anything yet.

## Step 3: Ask one question, show the plan, wait

1. Ask the user: **"Do you keep, or want to keep, a daily journal in Obsidian?"**
   - Yes: the journal lives in `Daily logs/`. It is the user's own space; you only read it.
   - No: there's no journal folder, and Obsidian's daily notes get switched off.
2. Tell the user, in one or two sentences, that from now on you'll file what matters from their clippings and your conversations into the brain every night, that every change is logged and can be undone, and that they can say "don't file anything about X".
3. Tell the user in plain English:
   - what moves where (the table in Step 4, filled in with the real files, only the rows that apply)
   - which Brand/People/Companies files have real content and which are empty templates
   - anything from the current `CLAUDE.md` you plan to carry over into the new one
   - which skills or scripts mention the old folder names
4. Wait until the user says go.

## Step 4: Move things

Only the rows that apply to this vault:

| From | To |
|---|---|
| `Daily/` (user keeps a journal) | rename the folder to `Daily logs/` |
| `Daily/` (no journal) | `Archive/Daily/` |
| daily notes at the top of the vault | `Daily logs/` (journal) or `Archive/` (no journal). If a file with that name already exists there, put the stray in `Archive/` instead. |
| `Brand/` files with real content | `_context/` |
| `Brand/` files that are still templates | `Archive/Brand/` |
| `People/` entries with real content | `_Brain/people/`, reshaped to the Brain page format in `_Brain/README.md` |
| `Companies/` entries with real content | `_Brain/companies/`, same reshaping |
| `People/` and `Companies/` templates and READMEs | `Archive/People/` and `Archive/Companies/` |
| `wiki/sources/`, `wiki/concepts/`, `wiki/explorations/` pages (from an earlier version of this setup) | `_Brain/sources/`, `_Brain/concepts/`, `_Brain/explorations/` |
| `wiki/entities/` pages | people → `_Brain/people/`, organisations → `_Brain/companies/`, places and works → `_Brain/concepts/`; add `relation: read-about` |
| `wiki/index.md`, `wiki/log.md` | merge their entries into the new `_Brain/index.md` and `_Brain/log.md` (Step 5), then move the originals to `Archive/wiki/` |

If `_Brain/` already exists, add to it; never overwrite a page that's already there. If a person or company already has a page, merge the new facts into it with their citations.

For every Markdown file you move into `Archive/`, add `archived: YYYY-MM-DD` and `archived_reason: "wiki restructure: template never filled in"` (or the real reason) to its frontmatter.

Then remove any `.DS_Store` in the emptied folders and clear them with `rmdir`. `rmdir` only works on empty folders, which is the safety net. If it fails, something is still inside: stop and tell the user.

## Step 5: Create the new folders and starter files

Create these folders if they don't exist:

```
Clippings/
Clippings/assets/
_Brain/sources/
_Brain/people/
_Brain/companies/
_Brain/concepts/
_Brain/explorations/
_Brain/_pending/
_context/
Archive/
[HOME]/_recovery/brain-snapshots/
```

If a starter file below already exists, don't overwrite it: tell the user and leave it. If `_Brain/` already has pages, list every existing page in `_Brain/index.md` (one line each, from its title and first line) so the index is complete from day one.

Create `_Brain/index.md` with exactly this:

~~~~markdown
---
type: index
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Index

> The catalogue of every page in the brain: link, one-line summary, optional date or source count. Updated whenever a page is created. Read this first, every time.

## Sources

## People

## Companies

## Concepts

## Explorations
~~~~

Create `_Brain/log.md` with exactly this:

~~~~markdown
---
type: log
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Log

> Append-only. One entry per page filed, saved answer, lint pass, undo or archive, newest at the bottom.
> Format: `## [YYYY-MM-DD] file (nightly) | Page name` (or `file |`, `query |`, `lint |`, `undo |`, `setup |`, `archive |`), then one short line.
> Last five entries: `grep "^## \[" _Brain/log.md | tail -5`
~~~~

Create `_Brain/overview.md` with exactly this:

~~~~markdown
---
type: overview
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: 0
---

# What the brain knows so far

> One page, rewritten whenever filing changes a view: the current best understanding, with links to the pages behind it. Topics get added after the setup conversation.

## The big picture
Nothing filed yet.

## Where sources disagree

## Open questions

## How the thinking has changed
~~~~

Create `Clippings/README.md` with exactly this:

~~~~markdown
---
type: folder-note
generated_by: claude-code
---

# Clippings/

Raw sources. Articles, web pages, PDFs, transcripts. The Obsidian Web Clipper saves here, and downloaded images go in `assets/`.

**The AI never edits, renames or moves anything in this folder.** It reads clippings and files what matters into `_Brain/`, usually overnight.

To add something: just clip it. Your AI files new clippings every night. Want it filed now, with a chat about it? Say "file this now".
~~~~

Create `_Brain/README.md` with exactly this (if one exists, move it to `Archive/_Brain/README-old.md` first; the old folder list is out of date):

~~~~markdown
---
type: folder-note
generated_by: claude-code
---

# _Brain/

The second brain the AI builds and keeps current from clippings and conversations, filed automatically every night. Every fact has a source.

- `index.md`: the catalogue of every page. Start here.
- `overview.md`: what the brain currently believes, and how that changed.
- `log.md`: every page filed, and when.
- `sources/`: one summary page per clipping
- `people/`: one page per person
- `companies/`: one page per organisation
- `concepts/`: ideas, methods, patterns, and works
- `explorations/`: good answers worth keeping
- `_pending/`: mentioned once, waiting for a second mention

## Page shape

```markdown
---
type: person | company | concept | source
generated_by: claude-code
first_seen: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Name

Current best understanding. Rewritten when the facts change.
Every fact ends with a citation. [Source: user, voice note, 2026-09-16]

<!-- ↑ COMPILED TRUTH ABOVE · APPEND-ONLY TIMELINE BELOW ↓ -->

## Timeline
- YYYY-MM-DD: what happened [Source: ...]
```

The full rules are in the vault's `CLAUDE.md`.
~~~~

Fill in today's date wherever a starter file says `YYYY-MM-DD` in frontmatter.

## Step 6: Replace CLAUDE.md

1. If the vault has a `CLAUDE.md`, **copy** it to the archive: `cp "[VAULT]/CLAUDE.md" "[VAULT]/Archive/CLAUDE-old-$(date +%F).md"`. Copy, don't move: if your home-folder `CLAUDE.md` links to this file, it must never disappear, not even for a moment.
2. Overwrite `[VAULT]/CLAUDE.md` itself (not the link in your home folder) with the content between the markers below, with every `[VAULT]` and `[HOME]` replaced by the real paths.
3. If the user agreed in Step 3 to carry anything over, add it at the end under `## Carried over from the old CLAUDE.md`.
4. Check: if Step 2 found a link, `ls -la "$(dirname "[VAULT]")/CLAUDE.md"` still shows it, and `head -1 "$(dirname "[VAULT]")/CLAUDE.md"` shows `# Vault rules`. If the link is gone or shows the old title, stop and tell the user.

===== NEW CLAUDE.md STARTS =====

~~~~markdown
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
~~~~

===== NEW CLAUDE.md ENDS =====

## Step 7: One label everywhere

AI-written files must say `generated_by: claude-code`, whatever your name is. Find files using any other value:
`grep -rn '^generated_by:' "[VAULT]" --include='*.md' | grep -v 'generated_by: claude-code'`
In each one, change that line to `generated_by: claude-code`. Touch only that line.

## Step 8: Fix old folder names in skills and scripts (ask first)

For each hit from Step 2, show the user the line and your proposed change (`Daily/` to `Daily logs/` or none, `Brand/` to `_context/`, `People/` to `_Brain/people/`, `Companies/` to `_Brain/companies/`). Change only what the user approves.

Watch for skills that **write** into the daily journal (a morning brief, a wrap-up, anything that creates or appends to a daily note). The journal is now the user's alone, or doesn't exist. Propose sending that output to `Memory/daily-memory.md`, or switching the skill off if it only exists to fill a journal, and let the user decide.

## Step 9: Check and report

1. Show the new layout:
   `find "[VAULT]" -maxdepth 2 -not -path '*/.obsidian*' -not -name '.DS_Store' | sort`
2. Count files again. The vault should have at least the backup's count, minus any `.DS_Store` files you removed. If it has fewer, stop and tell the user. The backup is untouched.
3. Tell the user, in plain words: what moved, what's new, what went to `Archive/`, and where the backup is.
4. If `Memory/daily-memory.md` exists, add one line:
   `YYYY-MM-DD HH:MM: Set up the second brain with nightly filing. Backup at [VAULT]-backup-YYYY-MM-DD.`
5. Remind the user to make the Obsidian settings changes from the guide (daily notes, Web Clipper folder, attachment folder, download-attachments hotkey).

## Step 10: Teach your nightly job to file

Your `dreaming` skill already runs every night and harvests yesterday's conversations into `Memory/daily-memory.md`. Now it also files into the brain.

1. Open `~/.claude/skills/dreaming/SKILL.md`. If it doesn't exist, tell the user nightly filing isn't possible yet (their install has no nightly job), skip to Step 11, and say so plainly in the final report.
2. Right after the conversation harvest step (and before memory compression), add this step, word for word:

~~~~markdown
### Step 0.5 — File into the brain

If `[VAULT]/_Brain/index.md` exists, follow the section **"Nightly filing (automatic)"** in `[VAULT]/CLAUDE.md` exactly: file the durable points you just harvested and up to 3 new clippings into `_Brain/`. Snapshot every existing page to `[HOME]/_recovery/brain-snapshots/YYYY-MM-DD/` and confirm the copy before you change it; no confirmed snapshot, no change. Skip points from conversations in folders marked `.private`. At most 15 pages, every fact cited, every page logged in `_Brain/log.md` as `file (nightly)` (new pages marked `(new)`). Never write anywhere else in the vault. If anything errors, stop filing, log it in `Memory/daily-memory.md`, and continue with the rest of dreaming. Filing must never stop memory compression.
~~~~

3. Check the nightly job is allowed to write files: `grep -o 'allowedTools[^-]*' ~/Library/LaunchAgents/*dreaming*.plist`. It should include `Read Edit Write Glob Grep`. If it doesn't, don't edit the plist yourself: tell the user and stop this step.
4. **Test once, now, on today:** run the filing step by hand on today's conversation (this one). File at most 3 pages, and make sure at least one is an update to an existing page so a snapshot gets written. Check the snapshot folder was created and the copy matches. Show the user what you filed and where the snapshot is, then run "undo" on one page and show that it came back exactly.
5. **Private folders:** tell the user in one sentence that any project folder with a file named `.private` in it is never filed, and offer to create that file in any client or shared-data folders they name.

## Step 11: Switch on search by meaning

This lets you find pages by what they're about, not only the exact words. It uses the Smart Connections plugin in Obsidian, and everything stays on the Mac.

1. **Check what's already there.** If `~/.claude/skills/vault-semantic-search/scripts/search.py` exists (the kit's Part 2 may have built one), run it with a test query. If it returns vault pages, keep it, check its command matches the one in the new `CLAUDE.md`, and skip to item 9.
2. **The user installs the plugin** (you don't touch `.obsidian/`). Ask the user to open Obsidian and:
   - Settings → Community plugins → **Turn on community plugins** (it's off by default, and it's the step everyone misses)
   - Browse → search "Smart Connections" → Install → Enable
   - In Smart Connections' settings, check the embedding model is the default `TaylorAI/bge-micro-v2` and no API key is entered, so it runs on the Mac
   - Leave Obsidian open a minute or two while it indexes
3. **Check the index exists:** `ls "[VAULT]/.smart-env/multi" | wc -l` should be more than 0. If it's 0 after a few minutes, stop and tell the user.
4. **Ask the user before downloading.** Say: this needs a one-time download of about 700 MB (a small search engine plus a 34 MB language model), stored in `~/.claude/skills/vault-semantic-search/`. Nothing gets uploaded. Wait for OK.
5. **Set up the Python environment:**
   `python3 -m venv ~/.claude/skills/vault-semantic-search/.venv`
   `~/.claude/skills/vault-semantic-search/.venv/bin/pip install sentence-transformers`
   If `python3` isn't found, macOS will offer to install developer tools; tell the user to accept, then retry.
6. **Write the script.** `mkdir -p ~/.claude/skills/vault-semantic-search/scripts`, then write `~/.claude/skills/vault-semantic-search/scripts/search.py` with exactly this:

~~~~python
#!/usr/bin/env python3
"""
vault-semantic-search/search.py: semantic ("by meaning") search over an Obsidian
vault, by reusing Smart Connections' on-disk local embeddings.

Smart Connections (Obsidian community plugin) already embedded every note
locally using TaylorAI/bge-micro-v2. This script:
  1. Loads the same model
  2. Embeds the query
  3. Reads SC's embedding store (.smart-env/multi/*.ajson)
  4. Returns top-N notes by cosine similarity

Usage:
  python3 search.py "what to charge for a workshop" --vault ~/your-ai/vault
  python3 search.py "pricing" --limit 5 --json --vault ~/your-ai/vault

Vault location: --vault, else the VAULT_PATH environment variable.
"""
from __future__ import annotations
import argparse, json, re, sys, time
from pathlib import Path

import os
VAULT = Path(os.environ.get("VAULT_PATH", "")).expanduser() if os.environ.get("VAULT_PATH") else None
SC_DIR = VAULT / ".smart-env" / "multi" if VAULT else None
MODEL_NAME = "TaylorAI/bge-micro-v2"  # MUST match Smart Connections' embed_model

VEC_RE = re.compile(r'"vec"\s*:\s*\[([0-9eE.,\-\s]+)\]')
SOURCE_RE = re.compile(r'"smart_sources:([^"]+)"\s*:')

def load_sc_index() -> list[tuple[str, list[float]]]:
    """
    Walk .smart-env/multi/*.ajson and pull out (note_path, vector) tuples.

    SC's .ajson format is append-only — each note's file holds a metadata
    record AND any vector records. A note may have multiple vectors (for
    sub-blocks). We take the LAST vector per note as the canonical one.
    """
    if SC_DIR is None or not SC_DIR.exists():
        return []
    results: dict[str, list[float]] = {}
    for fp in SC_DIR.glob("*.ajson"):
        try:
            raw = fp.read_text(encoding="utf-8", errors="replace")
        except Exception:
            continue
        # Find the note path (first smart_sources record)
        path_match = SOURCE_RE.search(raw)
        if not path_match:
            continue
        note_path = path_match.group(1)
        # Find all vec arrays in this file
        for m in VEC_RE.finditer(raw):
            try:
                vec = [float(x) for x in m.group(1).split(",")]
                if len(vec) >= 300:  # sanity: bge-micro-v2 is 384 dim
                    results[note_path] = vec  # last one wins
            except Exception:
                continue
    return list(results.items())

def cosine(a: list[float], b: list[float]) -> float:
    """Cosine similarity. Pure Python — fine for the ~280-note vault scale."""
    dot = sum(x*y for x, y in zip(a, b))
    na = sum(x*x for x in a) ** 0.5
    nb = sum(x*x for x in b) ** 0.5
    if na == 0 or nb == 0:
        return 0.0
    return dot / (na * nb)

def search(query: str, limit: int = 10) -> list[dict]:
    if not SC_DIR.exists():
        sys.stderr.write(
            "ERROR: Smart Connections embedding store not found at "
            f"{SC_DIR}\nIs Smart Connections plugin installed + indexing complete?\n"
        )
        return []

    # Load model + embed query (model cache is on disk from first run)
    from sentence_transformers import SentenceTransformer  # heavy import — lazy
    t0 = time.time()
    model = SentenceTransformer(MODEL_NAME)
    query_vec = model.encode(query).tolist()
    t_embed = time.time() - t0

    t1 = time.time()
    index = load_sc_index()
    t_load = time.time() - t1
    if not index:
        sys.stderr.write("ERROR: 0 embedded notes found. SC may still be indexing.\n")
        return []

    # Cosine similarity vs every note
    t2 = time.time()
    scores = [(note_path, cosine(query_vec, vec)) for note_path, vec in index]
    scores.sort(key=lambda x: x[1], reverse=True)
    t_score = time.time() - t2

    top = scores[:limit]
    out = []
    for note_path, score in top:
        # Try to read a short preview from the note
        preview = ""
        full = VAULT / note_path
        if full.exists():
            try:
                text = full.read_text(encoding="utf-8", errors="replace")
                # Skip frontmatter for preview
                if text.startswith("---"):
                    end = text.find("\n---", 4)
                    if end > 0:
                        text = text[end+4:]
                # First non-empty line, up to 180 chars
                for line in text.splitlines():
                    s = line.strip()
                    if s and not s.startswith("#"):
                        preview = s[:180]
                        break
                if not preview:
                    # Fallback to first heading
                    for line in text.splitlines():
                        if line.strip().startswith("#"):
                            preview = line.strip()[:180]
                            break
            except Exception:
                pass
        out.append({
            "path": note_path,
            "score": round(score, 4),
            "preview": preview,
        })

    # Stash timing for stderr (helpful for skill-author tuning, invisible to JSON)
    sys.stderr.write(
        f"[timing] embed_query={t_embed:.2f}s · load_index={t_load:.2f}s ({len(index)} notes) · score={t_score:.2f}s\n"
    )
    return out

def main():
    ap = argparse.ArgumentParser(description="Semantic search across an Obsidian vault (reuses Smart Connections embeddings).")
    ap.add_argument("query", help="natural-language query")
    ap.add_argument("--limit", type=int, default=10)
    ap.add_argument("--json", action="store_true", help="output JSON")
    ap.add_argument("--vault", help="vault folder (or set VAULT_PATH)")
    args = ap.parse_args()

    if args.vault:
        global VAULT, SC_DIR
        VAULT = Path(args.vault).expanduser()
        SC_DIR = VAULT / ".smart-env" / "multi"
    if VAULT is None:
        sys.stderr.write("ERROR: no vault given. Pass --vault /path/to/vault or set VAULT_PATH.\n")
        return 2

    results = search(args.query, limit=args.limit)

    if args.json:
        print(json.dumps(results, indent=2))
        return 0

    if not results:
        print(f"No semantic matches for: {args.query}")
        return 0

    print(f"\n🔍 Top {len(results)} semantic matches for: {args.query}\n")
    for i, r in enumerate(results, 1):
        print(f"[{i}] {r['score']:.3f}  {r['path']}")
        if r["preview"]:
            print(f"     › {r['preview']}")
        print()
    return 0

if __name__ == "__main__":
    sys.exit(main())
~~~~

7. **Write the skill file.** If `~/.claude/skills/vault-semantic-search/SKILL.md` already exists, move it to `SKILL-previous.md` in the same folder first. Then write `SKILL.md` with exactly this, replacing `[VAULT]`:

~~~~markdown
---
name: vault-semantic-search
description: Search the vault by MEANING, not just keywords, using the Smart Connections plugin's local index. Use when grep or wiki/index.md misses related pages, when checking for duplicate wiki pages during ingest or lint, or when the user asks "have I read anything about X?".
---

# Vault semantic search

```
~/.claude/skills/vault-semantic-search/.venv/bin/python ~/.claude/skills/vault-semantic-search/scripts/search.py "query" --limit 8 --vault "[VAULT]"
```

Add `--json` for machine-readable output. Needs the Smart Connections plugin installed and indexed in Obsidian. Fully local. Rules for when to use it are in the vault's `CLAUDE.md`, section "Search by meaning".
~~~~

8. **Test it:** `~/.claude/skills/vault-semantic-search/.venv/bin/python ~/.claude/skills/vault-semantic-search/scripts/search.py "what this vault is about" --limit 3 --vault "[VAULT]"`
   The first run downloads the small model, so it takes longer. You should see a few vault pages with scores. If you get "embedding store not found", go back to item 3.
9. **If the vault is a git repository** (`git -C "[VAULT]" status` works), make sure `.smart-env/` is in its `.gitignore`. The index is large and rebuilds itself.
10. **Record it:** add a row for `vault-semantic-search` to `tools.md` if you have one (what it does, the command above), and add one line to `Memory/daily-memory.md` if it exists.

## Step 12: Make it the user's brain

Run the setup conversation from the new `CLAUDE.md` now (section "The brain's focus"), so the brain knows what matters to the user, and what never to file, before its first night.
