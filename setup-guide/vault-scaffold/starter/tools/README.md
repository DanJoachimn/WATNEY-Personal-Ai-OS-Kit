---
type: tools-cache-readme
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# tools/ folder — compressed per-tool reference cache

> One `.md` per tool [AI_NAME] has access to. Lives next to `tools.md` (the inventory). The inventory is *"do I have this?"* — these files are *"how do I actually use this in [PARTNER_NAME]'s stack?"*

---

## What's here

For every CLI, MCP server, or API listed in `tools.md`, there's a corresponding file in this folder with the same base name:

```
~/[ai-name]/vault/
├── tools.md                 ← inventory (read every session)
└── tools/                   ← compressed docs (read on-demand)
    ├── README.md            ← this file
    ├── gh.md
    ├── obsidian-cli.md
    ├── genmedia.md
    ├── ffmpeg.md
    ├── elevenlabs-mcp.md
    └── ...
```

## What each tool file should contain

Compressed reference, not full docs. The goal: when [AI_NAME] is about to use this tool, the file gives it everything it needs in 100-300 lines, instead of needing to search the web or guess from training data that may be outdated.

Required sections per tool file:

```markdown
# [tool name]

## What it is
[1-2 sentence description]

## Auth + setup
[How [PARTNER_NAME] configured this tool — paths, env vars, credentials location]

## The commands [PARTNER_NAME] actually uses
[The 5-15 commands [PARTNER_NAME] runs most. Real examples, not generic docs.
Include exact flags [PARTNER_NAME] prefers.]

## Failure modes [PARTNER_NAME] has hit
[Specific errors + how they got fixed. Append-only — every new failure adds an entry.]

## When to use [TOOL_NAME] vs alternatives
[If there's a similar CLI/MCP/API, when does [PARTNER_NAME] reach for this one
specifically? E.g., "use gh for repo work; use git directly for branch surgery."]

## Upstream
[Link to official docs in case the AI needs to look something up beyond what's
captured here.]
```

## How files get created

Three ways:

### 1. Automatic — setup.sh's stage_deps (for kit-installed tools)

When `setup.sh` installs a tool (currently `ffmpeg`, `brew`, future additions), it auto-creates a starter `tools/[name].md` with the template above. The file is mostly placeholders — [AI_NAME] fills it in over time as [PARTNER_NAME] actually uses the tool.

### 2. Semi-automatic — wrap-up skill (for tools that emerge from use)

When the wrap-up skill detects that a new tool was used during the session (e.g., [PARTNER_NAME] said *"add yt-dlp to my tools.md"* or [AI_NAME] called a new MCP server for the first time), wrap-up:

- Adds the row to `tools.md`
- Drafts a starter `tools/[name].md` populated with what was used in the session
- Surfaces for [PARTNER_NAME]'s approval before writing

### 3. Manual — [PARTNER_NAME] says *"compress the docs for [tool] into tools/"*

[PARTNER_NAME] can ask [AI_NAME] to read official docs for a tool and produce a compressed `tools/[name].md`. The AI fetches docs, summarizes into the template structure, surfaces for approval.

## Why we have this folder

Without per-tool compressed docs:
- [AI_NAME] guesses at flags / commands based on training data (often outdated for newer tools)
- Common-failure patterns get rediscovered every time
- [PARTNER_NAME]'s specific configuration (paths, env vars, preferred flags) lives only in [PARTNER_NAME]'s head

With per-tool compressed docs:
- [AI_NAME] reads `tools/[name].md` on-demand when it's about to use the tool
- Failure modes [PARTNER_NAME] has already solved don't recur
- The tool reference is [PARTNER_NAME]-specific, not generic
- Future installs of the same tool by other users have a starting point (when [PARTNER_NAME] shares back via PR or kit update)

## Hard rules

- **One file per tool. Use the tool name as the filename** (lowercase, hyphens for spaces — `obsidian-cli.md` not `Obsidian CLI.md`).
- **Append, don't rewrite, the failure modes section.** Historical failures are reference; only the active fix section changes.
- **Real examples from [PARTNER_NAME]'s usage, not generic docs.** Generic docs go at the bottom under "Upstream" as a fallback.
- **Update when behavior changes** (new flag preference, new failure mode, new auth method). The wrap-up skill nudges if a tool's file hasn't been touched in 90 days.
- **No secrets.** API keys, tokens, passwords belong in `~/.config/[ai-name]/.env` or 1Password — never in `tools/`.

## Inspired by

YC's framing in 2026 of "make everything legible to AI" — a tool that's listed in inventory but has no usage notes is only half-legible. The `/tools/` folder closes the gap between *"does the AI know this exists"* and *"does the AI know how to use this well."*

Also inspired by Nate Herk's tools.md + tools/ pattern (the surfacing question that prompted adding this layer to the kit, 2026-05-18).
