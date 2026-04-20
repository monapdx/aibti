# AIBTI · 16 Positive Persona Cards

> Each card = identity name (fun) + positive label (respectful) + superpowers (2) + growth area (1) + prompt template + theory.
>
> **Core principle**: The fun name is the shareable hook; the report always leads with superpowers before growth areas, at a 2:1 ratio. No persona is "better" than another — every style is a signature shaped by real trade-offs in the 2024-2026 AI toolchain.
>
> Chinese version: [PERSONA_CARDS.md](./PERSONA_CARDS.md)

---

## Mystic · The Intuition School

Abstract prompts, trust-first delegation. You see the forest; you let the AI count the trees. The Mystic style plays especially well with *Agent mode* and the `CLAUDE.md` convention, where your standing intent lives in a file so each prompt can stay short. In Karpathy's *Software 3.0* framing, Mystics write the shortest spec with the highest implied context — a move that pays off richly when the standing context is well-maintained, and loses traction when it isn't. Read this school through Anthropic's *Building Effective Agents* (2024.12): you're natural operators of the *Autonomous Agent* pattern, and your growth loop is mostly about picking which work deserves that pattern versus a tighter *Workflow*.

### The Ghost Boss · AMDE
**Positive label**: High-Trust Delegator / Ultimate Believer
**Slogan**: "Just get it done — don't ask me how."

**Superpowers**
- Near-zero decision overhead; you don't get stuck in local detail and you ship faster than peers who over-specify
- Extreme trust in the model's judgment, which unlocks its agency on autonomous tasks where a more hands-on operator would unconsciously cap it
- You're a natural fit for Agent mode and long-horizon delegation workflows

**Growth area**
- Context occasionally goes missing, so the AI has to loop back and ask what "it" was — a cheap lift with a one-line goal statement

**Prompt upgrade**
- Before: "Fix it."
- After: "Fix the login endpoint — the goal is the 401-without-redirect bug. Don't touch the session logic."

**Theory background**: Anthropic *Be Clear, Direct & Detailed* (Prompt Engineering Overview, rule #1) · **Karpathy *Software 3.0* (AI Engineer Summit 2024)** — prompts are *specifications*, not incantations, and the Ghost Boss lives and dies by how tight that spec is. **Anthropic *Claude Code Best Practices* (2024-2025)** — encode your standing preferences once in `CLAUDE.md` (stack, conventions, don't-touch zones) so every future "fix it" arrives pre-loaded with the goal.

---

### The 3AM Philosopher · AMDX
**Positive label**: Deep Thinker / Metacognition Pioneer
**Slogan**: "Interrogate the AI at 3AM."

**Superpowers**
- Willing to step out of the code layer and ask strategic, architectural, even existential questions
- Catches essential insights when everyone else has gone home — you treat the model as a late-night whiteboard partner
- Comfortable holding ambiguity long enough for real structure to emerge

**Growth area**
- Late-night decision quality has high variance; the same prompt at 3AM and 10AM can produce very different next-day regret

**Prompt upgrade**
- Before: "How should the architecture evolve?"
- After: "How should the architecture evolve — the current bottleneck is X, the constraint is Y, and I'm leaning toward Z. Push back if you disagree."

**Theory background**: Wei et al. 2022 *Chain-of-Thought Prompting* (arXiv 2201.11903) · **OpenAI o1 System Card (2024.09)** — reasoning as a first-class capability; test-time compute is the new scaling axis, which rewards your preference for open-ended, reason-first prompts. **Anthropic Extended Thinking (2025)** — let `<thinking>` carry the heavy lifting so your midnight-brain doesn't have to hold the entire search tree at once.

---

### The Vibe Client · AMLE
**Positive label**: High-Delegation Partner / Trust-Forward Operator
**Slogan**: "Whatever you think."

**Superpowers**
- Near-zero micromanagement; the AI gets full creative runway and often produces work above your minimum bar
- Steady temperament, outcome-driven — you care about the destination, not the route
- Great at disarming over-hedged output: your "just pick one" unblocks agents that would otherwise stall on options

**Growth area**
- You may miss moments where the AI actually has a stronger idea worth surfacing — inviting a single pushback flips this instantly

**Prompt upgrade**
- Before: "Whatever you think."
- After: "Whatever you think — but I'm leaning X. If you strongly disagree, flag it before you start."

**Theory background**: Karpathy *LLM as junior collaborator* (2022-2023 talks, upgraded in 2024-2025 to "junior engineer *with tools*") · **Anthropic *Building Effective Agents* (2024.12)** — the industry-standard pattern language (Augmented LLM / Workflow / Autonomous Agent) gives you a vocabulary for picking the right level of delegation instead of defaulting to "you decide." **MCP (2024.11)** — tool-scoped trust means your delegation is bounded by capability surface, not blind faith.

---

### The Vibe Poet · AMLX
**Positive label**: Creative Thinker / Strategic Questioner
**Slogan**: "Is there a more elegant way?"

**Superpowers**
- Willing to escape the current frame and produce original ideas instead of iterating on the obvious one
- Loves brainstorming product- and strategy-level questions with the AI, not just code
- Often surfaces the "third option" that neither engineer nor PM would have found alone

**Growth area**
- When the thought is still fuzzy, the AI can't find the real target — a one-line "what I actually care about" is the unlock

**Prompt upgrade**
- Before: "Is there a more elegant way?"
- After: "Is there a more elegant way? What's bothering me is X; the ideal outcome is Y."

**Theory background**: Yao et al. 2023 *Tree of Thoughts* (arXiv 2305.10601, NeurIPS 2023) · **Karpathy *Software 3.0* (2024)** — treat the prompt as a spec you co-author with the model, not a riddle you throw at it. **DeepSeek-R1 (2025.01)** — open-source reasoning models make "explore the option space first" a cheap default move, which is exactly the Vibe Poet's instinct operationalized.

---

## Preacher · The Doctrine School

Context-rich framing, paragraph-first thinking. You ship the *why* before the *what*. This school thrives under 1M-token context windows and prompt caching, but is most vulnerable to *Lost in the Middle* (Liu et al. 2023) unless you actively flag the decision. Read this school through Anthropic's *Effective Context Engineering for Agents* (2025): context is no longer something you provide — it's something you *curate, prioritize, and prune*. The Preacher's upgrade path is almost entirely about moving from "provide" to "curate," which means adding one priority line at the tail of every long setup instead of expanding the setup itself.

### The PRD Tyrant · AVDE
**Positive label**: Systems Designer / Full-Spectrum Requirements Author
**Slogan**: "Three pages of spec and a single verb."

**Superpowers**
- Requirements are decomposed end-to-end; context is saturated before a single line of code is written
- Strong cross-functional vision — you think about users, APIs, metrics, and edge cases in one pass
- Your specs survive handoff; another engineer (or another agent) can pick up exactly where you left off

**Growth area**
- Long spec + short imperative at the end can drop priorities from the model's working set — a P0/P1 split fixes it in one line

**Prompt upgrade**
- Before: "…(three-page spec)… do it."
- After: "…(three-page spec)… Please ship P0 (X, Y) first. P1 can wait until next week."

**Theory background**: OpenAI Strategy 1 *Write clear instructions* + Strategy 3 *Split complex tasks* · **Anthropic *Effective Context Engineering for Agents* (2025)** — long context is a resource to *manage*, not just *provide*; priorities at the tail are your single most valuable steering signal. **Anthropic Prompt Caching (2024.08)** — your reusable spec blocks are no longer expensive; cache them once, iterate cheaply.

---

### The Keynote Strategist · AVDX
**Positive label**: Roadshow Strategist / Top-Down Architect
**Slogan**: "Lay down the full context, then ask."

**Superpowers**
- Background is thorough; the model has everything it needs to decide well
- You reliably lift local problems into strategic framing instead of solving symptoms
- Teammates borrow your context dumps verbatim — you effectively write reusable briefing docs

**Growth area**
- Occasionally context-overloaded — the model loses track of which decision you actually want; naming the decision explicitly at the end is the fix

**Prompt upgrade**
- At the end of a long setup, add: "About 40% of the above is essential context and 60% is supporting. The real decision I need your help with is XX."

**Theory background**: OpenAI *Provide reference text* (Strategy 2) · **Liu et al. 2023 *Lost in the Middle* (arXiv 2307.03172)** — the pivotal finding that models systematically ignore mid-context information; the fix is active flagging of *what actually matters*, which is exactly the "40/60" upgrade template. **Anthropic Context Editing / Memory APIs (2025)** — treat context as something you curate and prune, not something you dump and hope.

---

### The Architecture Evangelist · AVLE
**Positive label**: Theory-to-Practice Translator / Methodology-Driven Engineer
**Slogan**: "Teach the concept, then ship together."

**Superpowers**
- Grounded in a theoretical frame (DDD, hexagonal, clean-arch, event-sourcing); code quality stays stable across the codebase
- Values sustainability and team alignment — you write the kind of code juniors can still read in a year
- You effectively onboard the AI into your team's vocabulary, which compounds on long sessions

**Growth area**
- Heavy jargon can cause the model to map theory onto the wrong files; a one-line jargon-to-path mapping fixes it

**Prompt upgrade**
- After a theory block, add: "In this codebase, 'bounded context' maps to the YY package under the XX directory."

**Theory background**: Karpathy *Collaborative exploration* · **Anthropic *Building Effective Agents* (2024.12)** — the shared vocabulary for agent patterns is the same move you already make for domain patterns; adopt it and your methodology travels further. **MCP (2024.11)** — an open standard that lets your methodology actually travel across tools, not just slide decks.

---

### The Micro-Essay PM · AVLX
**Positive label**: Multi-Option Product Thinker / Choice-Architect
**Slogan**: "Mini essay plus pick-one-of-three."

**Superpowers**
- You already arrive at the conversation with option sets compared — the AI doesn't waste turns enumerating
- You give the AI a clear decision frame, which sharpens the quality of its judgment
- Strong preference for explicit trade-offs over implicit ones, which is exactly how reasoning models prefer to think

**Growth area**
- Unbalanced option descriptions can nudge the model into your pre-pick; a single line of neutrality reclaims its independence

**Prompt upgrade**
- After listing A/B/C, add: "I'd genuinely accept all three — I want your independent read."

**Theory background**: OpenAI Strategy 3 *Split complex tasks* · Yao 2023 *Tree of Thoughts* · **Anthropic *Effective Context Engineering for Agents* (2025)** — present options as parallel peers in the context so the model can actually reason across them, not just confirm the first one framed with the most tokens. **Anthropic Prompt Caching (2024.08)** — cache your evaluation rubric once and reuse across every option set.

---

## Sniper · The Precision School

Short, pointed, coordinate-driven. You move fast and you move exactly. This school thrives in *Edit mode* and with `CLAUDE.md` doing the standing-context work, which lets every new prompt stay surgical. Read this school through Karpathy's *Software 3.0* (2024): the Sniper has been living in Software 3.0 longer than anyone — you've been treating prose as source code with real addresses in it since before it had a name. The growth loop here is mostly about *when to loosen the grip*: on creative or ambiguous work, swapping one imperative for one invitation ("what would you do here?") unlocks a layer of model output that pure coordinates leave on the table.

### The Imperative Machine Gun · CMDE
**Positive label**: Precision Operator / Coordinate Sniper
**Slogan**: "Lock the target, pull the trigger."

**Superpowers**
- Fastest feedback loop in the org; the AI responds in one shot because there's no ambiguity to resolve
- Coordinates are crisp (files, line numbers, types, symbols); misfires are rare and the AI lands the intended edit first try
- You instinctively operate in what Karpathy calls Software 3.0: prose as source code, with real addresses in it

**Growth area**
- On multi-turn creative work, pure commands can feel mechanical — one-line goals unlock the model's optimization suggestions

**Prompt upgrade**
- On complex tasks, upgrade "change line 42 to X" into "change line 42 to X — the goal is Y. Show me the diff before you commit."

**Theory background**: Anthropic *Be Clear, Direct & Detailed* · **Karpathy *Software 3.0* (2024)** — concrete coordinates *are* the specification; you're already living in Software 3.0 without needing the label. **Anthropic *Claude Code Best Practices* (2024-2025)** — promote your best coordinates into `CLAUDE.md` so you don't retype them every session, and your signature stays surgical.

---

### The Bug Detective · CMDX
**Positive label**: Root-Cause Investigator / Evidence-Driven Engineer
**Slogan**: "Bring the evidence, then ask the question."

**Superpowers**
- Pushes on root cause with real evidence in hand — logs, stack traces, repro steps
- Refuses to settle for surface-level fixes; your bugs stay dead after they die
- You're a natural match for reasoning models: you already hand them the artifacts CoT loves

**Growth area**
- Sometimes chases the root even when a short-term fix would do; a one-line triage ("do I need root, or green build?") saves hours

**Prompt upgrade**
- Ask yourself first: "Do I want the root cause, or do I want it working today?" — then set the depth of the prompt accordingly.

**Theory background**: Wei 2022 *Chain-of-Thought* · **OpenAI o1 System Card (2024.09)** — reasoning models reward evidence-forward framing; "here's what I observed, here's what I tried" gives o1-style thinking the traction it needs. **Anthropic Extended Thinking (2025)** — let the model reason explicitly before proposing a fix, and audit the `<thinking>` trace the way you'd review a PR.

---

### The Pair-Programming Buddy · CMLE
**Positive label**: Peer Collaborator / Streaming Co-creator
**Slogan**: "Talk while we type."

**Superpowers**
- Makes the AI feel like a real teammate — short turns, shared context, shared credit
- Short feedback loops, small increments, low blast radius; bugs get caught before they compound
- You effectively run the *Augmented LLM* pattern in real time

**Growth area**
- On long tasks, you can lack a global plan; a 30-second "here's the step count" upgrade makes the session finish on time

**Prompt upgrade**
- Open with: "I think this task has about X steps — let's align on the plan before we start."

**Theory background**: Yao et al. 2022 *ReAct* (arXiv 2210.03629) — the formalization of reason-and-act loops you already run intuitively · **Anthropic *Building Effective Agents* (2024.12)** — pair-programming is the *Augmented LLM* + *Workflow* hybrid; naming the pattern sharpens it. **MCP (2024.11)** — a shared tool surface turns your "talk while we type" into something reproducible across sessions and teammates.

---

### The SOS Signaler · CMLX
**Positive label**: Honest Escalator / Fast-Feedback Contributor
**Slogan**: "Ask right where you're stuck."

**Superpowers**
- Doesn't hoard problems; asks for help fast and keeps the team unblocked
- Every ask comes with the actual stack trace and log output, not a paraphrase
- Your honest-escalation instinct is rare and worth more than perfect debugging skills

**Growth area**
- Very short prompts can make the AI treat an urgent issue as a one-off bug; adding the failed attempts reclassifies it correctly

**Prompt upgrade**
- "Stack trace + I already tried X and Y, neither worked" gets roughly 3× the signal of just "what do I do with this traceback."

**Theory background**: Anthropic *Be Clear, Direct & Detailed* · **DeepSeek-R1 (2025.01)** — open-source reasoning models reward problem statements that already include the failed attempts; you're halfway to a good CoT trace the moment you list them. **Anthropic Extended Thinking (2025)** — the more honest your dead-end inventory, the better the thinking trace the model can produce on top.

---

## Craftsman · The Builder School

Concrete, verbose, shipping-oriented. You write the spec *and* drive the build. This school gets the best return on 1M-context windows, prompt caching, and Plan Mode — your density of artifacts makes the AI's reasoning surface very large. Read this school through the o1 / DeepSeek-R1 / Extended Thinking era: reasoning models reward exactly the depth-of-context you naturally provide, and extended thinking gives them the runway to actually use it. The Craftsman's growth loop is about *budgeting* that depth — 60-point answers in 30 minutes versus 90-point answers in 3 days is a real dial, and knowing which to turn is what separates shipping Craftsmen from perfectionist ones.

### The Full-Spec Client · CVDE
**Positive label**: Full-Spec Commissioner / Delivery-Oriented Lead
**Slogan**: "Complete spec + 'done when you ship.'"

**Superpowers**
- Highest information density in the league; the AI lands the task in one pass
- Strong sense of delivery and accountability — you ship before you polish
- Your specs double as onboarding docs; new teammates (human or agent) can pick up the thread instantly

**Growth area**
- Command-style cadence can suppress the AI's own optimization suggestions; one "stop me if you see better" line reopens that channel

**Prompt upgrade**
- End a large ask with: "If you spot a better approach, stop me before you start."

**Theory background**: OpenAI Strategy 1 · Anthropic *Multishot Prompting* · **Karpathy *Software 3.0* (2024)** — your full specs are the prototype of prose-as-source-code at its most rigorous. **Anthropic *Claude Code Best Practices* (2024-2025)** — `CLAUDE.md` is where your implicit standards become reusable artifacts instead of tribal knowledge.

---

### The Technical Scout · CVDX
**Positive label**: Deep Investigator / Optimal-Solution Hunter
**Slogan**: "Lay out the battlefield, then ask for the best move."

**Superpowers**
- Complete situational awareness before the first prompt; decision quality is consistently high
- Willing to invest thought for an optimal solution rather than the first-found one
- You treat the AI as a genuine research collaborator, not a code autocomplete

**Growth area**
- Perfectionism can delay "good-enough" from shipping; budgeting the model's thinking the same way you budget your own is the unlock

**Prompt upgrade**
- When asking for the best solution, add: "If a 60-point answer takes 30 minutes and a 90-point answer takes 3 days, give me the 60-point one first."

**Theory background**: OpenAI Strategy 2 · Yao 2023 *Tree of Thoughts* · **OpenAI o1 System Card (2024.09)** — reasoning models reward explicit trade-off framing; budget their thinking time the same way you budget yours. **DeepSeek-R1 (2025.01)** — open reasoning models now make "explore many paths, pick one" affordable at your scale of investigation.

---

### The Technical Mentor · CVLE
**Positive label**: Coaching Engineer / Incremental Driver
**Slogan**: "One step at a time, with you."

**Superpowers**
- Steady cadence; juniors (human and AI) on the team grow fast under your walk-throughs
- Each step is independently verifiable; regressions get caught where they happen
- You naturally produce workflows that later teammates can reuse without translation

**Growth area**
- In familiar territory, "step by step" can slow you down; a single "ship the final version, I'll review" unlocks the skip-ahead

**Prompt upgrade**
- For simple tasks, skip the walkthrough: "Write the final version directly — I'll review."

**Theory background**: Karpathy *LLM as junior collaborator* · Anthropic *Let Claude Think* · **Anthropic *Building Effective Agents* (2024.12)** — the *Workflow* pattern is step-by-step done right; you're already running it, the doc just names your moves. **MCP (2024.11)** — your step-by-step reviews become much cheaper when each step has a verified tool surface behind it.

---

### The Socratic Engineer · CVLX
**Positive label**: Deep Questioner / First-Principles Learner
**Slogan**: "Why not X? What about Y?"

**Superpowers**
- Every conversation deepens your domain mastery — you leave sessions smarter, not just shipped
- You refuse to settle for "it works"; you insist on knowing *why* it works
- You're a natural match for reasoning models that finally reward first-principles engagement

**Growth area**
- Long dialogues can push the model into defensive answers (trying to avoid the next drill-down); stating intent up front keeps it in exploration mode

**Prompt upgrade**
- Declare intent up front: "I want to go deep on the principle — I don't need a hedged compromise."

**Theory background**: Wei 2022 *Chain-of-Thought* · Yao 2023 *Tree of Thoughts* · **OpenAI o1 System Card (2024.09)** — reasoning models finally reward your first-principles style instead of short-circuiting to a glib answer. **Anthropic Extended Thinking (2025)** — explicit `<thinking>` blocks give your Socratic follow-ups real material to engage with, turning the dialogue into a shared reasoning trace.

---

## Report Generation Hard Constraints (the skill must follow)

These constraints apply to every AIBTI report the skill produces. They are non-negotiable because the whole point of AIBTI is to be *a respectful mirror*, not a grading sheet.

1. **Ratio 2:1** — every persona diagnosis lists ≥ 2 superpowers and ≤ 1 growth area. The reader should feel seen, not diagnosed.
2. **Positive voice** — say "your superpower is X," never "your problem is X." The signature framing must read as an identity description, not a defect report.
3. **Affirm before advising** — before any prompt upgrade, explicitly name what the reader already does well, then position the upgrade as an *option* rather than a correction.
4. **Banned words**: fail / error / insufficient / lacking / bad / flaw. Replace with neutral descriptors (misfire, trade-off, room, signature, dial).
5. **Preferred words**: superpower / style / preference / room / upgrade / evolve / signature / trade-off.
6. **Theory over verdict** — every growth area must be grounded in a concrete 2024-2026 theory reference, so the advice reads as *"here's what the frontier research would say about this style,"* not *"here's what you did wrong."*
