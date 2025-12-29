# Superspeed: The Universal Intelligent Input Layer

**Document Version:** December 2025  
**Status:** In Development

---

## Executive Summary

Superspeed is a system-wide AI-powered input layer for macOS (expanding to Linux and Windows) that transforms raw user intent into polished, context-aware output across every application. Unlike existing tools that require context-switching, manual invocation, or work only within specific apps, Superspeed operates invisibly — users simply type naturally, and intelligent suggestions appear as ghost text that can be accepted with Tab or rejected with Esc.

**Core Philosophy:** Take the complex engineering. Provide simplicity to users.

---

## The Problem

### Fragmentation of AI Writing Tools

Users currently need multiple subscriptions and context switches:

| Task | Current Tool | Friction |
|------|--------------|----------|
| Polish emails | Grammarly/Superhuman | Browser extension, popup corrections |
| Write AI prompts | Copy-paste to ChatGPT | Context switch, separate window |
| Terminal commands | Google/StackOverflow | Leave terminal, search, copy-paste |
| Excel formulas | Google/Copilot function | Manual `=COPILOT()` invocation |
| Translate Hindi → English | Multiple tools | Copy, translate, paste back |

**Total cost for fragmented tools:** $50-100+/month  
**Total friction:** Constant context switching, cognitive load

### The Core Pain Point

> "I know WHAT to say, but not HOW to say it."

Users struggle with:
- **Tone:** Professional vs casual, formal vs friendly
- **Format:** Email vs Slack vs terminal command vs formula
- **Syntax:** Shell commands, Excel formulas, regex patterns
- **Language:** Thinking in native language, needing output in English
- **Prompts:** Writing effective prompts for AI tools

---

## The Solution: Superspeed

### One Invisible Layer. Five Pillars. Every App.

Superspeed is a single $8.99/month subscription that provides:

```
┌─────────────────────────────────────────────────────────┐
│                    USER EXPERIENCE                       │
│                                                          │
│   1. Type naturally in any app                          │
│   2. Pause for 3 seconds                                │
│   3. Ghost text appears with intelligent suggestion     │
│   4. Tab = Accept | Esc = Reject & Regenerate           │
│                                                          │
│   That's it. No buttons. No menus. No context switch.   │
└─────────────────────────────────────────────────────────┘
```

### The Five Pillars

#### 1. Prompt Supercharger
When typing in AI tools (ChatGPT, Claude, Cursor, Midjourney), Superspeed transforms vague requests into expert-level prompts.

**Example:**
```
User types: "make this python better"

Superspeed ghosts: "Refactor this Python code for better readability and 
performance. Specifically: 1) Add type hints, 2) Extract repeated logic 
into helper functions, 3) Add docstrings following Google style, 
4) Optimize any O(n²) operations if possible. Preserve existing 
functionality and add inline comments explaining non-obvious changes."
```

**Supported Apps:** ChatGPT, Claude, Cursor, Perplexity, Gemini, Midjourney, v0, Bolt, Grok, Copilot

#### 2. Communication Polisher
When typing in communication apps, Superspeed transforms raw thoughts into polished, professional messages.

**Example:**
```
User types: "need this fixed asap breaks login"

Superspeed ghosts: "Hi team, could you please prioritize the login issue? 
It appears to be critical and is blocking users. Let me know if you 
need any additional context. Thanks!"
```

**Supported Apps:** Gmail, Slack, Discord, WhatsApp, iMessage, Teams, LinkedIn, Twitter/X, Telegram, Outlook

#### 3. Language Bridge
Superspeed detects input language and automatically outputs in the appropriate language for the context.

**Example:**
```
User types (in Hindi): "जॉन को बताओ कि API में दिक्कत है"

Superspeed ghosts (for work Slack): "Hey John, heads up - there's an issue 
with the API. Can you take a look when you get a chance?"
```

**Key Feature:** 
- Work apps (Gmail, Slack, Jira) → English output
- Personal apps (WhatsApp to family) → Native language output
- Automatic detection, no manual switching

**Supported Languages:** Hindi, Hinglish, English (expanding to Spanish, French, German, Mandarin)

#### 4. Terminal Commands
When in terminal applications, Superspeed transforms natural language into executable shell commands.

**Example:**
```
User types: "find all python files modified in last 24 hours over 1mb"

Superspeed ghosts: find . -name "*.py" -mtime -1 -size +1M
```

**Supported Apps:** Terminal.app, iTerm2, Warp, Alacritty, Hyper, VS Code terminal, any shell

#### 5. Spreadsheet Formulas
When in spreadsheet applications, Superspeed transforms natural language into formulas.

**Example:**
```
User types: "sum column B if column A contains 'sales' and date is this month"

Superspeed ghosts: =SUMIFS(B:B, A:A, "*sales*", C:C, ">="&DATE(YEAR(TODAY()),MONTH(TODAY()),1), C:C, "<="&EOMONTH(TODAY(),0))
```

**Supported Apps:** Microsoft Excel, Google Sheets, Apple Numbers, Airtable, Notion tables

---

## Competitive Landscape (December 2025)

### Direct Competitors

#### Superhuman (formerly Grammarly)
- **What:** Rebranded from Grammarly in October 2025. AI assistant that integrates with 100+ apps.
- **Features:** Email drafting, summarization, scheduling, "Superhuman Go" AI assistant
- **Pricing:** ~$25-30/month (Premium)
- **UX:** Browser extension, popup corrections, sidebar assistant
- **Limitations:** 
  - NOT inline ghost text (uses popups/corrections)
  - No terminal command support
  - No spreadsheet formula support
  - No explicit language control (Hindi → English)
- **Source:** [TechRadar, Oct 2025](https://www.techradar.com/ai-platforms-assistants/grammarly-has-rebranded-as-superhuman-launching-a-new-ai-assistant-that-works-across-100-apps)

#### Apple Intelligence (macOS Sequoia)
- **What:** Native macOS writing tools
- **Features:** Rewrite, proofread, summarize text
- **Pricing:** Free (built into macOS 15+)
- **UX:** Select text → Right-click → Writing Tools menu
- **Limitations:**
  - NOT ghost text (requires selection and menu interaction)
  - No prompt enhancement
  - No terminal commands
  - No spreadsheet formulas
  - No cross-language support
  - Only works in Apple ecosystem apps

#### GitHub Copilot
- **What:** AI code completion
- **Features:** Inline ghost text for code suggestions
- **Pricing:** $10-19/month
- **UX:** Inline ghost text (Tab to accept)
- **Limitations:**
  - Code only (no communication, no terminal, no spreadsheets)
  - Only works in supported IDEs
  - No prompt enhancement
  - No language bridge

#### Raycast
- **What:** Application launcher with AI features
- **Features:** Quick access, AI chat, extensions
- **Pricing:** $8/month (Pro)
- **Platforms:** macOS, Windows (beta as of Nov 2025)
- **UX:** Command palette (Cmd+Space), chat interface
- **Limitations:**
  - NOT inline ghost text (command palette UX)
  - Requires manual invocation
  - Not system-wide text enhancement

#### Warp Terminal
- **What:** AI-powered terminal emulator
- **Features:** Command suggestions, AI explanations
- **Pricing:** Free (basic), $15/month (team)
- **Platforms:** macOS, Linux, Windows
- **UX:** In-terminal AI, command palette
- **Limitations:**
  - Terminal only (must use Warp, not native Terminal)
  - Not system-wide
  - No communication polishing
  - No spreadsheet formulas

#### Microsoft Copilot (Excel)
- **What:** AI assistant in Microsoft 365
- **Features:** `=COPILOT()` function in Excel cells
- **Pricing:** $30/month (M365 Copilot)
- **UX:** Manual function invocation
- **Limitations:**
  - Requires typing `=COPILOT("...")` explicitly
  - NOT ghost text
  - Excel/Microsoft apps only
  - Microsoft warns "not for tasks requiring accuracy"

### Competitive Matrix

| Feature | Superspeed | Superhuman | Apple Intel | Copilot | Raycast | Warp |
|---------|-------|------------|-------------|---------|---------|------|
| **Inline Ghost Text** | ✅ | ❌ | ❌ | ✅ (code only) | ❌ | ❌ |
| **System-wide** | ✅ | ✅ | Partial | ❌ | ❌ | ❌ |
| **Prompt Enhancement** | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Communication Polish** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Language Bridge** | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Terminal Commands** | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Spreadsheet Formulas** | ✅ | ❌ | ❌ | Partial | ❌ | ❌ |
| **Cross-Platform** | Planned | ✅ | ❌ | ✅ | ✅ | ✅ |
| **Price** | $8.99 | ~$25 | Free | $10-30 | $8 | $0-15 |

### Key Differentiators

1. **Inline Ghost Text UX** — Only GitHub Copilot does this, and only for code
2. **All Five Pillars** — No competitor covers prompts + communication + language + terminal + spreadsheets
3. **Language Bridge** — No competitor offers explicit Hindi/Hinglish → English control
4. **Price** — $8.99 undercuts all paid competitors
5. **Zero Friction** — No buttons, no menus, no command palette — just type and Tab

---

## User Workflow

### Installation & Setup (2 minutes)

```
1. Download Superspeed from superspeed.app
2. Drag to Applications
3. Launch → Grant Accessibility + Input Monitoring permissions
4. Done
```

### Onboarding (30 seconds)

```
┌────────────────────────────────────────────────┐
│  Welcome to Superspeed                              │
│                                                │
│  Just type what you WANT, not how to do it.   │
│                                                │
│  Examples:                                     │
│  • "polite email to boss about delay"         │
│  • "find large files modified today"          │
│  • "sum sales if region is west"              │
│                                                │
│  When you pause, Superspeed suggests.              │
│  Tab = Accept | Esc = Reject                  │
│                                                │
│  [Got it, let's go →]                         │
└────────────────────────────────────────────────┘
```

### Daily Usage

```
┌─────────────────────────────────────────────────────────────────┐
│ STEP 1: User types intent in any app                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Gmail compose:                                                 │
│  ┌──────────────────────────────────────────┐                   │
│  │ update john about the api bug fix█       │                   │
│  └──────────────────────────────────────────┘                   │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│ STEP 2: User pauses (3 seconds) → Ghost text appears            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Gmail compose:                                                 │
│  ┌──────────────────────────────────────────┐                   │
│  │ update john about the api bug fix        │                   │
│  │                                          │                   │
│  │ Hi John,                                 │ ← Ghost text      │
│  │                                          │                   │
│  │ Quick update on the API bug we discussed │                   │
│  │ - the fix has been deployed to staging   │                   │
│  │ and is passing all tests. Planning to    │                   │
│  │ push to production tomorrow morning.     │                   │
│  │                                          │                   │
│  │ Let me know if you have any questions.   │                   │
│  │                                          │                   │
│  │ Best,                                    │                   │
│  └──────────────────────────────────────────┘                   │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│ STEP 3: User decides                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  [Tab] → Accept: Intent deleted, ghost text becomes real text   │
│  [Esc] → Reject: Ghost text removed, new version in 3 seconds   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Cross-Pillar Examples

**Terminal (iTerm2):**
```
User: delete all node_modules folders recursively
Ghost: find . -name 'node_modules' -type d -prune -exec rm -rf {} +
[Tab to accept]
```

**Spreadsheet (Google Sheets):**
```
User: average of column C where status in column A is "completed"
Ghost: =AVERAGEIF(A:A, "completed", C:C)
[Tab to accept]
```

**AI Prompt (Cursor):**
```
User: fix the bug
Ghost: Analyze this code and identify the bug causing [specific behavior]. 
       Explain the root cause, then provide a fix with:
       1. The corrected code
       2. Explanation of what was wrong
       3. How to prevent similar issues
[Tab to accept]
```

**Language Bridge (Slack):**
```
User (Hindi): टीम को बताओ कि मीटिंग कैंसल है
Ghost: Hey team, heads up - today's meeting is cancelled. 
       Will reschedule for tomorrow. Thanks!
[Tab to accept]
```

---

## Technical Architecture

### Core Components

```
┌─────────────────────────────────────────────────────────────────┐
│                         HELIO CORE                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ App         │  │ Agent       │  │ Language    │              │
│  │ Detector    │→ │ Router      │→ │ Engine      │              │
│  │ (Bundle ID) │  │ (40+ rules) │  │ (Detection) │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│         │                │                │                      │
│         ▼                ▼                ▼                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ Keyboard    │  │ LLM         │  │ Ghost       │              │
│  │ Monitor     │← │ Engine      │← │ Writer      │              │
│  │ (Rust)      │  │ (Claude/GPT)│  │ (Clipboard) │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Technology Stack

| Component | Technology | Why |
|-----------|------------|-----|
| Core Engine | Rust | Speed (6-9ms keyboard events), cross-platform |
| macOS UI | Swift/SwiftUI | Native experience, Accessibility API |
| Linux UI | GTK/Tauri | Cross-platform Rust integration |
| Windows UI | Win32/Tauri | Native Windows integration |
| LLM Backend | Claude 3.5 Sonnet / GPT-4 | Best quality for text generation |
| Local Storage | SQLite | Learning data, preferences |

### Agent Architecture

Each app has a dedicated agent (prompt file):

```
superspeed-agents/
├── prompts/
│   ├── gmail.md
│   ├── slack.md
│   ├── discord.md
│   ├── cursor.md
│   ├── chatgpt.md
│   ├── terminal.md
│   ├── excel.md
│   └── ... (40+ agents)
└── language/
    ├── hindi-english.md
    ├── hinglish.md
    └── ... (language rules)
```

**Example Agent (gmail.md):**
```markdown
# Gmail Agent

You are assisting a user composing an email in Gmail.

## Output Format
- Include appropriate greeting (Hi/Hello/Dear based on formality)
- Professional but warm tone
- Clear paragraph structure
- Include sign-off (Best/Thanks/Regards based on context)

## Rules
- If user mentions urgency, reflect it politely
- If user mentions a person's name, use it in greeting
- Keep emails concise unless user indicates "detailed"
- Never use emojis unless user's intent includes them

## Examples
[Intent]: "tell sarah meeting moved to 3pm"
[Output]: 
Hi Sarah,

Just a quick note - our meeting has been moved to 3pm today. 
Let me know if that still works for you.

Thanks!
```

---

## Pricing Strategy

### Superspeed Free
- All 5 pillars
- All 40+ app agents
- 25 generations per day
- Basic language support (English)

### Superspeed Pro ($8.99/month)
- Unlimited generations
- Full language bridge (Hindi, Hinglish, Spanish, French, German, Mandarin)
- Priority LLM (faster responses)
- Learning system (adapts to your style)
- Cross-device sync

### Why $8.99?
- Below "think about it" threshold
- Cheaper than Grammarly ($25), Copilot ($10-19), Raycast ($8)
- Covers LLM costs with margin at scale
- Annual option: $7.99/month ($95.88/year)

---

## Roadmap

### Phase 1: macOS MVP (Current)
- Core ghost text UX
- 10 priority apps (Gmail, Slack, Terminal, Excel, ChatGPT, Cursor, Discord, iMessage, VS Code, Notes)
- English + Hindi/Hinglish language support
- Basic learning (accept/reject tracking)

### Phase 2: macOS Full (Q1 2026)
- All 40+ app agents
- Full language support (10 languages)
- Advanced learning (per-recipient, per-app preferences)
- Settings UI with customization

### Phase 3: Linux (Q2 2026)
- Port Rust core to Linux
- X11/Wayland + AT-SPI accessibility
- Tauri-based UI

### Phase 4: Windows (Q3 2026)
- Port Rust core to Windows
- UI Automation API integration
- Native Windows UI

---

## Success Metrics

### Launch (Month 1)
- 1,000 downloads
- 100 daily active users
- 10% free → Pro conversion

### Growth (Month 6)
- 10,000 total users
- 1,000 Pro subscribers
- $8,990 MRR

### Scale (Year 1)
- 50,000 total users
- 5,000 Pro subscribers
- $44,950 MRR (~$540K ARR)

---

## Exit Strategy

### Scenario 1: Grow Independently
- Profitable at 5,000+ subscribers
- Bootstrap to $1M+ ARR
- Build sustainable lifestyle business

### Scenario 2: Acquisition
- Likely acquirers: Grammarly/Superhuman, Apple, Microsoft, GitHub
- Acquisition triggers: Unique UX, user base, cross-platform, language tech
- Target: Acqui-hire or asset purchase in $1-10M range

---

## Why Now?

1. **LLM Quality:** Claude 3.5 Sonnet and GPT-4 are finally good enough for reliable text generation
2. **No Incumbent:** Nobody has built inline ghost text system-wide
3. **Fragmentation Pain:** Users are tired of 5+ subscriptions for AI writing tools
4. **Cross-Platform Rust:** Rust ecosystem now supports all major platforms
5. **Price Sensitivity:** Users want value; $8.99 is accessible

---

## Summary

Superspeed is the **invisible intelligence layer** that upgrades typing across every app.

**For users:** Just type naturally. Tab to accept. No learning curve.

**For the market:** First mover in system-wide inline ghost text. Five pillars no competitor covers. Price that undercuts everyone.

**For the builder:** Clear vision. Technical foundation. Exit options.

**Status:** Building.

---

*Last Updated: December 2025*

