---
name: session-storage
description: Indexes every conversation [AI_NAME] has had (Claude Code session transcripts) into a local SQLite database with FTS5 keyword search. Lets [AI_NAME] answer "what did we discuss about X?" against the full history of your conversations — not just what got written into the vault. Runs hourly via launchd to stay current. 100% local; nothing leaves the Mac. Trigger: "search our chats", "what did we say about X", "when did we discuss Y", or [AI_NAME] reaching for it during recall.
---

# Session Storage — searchable memory of every conversation

## Purpose (plain English)

Your vault holds what [PARTNER_NAME] *chose* to write down. But most of what you and [AI_NAME] actually talk through never makes it there — and it vanishes when the session ends. This skill fixes that.

Every Claude Code conversation is already saved as a file on the Mac (Claude Code does this automatically, at `~/.claude/projects/`). The problem: those files are scattered and hard to search. This skill pours them all into one **searchable catalog** so [AI_NAME] can find anything either of you ever said — by keyword, in under a second.

Think of it like turning a pile of loose notebooks into a library catalog. The notebooks were always there; now there's a fast way to find the right page.

## What it does

1. **Indexes** all session transcripts at `~/.claude/projects/*/*.jsonl` into a local SQLite database (`~/.claude/skills/session-storage/sessions.db`).
2. **FTS5 keyword search** over every message (FTS5 = SQLite's built-in full-text search; free, fast, ships with macOS).
3. **Runs hourly** via launchd so the catalog stays current.
4. **Idempotent** — re-running only adds new messages (keyed on each message's unique id), never duplicates.

## Privacy

100% local. The transcripts are already on the Mac (Claude Code stores them). This skill only indexes what's already there. No API, no cloud, nothing leaves the machine. This matters — it's part of why a Partner AI built this way is private by default.

## When [AI_NAME] uses it

- [PARTNER_NAME] says: "search our chats", "what did we say about X", "when did we decide Y", "find that conversation about Z"
- During recall, as a deep tier: when the vault and recent files don't have the answer, search the conversation history before giving up.

## How to build it (the operator's Claude Code session writes this)

This skill is two scripts + one scheduled job. Have your Claude Code session build them:

### 1. `scripts/ingest.py` — the indexer

- Walk every `*.jsonl` under `~/.claude/projects/`.
- Each line is a JSON object. Keep the ones where `type` is `user` or `assistant`. Skip the rest (queue-operation, system, etc.).
- For each kept message, extract: `uuid` (unique id — use as primary key so re-runs dedupe), `sessionId`, `type` (role), `timestamp`, and the text content. Content may be a plain string OR a list of parts (`text`, `tool_use`, `tool_result`) — flatten all text out of it.
- Store in SQLite with three tables: `sessions` (one row per session), `messages` (one row per message), and a `messages_fts` FTS5 virtual table (with triggers to keep it in sync) using `tokenize='porter unicode61'`.
- Use `INSERT OR IGNORE` on the message uuid so re-running is safe + incremental.
- Print a summary: files scanned, new messages, total messages, DB size.

### 2. `scripts/query.py` — the search

- Takes a query string + optional `--limit`, `--since YYYY-MM-DD`, `--json`.
- Runs an FTS5 `MATCH` query, ranked by `bm25()`, joins back to `messages` + `sessions` for context.
- Returns each hit with: timestamp, which session, role, and an FTS `snippet()` with the match highlighted.
- Default output is human-readable; `--json` for [AI_NAME] to consume.

### 3. The hourly job — `session-storage.plist.template`

Copy the included plist template to `~/Library/LaunchAgents/com.[user].[ai-name].session-storage.plist`, fill in the placeholders, and load it. It runs `ingest.py` every 3600 seconds.

> ⚠️ **Full Disk Access note:** this skill writes only to `~/.claude/` (not a protected folder), so it does NOT need Full Disk Access. But if you ever point its output at `~/Desktop`, `~/Documents`, or `~/Downloads` (macOS-protected folders), a launchd job running plain `python3` will silently fail to write there. In that case, run it via a Python binary that's been granted Full Disk Access in System Settings. (This is the #1 silent-failure trap for scheduled jobs that touch protected folders.)

## Smart-8th-grader explainer to give [PARTNER_NAME] after install

*"You know how you sometimes remember 'we talked about this weeks ago' but can't find where? I just gave [AI_NAME] a perfect memory of every conversation you two have had. Now you can ask 'what did we say about pricing last month?' and [AI_NAME] searches every chat instantly — like a search box for your own history. It all stays on your Mac; nothing goes to the cloud."*

## Edge cases
- Tool-use / tool-result messages are indexed too (searchable) but tend to be noise — fine to keep, FTS5 ranks real text higher.
- Very large transcripts are fine — FTS5 handles them.
- First run indexes everything (can be thousands of messages, takes a few seconds); later runs are near-instant.

## Companion skills
- `dreaming` / `wrap-up` — these curate what's *important* into the vault. session-storage keeps *everything* findable. Different layers: curated memory vs. total recall.
