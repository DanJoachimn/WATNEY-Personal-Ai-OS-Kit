# macOS Visual Snippets Library

> Reusable `osascript` and `open` one-liners the AI uses during install + ongoing operation to give the user a visual, native-Mac experience instead of a terminal-feel. Reference this file when you need to ask, notify, or navigate System Settings on the user's behalf.

---

## Opening System Settings to a specific pane

Each one of these opens System Settings (macOS 13+) or System Preferences (macOS 12) to the exact pane the user needs to interact with. Use when you need them to toggle a setting — they should never have to navigate menus.

### Apple ID → iCloud

```bash
open "x-apple.systempreferences:com.apple.preferences.AppleIDPrefPane"
```

Use case: verify iCloud Drive is on during install.

### Privacy → Microphone

```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone"
```

Use case: grant Granola or Whisper Flow microphone access.

### Privacy → Screen Recording

```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
```

Use case: grant Granola screen-recording access (for capturing meeting audio).

### Privacy → Accessibility

```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
```

Use case: grant input/output automation access for advanced workflows.

### Privacy → Full Disk Access

```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
```

Use case: grant an app full disk access (rare; only for very specific tools).

### Notifications

```bash
open "x-apple.systempreferences:com.apple.preference.notifications"
```

Use case: enable banner notifications from the user's AI (most users prefer modal dialogs — see notification rules below).

### Keyboard → Shortcuts (Siri Shortcuts route)

```bash
open "/System/Applications/Shortcuts.app"
```

Use case: install Siri Shortcuts during Guide 09 setup.

---

## Native dialog boxes

For yes/no questions or attention-required moments that benefit from a Mac-native UI instead of a chat message.

### Yes/no dialog

```bash
osascript -e 'tell application "System Events"' \
          -e 'activate' \
          -e 'display dialog "iCloud Drive looks like it might be off. Want me to walk you through enabling it?" buttons {"Walk me through it", "I'\''ll handle it"} default button 1 with title "[AI_NAME] — Setup Check"' \
          -e 'end tell'
```

The user gets a Mac-native dialog. The result comes back as `button returned:Walk me through it` or `button returned:I'll handle it`.

### Three-button choice

```bash
osascript -e 'display dialog "The kit has a 1Password integration available. Want to set it up now?" buttons {"Yes, set it up", "Maybe later", "Skip permanently"} default button 1'
```

### Text input

```bash
osascript -e 'display dialog "What should I call you? (First name is fine.)" default answer "" with title "[AI_NAME]"'
```

Returns: `text returned:Dani, button returned:OK`

### Critical alert (red icon, attention-required)

```bash
osascript -e 'display alert "Setup paused" message "Something needs your attention before we continue. Check the chat for details." as critical'
```

---

## Notifications (banner / Notification Center)

Use sparingly. Native dialogs are more reliable for setup moments (banners can be silenced in macOS Focus modes).

### Simple notification

```bash
osascript -e 'display notification "Your AI is ready to chat" with title "[AI_NAME]" subtitle "Setup complete"'
```

### Notification with sound

```bash
osascript -e 'display notification "Update complete" with title "[AI_NAME]" sound name "Glass"'
```

Sound options: `Glass`, `Hero`, `Submarine`, `Tink`, `Funk`, `Ping`, `Pop`.

### Forcing a modal dialog instead of a notification (recommended for setup)

If the user has notifications silenced (macOS Focus mode, Do Not Disturb, etc.), `display notification` may be invisible to them. For anything install-critical, use `display dialog` (modal — always shown) instead of `display notification`.

```bash
# Bad — might be silenced
osascript -e 'display notification "Toggle iCloud now" with title "[AI_NAME]"'

# Good — always shown
osascript -e 'display dialog "Toggle iCloud Drive on, then click Continue." buttons {"Continue"} default button 1 with title "[AI_NAME] — Setup"'
```

---

## File/folder picker dialogs

When the user needs to choose a path (rare, but useful for advanced workflows).

### Choose a folder

```bash
osascript -e 'POSIX path of (choose folder with prompt "Choose where your vault should live (default is ~/Documents/[AI_NAME]/vault/):")'
```

### Choose a file

```bash
osascript -e 'POSIX path of (choose file with prompt "Pick a CSV to import members from:")'
```

---

## Opening apps with context

### Open Claude Code Desktop with a specific folder loaded

```bash
open -a "Claude Code" "$HOME/Documents/[AI_NAME]/"
```

Use case: hand off from install to active session.

### Open Obsidian with a specific vault

```bash
open "obsidian://open?vault=[VAULT_NAME]"
```

Use case: jump the user into their vault to view their new Brand/ or Memory/ folder.

### Open Whisper Flow

```bash
open -a "Whisper Flow"
```

Use case: prep for voice-interview deluxe path during kick-off.

### Open Granola

```bash
open -a "Granola"
```

---

## Clipboard interactions

### Copy text to clipboard

```bash
echo -n "the text to copy" | pbcopy
```

Use case: copy the kick-off magic prompt to clipboard at the end of install so the user just hits Cmd+V.

### Read from clipboard (used for clipboard-transfer pattern in Guide 03)

```bash
pbpaste
```

### Clear clipboard (security)

```bash
printf '' | pbcopy
```

Use case: after pasting an API key from clipboard into a `.env` file, immediately clear so it's not lying in clipboard history.

---

## Progress feedback patterns

For multi-second operations where the user might wonder "is something happening?":

### Progress bar via osascript (real native UI)

```bash
osascript <<'EOF'
tell application "System Events"
  display dialog "Setting up your AI's vault..." buttons {"Cancel"} giving up after 5 with title "[AI_NAME] — Working"
end tell
EOF
```

The dialog auto-dismisses after 5 seconds (good for "working, please wait" moments).

### Continuous-progress alternative

For longer operations (>10 seconds), prefer in-chat progress markers over native dialogs:

```
✅ Created Documents folder
✅ Cloned the kit from GitHub
⏳ Setting up your vault... (10 sec)
✅ Done.
```

This keeps the user inside the chat, sees motion, doesn't have to dismiss dialogs.

---

## Variables this library expects

| Placeholder | Source |
|---|---|
| `[AI_NAME]` | The user's chosen AI name (e.g., `Coco`, `Watney`) |
| `[VAULT_NAME]` | Defaults to `[AI_NAME] vault` — what Obsidian sees |

---

## When to use which pattern

| Goal | Right tool |
|---|---|
| Yes/no answer required to proceed | `display dialog` (modal — they have to choose) |
| User needs to toggle a system setting | `open "x-apple.systempreferences:..."` + screenshot + chat confirm |
| Setup just completed, ambient awareness | `display notification` (with `display dialog` fallback) |
| Long operation, in-flight progress | In-chat checkmarks + `⏳` markers (not native UI) |
| File path needed | `choose file` / `choose folder` (clean Finder UI) |
| Multi-step decision | Three-button `display dialog` |
| Drop the user into another app cleanly | `open -a "AppName"` with optional path arg |

---

*Add new snippets here as the install flow evolves. The AI installer reads this file when it needs to do something visual on the user's behalf.*
