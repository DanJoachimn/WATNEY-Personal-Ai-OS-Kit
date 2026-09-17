# Obsidian LLM wiki: sources

These files build [`../obsidian-llm-wiki.html`](../obsidian-llm-wiki.html), the guide to turning the vault into an LLM wiki.

| File | What it is |
|---|---|
| `vault-rules.md` | The `CLAUDE.md` the setup prompt installs at the root of the vault |
| `setup-prompt.src.md` | The setup prompt, with slots for the rules, the search script and its skill file |
| `setup-prompt.md` | The finished setup prompt (built). Part 2, Stage 3.9 reads this one. |
| `template.html` | The guide page, with slots |
| `diagram-light.png`, `diagram-dark.png` | Stills of [`../obsidian-llm-wiki.workflow.html`](../obsidian-llm-wiki.workflow.html), the interactive archify diagram (source: `../obsidian-llm-wiki.workflow.json`) |
| `marked.min.js` | Renders the rules on the page. marked v12.0.2, MIT licence. |
| `build.py` | Builds the guide and `setup-prompt.md` |

The search script lives with its skill: `setup-guide/skill-templates/vault-semantic-search/scripts/search.py`.

After changing any source, rebuild:

```bash
python3 docs/obsidian-llm-wiki/build.py
```

If you change the diagram, re-render it with archify (`deliver workflow ... --quality showcase`), then replace the two PNG stills.
