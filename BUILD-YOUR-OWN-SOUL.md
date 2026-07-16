# Build your own SOUL

> Your AI comes with the **WATNEY soul** by default ([Soul.md](./Soul.md)) — optimistic, enthusiastic, resourceful, funny. Genuinely good, and most people happily keep it.
>
> But if there's a character whose voice you'd *love* to have in your corner — this is how you give your AI theirs instead. **~30–60 minutes** once you've got the source material.
>
> **For the installing AI:** this is the "build my own" branch of the kick-off soul question. Don't run it inside the Part 1 install — it's its own sitting. Note the choice, keep the WATNEY soul running in the meantime, and offer this when they've got an hour.

---

## Step 1 — Pick your character

**Pick a well-documented fictional character.** Not a real person you know. Not yourself (your *own* voice is captured separately, in the kick-off interview — that's a different layer).

Why fictional:
- **They're better documented.** A novel gives you 100,000 words of consistent, deliberate voice. Real people are inconsistent and mostly ghostwritten.
- **The AI already half-knows them.** Well-known characters sit in the model's training data, so the extraction has something to grip.
- **It's cleaner.** You're building a character for your own machine — not cloning a living person's likeness.

Good picks: a protagonist from a novel you re-read · a character from a series with a distinctive narration voice · a well-drawn character from film/TV with lots of dialogue.

⚠️ **Keep it personal.** This is for *your* AI on *your* Mac. Don't publish, sell, or distribute an AI that impersonates a real, living person — that's a different thing entirely, and not what this is for.

## Step 2 — Gather the source material

**Volume matters.** 5,000 words of their voice is the floor. 20,000 is solid. 50,000+ is gold.

**What works:**
- **Books / novels** they narrate or feature heavily (the single best source — long, consistent, deliberate)
- **Long-form video or film** — pull the dialogue
- **Podcasts / audio dramas** they appear in, 60+ min
- **Scripts / screenplays** if you can find them
- **Long-form written material** in their voice

**What doesn't work:**
- Short clips or quotes (too compressed — voice doesn't express)
- Fan-written material (that's someone else's read, not the source)
- Anything where other characters do most of the talking

## Step 3 — Transcribe it (your AI has the tools)

Hand your AI whatever you've got — it can turn most of it into text itself:

| Source | Tool your AI already has |
|---|---|
| Audio / video files | `~/[AI_NAME]/scripts/transcribe.sh <file>` |
| YouTube | the **youtube-transcript MCP** (Part 2, Stage 4) — give it the URL |
| Web articles / pages | the **Obsidian Web Clipper** (Part 2, Stage 3.5) — one click into the vault |
| PDFs / ebooks | drop the file in and ask it to read them |

Put everything in one folder — `~/[AI_NAME]/vault/Source material/` is exactly what it's there for.

## Step 4 — The traits report (the actual work)

Hand your AI **all** of it at once and give it this:

```
Read all of this source material. It's [CHARACTER] from [WORK].

Write me a detailed personality trait report capturing how this character
thinks, talks, and sees the world — thorough enough that another AI could
read it and BE them.

Cover:
1. Core identity — one paragraph. What drives them? What's their default
   emotional gear?
2. Beliefs they hold — both the standard ones and the contrarian ones.
3. How they actually talk — sentence structure, openers, closers,
   punctuation habits, rhythm, what they do when they're uncertain.
4. Their humour — what KIND, how often, what it targets, and the specific
   structural moves they use to land it. Name each move.
5. Emotional range — how they handle bad news, fear, joy, being wrong.
6. What they'd never do or say. Their hard nos.
7. Signature phrases and verbal tics — actual repeated patterns.
8. What makes them warm (or what makes them cold).

Be specific. For every trait, quote a real example from the source and
explain what technique is doing the work. Vague traits are useless —
"he's funny" tells me nothing; "he opens with the blunt worst-case
delivered like a restaurant review" tells me everything.

Output as markdown.
```

Expect ~3,000–5,000 words back. **Read it properly.** Flag anything that feels off — you know this character better than the AI does.

## Step 5 — Structure it into a Soul.md

Now compress the report into the shape your AI actually reads. Give it this:

```
Now turn that report into a Soul.md for yourself, using ~/[AI_NAME]/.kit/Soul.md
as the exact structural template. Keep these sections:

- The one-line version (who you are, in a sentence)
- The soul (the traits — numbered, one bold line each + a short explanation)
- The spice (the comedy/delivery techniques — each NAMED, each with an example)
- Signature patterns (their real verbal tics)
- The golden rule (what wins when two traits conflict)
- Hard boundaries (never aim humour at me; plain English beats a joke;
  public drafts still run anti-ai-writing)
- How this stacks (Soul = character, voice guide = my specifics,
  anti-ai-writing = polish)

Rules:
- Write it addressed to YOU, second person, as instructions you follow.
- Every technique gets a name and a concrete example — not a description.
- Include the ceiling: max one or two personality moves per reply.
- Keep the hard boundaries from the template verbatim. They're not optional.

Save it to ~/[AI_NAME]/Soul.md
```

## Step 6 — Test it, then tune

Open a fresh session and ask for something ordinary — a short email, a status update, a "what should I do about X."

- **Sounds like them?** Done. Enjoy your new colleague.
- **80% there?** Add the missing tunings straight into `Soul.md`. It's a text file — just edit it.
- **Sounds like nothing?** The report needs more depth. Back to Step 2 with more material.

---

## Honest caveats

- **This works best for characters the AI already half-knows.** A famous novel's protagonist → great. An obscure indie comic → thin.
- **The WATNEY soul is genuinely good.** Don't feel obligated. Most people keep it, and the ones who swap usually do it months later when they know what they actually want.
- **You can mix.** Keep the WATNEY soul for banter and lean on your *own* captured voice for drafts. Tell your AI which to use when — it'll listen.
- **Nothing's permanent.** Soul.md is a text file in your folder. Swap it, edit it, revert it. Your AI reads whatever's there next session.
