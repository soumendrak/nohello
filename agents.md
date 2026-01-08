# Trace Master: 911 - Technical Requirements Document

## Overview

**Game Title:** Trace Master: 911  
**Genre:** Puzzle / Educational / Root Cause Analysis (RCA) Mystery  
**Platform:** Static Web (Browser-based)  
**Tech Stack:** HTML5, CSS3 (Tailwind CSS), Vanilla JavaScript, LocalStorage

---

## Game Concept

You are an "AI Ops Engineer" on call. Each level is a "Ticket" that you must resolve before the "Customer Frustration" meter reaches 100%. Investigate AI agent traces, analyze LLM logs, and identify the root cause of AI system failures.

### AI Observability Focus

This game teaches players to debug modern AI/LLM systems, not traditional infrastructure. Key concepts include:

- **Hallucination Detection:** LLM generating false/fabricated information
- **Context Window Overflow:** Input exceeding token limits
- **Prompt Injection:** Malicious prompts bypassing safety guardrails
- **RAG Retrieval Failures:** Wrong or irrelevant documents retrieved
- **Text-to-SQL Errors:** Generated SQL queries returning wrong data
- **Agent Task Completion:** Multi-step agents failing mid-workflow
- **Tool Call Failures:** Agents calling wrong tools or with bad parameters
- **Guardrail Violations:** Content safety filters triggering incorrectly
- **Embedding Drift:** Vector similarity returning poor matches
- **Token Cost Explosions:** Runaway token usage from loops

---

## Technical Architecture

### File Structure

```
nohello/
├── index.html              # Single-page site with game section at bottom
├── README.md
├── agents.md               # This document
└── wrangler.jsonc
```

### Page Layout

The game is integrated into `index.html` as a section at the bottom of the page:

```
┌─────────────────────────────────────────┐
│  Hero Section (No Hello message)        │
├─────────────────────────────────────────┤
│  Problem Demonstration                  │
├─────────────────────────────────────────┤
│  Why This Matters                       │
├─────────────────────────────────────────┤
│  More Examples                          │
├─────────────────────────────────────────┤
│  Call to Action (Share)                 │
├─────────────────────────────────────────┤
│  ★ GAME SECTION: Trace Master: 911 ★   │  ← New section
│  (Full game UI embedded here)           │
├─────────────────────────────────────────┤
│  Footer                                 │
└─────────────────────────────────────────┘
```

All game CSS and JavaScript will be inline within `index.html` to maintain the single-file static site architecture.

**CRITICAL IMPLEMENTATION NOTE:** To prevent conflicts with the existing site, all game JavaScript MUST be namespaced (e.g., inside a `const TraceMaster = { ... }` object) and all CSS classes should use a prefix (e.g., `tm-`) or be scoped within the game container ID.

### Technology Constraints

| Requirement | Implementation |
|-------------|----------------|
| Framework | None - Vanilla JavaScript only |
| Styling | Tailwind CSS via CDN |
| Icons | Font Awesome via CDN |
| Fonts | Inter (Google Fonts) |
| Storage | Browser LocalStorage |
| Build Process | None - static files only |
| Server | None required - runs entirely client-side |

---

## Core Game Mechanics

### 1. Ticket System

Each level presents a "ticket" with:
- **Ticket ID:** Unique identifier (e.g., `TKT-001`)
- **Reporter:** Fictional user name (e.g., "PizzaLover123")
- **Issue Description:** The reported problem
- **Severity:** Low / Medium / High / Critical
- **Time Limit:** Seconds before frustration meter hits 100%

### 2. AI Agent Trace Visualization

Display a simplified AI agent trace view:
- **Desktop:** Horizontal waterfall bars representing AI pipeline steps
- **Mobile:** Vertical card list view (to avoid horizontal scrolling)
- **Span Types:**
  - LLM Call (model, tokens in/out, latency)
  - RAG Retrieval (documents retrieved, relevance scores)
  - Tool/Function Call (tool name, parameters, result)
  - Guardrail Check (pass/fail, violation type)
  - Agent Step (task, reasoning, action taken)
- **AI Metrics Displayed:**
  - Token count (input/output)
  - Latency (ms)
  - Confidence/relevance scores
  - Cost estimate ($)
- **Clickable:** Each span reveals detailed logs and AI-specific data

### 3. AI Log Viewer

When a span is clicked, show AI-specific information:
- **LLM Calls:** Prompt snippet, completion snippet, model used, temperature
- **RAG Steps:** Query, retrieved chunks, similarity scores
- **Tool Calls:** Function name, arguments, return value
- **Agent Reasoning:** Chain-of-thought, decision made
- **Errors:** Hallucination flags, guardrail triggers, timeout reasons

### 4. Fix Actions

Player can choose from AI-specific remediation actions:
- **Adjust Prompt Template** - Fix prompt engineering issues
- **Update RAG Index** - Reindex or fix retrieval configuration
- **Fix Tool Schema** - Correct function calling definitions
- **Tune Guardrails** - Adjust safety filter thresholds
- **Increase Context Window** - Switch to larger context model
- **Add Few-Shot Examples** - Improve LLM output quality
- **Fix SQL Schema Mapping** - Correct text-to-SQL table mappings
- **Clear Vector Cache** - Reset embedding cache

Only one action is correct per level.

### 5. Frustration Meter

- Starts at 0%
- Increases over time (configurable rate per level)
- **Penalty:** +10% increase for selecting a wrong action (prevents spamming)
- Game over if reaches 100%
- Visual progress bar with color gradient (green → yellow → red)

### 6. Field Guide (Docs)

- In-game glossary available via a "Docs" tab
- Explains key AI concepts (e.g., "What is RAG?", "What is Hallucination?")
- Accessible during gameplay without pausing the timer (adds pressure tradeoff)

---

## Data Models

### Level/Ticket Schema

```javascript
{
  id: "TKT-001",
  title: "The Hallucinating Recipe Bot",
  reporter: "PizzaLover123",
  description: "AI recipe assistant is inventing ingredients that don't exist!",
  severity: "high",
  timeLimit: 120, // seconds
  frustrationRate: 0.5, // % per second
  xpReward: 100, // Awarded on first completion only (or reduced on replay)
  category: "hallucination", // AI issue category
  spans: [
    {
      id: "span-1",
      type: "llm-call",
      service: "GPT-4 Turbo",
      status: "success",
      latency: 1250,
      tokensIn: 450,
      tokensOut: 380,
      cost: 0.02,
      logs: [
        { level: "INFO", message: "Prompt: Generate a pizza recipe for user" },
        { level: "INFO", message: "Temperature: 0.9, Max tokens: 500" },
        { level: "WARN", message: "High temperature setting detected" }
      ]
    },
    {
      id: "span-2",
      type: "rag-retrieval",
      service: "Recipe Knowledge Base",
      status: "success",
      latency: 85,
      documentsRetrieved: 3,
      avgRelevanceScore: 0.42,
      logs: [
        { level: "INFO", message: "Query: pizza recipe ingredients" },
        { level: "WARN", message: "Relevance scores: [0.45, 0.41, 0.39] - Below threshold 0.7" },
        { level: "WARN", message: "Retrieved docs may not be relevant to query" }
      ]
    },
    {
      id: "span-3",
      type: "guardrail",
      service: "Factuality Checker",
      status: "disabled",
      latency: 0,
      logs: [
        { level: "ERROR", message: "Guardrail SKIPPED - Feature flag disabled" },
        { level: "ERROR", message: "No hallucination detection performed" }
      ]
    }
  ],
  rootCause: "span-3",
  correctAction: "tune-guardrails",
  explanation: "The Factuality Checker guardrail was disabled, allowing hallucinated content to pass through. The low RAG relevance scores (0.42 avg) meant the LLM had poor context, and combined with high temperature (0.9), it invented ingredients.",
  redHerrings: ["span-2"] // Low relevance looks suspicious but guardrail is the fix
}
```

### Player Data Schema (LocalStorage)

```javascript
{
  playerName: "Telemetrist",
  totalXP: 0,
  level: 1,
  ticketsResolved: 0,
  ticketsFailed: 0,
  averageResolveTime: 0,
  unlockedTools: ["basic-trace"],
  completedTickets: ["TKT-001", "TKT-002"],
  highScores: {
    "TKT-001": { time: 45, xp: 100 },
    "TKT-002": { time: 62, xp: 150 }
  },
  settings: {
    soundEnabled: true,
    darkMode: false
  }
}
```

---

## UI Components

### 1. Main Menu Screen

- Game title with animation
- "New Game" button
- "Continue" button (if save exists)
- "Leaderboard" (local high scores)
- "Settings" button
- Player stats summary

### 2. Game Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│  TICKET: TKT-001                    FRUSTRATION: [████░░] 65% │
│  Reporter: PizzaLover123            Time: 0:45                │
├─────────────────────────────────────────────────────────────┤
│  "AI recipe is coming out in Latin instead of English!"      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  DISTRIBUTED TRACE                                           │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ [API Gateway]      ████████░░░░░░░░░░░░  200  45ms   │   │
│  │ [Translation Eng]  ████████████████████  200  230ms  │   │
│  │ [Config Service]   █░░░░░░░░░░░░░░░░░░░  500  5ms    │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  LOG VIEWER (Click a span to view logs)                      │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ [ERROR] NullPointerException at line 42              │   │
│  │ [ERROR] Failed to load language configuration        │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  ACTIONS                                                     │
│  [Restart Service] [Patch Config] [Scale Up] [Rollback]     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 3. Result Modal

- Success/Failure animation
- XP earned
- Time taken
- Explanation of root cause
- "Next Ticket" / "Retry" buttons

### 4. Unlockables Shop

- Service Map visualization
- Auto-highlight critical errors
- Time freeze power-up
- Hint system

---

## Game Progression

### XP & Leveling

| Level | XP Required | Unlocks |
|-------|-------------|---------|
| 1 | 0 | Basic Trace View |
| 2 | 200 | Service Map |
| 3 | 500 | Error Highlighter |
| 4 | 1000 | Time Freeze (1 use/ticket) |
| 5 | 2000 | Hint System |
| 6+ | +1500/level | Cosmetic themes |

### Difficulty Scaling

- **Early Levels:** Obvious errors (500 status), long time limits
- **Mid Levels:** Red herrings (slow services that aren't broken), shorter time
- **Late Levels:** Multiple issues, cascading failures, very short time

---

## LocalStorage API

### Keys

| Key | Description |
|-----|-------------|
| `traceMaster_playerData` | Main player save data |
| `traceMaster_settings` | User preferences |
| `traceMaster_currentTicket` | In-progress ticket state |

### Functions

```javascript
// Save player data
function savePlayerData(data) {
  localStorage.setItem('traceMaster_playerData', JSON.stringify(data));
}

// Load player data
function loadPlayerData() {
  const data = localStorage.getItem('traceMaster_playerData');
  return data ? JSON.parse(data) : getDefaultPlayerData();
}

// Reset progress
function resetProgress() {
  localStorage.removeItem('traceMaster_playerData');
  localStorage.removeItem('traceMaster_currentTicket');
}
```

---

## Visual Design

### Color Palette

| Element | Color | Hex |
|---------|-------|-----|
| Primary | Purple | `#667eea` |
| Secondary | Blue | `#764ba2` |
| Success | Green | `#10b981` |
| Warning | Yellow | `#f59e0b` |
| Error | Red | `#ef4444` |
| Background | Gray | `#f9fafb` |
| Dark BG | Slate | `#1e293b` |

### Status Indicators

- **200 OK:** Green bar
- **3xx Redirect:** Blue bar
- **4xx Client Error:** Yellow bar
- **5xx Server Error:** Red bar (pulsing animation)
- **Success:** Green bar - Step completed normally
- **Warning:** Yellow bar - Completed but with concerning metrics
- **Error:** Red bar (pulsing) - Step failed
- **Skipped/Disabled:** Gray bar (dashed) - Step was bypassed

### UX Improvements

- **Auto-Scroll:** On page load, if a game session is active in LocalStorage, automatically scroll down to the game section.
- **Mobile Optimization:** Trace view switches to vertical cards on screens < 768px.
- **Frustration Penalty:** Frustration meter increases when player makes incorrect actions, leading to a penalty in score or time.

### AI-Specific Visual Indicators

- **Token Usage:** Bar showing tokens used vs limit
- **Relevance Score:** Gauge (0-1) for RAG retrieval quality
- **Confidence Score:** Percentage badge on LLM outputs
- **Cost Badge:** Dollar amount per span
- **Hallucination Risk:** Warning icon when confidence < threshold

### Animations

- Span bars slide in from left
- Frustration meter pulses when > 75%
- Success confetti on ticket resolution
- Shake animation on wrong action

---

## Sound Effects (Optional)

If implementing audio:
- Ticket arrival notification
- Clock ticking (when time low)
- Success chime
- Failure buzzer
- Click feedback

*Note: Keep audio optional with toggle in settings*

---

## Accessibility

- Keyboard navigation support
- ARIA labels for interactive elements
- Color-blind friendly indicators (icons + colors)
- Pause functionality
- Adjustable text size

---

## Level Content (Initial Set)

### Level 1: The Hallucinating Recipe Bot
- **Category:** Hallucination Detection
- **Root Cause:** Factuality guardrail disabled
- **Red Herring:** Low RAG relevance scores look suspicious
- **Difficulty:** Easy
- **Teaching:** Understanding guardrails and hallucination risks

### Level 2: The SQL Injection Agent
- **Category:** Text-to-SQL Error
- **Root Cause:** SQL schema mapping missing the "orders" table
- **Red Herring:** LLM shows high latency (but query is correct)
- **Difficulty:** Easy
- **Teaching:** Text-to-SQL debugging, schema validation

### Level 3: The Confused Customer Support Agent
- **Category:** RAG Retrieval Failure
- **Root Cause:** Embedding model was updated, causing drift in similarity scores
- **Red Herring:** Agent reasoning looks correct, tool calls succeed
- **Difficulty:** Medium
- **Teaching:** Vector embedding drift, RAG pipeline debugging

### Level 4: The Infinite Loop Agent
- **Category:** Agent Task Completion
- **Root Cause:** Agent stuck in reasoning loop (no exit condition)
- **Red Herring:** Each individual step succeeds
- **Difficulty:** Medium
- **Teaching:** Agent loop detection, task completion metrics

### Level 5: The Prompt Injection Attack
- **Category:** Guardrail Violation
- **Root Cause:** Input guardrail regex too permissive
- **Red Herring:** Output looks normal, LLM metrics healthy
- **Difficulty:** Medium
- **Teaching:** Prompt injection detection, input sanitization

### Level 6: The $500 API Call
- **Category:** Token Cost Explosion
- **Root Cause:** Recursive summarization without token limit
- **Red Herring:** All calls succeed, no errors
- **Difficulty:** Hard
- **Teaching:** Token budgeting, cost monitoring

### Level 7: The Wrong Tool Agent
- **Category:** Tool Call Failure
- **Root Cause:** Tool schema description ambiguous, agent picks wrong tool
- **Red Herring:** Tool execution succeeds (but wrong tool)
- **Difficulty:** Hard
- **Teaching:** Function calling, tool schema design

### Level 8: The Context Window Overflow
- **Category:** Context Limit Error
- **Root Cause:** RAG retrieving too many documents, exceeding context
- **Red Herring:** Retrieval scores are high (too many good matches)
- **Difficulty:** Hard
- **Teaching:** Context window management, chunking strategies

### Level 9: The Biased Recommendation
- **Category:** Guardrail Violation
- **Root Cause:** Bias detection guardrail threshold too high
- **Red Herring:** LLM confidence is high, output looks reasonable
- **Difficulty:** Expert
- **Teaching:** Fairness guardrails, bias detection

### Level 10: The Cascading Agent Failure
- **Category:** Multi-Agent Orchestration
- **Root Cause:** Upstream agent timeout causes downstream agents to use stale context
- **Red Herring:** Individual agents show success status
- **Difficulty:** Expert
- **Teaching:** Multi-agent debugging, distributed AI systems

---

## Milestone-Based Development Plan

> **Note:** This project is structured for a solo developer. Each milestone is a **demoable deliverable** that builds on the previous one. Complete one milestone before starting the next.

---

### Milestone 1: Static Prototype (Demo: "Look, it exists!")
**Goal:** Prove the concept with a non-functional but visually complete mockup  
**Time Estimate:** 2-3 hours  
**Deliverable:** Static HTML section in `index.html` showing the game UI

#### Tasks
- [ ] Add game section HTML structure to `index.html` (after Call to Action, before Footer)
- [ ] Create static ticket display (hardcoded TKT-001)
- [ ] Create static trace visualization (3 hardcoded spans as styled divs)
- [ ] Create static log viewer panel (hardcoded logs)
- [ ] Create action buttons (non-functional)
- [ ] Create frustration meter (static at 65%)
- [ ] Style everything with Tailwind to match existing site

#### Demo Script
> "Here's the game section. You can see a ticket, the AI trace with spans, logs, and action buttons. Nothing works yet, but this is the UI."

#### Definition of Done
- [ ] Game section visible at bottom of page
- [ ] Responsive on mobile
- [ ] Matches existing site's visual style

---

### Milestone 2: Interactive Trace (Demo: "You can click things!")
**Goal:** Make the trace visualization interactive  
**Time Estimate:** 3-4 hours  
**Deliverable:** Clicking spans shows their logs

#### Tasks
- [ ] Convert hardcoded data to JavaScript object (single level)
- [ ] Render spans dynamically from data
- [ ] Add click handlers to spans
- [ ] Show/hide log viewer based on selected span
- [ ] Highlight selected span visually
- [ ] Display span-specific metrics (tokens, latency, cost)

#### Demo Script
> "Now when you click on a span, you see its logs. Click GPT-4 Turbo - see the prompt and temperature. Click the guardrail - see it's disabled."

#### Definition of Done
- [ ] All 3 spans clickable
- [ ] Logs update when span is clicked
- [ ] Visual feedback on selected span

---

### Milestone 3: Win/Lose Logic (Demo: "It's actually a game!")
**Goal:** Add game logic - correct action wins, wrong action loses  
**Time Estimate:** 3-4 hours  
**Deliverable:** Playable single level with win/lose conditions

#### Tasks
- [ ] Add click handlers to action buttons
- [ ] Check if selected action matches `correctAction`
- [ ] Show success modal on correct action
- [ ] Show failure modal on wrong action
- [ ] Display explanation of root cause in result modal
- [ ] Add "Play Again" button to reset state

#### Demo Script
> "Let's play! I'll click 'Tune Guardrails' - success! The explanation shows why. Now let me retry and pick wrong - 'Update RAG Index' - failure!"

#### Definition of Done
- [ ] Correct action shows success modal with explanation
- [ ] Wrong action shows failure modal
- [ ] Can replay the level

---

### Milestone 4: Timer & Frustration (Demo: "Now there's pressure!")
**Goal:** Add time pressure with countdown and frustration meter  
**Time Estimate:** 2-3 hours  
**Deliverable:** Timed gameplay with auto-fail

#### Tasks
- [ ] Add countdown timer display
- [ ] Implement `setInterval` for timer tick
- [ ] Animate frustration meter increasing over time
- [ ] Auto-fail when frustration hits 100%
- [ ] Add color transitions (green → yellow → red)
- [ ] Pause timer when modal is shown

#### Demo Script
> "Watch the frustration meter climb. If I don't solve it in time... game over! The pressure makes it exciting."

#### Definition of Done
- [ ] Timer counts down visually
- [ ] Frustration meter animates smoothly
- [ ] Game auto-fails at 100% frustration

---

### Milestone 5: Multiple Levels (Demo: "There's more content!")
**Goal:** Add level selection and 3 complete levels  
**Time Estimate:** 4-5 hours  
**Deliverable:** 3 playable levels with progression

#### Tasks
- [ ] Create level data for 3 tickets:
  - Level 1: The Hallucinating Recipe Bot (Easy)
  - Level 2: The SQL Injection Agent (Easy)
  - Level 3: The Confused Customer Support Agent (Medium)
- [ ] Add level selection screen/menu
- [ ] Track which levels are completed
- [ ] Show "Next Level" button on success
- [ ] Lock Level 3 until Level 1 & 2 completed

#### Demo Script
> "We have 3 levels now. Let me beat Level 1... success! Now Level 2 unlocks. Each teaches a different AI debugging concept."

#### Definition of Done
- [ ] 3 fully playable levels with unique content
- [ ] Level progression works
- [ ] Each level teaches a different AI concept

---

### Milestone 6: Persistence (Demo: "Your progress is saved!")
**Goal:** Save/load game state with LocalStorage  
**Time Estimate:** 2-3 hours  
**Deliverable:** Progress persists across browser sessions

#### Tasks
- [ ] Implement `savePlayerData()` function
- [ ] Implement `loadPlayerData()` function
- [ ] Save completed levels on win
- [ ] Save best time per level
- [ ] Load state on page load
- [ ] Add "Reset Progress" button in settings

#### Demo Script
> "I'll beat Level 1, refresh the page... my progress is still there! Best time saved too."

#### Definition of Done
- [ ] Progress survives page refresh
- [ ] Best times tracked per level
- [ ] Reset functionality works

---

### Milestone 7: XP & Polish (Demo: "It feels like a real game!")
**Goal:** Add XP system and visual polish  
**Time Estimate:** 3-4 hours  
**Deliverable:** Polished game with progression feedback

#### Tasks
- [ ] Award XP on level completion (based on time remaining)
- [ ] Display total XP and player level
- [ ] Add XP animation on win
- [ ] Add span slide-in animations
- [ ] Add shake animation on wrong answer
- [ ] Add pulsing effect when frustration > 75%
- [ ] Polish result modals with better styling

#### Demo Script
> "Watch the XP counter go up! The faster I solve it, the more XP. See the animations - spans slide in, wrong answers shake."

#### Definition of Done
- [ ] XP system functional
- [ ] Animations enhance the experience
- [ ] Game feels polished and fun

---

### Milestone 8: Content Expansion (Demo: "So much to play!")
**Goal:** Add 2 more levels for total of 5  
**Time Estimate:** 3-4 hours  
**Deliverable:** 5 levels covering key AI observability concepts

#### Tasks
- [ ] Create Level 4: The Infinite Loop Agent (Medium)
- [ ] Create Level 5: The Prompt Injection Attack (Medium)
- [ ] Balance difficulty progression
- [ ] Ensure each level has good red herrings
- [ ] Write educational explanations for each

#### Demo Script
> "5 levels now! From hallucination detection to prompt injection - you're learning real AI debugging skills."

#### Definition of Done
- [ ] 5 complete, balanced levels
- [ ] Difficulty scales appropriately
- [ ] All explanations are educational

---

## Milestone Summary

| Milestone | Deliverable | Time | Cumulative |
|-----------|-------------|------|------------|
| 1 | Static Prototype | 2-3h | 2-3h |
| 2 | Interactive Trace | 3-4h | 5-7h |
| 3 | Win/Lose Logic | 3-4h | 8-11h |
| 4 | Timer & Frustration | 2-3h | 10-14h |
| 5 | Multiple Levels (3) | 4-5h | 14-19h |
| 6 | Persistence | 2-3h | 16-22h |
| 7 | XP & Polish | 3-4h | 19-26h |
| 8 | Content Expansion (5) | 3-4h | 22-30h |

**Total Estimated Time: 22-30 hours** (3-4 days of focused work)

---

## Future Milestones (Post-MVP)

These are **not required** for initial release but can be added later:

### Milestone 9: Advanced Features
- [ ] Hint system (costs XP to use)
- [ ] Dark mode toggle
- [ ] Difficulty settings (Easy/Normal/Hard time limits)

### Milestone 10: More Content
- [ ] Levels 6-10 (Hard/Expert difficulty)
- [ ] Achievement badges
- [ ] Statistics dashboard

### Milestone 11: Nice-to-Have
- [ ] Sound effects (optional toggle)
- [ ] Service map visualization
- [ ] Unlockable tools/power-ups

---

## Testing Checklist

- [ ] Game loads without errors
- [ ] LocalStorage saves/loads correctly
- [ ] Timer counts down accurately
- [ ] Frustration meter increases correctly
- [ ] Correct action resolves ticket
- [ ] Wrong action shows feedback
- [ ] XP awards correctly
- [ ] Level unlocks work
- [ ] Responsive on mobile
- [ ] Works offline (after initial load)

---

## Performance Targets

| Metric | Target |
|--------|--------|
| Initial Load | < 2s |
| Time to Interactive | < 1s |
| LocalStorage Usage | < 100KB |
| No external API calls | ✓ |
| Works offline | ✓ |

---

## Browser Support

- Chrome 80+
- Firefox 75+
- Safari 13+
- Edge 80+
- Mobile browsers (iOS Safari, Chrome Android)

---

## Future Enhancements (Post-MVP)

1. **Multiplayer Mode:** Race against friends (would require backend)
2. **Custom Levels:** Level editor for community content
3. **Themes:** Different visual themes (cyberpunk, retro, etc.)
4. **Tutorials:** Interactive onboarding
5. **Statistics Dashboard:** Detailed analytics of player performance

---

## AI Observability Metrics Glossary

| Metric | Description | Healthy Range |
|--------|-------------|---------------|
| **Token Count** | Input/output tokens per LLM call | Varies by model |
| **Latency** | Time for LLM/RAG/Tool response | <2s for LLM, <100ms for RAG |
| **Relevance Score** | Cosine similarity for RAG retrieval | >0.7 |
| **Confidence Score** | LLM's self-reported confidence | >0.8 |
| **Task Completion Rate** | % of agent tasks completed successfully | >95% |
| **Hallucination Rate** | % of outputs flagged as fabricated | <5% |
| **Tool Call Accuracy** | % of correct tool selections | >98% |
| **Guardrail Pass Rate** | % of outputs passing safety checks | >99% |
| **Cost per Request** | Dollar cost of full pipeline | Varies |
| **Context Utilization** | % of context window used | <80% |

---

## References

- Existing site style: `index.html` (Tailwind, Font Awesome, Inter font)
- Inspiration: AI observability tools (LangSmith, Arize, Weights & Biases)
- Game mechanics: Puzzle/detective games
- AI concepts: LangChain, LlamaIndex, OpenAI function calling

---

*Document Version: 1.0*  
*Created: January 2026*
