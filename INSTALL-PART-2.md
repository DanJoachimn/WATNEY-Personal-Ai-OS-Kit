# INSTALL-PART-2.md — Part 2 (Reach) install playbook

> **This file is read by an AI agent when the user says "run Part 2" or "continue install" after completing Part 1.** Days, weeks, or months after Part 1 — doesn't matter. The kit's already in place; this playbook deepens it.

---

## When this fires

User says any of:
- "run Part 2"
- "continue install"
- "let's do Part 2"
- "deepen the setup"
- "more setup"
- "expand my partner"

OR: the AI offers it after the user has been using Part 1 for a few days and seems ready for more (proactive opportunity-spotting moment).

---

## Stage 0 — Greeting + check Part 1 is in place

```bash
test -f ~/[AI_NAME]/.part-1-complete || { echo "Part 1 not complete; redirect to INSTALL.md"; exit 1; }
```

If Part 1 isn't done → tell user, route them to `INSTALL.md` first.

If done → continue:

> "Good to see you back. Part 2 is where I learn you deeper. Here's what we'll do (~30 min, ~30 messages, fits comfortably in one Pro session):
>
> 1. **Connect your apps** — Gmail, Calendar, Drive, Apple Notes, whichever you use (~5 min)
> 2. **Knowledge Work Plugins backbone** — install Anthropic-maintained foundation plugins (~3 min)
> 3. **5-question voice interview** — sharper voice profile than Part 1's lightweight one (~10 min)
> 4. **ElevenLabs upgrade** — premium voices if you want them (~5 min, optional)
> 5. **Optional skills** — Hyperframes, Video Use, content pipeline, document transformations, others (~varies)
>
> Ready to start with your apps, or want to pick a different stage to go to first?"

---

## Stage 0.3 — Connect your apps (~5 min)

They've used their AI for a few days and come back for more. *This* is the moment to ask for keys to the inbox — not the first hour.

**Probe silently first** — inspect the tool list for connectors already wired, and skip those:

| Service | Tool suffix to look for |
|---|---|
| Gmail | `__search_threads`, `__list_labels`, `__create_draft` |
| Google Calendar | `__list_events`, `__create_event`, `__list_calendars` |
| Google Drive | `__list_recent_files`, `__read_file_content`, `__search_files` |
| Apple Notes | `__add_note`, `__get_note_content`, `__list_notes` |

Then pitch — outcome-first, and only the ones they actually use:

> "Right now I can't see your inbox or your calendar. Connecting them is what turns *'what's on my plate today?'* from a guess into an answer. Each takes about a minute. Skip any you don't use.
>
> | App | What you'll be able to ask me |
> |---|---|
> | **Gmail** | *'what important emails am I dodging?'* / *'draft a reply to Sarah'* |
> | **Calendar** | *'what's on my plate today?'* / *'find 30 min next week with Anders'* |
> | **Drive** | *'summarize the doc I shared with Lina yesterday'* |
> | **Apple Notes** | *'read my note about the supplier call'* |
>
> In the Claude desktop app: profile (top right) → **Settings → Connectors**. Tap **Add** on the ones you want — I'll watch the browser and confirm each one."

For each: tell them what to click → watch the OAuth tab via the Chrome extension → verify with a no-op call (`list_labels` / `list_calendars` / etc.) → confirm in chat (*"Gmail connected — I can see your labels"*). If one errors twice, mark deferred and move on.

**If they skip some or all:** *"Totally fine — everything still works. Say 'connect my Gmail' anytime and we'll do it in a minute."* Log `connectors-deferred: $LIST` to `~/[AI_NAME]/.first-run-log.txt`.

**One idea to plant, not build (say it once, in passing):** *"Once your inbox is connected, one thing people love: pick a topic you care about but never have time to read — say, the three newsletters piling up — and ask me each morning for a two-minute rundown of what's new in them. Say 'brief me on my newsletters' whenever you want to try it."* Don't schedule anything. Don't set up a job. It's a use case they can try, not a feature to install.

**Hard rules:** never gate anything on connectors · connect only what they actually use · verify with a real call, never trust "I clicked it" · one nudge max afterwards (the wrap-up skill checks the deferred log once after 3 days, then never again).

---

## Stage 0.5 — Knowledge Work Plugins backbone (~3 min)

Before the voice interview, install three Anthropic-maintained plugins that backbone the rest of your kit. They're production-grade, update automatically through Claude Code's plugin system, and you get them for free.

Tell the user what's about to land:

> "Three foundation plugins, ~3 min:
>
> - **productivity** — tasks, calendar, daily workflows. The plumbing for your day.
> - **enterprise-search** — one query across your tools (email, docs, wikis).
> - **brand-voice** (Tribe AI, partner-built) — extracts voice from your existing writing. Powers everything voice-related in your kit.
>
> All three are public, maintained by Anthropic. They'll update whenever you run `/update`.
>
> Install all three / customize / skip?"

### If user says "install all"

```bash
claude plugin marketplace add anthropics/knowledge-work-plugins
claude plugin install productivity@knowledge-work-plugins
claude plugin install enterprise-search@knowledge-work-plugins
claude plugin install brand-voice@knowledge-work-plugins
```

### If user customizes

Show the full picture and ask which to install:

> "OK — here's the full default set, plus optional add-ons. Tell me which to add.
>
> **Default set:**
> - productivity (tasks, calendar)
> - enterprise-search (cross-tool search)
> - brand-voice (voice extraction + validation)
>
> **Optional add-ons:**
> - marketing (content production — useful for newsletter/social/blog producers)
> - cowork-plugin-management (power-user — build custom plugins for your workflow)
>
> Tell me 'install' followed by the names. Example: 'install productivity and brand-voice.'"

Install whichever the user picks via:

```bash
claude plugin marketplace add anthropics/knowledge-work-plugins   # one-time, skip if already done
claude plugin install [plugin-name]@knowledge-work-plugins         # per plugin
```

### If user says skip

```bash
touch ~/[AI_NAME]/.knowledge-work-plugins-deferred
```

> "Skipped. You can install them anytime by saying 'install the knowledge work plugins' or running the commands in `KNOWLEDGE-WORK-PLUGINS.md`."

### Mark complete

After install (or skip):

```bash
touch ~/[AI_NAME]/.knowledge-work-plugins-stage-complete
echo "$(date -Iseconds) — Stage 0.5 complete" >> ~/[AI_NAME]/logs/install.log
```

### Why this stage is here and not later

These plugins are foundational. Subsequent stages — especially the voice interview and any content skills — lean on `brand-voice` and `productivity`. Installing the backbone first means later stages can wire INTO them rather than around them.

### Reference

Full plugin list, optional add-ons, update flow, and the "wrap, don't fork" architectural rationale: see `KNOWLEDGE-WORK-PLUGINS.md` at the repo root.

---

## Stage 1 — 5-question voice interview (~10 min)

This is the **Section B-Express** from the original kick-off skill — kit-known-good, captures voice with real fidelity.

Invoke the kick-off skill's `B-Express` path directly:

```
Section B — Voice (5 questions)

B1. The one-line principle
> "If [BRAND/YOUR WORK] were a person walking into a room, what's
   the energy? One sentence."

B2. Target customer / audience
> "Tell me about the actual person reading [BRAND]'s output. Where
   do they shop? What do they aspire to? What do they fear?"

B3. Reference brands — tone
> "Three brands whose copy you'd genuinely kill for. Reading their
   stuff, you think 'yes — that's the world I should live in.'"

B4. Direct competitors — what NOT to do
> "Two brands in your direct space whose tone is wrong. What
   specifically grates?"

B5. Banned words / tropes
> "Words, phrases, or patterns that — if I ever wrote them in a
   draft for you — would make you reject the whole draft."
```

Capture answers verbatim. Write to:
- `~/[AI_NAME]/vault/Brand/Voice guide.md` (overwrite the Part 1 lightweight version)
- `~/[AI_NAME]/vault/Brand/Reference brands.md`
- `~/[AI_NAME]/vault/Brand/Do-not-use list.md`

Mark complete: `touch ~/[AI_NAME]/.voice-express-complete`

---

## Stage 2 — ElevenLabs voice library (optional, ~2 min)

Most users already set up their AI's real ElevenLabs voice in Part 1 (Stage 12). This stage is just the *upgrade path* — the big library.

**If they skipped ElevenLabs in Part 1** (stayed on the robotic Mac voice): run the Part 1 Stage 12b/12c flow now — open Dani's referral link `https://try.elevenlabs.io/ppfxpf0bci79`, free account, API key via the clipboard trick into `~/.config/[ai-name]/elevenlabs/.env`, set **Brian** as the voice, test with `say-to-mac.sh`. Show the one-line referral disclosure if it's the first referral link this session.

**If they already did:** surface the upgrade softly, once — a nudge, not a sale:

> "Quick one — you're on the ElevenLabs free tier, which covers your voice notes nicely. If you ever want the *big* library — thousands of voices, every accent and character, plus more speaking time — that's their paid plan. Totally optional; Brian stays unless you pick someone else. You can browse the whole library free with the account you already made."

If they want to look, give them Dani's referral link: `https://try.elevenlabs.io/ppfxpf0bci79`. If they upgrade and choose a new voice, write its ID to `ELEVENLABS_VOICE_ID` in their elevenlabs `.env`. No gate, no pressure.

Mark complete: `touch ~/[AI_NAME]/.elevenlabs-configured`

---

## Stage 3.5 — Obsidian Web Clipper (browser → vault, ~3 min)

Vault feeder. The Obsidian Web Clipper pumps the open web — articles, blog posts, YouTube pages, anything readable in a browser — into the vault as clean markdown, in one click.

Combined with the AI's vault-awareness, this means *"summarize what I've clipped this week"*, *"find the article I clipped about retention"*, or *"pull the strongest arguments from my last 3 clippings on X"* all just work — without the user ever copy-pasting an article body into chat.

> "Want to add the Obsidian Web Clipper? It's the cleanest way to feed articles, transcripts, and pages from the open web straight into your vault. ~3 min to install."

If yes:

1. Open Chrome (or Edge / Firefox / Safari) → install the **Obsidian Web Clipper** extension from the browser's store. Direct link: https://obsidian.md/clipper
2. Click the extension icon → it asks where your vault is. Point it at `~/[AI_NAME]/vault/`.
3. Recommend a folder inside the vault for clips: `vault/Clippings/` (Web Clipper creates it if missing). This matches the Hab schema convention for raw source material.
4. Pick the default template — the bundled "Default" template handles most cases (articles, blog posts, news). Templates for recipes, papers, and YouTube exist for users with specific use cases.
5. Test: open any article in the browser, click the Web Clipper icon, save. Confirm a new markdown file appears in `~/[AI_NAME]/vault/Clippings/`.

Mark complete:

```bash
touch ~/[AI_NAME]/.obsidian-clipper-configured
```

After install: the AI reads everything in `vault/Clippings/` as context — same way it reads the rest of the vault. User clips, AI absorbs, queries spanning "what's in my head + what I've been reading" become trivial.

If the user sets up the LLM wiki (Stage 3.9), `Clippings/` becomes the wiki's intake: every clip can be filed into linked wiki pages with *"ingest this"*.

---

## Stage 3.7 — Vault backup (~5 min, strongly recommended)

The vault has been collecting [PARTNER_NAME]'s voice, projects, memory, brand rules, and clipped articles. It's the second brain. **Without backup, a Mac failure means starting over.**

Three options ranked easiest first. Pick at least one. Picking two is the right answer for anyone who values what they're building.

### Easiest: Time Machine

Plug in an external drive. macOS Time Machine backs up hourly, automatically, covers your whole Mac (not just the vault). ~3 min setup.

- ✅ Mac-native, fully automatic
- ✅ Covers everything (vault + skills + system + photos + whatever else)
- ✅ Version history — scroll back through any state of any file
- ⚠️ External drive required (one-time ~$60 for a small SSD)

Walk-through: System Settings → General → Time Machine → Add Backup Disk → pick the plugged-in drive. macOS handles the rest.

### Strongest (recommended): Private GitHub repo

Off-platform backup. Full version history. Restore from any commit. Works even if Apple or Obsidian disappear tomorrow.

- ✅ Disaster recovery + complete version history
- ✅ Free (private repos are unlimited)
- ✅ Works alongside Time Machine — two layers, not exclusive
- ⚠️ Requires GitHub account (free if not already) + ~5 min setup

Walk-through:
1. If user has no GitHub account, open https://github.com/signup via Chrome extension, help them through signup
2. Create a private repo named `[ai-name]-vault` via `gh repo create [ai-name]-vault --private --description "Backup of my AI's vault"`
3. Inside the vault folder, init git + add the right `.gitignore` + initial commit + push. Exclude: `_recovery/`, any `.env` files, anything secret, **`.smart-env/`** (Smart Connections' embeddings — large, and rebuildable from the notes; it's been indexing since Part 1 so this folder already exists), and **`.obsidian/workspace*.json`** (Obsidian's window state — churns on every pane move and would spam the history)
4. Schedule via launchd: nightly `git add . && git commit -m "vault backup $(date)" && git push` from `~/[AI_NAME]/.kit/scripts/git-vault-backup.sh`. The script lives at `~/[AI_NAME]/` (unprotected) so launchd can run it without TCC issues. The git push is a network call that doesn't touch `~/Documents/`.

Mark complete:

```bash
touch ~/[AI_NAME]/.github-vault-backup-configured
```

### Alternative: Obsidian Sync ($5–10/mo)

Vault-only sync with version history (1 year) and end-to-end encryption. Best if [PARTNER_NAME] wants the vault on multiple devices (Mac + iPad + iPhone via Obsidian Mobile).

- ✅ Multi-device + versioned + encrypted (not even Obsidian can read your notes)
- ⚠️ Paid subscription
- ⚠️ Vault-only — doesn't back up [AI_NAME]'s skills, scripts, config, recovery template

Walk-through in Obsidian app: Settings → Core plugins → Sync → enable → log in → pick which folders to sync. Point at `~/[AI_NAME]/vault/`.

### Don't: iCloud Drive

We deliberately don't recommend iCloud Drive for the vault. iCloud auto-sync requires moving files into `~/Documents/`, but macOS privacy controls (TCC) block background programs from reading or writing there — which includes [AI_NAME]'s Telegram poller and nightly dreaming routine. Picking this option would break [AI_NAME]'s always-on features within 24 hours.

If a user insists on iCloud (e.g., for cross-device access), the right answer is **Obsidian Sync** instead — same multi-device benefit, doesn't fight macOS TCC.

(We learned this the hard way during Install #1 — the vault was placed in `~/Documents/`, and every background routine silently stopped reading it.)

---

## Stage 3.8 — Deepen the memory layer (~10 min, strongly recommended)

This is where [AI_NAME]'s memory goes from "good" to "compounding hard." Two additions, both optional but high-leverage. The core memory loop (daily-memory → nightly dreaming → long-term + weekly curator) already shipped in Part 1. This stage adds the two pieces that make recall and knowledge-keeping genuinely powerful.

### Part A — Semantic search (find by meaning, not just words)

The problem: normal search only finds the exact words you type. Search "pricing" but the note says "revenue" → normal search finds nothing. Semantic search understands they mean the same thing.

> "Want me to add semantic search? Right now I find notes by exact words. With this, I find them by MEANING — search 'pricing' and I'll also pull up the notes where you wrote 'revenue' or 'what to charge', because I understand those are the same idea. It piggybacks on a free Obsidian plugin and stays 100% on your Mac. ~5 min."

If yes:

1. **Smart Connections should already be installed and indexing** — Part 1 Stage 10 sets it up the moment the vault opens, so the index has been growing since day one. Verify: Obsidian → Settings → Community plugins → Smart Connections present + enabled, and `ls ~/[AI_NAME]/vault/.smart-env/` shows an index.
   **If it's missing** (they declined it, or their install predates this): Settings → Community plugins → **"Turn on community plugins"** (it's OFF by default — Restricted Mode; this is the step everyone forgets) → Browse → "Smart Connections" → Install → Enable. Then give it a minute to index.
2. **Confirm it's local-only.** Smart Connections → settings → verify it's local-first (default `TaylorAI/bge-micro-v2` model, no cloud API key set). This keeps notes on the Mac.
3. **Check the index is warm.** By now it should have months of notes embedded, not seconds' worth — that's the payoff of installing it in Part 1.
4. **Set up the skill's Python environment:**
   ```bash
   python3 -m venv ~/.claude/skills/vault-semantic-search/.venv
   ~/.claude/skills/vault-semantic-search/.venv/bin/pip install sentence-transformers
   ```
5. **Install the skill.** Copy the `vault-semantic-search` skill folder from `~/[AI_NAME]/.kit/setup-guide/skill-templates/vault-semantic-search/` into `~/.claude/skills/`. Its search script ships in `scripts/search.py`, already tested; nothing to build. It needs the vault's location: run it with `--vault ~/[AI_NAME]/vault`.
6. **Gitignore the embeddings** if the vault is in a git repo: add `.smart-env/` to `.gitignore` (it's large + rebuildable).
7. **Test it:** *"Semantic search the vault for [a concept you've written about in different words]."* Confirm it surfaces conceptually-related notes that keyword search would miss.

Mark complete:

```bash
touch ~/[AI_NAME]/.semantic-search-configured
```

### Part B — The Brain (the filing cabinet that builds itself)

The richest memory upgrade. Part 1 ships simple flat `People/` and `Companies/` folders — light notes. Part B adds `_Brain/` — the AI's compiled, *cited*, *timelined* knowledge filing cabinet. One living document per person, company, concept, or source, where every fact has a receipt and the history is never erased.

> "Want me to add the Brain? Right now I keep light notes on people and companies. The Brain upgrades that into a proper memory: one living file per person, company, or idea in your world. Every fact I write has a receipt — where I learned it — so I can never make things up. And each file has a 'now' section that I keep current, plus a timeline of how the picture changed over time. Six months from now you ask 'what do I know about this client?' and get a complete, sourced answer pulling from every meeting and email — even the ones you forgot. ~5 min to set up the structure; it fills itself as we work."

If yes:

1. **Install the `_Brain/` scaffold** into the vault:
   ```bash
   OVERLAY="$HOME/[AI_NAME]/.kit/setup-guide/vault-scaffold/brain-layer"
   cp -R "$OVERLAY/_Brain" "$HOME/[AI_NAME]/vault/_Brain"
   ```
   This creates `_Brain/people/`, `_Brain/companies/`, `_Brain/concepts/`, `_Brain/sources/`, and `_Brain/_pending/`, each with a README and a page template.
2. **Tell [AI_NAME] the Brain rules** (they're documented in the vault's `CLAUDE.md`, which the scaffold install updates): every fact gets an inline citation; only notable entities (2+ mentions, or 1 substantive) get a page; singletons go to `_pending/`; the top of each page is rewritten as truth changes, the timeline below the divider is append-only and never deleted.
3. **The Brain fills itself.** Going forward, when a notable person or company surfaces in a session, [AI_NAME] creates or updates their `_Brain/` page with cited facts. The `wrap-up` and `dreaming` skills feed it. The user does nothing — it accretes.

Mark complete:

```bash
touch ~/[AI_NAME]/.brain-layer-configured
```

**The reflection firewall (important):** the `_Brain/` is the AI's filing cabinet (Substrate B). It is deliberately separate from the user's own reflective notes (Substrate A — `Notes/`, `_context/`, daily logs). Any reflection-style commands read ONLY the user's own writing, never `_Brain/` — so the AI's compiled inferences never get mistaken for the user's own thoughts. This is documented in the vault `CLAUDE.md`.

---

## Stage 3.9 — Your vault as a wiki (~20 min, recommended)

Best after Stage 3.5 (Web Clipper) and 3.8 (semantic search and the Brain). The full guide, written for the user, is `docs/obsidian-llm-wiki.html`.

The problem: clippings pile up and nothing connects them. This stage turns the vault into an LLM wiki, following Andrej Karpathy's pattern. [PARTNER_NAME] clips what's worth keeping. [AI_NAME] reads each source once, files it into linked pages (sources, people and organisations, ideas), keeps a one-page overview of what the wiki currently believes, and answers questions with links to the pages behind the answer.

> "Want to turn your vault into a wiki? You clip articles you care about. I read each one once, file it into linked pages, and keep a one-page overview of what we've learned. Next month you ask a question and the answer is already organised, with links as proof. It moves a few template folders around, but only after a full backup and your OK. About 20 minutes."

If yes:

1. **Obsidian first.** The wiki is made to be browsed in Obsidian. If Obsidian was skipped in Part 1 (Stage 6), offer it again now: https://obsidian.md/download, then open `~/[AI_NAME]/vault` with **"Open folder as vault"** exactly as in Part 1, Stage 10, and check the sidebar shows the vault's folders. If they still decline, say plainly that the wiki works without it, but they won't be able to browse it.
2. **Show the guide:** `open ~/[AI_NAME]/.kit/docs/obsidian-llm-wiki.html`. Its Part 1 is what's about to happen; Part 2 is how they'll use it.
3. **Run the setup prompt.** Read `~/[AI_NAME]/.kit/docs/obsidian-llm-wiki/setup-prompt.md` and follow it step by step in this session. It backs up the vault, asks whether they keep a daily journal, protects [AI_NAME]'s own `CLAUDE.md`, shows the plan and waits for "go", then installs the wiki rules as the vault's `CLAUDE.md`. If Stage 3.8 already set up semantic search, it keeps that.
4. **Obsidian settings are the user's clicks** (daily notes, Web Clipper folder, attachment folder, download-attachments hotkey). Guide them one at a time, or drive them with computer use if it's on.
5. **The setup conversation.** The prompt ends by offering six short questions about what the wiki is for. Run it: that's what makes the wiki theirs.
6. **Test:** clip one article, say *"ingest the new clipping"*, then ask a question about it.

Mark complete:

```bash
touch ~/[AI_NAME]/.llm-wiki-configured
```

---

## Stage 4 — Optional skills menu (varies)

### Optional skills

> "These are skills you can install now or anytime later. Each is independent. Tell me which interest you and I'll install just those — or say 'skip' and we move on.
>
> - **Hyperframes** — animated explainer videos by conversation (~5 min install). Need an animation? Tell me the script, I draft, you tweak.
> - **Video Use** — cut filler words + dead air from recordings (~5 min). For talking-head videos, podcasts, course content.
> - **Content pipeline** — multi-stage content production (research → draft → quality → distribute). For users producing newsletter/long-form regularly (~10 min).
> - **Document transformations** — mines meeting transcripts for case-study material (~5 min).
> - **Book mirror** — turns books you've read (via Readwise highlights) into chapter-by-chapter synthesis docs (~5 min).
> - **Superpowers** *(for builders only)* — a process framework by Jesse Vincent that makes your AI plan → test → verify before it ships code. Genuinely strong **if you build software or run complex, multi-step technical projects**. For everyday drafting, briefs, and admin it's overkill — it adds a little overhead to simple tasks — so I'd only set it up if that's you. Free, open-source. Install: `/plugin install superpowers@claude-plugins-official`."

Install only what user picks. Each installs via the standard skill pattern — copy template, substitute placeholders, optionally load launchd job. (Superpowers is a plugin, not a template — it installs via the `/plugin install` command above.)

### Optional MCP server additions

MCPs are different from skills — they're external servers that expose tools to the AI. One MCP server, one capability. Installed via Claude Code Settings → MCP servers → Add new → paste the server's command from its README.

> "Two MCP servers worth considering at this stage:
>
> - **youtube-transcript MCP** — fetches transcripts from any YouTube video by URL. Lets your AI summarize a video, fact-check claims in it, or pull quotes — without copy-paste. Pairs nicely with the Obsidian Web Clipper (clip the video page, fetch the transcript, ask for a synthesis). ~3 min to install. Search the Anthropic MCP registry or upstream for the current canonical package."

If the user adds youtube-transcript MCP, verify it works:

```
Test query: "Pull the transcript of this video: https://www.youtube.com/watch?v=<id>"
```

The AI should return the full transcript text without scraping issues.

Mark complete:

```bash
touch ~/[AI_NAME]/.youtube-transcript-mcp-configured
```

---

## Stage 5 — Part 2 close

```bash
touch ~/[AI_NAME]/.part-2-complete
date -Iseconds > ~/[AI_NAME]/.part-2-date
echo "$(date -Iseconds) — PART 2 COMPLETE" >> ~/[AI_NAME]/logs/install.log
```

Read the end-of-Part-2 value-prop close:

> "Now I really know you.
>
> **What you have now:**
> - A voice profile from the 5-question interview — drafts will land closer to how you'd actually write them
> - Premium voice replies (if you upgraded to ElevenLabs)
> - The optional skills you added
>
> **What this means for you:**
> - Drafts get sharper week over week — the learnings loop is running
> - Your meetings stop disappearing. Your AI can answer 'what did Sam and I decide last Tuesday?' three weeks later.
>
> **Example use cases now possible:**
> - *'Mine my client meetings this week for case study material'* → Research pulls verbatim moments from transcripts
> - *'What's the pattern in what my members keep asking?'* → Research synthesizes across captured meetings
> - *'What's on my plate tomorrow?'* — texted from your phone while you're cooking, answered in your AI's voice
>
> **What's next:** the kit gets better over time. Run `/update` to pull new skills as they ship. The 100-question deep voice interview is still on the table when you want it — that's a separate 90-min sitting. For now, just use what you have. It compounds."

**Final beat — the newsletter, once, ever.** This is the genuine end of the whole install. Say this verbatim, then never mention it again anywhere in the running experience:

> *"That's the whole thing, [PARTNER_NAME] — [AI_NAME] is fully yours now. One last thing and then I'll never bring it up again: if you want to follow how the kit grows — new skills, new tricks, what's landing for other operators — the person who built me runs a free weekly newsletter, **The All Gravy Times**. → **allgravytimes.com**. Opt in if it's useful to you; if not, we're done, and everything here is yours forever."*
>
> *Presented with [Beehiiv](https://www.beehiiv.com?via=daniel-joachim-nielsen).*

Send the credit line as markdown so Beehiiv is a live link. Point to the site; never collect their email in the conversation. The *"I'll never bring it up again"* is load-bearing — it's what makes the free-kit positioning credible.

---

## What's still in your back pocket after Part 2

| Skill / Feature | When to invoke |
|---|---|
| 100-Q deluxe voice interview | When you've used the AI for a few weeks and want maximum voice fidelity. Separate 90-min session. Best done on a quiet afternoon. |
| New skills shipping via `/update` | The kit gets new skills over time. `/update` (or "check for updates") pulls them. |
| `create-skill` (when shipped) | Meta-skill that walks you through creating new skills from the kit's template + the three-scenario test. |
| LLM Council | "council this" / "pressure-test this" for any locked decision with real stakes. |

---

*Part 2 of 2 — Reach. Part 1 (Foundation) is the prerequisite — see INSTALL.md.*
