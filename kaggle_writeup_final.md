# Sparky — Excel for the Trades

**An AI tutor for trade-school and apprenticeship classrooms — built on David Kolb's Experiential Learning Cycle, running 100% locally on Gemma 4.**

*Tasha Penwell · Ohio University*
*Kaggle Gemma 4 Good Hackathon · May 2026*
*Repo: github.com/TMPenwell/kaggle-Sparky-Excel-for-Electricians*

---

## The hook

My son is an electrician. He's smart. He's good at his job. He can wire a panel without a manual but he needs help with Excel. He completed the Excel course provided by the apprenticeship program and I helped him with it. What I saw was generic activities that I taught in my college-level classroom full of business majors. Tradesmen and business majors are not the same — but they are expected to learn this vital skillset the same way.

When he asks me for help, I build short tutorials around scenarios and techniques relevant to him, not generic exercises with no direct application. I started thinking about how many others could use this kind of resource.

---

## The problem

Electrical apprenticeship programs don't teach Excel. I checked five of the largest curricula — Penn Foster, IEC Chesapeake, IECI National, Mike Holt, Alberta AIT — and not one of them lists spreadsheets, estimating software, or business software as a required competency. The 756-hour Penn Foster apprenticeship covers AC/DC theory, the National Electrical Code, conduit, motors, and safety. None of it covers what an apprentice will need every day once they're running their own jobs.

Meanwhile, look at what working electricians actually do for a living. They bid jobs. Bidding means a spreadsheet of materials, labor hours, markups, sales tax, and a grand total. Get the math wrong and the margin disappears. Get the formula wrong and the job goes to someone else.

There's an entire cottage industry of companies — Jobber, Simpro, Moon Invoice, ServiceTitan, ArcSite, BuildOps, InvoiceFly — that exist specifically to sell Excel-based estimating templates to electricians. That market only exists because the formal training never meets the working need. Every one of those companies markets around the same universal objection: "easy learning curve." The learning curve is the actual problem. An apprentice shouldn't have to teach themselves Excel between jobs, in spare hours, alone.

The right place to close that gap is in the classroom — in the apprenticeship programs and trade-school courses already responsible for preparing journeymen. They have the audience. They have the structured time. What they don't have is a tool designed for the way working tradespeople actually learn: by doing, with someone patient beside them.

That's the gap Sparky fills.

---

## What Sparky is

Sparky is a single-file web app designed for trade-school and apprenticeship classrooms. The instructor sets up Ollama and Gemma 4 once on the lab computers (or students install on their own laptops as a first-class activity). After that, every session of Sparky runs entirely on the local machine.

The interface is deliberately simple. On the left, a realistic electrical bid sheet — apprentices can pick between three jobs: a 200A residential service upgrade, an EV charger install, or a commercial lighting retrofit. Most of the bid is filled in. The yellow cells with question marks are the blanks the apprentice has to compute: materials subtotal, labor line totals, markup, sales tax, grand total. A download button exports the bid sheet as a real .xlsx file, so apprentices work in actual Excel while Sparky coaches them through it.

On the right, Sparky. A chat where the apprentice can ask anything they're stuck on. *"How do I total the labor hours?"* *"What goes in D14?"* *"How do I add a 25% markup?"*

But here's the thing Sparky doesn't do: it doesn't immediately answer. From an educator's perspective, this is the vital part of the pedagogy.

---

## The pedagogy

This is what separates Sparky from every other AI tutor. Ask ChatGPT how to add a column in Excel and it tells you. Information transferred, learning negligible.

Sparky implements David Kolb's four-stage experiential learning cycle as the operating logic of every response.

1. **Concrete Experience.** The apprentice is doing the real thing. The bid sheet is on screen, the blanks are visible, the .xlsx is downloadable.
2. **Reflective Observation.** When the apprentice asks Sparky a question, Sparky's first move is *not* to give the answer. It asks: *"If you didn't have Excel and you were just looking at those labor hours on paper, how would you figure out the total? Walk me through your steps."* The apprentice has to articulate.
3. **Abstract Conceptualization.** Once the apprentice has described their reasoning in their own words, Sparky introduces the Excel function as the *formal expression* of what they just described. *"What you're describing — adding up a list of numbers — is exactly what the SUM function does."*
4. **Active Experimentation.** Sparky tells them which specific cell to type the formula into and asks what number pops out. The apprentice tries it on their own bid.

Every Sparky response is tagged with the Kolb stage it's executing — `[REFLECT]`, `[CONCEPT]`, `[APPLY]`, `[CHALLENGE]` — rendered as a small green pill in the UI. Judges, instructors, and learners can *see* the pedagogy happening. That's an accountability commitment, not just a claim. An instructor walking around the classroom can tell at a glance whether their apprentices are getting answers handed to them or actually working through the reasoning.

Sparky also addresses the core components of experiential learning: **Engagement** (sustained involvement in working a real bid), **Mentorship** (every interaction is meaningful feedback grounded in the apprentice's actual reasoning), **Challenge** (the skill-level selector and `[CHALLENGE]` tag extend learning beyond the comfort zone), **Ownership** (the apprentice picks the blank, articulates the problem, decides when to move on), and **Self-Awareness** (the visible stage tags build metacognition; planned Phase 5 work adds explicit reflection).

The skill-level selector — Apprentice / Journeyman / Master/Owner — adapts depth and tone. Apprentice mode walks one step at a time. Master mode skips the basics.

---

## Why local matters in a classroom

Sparky runs on Gemma 4 E4B (about 9.6 GB) through Ollama, entirely on the user's own machine. No cloud. No API key. No data leaves the laptop. After one-time setup, everything works offline.

For trade-school and apprenticeship classrooms, this matters concretely.

**Trade schools can't budget for API tutoring.** Pay-per-token costs are unpredictable; classroom IT budgets are not. A one-time local install owned in perpetuity is the only viable model for educational deployment at scale. Sparky can be deployed across a 30-seat lab without a recurring bill.

**Student bid data should stay local.** Apprentices working through realistic scenarios will inevitably input information that resembles their employer's pricing, labor rates, or job structure. That shouldn't go to a third-party API to be logged, retained, or potentially used in training. With Sparky, it doesn't.

**Classrooms with bad WiFi.** Not all of them — but enough of them, in enough places, that cloud-dependent tools fail at the worst moments. A tool that runs offline doesn't fail in the middle of a lesson.

**Local-first is also a teaching moment.** Apprentices who see a working AI tutor running on a lab computer with no cloud connection learn something important about how AI actually works — and what's possible when you don't have to send your data somewhere else.

The technical execution is deliberately simple. One HTML file. Gemma 4 served by Ollama on localhost:11434. SheetJS bundled inline so the .xlsx download works fully offline. No framework, no build tooling, no backend. Any IT person who can install Ollama on a lab computer can deploy Sparky in five minutes.

---

## Why this is more than a chatbot

You could write a system prompt for ChatGPT that approximates Sparky. You'd lose four things.

**The pedagogical architecture is enforced, not requested.** Sparky's system prompt isn't a polite suggestion — it's the core of the system. The stage tags are extracted by the frontend and rendered visibly, which means a response without one looks broken. The model can't quietly skip the REFLECT stage. An instructor can audit pedagogy by glancing at the screen.

**The scenario library is the curriculum.** Each bid sheet is hand-crafted with realistic 2026 pricing, plausible labor hours, and intentionally placed blanks that exercise specific Excel skills. The scenarios are the experiential ground; the chat is the scaffolding around it. Sparky doesn't just answer questions — it operates inside a designed learning environment.

**The voice is purpose-built for the audience.** Tradespeople have justified suspicion of educational tools that talk down to them. Sparky's prompt explicitly forbids "Great question!", excessive enthusiasm, emoji-heavy responses, and corporate help-bot tone. It uses trade language naturally. It respects the apprentice as an intelligent adult who happens not to know this particular thing yet. That voice is the difference between a tool an apprentice will actually open in week two of class and one they close after thirty seconds in week one.

**Local-first is a feature of the tool, not the deployment.** Privacy, offline capability, and zero ongoing cost aren't marketing — they're consequences of the architecture choice. They unlock use cases (apprenticeship programs without API budgets, trade schools with restricted networks, JATC centers in rural areas) that no API-based competitor can reach.

---

## An honest note about arithmetic

Large language models — including Gemma 4 — are unreliable at multi-number arithmetic. They predict plausible-looking numbers; they don't actually compute them. Ask any LLM to sum nine line items with decimals and it will often produce a confident answer that's wrong by a few dollars.

Sparky's system prompt addresses this directly: Sparky is forbidden from computing totals, products, or percentages itself. Instead, it tells the apprentice exactly which formula to type, which cell to type it in, and asks the apprentice to report what Excel returns. Excel always wins.

This isn't a workaround — it's the pedagogy. Kolb's Active Experimentation stage requires the *learner* to perform the operation and observe the result. If Sparky did the arithmetic and handed it back, it would skip the stage entirely. By deferring every calculation to Excel and the apprentice, Sparky enforces the experiential cycle and avoids the LLM's worst failure mode at the same time.

An apprentice who notices Sparky's earlier guess doesn't match Excel's number is doing exactly what we want apprentices to do: trust their own work, trust the tool that does the math, and develop healthy skepticism of confident-sounding AI.

---

## The bigger picture

Sparky belongs to a larger commitment.

I teach Business Analytics and Information Systems at Ohio University, in southern Appalachia. Most of my students are first-generation college students whose families work in skilled trades, agriculture, healthcare, and the local service economy. I volunteer at Ohio University Tech Savvy, where I run CS50-style puzzle days for 6th-8th grade girls who'd otherwise never see themselves in STEM. I'm building Rent A Bay, a community garage in southern Ohio where kids will learn hands-on skills their families can't teach. I'm pursuing my PhD in Instructional Technology and completing the experiential learning program through Ohio University because I want my own teaching practice to be more experiential, not more lecture-driven.

All of it points the same direction. **Experiential, offline-first AI for the audiences ed-tech overlooks.** Apprentices. First-generation college students. Rural kids. People who learn best by doing, with someone patient beside them. People whose internet is slow and whose privacy matters and whose teachers are stretched thin.

The classroom is where this work scales. One apprenticeship program adopting Sparky reaches dozens of apprentices a year. A regional trade school reaches hundreds. The technical pieces are interesting; the classroom deployment is the actual impact.

I have connections in trade education that will let me pilot Sparky in real apprenticeship programs after this hackathon. The product is built to be adopted, not just admired.

---

## What's next

**Phase 2 — Instructor tools.** A view for instructors to see which scenarios their cohort is working on, which Kolb stages are dominant, and where individual apprentices are getting stuck. Same local-first architecture; the data never leaves the lab.

**Phase 3 — Dynamic scenario generation.** The current scenarios are hand-crafted. The architecture is built so they don't have to be. A planned upgrade has Gemma 4 generate fresh bid sheets on demand, so apprentices can't memorize answers and instructors can introduce variety across class sessions.

**Phase 4 — Other trades.** The Sparky pattern (realistic scenario + Kolb-cycle prompts + skill-level adaptation) is trade-agnostic. Plumbers learning takeoff. HVAC contractors learning load calculation. General contractors learning multi-trade scheduling. Each trade has its own vocabulary; the underlying tutoring engine is the same.

**Phase 5 — Assessment and reflection.** Experiential learning needs assessment to be effective. A future version will end each scenario with a structured reflection: *"What did you figure out? What was hardest? How would you teach it to another apprentice?"* The reflections become a portfolio of growth for the apprentice — and, for instructors, a window into their cohort's thinking.

---

## Acknowledgments

My son, who calls me when Excel breaks him. Anthropic's Claude, who served as engineering pair-programmer through the build. Google DeepMind for releasing Gemma 4 with weights that fit on a teacher's laptop.

The story Sparky tells isn't really about Excel. It's about who gets a patient tutor and who doesn't.
