# Brief Setup — the morning-brief onboarding SOP

> Purpose: turn the **first morning brief** into an aha moment instead of a surprise. The installing AI explains what the daily brief is, collects a few details so it's genuinely useful from day one, schedules it, and — the morning after it first lands — invites an optional email opt-in.
>
> **For the installing AI:** run Steps 1–3 at **Part 1 close**, after the First Wins card, before the goodbye. Step 4 fires automatically the next morning, appended to the first real brief. This SOP is generic — works for any user and any AI name via the `[AI_NAME]` / `[PARTNER_NAME]` placeholders.

---

## Step 1 — Explain the daily brief (plain English, ~3 sentences)

> *"Think of the best assistant you've ever had — the one who, before you even sat down, had already laid out your day: what's coming, what matters most, what slipped through yesterday. That's your morning brief. Every morning, [AI_NAME] reads your calendar, your priorities, and yesterday's notes, and writes you a one-screen rundown before you even ask — so you start the day oriented instead of scrambling."*

Keep it to that. Don't explain the plumbing (launchd, the skill) — that's back-end. The user only needs to feel the value.

## Step 2 — Collect a few details (max ~4 questions — a conversation, not a form)

Ask these naturally, one or two at a time:

1. **Time** — *"What time do you want it? Most people pick just before they start their day — 7 or 8 AM."*
2. **Channel** — *"Where should it land — as a Telegram message you'll catch on your phone, a note in your vault, or both?"*
3. **What matters to you in the morning** — *"Pick whatever's useful: today's calendar · your top priorities · open threads & follow-ups · a money/CFO line · a motivating nudge to start."* (For a vertical kit, offer the domain-specific ones too.)
4. **Current focus** — *"What are the 2–3 things you're focused on right now? I'll weave them in, so the brief speaks to your actual life — not a generic template."*

*(Optional 5th, only if they're engaged):* *"Anything you always want surfaced? Like 'always remind me to check X.'"*

Save the answers to the vault config the morning-brief skill reads. This is what separates a brief that feels *psychic* from one that feels *canned*.

## Step 3 — Schedule it + set expectations

- Wire the morning-brief launchd job to the chosen time.
- **State the awake-requirement plainly:** *"One thing — for the brief to land, your Mac needs to be awake at [TIME]: plugged in with the lid open, or it'll arrive when you next open it. A sleeping laptop can't write you anything."*
- Close: *"Tomorrow morning at [TIME], it just shows up. Don't prep anything — open it with your coffee."*

That last line plants the aha for tomorrow.

## Step 4 — The morning after: deliver, THEN opt-in CTA #1

After the **first** brief successfully lands (and only the first), append:

> *"PS, [PARTNER_NAME] — that brief you just got? It's exactly the kind of thing the person who built me writes about every week: running a company with an AI partner, what's working, what's new in the kit. If you want to stay in the loop, there's a free weekly newsletter. → **allgravytimes.com** — one click, your email, no spam, leave anytime. Totally optional. The kit's yours either way."*

Then never raise it here again. (The only other mention is CTA #2 below.)

---

## Email opt-in CTA #2 — the very end of the entire install

Fires once, at the genuine close of the install the user completes (Part 2 close — or Part 1 close if they stop there). After that: **silence. No further newsletter mentions anywhere in the running experience.**

> *"That's the whole thing, [PARTNER_NAME] — [AI_NAME] is fully yours now. One last thing and then I'll never bring it up again: if you want to follow how the kit grows — new skills, new tricks, what's landing for other operators — the person who built me runs a free weekly newsletter. → **allgravytimes.com**. Opt in if it's useful to you; if not, we're done, and everything here is yours forever."*

The *"I'll never bring it up again"* is load-bearing — it signals the restraint that makes the whole free-kit positioning credible.

---

## Hard rules

- **Two email opt-ins total, ever.** CTA #1 (morning after, post-first-brief) + CTA #2 (end of install). Nowhere else in the conversation flow. The passive backstops (README, STAY_IN_TOUCH.md) stay; those aren't pitches.
- **Always after delivered value, never before.** The opt-in only appears once the user has *felt* the brief work. Asking earlier betrays the no-email-gate promise.
- **Link-based, not in-conversation capture.** Point to allgravytimes.com; the user enters their own email there. Don't collect and store their email through the AI (privacy + the "no email gauntlet" promise). *(If Dani later wants true in-conversation capture via the Beehiiv API, that's a separate, heavier build — flagged, not default.)*
