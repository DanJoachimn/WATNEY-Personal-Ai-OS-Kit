# Optional add-ons — the power-ups menu

> **Your kit works fully without a single thing on this page.** Everything here is optional. Add one *only* when a real, recurring need shows up — never because the list looks tempting.
>
> **For the installing AI — hard rule:** do NOT push, bundle, or auto-install anything below. Mention the *one* relevant tool only when [PARTNER_NAME] hits the need it solves (e.g. they complain about taking meeting notes → *then* mention Granola). Never run a download [PARTNER_NAME] didn't ask for. Forcing non-essential installs is the fastest way to make the kit feel bloated and pushy — the opposite of the point.

> **Note — voice is NOT on this list, because it's core.** [AI_NAME]'s voice (ElevenLabs) and your voice dictation (**Lispr** — free — with **Wispr Flow** as the polished alternative) are part of the **essential** kit, set up during install on their **free tiers**. They live in the core voice setup, not here. This page is only for the genuinely optional stuff.

---

## 🧰 Apps & tools

### 🎙 Granola — AI meeting notes
- **What it does:** sits in your meetings, writes the notes for you, and can flow them into your vault so [AI_NAME] remembers every conversation.
- **Use it when:** you're in enough calls that taking notes (or forgetting what was said) is a real cost.
- **Cost:** app is **free** (Basic). Automatic vault-sync needs **Business $14/mo** (the API) — or the free MCP path with limits (30-day window, summaries not transcripts, private notes only).
- **Link:** [granola.ai](https://www.granola.ai)

### 🎨 Refero — design reference library
- **What it does:** a huge library of real product screens/flows. When [AI_NAME] builds you a landing page or dashboard, it researches real patterns first instead of inventing generic "AI slop."
- **Use it when:** you're having [AI_NAME] build anything a human will *look at* — pages, dashboards, emails-as-pages.
- **Cost:** paid subscription (design tool). [AI_NAME]'s design work still functions without it — it just falls back to general pattern knowledge.
- **Link:** [refero.design](https://refero.design)

### ☕ Amphetamine — keep your Mac awake
- **What it does:** stops your Mac sleeping when you close the lid, so [AI_NAME] stays reachable 24/7 — even on a bare laptop with no external monitor.
- **Use it when:** you want to text [AI_NAME] from your phone while your laptop's closed, and you *don't* have an external display (if you do, you already have this for free — see AWAKE-SETUP).
- **Cost:** **free** (Mac App Store).
- **Setup:** the safe config (awake *only when plugged in* — never always-on) → **[AMPHETAMINE-SETUP.md](./AMPHETAMINE-SETUP.md)**.
- **Link:** [Amphetamine on the Mac App Store](https://apps.apple.com/app/amphetamine/id937984704)

### 🖼 fal.ai — image & video generation
- **What it does:** powers the `genmedia` skill — [AI_NAME] can generate images, social graphics, and short video clips on demand.
- **Use it when:** you make content that needs original visuals (newsletter headers, social graphics, thumbnails).
- **Cost:** pay-per-use (cheap per image; you only pay for what you generate).
- **Link:** [fal.ai](https://fal.ai)

### 📚 Readwise — highlights into your brain
- **What it does:** syncs your book/article highlights into the vault so [AI_NAME] can reference what you've read (powers the `book-mirror` skill).
- **Use it when:** you read a lot and want those ideas living in your second brain, not lost in a Kindle.
- **Cost:** paid subscription.
- **Link:** [readwise.io](https://readwise.io)

### 📰 Beehiiv — newsletter platform
- **What it does:** publish and grow an email newsletter. [AI_NAME] drafts issues in your voice; Beehiiv handles the sending, subscribers, and growth tools.
- **Use it when:** you want to build an audience or publish a newsletter (the kit's own creator runs *The All Gravy Times* on it).
- **Cost:** **free** up to a few thousand subscribers; paid as you scale.
- **Link:** [beehiiv.com](https://www.beehiiv.com)

### 🔐 1Password — secret manager
- **What it does:** stores your API keys and passwords securely, so [AI_NAME] pulls them from a vault instead of plain text files.
- **Use it when:** you've connected enough services that loose API keys in `.env` files make you nervous.
- **Cost:** ~$3/mo individual.
- **Link:** [1password.com](https://1password.com)

---

## 🧩 Skills & skill packs

The kit ships lean infrastructure. For optional *capability* skills — document creation (Word/PowerPoint/PDF/Excel), marketing packs, dev workflows — see the dedicated menu:

→ **[MORE-SKILLS.md](./MORE-SKILLS.md)** — what each pack does, the GitHub link, and how to add it.

### 🦾 Superpowers — dev process framework (**for builders only**)
- **What it does:** makes [AI_NAME] brainstorm, plan, write tests, and verify its own work before shipping code — a discipline layer for technical building.
- **Use it when:** you build software or run complex, multi-step technical projects. **Skip it if** [AI_NAME] is mostly for writing, briefs, and admin — it adds overhead to simple tasks with no upside there.
- **Cost:** **free** (open-source plugin by Jesse Vincent).
- **Install:** `/plugin install superpowers@claude-plugins-official` · [obra/superpowers](https://github.com/obra/superpowers)

---

## How to add anything here

Just tell [AI_NAME] in plain English: *"I keep losing track of my meetings"* or *"I want you to be able to make slide decks."* It'll point you to the right tool above (or skill in MORE-SKILLS), and walk you through adding it — via computer-use if it can drive the clicks for you.

## The rule, again
More tools is not better. Every add-on is one more thing to maintain and one more thing that can break. The strongest setups are **curated, not maximal.** Add a power-up when a real need appears — and not before.

<!-- Affiliate state (2026-07): voice-in LEADS with Lispr (free, no program) + Wispr Flow as the affiliate alternative; voice-out = ElevenLabs (affiliate); Granola + Beehiiv affiliate links live; Readwise + 1Password still plain. All links live once in AFFILIATE-LINKS.md. -->
