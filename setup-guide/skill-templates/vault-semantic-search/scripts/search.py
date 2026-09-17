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
