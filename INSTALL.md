# INSTALL.md — Live install playbook for the Partner AI Kit (Personal)

> **This file is read by an AI agent (Claude Code) at install time.** A non-technical user has just pasted a prompt asking you to install the Partner AI Kit for them. They've never used Claude Code before. They're not a developer. Your job is to walk them through setup like you're talking to a friend who's smart but new — using screenshots, native dialogs, and plain English.

---

## Read this carefully before doing anything

You're talking to a non-developer. They want their AI working, not configured. Every choice you make should reduce their cognitive load.

**Hard rules for the install conversation:**

1. **No jargon without translation.** First time you mention `launchd`, say *"launchd — the Mac's built-in scheduler. It's how your AI runs jobs in the background, like a Mac calendar entry."* Same for git, MCP, vault, subagent, plist, env file.
2. **Confirm before every write.** *"I'm about to create the folder `~/Documents/[ai-name]/`. OK to proceed?"* Wait for yes.
3. **Show, don't tell.** When the user has to click something, show them the screenshot from `assets/screenshots/`. When they have to toggle a system setting, open the right pane via `osascript` so they don't navigate menus.
4. **Visible progress.** After each step, confirm with a checkmark line: `✅ Created Documents/[ai-name]/`. The user should see motion every 10-20 seconds.
5. **No raw error output.** If something fails, translate the error to plain English. Never paste a stack trace into the chat unless the user explicitly asks.
6. **Pause for physical actions.** When you need them to download an app, click a system prompt, or copy a value from a website — wait for them to confirm "done" before continuing.

---

## Stage 0 — Greeting + tone-setting (~30 sec)

Open with warmth. Set expectations. Get permission to proceed.

Recommended opening:

> "Hi! I'm about to set up your Partner AI Kit. Before I start, here's what's going to happen over the next ~25 minutes:
>
> 1. I'll set up a home folder for your AI on your Mac (5 min)
> 2. I'll install a few small pieces of infrastructure — things like a memory layer and a backup system (5 min)
> 3. Then we'll have a 15-min conversation where I get to know you — your voice, your projects, your taste. That's what makes me actually useful instead of generic.
>
> Total: ~25 min. You'll be doing nothing technical. I'll show you screenshots and walk you through anything you need to click. Sound good?"

Wait for confirmation. If they hesitate or ask questions, answer briefly. Don't proceed until you have a clear go-ahead.

---

## Stage 1 — Choose the AI's name (~2 min)

Ask:

> "First — what should I call myself? Three patterns that work:
>
> - **Named after someone you admire** — real or fictional. *Watney* (from The Martian), *Coco* (Chanel), *Atticus* (To Kill A Mockingbird). The reference does a lot of personality work.
> - **Named for a vibe** — *Mira* for clarity, *Coco* for warmth, *Echo* for resonance.
> - **Named for the role** — *Coach*, *Atlas*, *Cornerman*. Boring but sometimes right.
>
> Whatever you pick is your AI's name forever, so 5 min on this is worth it. Renamed AIs feel like tools; AIs that grew into their name feel like partners."

Wait for the name. Confirm spelling. Use lowercase-no-spaces for the folder (e.g., "Watney" → `~/Documents/watney/`).

From this point forward, **address yourself by the chosen name in every message** — *"OK, I'm Coco now. Setting up Coco's home folder..."*

Save the name to a variable in your working memory. Refer to it as `[AI_NAME]` in this playbook.

---

## Stage 2 — Verify Claude Code Desktop is installed (~1 min)

Check if Claude Code Desktop exists:

```bash
ls -la "/Applications/Claude Code.app" 2>/dev/null
```

If found → proceed to Stage 3.
If not found → STOP and surface:

> "Quick check — I need Claude Code Desktop installed on your Mac. (You're already using it to talk to me, but I want to make sure it's the right install.) Run this in your terminal:
>
> `ls -la '/Applications/Claude Code.app'`
>
> If you see a line that mentions Claude Code.app, you're good. If you get "No such file," download it from https://claude.com/code — drag to Applications — re-launch and re-paste the install prompt. Tell me when you see it."

---

## Stage 3 — Verify iCloud Drive is on (~2 min, includes user action)

Run a quick check:

```bash
defaults read MobileMeAccounts Accounts 2>/dev/null | grep -c "AccountID" || echo 0
```

If output is `0` or no Apple ID is signed in → STOP and surface:

> "I need iCloud Drive on so your AI's memory survives a Mac swap or factory reset. Opening System Settings to the right spot now..."

Then run:

```bash
open "x-apple.systempreferences:com.apple.preferences.AppleIDPrefPane"
```

Show this screenshot (fetch from `https://raw.githubusercontent.com/DanJoachimn/Partner-Ai-Kit-Personal/main/assets/screenshots/icloud-drive-toggle.png`):

> "Settings just opened to your Apple ID pane. Click **iCloud Drive** in the list. Make sure both the main toggle AND 'Desktop & Documents Folders' are green. Tell me when both are on."

Wait for confirmation. If user says it's already on, proceed.

If user pushes back ("I don't want iCloud / I don't have an Apple ID") → continue install with a warning logged in `~/Documents/[ai-name]/_recovery/WARNINGS.md`: *"iCloud Drive not enabled at install time. AI's memory will not survive a Mac swap. Re-enable later by toggling in System Settings → Apple ID → iCloud Drive."*

---

## Stage 4 — Create the home folder + clone the repo (~30 sec)

Run:

```bash
mkdir -p "$HOME/Documents/[AI_NAME]"
cd "$HOME/Documents/[AI_NAME]"
git clone https://github.com/DanJoachimn/Partner-Ai-Kit-Personal.git .kit
```

If `git clone` fails (no git installed) → install Xcode Command Line Tools:

```bash
xcode-select --install
```

Wait for the popup. Tell the user:

> "A macOS popup just appeared asking to install Command Line Tools — that's the basic dev kit your Mac needs to run things like git. Click 'Install,' wait ~5 min, then tell me when it says 'Done.'"

Retry the clone after install completes.

Confirm with checkmark:

> "✅ Created `~/Documents/[ai-name]/.kit/` and fetched the latest version of the kit."

---

## Stage 5 — Build the vault scaffold (~10 sec)

Copy the vault scaffold from `.kit/SETUP GUIDE (Input Ai)/vault-scaffold/starter/` into `~/Documents/[ai-name]/vault/`:

```bash
cp -R "$HOME/Documents/[AI_NAME]/.kit/SETUP GUIDE (Input Ai)/vault-scaffold/starter/" \
      "$HOME/Documents/[AI_NAME]/vault/"
```

Substitute placeholders in the copied files. Replace every occurrence of:
- `[AI_NAME]` → the actual name
- `[PARTNER_NAME]` → ask user: *"What name should I call you by? First name is fine."*
- `[BRAND]` → leave for now, kick-off conversation fills it
- `YYYY-MM-DD` in frontmatter → today's date

Use a single sed run:

```bash
find "$HOME/Documents/[AI_NAME]/vault/" -type f -name "*.md" -exec \
  perl -i -pe "s/\[AI_NAME\]/[AI_NAME]/g; s/\[PARTNER_NAME\]/[PARTNER_NAME]/g;" {} \;
```

Confirm:

> "✅ Built your vault — folders for Brand, Projects, Memory, People, Companies, Notes, and Meetings. Empty for now; we'll fill the important parts in the kick-off interview."

Show a mermaid diagram of what was just created:

```mermaid
graph LR
    A[~/Documents/[AI_NAME]] --> B[vault/]
    A --> C[.kit/]
    A --> D[_recovery/]
    B --> E[Brand/]
    B --> F[Memory/]
    B --> G[Projects/]
    B --> H[People/]
    B --> I[Notes/]
```

---

## Stage 6 — Install user-level skills (~10 sec)

Copy the kit's skill templates to `~/.claude/skills/`:

```bash
SKILLS_SRC="$HOME/Documents/[AI_NAME]/.kit/SETUP GUIDE (Input Ai)/skill-templates"
SKILLS_DST="$HOME/.claude/skills"

mkdir -p "$SKILLS_DST"

for skill in kick-off wrap-up dreaming voice-compile update; do
  cp -R "$SKILLS_SRC/$skill" "$SKILLS_DST/$skill"
  # Substitute placeholders
  find "$SKILLS_DST/$skill" -type f -name "*.md" -exec \
    perl -i -pe "s/\[AI_NAME\]/[AI_NAME]/g; s/\[PARTNER_NAME\]/[PARTNER_NAME]/g;" {} \;
done
```

Confirm:

> "✅ Installed 5 core skills: kick-off (the first-conversation interview), wrap-up (end-of-session learnings), dreaming (overnight memory compression), voice-compile (turns voice interview transcripts into a portable voice file), and update (fetches kit updates from GitHub when I tell you so)."

---

## Stage 7 — Install scheduled jobs (launchd) (~10 sec)

For each scheduled skill (dreaming is the only one in the base kit), render the plist template and load it:

```bash
USER=$(whoami)
PLIST_SRC="$HOME/.claude/skills/dreaming/dreaming.plist.template"
PLIST_DST="$HOME/Library/LaunchAgents/com.${USER}.[AI_NAME].dreaming.plist"

mkdir -p "$HOME/Library/LaunchAgents"
mkdir -p "$HOME/Documents/[AI_NAME]/logs"

sed -e "s/\[USER\]/$USER/g" -e "s/\[AI_NAME\]/[AI_NAME]/g" "$PLIST_SRC" > "$PLIST_DST"

launchctl load "$PLIST_DST"
launchctl list | grep dreaming
```

Confirm:

> "✅ Wired up the overnight memory routine. Every night at 02:00, your AI will compress that day's memory while you sleep. You can also trigger it manually anytime by saying 'run dreaming.'"

---

## Stage 8 — Create the recovery file (~5 sec)

```bash
mkdir -p "$HOME/Documents/[AI_NAME]/_recovery"
cat > "$HOME/Documents/[AI_NAME]/_recovery/env-template.txt" <<'EOF'
# Recovery template — copy back to ~/.config/[ai-name]/.env on a new Mac.
# Get the actual secret values from your password manager or 1Password vault.
OPENAI_API_KEY=
ELEVENLABS_API_KEY=
ELEVENLABS_VOICE_ID=
TELEGRAM_BOT_TOKEN=
EOF
```

Tell the user:

> "I created a recovery file at `~/Documents/[ai-name]/_recovery/env-template.txt`. It's a checklist of what API keys you'll have once you wire up things like voice replies and Telegram. If your Mac ever dies, you'll see what to re-paste from your password manager. You can ignore it for now."

---

## Stage 9 — Set up the AI's CLAUDE.md (~5 sec)

The CLAUDE.md template was copied as part of the vault scaffold. Now wire it into the AI's home folder so every new Claude Code session in `~/Documents/[ai-name]/` reads it first:

```bash
# CLAUDE.md should already exist in vault/. Symlink at home root so Claude Code finds it.
ln -sf "$HOME/Documents/[AI_NAME]/vault/CLAUDE.md" "$HOME/Documents/[AI_NAME]/CLAUDE.md"
```

Confirm:

> "✅ Wired up your AI's operating manual. From now on, any Claude Code session opened from `~/Documents/[ai-name]/` will load it automatically and behave consistently."

---

## Stage 10 — Hand off to the kick-off interview (~15 min)

The hard infrastructure is done. Now run the conversational onboarding — voice, brand, projects, working style.

Trigger the kick-off skill:

> "OK — the technical stuff is in place. From here, it's just us talking. The next ~15-25 minutes is the kick-off conversation: I get to know you, your brand, your projects, and your voice. That's what makes me actually useful instead of generic.
>
> Want to start now, or take a break first?"

If start now → invoke `~/.claude/skills/kick-off/SKILL.md`. The kick-off skill takes over.

If break → set a flag file so kick-off auto-fires next session:

```bash
touch "$HOME/Documents/[AI_NAME]/.kick-off-pending"
```

Tell them:

> "All set. Next time you open Claude Code in `~/Documents/[ai-name]/`, I'll greet you and we'll pick up where we left off."

---

## Failure recovery

If anything in Stages 4-9 fails halfway through:

1. Log the failure with timestamp + stage to `~/Documents/[ai-name]/_recovery/install-log.txt`
2. Tell the user in plain English what went wrong and what they can do:
   > "Something didn't go to plan at Stage [X]. The good news: nothing's broken on your Mac. The fix: [specific one-liner]. Once you've done that, tell me 'try again' and I'll pick up where I stopped."
3. Make every failure resumable — re-running the install from Stage 4 should skip stages that already completed (check if `~/Documents/[ai-name]/vault/` already exists, etc.)

---

## Visual treatment reference

Throughout install, use these techniques (full library in `assets/snippets/macos-dialogs.md`):

| Moment | Technique |
|---|---|
| Need user to confirm a yes/no | `osascript -e 'display dialog "..." buttons {"Yes", "No"} default button 1'` |
| Open a System Settings pane | `open "x-apple.systempreferences:com.apple.preferences.AppleIDPrefPane"` |
| Notify them something's done | `osascript -e 'display notification "..." with title "[AI_NAME]"'` |
| Show a screenshot inline | Markdown image from `https://raw.githubusercontent.com/DanJoachimn/Partner-Ai-Kit-Personal/main/assets/screenshots/[name].png` |
| Show structural diagram | Mermaid block in chat (Claude Code Desktop renders) |

Use these liberally. The user's experience of install is mostly the visual layer.

---

## Variables this playbook expects

| Placeholder | When set | Example |
|---|---|---|
| `https://raw.githubusercontent.com/DanJoachimn/Partner-Ai-Kit-Personal/main` | Pre-fill before pushing repo | `https://raw.githubusercontent.com/dani/partner-ai-kit-personal/main` |
| `https://github.com/DanJoachimn/Partner-Ai-Kit-Personal.git` | Pre-fill before pushing repo | `https://github.com/dani/partner-ai-kit-personal.git` |
| `[AI_NAME]` | Stage 1 user answer | `watney`, `coco`, `atticus` |
| `[PARTNER_NAME]` | Stage 5 user answer | `Dani`, `Sam`, `Anna` |

The two `[REPO_*]` placeholders need a single search-and-replace before the repo is pushed for the first time. Do this in this file AND in `README.md` AND in `UPDATE.md`.

---

*This file is the live install playbook. Update it when the install flow changes; the next user's install will get the new version automatically.*
