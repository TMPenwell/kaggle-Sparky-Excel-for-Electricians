# Pedagogy

This document explains the educational theory that makes Sparky different from a generic AI chatbot. If you only care about the code, skip it. If you care about whether Sparky actually teaches anything — or you're a judge evaluating whether the educational claims hold up — this is where to look.

## The problem with most AI tutors

Ask ChatGPT or Gemini "how do I add up a column in Excel?" and you get something like this:

> _"Use the SUM function. The syntax is `=SUM(A1:A10)` where A1:A10 is the range you want to add up. For example, if your numbers are in column B from row 2 to row 15, you'd type `=SUM(B2:B15)` in any empty cell..."_

This is _correct_. It is not _teaching_.

The learner has been handed a fully-formed answer to a question they didn't fully form themselves. They didn't articulate what they were trying to do. They didn't connect the formula to their own reasoning. They didn't try it on their own data. They received information; they did not learn anything.

Three weeks later, when they need to add up a different column for a slightly different reason, they will go back to the chatbot and ask the same question again. They didn't learn SUM. They learned how to ask a chatbot.

This is shallow learning, and it doesn't transfer.

## David Kolb's Experiential Learning Cycle

David Kolb's [Experiential Learning Theory](https://learningfromexperience.com/) (developed in the 1970s and refined since) argues that real learning happens through a four-stage cycle:

1. **Concrete Experience (CE)** — the learner is _doing_ the thing. Not reading about it, not watching it, not imagining it. Doing it.
2. **Reflective Observation (RO)** — the learner steps back and thinks about what happened. What worked? What didn't? What was confusing?
3. **Abstract Conceptualization (AC)** — the learner connects the experience to a general principle, theory, or framework. The lived experience becomes a known concept.
4. **Active Experimentation (AE)** — the learner applies the new understanding to a new situation. They try the concept on slightly different ground and consolidate it.

Then the cycle repeats.

Kolb's framework has been widely adopted in adult education, professional training, medical education, leadership development, and trade education. It's the theoretical backbone of most modern apprenticeship models.

It is also the theoretical basis of every well-designed coding bootcamp, surgery residency, and flight school. It works.

## How Sparky implements the cycle

Each stage of Kolb's cycle is implemented as part of Sparky's prompt architecture:

| Kolb stage | What Sparky does | Stage tag |
|---|---|---|
| **Concrete Experience** | The learner sees a real bid sheet on screen. The yellow blank cells are real things to fill in. The downloadable .xlsx lets them work in actual Excel. | (always present) |
| **Reflective Observation** | When the learner asks a question, Sparky's first move is _not_ to give the answer. It's to ask: "What are you trying to figure out? How would you do it on paper?" The learner has to articulate. | `[REFLECT]` |
| **Abstract Conceptualization** | Once the learner has articulated their reasoning, Sparky introduces the Excel function as the formal expression of what they just described: "What you're describing — adding up only the items that match a condition — is exactly what SUMIF does." | `[CONCEPT]` |
| **Active Experimentation** | Sparky tells the learner exactly which cell to type the formula into and asks them to report what number pops out. The learner _tries it_ on their actual bid. | `[APPLY]` |
| **Cycle repeats** | Sparky pushes the learner slightly further: "Now try it for just the EV-related items. What changes about the formula?" | `[CHALLENGE]` |

Each Sparky response visibly displays its stage tag as a small green pill next to its name. This is intentional — the learner can _see_ the pedagogical structure happening to them, which itself builds metacognitive awareness of how they learn.

## What this looks like in practice

A learner asks: _"how do I total the labor hours?"_

**A typical AI tutor:**
> "Use the SUM function. Type `=SUM(B14:B19)` in any empty cell to add up your labor hours."

**Sparky:**
> `[REFLECT]` _Before we hit a function — if you didn't have Excel and you were just looking at those labor hours on paper, how would you figure out the total? Walk me through your steps._

The learner replies: _"I'd just add them up — 7 plus 5 plus 3 plus 3 plus 2."_

**Sparky:**
> `[CONCEPT]` _Right — you're describing addition, just sped up. What you're doing manually is exactly what the SUM function does in Excel. It points at a column of numbers and adds them up for you._
>
> `[APPLY]` _Type `=SUM(B14:B19)` into cell B20 (right under your last labor hour). Hit Enter and tell me what number pops out._

The learner has now: described the problem in their own terms, connected their reasoning to a formal concept, and tried it on their own data. That's three of Kolb's four stages in one exchange. The fourth (CHALLENGE) comes when they then ask "okay how do I total the cost?" and Sparky pushes them to extend.

This is real learning. They will remember SUM next month, because they didn't just receive it — they _arrived_ at it.

## Ohio University's Five Components of Experiential Learning

Beyond Kolb's cycle, Ohio University's [University Curriculum Council](https://www.ohio.edu/curriculum/bricks-bridges) defines five components that any rigorous EL implementation must include. Sparky implements all five:

| OU Component | How Sparky implements it |
|---|---|
| **Engagement** — sustained, intensive student involvement | Working through a real bid sheet takes 15-30 minutes of focused work, not a 30-second quick lookup |
| **Mentorship** — regular, meaningful feedback | Sparky responds to every step with feedback grounded in the learner's actual reasoning |
| **Challenge** — pushes the learner beyond familiar territory | The skill-level selector adapts difficulty; the `[CHALLENGE]` tag explicitly extends learning |
| **Ownership** — independent judgment in defining and executing | The learner picks which blank to tackle next, articulates their own reasoning, and decides when to move on |
| **Self/Social Awareness** — reflection on learning | The visible Kolb stage tags build metacognition; Phase 4 will add explicit reflection prompts at the end of each scenario |

These are not retrofitted claims. They are the design constraints I worked from while building Sparky, drawn directly from my coursework at Ohio University.

## The skill-level adapter

Kolb's cycle assumes a learner who's at a particular point in their development. An apprentice and a master need different things. Sparky adapts:

- **Apprentice:** Plain language. One step at a time. Never assume a function exists — introduce it before using it. Walk through every concept with patience.
- **Journeyman:** Knows Excel basics. Skip those. Reach for the right function and explain when needed.
- **Master / Owner:** Assume Excel comfort. Be efficient. Skip foundational explanations.

This is consistent with the ZPD (Zone of Proximal Development) concept from Lev Vygotsky — the principle that effective scaffolding meets the learner just above their current capability and pulls them up.

## Voice as pedagogy

A surprising amount of what makes Sparky work is its _voice_. The system prompt explicitly forbids:

- "Great question!" — patronizing, fake
- Excessive enthusiasm — feels condescending to working adults
- Childish language or emoji-heavy responses
- Talking down to the learner

And explicitly requires:

- Trade-friendly language ("the bid," "the run," "labor units")
- Direct, tight responses (3-5 sentences usually)
- Permission for trade-adjacent informality ("yeah, that one trips everyone up")
- Treating the learner as a smart adult who happens to not know this particular thing yet

This matters because **electricians and other tradespeople often have justified suspicion of educational tools that talk down to them.** Trade work requires intelligence; tradespeople know it; and any tool that treats them like elementary schoolers will be rejected before it has a chance to teach anything.

## Why this is hard for general-purpose AI

You _can_ make ChatGPT or Claude implement Kolb's cycle by writing a careful system prompt. But:

1. **Most users don't write careful system prompts.** They just ask the question. The default behavior of every general-purpose AI is to give the answer immediately.
2. **The user has no way to verify the AI is actually following a pedagogical structure** vs. just adding fluff.
3. **The visible stage tags** — the small green pills next to Sparky's name — are a UI commitment to the framework. They make the pedagogy visible, which makes it accountable.

Sparky is purpose-built for this one use case, with the framework baked in at every level: the prompt, the UI, the scenario design, the voice. That's the difference between "AI chatbot" and "pedagogically-grounded learning tool."

## What's next pedagogically

**Phase 4 (post-hackathon roadmap):** Add explicit reflection prompts at the end of each scenario. Module 5 of the BRICKS Bridges EL coursework emphasizes that experiential learning needs assessment to be effective. Sparky should ask:

- _"What did you figure out today that you didn't know before?"_
- _"What was the hardest part?"_
- _"If you had to teach this to another apprentice, how would you explain it?"_

These reflections become the learner's own portfolio of growth — and, in a classroom setting, a window for the instructor into how the learner is thinking.

This closes the Kolb cycle properly: not just "did you do the thing," but "do you know what you know now?"

---

## References

- Kolb, D. A. (1984). _Experiential Learning: Experience as the Source of Learning and Development._ Prentice Hall.
- Vygotsky, L. S. (1978). _Mind in Society: The Development of Higher Psychological Processes._ Harvard University Press.
- Ohio University BRICKS Bridges Learning and Doing program: [ohio.edu/curriculum/bricks-bridges](https://www.ohio.edu/curriculum/bricks-bridges)
- Kolb's Learning Styles Inventory: [learningfromexperience.com](https://learningfromexperience.com/)
