# Sparky

**An AI tutor that helps electricians learn Excel by working real bids.**
Built on David Kolb's Experiential Learning Cycle. Runs 100% locally on Gemma 4 via Ollama. No cloud. No data leaves your laptop.

> _Submission for the [Kaggle × Google Gemma 4 Good Hackathon](https://www.kaggle.com/competitions/google-gemma-3n-hackathon), May 2026._

![Sparky main screen](screenshots/sparky_main.png)

---

## The story

My son is an electrician.

He's smart. He's good at his job. He can pull a service entrance, terminate a panel, and pass an inspection on his own. But Excel breaks him. Every few weeks, my phone rings — _"Mom, can you help me figure out a formula?"_

I happen to be an Excel professor at Ohio University. So I help.

Most electricians don't have an Excel professor for a mom. I built Sparky for them.

---

## The problem

Electricians have to bid jobs in Excel. Materials lists, labor units, markups, sales tax, grand totals — all of it lives in spreadsheets. <cite>"One missed line item, one rushed calculation, and a profitable job can quietly turn into a costly lesson."</cite>

But here's what nobody talks about: **electrical apprenticeship programs don't teach Excel.**

I checked. Penn Foster's 756-hour curriculum covers AC/DC principles, conduit bending, motor controls, and the National Electrical Code — but no spreadsheets. The IBEW/NECA Electrical Training Alliance, the IEC programs, Grand Rapids CC — same story. Some require "fundamental computer skills" as a _prerequisite_, but Excel is never _taught_.

So apprentices graduate as journeymen who can wire a building but can't price one. They figure it out on the job, painfully, often by losing money on under-bid work. From an electrician forum, one journeyman to another about an estimating spreadsheet:

> _"You'd never get past the learning curve. Seriously. I'm not saying it's because you're not smart enough, but it would simply take too long."_

That's an electrician telling another electrician that Excel is too hard for him to learn.

It doesn't have to be.

---

## What Sparky does differently

Sparky isn't a chatbot that answers Excel questions. ChatGPT already does that, badly. Sparky is a **structured implementation of David Kolb's Experiential Learning Cycle** — the same framework I'm being formally certified in through Ohio University's [BRICKS Bridges Learning and Doing](https://www.ohio.edu/curriculum/bricks-bridges) program.

Kolb's cycle says learning happens through four stages, in order:

1. **Concrete Experience** — the learner is doing the actual thing
2. **Reflective Observation** — they articulate what they're trying to do, in their own words
3. **Abstract Conceptualization** — they connect their reasoning to a formal concept
4. **Active Experimentation** — they apply the concept and consolidate

Most AI tutors skip stages 1 and 2 entirely. You ask "how do I add up a column?" and ChatGPT says "use SUM." You learned a function but not why or when. The learning is shallow and doesn't transfer.

Sparky won't give you the formula until you've articulated what you're trying to figure out. Then it introduces the function as the _abstraction of your own reasoning_, then has you try it in a specific cell on a real bid sheet, then pushes you slightly further.

Every Sparky response is tagged with the Kolb stage it's executing — visible to the learner as a small green pill so they can see the pedagogy in action.

![Kolb stage tags in action](screenshots/sparky_kolb_in_action.png)

---

## What you see when you open it

- **A real bid sheet** for a 200A residential service upgrade with EV charger and hot tub circuits — the kind of job an electrician actually bids
- **Most of it filled in** — line items, prices, line totals
- **Yellow blank cells** marked with `?` — these are what the apprentice is learning to fill in (subtotals, labor cost calculations, markup, sales tax, grand total)
- **A real downloadable .xlsx file** so they can work in actual Excel
- **A skill-level selector** — Apprentice / Journeyman / Master/Owner — that adapts Sparky's tone and depth
- **Sparky on the right**, ready to coach them through any blank they pick

Sparky knows what's on the bid sheet. It can refer to specific cells (`D14`, `B7`) and the apprentice can find them. The on-screen sheet and the downloaded file are the same data — the on-screen version is for shared reference, the downloaded version is for actually working.

---

## Why local matters

Sparky runs on Gemma 4 E4B via Ollama, on the user's own machine. No cloud. No API keys. No usage caps. No data leaves the laptop.

This matters for skilled trades because:

- **Bid data is competitive.** Contractors don't want their pricing strategies, labor rates, or material markups sitting in someone else's training data.
- **Job sites have bad WiFi.** Many residential and rural job trailers can't depend on a cloud connection.
- **Trade schools have tight budgets.** Pay-per-token API tutoring isn't viable; a one-time install is.

The full app is a single HTML file. Drop it on a contractor's laptop, point it at the local Ollama install, and it works forever, offline.

---

## Quick start

**Prerequisites:** A Mac, Windows, or Linux machine with at least 16GB of RAM. (Gemma 4 E4B is about 9.6GB.)

**1. Install Ollama.** Download from [ollama.com/download](https://ollama.com/download) and install.

**2. Pull Gemma 4.**
```bash
ollama pull gemma4:e4b
```

**3. Allow browser access to Ollama.** This is a one-time setup so the HTML page can talk to your local model.

On Mac:
```bash
launchctl setenv OLLAMA_ORIGINS "*"
```

On Linux (add to `~/.bashrc` or `~/.zshrc`):
```bash
export OLLAMA_ORIGINS="*"
```

On Windows: set `OLLAMA_ORIGINS=*` in System Environment Variables.

**4. Restart Ollama** so it picks up the new env var.

**5. Open the app.** Double-click `index.html` in this repo. That's it.

If you hit issues, see [docs/SETUP.md](docs/SETUP.md) for detailed troubleshooting.

---

## How it's built

| Layer | Choice | Why |
|---|---|---|
| Model | **Gemma 4 E4B** | Fits comfortably on a laptop, fast enough for real-time tutoring, free |
| Runtime | **Ollama** | One-line install, handles model lifecycle, exposes a simple HTTP API |
| Frontend | **Single HTML file** | No build step, no install, works on any machine with a browser |
| Spreadsheet export | **SheetJS (xlsx.js)** | Generates real .xlsx files entirely in the browser |
| Pedagogy | **Kolb's Experiential Learning Cycle** | Backed by formal coursework at Ohio University, implemented as a structured prompt architecture |

The whole thing is roughly 850 lines of HTML, CSS, and JavaScript in one file. No framework. No build tooling. No backend. Anyone with VS Code and a working brain can read it, modify it, and ship a variant for their own trade.

---

## What's next

**Phase 2: Dynamic scenario generation.** Sparky currently uses one hand-built bid sheet (a 200A residential service upgrade). The next version will use Gemma 4 to generate fresh, realistic bid sheets on demand — different jobs every time, so apprentices can't memorize answers and the same learner can keep practicing.

**Phase 3: More trades.** The architecture is trade-agnostic. The same pattern (realistic scenario + Kolb-cycle prompts + skill-level adaptation) works for plumbers learning Excel, HVAC contractors learning estimating, general contractors learning project tracking — anyone whose formal training didn't include the spreadsheet skills their business depends on.

**Phase 4: Reflection and assessment.** Module 5 of Ohio University's Experiential Learning curriculum emphasizes that EL needs assessment to be effective. A future version will ask the learner to reflect on what they figured out at the end of each scenario, and save those reflections for the learner (and, optionally, for an instructor in a classroom setting).

---

## Built by

**Tasha Penwell** ([@TMPenwell](https://github.com/TMPenwell)) — Assistant Professor of Instruction at Ohio University's College of Business, AWS Authorized Instructor, founder of [Rent A Bay](https://rentmybay.com/), volunteer at [Ohio University Tech Savvy](https://www.ohio.edu/kids/programs/tech-savvy) (a STEM program for middle school girls), and mom to an electrician.

I teach Business Analytics (QBA 1720) and Information Systems (MIS 2800). Most of my students are first-generation college students from rural Appalachia. I'm being formally certified in Experiential Learning through Ohio University's BRICKS Bridges Learning and Doing program.

I built Sparky because the same students who can't access Excel professors at home are the same students who'll grow up to be the electricians who need them. The same offline-first, experiential-learning philosophy I bring to QBA 1720 and to Tech Savvy puzzle days for 6th-8th grade girls is what made Sparky possible.

This is one piece of a larger commitment: **experiential, offline-first AI for the audiences ed-tech overlooks.**

---

## Acknowledgments

- **My son**, who calls me when Excel breaks him. The reason this exists.
- **Anthropic's Claude** ([claude.ai](https://claude.ai)), who served as my engineering pair-programmer for this project. I owe Claude credit for the heavy lifting on the implementation, the Kolb-cycle prompt architecture, and many honest conversations about scope.
- **Ohio University's BRICKS Bridges program** for the experiential learning coursework that grounds this project.
- **The CS50 team at Harvard** for the Puzzle Day materials I used at Tech Savvy the same week I built this — proof that good pedagogy is good pedagogy whether the audience is 11 or 41.
- **Google DeepMind** for releasing Gemma 4 with weights that fit on a teacher's laptop.

---

## License

MIT. Use it, fork it, ship it for your own trade. If you build something good with it, I'd love to know — open an issue and tell me.

See [LICENSE](LICENSE) for the full text.
