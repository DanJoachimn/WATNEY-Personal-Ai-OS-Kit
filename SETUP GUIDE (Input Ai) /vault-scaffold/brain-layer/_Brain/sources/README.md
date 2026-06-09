---
type: brain-drawer-readme
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# _Brain/sources/ — raw ingested material

The raw material the AI's compiled knowledge is built FROM: meeting transcripts, emails, call recordings. Organized by type:

```
sources/
├── meetings/    ← meeting transcripts (Granola sync target for ingestion)
├── emails/      ← email threads worth keeping as source
└── calls/       ← call recordings / transcripts
```

**Why keep raw sources separate from compiled pages:** the people/companies/concepts pages hold the *synthesized* truth (compact, current, cited). The sources/ drawer holds the *original* material those citations point back to. When a `_Brain/people/Sarah.md` fact says `[Source: meeting transcript, 2026-04-18]`, the actual transcript lives in `sources/meetings/2026-04-18 — ....md`. Compiled truth up top; raw receipts down here.

**Sources are append-only.** Never edit an ingested transcript — it's the evidence. Synthesize FROM it into the compiled pages; leave the original intact.
