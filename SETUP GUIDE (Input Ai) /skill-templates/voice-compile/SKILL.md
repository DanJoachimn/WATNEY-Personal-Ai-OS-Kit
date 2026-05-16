---
name: voice-compile
description: Compresses a 20k-word voice interview archive into a high-fidelity ~3-5k token <about_me> XML file optimized for AI behavioral fidelity, not human reading. Auto-invoked at the end of the kick-off skill's deluxe (100-Q) path. Manually invokable via "compile my voice" or "compress voice archive" when the user wants to refresh after editing the raw archive. The output file becomes [PARTNER_NAME]'s portable voice canon — readable by any AI (Claude, ChatGPT, Gemini, Grok) at the start of any session.
---

# Voice Compile Skill

## Purpose

The 100-question voice interview produces a ~20,000-word raw archive — too big to load into every AI session, too unstructured for the AI to apply consistently. **This skill compresses it.**

The compressed file (`about-me.md`) is:
- ~2,000–5,000 tokens (target 3,000)
- XML-structured for clear AI parsing
- Optimized for behavioral fidelity per token
- Portable across Claude / ChatGPT / Gemini / Grok / future models
- Editable in Obsidian by [PARTNER_NAME] over time

## When to use

### Auto-trigger (the default)

Invoked automatically by the **kick-off skill** at the end of the B-Deluxe path, immediately after question 100 of the voice interview. The kick-off skill chains directly into this one.

### Manual triggers

[PARTNER_NAME] says any of:
- "compile my voice"
- "compress voice archive"
- "rebuild my about-me file"
- "refresh my voice file"

Useful when:
- They've edited the raw archive (`voice-archive.md`) in Obsidian and want to regenerate the compressed file
- The about-me file feels stale and they want to recompile from the raw answers
- After a yearly voice refresh interview (the wrap-up skill nudges this once `.voice-interview-date` ages past 365 days)

## Inputs

- **Required:** `~/Documents/[ai-name]/vault/Voice/voice-archive.md` (the raw 100-Q interview transcript with verbatim Q&A pairs)
- **Optional:** any extra context [PARTNER_NAME] wants you to consider (recent posts, brand canon files, etc.)

## The compression prompt (run verbatim)

After reading the voice-archive.md file, run this exact prompt against its content:

```
You are a Voice Compiler.

You will turn the raw voice archive above into a compact, high-fidelity about-me .md file for an AI to use as standing context.

This file is not for humans. It is for Claude, ChatGPT, Gemini, or another AI to read at the start of future sessions.

Your job is not to summarize. Your job is to preserve the smallest set of instructions, examples, phrases, laws, refusals, and taste signals that will make an AI write, judge, edit, and decide more like the user.

Core rule:
Every line must pass this test:
"If this line disappeared, would the AI write, edit, judge, refuse, structure, or decide differently?"
If yes, keep it. If no, cut it.

Optimize for maximum behavioral fidelity per token.

Target length:
- Usually 2,000 to 4,000 tokens
- Hard ceiling: 5,000 tokens
- Shorter is fine if the archive is thin
- Longer is fine only when every line is high-signal
- Do not pad
- Do not cut useful specificity just to look minimal

Keep:
- specific voice laws
- specific writing laws
- specific communication laws
- hard refusals
- compact BAD / GOOD examples
- verbatim phrases that teach the AI how the user sounds
- words they use
- words they hate
- sentence shapes
- taste loves
- taste disgusts
- decision rules
- tiny tells
- productive contradictions
- identity details that affect voice or judgment

Cut:
- generic values
- flattering self-description
- biography that does not affect output
- aspirations not backed by evidence
- repeated ideas that add no new instruction
- vague preferences
- long transcript excerpts
- quotes that are verbatim but not useful
- anything that sounds like a personal bio
- anything included only because it is true

Use XML-style structure. No markdown essay. No prose transitions. No motivational ending. No commentary before or after the file.

Output only this:

<about_me>

<usage>
Explain in 3 compact lines how the AI should use this file.
</usage>

<priority>
1. Current user instructions override this file.
2. Truth, safety, and task requirements override style imitation.
3. Hard refusals override ordinary preferences.
4. Specific examples override abstract rules.
5. Evidence-backed rules override inferred rules.
6. When rules conflict, preserve deeper judgment over surface style.
</priority>

<identity_context>
Only identity details that affect voice, taste, metaphors, judgment, or recurring concerns.
</identity_context>

<voice_fingerprint>
Describe the voice operationally: rhythm, density, directness, humor, emotional temperature, formality, weirdness, default stance.
No generic adjectives unless attached to observable behavior.
</voice_fingerprint>

<writing_laws>
Use compact rules.

Format:
<law>Do: [specific instruction]. Avoid: [specific failure]. Example: [optional compact example].</law>
</writing_laws>

<communication_laws>
Rules for emails, texts, replies, requests, disagreement, praise, critique, reminders, apologies, refusals.
</communication_laws>

<hard_refusals>
Things the AI should never write, say, imply, fake, praise, or do.

Format:
<never>Never [specific thing]. Bad: "[bad example]". Use: "[better version]".</never>
</hard_refusals>

<taste_loves>
Specific things the user loves, admires, trusts, or gravitates toward.
Include why only when it changes future output.
</taste_loves>

<taste_disgusts>
Specific things they hate, distrust, cringe at, or reject.
Include words, tropes, styles, arguments, postures, formats.
</taste_disgusts>

<phrase_bank>
<use>
Words, phrases, metaphors, sentence shapes, jokes, transitions, moves that sound like them.
</use>

<avoid>
Words, phrases, structures, tones, tropes, transitions, claims that do not sound like them.
</avoid>
</phrase_bank>

<signature_tells>
Small recurring details that make them recognizable.
Only include tells that can guide future writing, editing, or judgment.
</signature_tells>

<decision_rules>
How they judge quality, usefulness, honesty, beauty, risk, trust, competence, status, bullshit, and whether something is worth saying.
</decision_rules>

<productive_contradictions>
Tensions to preserve instead of smoothing out.

Format:
<tension>[tension]. Preserve by: [operational instruction].</tension>
</productive_contradictions>

<golden_examples>
Include 3-6 examples only. Each should teach a high-value pattern.

Format:
<example>
<context>[when this applies]</context>
<bad>[sentence that does not sound like them]</bad>
<good>[sentence that sounds more like them]</good>
<why>[short explanation]</why>
</example>
</golden_examples>

<do_not_infer>
Things the AI should not assume from this profile.
</do_not_infer>

<final_instruction>
One compact instruction telling the AI to apply this profile silently unless overridden.
</final_instruction>

</about_me>

Before outputting, silently audit:
- Cut generic lines
- Cut flattering lines
- Cut weak biography
- Cut low-evidence claims
- Cut quotes that do not change output
- Preserve specific examples
- Preserve negative constraints
- Preserve positive taste
- Preserve decision rules
- Preserve useful contradictions
- Stay under 5,000 tokens

Now compile the final about-me .md.
```

## Where to save the output

```bash
~/Documents/[ai-name]/vault/Voice/about-me.md
```

If the file already exists, **don't silently overwrite** — show [PARTNER_NAME] the new compressed version, ask for confirmation, then write. The about-me file is precious; preserve old versions:

```bash
# Before writing the new version, archive the previous one (if exists):
if [ -f ~/Documents/[ai-name]/vault/Voice/about-me.md ]; then
    mkdir -p ~/Documents/[ai-name]/vault/Voice/_versions
    cp ~/Documents/[ai-name]/vault/Voice/about-me.md \
       ~/Documents/[ai-name]/vault/Voice/_versions/about-me-$(date +%Y-%m-%d).md
fi
```

## Tell the AI to actually use the file

After writing `about-me.md`, update [AI_NAME]'s root `CLAUDE.md` to `@`-import it:

```markdown
@~/Documents/[ai-name]/vault/Voice/about-me.md
```

This makes the file load on every Claude Code session start. For other AIs (ChatGPT projects, Gemini gems, etc.), [PARTNER_NAME] uploads it as a project document.

## Hard rules

- **Never compile without reading the source archive first.** The compression must be grounded in actual answers, not invented patterns.
- **Never inflate to hit a token target.** If the source is thin, the output is thin. Honest > pretty.
- **Never ship without verification.** After compiling, instruct [PARTNER_NAME] to test in a fresh AI session — paste the file, ask for a sample draft, confirm it sounds like them. If not, iterate.
- **Always archive previous versions** to `_versions/` before overwriting.
- **The archive is the source of truth, not the compressed file.** If [PARTNER_NAME] wants a structural change, they edit the archive (or run a fresh interview), then recompile. Don't edit the compressed file directly to "fix" the voice — that disconnects it from the archive.

## When to refresh

The wrap-up skill watches `~/Documents/[ai-name]/.voice-interview-date`:

- **Once 365 days have passed** since the last interview, the wrap-up skill offers a yearly voice refresh: a 30-min focused interview that updates only the sections most likely to have evolved (beliefs, taste-loves/disgusts, hard nos). Then this skill recompiles.
- **If [PARTNER_NAME] notices the voice file feels stale before then**, they say "let's refresh my voice" → wrap-up skill runs the focused 30-min interview → this skill recompiles.

## Why this matters

A user's voice ISN'T just style. It's their decisions, their refusals, their taste. The compressed `about-me.md` captures all of that in a format the AI can apply automatically — without re-asking, without drift, without [PARTNER_NAME] having to remind it every session.

Without this skill: the 100-Q interview's value evaporates because the raw archive is unusable in practice.

With this skill: the interview's value compounds — the compressed file loads instantly, the AI sounds like the user from the first message of every session, and [PARTNER_NAME] can take their voice file to any AI on the planet.

---

## Three-scenario test (production-grade standard)

Run all three before marking the skill production-grade. If any fails, the failure tells you exactly what instruction to add.

### Scenario 1 — Happy path

**Test input:** A complete `~/Documents/[ai-name]/vault/Voice/voice-archive.md` with all 100 Q&A pairs from the kick-off Section B-Deluxe interview. Answers vary in length (some 1-sentence, some 3-paragraph). User's voice is consistent across the archive — no contradictions, clear taste signals.

**Expected output:** Compressed `about-me.md` ≤2 pages organized into 7 sections (beliefs, mechanics, aesthetic, tone, structure, hard nos, red flags). Every claim in the compressed file traces back to at least one Q&A in the archive (no fabrications). Direct quotes from the user appear where they capture voice most precisely — never paraphrased into generic language. File loads cleanly as context in a fresh chat and produces drafts that pass the verify-in-fresh-session test.

**Pass criteria:** Compression ratio ≥ 10:1 (archive averages 200-500 lines; compressed file ≤50 lines plus quotes). Zero fabrications. The 7-section structure is present. Direct user quotes appear in at least 5 of the 7 sections. Fresh-session test: a draft generated against this file alone sounds like the user, not generic.

### Scenario 2 — Edge case

**Test input:** A `voice-archive.md` that's only 60% complete — user bailed at Q60 of the interview. Sections like "structural preferences" and "red flags" got 1-2 answers; "beliefs" and "writing mechanics" got 10+ each.

**Expected output:** Skill compiles what's actually there. Under-populated sections explicitly say *"[PARTNER_NAME] hasn't fully answered this yet — current best read is X, refresh when more data lands."* No silently inventing answers to fill gaps. No averaging across categories. Skill suggests at the end: *"You bailed at Q60. The sections below marked [thin] would meaningfully sharpen if you ran another 20 questions sometime. Want a 15-min top-up later?"*

**Pass criteria:** No fabrication for thin sections. Honest annotation of what's missing. Recovery path offered to the user. Compressed file still useful for sections that ARE populated.

### Scenario 3 — Stress test

**Test input:** A `voice-archive.md` with internal contradictions — user said *"I never use exclamation marks"* in Q14 but Q67 has them praising punctuation maximalism. Plus: archive includes raw Whisper transcription artifacts (filler words, false starts, *"um,"* *"so basically,"* corrected re-takes). Plus: previous compiled `about-me.md` already exists from an earlier interview that the new archive should override but not silently destroy (keep a backup).

**Expected output:** Skill (a) flags the Q14/Q67 contradiction explicitly to the user in chat before writing — *"two answers disagree on exclamation marks. Which is the actual rule?"* — and waits for resolution. (b) Strips transcription artifacts during compression but preserves them in the raw archive (never edit the archive itself). (c) Renames the existing `about-me.md` to `about-me.YYYY-MM-DD-prior.md` before writing the new one — never silently overwrites. (d) Notes the prior file's existence in a one-line audit trail at the bottom of the new file.

**Pass criteria:** Contradictions surface BEFORE the file is written, not after. Archive remains immutable. Prior version is backed up with timestamp. New file's audit trail mentions the backup path. No data loss.

### Marking production-grade

Once all three scenarios pass, add to frontmatter:

```yaml
production_grade: true
last_qa: YYYY-MM-DD
```
