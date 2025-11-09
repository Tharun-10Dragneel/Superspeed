# **Helio - Product Requirements Document (PRD)**

**Product Name:** Helio  
**Tagline:** The universal AI copilot for macOS  
**Version:** 1.0 (V1: Thought Partner) → 2.0 (V2: Action Engine)  
**Owner:** [Your Name]  
**Status:** Planning → Build  
**Target Launch:** December 1, 2025  
**Last Updated:** November 6, 2025

***

## **1. Executive Summary**

Helio is a native macOS application that acts as a universal AI copilot, living inside every text field across the entire operating system. It eliminates the friction of writing, context-switching, and information retrieval by providing intelligent, context-aware text suggestions as "ghost text" exactly where the user is typing.

Helio operates in three intelligent modes—**Autocomplete**, **Generation**, and **Rewriting**—adapting its behavior based on what the user has typed. Each application gets its own specialized AI agent that understands the context and communication style appropriate for that app. The system learns from user feedback to personalize tone, format, and vocabulary over time.

In V2, Helio evolves from a "thought partner" into an "action engine" by integrating external connectors (Jira, Fireflies, Google Drive, etc.) to pull real-time context into communications, and by adding multilingual support for global users.

**Core Value Proposition:**  
"The universal AI copilot for macOS—autocomplete your thoughts, generate your ideas, and rewrite your words, anywhere you type."

***

## **2. Unique Positioning**

### **What Makes Helio Different**

**The Problem with Existing Tools:**
- **Grammarly:** Editing-focused, not generative. System-wide but treats all apps the same. No connectors for external context.
- **Notion AI:** Powerful connectors, but only works inside Notion for documentation. Not for real-time communication in other apps.
- **GitHub Copilot:** Excellent ghost text UX, but code-only. Not system-wide.
- **Superhuman/Notion Mail:** App-specific email AI. Not system-wide.

**Helio's Unique Combination:**
1. **System-wide:** Works in every app, not locked to one interface
2. **Multi-Agent:** 20+ specialized agents, each optimized for specific apps
3. **Learning System:** Learns your tone, format, relationships, vocabulary
4. **Ghost Text UX:** Instant, proactive suggestions with Tab/Esc control
5. **Voice Input:** Secondary input method for hands-free operation
6. **Connectors (V2):** Pulls context from Jira, Fireflies, Google Drive, etc. for real-time communication assistance (not just documentation)
7. **Multilingual (V2):** Automatic language detection with 5 translation scenarios including slang support

**No competitor offers all of these features in one product.**

***

## **3. Target Audience**

**Primary Audience:**  
Mac power-users who live in multiple apps and value speed, efficiency, and quality in their digital communications.

**User Archetypes:**
- **Developers:** Live in VS Code, Terminal, GitHub, Slack
- **Designers:** Live in Figma, design tools, client communication apps
- **Marketers/Content Creators:** Live in Google Docs, social media, email
- **General knowledge workers:** Live in email, Slack, Notion, meetings

**Key Characteristics:**
- Keyboard-first workflow preference
- Context-switching fatigue
- Early adopters of AI tools
- Privacy-conscious
- Willing to pay for productivity tools

**Geographic Focus:**
- **V1:** Global English-speaking market (US, UK, Canada, Australia, India)
- **V2:** Expanded to multilingual markets (India Hindi/Hinglish, Europe, Latin America)

***

## **4. Business Model & Monetization**

### **Free Tier**
- All three modes (Autocomplete, Generation, Rewriting)
- All 20+ application-specific agents
- Learning system
- Voice input
- **Limit:** 25 generations per day

**When limit is reached:**
- Ghost text stops appearing
- Dialog box appears: "Daily limit reached. Upgrade to Helio Pro for unlimited generations"

### **Helio Pro (V1)**
- Everything in Free
- **Unlimited generations per day**
- **Pricing:**
  - $10/month (monthly billing)
  - $8/month ($96/year, annual billing—20% discount)

### **Helio Pro (V2)**
- Everything in V1 Pro
- **+ Connectors:** Integration with Google Drive, Jira, Fireflies, GitHub, Slack, Calendar, Notion, Linear, Dropbox, Asana (minimum 10)
- **+ Multilingual Support:** Automatic translation in 5+ scenarios, Hinglish/slang support, 10+ languages
- **Pricing:** TBD (likely $15-20/month)

### **Revenue Projections**

**Year 1 (Conservative):**
- 10,000 free users
- 10% conversion = 1,000 paid users
- $10K MRR ($120K ARR)

**Year 2 (Optimistic):**
- 50,000 free users  
- 15% conversion = 7,500 paid users
- $75K MRR ($900K ARR)

***

## **5. Success Metrics**

### **V1 Metrics**
- **Activation Rate:** % of new users who accept at least one ghost text suggestion (Tab press) within first session
- **Daily Active Users (DAU):** Users who trigger Helio at least once per day
- **Engagement:** Average number of accepted suggestions (Tab presses) per active user per day
- **Retention:** Day 7, Day 30, Day 90 retention rates
- **Mode Distribution:** % of usage split between Autocomplete / Generation / Rewriting
- **Conversion Rate:** % of free users who upgrade to Pro

### **V2 Metrics**
- **Connector Adoption:** % of paid users who connect at least one external service
- **Connector Engagement:** Average number of connectors used per active paid user
- **Multilingual Adoption:** % of users who use non-English languages

***

## **6. Core Features - V1 (The Thought Partner)**

V1 delivers a flawless, zero-friction, system-wide AI copilot experience focused on English-language communication.

### **6.1. System-Wide Ghost Text UI**

**Activation:**
1. User presses a **keyboard shortcut** (default: `Cmd + Shift + Space`, customizable in Settings)
2. User types naturally in any text field (Gmail, Slack, VS Code, Twitter, etc.)
3. Helio automatically detects intent after a **3-second pause** when the user stops typing

**Three Operating Modes:**

Helio intelligently determines which mode to use based on the user's input:

| **Mode** | **User Input Type** | **Behavior** | **Ghost Text Position** | **Accept (`Tab`)** |
|----------|---------------------|--------------|------------------------|-------------------|
| **Autocomplete** | Incomplete sentence/thought | Completes the sentence naturally | Appears inline after cursor (like native autocomplete) | Appends the completion to existing text |
| **Generation** | Question or explicit intent | Generates full response from scratch | Appears 2 lines below (2× Shift+Enter, then paste) | Replaces the question/intent with generated text |
| **Rewriting** | Complete sentence/normal text | Rewrites for clarity/tone/style | Appears 2 lines below (2× Shift+Enter, then paste) | Replaces original text with rewritten version |

**User Controls:**
- **`Tab`:** Accepts the suggestion
  - In Autocomplete: Appends completion
  - In Generation/Rewriting: Deletes original intent, keeps only generated text
- **`Esc`:** Rejects the suggestion
  - Ghost text disappears in all modes
  - Cursor returns to end of original text (unchanged)

**Technical Implementation:**
- Clipboard-based paste for instant appearance (~6-9ms total)
- No character-by-character simulation (imperceptible speed)
- Selected/highlighted text for visual distinction

**Example Workflows:**

**Autocomplete Mode:**
```
User types: "The bug fix will be deployed to prod"
[3-second pause]
Ghost text (inline): "uction by end of day today"
User presses Tab → "The bug fix will be deployed to production by end of day today"
```

**Generation Mode:**
```
User types: "draft email updating client on the login bug"
[3-second pause]
Ghost text (2 lines below):
"Hi [Client Name],

I wanted to give you a quick update on the login issue we discussed. Our team has identified the root cause—a timeout error in Safari—and we're deploying a fix this afternoon. We expect the issue to be fully resolved by end of day.

I'll follow up once the fix is live. Please let me know if you have any questions.

Best regards,"

User presses Tab → Question deleted, email ready to send
```

**Rewriting Mode:**
```
User types: "hey can u send that file thx"
[3-second pause]
Ghost text (2 lines below):
"Hi [Name],

Could you please send me that file when you have a moment? I'd really appreciate it.

Thanks!"

User presses Tab → Casual text replaced with professional version
```

***

### **6.2. Multi-Agent Architecture**

Helio uses a **specialized agent for every application** to ensure contextually perfect output.

**Core Principle:**  
Each agent has its own personality, tone guidelines, and output format optimized for the specific application it serves.

**Priority Applications for V1 (Minimum 20 Agents):**

**Communication:**
- `GmailAgent`: Professional, well-structured emails with appropriate greetings/sign-offs
- `SlackAgent`: Brief, casual, emoji-friendly messages
- `MessagesAgent`: Personal, conversational tone for iMessage
- `WhatsAppAgent`: Context-aware for both personal and group chats
- `DiscordAgent`: Community-friendly, gaming/tech culture aware
- `TeamsAgent`: Professional but slightly more casual than email

**Productivity:**
- `NotionAgent`: Structured, markdown-friendly documentation
- `GoogleDocsAgent`: Long-form, document-style writing
- `AppleNotesAgent`: Quick notes, bullet-point style
- `EvernoteAgent`: Similar to Apple Notes

**Developer Tools:**
- `VSCodeAgent`: Technical, code-aware, concise
- `TerminalAgent`: Command-line focused, minimal output
- `GitHubAgent`: Issue/PR descriptions with technical detail
- `CursorAgent`: AI prompt optimization for code generation
- `LinearAgent`: Engineering task descriptions

**Design Tools:**
- `FigmaAgent`: Design-centric, collaborative language
- `MiroAgent`: Brainstorming, visual thinking style

**Social Media:**
- `TwitterAgent`: Concise, engaging, 280-char limit aware, hashtag suggestions
- `LinkedInAgent`: Professional thought-leadership tone
- `InstagramAgent`: Visual storytelling, caption-focused
- `RedditAgent`: Conversational, context-aware for subreddit culture

**AI Tools (Prompt Supercharger):**
- `ChatGPTAgent`: Transforms simple ideas into expert-level prompts
- `ClaudeAgent`: Optimized for Claude's instruction format
- `MidjourneyAgent`: Detailed image prompts with technical parameters
- `PerplexityAgent`: Research-focused query optimization

**Other:**
- `DefaultAgent`: Handles any unknown application with general-purpose intelligence

**Agent Behavior:**  
- Each agent has unique system prompts and guidelines
- Non-configurable by user in V1 (to maintain quality)
- Learns and adapts over time via the learning system

***

### **6.3. Adaptive Learning System**

Helio learns from every `Tab` (accept) and `Esc` (reject) to personalize future suggestions.

**What Helio Learns:**
- **Tone:** Formal vs. casual, enthusiastic vs. neutral, friendly vs. direct
- **Format:** Bullet points vs. paragraphs, long-form vs. brief, emoji usage
- **Vocabulary:** Personal slang, industry jargon, technical terms, preferred phrases
- **Relationship Context:** Communication patterns without reading actual content ("No, what are they talking about"—learns metadata like "casual with John," not the content of messages)

**Learning Scope:**
- **Per-Recipient:** Understands different tones for different people ("casual with John, formal with Sarah")
- **Per-App:** Adapts to context ("always brief in Slack, detailed in Gmail")
- **Combined:** "When messaging John in Slack, ultra-casual. When emailing John, more professional."

**Privacy-First Approach:**
- Learns **metadata** (tone, structure, style patterns) NOT actual message content
- Sensitive content never stored or transmitted
- All learning happens locally on-device when possible
- Only anonymized patterns synced to cloud for cross-device consistency (hybrid storage model)
- Users can view and delete all learning data via Settings

**User Communication:**
- During onboarding: "We follow Apple-level privacy. We learn the way you write, not what you write."
- No visible learning indicators, progress bars, or notifications
- Silent improvement over time

**Technical Implementation:**
- Lightweight metadata storage (tone scores, format preferences, vocabulary lists)
- On-device processing prioritized
- Encrypted cloud sync for cross-device learning
- User can reset learning data at any time

---

### **6.4. Voice Input (Secondary Input Method)**

In addition to typing, users can activate Helio and speak their intent.

**How It Works:**
1. User presses keyboard shortcut + speaks instead of typing
2. Speech-to-text converts voice to text intent
3. Helio processes normally and generates ghost text
4. User still uses `Tab`/`Esc` to accept/reject

**Use Cases:**
- Hands-free operation (walking, standing)
- Faster input for long intents
- Accessibility

**Technical Implementation:**
- Use Apple's built-in Speech Recognition API (no third-party service needed)
- Works offline
- Privacy-preserving (on-device processing)

**Scope for V1:**
- English voice input only
- Basic implementation (nice-to-have, not critical for launch)

---

### **6.5. Universal Prompt Supercharger**

A key use case for Helio is enhancing prompts for other AI tools.

**The Problem:** Most people write mediocre prompts to AI tools, resulting in mediocre outputs.

**Helio's Solution:** When a user is in ChatGPT, Midjourney, Claude, or any AI interface, the relevant agent transforms simple, casual prompts into expert-level instructions.

**Example (Midjourney):**
```
User types: "robot in forest"
[3-second pause]
MidjourneyAgent ghost text:
"/imagine prompt: a cinematic, photorealistic shot of a lone, weathered humanoid robot walking through a misty, ancient redwood forest at sunrise, volumetric god rays piercing through the canopy, detailed mechanical joints with rust and wear, 8K resolution, octane render, --ar 16:9 --v 6 --stylize 750"

User presses Tab → Expert-level image generated
```

**Example (ChatGPT):**
```
User types: "explain quantum computing"
[3-second pause]
ChatGPTAgent ghost text:
"Explain quantum computing to me as if I'm a software engineer with no physics background. Start with the core principles (qubits, superposition, entanglement), then explain how it differs from classical computing, and finally give me 2-3 practical applications that are relevant to my field. Use analogies where helpful."

User presses Tab → Much better response from ChatGPT
```

**Positioning:** Helio is the "meta-AI"—the AI that makes you better at using other AIs.

***

## **7. Core Features - V2 (The Action Engine)**

V2 transforms Helio from a "thought partner" into an "action engine" by adding Connectors and Multilingual Support.

### **7.1. Connector Framework**

**Core Principle:**  
Connectors are **read-only**. They exist solely to pull contextual information into Helio's agents to enrich text generation. Helio will **never** perform actions (create tickets, send emails, modify files) in external applications.

**What Connectors Do:**
- Authenticate securely via OAuth (credentials stored in macOS Keychain)
- Search and retrieve information via APIs
- Pass context to the active agent to generate richer, more accurate text

**What Connectors DON'T Do:**
- Perform actions in other apps
- Modify or create data
- Act as automation tools

**The Key Difference from Notion AI:**
- **Notion AI Connectors:** Pull data into Notion for documentation and knowledge work
- **Helio Connectors:** Pull data into real-time communication drafting across all apps

***

### **7.2. Priority Connectors for V2 (Minimum 10)**

**Tier 1 (Launch):**
1. **Google Drive:** Search documents, presentations, spreadsheets for relevant information
2. **Jira:** Fetch ticket details, status, descriptions, comments
3. **Fireflies.ai:** Search meeting transcripts for keywords, summaries, action items
4. **GitHub:** Read repository code, issues, PR descriptions, commit history
5. **Slack:** Search past messages, threads, channels for context
6. **Google Calendar:** Find meeting times, attendees, agendas, locations
7. **Notion:** Pull content from pages, databases, project docs
8. **Linear:** Fetch issue/project details (alternative to Jira for startups)
9. **Dropbox:** Search for files and folders
10. **Asana:** Fetch task details, project status

**Tier 2 (Post-Launch):**
- Microsoft Teams
- Confluence
- Salesforce
- HubSpot
- Trello
- Monday.com

***

### **7.3. Connector Behavior & User Experience**

**Activation:**
- **Automatic:** Helio intelligently decides which connectors to activate based on user intent
  - Example: User mentions "the bug" → `JiraConnector` activates
  - Example: User mentions "last meeting" → `FirefliesConnector` activates
- **Explicit:** User can specify a connector
  - Text: `"helio + fireflies: draft email about bug"`
  - Voice: "Find it in Fireflies"

**User Experience:**
- **Completely invisible:** No loading indicators, spinners, or notifications
- Ghost text simply appears, enriched with connector data
- User has no idea connectors are working in the background—it just feels like Helio is "smarter"

**Error Handling:**
- If a connector fails (API down, authentication expired, no results found), a **small, non-intrusive popup** appears:
  - "Couldn't connect to Jira. Generated text without that context."
- Popup auto-dismisses after 3 seconds
- Helio generates the best possible text without that connector's data

**Privacy & Permissions:**
- Users must explicitly connect each service via Settings
- OAuth authentication (users log in directly to the service, not through Helio)
- Helio only requests read-only permissions
- Users can disconnect services at any time

---

### **7.4. Connector Workflow Examples**

**Example 1: Email with Jira + Fireflies Context**
```
Context: User is in Gmail
User types: "helio: update john about the login bug"
[3-second pause]

Behind the scenes:
- GmailAgent activates
- Detects "login bug" → activates JiraConnector
- JiraConnector finds: Ticket BUG-451 "Login page timeout on Safari"
- Detects "john" + "bug" → activates FirefliesConnector
- FirefliesConnector finds: Meeting transcript from Nov 3 where John said this is P1

Ghost text appears:
"Hi John,

Quick update on the login bug (BUG-451) we discussed on Nov 3rd. Our team has identified the root cause—Safari is timing out on the login page due to a caching issue. We're deploying a fix this afternoon and expect it to be resolved by EOD.

I'll keep you posted once it's live.

Best,"

User presses Tab → Email ready to send with zero manual lookup
```

**Example 2: GitHub Issue with Meeting Context**
```
Context: User is in GitHub issue description field
User types: "helio: create issue for new feature discussed in design meeting"
[3-second pause]

Behind the scenes:
- GitHubAgent activates
- Detects "design meeting" → activates FirefliesConnector
- FirefliesConnector finds: Latest design meeting transcript with feature discussion

Ghost text appears:
"## Feature Request: Dark Mode Toggle

### Context
Discussed in design meeting on Nov 5th. Users are requesting a system-wide dark mode option that respects OS settings.

### Requirements
- Toggle in Settings panel
- Persist user preference
- Respect system theme by default
- Apply to all UI components

### Design Mockups
See Figma file linked in meeting notes

### Priority
P2 - Target for Q1 2026 release"

User presses Tab → Issue created with all context, no copy-pasting
```

**Example 3: Slack Message with Calendar Context**
```
Context: User is in Slack
User types: "helio: remind team about tomorrow's standup"
[3-second pause]

Behind the scenes:
- SlackAgent activates
- Detects "tomorrow's standup" → activates CalendarConnector
- CalendarConnector finds: Standup meeting tomorrow at 10 AM, Conference Room B

Ghost text appears:
"Hey team 👋

Quick reminder: standup tomorrow (Nov 7) at 10 AM in Conference Room B. See you there!"

User presses Tab → Message sent with exact details, no calendar lookup
```

***

### **7.5. Multilingual Support**

Helio will support automatic language detection and translation across all three operating modes.

**Core Principle:**  
Helio detects both the **input language** (what the user types) and intelligently determines the **target language** (what the output should be) based on context.

***

### **Translation Scenarios**

Helio supports five translation scenarios:

| **Scenario** | **User Input** | **Helio Output** | **Example** |
|-------------|----------------|------------------|-------------|
| **1. Language → English** | User types in any language | Generates in English | User: मुझे मीटिंग कैंसल करनी है → Output: "I need to cancel the meeting" |
| **2. English → Language** | User types in English | Generates in target language based on context | User: "draft meeting invite" → Output: मीटिंग का आमंत्रण (if context suggests Hindi) |
| **3. Language → Different Language** | User types in Language A | Generates in Language B | User: Hola, cómo estás → Output: Bonjour, comment vas-tu |
| **4. Slang → Slang** | User types in Hinglish | Generates in another slang mix | User: "bhai meeting cancel kardo" → Output: (maintains Hinglish style) |
| **5. English ↔ Slang** | User types in English | Generates in Hinglish (or vice versa) based on context | User: "Cancel the meeting" → Output: "Bhai meeting cancel kar do" |

***

### **Automatic Language Detection**

**How It Works:**
1. **Input Detection:** When user types, Helio analyzes the language(s) used
2. **Context Analysis:** Helio considers:
   - The application (WhatsApp = casual, LinkedIn = professional)
   - The detected input language
   - The communication context (formal vs. informal)
3. **Target Language Selection:** Helio intelligently decides output language

**Key Behaviors:**
- **No per-recipient memory:** Helio does NOT remember "Priya prefers Hindi." Instead, it detects the language the user types *in that moment*
- **Dynamic switching:** If user normally writes in Hinglish but suddenly types pure English, Helio responds in English
- **Mixing style preservation:** For slang languages like Hinglish, Helio preserves the user's Hindi-English mixing ratio

**Example Scenarios:**

**Scenario 1: Hinglish Input (WhatsApp)**
```
User types: "bhai meeting 5pm pe hai reminder bhej"
[3-second pause]
Helio detects: Hinglish input, WhatsApp (casual context)
Ghost text: "Bhai, reminder: meeting aaj 5pm pe hai. Don't forget!"
```

**Scenario 2: Hindi → English (Gmail, Professional)**
```
User types: [translate:क्लाइंट को अपडेट भेजना है]
[3-second pause]
Helio detects: Hindi input, Gmail (professional), needs English output
Ghost text:
"Hi [Client Name],

I wanted to provide you with a quick update on the project status. We're on track for the milestone delivery next week. Please let me know if you need any additional information.

Best regards,"
```

**Scenario 3: English → Hinglish (Slack, Team Context)**
```
User types: "need to tell team about delay"
[3-second pause]
Helio detects: English input, Slack (team chat, casual)
Ghost text: "Team, heads up – thoda delay ho raha hai project mein. Will keep you posted!"
```

***

### **Language Priority**

**Tier 1 (V2 Launch):**
- English (primary)
- Hindi
- Hinglish (Hindi-English code-mixing)

**Tier 2 (3-6 Months Post-V2):**
- Spanish
- French
- German
- Mandarin Chinese
- Portuguese
- Arabic

**Tier 3 (Future):**
- Japanese, Korean, Italian, Russian
- Other popular languages based on user demand

***

### **Slang & Code-Mixing Behavior**

For languages like Hinglish (or Spanglish, Franglais in future), Helio will:

1. **Preserve Mixing Style:** If user writes with 80% Hindi / 20% English, Helio maintains similar ratio
2. **Match Formality:** Casual Hinglish for friends, more formal Hindi for professional contexts
3. **Vocabulary Learning:** Over time, learns user's preferred slang terms

**Example:**
```
User's typical style: Heavy Hindi, light English (80/20 mix)
Input: "boss ne kaha meeting postpone kardo"
Output: "Team ko bata do ki boss ne meeting postpone kar di hai, nayi date confirm hone pe update milega"

User's typical style: Balanced Hinglish (50/50 mix)
Input: "boss said postpone the meeting"
Output: "Hey team, meeting postpone ho gayi hai, will update you with the new date soon"
```

***

### **Translation in All Three Modes**

**Autocomplete Mode:**
- User types partial sentence in Hindi: मुझे लगता है कि हमें...
- Helio completes in Hindi: प्रोजेक्ट की समीक्षा करनी चाहिए

**Generation Mode:**
- User asks in Hinglish: "how to explain new feature to clients?"
- Helio generates full response in appropriate language based on app context

**Rewriting Mode:**
- User types casual Hinglish: "bhai client ko update do"
- Helio rewrites professionally in English: "Hi [Client], I wanted to update you on the current status..."

***

### **No Manual Language Selection (V2)**

- No language dropdown or selector UI
- Fully automatic detection and generation
- **Future consideration:** Manual override (e.g., `helio in hindi:`) if user demand is high

***

## **8. Technical Architecture**

### **8.1. Platform**
- **Operating System:** macOS native application (Swift + Rust hybrid)
- **Minimum Version:** macOS 13 (Ventura) or later
- **System Requirements:** 
  - Accessibility API permissions
  - Apple Silicon or Intel processor
  - 4GB RAM minimum

### **8.2. Backend & AI**
- **Testing Environment:** OpenRouter (for flexible model testing during development)
- **Production Environment:**
  - **OpenAI (GPT-4/GPT-4-Turbo):** General-purpose tasks, autocomplete, rewriting
  - **Anthropic (Claude 3.5 Sonnet):** Writing prompts for other AIs, long-form generation, complex reasoning
  - **Future (V2+):** Local on-device model (likely Llama 3-based) for privacy-sensitive tasks and offline functionality

### **8.3. Data Storage**
- **Hybrid Model:**
  - **Local (On-Device):** User preferences, learning patterns, sensitive personalization data, recent generation history
  - **Cloud (Encrypted):** Anonymized usage patterns for cross-device sync, connector authentication tokens, subscription status
- **Database:** SQLite (local), PostgreSQL (cloud)
- **Storage Location:** macOS Application Support folder + iCloud sync

### **8.4. Connector Integration**
- RESTful API calls to third-party services
- OAuth 2.0 for secure authentication
- Credentials stored in macOS Keychain (never in Helio's servers)
- Rate limiting and caching to optimize API usage

### **8.5. Performance Targets**
- Ghost text appears within **1 second** of 3-second pause (target: 500ms)
- Keyboard simulation (Shift+Enter, Cmd+V) takes **6-9ms** (imperceptible)
- Agent switching: **Instant** (context-aware detection)
- App memory footprint: **<100MB** idle, <500MB active

***

## **9. Privacy & Security**

**Core Commitment:**  
"We follow Apple-level privacy. We learn the way you write, not what you write."

### **Data Principles**
- Helio does **not** store the content of user communications
- Learning data is **anonymized and encrypted**
- All connector API calls are **ephemeral** (no content caching beyond current session)
- Users can **delete all learning data** at any time via Settings
- **No third-party data sharing** (user data never sold or shared)

### **Compliance**
- GDPR-compliant (EU privacy regulations)
- CCPA-compliant (California privacy regulations)
- SOC 2 Type II certification (for enterprise adoption in future)

### **Security**
- OAuth tokens stored in macOS Keychain
- All API communication over HTTPS/TLS
- Local data encrypted at rest
- Cloud data encrypted in transit and at rest
- Regular security audits

***

## **10. User Interface & Settings**

While Helio is designed to be zero-configuration out of the box, there is a **minimal Settings panel** accessible via a menu bar icon.

### **Settings Include:**

**General:**
- Keyboard shortcut customization (default: `Cmd + Shift + Space`)
- Enable/disable voice input
- Daily generation counter (for free tier)

**Connectors (V2):**
- Add/remove external service integrations
- Re-authenticate services
- View which connectors have been used recently

**Learning & Privacy:**
- View learning data (tone patterns, vocabulary preferences)
- Reset learning data
- Export learning data
- Delete all data

**Account & Billing:**
- Upgrade to Pro
- Manage subscription
- Payment method
- Billing history

**About:**
- Version info
- Release notes
- Send feedback
- Contact support

***

## **11. Out of Scope**

**For V1 & V2:**
- Voice input integration beyond basic implementation (advanced features deferred)
- Windows, Linux, or web versions
- Mobile apps (iOS/iPadOS)
- Team/enterprise features (shared learning, admin dashboards, team billing)
- Helio performing actions in other apps (creating tickets, sending emails, modifying files)
- Browser extension (native app only)
- Offline mode for AI inference (requires internet for V1/V2)

**Explicitly NOT Building:**
- A chat interface or command center
- A separate window or panel
- Background automation or task scheduling
- Integration with non-macOS platforms

***

## **12. Go-to-Market Strategy**

### **Pre-Launch (Now → Nov 30)**

**Week 1-2: Build & Polish**
- Complete V1 core features
- Internal testing
- Bug fixes
- Performance optimization

**Week 3: Marketing Assets**
- **Demo Video (30 seconds):**
  - Problem: Writing is slow, context-switching kills flow
  - Solution: Ghost text appears, Tab to accept
  - Show it in Gmail, Slack, VS Code
  - End: "Download Helio. macOS only."
- **Product Page:**
  - Clean landing page with download button
  - Feature highlights
  - Demo video embedded
  - Email capture for beta list
- **Product Hunt Assets:**
  - Hunter comment (use PRD for inspiration)
  - 5 screenshots showing different apps
  - Tagline: "The universal AI copilot for macOS"

**Week 4: Beta Testing**
- Recruit 10-20 beta testers from Twitter/Reddit
- Gather feedback
- Final bug fixes

***

### **Launch (Dec 1-7)**

**Day 1: Product Hunt**
- Launch on Tuesday or Wednesday (highest traffic)
- Goal: #1 Product of the Day
- Expected: 5-10K visitors if successful

**Day 1-7: Social Media Blitz**
- **Twitter:** 
  - Thread explaining the vision
  - Tag @levelsio, @bentossell, indie hacker influencers
  - Demo video pinned
- **Reddit:**
  - Post in r/macapps, r/SideProject, r/productivity
  - Include demo video
- **Indie Hackers:**
  - Launch post with metrics and journey
- **LinkedIn:**
  - Professional angle: "Built a productivity tool in 1 month"
- **Hacker News:**
  - "Show HN: Helio – System-wide AI copilot for macOS"

**Day 7: Reach Out to Influencers**
- DM 10 Mac productivity YouTubers
- Offer free Pro access for review
- Target: 1-2 reviews by end of month

---

### **Post-Launch (Dec 8 → Jan 31)**

**Weeks 2-4: Iteration**
- Daily user feedback monitoring
- Ship bug fixes and improvements
- Weekly updates to community

**Month 2-3:**
- Continue marketing (blog posts, more videos)
- Build V2 features (Connectors + Multilingual)
- Prepare V2 launch

---

## **13. Success Criteria**

### **V1 Launch Success**
- **1,000 downloads** in first week
- **100 active daily users** by end of Week 2
- **10%+ conversion rate** to Pro by end of Month 1
- **#1 or2 Product of the Day on Product Hunt
- **One tech YouTuber review** by end of Month 1

### **V1 Sustainability (3 Months)**
- **10,000 total users**
- **1,000 paid users** ($10K MRR)
- **70%+ Week 1 retention**
- **30%+ Month 1 retention**

### **V2 Launch Success (6 Months)**
- **50,000 total users**
- **5,000 paid users** ($50K MRR)
- **50%+ of paid users connect at least one connector**
- **20%+ of users use multilingual features**

***

## **14. Risks & Mitigation**

### **Technical Risks**

**Risk 1: Accessibility API Limitations**
- Some apps may not expose text fields properly
- **Mitigation:** Test top 20 apps extensively, document known limitations, prioritize compatibility

**Risk 2: Performance Issues**
- AI inference could be slow (<1 second target)
- **Mitigation:** Use streaming responses, optimize prompts, consider edge caching

**Risk 3: Connector API Changes**
- Third-party services could change/break APIs
- **Mitigation:** Monitor API status, build fallback behaviors, communicate with users

***

### **Business Risks**

**Risk 1: Apple Competition**
- Apple could build this natively into macOS
- **Mitigation:** Move fast, build defensibility through learning system and connectors, target acquisition

**Risk 2: Low Conversion Rate**
- Free users may not upgrade to Pro
- **Mitigation:** 
  - Lower free tier limit if needed (15 gens/day)
  - Aggressive upgrade prompts at limit
  - Use cheaper models for free tier

**Risk 3: High LLM Costs**
- Free tier could become expensive at scale
- **Mitigation:**
  - Optimize prompts for token efficiency
  - Use cheaper models (GPT-4-mini) for simple tasks
  - Implement local models for basic operations (future)

**Risk 4: Distribution Failure**
- Product doesn't go viral or get noticed
- **Mitigation:**
  - Demo video is the #1 priority
  - Multiple launch channels (PH, HN, Reddit, Twitter)
  - Direct outreach to influencers

***

### **Market Risks**

**Risk 1: Competitors Copy Features**
- Grammarly/Superhuman could add similar UX
- **Mitigation:** Multi-agent system and learning create moat, move fast on V2

**Risk 2: User Trust/Privacy Concerns**
- Users may not trust AI with their communications
- **Mitigation:** Transparent privacy policy, Apple-level messaging, on-device learning

***

## **15. Timeline & Milestones**

### **Phase 1: Build (Nov 6 → Dec 1)**
- **Week 1 (Nov 6-12):** Core architecture, Accessibility API integration, basic ghost text
- **Week 2 (Nov 13-19):** Multi-agent system, 20+ agents implemented
- **Week 3 (Nov 20-26):** Learning system, voice input, settings UI
- **Week 4 (Nov 27-Dec 1):** Testing, bug fixes, marketing assets, beta testing

### **Phase 2: Launch (Dec 1-7)**
- **Dec 1:** Product Hunt launch
- **Dec 1-7:** Social media blitz, community engagement

### **Phase 3: Iterate (Dec 8 → Jan 31)**
- Daily bug fixes and improvements
- User feedback integration
- Marketing content (blog posts, videos)

### **Phase 4: V2 Build (Feb 1 → Apr 30)**
- Connector framework (Feb)
- 10 connectors implementation (Mar)
- Multilingual support (Apr)
- V2 beta testing

### **Phase 5: V2 Launch (May 1)**
- Product Hunt launch (V2 announcement)
- Upgrade campaign for existing users
- Target: 5,000 paid users by June 30

***

## **16. Open Questions & Next Steps**

### **Open Questions**
1. What is the exact keyboard shortcut? (Avoid conflicts with system shortcuts)
2. How to handle apps with custom text editors (VS Code Monaco, Notion block editor)?
3. What is fallback if 3-second detection fails or feels too slow?
4. Should there be a visual indicator when Helio is "thinking"?

### **Next Steps (Immediate)**
1. Finalize tech stack (Swift vs. Swift+Rust)
2. Set up development environment
3. Begin Accessibility API research and prototyping
4. Start work on 30-second demo video script
5. Register domain and set up landing page

---

## **17. Appendix**

### **Competitive Landscape Summary**

| Feature | Grammarly | Notion AI | Copilot | Superhuman | **Helio** |
|---------|-----------|-----------|---------|------------|-----------|
| System-wide | ✅ | ❌ | ❌ | ❌ | ✅ |
| Per-app agents | ❌ | ❌ | ❌ | ❌ | ✅ |
| Learning system | ❌ | ❌ | ❌ | ❌ | ✅ |
| Connectors (for comms) | ❌ | ❌ | ❌ | ❌ | ✅ |
| Ghost text UX | ❌ | ❌ | ✅ | ❌ | ✅ |
| Voice input | ❌ | ❌ | ❌ | ❌ | ✅ |
| Multilingual | ✅ | ✅ | ✅ | ❌ | ✅ (V2) |

**Helio is the only product combining all of these features.**

---

**End of PRD**

