# Superspeed - AI Communication Copilot

## Core Problem

**"I know WHAT to say but not HOW to say it"**

Superspeed solves the gap between intent and perfect communication. Users struggle with:
- **Tone**: Professional vs casual, formal vs friendly
- **Format**: Email vs Slack vs terminal commands
- **Audience**: Boss vs colleague vs client vs AI tools
- **Prompting AI**: How to phrase requests to Cursor, Claude Code, ChatGPT

**Real-world example:** User's dad spends 10 minutes editing ChatGPT-generated emails because the tone/format isn't right for the recipient.

---

## How Superspeed Works

### 1. User Provides Complete Intent + Context

User must provide **full intent**, not partial text:

**Text input example:**
```
send message to john about overlay discussion yesterday at 4pm
```

**Voice input example:**
```
"Send a follow-up email to John about the overlay architecture we discussed yesterday"
```

**NOT autocomplete** - AI needs complete context to generate properly. "Hey John" alone won't work.

---

### 2. Three Input Modes (Moon Phases)

- **Crescent Mode** (Fn toggle): Text input with 3-second pause detection
- **Half Moon Mode** (Fn hold): Voice input while holding
- **Full Moon Mode** (Fn double tap): Hands-free voice mode

---

### 3. Main Orchestrator Agent

Analyzes three dimensions:

1. **Intent + Context**: What user wants to communicate
2. **App/Domain**: Which application (Gmail, Slack, Cursor, Terminal)
3. **Audience**: Who is receiving (boss, colleague, client, AI tool)

Routes to appropriate app-specific sub-agent.

---

### 4. App-Specific Sub-Agents

**Important:** Agents are APP-SPECIFIC, not domain-specific.

- **GmailAgent**: Optimized for Gmail interface and email conventions
- **SlackAgent**: Optimized for Slack interface and messaging style
- **CursorAgent**: Optimized for Cursor AI prompting patterns
- **TerminalAgent**: Optimized for shell commands and scripts
- **LinearAgent**: Optimized for Linear issue tracking

Each agent understands:
- The app's UI/UX patterns
- Expected communication style
- Formatting conventions
- Best practices for that specific tool

---

### 5. Ghost Text Preview Workflow

**Automatic behavior:**

1. User types intent and stops (3-second pause detected)
2. System automatically:
   - Simulates Enter key twice (creates blank line separator)
   - Generates single BEST version
   - Inserts ghost text via clipboard paste

**Visual example:**

```
User types:
send message to john about overlay discussion yesterday█

After 3-second pause (AUTOMATIC):
send message to john about overlay discussion

Hi John, wanted to follow up on our overlay discussion from yesterday at 4pm...█
```

**User controls:**

- **Tab (Accept)**: Original intent deleted, blank line deleted, ghost text moves up to original position
- **Esc (Reject)**: Ghost text deleted, original intent stays, regenerates new version after 3 seconds
- **Infinite regenerations**: User can keep pressing Esc to try different versions

**Result after Tab (Accept):**
```
Hi John, wanted to follow up on our overlay discussion from yesterday at 4pm...█
```

**Result after Esc (Reject):**
```
send message to john about overlay discussion

Hey John! Following up on yesterday's overlay architecture chat...█
```
(New version automatically appears after 3 seconds - dead simple, no loading indicators)

---

### 6. Explicit Language Control

**VALIDATED DIFFERENTIATOR** (tested against ITO 2025-10-25)

**The Problem:**
- User speaks/types in native language (Hindi, Hinglish, etc.)
- Needs output in work language (English)
- Existing tools (ITO) let LLM decide output language → unpredictable
- Takes 5-6 tries to get right language + format

**Test results from ITO:**
```
Input (Hindi): "John भाई API में दिक्कत है चेक करना"
ITO Output: Just transcribed Hindi, no conversion

Input (Hinglish): "John, APM में कोई दिक्कत है। Can you check?"
ITO Output: Mixed Hindi/English, not formatted for work

Input (Hindi via "Hey Ito"): "योज भाई को मैसेज भेजना, API चेक करने को कुछ दिक्कत है"
ITO Output: Sometimes Hindi email, sometimes English, inconsistent
```

**Superspeed Solution:**

1. **Automatic input language detection**: Detect Hindi, Hinglish, English, etc.
2. **Explicit output language control**: User sets per app/recipient
3. **Guaranteed behavior**: Hindi input → guaranteed English output for work
4. **Context-aware preferences**:
   - Work apps (Gmail, Slack, Jira) → English
   - Family WhatsApp → Hindi
   - Personal notes → User's native language

**Implementation:**
```typescript
interface LanguagePreferences {
  inputLanguage: 'auto-detect' | 'hindi' | 'english' | 'hinglish'
  outputLanguage: 'english' | 'hindi' | 'match-input'
  perAppOverrides: {
    'gmail': 'english',
    'slack': 'english',
    'whatsapp': 'hindi',
    'notes': 'match-input'
  }
  perRecipientOverrides: {
    'boss@company.com': 'formal-english',
    'mom-whatsapp': 'hindi'
  }
}
```

**Market opportunity:**
- Billions of non-native English speakers
- Communicate in native language, need professional English output
- No existing tool guarantees this behavior

---

### 7. Relationship Detection & Learning

**Relationship detection:**
- Parses To: field from email context
- Analyzes email history with recipient
- Org chart awareness (boss, colleague, client)
- Detects formality level from past interactions

**Learning system:**
- Tracks accepts vs rejects per recipient
- Learns tone preferences (formal vs casual)
- Learns format preferences (brief vs detailed)
- Learns language preferences (English vs Hindi)
- Improves suggestions over time based on feedback

**Example:**
- User always accepts formal tone for boss → future suggestions automatically more formal
- User always rejects verbose emails to colleagues → future suggestions more concise
- User always accepts Hindi for family WhatsApp → remembers preference

---

## Technical Implementation

### Text Insertion Method

Uses clipboard paste method (borrowed from ITO):

1. Save current clipboard contents
2. Clear clipboard
3. Put new text in clipboard
4. Verify clipboard set (retry up to 50 times)
5. Simulate Cmd+V keyboard event
6. Wait 1 second
7. Restore original clipboard contents

**Why clipboard method:** macOS Accessibility API (`AXUIElement`) works system-wide across all applications.

---

### Ghost Text Limitation

**Desired:** Gray inline text like GitHub Copilot's code suggestions

**Reality:** macOS Accessibility API **cannot insert styled/colored text** system-wide.

**Research findings:**
- `AXUIElementSetAttributeValue` only accepts plain text strings
- Attempting `NSAttributedString` with color/style → `kAXErrorIllegalArgument`
- `NSPasteboard` with RTF/HTML only works in rich text apps (Word, TextEdit), not web apps (Gmail, Slack)
- Rust bindings (`cocoa-rs`, `cacao`) use same underlying APIs → same limitations

**Solution:** Blank line separator between intent and ghost text.

---

### System Architecture

```
User Input (Text/Voice)
    ↓
Main Orchestrator Agent
    ↓
Analyzes: Intent + App + Audience
    ↓
Routes to App-Specific Sub-Agent
    ↓
Generates Single Best Version
    ↓
Ghost Text Preview (2 lines below with blank separator)
    ↓
Tab/Esc (Accept/Reject)
    ↓
Learning System (tracks feedback)
```

---

## Superspeed vs ITO (Validated 2025-10-25)

| Feature | ITO | Superspeed |
|---------|-----|-------|
| **Core purpose** | Voice dictation with cleanup | Intent → Perfect communication |
| **Problem solved** | Faster than typing | "Know WHAT to say, not HOW" |
| **Input methods** | Voice only | Text OR Voice (3 modes) |
| **Language control** | ❌ LLM decides (unpredictable) | ✅ Explicit input/output language control |
| **Cross-language** | ❌ Hindi input → Hindi output | ✅ Hindi input → guaranteed English output |
| **Consistency** | ❌ Takes 5-6 tries for right format | ✅ Consistent format on first try |
| **Intelligence** | Generic AI generation (EDIT mode has context awareness) | Multi-agent orchestration with audience analysis |
| **Output preview** | ❌ None - immediately inserts | ✅ Ghost text preview before accepting |
| **User control** | ❌ No reject/regenerate | ✅ Tab/Esc to accept/reject, infinite regenerations |
| **Learning** | ❌ No learning from user feedback | ✅ Learns from accepts/rejects per recipient |
| **Relationship awareness** | ❌ No | ✅ Parses To: field, org chart, email history |
| **App optimization** | Generic context (window title, app name, selected text) | App-specific sub-agents (GmailAgent, CursorAgent) |
| **Context sent to AI** | Window title, app name, selected text (up to 10K chars) | Intent + App + Audience + Relationship + Language preferences |

**Key differentiators (validated through testing):**

1. **Language Control** (BIGGEST GAP):
   - **ITO:** Speak Hindi → unpredictable output (sometimes Hindi, sometimes English, takes 5-6 tries)
   - **Superspeed:** Speak Hindi → guaranteed English output for work, Hindi for family

2. **Preview & Control**:
   - **ITO:** Immediately pastes, no preview, no undo
   - **Superspeed:** Ghost text preview → Tab/Esc to accept/reject → infinite regenerations

3. **Input Flexibility**:
   - **ITO:** Voice only (user types fast, doesn't always want voice)
   - **Superspeed:** Text OR Voice (3 modes for different contexts)

4. **Consistency**:
   - **ITO:** Inconsistent formatting (sometimes email, sometimes message)
   - **Superspeed:** App-specific agents guarantee correct format every time

---

## Market Validation

### Communication Problem is Real

**Research findings:**
- **50%** of emails are misunderstood (Grammarly survey)
- **88%** of workers regret sending emails
- **97%** over-explain in Slack (fear of misinterpretation)
- **11 hours/week** on email alone
- **40+ hours/week** on ALL communication (email, Slack, Jira, GitHub, Linear, Notion, Google Docs)

**User pain points:**
- AI-generated text feels "cringe" for casual messages (48% hide AI usage)
- Dad spends 10 minutes editing ChatGPT emails → tone/format wrong
- Takes 5-6 tries with existing tools (ITO) to get right language + format
- No tool guarantees cross-language conversion (Hindi → English for work)

### Existing Solutions (Partial)

**Big players solving pieces:**
- **Grammarly** ($13B valuation): Tone detection, writing suggestions (English only)
- **Superhuman** ($825M valuation): Email productivity, AI writing (email only)
- **Lavender** ($13M+ funding): Email personalization for sales (sales only)
- **GitHub Copilot** (1.3M subscribers): Code suggestions with ghost text UX

**Voice dictation competitors** (50+ apps):
- **Dragon**: Desktop dictation ($300/year, English-focused)
- **Otter.ai**: Meeting transcription ($16.99/month)
- **Superwhisper**: macOS voice input ($8/month)
- **MacWhisper**: Local transcription (one-time $35)
- **ITO**: Open source voice dictation (GPL v3)

### Gap Superspeed Fills (Validated)

**No existing tool provides:**

1. **Cross-language control** (VALIDATED):
   - Billions of non-native English speakers
   - Need professional English output from native language input
   - ITO and competitors let LLM decide → unpredictable

2. **Ghost text preview workflow**:
   - GitHub Copilot proves ghost text UX works (1.3M subscribers)
   - But only for code, not communication
   - Tab/Esc accept/reject with infinite regenerations

3. **Text + Voice input**:
   - Fast typers don't always want voice
   - Existing tools force one or the other
   - Superspeed supports both seamlessly

4. **App-specific optimization**:
   - No tool optimizes for Cursor, Claude Code, Terminal
   - Generic context vs deep understanding
   - MCP integration for true context awareness

5. **Learning from feedback**:
   - Track accepts vs rejects per recipient
   - Improve over time based on user preferences
   - Language, tone, format preferences per context

---

## Design Principles

1. **Dead minimal**: No overlay windows, no complex UI
2. **System-wide**: Works in any app (Gmail, Slack, Cursor, Terminal)
3. **Automatic**: User just types/speaks, everything else is automatic
4. **User control**: Tab/Esc for accept/reject, infinite regenerations
5. **Learning**: Gets better over time based on user feedback

---

## Next Steps (Prioritized by Validated Gaps)

### Phase 1: Core Differentiators (MVP)

**Goal:** Prove the 3 validated gaps ITO doesn't solve

1. **Explicit Language Control System**
   - Input language auto-detection (Hindi, Hinglish, English)
   - Output language specification in system prompts
   - Per-app language preferences (Gmail = English, WhatsApp = Hindi)
   - Guaranteed cross-language conversion (Hindi → English for work)

2. **Ghost Text Preview Workflow**
   - 3-second pause detection for text input
   - Blank line separator + clipboard paste
   - Tab/Esc keyboard listeners (accept/reject)
   - Infinite regeneration on Esc press
   - Original intent deletion on Tab accept

3. **Text Input Support**
   - Crescent Mode (Fn toggle): Text input
   - Focus on fast typers who don't want voice
   - Voice can come later (Half Moon, Full Moon modes)

4. **Consistent Formatting**
   - Simple app detection (window title, app name)
   - Basic app-specific prompts (Gmail = email, Slack = message, Terminal = command)
   - No MCP yet, just reliable formatting

**Success criteria:**
- Hindi input → 100% English output for work apps
- First generation is correct format (no 5-6 tries like ITO)
- Ghost text workflow feels natural (like GitHub Copilot)

### Phase 2: Learning & Intelligence (Post-MVP)

5. **Learning Feedback Loop**
   - Track Tab (accept) vs Esc (reject) per recipient
   - Learn language preferences (boss = formal English, family = Hindi)
   - Learn tone preferences (colleague = casual, client = formal)
   - Learn format preferences (brief vs detailed)

6. **Relationship Detection**
   - Parse To: field from email context
   - Basic formality detection (boss vs colleague)
   - Email history analysis (optional, privacy-sensitive)

### Phase 3: Advanced Context (Future)

7. **MCP Integration**
   - Deep Gmail context (email threads, signatures)
   - Deep Slack context (channel norms, previous messages)
   - Deep Cursor context (codebase, selected code)

8. **Advanced Agents**
   - Main Orchestrator Agent (routes to sub-agents)
   - App-specific sub-agents (GmailAgent, CursorAgent, etc.)
   - Audience analysis (boss, colleague, client, AI tool)

---

## Why This Approach Wins

**Against ITO (10 devs, open source):**
- Don't compete on features (they'll copy)
- Compete on **execution** (language control DONE RIGHT)
- Compete on **UX** (ghost text preview obsession)
- Compete on **positioning** (communication copilot, not voice dictation)

**Market opportunity:**
- Billions of non-native English speakers (MASSIVE TAM)
- ITO proves voice dictation works, but left gap in language control
- GitHub Copilot proves ghost text UX works, but only for code
- Grammarly proves communication market is huge ($13B)

**Solo dev advantage:**
- Focus on ONE validated gap (language control)
- Obsess over UX details (10-person team can't)
- Ship fast, iterate based on user feedback
- No GPL trap (can close source if needed)
