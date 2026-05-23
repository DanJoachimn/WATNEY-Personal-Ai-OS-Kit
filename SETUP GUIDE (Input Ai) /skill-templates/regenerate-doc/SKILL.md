---
name: regenerate-doc
description: Regenerate a stale or improving artifact (kit docs, content series, internal references) from accumulated source material (friction logs, vault content, recent learnings, conversation transcripts). Use when [PARTNER_NAME] says "regenerate [doc]", "refresh [doc]", "rebuild [doc] from scratch using everything we've learned since", or when a doc is more than 30 days old and has had significant upstream changes (new install findings, new conversations, new patterns). The pattern from YC's 2026 thinking: software/docs are ephemeral; source material + comprehension is permanent. Regenerate the artifact when models get smarter or when enough new material has accumulated.
---

# Regenerate-Doc Skill

## Purpose

Some artifacts in your stack should NOT be hand-maintained forever:

- The kit's `INSTALL.md` — gets better as friction logs accumulate
- The kit's `Common Failures` sections in each skill — gets better as installs surface new failure modes
- The kit's `README.md` positioning — gets better as the kit's identity sharpens through real conversations
- Newsletter back-issues' indexes / round-up posts
- The User Manual (YC's example) — regenerated from accumulated office-hours transcripts
- Per-tool `/tools/[tool].md` compressed docs — regenerated from actual usage patterns

This skill takes an artifact + its sources + an updated regeneration prompt, and produces a fresh version. [PARTNER_NAME] reviews, approves or edits, the new version replaces the old.

## What this is — and isn't

This skill regenerates DOCS, not running software. The kit's actual `setup.sh`, the skills' executable logic, anything users depend on for behavior — those stay hand-tuned. **What gets regenerated is reference material that's read by humans or by AI as context.** README files, INSTALL playbooks, Common Failures sections, tool compressed docs, user manuals, content compilations.

The reframe (from YC's "software is ephemeral, data is precious"): treat documentation as the OUTPUT of a regenerable process, not a hand-maintained artifact. Source material (friction logs, vault content, conversations) is the durable layer. Docs are the rendered view.

## How it works

### Step 1 — Identify the artifact to regenerate

[PARTNER_NAME] specifies one of:

- A kit doc: `INSTALL.md`, `README.md`, `INSTALL-PART-2.md`, a specific skill's `SKILL.md`
- A vault doc: a Project file, a `_Brain/` entity page, a context doc
- A content artifact: a newsletter back-issue index, a quarterly recap, a "what's new in WATNEY" post

### Step 2 — Identify the sources

For each artifact, the sources are the durable upstream material. Examples:

| Artifact | Sources to read |
|---|---|
| `INSTALL.md` | All `~/Desktop/Claude's Office/*-install-friction-log.md` files, `Common Failures` notes in skills, recent install-related daily-log entries |
| Skill `SKILL.md` | The skill's own `learnings.md`, recent monitoring-agent patterns, friction-log entries naming this skill |
| `README.md` | The kit's recent commit history (what shipped + why), accumulated install testimonials, recent AGT posts about the kit |
| `_Brain/people/[name].md` | All daily logs + meeting notes + conversations mentioning the person since the page was last updated |
| AGT quarterly recap | The last 12 weekly AGT issues + the kit's commit log for that quarter |
| `/tools/[tool].md` | Recent skill files using the tool, friction-log entries naming the tool, the tool's own --help output |

Sources are listed in this skill's `learnings.md` as defaults per artifact type. New artifact → [PARTNER_NAME] specifies sources on the first regenerate; the mapping gets saved for future regenerations.

### Step 3 — Read everything

Load the current artifact + all sources into context. Yes this is a heavy read; that's the point. The regenerated artifact is only as good as the source material the agent saw.

If the source set is too large for one session (e.g., 12 newsletter back-issues), summarize each source first into a 1-page synthesis, then regenerate from the summaries.

### Step 4 — Regenerate

Produce the fresh artifact. Same structure as the current version unless [PARTNER_NAME] explicitly asked for structural changes. Updates should:

- Pull in concrete examples from the sources (real install names, real friction patterns, real testimonials)
- Drop content that's been superseded by newer source material
- Sharpen language based on more current voice (read recent AGT issues if the artifact has voice constraints)
- Preserve [PARTNER_NAME]'s tunings — anything in the current version that doesn't directly contradict source material is presumed intentional and kept

### Step 5 — Present the diff, get approval

```
Regeneration of [artifact] complete.

Old version: [path] (X lines, last updated YYYY-MM-DD)
New version: drafted (Y lines)

Major changes:
- [bullet 1]
- [bullet 2]
- [bullet 3]

Sections preserved unchanged: [N of total]
Sections rewritten: [N]
New sections: [N]
Removed sections: [N]

Want to see the full diff, or just ship it?
```

If [PARTNER_NAME] wants the diff → show side-by-side or unified diff. If they approve → write the new version, backup the old to `[path].pre-regen-YYYY-MM-DD`, log the regeneration event.

### Step 6 — Log the regeneration

Append to `~/Documents/[AI_NAME]/logs/regenerations.log`:

```
2026-05-18 14:23 — INSTALL.md regenerated from 4 friction logs + 2 install-helper-Claude transcripts. Major changes: Stage 3 (backup), Stage 0c (anti-ai-writing positioning), Stage 6 (FFmpeg). Backup at INSTALL.md.pre-regen-2026-05-18.
```

The log is what makes regenerations safe — every regeneration is reversible.

---

## Hard rules

- **Never regenerate without [PARTNER_NAME]'s explicit ask.** This skill is heavy (large reads, large writes) and should not auto-fire.
- **Always back up the old version before writing the new one.** Format: `[original-path].pre-regen-YYYY-MM-DD`. Never delete the backup.
- **Always show major changes before showing the full new version.** [PARTNER_NAME] needs to see the shape of what's changing before drowning in the diff.
- **Preserve [PARTNER_NAME]'s explicit tunings.** Any line in the current version that came from [PARTNER_NAME]'s direct correction (per the affected skill's `learnings.md`) stays unless source material directly contradicts.
- **Never regenerate user-shipped kit files (setup.sh, executable scripts, plist templates) without separate explicit confirmation.** These are software, not docs. Different skill, different approval gate.
- **Source material is the source of truth — but [PARTNER_NAME]'s voice is the constraint.** Read recent AGT issues or vault voice guide before regenerating any artifact with voice considerations. Use anti-ai-writing skill on the output.

---

## Example invocations

### Invocation 1 — refresh kit INSTALL.md after a real install

> [PARTNER_NAME]: *"Regenerate INSTALL.md using everything we learned from Julie's install."*

This skill:
1. Reads current `INSTALL.md`
2. Reads `~/Desktop/Claude's Office/julie-install-friction-log.md`
3. Reads any newer skill `Common Failures` sections
4. Reads the kit's last 2 weeks of commits to understand what shipped
5. Drafts new `INSTALL.md` integrating the 4 Install #1 findings cleanly (FFmpeg, TCC/launchd, CLI auth workaround, backup story)
6. Surfaces diff for approval

### Invocation 2 — regenerate /tools/gh.md

> [PARTNER_NAME]: *"Refresh tools/gh.md — I've been using gh more, the docs probably don't match my actual usage."*

This skill:
1. Reads current `vault/tools/gh.md`
2. Greps for `gh` usage across recent daily logs + skill files
3. Identifies actual command patterns [PARTNER_NAME] uses (which subcommands, which flags, which fail modes)
4. Drafts new `gh.md` with [PARTNER_NAME]'s actual usage as the primary examples, generic reference as secondary
5. Surfaces diff

### Invocation 3 — quarterly AGT recap

> [PARTNER_NAME]: *"Regenerate this quarter's recap. Use the last 12 weeks of newsletter issues."*

This skill:
1. Reads the last 12 AGT issues
2. Reads kit's commit log for the same period
3. Reads recent install-related entries
4. Drafts a recap post that identifies through-lines (e.g., *"this quarter the kit went from individual to two-product, picked up X installs, surfaced Y architectural findings"*)
5. Runs through anti-ai-writing skill before surfacing
6. Surfaces draft for [PARTNER_NAME]'s edit

---

## Three-scenario test (production-grade standard)

### Scenario 1 — Happy path

**Test input:** [PARTNER_NAME] asks to regenerate `INSTALL.md`. Friction logs from 3 installs + recent commits exist. Current version is ~6 weeks old.

**Expected output:** New `INSTALL.md` that incorporates the friction logs' findings, drops superseded sections, preserves intentional structure, ~10-20% size delta (not radical restructure). Diff surfaces 4-6 substantive changes. Backup saved. Regeneration logged.

**Pass criteria:** [PARTNER_NAME] approves with at most minor edits. The new version is genuinely better than the old one (catches things the manual maintenance had missed). No data loss from the old version that wasn't deliberately removed.

### Scenario 2 — Edge case

**Test input:** [PARTNER_NAME] asks to regenerate a doc that's been recently hand-tuned ([PARTNER_NAME] made specific edits 3 days ago that aren't captured in any source). The regeneration would overwrite those tunings.

**Expected output:** Skill detects recent manual edits (via git history or file mtime check). Surfaces warning: *"this doc was hand-edited 3 days ago in ways that aren't in the source material. Regenerating would overwrite those edits. Want to (a) proceed anyway, (b) feed me the recent edits as additional source, or (c) cancel?"* Waits for choice.

**Pass criteria:** No silent destruction of recent manual work. Recovery path is offered.

### Scenario 3 — Stress test

**Test input:** [PARTNER_NAME] asks to regenerate a large artifact (5000+ line skill doc) from a large source set (8 friction logs + 12 newsletter issues + 30 daily logs). Too much to fit cleanly in one context window.

**Expected output:** Skill chunks the source set: summarizes each source down to a 1-page synthesis, then regenerates the artifact from the summaries. Notes in the log: *"sources summarized to fit context budget; full source files preserved at their original paths."* The regeneration is slower but still produces a coherent output.

**Pass criteria:** Doesn't error out on context overflow. Doesn't silently truncate sources. Doesn't produce a regeneration that misses content because half the sources were dropped.

### Marking production-grade

Once all three pass:

```yaml
production_grade: true
last_qa: YYYY-MM-DD
```

---

## Cross-skill interactions

- **Wrap-up** — wrap-up's `learnings.md` updates are inputs to regenerate-doc. When regenerating a SKILL.md, read the skill's learnings.md first to incorporate accumulated tunings.
- **Monitoring-agent** — monitoring-agent's `patterns-log.md` is another input. Sub-threshold patterns that haven't triggered individual SKILL.md fixes can show up as themes in regenerations.
- **Anti-ai-writing** — run all regenerated voice-sensitive artifacts (READMEs, AGT posts, kit copy) through anti-ai-writing before surfacing.
- **Update** — when the kit's repo gets regenerated docs, propagate via `/update` to installed users (with their explicit approval per existing update gates).

---

*Inspired by YC's 2026 framing: software/docs are ephemeral, source material + comprehension are permanent. The kit's docs become artifacts that can be regenerated as accumulated learning surfaces, not hand-maintained forever. Last updated: 2026-05-18.*
