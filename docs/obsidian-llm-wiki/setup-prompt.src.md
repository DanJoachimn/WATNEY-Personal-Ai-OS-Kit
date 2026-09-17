# Set up an LLM wiki in this Obsidian vault: instructions for the AI

You are the user's AI. This job turns the user's Obsidian vault into an LLM wiki (Andrej Karpathy's pattern) with clear rules about who writes where, plus search by meaning. Do it in order. Show the user the plan before you move anything.

## Safety rules for this job

- **Nothing gets deleted.** Anything no longer needed moves to `Archive/`. The one exception: macOS `.DS_Store` junk files, which you may remove so empty folders can be cleared.
- **Back up first.** If the backup fails or doesn't check out, stop.
- **Move with `mv`.** Never copy and then delete the original.
- **Don't edit `.obsidian/`.** The user changes Obsidian settings themselves.
- **If anything looks different from what this prompt expects, stop** and explain it to the user in plain words before going on.

## Step 1: Find the vault and back it up

1. Find the vault. A WATNEY kit install keeps it at `~/<your-name>/vault/`; your own `CLAUDE.md` or `tools.md` usually says where. If you can't find it, ask the user. **Everywhere below, `[VAULT]` means the vault's full path.** When you write files from this prompt, replace every `[VAULT]` with that real path.
2. Ask the user to quit Obsidian while you work, so it doesn't fight the moves.
3. Make a full copy:
   `cp -R "[VAULT]" "[VAULT]-backup-$(date +%F)"`
4. Compare file counts. They must match:
   `find "[VAULT]" -type f | wc -l`
   `find "[VAULT]-backup-$(date +%F)" -type f | wc -l`
   If they differ, stop.

## Step 2: Look before you plan

1. **Check how your instructions file is wired.** Run `ls -la "$(dirname "[VAULT]")/CLAUDE.md"`. On a WATNEY kit install it's a link (`->`) to `[VAULT]/CLAUDE.md`: the vault's rules file is also the file you read at the start of every session. That's expected. **Leave the link alone.** Step 6 replaces the file's contents, and the link then points at the new rules by itself. Never turn the link into a copy: a copy would freeze the old rules, and every session would read those instead of the new ones.
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
2. Tell the user in plain English:
   - what moves where (the table in Step 4, filled in with the real files, only the rows that apply)
   - which Brand/People/Companies files have real content and which are empty templates
   - anything from the current `CLAUDE.md` you plan to carry over into the new one
   - which skills or scripts mention the old folder names
3. Wait until the user says go.

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

If `_Brain/` already exists, add to it; never overwrite a page that's already there. If a person or company already has a page, merge the new facts into it with their citations.

For every Markdown file you move into `Archive/`, add `archived: YYYY-MM-DD` and `archived_reason: "wiki restructure: template never filled in"` (or the real reason) to its frontmatter.

Then remove any `.DS_Store` in the emptied folders and clear them with `rmdir`. `rmdir` only works on empty folders, which is the safety net. If it fails, something is still inside: stop and tell the user.

## Step 5: Create the new folders and starter files

Create these folders if they don't exist:

```
Clippings/
Clippings/assets/
wiki/sources/
wiki/entities/
wiki/concepts/
wiki/explorations/
_Brain/people/
_Brain/companies/
_Brain/concepts/
_Brain/sources/
_Brain/_pending/
_context/
Archive/
```

If a starter file below already exists, don't overwrite it: tell the user and leave it.

Create `wiki/index.md` with exactly this:

~~~~markdown
---
type: index
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Index

> The catalog of every wiki page: link, one-line summary, optional date or source count. Updated on every ingest. Read this first, every time.

## Sources

## Entities

## Concepts

## Explorations
~~~~

Create `wiki/log.md` with exactly this:

~~~~markdown
---
type: log
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Log

> Append-only. One entry per ingest, filed query or lint pass, newest at the bottom.
> Format: `## [YYYY-MM-DD] ingest | Title` (or `query |`, `lint |`, `setup |`, `archive |`), then one short paragraph.
> Last five entries: `grep "^## \[" wiki/log.md | tail -5`
~~~~

Create `wiki/overview.md` with exactly this:

~~~~markdown
---
type: overview
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: 0
---

# What the wiki knows so far

> One page, rewritten on every ingest: the current best understanding, with links to the pages behind it. Topics get added after the setup conversation.

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

**The AI never edits, renames or moves anything in this folder.** It reads clippings and writes summaries of them into `wiki/`.

To add something: clip it, then tell your AI "ingest the new clipping".
~~~~

Create `_Brain/README.md` with exactly this (skip if it exists):

~~~~markdown
---
type: folder-note
generated_by: claude-code
---

# _Brain/

The AI's filing cabinet about the user's real world: the people, companies and ideas that come up in the user's actual life and work. Every fact has a source.

- `people/`: one page per person
- `companies/`: one page per organisation
- `concepts/`: frameworks and methods the user uses
- `sources/`: raw captured material (meeting transcripts, emails), one subfolder per type
- `_pending/`: someone or something mentioned only once, waiting for a second mention

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
2. Overwrite `[VAULT]/CLAUDE.md` itself (not the link in your home folder) with the content between the markers below, with every `[VAULT]` replaced by the real path.
3. If the user agreed in Step 3 to carry anything over, add it at the end under `## Carried over from the old CLAUDE.md`.
4. Check: if Step 2 found a link, `ls -la "$(dirname "[VAULT]")/CLAUDE.md"` still shows it, and `head -1 "$(dirname "[VAULT]")/CLAUDE.md"` shows `# Vault rules`. If the link is gone or shows the old title, stop and tell the user.

===== NEW CLAUDE.md STARTS =====

~~~~markdown
{{CLAUDE}}
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
   `YYYY-MM-DD HH:MM: Restructured vault into an LLM wiki. Backup at [VAULT]-backup-YYYY-MM-DD.`
5. Remind the user to make the Obsidian settings changes from the guide (daily notes, Web Clipper folder, attachment folder, download-attachments hotkey).

## Step 10: Switch on search by meaning

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
{{SEARCH}}
~~~~

7. **Write the skill file.** If `~/.claude/skills/vault-semantic-search/SKILL.md` already exists, move it to `SKILL-previous.md` in the same folder first. Then write `SKILL.md` with exactly this, replacing `[VAULT]`:

~~~~markdown
{{SKILL}}
~~~~

8. **Test it:** `~/.claude/skills/vault-semantic-search/.venv/bin/python ~/.claude/skills/vault-semantic-search/scripts/search.py "what this vault is about" --limit 3 --vault "[VAULT]"`
   The first run downloads the small model, so it takes longer. You should see a few vault pages with scores. If you get "embedding store not found", go back to item 3.
9. **If the vault is a git repository** (`git -C "[VAULT]" status` works), make sure `.smart-env/` is in its `.gitignore`. The index is large and rebuilds itself.
10. **Record it:** add a row for `vault-semantic-search` to `tools.md` if you have one (what it does, the command above), and add one line to `Memory/daily-memory.md` if it exists.

## Step 11: Make it the user's wiki

Offer to run the setup conversation from the new `CLAUDE.md` now (section "The wiki's focus"), so the wiki fits what the user actually wants before the first clipping goes in.
