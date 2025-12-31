

## Superspeed helps you transform your intent into perfectly-crafted messages using a GitHub Copilot-style ghost text workflow.

## Phase 1 Features (Implemented)

### Core Functionality
- ✅ **Fn Key Toggle** - Press Fn once to activate/deactivate Superspeed (Crescent Mode)
- ✅ **3-Second Pause Detection** - Automatically triggers ghost text generation
- ✅ **Ghost Text Preview** - AI-generated text appears with blank line separator
- ✅ **Tab/Esc Controls** - Tab to accept, Esc to reject and regenerate
- ✅ **System-Wide** - Works in any macOS app (Gmail, Slack, TextEdit, etc.)
- ✅ **Clipboard Paste Method** - Based on ITO's proven implementation
- ✅ **Menu Bar App** - Minimal UI, lives in menu bar only

### AI Integration
- ✅ **Claude API** - Powered by Anthropic Claude Sonnet 4
- ✅ **Professional Rewriting** - Transforms intent into polished messages
- ✅ **Regeneration** - Different versions when you reject

### Learning & Analytics
- ✅ **SQLite Database** - Local-only data storage (privacy-first)
- ✅ **Accept/Reject Tracking** - Logs all interactions
- ✅ **Statistics** - View accept rate and usage metrics
- ✅ **App Detection** - Tracks which apps you use Superspeed in

## Installation & Setup

### Prerequisites
- macOS 13.0 (Ventura) or later
- Xcode 14.0 or later
- Claude API key from [console.anthropic.com](https://console.anthropic.com)

### Build Steps

1. **Clone/Open the project**
   ```bash
   cd /Users/hak/projects/Superspeed
   open Superspeed.xcodeproj
   ```

2. **Add new files to Xcode**
   - Add `SettingsView.swift` to the project
   - Add `DatabaseManager.swift` to the project
   - Ensure they're in the target membership

3. **Build and Run**
   - Press Cmd+R in Xcode
   - Grant Accessibility permissions when prompted
   - Grant Input Monitoring permissions when prompted

4. **Configure API Key**
   - Click Superspeed icon in menu bar
   - Select "Settings..."
   - Paste your Claude API key
   - Close settings window

### Required Permissions

Superspeed requires these macOS permissions:

1. **Accessibility** - To monitor keyboard input and detect typing pauses
2. **Input Monitoring** - To capture Fn key presses and Tab/Esc actions

**Why these are needed:**
- System-wide keyboard listening (for Fn toggle and pause detection)
- Text insertion via clipboard paste method
- Tab/Esc handler for accepting/rejecting ghost text

### Grant Permissions Manually

If the app doesn't prompt you automatically:

1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Click the **+** button and add Superspeed
3. Open **System Settings** → **Privacy & Security** → **Input Monitoring**
4. Enable Superspeed

## How to Use

### Basic Workflow

1. **Activate Superspeed**
   - Press **Fn** key once (or click menu bar → "Enable Superspeed")

2. **Type your intent** in any app
   - Example: "send message to john about meeting tomorrow"

3. **Wait 3 seconds** (automatic pause detection)
   - Ghost text appears below with blank line separator:
   ```
   send message to john about meeting tomorrow

   Hi John, I wanted to follow up about our meeting scheduled for tomorrow...
   ```

4. **Accept or Reject**
   - Press **Tab** to accept (intent deleted, ghost text stays)
   - Press **Esc** to reject and regenerate (new version appears after 3s)

5. **Superspeed auto-disables** after you accept/reject

### Settings

- **Claude API Key** - Required for AI generation
- **Pause Detection Delay** - Adjust from 1-10 seconds (default: 3s)
- **Enable Superspeed system-wide** - Toggle on/off

### Statistics

View your usage metrics in Settings:
- **Accepts** - How many times you pressed Tab
- **Rejects** - How many times you pressed Esc
- **Accept Rate** - Percentage of accepts (target: >70%)

## Architecture

### Components

- **SuperspeedApp.swift** - App entry point, menu bar setup, AppDelegate
- **ContentView.swift** - Main logic, SuperspeedTextMode manager, NetworkManager
- **SettingsView.swift** - Settings UI with statistics
- **DatabaseManager.swift** - SQLite database for logging interactions

### Text Insertion Method

Uses clipboard paste method (not styled text injection):

1. Save current clipboard
2. Set ghost text to clipboard
3. Simulate Cmd+V
4. Restore original clipboard

**Why:** macOS Accessibility API cannot insert styled/colored text system-wide, so we use blank line separator for visual distinction.

### Database Schema

```sql
-- Interactions table (Phase 1)
CREATE TABLE interactions (
    id TEXT PRIMARY KEY,
    app_name TEXT,
    intent TEXT,
    generated_text TEXT,
    action TEXT, -- 'accept' or 'reject'
    timestamp TIMESTAMP
);

-- Additional tables created for Phase 2+
-- recipients, app_preferences, rejected_versions
```

## What's NOT in Phase 1

According to the PRD, these features are **explicitly out of scope** for Phase 1:

- ❌ Voice input (Half Moon / Full Moon modes)
- ❌ Multi-agent orchestration (GmailAgent, SlackAgent, etc.)
- ❌ Advanced learning algorithm (per-recipient preferences)
- ❌ Relationship detection
- ❌ Email history analysis
- ❌ Cloud sync

These will be added in Phase 2 and beyond.

## Testing

### Test in TextEdit

1. Open TextEdit (or any text app)
2. Press Fn to activate Superspeed
3. Type: "write email to boss about vacation request"
4. Wait 3 seconds
5. Ghost text should appear
6. Press Tab to accept or Esc to regenerate

### Test in Multiple Apps

Try Superspeed in:
- Gmail (web browser)
- Slack (desktop app)
- Messages
- Notes
- Terminal
- Any text field!

## Troubleshooting

### Ghost text doesn't appear
- Check Accessibility permissions in System Settings
- Check that Claude API key is configured
- Look at Xcode console for error messages
- Ensure you waited full 3 seconds after typing

### Tab/Esc doesn't work
- Check Input Monitoring permissions
- Ensure ghost text has appeared first
- Try clicking in the text field before pressing Tab/Esc

### "No Claude API key configured" error
- Open Settings and add your API key from console.anthropic.com
- Make sure to save (close settings window)

## Database Location

Learning data is stored locally at:
```
~/Library/Application Support/Superspeed/superspeed.db
```

You can clear all data from Settings → "Clear All Learning Data"

## Success Metrics (Phase 1)

According to the PRD:
- **Primary:** User uses Superspeed for 1 week, reduces email editing time by >60%
- **Accept rate:** >70% (ghost text accepted without regeneration)
- **Regenerations:** <2 per intent on average

Check your stats in Settings to track progress!

## Next Steps (Phase 2)

After Phase 1 validation:
- Add voice input (Half Moon Mode with Fn hold)
- Implement recipient detection (email parsing)
- Add app-specific context awareness
- Build preference learning algorithm
- Improve regeneration with previous version context

## Privacy

- All data stored **locally only** (SQLite database)
- No cloud sync in Phase 1
- Only API calls go to Anthropic Claude (HTTPS)
- You can clear all data anytime from Settings

---

**Built according to [SUPERSPEED_PRD.md](SUPERSPEED_PRD.md) Phase 1 specification**
