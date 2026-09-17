"""Build the second-brain guide (Obsidian LLM wiki that files itself).

Outputs:
  docs/obsidian-llm-wiki.html               the guide (one self-contained file)
  docs/obsidian-llm-wiki/setup-prompt.md    the setup prompt on its own

Sources (this folder unless noted):
  vault-rules.md          the CLAUDE.md the setup prompt installs in the vault
  setup-prompt.src.md     the setup prompt, with {{CLAUDE}}, {{SEARCH}}, {{SKILL}} slots
  template.html           the page, with {{DIAGRAM}}, {{PROMPT}}, {{CLAUDE}}, {{MARKED}} slots
  diagram-light.png, diagram-dark.png   stills of ../obsidian-llm-wiki.workflow.html (archify)
  marked.min.js           markdown renderer for the rules section (MIT, marked v12.0.2)
  ../../setup-guide/skill-templates/vault-semantic-search/scripts/search.py

Run: python3 docs/obsidian-llm-wiki/build.py
"""
import base64
import html
from pathlib import Path

here = Path(__file__).resolve().parent
docs = here.parent
kit = docs.parent

claude = (here / "vault-rules.md").read_text()
search = (kit / "setup-guide/skill-templates/vault-semantic-search/scripts/search.py").read_text().rstrip()
search_cmd = ("~/.claude/skills/vault-semantic-search/.venv/bin/python "
              "~/.claude/skills/vault-semantic-search/scripts/search.py")
skill = f"""---
name: vault-semantic-search
description: Search the vault by MEANING, not just keywords, using the Smart Connections plugin's local index. Use when grep or wiki/index.md misses related pages, when checking for duplicate wiki pages during ingest or lint, or when the user asks "have I read anything about X?".
---

# Vault semantic search

```
{search_cmd} "query" --limit 8 --vault "[VAULT]"
```

Add `--json` for machine-readable output. Needs the Smart Connections plugin installed and indexed in Obsidian. Fully local. Rules for when to use it are in the vault's `CLAUDE.md`, section "Search by meaning"."""

prompt = (here / "setup-prompt.src.md").read_text()
for slot, value in {"{{CLAUDE}}": claude.rstrip(), "{{SEARCH}}": search, "{{SKILL}}": skill}.items():
    assert prompt.count(slot) == 1, f"expected one {slot} in setup-prompt.src.md"
    prompt = prompt.replace(slot, value)
(here / "setup-prompt.md").write_text(prompt)


def data_uri(name):
    return "data:image/png;base64," + base64.b64encode((here / name).read_bytes()).decode()


diagram = f"""<figure class="diagram">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="{data_uri('diagram-dark.png')}">
      <img src="{data_uri('diagram-light.png')}" alt="Diagram: you clip articles into Clippings and work with your AI in chats. Every night your AI files new clippings and what mattered in your chats into linked brain pages, cited, logged and undoable, which feed the overview. You ask a question; your AI reads the overview first and answers with links; good answers are saved as pages.">
    </picture>
    <figcaption>You clip and work; it files every night; you ask; good answers become pages too. The interactive version, with guided views, is <code>docs/obsidian-llm-wiki.workflow.html</code> in the kit.</figcaption>
  </figure>"""

page = (here / "template.html").read_text()
for slot, value in {
    "{{DIAGRAM}}": diagram,
    "{{PROMPT}}": html.escape(prompt, quote=False),
    "{{CLAUDE}}": html.escape(claude, quote=False),
    "{{MARKED}}": (here / "marked.min.js").read_text(),
}.items():
    assert page.count(slot) == 1, f"expected one {slot} in template.html"
    page = page.replace(slot, value)
(docs / "obsidian-llm-wiki.html").write_text(page)
print(f"built docs/obsidian-llm-wiki.html ({len(page):,} chars) and setup-prompt.md ({len(prompt):,} chars)")
