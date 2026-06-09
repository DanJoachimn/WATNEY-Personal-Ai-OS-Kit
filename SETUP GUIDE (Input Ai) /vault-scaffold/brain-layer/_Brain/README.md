---
type: brain-readme
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# _Brain/ — [AI_NAME]'s filing cabinet

> The AI's compiled, cited, timelined knowledge about the people, companies, concepts, and sources in [PARTNER_NAME]'s world. This is **Substrate B** — the AI's own filing cabinet. It is deliberately separate from [PARTNER_NAME]'s own reflective notes (Substrate A: `Notes/`, `_context/`, daily logs).

## The four drawers

| Drawer | One page per... |
|---|---|
| `people/` | Person referenced in the work (client, supplier, collaborator, contact) |
| `companies/` | Company [PARTNER_NAME] works with or tracks |
| `concepts/` | Framework, method, or idea that recurs in the work |
| `sources/` | Raw ingested material — meeting transcripts, emails, calls (organized by type: `sources/meetings/`, `sources/emails/`, etc.) |

Plus `_pending/` — a holding area for singletons that haven't yet earned a full page (see the notability gate below).

## Every page has the same shape

```markdown
---
type: person | company | concept | source
generated_by: claude-code
first_seen: YYYY-MM-DD
updated: YYYY-MM-DD
---

# [Title]

[COMPILED TRUTH — the current best understanding. Rewritten when evidence
changes. Every fact has an inline citation.]

<!-- ↑ COMPILED TRUTH ABOVE · APPEND-ONLY TIMELINE BELOW ↓ -->

## Timeline
- YYYY-MM-DD — [event] [Source: ...]
```

**Above the divider = compiled truth.** May be rewritten as the picture changes (she moved cities → the top updates).

**Below the divider = append-only timeline.** Never deleted, only added to. The full story of how the picture changed over time.

## The two rules that make it trustworthy

### 1. Every fact has a receipt (citation discipline)

Every single fact carries an inline citation. Three formats:

- **Direct** (something [PARTNER_NAME] told the AI): `[Source: User, {context}, YYYY-MM-DD]`
- **External** (from captured material): `[Source: Gmail thread, 2026-04-15]`, `[Source: meeting transcript, 2026-04-18]`
- **Compiled** (synthesized from multiple places): `[Source: compiled from _context/Brand Voice Guide.md + meeting 2026-04-18]`

No fact without a source. The AI can't invent things, because every claim points back to where it was learned.

### 2. Notability gate (keeps it from filling with noise)

Only create a `people/` or `companies/` page for an entity mentioned **at least twice**, OR **once with substantive content**. Singletons go to `_Brain/_pending/` as candidates — [PARTNER_NAME] can promote them manually, or they get promoted automatically on the second mention.

## How the Brain fills itself

[PARTNER_NAME] does nothing. The Brain accretes from normal work:

- **Meeting captured (Granola)** → the AI files the transcript in `sources/meetings/`, extracts the people + companies mentioned, and enriches their `_Brain/` pages with cited facts.
- **Notable person/company surfaces in a session** → the AI creates or updates their page.
- **`wrap-up` and `dreaming`** feed the Brain as part of their normal passes.

## The reflection firewall (off-limits to reflection commands)

The `_Brain/` is the AI's compiled inferences. Reflection-style commands (anything that mines [PARTNER_NAME]'s *own* thinking for patterns) must read ONLY Substrate A — never `_Brain/`. Otherwise the AI's inferences would get surfaced back to [PARTNER_NAME] as if they were her own thoughts. Operational skills (meeting capture, enrichment, morning brief) MAY read `_Brain/`. Reflection commands MAY NOT.

## Re-read before edit

Same rule as everywhere: re-read a page before writing it (another agent or session may have touched it), bump `updated:` frontmatter, never silently overwrite unfamiliar content.
