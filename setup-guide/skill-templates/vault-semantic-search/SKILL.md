---
name: vault-semantic-search
description: Search the vault by MEANING, not just keywords. Reuses the local embeddings the Smart Connections Obsidian plugin already builds — so a search for "pricing" also surfaces notes that say "revenue" or "what to charge", even when the word "pricing" never appears. Use when keyword search (grep) misses conceptually-related notes. Trigger: "find notes about X by meaning", "semantic search the vault", "what does the vault say about X".
---

# Vault Semantic Search — find notes by meaning

## Purpose (plain English)

Normal search (grep / Cmd-F) only finds the exact words you type. So if [PARTNER_NAME] searches "pricing" but the relevant note says "revenue" or "what to charge", normal search finds nothing — even though the note is exactly what they wanted.

**Semantic search finds notes by what they're ABOUT, not the exact words.** Search "pricing" → it also surfaces the "revenue" and "monetization" notes, because it understands they mean the same thing.

This matters most when [PARTNER_NAME] writes in different voices/contexts (personal vs. brand vs. client) — the same idea gets phrased five ways across the vault, and keyword search only catches one.

## The clever part: we don't build a database, we borrow one

The **Smart Connections** Obsidian plugin (free, community plugin) already reads every note and writes a local "meaning fingerprint" for each one (an embedding) to `vault/.smart-env/`. It does this on-device, privately, and keeps it updated automatically as notes change.

This skill **reuses those fingerprints.** It doesn't build or maintain its own vector database — Smart Connections did the hard part. We just add a small script that lets [AI_NAME] query the same fingerprints. One embedding store, two doors: the Obsidian UI (for [PARTNER_NAME] browsing) and this script (for [AI_NAME] during a task).

## Prerequisites

1. **Smart Connections plugin** installed + enabled in Obsidian, with embeddings built (it indexes automatically; first build takes a couple minutes). Verify it uses a **local** embedding model (Settings → Smart Connections → it ships local-first by default; confirm no cloud API key is set, so notes stay on the Mac).
2. **A small Python environment** with `sentence-transformers` and the SAME model Smart Connections uses (default: `TaylorAI/bge-micro-v2`). Install in a dedicated venv so it's self-contained:
   ```bash
   python3 -m venv ~/.claude/skills/vault-semantic-search/.venv
   ~/.claude/skills/vault-semantic-search/.venv/bin/pip install sentence-transformers
   ```

## How to build it (the operator's Claude Code session writes `scripts/search.py`)

- Take a query string + `--limit` + optional `--json`.
- Load the embedding model (`TaylorAI/bge-micro-v2` — **must match Smart Connections' model**, or query and note fingerprints won't be comparable).
- Embed the query.
- Read every note's fingerprint from `vault/.smart-env/multi/*.ajson` (each file holds a note path + one or more `"vec":[...]` arrays — take the last vector per note).
- Score each note by cosine similarity to the query.
- Return the top-N note paths, with a short preview line from each.

Pure-Python cosine similarity is fine at typical vault scale (hundreds of notes). No external service.

## When [AI_NAME] uses it

- [PARTNER_NAME] says: "find notes about X by meaning", "semantic search the vault", "what does the vault say about X", "find related to..."
- During recall: when keyword search (grep) returns nothing or too little, escalate to this before giving up. (See the recall-discipline tiers in CLAUDE.md.)
- Distinct from `session-storage` (which keyword-searches past *conversations*) — this searches the *vault notes* by meaning.

## Privacy

100% local IF Smart Connections is configured for local embeddings (its default) and the query model runs locally (it does — `sentence-transformers` on-device). Confirm Smart Connections has no cloud embedding API key set. Nothing leaves the Mac.

## Important: the model must match

Smart Connections embeds notes with one model; this script must embed queries with the **same** model, or the comparison is meaningless. Default is `TaylorAI/bge-micro-v2`. If [PARTNER_NAME] ever changes Smart Connections' embedding model in its settings, update this script's model name to match.

## Smart-8th-grader explainer to give [PARTNER_NAME] after install

*"You know how searching your notes only works if you remember the exact word you used? I gave [AI_NAME] a smarter kind of search — it finds notes by what they MEAN. Ask about 'pricing' and it'll also pull up the notes where you wrote 'revenue' or 'what to charge', because it knows those are the same idea. It piggybacks on a plugin you already have, and it all stays on your Mac."*

## Edge cases
- Smart Connections still indexing → some notes have no fingerprint yet; they're skipped. Let it finish (open Obsidian a few minutes).
- A note edited just now → Smart Connections re-embeds ~13s later; the search reflects the latest once that's done.
- `.smart-env/` should be gitignored (it's large + rebuildable) if the vault is in a git repo.
