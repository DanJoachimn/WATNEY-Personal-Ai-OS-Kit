# Changelog and lessons from real installs

The playbooks say what to do. This file keeps the *why*, so the install stays short and the reasons aren't lost.

## 2026-09-16 — workshop prep

- Stages renumbered 1–14 in one pass. The old 0a / 0b / 0c / 0 / 0.5 / 1.5 / 2.5 / 4.5 / 5.5 / 8.5 / 9.3 numbering was a fossil of how the install grew.
- `/waitwhat`, Wispr Flow and the two capability switches are all in Stage 1. Talking beats typing for the whole hour, and the escape hatch has to exist before anything confusing happens.
- `/waitwhat` and `llm-council` install right after the safety check, where the install first promises them. Before this, `/waitwhat` was promised in minute two and installed twenty minutes later.
- Morning brief removed from the kit. It was promised at the close of Part 1, in First Wins and in the connectors pitch, and no skill shipped it. Now it's an idea planted in Part 2 ("brief me on my newsletters"), not a feature.
- Meeting capture (Granola) and the awake/Amphetamine steps removed.
- Part 1 now ends on First Wins. Connectors moved to the start of Part 2; the newsletter is mentioned once, at the end of Part 2.
- The security audit reads what can run (scripts, plists) and greps the prose. Reading every markdown file didn't fit a Pro session.
- The aha voice note is drafted by the installing AI itself. The helper subagents live in the AI's folder and aren't loaded in the install session, so "I delegated to Content" wasn't true.
- One memory: `vault/Memory/daily-memory.md` (day) → `long-term.md` (night). `notes.md` is a signpost only. Before, CLAUDE.md sent daytime memory to `notes.md`, where the night shift never read it.
- Homebrew is handed to the user as a Run button in the desktop app instead of "open Terminal". Fallback to Terminal if the run panel doesn't accept the password.
- The kit's Telegram poller wakes the answering machine for any message left unprocessed over five minutes, instead of waiting for the next message to arrive.
- The AI's home folder is `~/<name>/`. Stage 4 used to say `~/Documents/<name>/`, the one place that kills the background jobs.

## Lessons from real installs (the reasons behind the odd rules)

- **`~/Documents/` and `~/Desktop/` break background jobs.** macOS privacy (TCC) blocks launchd jobs from reading them. Install #1 (2026-05-18) put the vault in Documents and every routine silently died within a day. The kit never installs there and tells the user once why.
- **`ffmpeg` was a hidden dependency.** Telegram voice notes failed silently without it. `setup.sh` now installs it first.
- **Users met the memory jobs and the messenger before they saw the vault.** The Obsidian reveal moved ahead of Telegram.
- **`open -a Obsidian <folder>` does not register a vault.** The reveal has to use "Open folder as vault" and verify the sidebar before saying anything.
- **The health check runs on nothing but bash.** A Homebrew Python upgrade once killed every maintenance job and the watchdog watching them in the same moment. The alarm lives on a different substrate than what it watches.
- **Connectors asked for in minute one burn trust.** Nobody hands a stranger their inbox before seeing one thing work.
