# Scenarios

This document explains how Sparky's scenarios are structured, how the on-screen bid sheet relates to the downloadable Excel file, and how to add new scenarios for other trades or job types.

## What is a scenario?

A **scenario** in Sparky is a realistic job for a tradesperson, expressed as a partially-completed bid sheet. The current scenario is a **200A residential service upgrade** with EV charger and hot tub circuits added — the kind of job a residential electrician encounters several times a year.

A scenario has two parts:

1. **The bid sheet** — a structured spreadsheet with realistic line items, some filled in, some blank
2. **The system prompt context** — a text representation of the bid sheet that Sparky can "see," so it can reference specific cells and guide the learner

Both parts are generated from the same source of truth: the `BID_ROWS` array in `index.html`.

## Why one source of truth matters

A common trap in AI tutoring is the model "knowing" something different from what the user sees. If Sparky says "look at row 14" but the user's row 14 is something else, the trust collapses immediately.

Sparky avoids this by using a single JavaScript array (`BID_ROWS`) that drives:

- The on-screen HTML table the learner sees
- The downloadable .xlsx file (via SheetJS)
- The text representation injected into Sparky's system prompt

When Sparky says "type your formula in cell D11," the learner can find D11 on the screen, in their downloaded file, and in Sparky's reasoning — because all three are generated from the same data.

## Anatomy of a row

Each row in `BID_ROWS` is an object with a `type` and column data. Here's the shape:

```javascript
{
  type: 'data',                    // 'header' | 'section' | 'data' | 'subtotal' | 'total' | 'blank-row'
  A: 'Main breaker panel, 200A',   // column A (item description)
  B: 1,                             // column B (quantity)
  C: 348.00,                        // column C (unit price)
  D: 348.00,                        // column D (line total)
  blank: ['D']                      // optional: which columns are intentionally blank for the learner
}
```

### Row types

- **`header`** — the column header row (Item / Qty / Unit Price / Line Total). Only one of these per scenario, at the top.
- **`section`** — a section divider with a single text label that spans all four columns. Renders as a navy bar with caution-yellow text. Used for MATERIALS, LABOR, PERMITS, TOTALS.
- **`data`** — a normal line item with values in some or all columns. The most common type.
- **`subtotal`** — a subtotal row (typically blank in the D column for the learner to fill in with SUM).
- **`total`** — the grand total row. Renders with a bolder top border and shaded background.
- **`blank-row`** — an empty row used as visual whitespace between sections.

### The `blank` array

Any column listed in the `blank` array of a row will:

- Render in the on-screen sheet as a yellow cell with a `?` marker
- Be exported to the .xlsx file as an empty cell
- Be marked as `BLANK` in the text representation Sparky sees

This is how the learner knows what they're supposed to fill in, and how Sparky knows what to coach them through.

## The current scenario

The 200A residential service upgrade scenario has 5 categories of blank cells, each teaching a different Excel skill:

| Cells | What the learner has to compute | Excel skill being taught |
|---|---|---|
| D12 | MATERIALS SUBTOTAL | `=SUM(D3:D11)` — basic SUM across a range |
| D15-D19 | Each labor line total | `=B15*C15` — multiplication of two cells |
| D20 | LABOR SUBTOTAL | `=SUM(D15:D19)` — SUM, second time, building reinforcement |
| D26 | Materials markup (25%) | `=D12*0.25` — multiplying by a percentage |
| D27 | Sales tax on materials (7%) | `=(D12+D26)*0.07` — tax on materials including markup |
| D28 | GRAND TOTAL | `=D12+D20+D23+D24+D26+D27` — combining multiple subtotals |

That's a meaningful arc: SUM → multiplication → SUM again → percentages → grand total. By the time the learner finishes, they've used the four most foundational Excel operations on data they actually understand.

## How Sparky "sees" the bid sheet

The `bidSheetForPrompt()` function in `index.html` walks `BID_ROWS` and builds a compact text representation that gets injected into Sparky's system prompt. It looks like this:

```
BID SHEET (the user can see this on screen — refer to cells by column letter + row number, e.g. D14):

Row 1: [A=Item] [B=Qty] [C=Unit Price] [D=Line Total]
Row 2: === MATERIALS ===
Row 3: A="Main breaker panel, 200A" B=1 C=$348.00 D=$348.00
Row 4: A="Service mast + weatherhead + riser" B=1 C=$215.00 D=$215.00
...
Row 12: A="MATERIALS SUBTOTAL" B=- C=- D=BLANK  [SUBTOTAL ROW]
Row 13: (blank divider row)
Row 14: === LABOR ===
Row 15: A="Service entrance install" B=7 C=$95.00 D=BLANK
...
```

This is what makes Sparky able to say "type `=SUM(D3:D11)` into cell D12" with confidence — it knows exactly what's in the sheet and where the blanks are.

## Adding a new scenario

The current build has one scenario hardcoded. Adding a new one requires editing `index.html`. The architecture is set up so this is mechanical:

1. **Decide the job.** What's the trade? What's the realistic scope?
2. **Build the BID_ROWS array** for that scenario. Use realistic line items, plausible 2026 pricing (don't worry about being exact — this is for teaching, not quoting), and intentionally leave blanks where you want the learner to practice specific Excel skills.
3. **Add a scenario selector** to the UI (currently doesn't exist — would need to be added).
4. **Update the system prompt** to mention which scenario is active.
5. **Update the scenario detail strip** above the bid sheet with the new customer description.

For Phase 2 of Sparky's roadmap, this hand-built process is replaced with **Gemma 4 generating the scenario dynamically**. The same `BID_ROWS` schema gets produced by the model rather than hardcoded — different bid every time, infinite practice variety.

## Pricing realism

The current scenario uses plausible 2026 wholesale prices for materials and a $95/hr journeyman labor rate. These are educational placeholders, not quotes — actual prices vary significantly by region, supplier, and contract.

For Phase 2 (dynamic generation), realistic pricing becomes harder because Gemma might generate $5,000 main panels or $0.50/hr labor rates. The fix is a constraint layer in the prompt: "Materials must be in plausible 2026 wholesale ranges (panels $200-500, cable $5-15/ft, etc.) and labor rates must be $65-150/hr."

## Scenarios for other trades

The same scaffolding works for any trade with spreadsheet-driven estimating:

- **Plumbers:** rough-in materials, fixture install costs, labor for trenching, water heater swap-outs
- **HVAC contractors:** equipment, refrigerant, ductwork, labor for install/start-up/balancing
- **General contractors:** demo, framing, drywall, paint, fixtures across multiple sub-trades
- **Landscapers:** plant material, hardscape material, equipment time, labor crews
- **Roofers:** shingles, underlayment, flashing, labor squares, dump fees

Each trade has its own line item vocabulary, its own typical labor units, its own pricing conventions. The Sparky pattern (realistic scenario + Kolb-cycle prompts + skill-level adaptation) applies; the specific scenarios get rebuilt for each trade.

This is the long-term roadmap: a **library of trade-specific scenarios** that share the underlying tutoring engine but speak each trade's native language.
