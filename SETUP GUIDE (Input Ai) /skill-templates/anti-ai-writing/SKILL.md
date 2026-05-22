---
name: anti-ai-writing
description: Public-output cleanup layer that fires on EVERY external-facing draft for [PARTNER_NAME]. Removes ~250 patterns that signal AI generation (em dashes, rule of three, contrast framing, copula avoidance, synonym cycling, "despite challenges" formula, banned-word list) and adds personality via the POP framework (Personal / Observational / Playful / Vignette). Reads [PARTNER_NAME]'s Brand voice guide + Do-not-use list to layer user-specific rules on top of the universal cleanup. Auto-activates on emails, posts, captions, essays, briefs, replies, social — anything [PARTNER_NAME] will publish, send, or sign their name to. Distinct from voice capture (which happens via the kick-off interview and lives in `Brand/Voice guide.md` + `Voice/about-me.md`) — THIS skill is the cleanup mechanism that applies the voice rules + universal AI-tell removal to every public draft. Combines Ruben Hassid's framework + Wikipedia's AI cleanup project + David Perell's POP framework.
---

# Anti-AI Writing Skill

This skill is the cleanup layer for anything [PARTNER_NAME] will publish, send, or sign their name to. It runs every public-facing draft through universal AI-tell removal AND [PARTNER_NAME]'s personal voice rules. Discipline is non-negotiable. If [PARTNER_NAME] later tunes the rules (adding personal banned words, relaxing one rule, etc.), updates go in `learnings.md` next to this file and the wrap-up skill folds them in.

## What this is NOT

This is **not** the voice-capture mechanism. [PARTNER_NAME]'s voice (their beliefs, taste, banned words, sentence patterns, reference brands) is captured separately via the kick-off interview — the 3-Q foundation in Part 1, the 5-Q express in Part 2, or the 100-Q deluxe later — and stored in `Brand/Voice guide.md` + (if deluxe was run) `Voice/about-me.md`.

This skill READS those voice files and APPLIES their rules. The voice files are the *signature*; this skill is the *filter that enforces the signature on every public draft + strips AI tells on top*. Two different things, both important, in a clear sequence:

1. **Voice capture** (kick-off interview) → `Brand/Voice guide.md` + `Voice/about-me.md`
2. **Anti-AI writing skill** (this file) → applies the voice rules + universal AI-tell removal on every public-facing draft

## When this fires

**Always**, when drafting:
- Emails, replies, threads
- Social posts (Twitter/X, LinkedIn, Instagram captions, Threads, Bluesky)
- Essays, blog posts, newsletter copy
- Marketing copy (landing pages, headlines, ad copy)
- Captions, subtitles, video descriptions
- Pitch decks, briefs, proposals
- Any text the user will publish, send, or sign their name to

**Skip** for:
- Internal AI reasoning (planning, debugging, tool use)
- Code (skill applies to comments and docs, not the code itself)
- Pure structural drafts where voice doesn't matter yet (outlines, bullet lists for the user to expand)
- Short factual answers (one-sentence replies to factual questions)

When in doubt, fire. The cost of accidentally applying it is small; the cost of accidentally skipping it is the user shipping a draft that sounds generated.

---

## The two-step rule

**Step 1: Remove** the specific patterns that mark text as machine-generated.
**Step 2: Add** personality — because clean text without voice still reads like a press release.

Both steps matter. You can't skip either.

---

## HARD RULES — never break these

1. **No em dashes.** Use commas, periods, or parentheses. AI uses em dashes where humans naturally use softer punctuation.
2. **No rule of three.** Don't group adjectives, nouns, or ideas into trios. Two is fine. Four is fine. Three every time is a tell.
3. **No contrast framing.** Don't write "It's not X, it's Y." Don't write the escalation version: "It's not A. It's not even B. It's actually C." This is the single most flagged AI tell on Wikipedia. Just say the thing.
4. **No staccato bursts.** Don't stack three or more short sentences for dramatic effect. Vary sentence length naturally.
5. **No rhetorical transition questions.** Cut "The catch?" "The kicker?" "So what does this mean?" "But here's the thing." Only ask questions you'd genuinely ask someone.
6. **No "nobody" dramatic opener.** "Nobody tells you this" and "Nobody talks about this" are fake intimacy.
7. **No emojis in professional writing.** (See emoji list below.)
8. **No "let's" openers.** "Let's dive in," "Let's break this down" — YouTube intro energy.
9. **No fake naming.** Don't capitalize invented frameworks: "The 5-Step Method," "The Growth Paradox." If it doesn't have a real name people already use, just describe it.
10. **No self-narration.** Don't announce or comment on your own points. Cut "this highlights," "this underscores," "here's why this matters," "the key takeaway is." If the point landed, the narration is dead weight. If it didn't, the narration won't save it.
11. **No -ing clause padding at sentence ends.** Lines that end with "...ensuring quality," "...highlighting the importance," "...reflecting broader trends" are empty analysis stapled to a real sentence. Cut after the comma.
12. **No bullet points with bold titles that just restate the bullet.** "**Scalability:** The system is designed to scale." The bold word is just the sentence repeated. Either make the explanation earn its space or cut the bold label.
13. **No excessive boldface.** Bold used to mechanically highlight key terms is an AI formatting habit. Use it sparingly and only when it genuinely aids scanning.
14. **No elegant variation (synonym cycling).** AI has a built-in repetition penalty that makes it rotate through synonyms instead of reusing a word naturally. A person's name becomes "the founder," then "the entrepreneur," then "the Acme CEO." Real humans just say the name again. If you mean Sarah, write Sarah. Don't cycle descriptors to avoid repetition.
15. **No false ranges.** AI loves "from X to Y" constructions where X and Y don't sit on any real scale. "From grassroots community building to operational excellence" has no meaningful middle ground. The test: can you name three points between X and Y without switching categories? If not, it's a false range. Cut it and just list the things.
16. **No "despite challenges" formula.** AI writes "Despite its [positive words], [subject] faces challenges..." then ends with vague optimism about future prospects. It's the rigid structure that's the tell: acknowledge good thing, pivot to challenges, resolve with hope. If you need to discuss trade-offs, don't use this skeleton.
17. **No copula avoidance.** AI systematically replaces "is" and "are" with "serves as," "stands as," "marks," "represents," "boasts," "features," "offers." One study showed a 10%+ drop in "is"/"are" usage in AI-edited text. Just use "is" and "has." The gym is a training facility, it doesn't "serve as" one.

---

## Patterns from Wikipedia's AI cleanup project

The 14 categories Wikipedia editors identified across thousands of flagged AI submissions (original 10 from July 2025, plus 4 added March 2026):

**1. Inflated symbolism — exaggerating importance.** AI connects everything to "broader themes" and "pivotal moments." Cut or rewrite: is/stands as/serves as a testament to, plays a vital/significant role, underscores its importance, leaves a lasting impact, watershed moment, key turning point, deeply rooted, profound heritage, solidifies, stands as a.

**2. Promotional tone** (especially around places, cultures, products). Reads like a travel brochure: rich cultural heritage, rich history, rich cultural tapestry, breathtaking, stunning natural beauty, must-visit, must-see, enduring legacy, lasting legacy, nestled in, vibrant, boasts.

**3. Editorializing — adding interpretation nobody asked for.** AI adds opinion and significance even when neutral tone is requested: it's important to note/remember/consider, it is worth noting, no discussion would be complete without, in this article we will.

**4. Overused conjunctive transitions.** AI leans on a tiny set of transitions to fake flow: Moreover, Furthermore, Additionally, In addition, However (as sentence opener), On the other hand, In contrast, Consequently, Accordingly, Hence, Thus, Notably, Essentially.

**5. Negative parallelism (the #1 Wikipedia AI tell).** "It's not just about X — it's about Y." This structure appears constantly in AI output and almost never in natural human writing. Variants: It's not X it's Y, Not only X but Y, He didn't just X he Y, Not X. Not even Y. Actually Z.

**6. Superficial analysis via -ing endings.** Sentences that end with vague significance claims: ...ensuring [vague outcome], ...highlighting the importance of, ...emphasizing the significance of, ...reflecting broader trends, ...demonstrating the continued relevance of.

**7. Vague attribution (weasel wording).** Attributing claims to unnamed authority: Industry reports suggest, Observers have noted, Some critics argue, Experts say. Replace with a named source or cut the claim entirely.

**8. Excessive em dash use.** Already in the hard rules. Wikipedia specifically notes AI uses em dashes in places where human writers naturally use commas or parentheses. The em dash itself isn't wrong. The frequency and placement is the tell.

**9. Bullet points with bold label + restatement.** AI default structure. The bold label is usually just the sentence in one word. Either make the explanation genuinely add to the label, or write it as prose.

**10. Significance inflation via tailing clauses.** Events and details get attached to claims about their importance: "...marking a pivotal moment in the history of...", "...reflecting the continued relevance of...", "...setting the stage for...", "...paving the way for...". These are almost always empty. Cut them.

**11. Elegant variation (synonym cycling).** AI's repetition penalty forces it to avoid reusing the same word, so it rotates through synonyms and descriptors unnaturally. A character's name becomes "the protagonist," then "the key player," then "the eponymous figure." Real writers repeat names. The variation itself is the tell.

**12. False ranges ("from X to Y" with no real scale).** AI uses "from ... to ..." constructions where the endpoints don't sit on any meaningful spectrum. Real ranges have identifiable midpoints. If you can't name the middle without switching categories entirely, the range is fake. Cut it and just list the items.

**13. "Despite challenges" formula.** AI has a rigid pattern: acknowledge good, pivot to challenges, resolve with hope. Wikipedia editors flag this as a structural tell. If you need to discuss trade-offs, break the skeleton.

**14. Copula avoidance ("serves as" instead of "is").** AI systematically avoids "is," "are," and "has" in favor of "serves as," "stands as," "marks," "represents," "boasts," "features," "offers." Use "is" and "has" when that's what you mean.

---

## Banned words and phrases

**Transition words to avoid:** Arguably, Certainly, Consequently, Hence, However (sentence opener), Indeed, Moreover, Nevertheless, Nonetheless, Thus, Undoubtedly, Accordingly, Additionally, Furthermore, Notably, Essentially, Fundamentally, Inherently, Particularly (sentence opener)

**Adjectives AI overuses:** Adept, Commendable, Compelling, Comprehensive, Crucial, Cutting-edge, Dynamic, Efficient, Ever-evolving, Exciting, Exemplary, Game-changing, Genuine, Groundbreaking, Holistic, Innovative, Invaluable, Meticulous, Multifaceted, Noteworthy, Nuanced, Paramount, Pivotal, Profound, Remarkable, Robust, Scalable, Seamless, Significant, State-of-the-art, Streamlined, Substantial, Synergistic, Tailored, Thought-provoking, Transformative, Unprecedented, Vibrant, Vital

**Adverbs AI overuses:** Drastically, Genuinely, Meticulously, Notably, Profoundly, Remarkably, Significantly, Strategically, Substantially, Truly

**Abstract nouns that signal AI:** Bandwidth (figurative), Bedrock, Cadence, Catalyst, Cornerstone, Deep dive, Ecosystem (figurative), Efficiency, Framework (when vague), Game-changer, Guardrails (figurative), Headwinds/Tailwinds (figurative), Implementation, Innovation, Institution, Integration, Interplay, Intersection (figurative), Intricacies, Juxtaposition, Landscape (figurative), Linchpin, North star (figurative), Optimization, Pain point, Paradigm, Paradigm shift, Realm, Synergy, Takeaway, Key takeaway, Tapestry (figurative), Transformation

**Verbs AI defaults to:** Aligns, Amplify, Augment, Bolster, Catalyze, Craft (figurative), Cultivate, Curate, Delve, Demystify, Dive in, Double down, Elevate, Embark, Empower, Enhance, Facilitate, Foster, Garner, Harness, Leverage, Maximize, Navigate (figurative), Reimagine, Resonate, Revolutionize, Showcase, Spearhead, Streamline, Underscore, Unlock (figurative), Unpack (figurative), Utilize

**Phrases to delete entirely:** "A testament to...", "In conclusion...", "In summary...", "It's important to note...", "It's worth noting that...", "At its core...", "In today's [rapidly evolving] landscape...", "At the end of the day...", "Moving forward...", "That said...", "That being said...", "With that in mind...", "When it comes to...", "At the intersection of...", "Here's the thing...", "Make no mistake...", "Simply put...", "The reality is...", "Let that sink in", "Read that again", "Full stop.", "Period." (as emphasis), "This can't be overstated", "Rest assured...", "Here's why that matters", "And that's okay", "Spoiler alert:", "Hot take:", "Pro tip:", "The takeaway?", "The bottom line?", "Level up", "Move the needle", "Low-hanging fruit", "Circle back", "It's a marathon, not a sprint", "The elephant in the room", "Only time will tell", "Stands out as", "Serves as a reminder", "Paves the way for", "Sheds light on", "Bridges the gap", "Strikes a balance", "Raises the bar", "This highlights...", "This underscores...", "This speaks to...", "This illustrates...", "This demonstrates...", "This signals...", "This points to...", "This reflects...", "This suggests that...", "The key takeaway is...", "The big picture here is...", "Now for the interesting part", "Which brings us to the real question", "Why does this matter?", "Why should you care?", "And here's what most people miss...", "And that's exactly why...", "And that's the point"

**Plain word substitutions:**
utilize → use / execute → do / facilitate → help / expedite → speed up / implement → start or build / optimize → improve / leverage → use / garner → get / delve → look at / underscore → show / embark → start / augment → add to / maximize → increase / align → match / cultivate → build or grow / harness → use / bolster → support / catalyze → start or cause / amplify → increase / elevate → raise or improve / empower → let or enable / navigate → handle or deal with / spearhead → lead / streamline → simplify / curate → pick or choose / craft → write or make / unpack → explain / demystify → explain / reimagine → rethink or redo / resonate → connect or land

---

## Emojis to avoid in professional writing

🚀 💡 🎯 ✅ 🔥 💪 🌟 ✨ 📈 🏆 💎 🔑 🎉 ⚡ 🌐 📊 🤝 💼 🧠 🔒 ⭐ 📌 👉 🛠️ 📢 🔷 💠 🪄 ⚙️ 🎁 💰 🧩 🏅 📍 🔔 💬 📝 🎓 🌱 💥

The pattern: AI uses emojis as bullet points, as decoration before headers, or scattered throughout to signal engagement. Real people use them occasionally in casual contexts, not systematically.

---

## Filler to cut

- "in order to" → "to"
- "due to the fact that" → "because"
- "at this point in time" → "now"
- "has the ability to" → "can"
- "in the event that" → "if"
- Delete "it is important to note that" entirely
- Delete "it's worth considering that" entirely
- Delete "needless to say" (then don't say it)
- Cut any sentence that starts with throat-clearing

---

## Hedging to reduce

Cut excessive qualification. "It could potentially possibly be argued that the policy might have some effect" → "The policy may affect outcomes." One qualifier per claim is enough.

---

## Style patterns to fix

**Title case** → sentence case for all headers and subheadings. "How to write better emails" not "How To Write Better Emails."

**Vertical lists with inline bold headers** that just restate the label → write as prose or make the explanation genuinely expand the label.

**Uniform sentence length** → vary rhythm deliberately. Short sentences land punches. Longer ones build context and carry the reader through an idea before letting them rest.

---

## Then add personality (step 2)

Clean text without voice is still boring. After removing AI patterns:

**Have opinions.** React to what you're writing about. "I don't know how to feel about this" beats a neutral list of pros and cons.

**Vary rhythm.** Mix short with long. When every sentence is the same length, it feels generated.

**Use "I" when it makes sense.** First person sounds like a real person thinking. "I keep coming back to..." and "What gets me about this..." are human.

**Be specific.** Not "this is concerning" but "there's something unsettling about a system that runs all night with no one watching."

**Leave some imperfection.** Perfect structure feels algorithmic. An aside, a half-formed thought, or an honest "I'm not sure" is more convincing than a clean five-paragraph essay.

**Acknowledge mixed feelings.** People rarely feel one way about anything. "This is impressive but also kind of unsettling" is more honest than just "This is impressive."

**Add a specific example.** You don't need a full story. Just anchor the point in something real: "This worked when we ran X" or "I tried this last week and found..."

---

## POP writing framework (David Perell / Write of Passage)

Used actively on all drafts. After removing AI patterns, this is the framework for adding genuine human voice.

**P — Personal.** Comes from lived experience. Only this specific person could have written it. Not "the onboarding process was confusing" but "I watched a new hire open the handbook, read page one, close it, and never open it again."

**O — Observational.** Notices something true that most people walk past without seeing. The insight doesn't explain itself, it just points at something real and lets the reader feel the recognition. Example: "The more research tools a company buys, the less time anyone spends actually talking to customers."

**P — Playful.** An unexpected frame, twist, or punchline that makes the point stick. Not jokes for the sake of jokes, but following the logic of a serious idea somewhere the reader didn't expect. The Rory Sutherland move: take a real observation to its absurd but accurate conclusion.

**V — Vignette (the delivery vehicle for POP).** Short, sensory, mood-driven writing that captures a specific instant rather than summarizing a situation. Vivid detail over explanation. Emotional resonance over plot. The goal: make it feel witnessed, not reported. Vignettes set scenes before dialogue, anchor abstract claims in physical reality, and give the reader something to see, smell, or hear instead of just understand.

Bad: "The presentation didn't go well."
Good: "Slide 4. She clicks forward. The room shifts. Someone checks their phone. The CEO uncaps a pen, writes nothing, caps it again."

Bad: "The restaurant was busy on a Friday night."
Good: "Plates stacking up at the pass. The ticket machine won't stop printing. Someone calls 'behind' and nobody moves."

### POP brackets in drafts

When writing or reviewing any draft, flag gaps inline using brackets. These are editorial prompts for the human editor, not placeholder text. Each bracket must name *why* that type of moment is needed and *what specifically it would add* in that spot.

The four bracket types:

- `[POP: Personal]` — a specific story, memory, or internal reaction that only this writer (or the subject) could provide. "What went through their head in that pause?" Not an explanation for the reader, just one honest reaction.
- `[POP: Observational]` — a moment where the writing states a fact but misses the sharp, true thing underneath it. The insight the reader will recognize but hasn't put into words themselves.
- `[POP: Playful]` — a place where an unexpected angle, image, or follow-through would make the point land harder. The twist that earns a half-smile.
- `[POP: Vignette]` — a spot that needs sensory scene-setting. What does the room look/smell/sound like? What's happening physically in that moment? One or two concrete details that put the reader *there* before the point lands.

**Bracket placement rules:**

1. Place the bracket *above* the line it applies to, not after it.
2. Be specific about what's missing. "[POP: Personal]" alone is lazy. "[POP: Personal — what did the founder actually feel watching the first user quit? Not the investor pitch version. The gut reaction.]" gives the editor something to work with.
3. Don't over-bracket. 4-6 per piece is plenty. More than that and the editor drowns in flags instead of writing.
4. Vignette brackets work best at scene openings, before dialogue, and at emotional turning points. They don't belong on every paragraph.

---

## Quick reference: the full pattern checklist

| # | Pattern | Fix |
|---|---------|-----|
| 1 | Overused AI words (leverage, delve, robust...) | Replace with plain equivalents |
| 2 | Rule of three | Cut to 2 or expand to 4+ |
| 3 | "It's not X, it's Y" contrast framing | Just say what it is |
| 4 | Em dashes everywhere | Commas, periods, or parentheses |
| 5 | Staccato short sentence stacks | Break them up, vary rhythm |
| 6 | Self-narrating ("here's why this matters") | Delete narration, add specifics |
| 7 | "Nobody tells you this" opener | Cut entirely |
| 8 | Fake capitalized frameworks | Just describe the idea |
| 9 | Systematic emoji use | Sparingly or not at all |
| 10 | Formal transition openers (Moreover, Furthermore...) | Use "but", "also", or nothing |
| 11 | Significance inflation ("pivotal moment") | Show importance with specifics |
| 12 | -ing phrase padding at sentence ends | Delete after the comma |
| 13 | Copula avoidance ("serves as", "boasts") | Replace with "is" and "has" |
| 14 | Negative parallelism ("not X, but Y") | Say the thing directly |
| 15 | Bullet + bold label that restates itself | Write as prose or earn the label |
| 16 | Vague attribution ("experts say") | Name the source or cut the claim |
| 17 | Promotional/travel-brochure tone | Concrete facts instead |
| 18 | Uniform sentence length | Vary deliberately |
| 19 | Excessive boldface | Sparingly, never mechanically |
| 20 | Tailing -ing clauses of vague importance | Cut after the comma |
| 21 | Elegant variation (synonym cycling for names/concepts) | Just repeat the word or name |
| 22 | False ranges ("from X to Y" with no real scale) | List the items, cut the fake spectrum |
| 23 | "Despite challenges" formula | Break the skeleton, don't follow the sequence |
| 24 | Copula avoidance ("serves as," "stands as," "boasts") | Use "is" and "has" |

---

## How this skill interacts with the rest of the kit

- **Voice guide** (`vault/Brand/Voice guide.md`) — populated during kick-off Section B. Adds [PARTNER_NAME]-specific banned words, tone preferences, sentence-length defaults. This skill reads it on every fire.
- **Do-not-use list** (`vault/Brand/Do-not-use list.md`) — populated during kick-off B5. Specific phrases [PARTNER_NAME] hates that aren't in the general banned-word list. This skill reads it on every fire.
- **Reference brands** (`vault/Brand/Reference brands.md`) — three brands [PARTNER_NAME] admires tonally. This skill checks output against the tonal range those brands suggest.
- **About-me file** (`vault/Voice/about-me.md`) — compressed 100-Q voice interview output (if Part 2 deluxe was run). Highest-fidelity voice anchor. This skill loads it preferentially over the lighter Voice guide if both exist.
- **Wrap-up skill** — at end of session, if [PARTNER_NAME] flagged a draft as "didn't sound like me," wrap-up captures the specific phrase/pattern and proposes adding it to this skill's `learnings.md`. Over time, the skill specializes to [PARTNER_NAME].

## Hard rules for this skill itself

- **Never claim a draft is "human-sounding" without running the full pattern check.** The two-step rule (remove patterns, add personality) is non-negotiable.
- **Never recommend a banned word as a fix.** If a draft has too many "Moreover"s and the suggested rewrite uses "Furthermore," the skill failed.
- **Never strip voice in the name of safety.** A clean-but-flat draft is the failure mode this skill exists to prevent. If a pass produces something less recognizable as [PARTNER_NAME], reverse the change.
- **When user adds a personal banned word**, append to `learnings.md`. Wrap-up skill folds promoted entries into the main SKILL.md on a periodic basis.

---

## Three-scenario test (production-grade standard)

### Scenario 1 — Happy path

**Test input:** [PARTNER_NAME] asks the AI to draft a 300-word LinkedIn post about a recent client win. Voice guide + Reference brands files populated from kick-off Section B.

**Expected output:** Draft with zero em dashes, no rule-of-three patterns, no "It's not X it's Y" framing, no banned words from the comprehensive list, no rhetorical transition questions. Sentence rhythm varies (short + medium + long mix). Uses "I" where appropriate. Has at least one specific anchor (a real moment, not a generic claim). Avoids the "despite challenges" structure. Concrete examples instead of abstract significance claims.

**Pass criteria:** Pasted into a fresh AI session with no other context, the AI can't confidently identify it as AI-generated. [PARTNER_NAME] reads it and says "yes, that sounds like me" without edits.

### Scenario 2 — Edge case

**Test input:** [PARTNER_NAME] asks for a thank-you note to a high-stakes client after a difficult meeting. Wants warmth without over-promising. Pulls toward emotional language the skill might over-correct.

**Expected output:** Honest warmth using "I" voice. Specific reference to what happened in the meeting (not generic). One mixed-feeling acknowledgment (e.g., "I know this isn't the answer you were hoping for"). No "this is impressive but also..." pattern (that's an AI-mixed-feeling template). No em dashes. No "circle back" or "moving forward."

**Pass criteria:** [PARTNER_NAME] could send this as-is. It sounds like them having a real moment, not a template.

### Scenario 3 — Stress test

**Test input:** Long-form essay draft (1500+ words) where [PARTNER_NAME] has supplied an initial draft full of AI patterns. Skill is asked to clean it while preserving structure + argument.

**Expected output:** Every paragraph passes the 24-pattern checklist. Original argument structure preserved. Specific examples retained. Sentence rhythm varied throughout (not uniformly clipped or uniformly long). At least one POP bracket marking a spot where a personal anecdote would land harder. No synonym cycling: names and key terms repeat naturally. Final word count within ±10% of original (cleanup shouldn't bloat or shred).

**Pass criteria:** The original argument is unchanged. The voice is recognizably [PARTNER_NAME]'s. A fresh-AI scan returns zero high-confidence "this is AI-generated" flags.

### Marking production-grade

Once all three scenarios pass, add to frontmatter:

```yaml
production_grade: true
last_qa: YYYY-MM-DD
```

---

*Sources: Ruben Hassid (Ai_to_Human_Writing_Skill.md) + Wikipedia "Signs of AI Writing" cleanup project (July 2025 initial, March 2026 update) + David Perell POP framework (Write of Passage). Last updated: 2026-05-18.*
