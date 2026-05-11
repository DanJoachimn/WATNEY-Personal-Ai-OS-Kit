# Screenshot Inventory

> The AI references images in this folder during install + ongoing operation. Each filename below is what the AI's playbooks (`INSTALL.md`, kick-off SKILL.md, guides) expect to fetch from the repo. **Shoot these in one ~20-min batch on a fresh-ish Mac, save with the exact filenames listed.**

---

## How the AI uses these

During install + setup conversations, the AI fetches and shows the image inline:

```markdown
Here's what you're looking for — see the toggle in the upper right of this screen:

![iCloud Drive toggle](https://raw.githubusercontent.com/[USER]/partner-ai-kit-personal/main/assets/screenshots/icloud-drive-toggle.png)

Toggle it on, then tell me "done."
```

Claude Code Desktop renders the image inline. The user sees the exact thing they need to find. No interpretation needed.

---

## The batch list — 12 screenshots needed

| Filename | What to capture | Where to shoot |
|---|---|---|
| `claude-code-download.png` | The Claude Code download button on claude.com/code, highlighted | Browser on claude.com/code |
| `claude-code-applications.png` | Finder window showing Claude Code.app in /Applications/ | Finder, navigated to /Applications/, Claude Code visible |
| `claude-code-first-launch.png` | The Claude Code Desktop window on first launch (signed in, empty chat ready) | Open Claude Code Desktop |
| `icloud-drive-toggle.png` | System Settings → Apple ID → iCloud → iCloud Drive pane with both toggles visible (main iCloud Drive + "Desktop & Documents Folders") | System Settings → Apple ID → iCloud → iCloud Drive |
| `system-settings-mic-permission.png` | System Settings → Privacy & Security → Microphone, with one app's toggle visible (any app — for visual reference) | System Settings → Privacy & Security → Microphone |
| `system-settings-screen-recording.png` | Same as above but Screen Recording pane | System Settings → Privacy & Security → Screen Recording |
| `xcode-clt-popup.png` | The "Command Line Developer Tools" install popup that appears when running `xcode-select --install` | Trigger by running `xcode-select --install` in Terminal |
| `granola-install.png` | The Granola download page from granola.ai or the app's first-launch screen | granola.ai or first launch |
| `granola-auto-record.png` | Granola's Settings → Recording panel with "Auto-record meetings" visible | Granola → Settings → Recording |
| `whisper-flow-menubar.png` | The Whisper Flow menu bar icon, zoomed in | Top-right of menu bar after WF is running |
| `siri-shortcuts-import.png` | Siri Shortcuts app showing the "Import from iCloud" or .shortcut file double-click moment | Shortcuts.app on macOS or iOS |
| `obsidian-vault-open.png` | Obsidian with the user's vault open, showing the sidebar with Brand/, Memory/, Projects/ folders | Obsidian with the kit's starter vault loaded |

---

## Optional / advanced (Phase 2 — not required for soft launch)

These improve the experience but the kit works without them:

| Filename | What to capture |
|---|---|
| `1password-cli-link.png` | 1Password app → Settings → Developer → "Integrate with 1Password CLI" toggle |
| `1password-create-vault.png` | The "New Vault" dialog in 1Password app |
| `flexybox-api-key.png` | Flexybox admin panel showing where the API key is generated (only needed for HTC repo) |
| `telegram-botfather-token.png` | Telegram chat with @BotFather showing where the bot token appears after `/newbot` |

---

## Recording instructions

**Resolution:** 1920×1080 or higher. Retina captures are fine but compress to ~150-300 KB per file (the raw retina PNG can be 5+ MB which makes the AI's WebFetch slow).

**Compression after capture:**

```bash
# Compress all PNGs in this folder to ~70% quality (good balance)
for f in *.png; do
  sips -s formatOptions 70 "$f" --out "compressed-$f"
  mv "compressed-$f" "$f"
done
```

**Annotation tips:**
- Where the user needs to click → red circle around the target (use macOS Preview's Markup, or [Skitch](https://evernote.com/products/skitch))
- Use arrows sparingly; the AI's chat caption usually does the directional work
- Crop tightly — don't include irrelevant chrome (browser tabs, dock, etc.) unless they help orient

**Filename rules:**
- Lowercase, dashes, no spaces, `.png` extension
- Match the filename column above EXACTLY — the AI's playbooks reference these strings literally

---

## Why this is a batch task

Shooting these one-at-a-time during install drags out development. Doing them in one ~20-min sitting:
1. Forces you to walk the install yourself end-to-end (catches issues)
2. Keeps visual consistency (same lighting, same compression, same annotation style)
3. Means the kit can launch the moment screenshots land — no per-feature blocker

Recommended order:
1. Start with a fresh Mac account (or close to it) so screenshots look like what an HTC owner will actually see
2. Walk through the install yourself, screenshotting at each visual moment
3. Save each file directly into this folder with the right filename
4. Run the compression command at the end

---

*Update this list as the install flow evolves. The AI's playbooks reference these exact filenames — adding a new screenshot means updating the playbook to reference it too.*
