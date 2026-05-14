---
name: llm-council
description: "Run a big decision through 5 independent AI advisors who think from completely different angles, peer-review each other anonymously, then synthesize a final verdict. Pressure-tests decisions with real stakes — pricing, hiring, big bets, lock-in choices, anything you're agonizing over. Triggers on: 'council this', 'run the council', 'pressure-test this', 'stress-test this', 'should I X or Y' (when there are real stakes), 'I'm stuck between', 'help me decide', 'is this the right move'. Adapted from Andrej Karpathy's LLM Council methodology. Do NOT trigger on simple yes/no questions, factual lookups, or casual 'should I' without a meaningful tradeoff."
---

# LLM Council — Get a Second Opinion From Five Specialists

## What this is (for [PARTNER_NAME], plain English)

When you face a real decision with real stakes — should I take on this client, should I raise prices, should I hire, should I pivot — you usually do one of three things:

1. **Ask one trusted person** for advice. You get one opinion, filtered through one personality and one set of biases. Helpful, but you only see one angle.
2. **Ask your AI** ([AI_NAME]). Same problem — one perspective, however good.
3. **Decide alone in your head.** You'll lean toward whatever feels right today, which is often whatever you'd already decided before asking.

**The LLM Council is option 4.** It runs your decision past 5 independent AI advisors at once. Each one thinks from a fundamentally different angle:

- **The Contrarian** — actively looks for what's wrong, what's missing, what will fail
- **The First Principles Thinker** — strips away your assumptions, rebuilds the problem from scratch, sometimes says "you're asking the wrong question entirely"
- **The Expansionist** — finds the upside everyone is missing, asks what happens if this works better than expected
- **The Outsider** — zero context about you, catches things that are obvious to you but confusing to anyone else
- **The Executor** — only cares about "can this be done, what's the fastest path, what ships Monday morning"

They each give you their independent take. Then they **peer-review each other anonymously** — none of them knows which advisor said what, so they evaluate purely on merit, not personality. Then a chairman synthesizes everything into a clean recommendation, including a single "one thing to do first."

It takes about 2-4 minutes to run. The output is structured, scannable, and you can usually decide within 30 seconds of reading the verdict.

## Why it matters (the real value)

Most big decisions get made twice:

1. **In your head**, leaning toward the option you secretly already prefer
2. **Two months later**, when reality has shown you what you should have considered

The council collapses that gap. It surfaces the blind spots, the assumptions you didn't know you were making, the framing you didn't realize you were stuck inside.

**It's been the difference, in real use, between:**
- Spending 10 hours on a refactor that turned out to be the wrong layer to fix
- Pricing a service at the gut-instinct number vs. a number that respects your actual cost structure
- Pivoting too early vs. holding the line vs. doubling down

It's not magic. It's structured disagreement. But structured disagreement is what most decisions are missing.

## When to use it

✅ **Good council questions** — decisions where being wrong is expensive:

- "Should I launch X as free or paid?"
- "Should I take on this client at this price?"
- "I'm stuck between [option A] and [option B] — what am I missing?"
- "Is this offer / landing page / pitch strong enough to send?"
- "Should I hire / fire / pivot / hold?"
- "Should I refactor X or leave it?"
- "Park this project or proceed?"

❌ **Bad council questions** — things that don't need 5 specialists:

- "What's the capital of France?" (one right answer — just ask)
- "Write me a tweet" (creation, not decision)
- "Summarize this article" (processing, not judgment)
- "What time is it?" (lookup)
- Anything you already know the answer to and just want validation on — the council will likely tell you things you don't want to hear, which is the point

If you're agonizing → council it.
If you're just curious → don't council it.

## How it works (the 6 steps the AI runs)

This part is for [AI_NAME] to follow. [PARTNER_NAME] doesn't need to know the steps; the AI handles them.

### Step 1 — Frame the question (with targeted context)

**A. Context scan — narrow allowlist only.** Before framing, do a quick scan for context that's directly relevant to this specific decision. Do NOT broad-scan everything. Read only:

- The user's explicitly attached files or referenced paths
- The CLAUDE.md operating manual (already loaded — don't re-read)
- If the question clearly concerns a specific business or client, the corresponding `_context/` folder in the vault
- Recent transcripts in `~/Documents/[ai-name]/vault/Council Talks/` (to avoid re-counciling the same ground)

Budget: 30 seconds. 2–3 files max. Looking for minimum context advisors need to give specific, grounded answers instead of generic takes.

**B. Frame the question.** Reframe as a clear, neutral prompt all five advisors receive. Include:

1. The core decision
2. Key context from the user's message
3. Key context from the files read (stage, audience, constraints, relevant numbers)
4. What's at stake

Don't add opinion. Don't steer. But DO give each advisor enough to answer specifically.

If the question is too vague ("council this: my business"), ask one clarifying question. Just one.

### Step 2 — Convene the council (5 sub-agents in parallel)

Spawn all 5 advisors simultaneously via the `Agent` tool across a single message (multiple tool-use blocks in one turn). Each gets:

1. Their advisor identity and thinking style
2. The framed question
3. Instruction: respond independently, don't hedge, don't try to be balanced. Lean fully into the assigned angle.

Each response: 150–300 words.

**Sub-agent prompt template:**

```
You are [Advisor Name] on an LLM Council.

Your thinking style: [advisor description]

A user has brought this question to the council:

---
[framed question]
---

Respond from your perspective. Be direct and specific. Don't hedge or try to
be balanced. Lean fully into your assigned angle — the other advisors will
cover the angles you're not covering.

Keep your response between 150–300 words. No preamble.
```

### Step 3 — Peer review (5 sub-agents in parallel)

This is what makes the council more than "ask 5 times."

Collect all 5 advisor responses. **Anonymize them as Response A–E (randomize the mapping so there's no positional bias).**

Spawn 5 reviewer sub-agents in parallel. Each sees all 5 anonymized responses and answers:

1. Which response is strongest? Why?
2. Which response has the biggest blind spot? What is it missing?
3. What did ALL five miss that the council should consider?

Keep reviews under 200 words.

### Step 4 — Chairman synthesis

One agent gets everything: original question, all 5 de-anonymized advisor responses, all 5 peer reviews. Produces the final verdict in this exact structure:

- **Where the Council Agrees** — convergent points. High-confidence signals.
- **Where the Council Clashes** — genuine disagreements. Present both sides, don't smooth over.
- **Blind Spots the Council Caught** — things that only emerged in peer review.
- **The Recommendation** — a clear, actionable call. Not "it depends." The chairman can disagree with the majority if the minority reasoning is stronger.
- **The One Thing to Do First** — a single concrete next step. Not a list. One thing.

### Step 5 — Present the verdict in chat

Present the full verdict directly in chat as markdown. Do NOT generate HTML or any output files at this step.

```
## Council Verdict: {short topic}

### Where the Council Agrees
{content}

### Where the Council Clashes
{content}

### Blind Spots the Council Caught
{content}

### The Recommendation
{content}

### The One Thing to Do First
{content}
```

Keep it scannable. Use bullets.

### Step 6 — Save the transcript (when significant)

Save if the user asks for it ("save this", "file it") OR the decision is clearly significant enough to reference later.

**Path:** `~/Documents/[ai-name]/vault/Council Talks/YYYY-MM-DD-{short-topic-slug}.md`

**Required frontmatter:**

```yaml
---
title: "Council: {short topic}"
type: council-transcript
generated_by: claude-code
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [council]
---
```

**File body:** framed question, all 5 advisor responses (de-anonymized), all 5 peer reviews, chairman verdict. Reference artifact — [PARTNER_NAME] may want to re-read who said what.

If the `Council Talks/` folder doesn't exist yet, create it on first save. The folder is operational (the AI may write here).

## When [AI_NAME] auto-surfaces the council

Beyond explicit triggers, [AI_NAME] should *offer* the council when it detects a significant decision moment in conversation:

- [PARTNER_NAME] mentions being **stuck between options** with real stakes
- [PARTNER_NAME] uses language like *"agonizing over,"* *"can't decide,"* *"torn between,"* *"go all-in or pilot"*
- [PARTNER_NAME] is making a **commit-or-park** decision on a real project, hire, price, pivot
- [PARTNER_NAME] is about to make a **lock-in choice** (signing a contract, picking a tech stack, committing to a positioning)

How to offer (low-friction, never pushy):

> *"This sounds like a council-worthy moment — significant decision, real tradeoffs, multiple viable paths. Want me to run it past the council? 5 independent advisors, peer-reviewed, ~3 minutes. Or we can just keep talking it through if you'd rather."*

If [PARTNER_NAME] says yes → run. If no → drop it, don't re-offer.

## Important notes for [AI_NAME]

- **Always spawn advisors in parallel.** Sequential spawning wastes time and lets earlier responses bleed into later ones.
- **Always anonymize for peer review.** If reviewers know which advisor said what, they'll defer to the thinking style instead of evaluating on merit.
- **The chairman can disagree with the majority.** If 4 of 5 say "do it" but the dissenter's reasoning is strongest, side with the dissenter and explain why.
- **Don't council trivial questions.** If there's one right answer, just answer it.
- **Output is markdown in chat.** The optional transcript is the only file this skill ever writes (and only when significant).
- **Don't offer the council more than once per conversation** unless [PARTNER_NAME] brings up a new decision. Council fatigue is real.

## Original credit

Adapted from Andrej Karpathy's LLM Council methodology. Karpathy dispatches queries to multiple different model providers. This adaptation uses Claude sub-agents with different thinking lenses instead. Both approaches answer the same question: "what if I asked five thoughtful people who disagree about everything?"
