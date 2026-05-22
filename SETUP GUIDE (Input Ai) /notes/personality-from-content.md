# Building a custom personality from someone's content — optional, advanced

> A workflow for users who want their AI to have a specific personality (their own, or a creator they admire) instead of the kit's default. ~30-60 minutes once you have the source material. Optional — most users will skip this and stick with the kit's default personality, which is fine.

---

## The workflow in 3 steps

### Step 1 — Collect long-form content from the personality you want to capture

The more material, the sharper the personality report. What works:

- **eBook PDFs** (their own book, or a book they wrote that captures their voice)
- **Podcast interviews** they did — long-form, ideally 60+ min each. Pull transcripts.
- **Newsletter archive** they've written (any platform — export the full archive if possible)
- **Substack posts**, **blog posts**, **long-form social posts**
- **YouTube interviews** — pull the auto-generated transcripts
- **Books they've publicly cited as influential** (less direct, but adds taste signals)

**Quality > quantity, but volume matters.** 5,000+ words of their own voice is the floor. 20,000+ is solid. 50,000+ is gold.

**What does NOT work well:**
- Short social posts (too compressed; voice doesn't fully express)
- Marketing copy (often ghostwritten; not their voice)
- Interview transcripts where the host talks more than them

### Step 2 — Ask Claude to create a personality trait report

Open Claude Code (or any Claude session). Hand it all the content collected. Then ask:

> *"Read all of this. Write me a personality trait report capturing how this person thinks, writes, and sees the world. Cover: beliefs they hold (contrarian and standard), how they actually write (sentence structure, openers, closers, punctuation habits), aesthetic crimes they cringe at, voice + tone, structural preferences, hard nos, and red flags that make them distrust content. Be specific — quote verbatim examples wherever possible. Output as a markdown report I can use to make an AI sound like this person."*

Claude will produce a structured report. ~3-5K words usually. Read it carefully — flag anything that feels off.

### Step 3 — Upload the report as your Partner AI's default personality

Save the report to your AI's personality file:

```
~/Documents/[ai-name]/vault/Voice/about-me.md
```

(Or wherever the kick-off skill placed the voice file — check `vault/Voice/`.)

Your AI now reads this file at every session start (per the kit's standard setup). From this point on, the AI's drafts adopt that personality.

**To verify:** open a fresh Claude session, paste only the `about-me.md` content, and ask the AI to draft something simple — a newsletter intro, an Instagram caption, an email. Read the output. Does it sound like the source personality? If yes, you're done. If 80% right but missing something, add the missing tunings to the file. If it sounds nothing like the source, the report needs more depth — go back to Step 1 with more content.

---

## Honest caveats

- **This works best for personalities the AI already has some training-data exposure to** (popular authors, public figures). It works less well for unknown private individuals — you're asking the AI to extract a voice it's never heard before.
- **The kit's default personality is genuinely usable.** Don't feel obligated to do this. Most users get great results from the kick-off interview's 100-Q voice path, which captures *the user's own* voice. This custom-personality workflow is for users who specifically want to channel someone else's voice for their drafts.
- **You can mix.** Capture YOUR voice via the 100-Q AND add a personality layer from a creator you admire. Tell the AI which to lean on for which kind of work ("use my voice for member messages, use [creator]'s voice for the newsletter").

---

## Why this works

LLMs are surprisingly good at extracting voice signals from large amounts of text. The "personality trait report" structure (beliefs → mechanics → aesthetic → tone → preferences → hard nos → red flags) maps to the same dimensions the kit's 100-Q voice interview captures. You're just using content as the input instead of a self-introspection interview.

---

*Filed by: Dani. Captured 2026-05-12 as part of Training Club-tier WATNEY development. Updated as users surface what works and what doesn't.*
