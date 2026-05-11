# Vault Rules — for [AI_NAME]

*This file lives at the root of [PARTNER_NAME]'s Obsidian vault. It tells her AI how to interact with the vault.*

## What's in here

- `tools.md` — **Read at session start.** Inventory of every CLI, MCP, and API [AI_NAME] has access to. If a capability isn't listed there, [AI_NAME] doesn't have it.
- `Memory/` — [AI_NAME]'s working memory layer. `daily-memory.md` accumulates 1-line entries from sessions. `long-term.md` is the synthesized state, rewritten nightly by the dreaming routine. Both are agent-writable.
- `Projects/` — one file per [BRAND] product or podcast project. You may read and append.
- `Brand/` — brand canon. **Read before drafting any [BRAND] content.** Do not edit without [PARTNER_NAME]'s explicit go-ahead.
- `Daily/` — [PARTNER_NAME]'s daily journal. You may read if she asks; **do not write** unless she explicitly invites you.
- `Meetings/` — meeting notes. Usually started by [PARTNER_NAME]; you can clean them up on request.
- `Notes/` — her catch-all. You may read and append.
- `Archive/` — old stuff, kept for reference. Read only.

## Hard rules

1. **Always read `Brand/Voice guide.md` and `Brand/Do-not-use list.md` before drafting ANY [BRAND] content.** The voice is defined here. If you skip these files, you will write baby-brand marketing-speak and [PARTNER_NAME] will have to rewrite you.

2. **Never write to `Daily/` unless [PARTNER_NAME] explicitly asks.** Her journal is hers. You can read it when she says "what did I note last Tuesday?" — but don't append.

3. **Never delete anything.** Move to `Archive/` instead. [PARTNER_NAME] can prune manually.

4. **Frontmatter on everything you create.** Format:
   ```yaml
   ---
   created: 2026-05-01
   updated: 2026-05-01
   type: project | note | meeting
   generated_by: [AI_NAME]
   ---
   ```
   Bump `updated:` on every edit.

5. **Two levels deep, max.** If you're tempted to make `Projects/[BRAND]/Products/Sling wrap/Research/`, stop. Flatten. Use tags or wikilinks instead of nested folders.

6. **Use wikilinks liberally.** `[[[BRAND] — sling wrap]]` beats `Projects/[BRAND] — sling wrap.md`. Obsidian resolves them automatically and shows backlinks.

## How to reference the vault when [PARTNER_NAME] asks questions

When [PARTNER_NAME] asks "what did we decide about X," don't guess. Search the vault:
- `Grep -r "X" ~/Documents/[BRAND]/` for content search.
- `Glob "~/Documents/[BRAND]/**/*.md"` for file lists.

When she asks for context, pull the specific file, summarise, then answer. Don't try to remember from session memory — the vault is the source of truth.

## When she edits a file you've written

She's allowed. Re-read before your next edit — she might have changed the direction. Don't silently overwrite her changes.
