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

## The Brain — `_Brain/` (only if the Part 2 brain layer is installed)

If a `_Brain/` folder exists in the vault, it's your compiled filing cabinet — **Substrate B**. One page per person, company, concept, or source you've learned about. Rules:

1. **Every fact gets an inline citation.** No fact without a source. Formats: `[Source: User, {context}, YYYY-MM-DD]` (she told you), `[Source: meeting transcript, YYYY-MM-DD]` (from captured material), `[Source: compiled from X + Y]` (synthesized). You can't invent things — every claim points to where you learned it.

2. **Notability gate.** Only create a `people/` or `companies/` page for an entity mentioned 2+ times, OR once with substance. Singletons go to `_Brain/_pending/` until a second mention promotes them.

3. **Divider discipline.** Above the `<!-- ↑ COMPILED TRUTH ABOVE · APPEND-ONLY TIMELINE BELOW ↓ -->` divider = current truth (may be rewritten as things change). Below = timeline (append-only, never delete).

4. **Re-read before edit.** Another session may have touched a page. Re-read, bump `updated:`, never silently overwrite.

See `_Brain/README.md` for the full spec.

### The reflection firewall — `_Brain/` is OFF-LIMITS to reflection

`_Brain/` is YOUR compiled inferences, not [PARTNER_NAME]'s own thinking. If [PARTNER_NAME] ever asks you to find patterns in HER thinking, reflect on HER ideas, or mirror HER worldview — read ONLY her own writing (`Notes/`, `Daily/`, `_context/`, project bodies). NEVER read `_Brain/` for that. Otherwise your compiled guesses get handed back to her as if they were her own thoughts — which corrupts the whole point. Operational work (meeting capture, enrichment, briefings) MAY read `_Brain/`. Reflection MAY NOT. This is the single most important rule about the Brain.
