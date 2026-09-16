# Optional add-ons — the power-ups menu

> **Your kit works fully without a single thing on this page.** Everything here is optional. Add one *only* when a real, recurring need shows up — never because the list looks tempting.
>
> **For the installing AI — hard rule:** do NOT push, bundle, or auto-install anything below. Mention the *one* relevant tool only when [PARTNER_NAME] hits the need it solves (e.g. they keep asking for images → *then* mention fal.ai). Never run a download [PARTNER_NAME] didn't ask for. Forcing non-essential installs is the fastest way to make the kit feel bloated and pushy — the opposite of the point.

> **Note — voice is NOT on this list, because it's core.** [AI_NAME]'s voice (ElevenLabs) and your voice dictation (Wispr Flow) are part of the **essential** kit, set up during install on their **free tiers**. They live in the core voice setup, not here. This page is only for the genuinely optional stuff.

---

## 🧰 Apps & tools

### 🎨 Refero — design reference library
- **What it does:** a huge library of real product screens/flows. When [AI_NAME] builds you a landing page or dashboard, it researches real patterns first instead of inventing generic "AI slop."
- **Use it when:** you're having [AI_NAME] build anything a human will *look at* — pages, dashboards, emails-as-pages.
- **Cost:** paid subscription (design tool). [AI_NAME]'s design work still functions without it — it just falls back to general pattern knowledge.
- **Link:** [refero.design](https://refero.design)

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

## 🎬 Video & Motion — the one true add-on

Everything else on this page is a single tool. This is a whole **package**, kept
deliberately outside the main kit so the default install stays short.

- **What it does:** [AI_NAME] watches, edits, animates and generates video.
- **Say yes if:** you publish video, record Looms or course modules, or want long
  videos transcribed instead of watched.
- **Say no if:** you mostly write, brief and run admin — and add it later, free, the
  first time you wish [AI_NAME] could cut a clip for you.
- **Cost:** free skills. A couple of optional paid tools, free tiers shown first.
- **Install:** tell [AI_NAME] *"I need the video add-on, go ahead."*
  → full detail in **[VIDEO-ADD-ON.md](./VIDEO-ADD-ON.md)**

---

## 🔌 MCP servers — giving [AI_NAME] reach

Everything above is an *app*. These are different: an **MCP server** is a connection
that lets [AI_NAME] reach out and *do* something on the live internet, rather than
only working with files on your Mac.

**Read this before adding either.** Both are genuinely useful and both change the
shape of what [AI_NAME] can do — which cuts in two directions:

- **They cost money per use**, not a flat monthly fee. Small jobs are pennies. A
  large scrape can be several dollars. Check the bill in the first week rather
  than at the end of the month.
- **They reach outward.** The rest of your kit reads your own files. These send
  requests to other people's websites. Point them at public information —
  business listings, published articles, public profiles — and be deliberate
  about anything more sensitive than that.
- **They break.** Websites change their layout and the scraper that worked last
  month returns nothing. Expect maintenance. Don't build something you depend on
  daily without accepting that.

### 🕷 Apify — ready-made scrapers for specific sites
- **What it does:** a store of pre-built robots that each know how to read one
  website — Google Maps, LinkedIn, Instagram, Zillow, and hundreds more. You ask
  for a list, it goes and gets it, and hands back structured data.
- **Use it when:** you need to *build a list* from a site that has one — local
  businesses in your area, event listings, competitor pages. The boring
  copy-into-a-spreadsheet work.
- **Cost:** pay-per-use, billed per robot run.
- **Add it:** `claude mcp add apify "https://mcp.apify.com/" -t http --scope user`
  · [apify.com](https://apify.com)

> ⚠️ **Use `--scope user`.** Without it the CLI defaults to *local* scope, which
> silently chains the server to whatever folder you ran the command in — it then
> loads nowhere else, with no error to tell you why. This has bitten this kit's
> author on a paid subscription that went unused for weeks.

### 🔥 Firecrawl — turn any page into clean text
- **What it does:** fetches a web page (or a whole site) and returns readable
  text instead of raw HTML, so [AI_NAME] can actually work with it. Also does
  search and multi-page crawls.
- **Use it when:** you want [AI_NAME] to read something on the web properly —
  research, competitor pages, documentation, an article you want summarised.
  This is the general-purpose one; Apify is the site-specific one.
- **Cost:** free tier, then paid by volume.
- **Add it:** see [firecrawl.dev](https://firecrawl.dev) for the current MCP URL,
  then `claude mcp add firecrawl "<url>" -t http --scope user`

**Which one do you actually need?** Most people want **Firecrawl** first — reading
pages is the common case. Add **Apify** only when you hit a specific site that
Firecrawl can't get into, or when you need hundreds of rows rather than one page.

> **Note on both:** MCP servers load when a session *starts*. After adding one,
> quit [AI_NAME] and open it again, or the tools won't appear. Most remote
> servers also ask you to sign in through your browser the first time.

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

<!-- Phase 4 (affiliate): CORE-stack ElevenLabs + Wispr Flow (Dani joining both programs) → affiliate links in the voice setup. Optional-list Granola, Readwise, Beehiiv also have programs. Swap to affiliate links + keep README disclosure once joined. Plain links for now. -->
