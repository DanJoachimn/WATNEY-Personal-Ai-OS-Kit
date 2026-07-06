# More skills — where to get them

> Your kit ships **lean**: the infrastructure that makes [AI_NAME] a real partner (memory, install, voice, self-update, llm-council). It deliberately does **not** bundle a giant pile of capability skills — fewer moving parts means fewer things that break, and you add power only where you actually need it.
>
> This file is the menu. Each pack below is a public, well-maintained collection you can browse and install when a need shows up. Nothing here is required. The kit works fully without any of it.

---

## How skills get added (two mechanisms)

- **Folder skills** — a skill is just a folder with a `SKILL.md`. To add one, copy that folder into `~/[AI_NAME]/.claude/skills/` (or your global `~/.claude/skills/`). [AI_NAME] picks it up next session.
- **Plugin skills** — installed through Claude Code's plugin system with one command: `claude plugin install [name]@[marketplace]`. These auto-update from upstream.

Not sure which you need? Just tell [AI_NAME] *"I want to be able to make slide decks"* (or whatever) and it'll find the right skill and walk you through adding it.

---

## Already built into your kit

- **llm-council** — pressure-test a real decision through 5 independent AI advisors who argue, peer-review, and synthesize a verdict. Adapted from Andrej Karpathy's LLM Council methodology. Say *"council this"* on any decision with real stakes. **No install needed — it ships with the kit.**

---

## Recommended packs to add when you need them

### 📄 Anthropic Skills — documents & creation
**What it's good for:** making real files — Word docs, PowerPoint decks, PDFs, Excel sheets — plus brand guidelines, canvas design, and `skill-creator` (a skill that helps you build your own skills).
**Get it:** **[github.com/anthropics/skills](https://github.com/anthropics/skills)**
**Add it:** browse the repo, copy the skill folder you want (e.g. `docx`, `pptx`, `pdf`, `xlsx`) into `~/[AI_NAME]/.claude/skills/`.
**Add when:** the first time you wish [AI_NAME] could hand you a finished deck or spreadsheet instead of just text.

### 🛠 Superpowers — agentic workflows (for the technical)
**What it's good for:** disciplined building — test-driven development, systematic debugging, structured brainstorming, writing and executing implementation plans, git worktrees. Jesse Vincent's agentic framework.
**Get it:** **[github.com/anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)**
**Add it:** `claude plugin install superpowers@claude-plugins-official`
**Add when:** you start having [AI_NAME] write or maintain actual code and want it to work methodically instead of cowboy-coding.

### 💼 Knowledge-Work Plugins — role packs (Anthropic-maintained)
**What it's good for:** whole job functions — marketing (campaign planning, performance reports), sales, finance, customer support, brand-voice. Plain markdown, no code, auto-updating.
**Get it:** **[github.com/anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins)**
**Add it:** `claude plugin install [name]@knowledge-work-plugins` *(your kit already pulls `productivity`, `enterprise-search`, and `brand-voice` during Part 2)*
**Add when:** you want a full role's worth of capability at once — e.g. *"install the marketing plugin."*

<!-- PENDING: 28-skill growth/marketing pack (ab-testing, cro, ads, ai-seo, analytics…). Source unconfirmed — add the repo link here once Dani confirms where it came from. -->

---

## A note on restraint

More skills is not automatically better. Every skill you add is one more thing [AI_NAME] has to consider, one more thing that can update badly, one more bit of surface area. The kit stays lean on purpose. Add a pack when a real, recurring need appears — not because the menu looks tempting. The strongest setups are *curated*, not *maximal*.
