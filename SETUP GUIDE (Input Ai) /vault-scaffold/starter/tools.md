---
type: tools-inventory
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Tools Inventory — what [AI_NAME] has access to

> Single source-of-truth list of every CLI, MCP server, and API [AI_NAME] can use. Read at the start of every session so [AI_NAME] knows what's actually wired up. **Whenever a new tool is installed, [PARTNER_NAME] says *"add this to your tools.md"* and the AI appends an entry below.**

---

## Tool selection priority — when picking a new tool

When choosing how to interact with an external service (e.g. *"how do I let [AI_NAME] access my calendar?"*), prefer in this order:

1. **CLI** — a command-line tool installed locally (`gcal`, `gh`, `op`, `postiz`). Fastest, lowest context overhead, no token bloat. Best when available.
2. **MCP** — a Model Context Protocol server that exposes the service to Claude. Use when no good CLI exists. Slight context cost; some MCPs bloat conversations with tool descriptions.
3. **API direct** — write a script that calls the service's REST API. Use as a last resort when neither CLI nor MCP exists. More fragile, harder to maintain.

**Why this order:** CLIs run locally, return clean text, and don't pollute the chat with tool schemas. MCPs are convenient but each connected one costs tokens upfront. APIs require Claude to write throwaway code on the fly. Pick in this order unless something specifically requires a different transport.

---

## CLIs (preferred — installed locally)

*— None yet. Add as you install. Format below. —*

<!--
### Example entry — delete this when first real entry lands

#### gh — GitHub CLI
- **Installed:** YYYY-MM-DD
- **Path:** `/opt/homebrew/bin/gh`
- **Auth:** `gh auth login` — token stored in macOS Keychain
- **What [AI_NAME] uses it for:** PR creation, issue triage, repo cloning
- **Common commands:** `gh pr create`, `gh issue list`, `gh repo clone`
- **Failure modes:** Token expires after 90 days → re-run `gh auth login`
-->

---

## MCP servers (use when no CLI exists)

*— None yet. Add as you connect. Format below. —*

<!--
### Example entry — delete this when first real entry lands

#### Granola MCP
- **Installed:** YYYY-MM-DD
- **Type:** Local (runs via `granola-mcp serve`)
- **What [AI_NAME] uses it for:** Reading meeting transcripts from Granola's local cache
- **Auth:** None (local file access)
- **Failure modes:** Granola app must be running for cache to be fresh
-->

---

## APIs (direct — use only when CLI/MCP unavailable)

*— None yet. Add as you script against. Format below. —*

<!--
### Example entry — delete this when first real entry lands

#### OpenAI API (Whisper transcription)
- **Installed:** YYYY-MM-DD
- **Endpoint:** `https://api.openai.com/v1/audio/transcriptions`
- **Auth:** `OPENAI_API_KEY` env var (in `~/.config/[ai-name]/.env`)
- **What [AI_NAME] uses it for:** Transcribing voice notes via Whisper
- **Wrapper script:** `~/[ai-name]/scripts/transcribe.sh`
- **Failure modes:** Rate limits at high concurrency; check status at status.openai.com
-->

---

## How [AI_NAME] uses this file

- **At session start:** Read this file as part of the standard import set. Know what's available before suggesting solutions.
- **When [PARTNER_NAME] asks for something new:** Check this file before assuming a capability exists. If it's not listed, propose installing the right tool (CLI > MCP > API priority above).
- **When [PARTNER_NAME] says "add this to your tools.md":** Append a new entry under the appropriate section using the format shown in the example. Bump `updated:` in frontmatter.
- **When a tool fails or gets removed:** Don't delete — strike it through (`~~entry~~`) and add a note about why and when. History matters.

## Hard rules

- **Never invent a capability.** If a tool isn't in this file, [AI_NAME] doesn't have it. Don't pretend.
- **Always update `updated:` frontmatter** when adding or modifying an entry.
- **Per-tool failure modes are mandatory.** If [AI_NAME] can't tell [PARTNER_NAME] how a tool will fail, it's not documented well enough.
