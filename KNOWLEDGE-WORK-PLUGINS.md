# Knowledge Work Plugins — the upstream backbone

> Your kit installs and references a public Anthropic-maintained plugin marketplace. This file documents what's installed, what's optional, and how updates flow.

---

## What this is

`anthropics/knowledge-work-plugins` is a public marketplace of role-specific plugins (productivity, marketing, finance, sales, customer support, brand voice, and more) built and maintained by Anthropic. Each plugin is plain markdown + a small manifest — no code, no infrastructure, no build steps. They install via Claude Code's standard plugin system and update from upstream.

Your kit stands on top of this marketplace. A curated subset installs during kick-off. Updates flow whenever you run `/update`.

| | |
|---|---|
| **Upstream repo** | https://github.com/anthropics/knowledge-work-plugins |
| **Marketplace name** | `knowledge-work-plugins` |
| **License** | Per upstream — see the LICENSE in the marketplace repo |
| **Maintainer** | Anthropic |

---

## What this kit installs by default

These three are the personal-AI foundation. They install during Stage 0.5 of `INSTALL-PART-2.md`.

| Plugin | What it does | Why it's here |
|---|---|---|
| **productivity** | Tasks, calendars, daily workflows, work context. Syncs with calendar / email / chat. | The plumbing for your day. Direct fit for personal AI. |
| **enterprise-search** | One query across email, chat, docs, wikis. | Universal "find anything" utility. Every personal user wants this. |
| **brand-voice** *(Tribe AI, partner-built)* | Extracts voice from your existing writing, generates enforceable guidelines, validates AI output against them. | Production-grade version of voice extraction. Powers every voice-sensitive draft your AI ships. |

---

## Optional add-ons

These are NOT auto-installed. Your AI knows they exist and can install on request. Say something like *"add the marketing plugin"* or *"install cowork-plugin-management"* — the AI runs the install.

| Plugin | When you'd want it |
|---|---|
| **marketing** | If you produce content regularly (newsletter, social, blog, talks). Brand-voice integration + campaign planning + performance reporting. |
| **cowork-plugin-management** | Power-user only. Lets you build custom plugins for your own workflows. |

The full marketplace also includes plugins for sales, customer-support, finance, legal, data, product-management, engineering, design, HR, operations, bio-research — see the upstream README for the complete list. Most are overkill for a personal AI but available if your use case calls for them.

---

## How updates work

When you run `/update`, the kit's update flow:

1. Pulls the latest version of THIS kit from GitHub (the usual)
2. **Also runs** `claude plugin marketplace update knowledge-work-plugins`
3. Reports any installed plugins that have new versions
4. Surfaces any NEW plugins added to the upstream marketplace since your last update
5. Asks if you want to install any of them — never silent

You stay on the plugin versions you have until you say "update." No silent upstream rolls.

---

## Install / remove individual plugins (manual)

```bash
# One-time: add the marketplace (the kit does this for you during Stage 0.5)
claude plugin marketplace add anthropics/knowledge-work-plugins

# Install a specific plugin
claude plugin install [plugin-name]@knowledge-work-plugins

# Remove
claude plugin remove [plugin-name]@knowledge-work-plugins

# List everything you have installed
claude plugin list

# Pull upstream updates manually
claude plugin marketplace update knowledge-work-plugins
```

---

## Why "wrap, don't fork"

This kit deliberately does NOT copy Anthropic's plugin source into the repo. Instead:

- The plugins install fresh from upstream on first run
- They update automatically through Claude Code's standard plugin system
- Anthropic maintains the heavy lifting. The kit adds the personal-AI sauce on top.

If Anthropic ships a better `productivity` plugin tomorrow, you get it for free. If you fork, you maintain it forever.

This is the kepano pattern — stand on the shoulders, add the vertical.

---

## What this kit adds ON TOP of the upstream plugins

The kit's own skills (the ones in `setup-guide/skill-templates/`) are NOT replaced by the upstream plugins. They're personality-AI-specific things the marketplace doesn't cover:

- The orchestrator + 4 subagents architecture
- Telegram bridge + voice I/O
- Daily-memory dreaming
- The Learnings Loop
- Meeting capture via Granola
- Personal vault scaffolding

The upstream plugins handle the universal stuff (search, productivity, voice extraction). The kit handles the parts unique to running a personal AI.

---

## If something goes wrong

- **A plugin install fails during Stage 0.5** → the kit logs it, marks Stage 0.5 incomplete, and continues with the rest of Part 2. You can re-run Stage 0.5 anytime.
- **An upstream plugin has a regression** → roll back with `claude plugin install [name]@knowledge-work-plugins@<previous-version>` (if Claude Code's plugin CLI supports versioning at the time you read this) OR remove + reinstall + pin the version manually in your config.
- **Your kit's wrappers reference a plugin you removed** → the wrapper will error gracefully and surface "plugin X is needed for this — install it?" rather than crashing.

---

*Plugin awareness layer — read by the AI on session start so it knows which upstream skills it can delegate to. Updated 2026-06-06.*
