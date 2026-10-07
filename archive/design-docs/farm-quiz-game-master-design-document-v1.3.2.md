# Farm Quiz Game — Master Design Document

**Version:** 1.3.2 — Knowledge, Rest & steady difficulty; farm map for the iPad, seen at an angle (3 Oct 2026). Earlier versions and the 1.2 / 1.3 change notes are in `archive/`.

> **1.3.2:** the farm map is now seen at an angle like Hay Day (isometric): diamond field patches, pictures standing on their feet, a drag-and-drop layout editor, and see-through dark-blue shadows (§37.20).
>
> **1.3.1:** the prototype is now a farm map for an iPad held upright, plays in the browser, and has an art pipeline (§37.19).
>
> **What changed in 1.3** (details in §37)
> - **Knowledge:** 67 cards in 12 books and a library that grows from a box in the tent to a room. A card is learned by reading it and passing a short quiz that also reviews earlier cards. Card reviews are mixed into the Time Quiz (`knowledgeReviewShare` setting).
> - **"Training" is now Rest** (sleep, food, a sip of water). Gear — shoes, gloves, bag, water bottle, hat, apron, pillow, bed — makes work cheaper or gives more energy per Rest answer.
> - **Polish:** 22 endless upgrades with diminishing returns from chapter 1 (sharpen, oil, clean, re-stuff, root out the weeds…).
> - **New perpetual and seasonal systems:**
>   - seasons with things that slow and things that become plentiful;
>   - freshness checked at the change of season;
>   - visible pests chased by the scarecrow's fierce looks;
>   - frost stones, firewood, muck and crop rotation.
> - **Rewards and helpers:**
>   - food bonuses;
>   - luck and lucky events;
>   - pick-1-of-3 gift cards;
>   - little jobs;
>   - golden acorns;
>   - practice stars;
>   - choice slots on stations.
> - **Numbers:** exact underneath, whole on screen.
> - **Pacing:** steady difficulty instead of fixed hours (data v0.3).
> - **Prototype:** a playable **Godot 4.7 prototype** in `godot-prototype/` with a cheat button.
>
> **What changed in 1.2** (details in §36)
> - Energy for every job, growing by chapter.
> - Basic materials (sticks, stones, weeds) can be gathered at any time.
> - 9 patch levels, fertilizer and perpetual weeds.
> - Animal products need water.
> - 36 optional helpers, 27 side quests and two extra fields.
> - Swappable Time Quiz question packs.
> - The alpaca as fifth pet, and default pet names.
>
> **What changed in 1.1**
> - **New §33 Production & Unlock Tree.** Five chapters, 154 unlockables, 132 items, 94 recipes, paced by a simulation to ≈25 hours with the five pets at ≈1 / 6 / 10 / 18 / 25 h. The data lives in `progression/farm-progression.json`; `progression/progression-explorer.html` browses and checks it.
> - **New §34 Engine & asset pipeline** (HTML5 vs Godot) and **§35 Review notes** (prototype bugs fixed in this pass, plus what still needs a decision).
> - **Proposed resolutions** for several open questions, each marked *Proposed (1.1)* where it applies and collected in §30: manure becomes a compost loop; bees need flowers, not wheat or sugar; sugar comes from beets only; Lumbermill gets the "Extra" slot; Barn tiers carry the big animals; the Watering track saves water; Import Broker arrives with the 4th pet; linen and dyed wool replace silk.
> - Corrected statements: layout status (§17.5), Bread's place in the sequence (§9.2), animal conversions that lose money (§8.1).

---

## How to read this document

Every claim below carries a status tag so you always know how real something is:

| Tag | Meaning |
|---|---|
| **Implemented** | Verified in the current five-file prototype snapshot, or explicitly tested successfully. |
| **Partially Implemented** | The underlying mechanic exists, but a requested UX or final form is still missing. |
| **Placeholder** | The UI/location exists to reserve the concept, but the system behind it isn't built. |
| **Conceptual / Planned** | Established design direction, actively referenced in project discussion, not yet built. |
| **Dormant** | Specified once in the original Primer (including its brainstorm tail) and not reaffirmed, contradicted, or built on since. Carried forward here at full strength rather than dropped — but it needs a fresh yes/no before it's scheduled, because it may simply have fallen out of the conversation rather than been deliberately deprioritized. |
| **Inferred** | A reasonable conclusion drawn from combined design decisions, not a direct specification. |

---

## 1. Vision

### 1.1 Premise and setting

A medieval, craft-from-scratch farming game. The protagonist returns to a devastated farm — nothing works but the Well, the plots are barren, and only a Tent, hands, and a handful of wheat seeds remain. The player rebuilds the farm from nothing.

### 1.2 Target player and educational purpose *(Inferred, high confidence)*

The Primer's brainstorm tail repeatedly frames the audience as **children** — bars exist "so that children can immediately and intuitively get an idea," a proposed mini-game exists explicitly to "train eye tracking and fine motor skills,".

Stated educational aims:
1. **Resource planning** — deciding where scarce resources go.
2. **Opportunity cost** — saving an item for a future recipe vs. selling now.
3. **Sustainability, especially water** — water is intentionally visible and central.
4. **Light arithmetic with two-digit numbers** — via the Training Quiz.
5. **Quick-recall practice** — short response windows, repeated exposure, eventually spaced repetition.

The learning mechanics are meant to be the game's economy, not a bolted-on quiz layer.

### 1.3 The player fantasy

The satisfaction is not "I harvested a crop." It's **"I turned a handful of scarce resources into something valuable, and that unlocked the next part of my farm."** The full intended chain:

> seed → crop → animal/processing input → intermediate ingredient → processed ingredient → recipe → finished dish → pet/progression key

with water, energy, time, tools, and coins as competing constraints throughout.

### 1.4 The hidden narrative goal

**Five secret vegetarian pets** are the game's true destination. They are not announced up front with a tracker or checklist — recipes, ingredients, appliances, tools, and marketplace content gradually reveal what's possible, and the player discovers the dishes that bring each pet home. The farm is being rebuilt *for someone to come home to*.

### 1.5 What this game deliberately is not

Stated explicitly in the Primer as a boundary, and worth keeping as one:

- No XP/level system.
- No timed locks beyond the 1-question animal cooldown and Aging Station waits.
- No multi-screen navigation; no tech-tree UI. Dependencies are shown only when relevant. *(The complete tree in §33 is a design tool for us; players never get it as a screen.)*
- No direct coin rewards from quizzes — questions advance time and trigger passive production, nothing else.

---

## 2. Core Design Principles

- **The farm stays on one screen.** Detailed actions open contextual modals; the underlying systems can deepen without adding navigation layers.
- **Minimal text, strong visual signals.** Icons, numbers, compact requirement bars, visible locks, short labels, cause/effect interactions — not paragraphs.
- **Water is strategic, not decorative.** Every extra crop or animal indirectly competes for the same Well-fed water pool. The lesson isn't "water exists," it's *every choice that uses water reduces what's available for another choice.*
- **Energy is for actions; Training is how you replenish it.** Time Quiz and Training Quiz are deliberately separate loops. Time Quiz never grants energy.
- **Sell now vs. save to pantry** is the foundational expression of opportunity cost, and it recurs after every harvest, conversion, and craft.
- **Dependencies are visible only when they matter** — at the moment something is being unlocked or built. Once unlocked, routine screens show only the *immediate* inputs for the next action.
- **Upgrades replace, they don't multiply.** Hands → Wooden Shovel → Iron Shovel → Steel Shovel: one active tool, not four managed forever. The Primer is specific that this is literal — **the prior tier is consumed as an input to the upgrade**, not simply swapped out in the UI. Production responsibilities also migrate to their logical station as the farm matures (e.g., flour: Kitchen → Workshop Mill).

---

## 3. The Core Loop

1. **Answer the Time Quiz.** A correct answer advances farm time by one question-step. This can simultaneously: grow crops, refresh animal cooldowns, produce Well water, and roll a chest chance (§16). It does **not** award energy.
2. **Inspect the changed farm.** Crops closer to harvest, more water, animals available again — the quiz answer should feel like a game action, not an interruption.
3. **Harvest.** Sell now for coins, or save to pantry. Costs energy.
4. **Convert** raw materials through animal areas and, later, processing stations. Costs water and energy; animal conversions are intentionally water-heavier than plant harvests, by design, to keep the sustainability lesson present.
5. **Craft** finished goods. Same sell-vs-save choice.
6. **Spend** coins and materials on seeds, animals, Well upgrades, buildings, tools, and Marketplace unlocks.
7. **Progress** toward the pet dishes. Recipes unlock once the player holds at least one ingredient matching the recipe template's required tag(s) *and* the required appliance/tool prerequisite is built. Once unlocked, a recipe template stays visible in the Recipe Book even if its ingredients are later depleted. Not-yet-unlockable recipes remain visible under a lock icon everywhere relevant, so the path stays legible without cluttering the screen.

---

## 4. The Two Quiz Systems

### 4.1 Time Quiz

The game's time engine. **Implemented** as a separate `farm-quiz-engine.html`, embedded as an iframe, communicating with the farm via `postMessage`.

Current behavior:
- Random question from a small bank; wrong answers show feedback without advancing time.
- Correct answer → farm's `questionsAnswered` increments by 1 → all planted crops gain one growth unit → Well adds water up to capacity → state saves.
- Supports Next Question and Close Quiz.

**Design constraint (permanent rule, both sources agree):** Time Quiz is a *time* mechanic. It must never become an energy faucet.

Future direction: a real, much larger question bank with difficulty progression, repetition rules, curriculum/topic tagging, and possibly multiple question types, tied more deliberately to the farm's actual systems.

**Review note (1.1):** two things undercut the time engine. (1) A wrong answer can simply be retried, so with two choices every question ends up advancing time; consider showing the right answer with its explanation and moving on without advancing time (wrong answers then come back sooner, which is the spaced-repetition idea). (2) The bank has 4 questions, while a full playthrough is ≈1,350 Time Quiz answers (§33). Generated questions built from the player's own farm ("You have 14 water and wheat needs 2. How many can you plant?") would scale and tie the quiz to the farm.

### 4.2 Rest (formerly the Training Quiz)

> **Renamed in 1.3:** this loop is now called **Rest** — sleep, eating, a sip of water. It is still arithmetic. A better home, bed, pillow and water bottle give more energy per right answer, and gear makes work cheaper (§37.2). Wrong answers can be retried; there is no timer.

The quick-recall mini-game that restores energy. **Implemented** in simplified form.

Current behavior:
- Generated arithmetic question (simple small-number addition — a placeholder for the intended two-digit target), three answer choices, 3-second response window.
- **Correct answer → +5 energy, capped at max.**
- **Wrong answer or timeout → 0 energy.** *(Decision: the Primer's original "+1 safety net" is explicitly not kept. There is no floor reward.)*
- Continue / Close flow.

**Spaced repetition (Conceptual — Dormant until reaffirmed):** the original design specifically calls for an Anki-style scheduler underneath both quizzes — correct answers recede into the future, incorrect ones recur soon, adapting to what each player actually knows. Not yet implemented; the current generator is a flat random draw.

**Intended UX direction (Pending):** remove the separate Training button; tapping the **Energy indicator itself** launches Training. Makes the resource its own entry point to replenishment and simplifies the top bar.

---

## 5. Resource Economy

### 5.1 Coins

Earned primarily by **selling outputs** — never directly from answering quizzes. Spent on seeds, animals, Well upgrades, buildings, tools, and Marketplace unlocks.

- **Target/final starting state (Primer, prioritized): 0 coins.** This is the intended poorest-start fantasy — the player earns their first coins by selling Porridge.
- **Current prototype value: 200 coins**, explicitly a testing convenience, not the intended economy.

### 5.2 Water

Finite capacity resource produced by the Well.

| Well level | Water/Time Quiz | Capacity |
|---|---:|---:|
| 1 | +2 | 20 |
| 2 | +4 | 30 |
| 3 | +6 | 40 |

Consumed by planting, animal conversion, and (later) processing/crafting. Well upgrades are intentionally **frequent and cheap**, coin-only early, to keep water salient without letting it overshadow coins. Animal conversions cost meaningfully more water than plant harvests — a deliberate economy-balance rule to keep the sustainability lesson visible.

*Proposed (1.1, §33):* Well 4 (+8 per question, holds 60; bricks + iron) and Well 5 hand pump (+11, holds 80; steel). Extra sources: Pond (+2, +20 storage), Rain Barrel (+1, +15), Tortoise pet (+1), Wind Pump (+4, +40). Tools cut use instead of adding water: Watering Can −25%, Drip Line −50% (§11).

### 5.3 Energy

Manual-action resource (planting, harvesting, converting, crafting, building).

- Living Quarters caps: Tent 20 → Cottage 30 → Farmhouse 50 (both sources agree).
- Current prototype: start 10, max 20; planting/harvesting cost 1; conversion/crafting costs vary by action; +5 on Training success; **0 on Training failure or timeout** (Decision, §4.2).
- Never granted by Time Quiz.

### 5.4 Seeds

Bought primarily through the **Seed Merchant**, always available for coins as a safety valve — the player is never permanently locked out of basic seeds.

- **Starting wheat seeds: 5** *(Decision — adopts the prototype's value over the Primer's original 10)*.
- **Pending UX:** seed quantity needs a visible requirement/progress bar in the planting interface, not text-only. Water and energy already have bars; seeds don't yet.

### 5.5 Manure *(Dormant — reinstated from Primer)*

The Primer states mid- and late-stage crops require manure to initiate growth. This resource has **no presence anywhere in the current prototype or its economy model** — not even as a placeholder. It needs to be reintroduced into the resource list and tied into the crop-growth-stage gating logic before mid/late crops can function as intended. Likely source: animal byproducts (needs a decision on which animal, or a dedicated collection mechanic).

*Proposed resolution (1.1):* manure feeds a **compost loop** instead of being a resource of its own. "Hungry" crops (tomato, sunflower, pumpkin, berries, all greenhouse crops) need 1 compost to be planted. Compost comes from the Compost Bin: 3 straw → 2 compost or 3 weeds → 2 compost (4 questions), and much faster with manure (1 manure + 1 straw → 3 compost in 3 questions) or oilcake from the press. Cows and sheep drop manure with every product. The goat pet adds a little compost by itself.

### 5.6 Requirement / progress bars

A repeatedly-validated UX pattern in both sources, and one of the strongest anchors in the whole design:

- A bar appears **directly below the number display** for *every* required input to an action — including coins.
- **Color coding:** red = low/empty, yellow = partial, green = sufficient/full.
- **Accessibility:** color must be paired with iconography, not carry meaning alone, for players with color vision differences. *(This accessibility note exists only in the Primer — the Briefing's version of this rule drops it entirely and should not.)*

Current status: water, energy, and Well-upgrade progress have bars. Seed quantity and conversion/cooldown timing do not yet (§22).

---

## 6. Farming System

### 6.1 Field layout

**12 central planting patches, 3×4 grid, zero gaps between them** — 9 ordinary field patches plus 3 reserved/special patches for later building or feature use. This supersedes the Primer's original 9-plot/3×3 concept; it's a deliberate later evolution (discovered through testing), not a contradiction to resolve.

### 6.2 Planting

Requires: 1 seed + crop-specific water + 1 energy. **Mid- and late-stage crops additionally require manure** (§5.5 — currently unimplemented). The planting modal shows crop icon, seed quantity, water requirement, energy requirement, and growth time in quiz questions. The whole field plot is already clickable (Implemented) — the remaining UX debt is applying that same whole-card interaction elsewhere (§22).

### 6.3 Growth and visuals

Two distinct mechanics work together here and are not in conflict, though they've only ever been described separately:

- **Growth stages** (per individual plant): sprout → developing crop icon → larger/pulsing "ready" stage. Currently implemented with emoji as a deliberate placeholder for future PNG art; crops should render centered in the patch, scaled rather than clipped.
- **Plants-per-plot** (Conceptual/Dormant): tool-tier upgrades (Digging, Watering) are meant to raise how many plants a single patch holds — 1 → 2 → 3+. Visual abundance for this is meant to come from simply **repeating the current growth-stage image in a small grid inside the patch** — no bespoke multi-plant art is needed. The current prototype only supports 1 plant per plot; this tiling behavior hasn't been built yet.

### 6.4 Canonical crop catalog

wheat, tomato, potato, onion, carrot, beet, lettuce, beans, olive, walnut, apple, berries, flax, **sunflower, pumpkin** *(sunflower and pumpkin added per Decision — previously mentioned only as example future Seed Merchant unlocks, now formally canonical)*.

Current prototype test set (Implemented, intentionally small): **wheat, carrot, tomato** only. Lettuce is explicitly confirmed canonical in the Primer and should not be second-guessed during content expansion.

*Proposed catalog (1.1, §33):* **field** — wheat, carrot, clover *(new: fodder and bee flowers)*, onion, potato, lettuce, beans, tomato, beet, oats *(new)*, sunflower, flax, pumpkin, berries, herbs *(new)*, woad *(new: blue dye)*; **orchard** (planted once, harvested again and again) — apple, walnut, olive; **greenhouse** — saffron crocus *(new)* and the heirlooms rainbow carrot and golden beet, which are the "rainbow vegetables" of §15.1. Wheat and oats also give straw.

### 6.5 The tomato unlock example

**2 eggs → unlock tomato seeds once → purchasable with coins thereafter.** Implemented and tested. This is a working prototype of an **ingredient-threshold unlock** — note this is mechanically distinct from the Marketplace's **dish-delivery unlocks** (§13); the two patterns should be named and tracked separately rather than treated as the same system.

---

## 7. Harvesting, Selling, and Pantry Decisions

Every production event ends in the same choice:

- **Harvest** → Sell now / Save to pantry / Cancel. Costs energy.
- **Animal products** → same pattern.
- **Crafted goods** (currently: Bread) → same pattern.

**Pantry** is the compact inventory UI, reached through the Storage/Barn slot, grouping raw crops, animal/bee products, and crafted goods. Selling from pantry is implemented.

**Pending:** make the **whole pantry item card** the click target for selling, not a small Sell button (§22).

---

## 8. Animal System

Four animal areas, all spatially implemented: Chicken, Cow, Sheep, Bee.

### 8.1 Chicken

**3 Wheat + 3 Water + 1 Energy → 1 Egg.** Trivial conversion by design — no processing chain intended for eggs. Each chicken converts once per question-step, then waits for the next Time Quiz. Chickens are purchasable; area has a capacity.

**Review note (1.1):** at the prototype's prices this conversion loses money (3 wheat sell for 9 coins, the egg for 6) and the cow only breaks even (4 wheat = 12 = 1 milk), so selling the wheat is always better. The tree (§33) uses: chickens 2 wheat + 1 water → 1 egg every question; cows 3 clover + 3 water → 1 milk + 1 manure every 2 questions (needs the Barn); sheep 2 clover + 2 water → 2 wool + 1 manure every 3 questions (needs the Sheep Pen and Shears); bees see §8.4. Every animal now earns more than its feed is worth, and animal products stay the thirstiest.

### 8.2 Cow

**4 Wheat + 4 Water + 2 Energy → 1 Milk** (current simplified conversion). Intended full chain:
- **Butter:** milk → Churn L1–3.
- **Yogurt:** milk + yogurt culture → Fermenter L1–3.
- **Cheese (fresh):** milk + cheese culture → Cheese Station (requires a built Pressing Machine).
- **Aged Cheese:** fresh cheese → Aging Station, N questions.

### 8.3 Sheep

**3 Wheat + 3 Water + 1 Energy → 1 Wool** (current simplified conversion). Intended chain: shearing → thread (Hand Spindle, stays in Sheep Area) → weaving, which **migrates to the Workshop** once the Textile Machine is built, consuming the Hand Loom in the process.

### 8.4 Bee

**2 Wheat + 2 Water + 1 Energy → 1 Honey** (current simplified conversion). Intended chain: Honey Extractor levels 1–3, later a Beeswax Extractor. Beeswax uses: candles (a night-craft prerequisite), waterproofing (a Cellar upgrade requirement), polish (Living Quarters upgrades), tool maintenance, and wax seals for special trades.

**Pollination / biodiversity system** *(Dormant — reinstated from Primer)*: bees don't need direct feeding via flowers. Planting pollinator-friendly crops grows the hive over each time cycle those crops are present; larger hives in turn benefit crop growth, though the exact mechanism (shorter grow time vs. lower water need) is explicitly **undetermined and needs playtesting** — this was an open question in the source, not a specification.

A more complex bee-economy variant is also proposed: harvesting honey requires *feeding the bees sugar* (since honey is being taken from them). Collection readiness is shown via a blinking indicator, at which point sugar is converted into honey + wax. The proposed sugar source is a **"Sugar Carrot"** — pressed into sugar water, aged/reduced at the Aging Station, then finished by an unspecified tool that turns syrup into a usable form. **Open inconsistency, flagged rather than resolved:** the Primer separately defines a *Beet → sugar/syrup* conversion (Press L1 + Stove L1 reduction) elsewhere in its recipe catalog. Whether "Sugar Carrot" is a distinct crop, a rare chest-only carrot variant (the same document elsewhere floats "purple carrots" as a luck-only cosmetic variant), or simply an inconsistent restatement of Beet, is an unresolved naming question that needs a designer decision before this system is built (see §31).

*Proposed resolution (1.1):* keep bees simple. They are never fed and never given sugar; a hive (straw skep first, wooden hive later) yields honeycomb every 2 questions as long as a flowering crop grows somewhere on the farm (clover, sunflower, flax, berries, herbs, fruit trees). Comb is crushed by hand (2 comb → 1 honey + 1 wax) until the Honey Extractor (2 comb → 3 honey + 1 wax). Sugar comes only from beets (press → beet juice → iron-top stove). "Sugar Carrot" is dropped; purple and rainbow carrots stay as the heirloom crop. Hive growth through pollination is left out of v0.1 because it needs its own balancing.

### 8.5 Cooldown principle

Question-based, not real-time (both sources agree). The farm's master clock is the quiz-driven question count; no independent real-time simulation is needed.

### 8.6 Animal visualization

**Implemented and tested successfully:** one emoji per owned animal, placed within its area, small bob animation, periodic small random movement, clamped to an interior region. Should keep this lightweight concept when emoji are eventually replaced with real animal art — the lesson from testing was that *small ambient animation adds life without needing a full simulation.*

### 8.7 Animal-area interaction

The whole animal field opens the relevant modal (Implemented) — good, matches the whole-card philosophy. **Pending:** conversion *within* the modal is still small-button-based; the entire conversion row should be the click target, with clear disabled-state feedback when requirements aren't met.

---

## 9. Cooking and Crafting

### 9.1 Porridge — the true starter recipe *(Decision)*

Before the Farmhouse, Recipe Book, or Bread exist, the player cooks **Porridge at the Tent**, using **Fire + Tin Pot**. Selling Porridge yields the player's *first coins*, used to buy more seeds. This is the opening rung of the crafting ladder and precedes everything else in this section.

### 9.2 Bread — the first Farmhouse/Oven recipe

Currently the sole prototype recipe (Implemented): **3 Wheat + 1 Energy + fixed sell value**, accessed via the Farmhouse/Recipe Book. In the corrected sequence, Bread is the step *after* Porridge — it becomes available once the Farmhouse and a basic Oven exist, not before.

*Proposed (1.1):* Flatbread (flour from the hand quern + water, on the campfire) fills the gap in chapter 1. Real Bread needs the Oven, which arrives with the Cottage (chapter 2, not the Farmhouse), and a **Sourdough Starter** that is made once and kept, so bread needs no yeast merchant. The prototype's 3-raw-wheat bread is a placeholder.

### 9.3 Appliance-first kitchen UX

The Kitchen (inside Living Quarters) organizes around **the appliance first**, not one giant recipe list:

- **Stove** (cooking/boiling) — Levels 1–3 unlock stews, sauces, multi-step cooking.
- **Oven** (baking) — Levels 1–3 unlock breads, cakes, masterwork dishes.
- **Prep Station** — improves recipe eligibility and throughput; raw-edible and assembly-only items.
- **Food Processor** — evolves from an early small-batch Grinding Tool; specializes for spices/nut butters once the Workshop Mill takes over bulk flour milling.

Tapping an appliance filters inventory to only what's usable there, based on known recipe templates and tag compatibility. A later-unlockable **"Experiment" tab** allows free-form combinations, with clear failure feedback (e.g., "Needs vinegar").

Preservation/aging lives in the **Barn**, not the Kitchen (§12.4).

### 9.4 Appliance and tool leveling

- Stove/Oven/Prep/Processor each gate recipe tiers: basic → intermediate → advanced across Levels 1–3.
- Cutting Tool tier (Stone/Iron/Steel Knife) gates prep complexity: rough chop → fine dice → precision.

### 9.5 Appliance–tag compatibility

Process tags drive what each appliance can use:

| Appliance | Compatible tags |
|---|---|
| Stove | cookable, fermentable (heat step), mashable, pureeable (if a processor isn't required) |
| Oven | bakeable, roastable |
| Prep Station | raw-edible, assembly-only components |
| Food Processor | pureeable, nut-seed (butters), small-batch milling (early only) |
| Press | pressable-oil, pressable-juice, pressable-sugar |
| Mill | millable (grains, nuts/seeds for flours) |
| Churn | dairy (milk → butter) |
| Fermenter | fermentable + culture-agent (yogurt, cultured cheese prep) |
| Aging Station | age-able (cheese, vinegar, honey, cured olives) |

*(The full recipe template catalog these tags feed into is reproduced in full in Appendix C — it's long enough to warrant its own reference section rather than living inline.)*

### 9.6 Multi-step assembly example: vinegar

**Juice → cider (ferment) → vinegar (age)**, via the Aging Station over N questions. Vinegar then enables pickling recipes. This is the Primer's deliberate proof that the crafting system must handle multi-step transformation chains, not just one-step recipes.

### 9.7 Recipe unlock rules

A recipe template becomes visible once the player has at least one ingredient matching its required tag(s) **and** the required appliance/tool level is built. Once unlocked, it **stays visible** even if ingredients are later depleted. Not-yet-unlockable recipes remain visible under a lock icon so the path stays legible.

### 9.8 The tag system *(partially Inferred)*

The Primer states ingredients carry "four tag sets" that drive recipes, filtering, and progression — but the original enumeration was lost mid-edit in the source. Reconstructed from the surrounding design language (Inferred, flagged for confirmation):

- **Ingredient tags** (what it is)
- **Process tags** (what can be done to it — cookable, bakeable, pressable, etc.)
- **Function tags** (what role it plays — sweetener, fat-source, aromatic, etc.)
- **Appliance-compatibility tags** (which stations accept it)

This should be explicitly reconfirmed rather than assumed correct, since it's a reconstruction, not a direct quote.

### 9.9 Pricing model *(Dormant — reinstated draft from Primer)*

Prices should emerge from base ingredient value + processing multipliers + rarity/complexity bonuses, not be arbitrary. A first-pass multiplier draft exists and should be treated as a starting point for calibration, not a final table:

| Process | Multiplier |
|---|---|
| Milling | 1.2× |
| Cooking | 1.25× |
| Baking | 1.4× |
| Pressing | 1.3× |
| Fermenting | 1.35× |
| Aging | 1.5× |
| Assembly bonus | 1.1× |

Compounded multipliers should be **capped** to prevent runaway values on deep chains. Current prototype uses flat fixed prices as a placeholder.

*Used in the tree (1.1):* a processed item is worth (inputs + 0.2 per water + 0.2 per energy + 0.2 per question of waiting) × 1.15, split across its outputs; by-products have small fixed values; bought materials sell back at half price. The explorer's value check flags any recipe that loses value or more than triples it. Deep chains still compound (a Golden Honey Cake is worth 128 coins, a porridge 3), which is the point.

---

## 10. Workshop and Production Infrastructure

Planned stations, all currently Placeholder:

- **Bulk Milling Machine (Flour Mill)** — once built, the "grind wheat" option disappears from the Kitchen and reappears here.
- **Textile Machine (Loom)** — consumes the prior Hand Loom; all weaving moves here from the Sheep Area, which retains only shearing/thread prep.
- **Pressing Machine** — extracts oils (seeds/nuts) and juices (fruits/roots); also the prerequisite for the Cheese Station in the Cow Area.
- **Metalworking Station** (Forge/Anvil/Smithy tiers) — required for metal tools and advanced machines.

The current Workshop UI is a placeholder that tells the player future machines will live there. A Windmill slot exists as a placeholder specifically for the eventual flour mill — see §12.6 for how this relates to (and is currently conflated with) the separately-planned Lumbermill.

---

## 11. Tools and Action Slots

Five upgrade tracks, each **replacing its prior tier by consuming it as a build input** (per the Decision in §2 — this is the Primer's literal reading, prioritized over the Briefing's softer "replaces the old tool" phrasing). Only the current tier is shown or usable at any time.

| Track | Progression | Effect *(Conceptual/Dormant — proposed mechanics, not yet built)* |
|---|---|---|
| Digging | Hands → Wooden Shovel → Iron Shovel → Steel Shovel | Raises plants-per-plot; affects planting/harvest energy cost |
| Cutting | Stone Knife → Iron Knife → Steel Knife | Gates prep complexity (rough chop → fine dice → precision); small harvest bonus |
| Hammering | Rock → Iron Hammer → Smith's Hammer | Enables metal item crafting/build upgrades |
| Woodworking | Hand Axe → Saw → Master Saw | Enables wooden structures/machines |
| Watering | Wood Can → Crude Metal Can → Steel Can → Sprinkler | Raises plants-per-plot |

Current status: conceptual only. No tool inventory or upgrade UI is active in the prototype yet.

*Proposed effects (1.1, §33):*
- **Digging:** Wooden Shovel clears rocky patches; Iron Shovel = 2 plants per patch; Steel Shovel = 3. Seeds, water and harvest scale with it.
- **Watering:** changed from plants-per-patch to **water efficiency**: Bucket 100%, Watering Can 75%, Drip Line 50%. This gives the sustainability lesson a tool of its own and avoids two tracks doing the same thing.
- **Cutting:** gates recipes (stone: bowls and salads; iron: sauces and pasta; steel: master dishes).
- **Hammering:** gates building tiers (Rock: early builds; Iron Hammer: nails, windmill, barn cellar, bigger well; Smith's Hammer: Farmhouse, Greenhouse, master buildings).
- **Woodworking:** Hand Axe clears stumps and splits logs into planks (1 → 2); the Saw at the sawbench gives 1 → 4; the Master Saw builds looms and the stone-grinder windmill.
- Two side tools: **Shears** (needed for sheep) and **Wheelbarrow** (harvesting −25% energy).

---

## 12. Buildings and Farm Infrastructure

### 12.1 Living Quarters

**Tent → Cottage → Farmhouse.** Energy cap: 20 → 30 → 50. Houses the Kitchen appliances. The Farmhouse is also the Recipe Book access point.

### 12.2 Workshop

Three tiers: **Basic → Advanced → Master.** Hosts the machines in §10.

### 12.3 Storage Building

**None (bag/box) → Shed → Warehouse.** *(Decision: Barn is removed from this progression track and treated as its own building — see 12.4.)* General inventory capacity track.

### 12.4 Barn *(Decision — separate building)*

The Barn is its own building slot, distinct from Storage — matching what the current prototype's bottom building row already implements (Row 2 includes a standalone "Barn" slot alongside Storage). Per the project owner's resolution:

> *"The Barn links to storage upgrades, the Aging Station, and some animal-related upgrades."*

That is: the Barn is where storage-capacity bonuses are realized, it houses the Aging Station (and Cellar), and it also gates or boosts certain animal-related upgrades. **Open question:** the exact animal-upgrade linkage (coop/pen capacity? feed storage? something else?) is not yet specified and needs a follow-up decision (§31).

*Proposed resolution (1.1):* Barn tiers carry the big animals. Barn (built in two stages) lets 2 cows move in; Barn · cellar makes room for 3 and holds the Cellar Racks and Fermenting Crocks; Barn · stable takes 4 cows and 5 sheep and is where the pony lives. Chickens and bees have their own small upgrades (coop, hives). Storage capacity stays with the Storage track (Basket 10 → Shed 25 → Warehouse 60 of each item).

### 12.5 Well

The first fully active building. Upgrade levels, capacity changes, coin requirements, and a requirement bar are all Implemented (§5.2).

### 12.6 Lumbermill

Intended passive production: wood per question, with upgrade levels raising the rate and eventually unlocking hardwood. **Note:** the current Windmill placeholder is aimed at *flour* production (§10), not wood — Lumbermill and Windmill are two distinct planned buildings that are currently conflated in the prototype's single placeholder slot. This should be split out explicitly before either system is built.

*Proposed resolution (1.1):* the 8th building slot ("Extra") becomes the **Lumber** slot: Woodlot (chapter 2, 1 log every 2 questions) → Lumbermill (1.5 logs) → hardwood grove (2 logs + some hardwood). The Windmill slot stays flour and later also pumps water.

### 12.7 Marketplace

An interface, not a conventional upgradeable production building. Unlocks progressively via dishes (§13).

### 12.8 Greenhouse

A mid/late-game system, intended to eventually occupy one of the three reserved special field patches (§6.1).

### 12.9 Scarecrow

**Stick → Dressed → Guardian.** *(Dormant — reinstated mechanical effect)* Better tiers reduce the energy cost of planting/growing. This specific effect exists only in the Primer; the Briefing had left the Scarecrow's gameplay purpose fully undefined.

*Proposed numbers (1.1):* Stick Scarecrow — planting costs half the energy; Dressed (wool cloth) — planting is free; Guardian (iron, linen) — harvesting also costs half.

---

## 13. Marketplace and Unlock Economy

Merchant categories, most still mostly future (only the Seed Merchant piece is Implemented):

- **Seed Merchant** — always available, coins-only (the seed safety valve, §5.4). Further seeds — including **Sunflower and Pumpkin**, now canonical (§6.4) — unlock gradually via distinct recipes.
- **Spice Merchant** — unlocks via delivering a distinct dish; sells spices and salt, using a **crop + coins barter**, not coins alone.
- **Culture Specialist** — unlocks via a distinct dish; sells yeast, cheese cultures, and yogurt cultures, also via ingredient + coins barter.
- **Raw Materials Merchant** — better material tiers (Wood, Metal, Stone, Clay/Mortar, Glass) unlock via delivering specific composite dishes, one-time. Worked examples from the Primer: *Hearty Vegetable Stew → Iron Ore; Honey Oat Cake → Hardwood; Stone Soup → Quarried Stone; a premium dish → Steel.* Lower-quality material tiers remain cheaply purchasable throughout. *(Proposed 1.1 mapping: Porridge → sticks, stone, logs; Stone Soup → clay; Hearty Vegetable Stew → iron ore; Honey Oat Cake → hardwood and sand; Pizza → finished steel and glass as an expensive shortcut.)*
- **Import Broker** — late-game; unlocks after returning 3 pets; trades high-value crafted goods for rare/exotic ingredients. Barter-only — coins are explicitly not sufficient here. *(Proposed 1.1: arrives with the 4th pet, so chapter 5 opens with it; trades saffron corms, heirloom seeds and woad for aged cheese, jam, pickles and cloth.)*
- **Avatar Accessories Shop** — unlocks mid-game after the 2nd or 3rd pet returns; purely cosmetic, coins only.

**Two distinct unlock mechanisms — do not conflate them:**
1. **Ingredient-threshold unlocks** (e.g., 2 eggs → tomato seeds, §6.5) — already tested and working.
2. **Dish-delivery unlocks** (the merchant tiers above) — consumed on delivery, paired with the NPC hint system (§15.3).

**Lock icon pattern:** locked/future content in any merchant panel is grouped under a single lock icon; tapping it expands the full list with requirements. Same pattern reused in the Recipe Book and every other relevant menu — this avoids complicated per-item condition-checking UI while keeping the progression path visible.

---

## 14. Progression Philosophy

No XP, no levels, no permanent top-of-screen progress bar, no tech-tree screen. The player reads their own progress from what they can now *do* — better tools, buildings, machines, crops, animals, recipes, chains, storage, water capacity, passive production, and merchant access.

---

## 15. The Pet Goal Structure

### 15.1 The five pets

Return in order of increasing complexity, each bound to a specific vegetarian dish (or set of dishes/items). Each return reveals a piece of the farm's mystery narrative. The final pet requires multi-branch mastery: rainbow vegetables, aged premium ingredients, textiles/silk, and a master-level cake (e.g., a Golden Honey Cake).

*Proposed line-up (1.1, §33; names are placeholders):*

| # | Pet | Dish | Comfort item | Simulated arrival | Bonus idea |
|---|---|---|---|---:|---|
| 1 | Bunny | Carrot-Clover Bowl | Straw Hutch | ≈1 h | +1 carrot per harvest |
| 2 | Tortoise | Tortoise Garden Platter | Warm Shell House | ≈6 h | +1 water per question |
| 3 | Goat | Apple Oat Crumble | Goat Shed | ≈10 h | 1 compost every 4 questions |
| 4 | Pony | Apple-Carrot Cake | Saddle Blanket (needs the Barn stable) | ≈18 h | +10% when selling |
| 5 | Unicorn *or* alpaca | Golden Honey Cake + Rainbow Roast | Rainbow Quilt | ≈25 h | — |

Silk is replaced by linen and plant-dyed wool: silk production kills the silkworms, which sits badly with a vegetarian theme. A unicorn fits the pixie and fairy-dust magic of §16; an alpaca keeps the farm grounded.

### 15.2 Avatar and companion behavior *(Dormant — reinstated from Primer)*

A player avatar that **walks toward whatever part of the screen is being interacted with**. This is purely cosmetic — it doesn't gate or slow menu access; it just continues walking and stands there while the player uses the relevant menu. Once pets return, **they follow the avatar in a loose radius**, wherever it goes.

Related, also Dormant: avatar accessories purchasable via the Marketplace's Avatar Accessories Shop (§13); avatar clothing eventually craftable; an avatar "skill" system (cooking/crafting proficiency) tradeable for specific dishes given to expert NPCs; and an optional permanent "strength" stat, upgraded by depositing/spending energy into it.

### 15.3 NPC hints and unlock penalties *(Dormant — new section, reinstated from Primer)*

NPCs give **partial**, not complete, hints about what's needed to unlock the next item — the player has to do some trial and error. If a delivery attempt is wrong, the crafted dish is consumed: the player still receives its sale-value coins, but the unlock does not trigger. The NPC then offers an additional hint as compensation. This system pairs directly with the dish-delivery unlock mechanism in §13.

---

## 16. Random Reward / Chest System

**Trigger:** a 20% chance after each successful Time Quiz answer (both sources agree — the Primer's brainstorm tail phrases this once as "a one in five chance," which is the same 20%, not a separate rule).

**Review note (1.1):** at ≈1,350 Time Quiz answers per playthrough this is ≈270 chests, each with a pixie mini-game: one every 5 questions. Consider 8–10%, or a fixed chest every N questions with small random extras in between.

**Reward tiers** *(Dormant — the Primer's fuller version, reinstated in full; the Briefing's version had flattened this to a generic "tiered loot" line)*:
- Almost always contains *something*, often low-value (e.g., a single wheat seed).
- Sometimes a seed that's not yet unlocked, but not too far out of reach.
- Rarely, a seed **obtainable only through chest luck** — cosmetic crop variants (the Primer's own example: purple carrots).
- Occasionally a purely cosmetic avatar item (a ring, a scarf) that doesn't touch any dependency chain.

**Pixie collection mini-game** *(Dormant — reinstated, no equivalent anywhere in the Briefing)*: when a chest triggers, a small pixie sprite flies around the screen in random directions, briefly sprinkling fairy dust. The player must tap the pixie to collect it, and must fill a short "fairy dust meter" before the mini-game window ends to actually receive the reward. Framed explicitly in the source as incidental eye-tracking and fine-motor practice.

---

## 17. Visual and Layout Direction

> **Update 1.3.1:** the Godot prototype uses a portrait farm map with places to tap and sheets that slide up — see §37.19; since 1.3.2 it is seen at an angle (§37.20).

### 17.1 Composition

Three (four, counting the split) visual bands: top bar (resources + quiz access) → animal row (4 areas) → central 3×4 crop grid → bottom building rows (8 slots, 2 rows of 4). The central field is the visual heart of the farm.

### 17.2 No gaps

Adjacent image-backed areas visually touch — the crop grid, animal tiles, and building rows all use zero gaps, so the eventual PNGs can read as continuous terrain/bars rather than floating cards.

### 17.3 Placeholder art now, final art later

Current visuals (field/animal/building PNGs, emoji plants and animals) are intentional placeholders; the user will produce final art later. Code should avoid baking layout assumptions too deeply into specific image dimensions or art-specific hacks.

### 17.4 Aspect-ratio philosophy

- Animal fields: fairly large, slightly taller than wide.
- Central planting patches: consistent ratio, allowed to absorb some overall screen-ratio distortion.
- Building fields: smaller, arranged 2×4.
- Background elements should not be unnecessarily cropped.

*(Exact final pixel dimensions previously discussed are not preserved in either source document and would need to be re-derived or re-specified.)*

### 17.5 Responsive targets

Usable on an **iPhone 6-sized screen** at minimum, scaling well to **iPad**-sized displays. **Updated 1.1:** the farm now fills exactly one screen (viewport height, no page scrolling) and the column scales as a ≈3:4 portrait (`max-width: min(100vw, 75vh)`), checked at 320×568, 375×667, 414×896, 768×1024, 1024×1366 and landscape. Final art may still need ratio decisions (§17.4).

### 17.6 Current technical visual debt

- Field backgrounds use `object-fit: fill` — preserves full visibility, can distort art.
- Animal/building backgrounds use `object-fit: cover` — can crop art.

Both should be revisited once real art replaces placeholders, rather than treated as final.

### 17.7 Asset specifications *(reinstated from Primer — the Briefing had explicitly flagged these as lost)*

- Crop stage art: transparent PNGs, **64–128px**.
- Buildings/tools: neutral backgrounds.
- Dedicated bee/wax icon set.
- Animated "ready" pulse via CSS.
- Images organized under `/assets`, with folders per category.

### 17.8 Reference/inspiration resources *(reinstated)*

- [opengameart.org — Farming Tool Icons](https://opengameart.org/content/farming-tool-icons)
- [opengameart.org — 16x16 Food](https://opengameart.org/content/16x16-food)
- [opengameart.org — Farming Set Pixel Art](https://opengameart.org/content/farming-set-pixel-art)
- [opengameart.org — Simple Farm Tiles](https://opengameart.org/content/simple-farm-tiles)

---

## 18. UI Structure and Modal UX

> **Update 1.3.1:** see §37.19 for the farm-map interface that replaces the tabs.

**Top bar (current → intended):**

| Current | Intended |
|---|---|
| Coins | Coins |
| Water | Water |
| Energy | Energy *(becomes the Training entry point once merged — Pending)* |
| Time Quiz (question-mark icon + text) | Time Quiz (**clock icon** — Pending) |
| Training (separate button) | *(removed — merged into Energy)* |

Recipe Book is reached through the **Farmhouse**, not the top bar (both sources agree).

**Modal-per-feature philosophy:** field tap → plant/harvest; Market tap → seed marketplace; Farmhouse tap → recipes; Storage/Barn tap → pantry/aging; animal field tap → animal area; Well tap → upgrade interface; Energy tap → Training. No feature gets its own full page — the modal system is the game's entire secondary interaction layer.

---

## 19. Current Technical Architecture

Five files, intentionally split so future changes don't require rewriting one monolithic file:

- **`farm-game-main.html`** — persistent farm composition: top bar, animal slots, 3×4 field grid, building slots, quiz modal iframe, generic UI modal.
- **`farm-game-style.css`** — layout, responsive structure, tile sizing, modal styling, buttons, requirement bars, crop/animal animation, card styling.
- **`farm-game-config.js`** — data-oriented definitions: crops, recipes, Well levels, action energy costs, animal-output prices, starting state.
- **`farm-game-core.js`** — the engine: state load/save, migrations, time advancement, field/animal rendering and wandering, planting, harvesting, pantry, market, animal conversion, recipe crafting, Well upgrades, placeholder buildings, Training Quiz, event wiring, iframe communication.
- **`farm-quiz-engine.html`** — the Time Quiz: question bank, answer handling, feedback, Next Question, farm communication via `postMessage`.

- **`progression/farm-progression.json`** *(new in 1.1; design data, not yet read by the prototype)* — every item, unlockable and recipe of the full tree (§33). Plain JSON so the HTML prototype and Godot can both load it.
- **`progression/progression-explorer.html`** *(new in 1.1; design tool)* — browses the tree and runs the validity and pacing checks.

(Full file-tree diagram in **Appendix B**.)

---

## 20. Game State Model

### 20.1 Current (Implemented)

```text
resources
  coins
  water
  waterCapacity
  energy
  energyMax
  inventory

farm
  plots[]
    planted
    cropId
    growth
    type

buildings
  well
    level

animals
  chickens[]
  cows[]
  sheep[]
  bees[]

unlockedCrops
unlockedRecipes

quiz
  questionsAnswered
```

Persistence: browser `localStorage`, versioned storage key.

### 20.2 Suggested future save-state schema

Extended to cover both the Briefing's known gaps *and* the systems reinstated in this merge (manure, Barn, avatar, NPC hints, bee biodiversity, chest/pixie history):

```text
player
  tools
  equipment
  avatar
    position
    accessories
    clothing
    skills
    strengthStat

resources
  coins
  water
  energy
  manure
  inventory

farm
  plots
  greenhouse
  scarecrow

buildings
  livingQuarters
  workshop
  storage
  barn
    agingStation
    cellar
  well
  lumbermill
  windmill
  marketplace

animals
  chickens
  cows
  sheep
  bees
    hiveSize
    pollinationState

machines
  mill
  loom
  press
  metalworking
  kitchenAppliances
  aging

progression
  unlockedCrops
  unlockedRecipes
  unlockedMachines
  unlockedMerchants
  unlockedTools
  petGoals
  npcHints
    hintsGiven
    failedDeliveries

quiz
  questionsAnswered
  timeQuestionHistory
  trainingQuestionHistory
  spacedRepetitionData

rewards
  chestHistory
  pixieEventHistory
  unlockedVariants
  cosmetics
```

This schema should be locked before the game grows much further — migrating a deeply nested `localStorage` structure gets harder with every iteration.

---

## 21. Project Status at a Glance

| Area | Current state | Direction |
|---|---|---|
| Single-screen farm | Implemented | Keep and polish |
| Mobile-oriented layout | Implemented; one-screen fit fixed in 1.1 | Validate on real devices |
| 3×4 field grid | Implemented | Keep |
| Animal row + wandering | Implemented and tested | Keep lightweight; art later |
| Building slots | Implemented | Populate progressively |
| Coins / Water / Energy | Implemented | Deepen economy & interaction |
| Time Quiz | Implemented as separate engine | Expand content; add spaced repetition |
| Training Quiz | Implemented, no safety net (Decision) | Merge into Energy indicator |
| Wheat/carrot/tomato | Implemented | Expand to full canonical set incl. sunflower/pumpkin |
| Seed Merchant | Implemented (partial) | Expand full Marketplace |
| Tomato unlock | Implemented | Generalize unlock architecture |
| Pantry | Implemented | Whole-card clickability |
| Chicken/Cow/Sheep/Bee conversion | Implemented (simplified) | Full processing chains |
| Porridge | **Not implemented** | First functional-completion milestone |
| Bread | Implemented | Resequence after Porridge |
| Well upgrades | Implemented | Expand building progression |
| Workshop / Windmill / Barn | Placeholder | Build real machine + storage systems |
| Lumbermill | Not distinguished from Windmill | Proposed: own Lumber slot (§12.6) |
| Manure | **Absent** | Proposed: compost loop (§5.5, §33) |
| Tools | Conceptual | Implement tracks + mechanical effects |
| Advanced kitchen | Conceptual | Implement appliance leveling |
| Full recipe catalog & tag system | Designed as data (§33) | Implement from `farm-progression.json` |
| Barter purchasing | Dormant | Implement at Spice/Culture/Import merchants |
| Raw material tiers | Dormant | Implement dish-delivery unlocks |
| Avatar system | Dormant | Design + implement |
| NPC hints/penalty | Dormant | Design + implement |
| Bee pollination/biodiversity | Dormant, mechanism undetermined | Needs design decision + playtesting |
| Chest system | Conceptual | Implement tiers |
| Pixie mini-game | Dormant | Implement alongside chest system |
| Five pets / pet dishes | Proposed line-up (§15.1) | Confirm names, then implement |
| Final art | Not started | User-created PNG phase |

---

## 22. Immediate Pending UX Changes

The concrete near-term backlog, unchanged from the prototype's testing cycle:

1. **Seed requirement bar** — Pending.
2. **Whole-card interaction, standardized** — Partially satisfied (plots done; seed cards, pantry, conversion rows not yet).
3. **Conversion cooldown/time bar** — Pending (currently text-only: "Answer a Time Quiz first").
4. **Time Quiz clock icon** — Pending.
5. **Training merged into Energy indicator** — Pending.
6. **Whole conversion row clickable** — Pending.
7. **Whole pantry card clickable** — Pending.

---

## 23. Content Still Mostly Prototype / Placeholder

- **Farming:** full crop catalog (incl. sunflower/pumpkin), crop-specific art, multi-plant-per-plot visuals, manure-gated growth.
- **Tools:** inventory, upgrades, tier-specific effects, unlock rules.
- **Workshop:** milling, textile, pressing, metalworking, machine upgrades.
- **Animal processing:** churning, yogurt, cheese, shearing/weaving chain, honey/wax extractor chain, pollination/biodiversity mechanics.
- **Storage/Barn:** Shed/Warehouse tiers, Aging Station, Cellar, real preservation timers, the Barn's animal-upgrade linkage.
- **Kitchen:** Stove/Oven/Prep/Processor leveling, appliance-first filtering, multi-step recipes, Porridge itself.
- **Recipe system:** full template graph (Appendix C), tag-based unlocking, persistent unlock state, locked future-recipe visibility.
- **Marketplace:** all merchant categories beyond basic seeds, barter purchasing, raw material tiers, conditional unlocks.
- **Progression:** five pet goals, dish/key chain, avatar system, NPC hints.
- **Rewards:** chest tiers, pixie mini-game, rare variants, cosmetics.
- **Education:** larger Time Quiz bank, spaced repetition, two-digit arithmetic, topic progression.

---

## 24. Prototype History and Testing Lessons

Preserved as-is — this is genuinely prototype-only knowledge with no Primer equivalent to reconcile against.

- **Marketplace discovery:** introduced after testing revealed players had seeds but no coherent way to get more.
- **Animal-row relocation:** animals moved up, buildings moved down, giving hierarchy *resources → animals → crops → buildings* and more visual weight to the crop field.
- **Field expansion:** moved from the original 9-plot concept to the 12-patch grid with 3 reserved slots.
- **Plant visuals:** refined toward sprout-in-early-growth → crop icon as it develops → centered, scaled (not clipped).
- **Pantry bugs:** found cases where outputs didn't appear or lacked the expected sell/save flow — led to the rule that *every* production output needs a predictable immediate decision point.
- **Tomato unlock:** successfully tested a resource-based unlock that persists after the unlock event.
- **Requirement bars:** repeatedly proved out as the right pattern over text-only prerequisites.
- **Separate quiz engine:** split out so quiz content/behavior can evolve independently of the farm UI.
- **Training timeout:** 3-second window, timeout treated exactly like a wrong answer.
- **Animal wandering:** small random movement added after static emoji felt lifeless — tested and reported as working well. Lesson: *small amounts of ambient animation add life without needing a complex simulation.*

---

## 25. Testing the Feel (qualitative) and Telemetry (quantitative)

These are complementary, not overlapping — keep both.

**Feel questions the current prototype can already answer** (from playtesting, qualitative):
- Does quiz-driven time feel understandable? Is water easy to read?
- Does spending water create meaningful tension? Is energy scarce enough to make Training relevant?
- Does sell-vs-save create meaningful decisions? Does animal conversion feel satisfying?
- Is the single-screen composition readable on mobile? Are zones visually distinct?
- Do modals feel faster than separate pages? Do requirement bars communicate enough without text overload?

**Telemetry targets** *(reinstated from Primer)*, for once real instrumentation exists:
- Recipe attempts and failed combos.
- Time-to-first-unlock.
- Average water/energy spent per unlock.
- Iterate balance based on actual data rather than intuition alone.

---

## 26. Design Vocabulary

| Term | Meaning |
|---|---|
| **Time Quiz** | Knowledge quiz that advances farm time. Never awards energy. |
| **Rest** *(formerly Training Quiz)* | Quick-recall mini-game that restores energy. No safety net on failure. |
| **Question step** | One successful Time Quiz advancement unit. |
| **Well** | Passive water-producing building tied to question progression. |
| **Pantry** | Inventory/saved-output view. |
| **Storage** | General inventory-capacity building track (None → Shed → Warehouse). |
| **Barn** | Separate building; houses the Aging Station/Cellar and links to some animal-related upgrades. |
| **Marketplace** | Seed/merchant purchasing interface; unlocks via dishes, not a normal upgradeable building. |
| **Recipe Book** | Farmhouse-accessed recipe interface. |
| **Animal Area** | A field/slot containing chickens, cows, sheep, or bees. |
| **Conversion** | Turning inputs into an animal/product output. |
| **Requirement bar** | Color-coded visual progress indicator for an input requirement. |
| **Ingredient-threshold unlock** | Unlock triggered by holding enough of a specific item (e.g., 2 eggs → tomato). |
| **Dish-delivery unlock** | Unlock triggered by delivering a specific finished dish to a merchant/NPC; consumed on use; paired with partial hints. |
| **Barter** | A purchase requiring crop/ingredient + coins, not coins alone (used by several later merchants). |
| **Manure** | Resource required to initiate mid/late-stage crop growth. |
| **Locked** | Content not currently available but intentionally visible when relevant. |
| **Special patch** | Reserved central plot for future infrastructure/content. |
| **Pet dish** | A high-level food objective tied to bringing back one of the secret pets. |
| **Pixie event** | The tap-to-collect mini-game gating whether a triggered chest actually pays out. |

---

## 27. Roadmap

An inferred project plan following naturally from the merged design decisions — not a claim that every sequencing choice has been formally locked.

### Phase A — Immediate prototype UX stabilization
Add seed requirement bar; standardize full-card click targets; add conversion cooldown bars; clock icon for Time Quiz; merge Training into Energy; whole conversion rows clickable; whole pantry cards clickable; verify no regressions.
**Goal:** make the existing vertical slice coherent before adding content.

### Phase B — Responsive/layout hardening
Validate iPhone 6 and iPad viewports; remove fixed-width assumptions; revisit `max-width: 480px`; finalize aspect-ratio rules; confirm no unexpected PNG cropping.
**Goal:** lock the farm composition before final art.

### Phase C — Data-driven systems refactor
Expand config into clean item/crop/animal/recipe data models; formalize the tag system (§9.8) and unlock conditions; formalize building/tool schemas; formalize save-state migrations (§20.2).
**Goal:** make content expansion cheap and safe. Start from `progression/farm-progression.json` (§33); decide the engine (§34) before this phase.

### Phase D — Core production expansion
Full crop catalog (incl. sunflower/pumpkin); Porridge implemented as the true starter, Bread resequenced after it; proper animal production chains; Workshop machines (Mill, Loom, Press, Metalworking); kitchen appliance leveling and the full recipe catalog (Appendix C); Barn build-out (Aging Station, Cellar).
**Goal:** turn the vertical slice into the intended production sandbox.

### Phase E — Progression and economy
Full Marketplace merchant system, including barter purchasing and raw-material tier unlocks; tool progression and mechanical effects; building upgrades; pricing-multiplier calibration (§9.9); Greenhouse; Scarecrow effect; Lumbermill (split from Windmill); bee pollination/biodiversity system, once its core mechanism question (§8.4, §31) is resolved.
**Goal:** create mid-game strategic depth.

### Phase F — Pet and end-goal layer
Define the five pets and their dishes; connect recipe/ingredient chains to pet objectives; implement the avatar system and pet-following behavior (§15.2); implement NPC hints and delivery-failure penalties (§15.3); add reveal and completion/reunion states.
**Goal:** give the production system its narrative purpose.

### Phase G — Quiz/education expansion
Larger Time Quiz bank with metadata, topic coverage, difficulty progression; spaced-repetition (Anki-style) scheduling for Training; two-digit arithmetic; more varied quick-recall question types.
**Goal:** make the educational layer as deliberately designed as the farm layer.

### Phase H — Reward and polish systems
Full chest-tier system plus the pixie collection mini-game (§16); rare cosmetic variants; avatar accessories/clothing; final UI animation pass; accessibility review (colorblind-safe requirement bars, §5.6); final balancing.
**Goal:** turn the prototype into a complete product candidate.

---

## 28. Risks to Watch

1. **Too much content too early** — could bury the core loop. *Countermeasure:* re-validate the minute-to-minute loop after every systems expansion.
2. **Resource complexity becoming opaque** — water, energy, coins, seeds, manure, tools, animals, cooldowns. *Countermeasure:* show only immediate requirements during routine actions; expose deeper dependencies only at unlock/build moments.
3. **Quiz fatigue** — too many repetitive questions just to wait for crops. *Countermeasure:* variety, pacing, spaced repetition, question relevance.
4. **Economy too generous** — if everything is instantly buyable, opportunity cost disappears. *Countermeasure:* balance water/energy/seed supply/throughput deliberately.
5. **Production chains as a checklist** — impressive on paper, tedious in play. *Countermeasure:* contextual discovery; migrate production to logical stations only when meaningful.
6. **UI becoming button-heavy** — the natural tendency is small Convert/Buy/Sell buttons inside cards. *Countermeasure:* keep pushing toward whole-area interaction (§22).
7. **Art integration breaking composition** — placeholders can hide cropping/ratio problems. *Countermeasure:* lock the layout contract before the final asset pass.
8. **Reinstated scope re-inflates the backlog.** This merge deliberately brought back a large amount of Dormant Primer content (avatar, NPC hints, bee biodiversity, pixie mini-game, full recipe catalog, barter, manure, raw material tiers) that had quietly dropped out of the working conversation. Restoring it to the *document* is not the same as scheduling it for the *game* — this is the same trap as Risk 1, aimed specifically at this merge. *Countermeasure:* the roadmap phases (§27) and the Idea Backlog (§32) exist precisely to keep "documented" and "scheduled" visibly separate; Phase A/B discipline still applies before any Dormant content gets touched.

---

## 29. Definition of "Done"

**Functional completion** — a player can, without developer intervention, starting from the devastated farm:
1. Answer Time Quiz questions.
2. Cook and sell Porridge, then grow into Bread and beyond. *(Updated to reflect the corrected recipe sequence.)*
3. Grow and harvest crops; manage water and energy; train to restore energy.
4. Buy and use animals; produce intermediate goods.
5. Use Workshop/Kitchen/Barn/Storage systems; build multi-step recipes.
6. Sell or save outputs; unlock new content via both unlock mechanisms (§13).
7. Discover pet-related goals; craft all required pet dishes; bring all five pets home.

**Educational completion** — consistently reinforces planning, opportunity cost, water sustainability, and arithmetic/recall, integrated with actual game decisions.

**UX completion** — the player understands the next action primarily from icons, numbers, requirement bars, color/state, locks, and object location.

**Technical completion** — content expansion happens by editing data, not rebuilding the engine.

---

## 30. Decisions Log

Explicit record of every conflict between the two sources and how it was resolved, for future reference.

| # | Conflict | Primer said | Briefing/prototype said | Resolution |
|---|---|---|---|---|
| 1 | Training on wrong/timeout | +1 energy (safety net) | 0 energy | **0 energy — safety net removed.** *(Direct override, not a Primer-priority case.)* |
| 2 | Training on correct answer | +5 in one place, +3 in another (internal inconsistency) | +5, capped at max | **+5**, resolving the Primer's own internal contradiction using its majority value, which also matches the implemented behavior. |
| 3 | First cookable recipe | Porridge, at the Tent, via Fire + Tin Pot | Bread, via Farmhouse/Recipe Book | **Porridge first, Bread second.** Porridge precedes the Farmhouse entirely; Bread becomes available once Farmhouse/Oven exist. |
| 4 | Starting wheat seeds | 10 | 5 | **5** — prototype value adopted as the new baseline. |
| 5 | Sunflower / Pumpkin | Named as example future unlocks, not in the canonical list | Not mentioned | **Folded into the canonical crop catalog** (§6.4). |
| 6 | Barn vs. Storage | Barn was a tier *within* Storage's progression | Barn appears as its own separate building slot in the UI | **Separate buildings.** Storage keeps a plain capacity track (None → Shed → Warehouse); Barn is distinct and links to storage upgrades, the Aging Station, and some animal-related upgrades (exact linkage still open, §31). |

**Clarifications (not true conflicts, but worth recording):**
- **Starting coins:** Primer's 0 is the intended final-economy target (prioritized); the prototype's 200 is an explicitly self-flagged testing convenience, not a competing design decision. Both are kept, clearly labeled by purpose.
- **Plants-per-plot vs. growth-stage visuals:** not actually in conflict — growth stages describe a single plant instance; plants-per-plot governs how many instances tile within a patch. Reconciled as complementary in §6.3.
- **"Replacement consumes prior tool"** (Primer) vs. **"replaces as active tool"** (Briefing, softer phrasing): Primer's literal reading — the old tier is a build input to the new one — is prioritized (§2, §11).

---

**Proposed in 1.1 (each needs your yes or no):**

| # | Topic | Before | Proposed |
|---|---|---|---|
| 7 | Manure | Required for mid/late crops; source undecided | Compost loop: hungry crops need compost; straw and weeds work, manure is faster (§5.5) |
| 8 | Bees | Eat wheat (prototype); sugar-feeding idea | Need flowering crops; no feeding; comb → honey + wax (§8.4) |
| 9 | Sugar | Beet vs "Sugar Carrot" | Beet only |
| 10 | Lumbermill vs Windmill | One placeholder slot | "Extra" slot → Lumber; Windmill = flour, later a wind pump (§12.6) |
| 11 | Barn's animal linkage | Open | Barn tiers = cow/sheep capacity, cellar, stable (§12.4) |
| 12 | Watering track | Plants per patch | Water efficiency 100/75/50% (§11) |
| 13 | Import Broker | After 3 pets | After 4 pets, opening chapter 5 (§13) |
| 14 | Silk | Final pet needs textiles/silk | Linen + plant-dyed wool → Rainbow Quilt (§15.1) |
| 15 | Bread | Farmhouse + oven | Cottage + oven + sourdough starter (kept); flatbread in chapter 1 (§9.2) |
| 16 | Big buildings | Bought in one go | Built in 2–3 visible stages (§33.1) |
| 17 | Pets | Unnamed | Bunny, Tortoise, Goat, Pony, fifth to decide (§15.1) |
| 18 | Storage | Capacity track, no numbers | Per-item caps 10 / 25 / 60 |

---

**1.2 and 1.3:** the decisions taken since are listed in §36.1 and §37.1.

## 31. Open Questions and Unsolved Problems

> Several questions below were settled in 1.2 and 1.3. See §36.1 and §37.1 (for example: pets and the alpaca, the quiz bank, Training → Rest, layout bonuses: no, quality stars: no).

Merged from both sources' "still open" lists, organized by topic.

**Recipe catalog & tags**
- Finalize the tag taxonomy; confirm the four-tag-set reconstruction in §9.8.
- Confirm the initial 25–35 recipe templates (Appendix C) and their prerequisite levels; expand only if playtesting shows real gaps.

**Economy & pricing**
- Calibrate the base values and the first-pass multipliers in §9.9 through actual play.
- Decide rare-variant reward structure: cosmetic only, small value boost, or tied to a specific unlock requirement.

**Progression gates & Marketplace**
- Map the remaining unlock-dish → merchant-tier/material assignments beyond the worked examples already given (§13).
- Choose which specific recipe variants unlock each merchant tier; decide how NPCs signal partial hints (§15.3).

**Water/energy/time balance**
- Assign baseline water costs per plant type and per animal conversion; formalize a cost table.
- Set aging/fermentation durations by category (yogurt short, vinegar long, cheese medium-long), aligned to quiz rhythm.

**Crop list**
- Both Olive and Sunflower/Pumpkin are now canonical (§6.4) — no remaining either/or here.
- Select which crops are Greenhouse-exclusive for mid/late game.

**Bees / biodiversity** *(genuinely unresolved in the source, not just under-specified)*
- The exact mechanism by which hive size benefits crop growth (shorter grow time vs. lower water need) is undetermined and needs playtesting.
- The "Sugar Carrot" vs. Beet-based sugar inconsistency (§8.4) needs a designer decision before the bee-feeding chain can be built.
- The "multipurpose tool" needed to turn reduced sugar syrup into a usable form is explicitly unsolved in the source — ideally something already planned for another purpose, not a single-use addition.

**UX & discoverability**
- "Experiment" tab unlock timing and guardrails (clear feedback on failed combos).
- Colorblind-accessible requirement bars need a concrete icon-pairing scheme, not just the stated principle (§5.6).

**Data & content architecture**
- Full template schema fields: tag slots, required appliance, minimum tool/appliance levels, optional modifiers, output naming, sell-value formula hooks, cooldowns, energy/water costs.
- Migration signposting consistency (flour → Mill, weaving → Textile Machine, and any future migrations).
- Auto-generated recipe names (e.g., "Tomato-Onion Soup," "Honey Cake") need a localization-friendly naming approach.

**Testing & iteration**
- Validate via paper prototype / spreadsheet sim that the early game supports 6–8 recipes without overwhelming the player.
- Track the telemetry targets in §25 once instrumentation exists.

**New in 1.1**
- Engine: stay HTML5 or move to Godot before Phase C (§34)?
- The fifth pet, pet names, and whether pets give small bonuses at all.
- Is ≈2,300 Training answers per playthrough (about one every 40 seconds of play) the right amount of arithmetic? If not: more energy per Training answer as the home improves, or cheaper actions.
- Per-item storage caps (10 / 25 / 60): wanted, or unlimited storage?
- Spoilage: nothing ever goes bad right now. Keep it that way for an 8-year-old?
- The bee, manure and sugar questions above have proposed answers in §5.5 and §8.4.

**Newly surfaced by this merge**
- Barn's exact animal-related-upgrade linkage (§12.4) — named as a category, not yet specified.
- Which of the five pet dishes anchors which progression tier.
- Exact vinegar chain durations, and whether a fallback (purchasable) vinegar option should exist.
- How many salad/sandwich templates are needed to keep the Prep Station meaningful without bloating it.

---

## 32. Idea Backlog — Dormant / Speculative Concepts Not Yet Scheduled

A single scanable index of everything reinstated in this merge that doesn't yet have a confirmed roadmap slot. Full detail lives at the cross-referenced section; this list exists so nothing here quietly falls out of view again.

- **Avatar system & pet-following** → §15.2
- **NPC hints & delivery-failure penalty** → §15.3
- **Bee pollination / biodiversity mechanics** → §8.4
- **Pixie chest mini-game** → §16
- **Manure as a growth-gating resource** → §5.5
- **Barter purchasing at Spice/Culture/Import merchants** → §13
- **Raw material quality tiers via dish delivery** → §13
- **Scarecrow's specific energy-reduction effect** → §12.9
- **Tool-tier mechanical effects** (plants-per-plot, prep complexity, etc.) → §11
- **Avatar accessories & craftable clothing** → §13, §15.2
- **Full recipe template catalog & appliance-tag table** → Appendix C, §9.5
- **Telemetry instrumentation** → §25

---

## 33. Production & Unlock Tree *(Proposed, v0.1)*

The complete map of what enables what. It is encoded as data in `progression/farm-progression.json` (one line per item, unlockable and recipe) and can be browsed and checked in `progression/progression-explorer.html`: open it in a browser, click anything to see what it needs and what it unlocks, and drop an edited JSON onto the page to re-run the checks. Every number is a first pass meant to be tuned in playtests.

**At a glance:** 5 chapters · 154 unlockables (121 goals the player works toward, 33 that open by themselves, such as new seed tiers) · 132 items · 94 recipes · ≈25.5 hours · ≈1,350 Time Quiz answers · ≈2,300 Training answers.

### 33.1 Design rules ("always a bit out of reach")

1. **Two horizons at once.** There is always a near goal (within ≈10 questions in chapter 1, ≈20–30 later) and a far goal (the chapter's big build or pet). The explorer's *Always a bit out of reach* chart checks this for the whole playthrough.
2. **Width matched to the player.** 2–6 open goals in chapter 1, so an 8-year-old can play alone; up to ≈10 later, when families play together.
3. **By hand first, automatic later.** Every chain starts as manual work (hand quern, spindle, hand loom, compost bin, crushing honeycomb) and is later handed to something that works by itself every question (windmill, spinning wheel, textile loom, woodlot and lumbermill, honey extractor, wind pump). The "migration" rule in §2 becomes the reward: less tapping, more output.
4. **Upgrades replace** (unchanged from §2). The old tier is consumed; anything that needed it stays satisfied.
5. **Big builds go up in stages.** Cottage (walls → thatched roof → hearth), Barn (frame → roof), Smithy (chimney → workshop), Windmill (stone tower → sails), Farmhouse (foundation → brick walls → windows), Greenhouse (frame → glass). Each stage is a visible win, and the building slot can show the construction.
6. **Dishes are the research.** Deliveries to the village open the next merchant tier (seeds, salt, clay, iron ore, hardwood and sand, guild steel). Dish-delivery and ingredient-threshold unlocks stay distinct (§13); tomato keeps its 2-egg unlock from the prototype.
7. **Keepers.** Some things are needed but not used up: Tin Pot, Sourdough Starter, yogurt and cheese cultures, and the stone in Stone Soup. ("A culture lives on" is a real idea worth teaching.)
8. **The bottleneck moves.** Each upgrade relieves one limit and exposes the next: the Iron Shovel doubles plants per patch, then water runs short, then the Watering Can and Well 4 matter. The explorer names the bottleneck behind every goal.
9. **Processing always pays.** Outputs are worth at least 5% more than inputs, animal products at least 10% more than their feed (the prototype's chicken breaks this, §8.1).

### 33.2 The five chapters

| Chapter | Home | Material age | What opens up | Pet | Simulated time (goals) |
|---|---|---|---|---|---|
| 1 Ashes | Tent | sticks, stones, fiber | campfire and porridge, clearing patches, stone tools, quern and flatbread, chickens, well upgrades | Bunny | 0 → 0.9 h (18) |
| 2 Homestead | Cottage | logs, split planks, clay, bricks | shed, compost and tomatoes, bees, woodlot, carpenter and kiln, staged cottage, stove/oven/prep table, pond, market stall, barn and cows, butter, orchard | Tortoise | 0.9 → 5.8 h (31) |
| 3 Smallholding | Cottage | iron, nails | smithy, forge and anvil, iron tools (2 plants per patch), sawbench, sheep and wool cloth, linen from flax, press (oil, juice, sugar), windmill, fermenting and cellar (yogurt, cheese, cider, vinegar, pickles), lumbermill | Goat | 5.8 → 11.7 h (32) |
| 4 Village Trade | Farmhouse | steel, glass, hardwood | blast forge and steel tools (3 plants per patch), drip line, staged farmhouse, greenhouse, brickworks, warehouse, master workshop and textile loom, walnuts and olives, pizza | Pony | 11.7 → 18.2 h (25) |
| 5 Master Farm | Farmhouse | heirlooms, dyes | Import Broker barter, saffron and heirloom crops, dye vat and colour mixing, Harvest Fair ribbons, master oven and stove, fine flour, wind pump | Fifth friend | 18.2 → 25.5 h (15) |

```mermaid
flowchart LR
  A[Campfire + Porridge] --> B[Workbench + stone tools]
  B --> C[Clear patches · Quern · Chickens]
  C --> P1((Bunny))
  C --> D[Log Shed]
  D --> E[Carpenter's Shed · Kiln]
  E --> F[Cottage: walls, roof, hearth]
  F --> G[Stove · Oven · Barn · Cows]
  G --> P2((Tortoise))
  G --> H[Hearty Stew: iron ore]
  H --> I[Smithy · Forge · Anvil]
  I --> J[Iron tools · Sawbench · Sheep · Press]
  J --> K[Windmill · Cellar · Cheese]
  K --> P3((Goat))
  K --> L[Honey Oat Cake: hardwood and sand]
  L --> M[Blast Forge · Glass Kiln]
  M --> N[Farmhouse · Greenhouse · Textile Loom · Stable]
  N --> P4((Pony))
  P4 --> O[Import Broker: saffron, heirlooms, woad]
  O --> Q[Dye Vat · Master Oven · Fine flour]
  Q --> P5((Fifth friend))
```

### 33.3 Chapter ladders (in the order the simulated player reaches them)

**Chapter 1 — Ashes (Tent).** Build the Campfire from the sticks and stones you start with, plant the 5 wheat seeds, answer two questions, cook Porridge (2 wheat + 1 water; the Tin Pot is kept). Deliver 2 porridge to the travelling merchant: clover and onion seeds and a timber-and-stone stall appear. Pull the weeds by hand (+2 patches, fiber, sticks, stones) → Workbench → Stone Knife, Hand Axe, Wooden Shovel → clear the rocks and stumps (+4 patches, stones, logs) → Chopping Block and Hand Quern (flour → flatbread). Deeper well, Stick Scarecrow, 3 vegetable soups for the village (→ potato, lettuce, beans, beet seeds and salt). Chicken Coop and chickens, well winch. **Bunny:** Carrot-Clover Bowl + Straw Hutch.

**Chapter 2 — Homestead (Cottage).** Compost Bin, tomatoes (2 eggs once, then compost), Stone Soup for the quarry folk (→ clay), Bee Yard and straw skeps. The **Log Shed** raises storage from 10 to 25 of each item, which the big builds need. Woodlot, Carpenter's Shed and Bench (split planks), Kiln (bricks, jars, charcoal), Compost Heap, Wheelbarrow. The Cottage in three stages, then Prep Table, Stove and Oven; dig the Pond (water, clay, a place to soak flax). Hearty Stew for the miners (→ iron ore for sale), sourdough for the Culture Specialist, pancakes for the seed shop (→ sunflower, flax, oats, apple saplings). Market Stall (+10% when selling), Bigger Coop, Wooden Hives, Barn, Butter Churn, Cows, the old orchard. **Tortoise:** Tortoise Garden Platter + Warm Shell House.

**Chapter 3 — Smallholding (iron).** Hand spindle and hand loom start the linen chain from flax. Smithy (chimney, then workshop) → Forge → Anvil → Iron Hammer, Knife, Shovel (2 plants per patch) and Saw → Sawbench (1 log → 4 planks). Rain Barrel, Sheep Pen, Shears and sheep, Honey Extractor, Windmill tower, Wooden Press (sunflower oil, apple juice, beet juice), iron-top Stove (sugar, sauces, jam) and iron-door Oven (cakes). Honey Oat Cake for the forester (→ hardwood and sand), a cake for the seed merchant's birthday (→ pumpkin, berries, herbs, walnut and olive saplings). Well 4, Watering Can, Dressed Scarecrow, Windmill sails (flour by itself), Lumbermill, Barn cellar with Cellar Racks, Cheese Vat. **Goat:** Apple Oat Crumble + Goat Shed.

**Chapter 4 — Village Trade (steel and glass).** Guardian Scarecrow, pizza night for the builders (→ guild steel and glass as an expensive shortcut), Glass Kiln, Blast Forge → steel → Smith's Hammer, Steel Knife, Steel Shovel (3 plants per patch), Master Saw, Drip Line (half the water), Spinning Wheel. The Farmhouse in three stages (energy 50), marble Prep Table, kitchen Grinding Mill (the quern becomes a nut and olive grinder once the windmill makes flour), Brickworks, Warehouse (60 of each item), hardwood grove, Greenhouse, hand-pump well, Master Workshop and Textile Loom, Barn stable. **Pony:** Apple-Carrot Cake + Saddle Blanket.

**Chapter 5 — Master Farm.** The Import Broker barters rare seeds for fine goods: saffron corms, rainbow carrots, golden beets, woad. Dye Vat: red from beets, yellow from onion skins, blue from woad, then mix orange, green and purple into Rainbow Yarn. Four Harvest Fair ribbons (pies; preserves; cheese; weaving), each +5% when selling. Bee Garden, orchard terraces, Seed Library (save heirloom seeds from your own harvest), Cheese Cave, Master Stove, stone-grinder Windmill (fine flour), greenhouse extension, Master Oven. **Fifth friend:** Golden Honey Cake (fine flour, honey, butter, eggs, saffron, walnuts) + Rainbow Roast (rainbow carrots, golden beets, onions, olive oil, herbs) + Rainbow Quilt. After that, the Wind Pump is left as a last project.

### 33.4 The long chains (where the Factorio feeling comes from)

- **Grain:** wheat → hand quern, later the windmill → flour → bread (oven, starter kept) → sandwich, cheese board. Wheat also gives **straw** → rope, thatch, skeps, scarecrow, compost.
- **Dairy:** clover → cow → milk (+ manure → compost → tomatoes) → churn → butter; milk + culture → yogurt; milk + culture + salt → fresh cheese → 8 questions in the cellar → aged cheese → pesto, cheese board, saffron barter.
- **Sugar:** beets → press → beet juice → iron-top stove → sugar → cakes, jam, pies.
- **Fermentation:** apples → press → juice → crocks (4 questions) → cider → cellar (6 questions) → vinegar → pickles (+ salt + clay jar).
- **Textiles:** sheep → wool → spindle → yarn → loom → wool cloth → windmill sails, scarecrow, saddle blanket, quilt. Flax → soak in the pond → flax fiber → spindle → linen thread → loom → linen cloth.
- **Metal:** logs → kiln → charcoal; iron ore (bought) + charcoal → forge → iron bar → anvil → nails and iron tools; iron + more charcoal → blast forge → steel.
- **Glass:** sand + charcoal → glass kiln → glass → farmhouse windows, greenhouse, bee garden.
- **Colour:** beets, onions, woad → red, yellow, blue → orange, green, purple → rainbow yarn → rainbow quilt.
- **Compost loop:** straw, weeds, manure, oilcake → compost bin → compost → hungry crops.

The deepest single item is the Rainbow Quilt (about eight steps from the field); the Golden Honey Cake draws on seven different buildings.

### 33.5 Where realism was bent on purpose

- **Cows** cost 150 coins each and give one milk every 2 questions. Real cows cost far more and eat far more; here they stay affordable but are clearly the thirstiest product (3 clover + 3 water per milk, and each clover patch needs water too).
- **Iron ore is bought, not mined.** A mine would need its own screen; feeding the miners a hearty stew is the unlock instead.
- **Planks before saws:** logs are split with the axe (riven boards are real), then the saw quadruples the yield.
- **Bees** are never fed; they only need flowers somewhere on the farm.
- **No seasons:** every crop grows any time. Orchard trees take long to mature and then give a harvest every few questions.
- **Pets:** a unicorn as the fifth friend is fantasy; an alpaca is the grounded alternative.

### 33.6 What the tree adds to the learning goals (§1.2)

- **Water footprint:** one fresh cheese is 4 milk, which is 12 clover plus 12 water at the cow, plus the water for the clover patches. The pantry can show this chain.
- **Using less instead of getting more:** the Watering Can and Drip Line cut water use by 25% and 50%; rain barrel and pond show other sources.
- **Circular farming:** straw, weeds, manure and pressed seed cake become compost for the hungry crops.
- **Seed saving:** the Seed Library lets heirloom crops give their own seeds back.
- **Rarity:** a saffron flower gives one small harvest after 8 questions in the greenhouse, which is why it is precious.
- **Colour mixing:** three plant dyes make the other three.
- **Opportunity cost everywhere:** eggs can be sold, cooked, fed into the tomato unlock or saved for cakes.

### 33.7 How to change it

1. Edit `progression/farm-progression.json`. Each item, unlockable and recipe sits on one line; `meta.rules` at the top explains the fields (`requires`, `cost`, `replaces`, `keeps`, `tag:` inputs, `slots`, `plantsPerPlot`).
2. Open `progression/progression-explorer.html` and drop the edited file onto it. **Checks** lists broken references, unreachable goals, storage that is too small, and recipes that lose value. **Pacing** shows when each pet arrives against its target and where the playthrough gets too narrow, too crowded, or has no quick win.
3. The pacing check rests on guesses: 25 seconds per Time Quiz question, 4 seconds per action, 5 energy per Training answer, a player who uses 60% of their capacity. Replace them with numbers from playtests in the Pacing tab; the hours move accordingly.
4. Costs in chapters 2–5 were scaled so the pets land near 1, 6, 12, 18.5 and 26 hours. If a chapter gets much more content, lower its costs.

### 33.8 How it maps onto the one-screen farm

- **8 building slots:** Market · Living quarters (Tent → Cottage → Farmhouse; the kitchen lives inside) · Workshop (Workbench → Carpenter's Shed → Smithy → Master Workshop; its machines live inside) · Storage (Basket → Shed → Warehouse) · Well · Windmill (+ wind pump) · Barn (cows, cellar, fermenting, stable) · Lumber (Woodlot → Lumbermill; the former "Extra" slot).
- **3 special patches:** Orchard, Pond, Greenhouse.
- **4 animal areas:** chickens, cows (with churn and cheese vat), sheep (with spindle), bee yard (with extractor).
- **Field edge:** compost bin and scarecrow.

---

## 34. Engine & Asset Pipeline *(Recommendation — needs your decision)*

> **Update (1.3):** the switch has started. A playable **Godot 4.7** prototype lives in `godot-prototype/` (§37.16). It reads the same `farm-progression.json`, uses emojis for missing art and runs the full rule set. The HTML prototype stays as the reference for the original UX.

A friend suggested moving from HTML5 to Godot. For this game specifically:

| | Stay with HTML5 (current) | Move to Godot 4 |
|---|---|---|
| Menus, cards, modals, requirement bars | Very strong; HTML/CSS is made for this | Good (Control nodes, themes), more setup |
| Animated world: wandering animals, avatar walking, pets following, pixie mini-game | Possible with the DOM or a canvas, gets messy as it grows | Strong: scenes, AnimationPlayer, tweens, particles |
| iPhone-to-iPad scaling (the Phase B work) | Hand-written CSS (now fixed for the current layout) | Built-in stretch modes and anchors |
| Getting it onto an iPad | Browser, or "Add to Home Screen" as a web app; works offline | Native app via Xcode on a Mac (free provisioning for your own devices; the App Store needs the paid developer program). Web export is heavy (tens of MB) |
| Working with AI help | Excellent: every file is plain text | Good for GDScript; scenes are best built in the editor |
| Data | JSON (via a small local server) or a JS file | JSON natively: `JSON.parse_string(FileAccess.get_file_as_string("res://data/farm-progression.json"))` |
| Cost of switching | — | Low now: the prototype is ≈1,000 lines and Phase C would rewrite most of it anyway |

**Recommendation:** decide before Phase C. If the avatar, pets following, the pixie mini-game and an animated farm stay in the plan (§15–§16), Godot pays off, and the switch is cheapest now, before the systems in §33 get built. Until then, keep everything engine-independent:
- game content as data (`farm-progression.json` loads unchanged in both);
- quiz banks as JSON or CSV (Godot also reads CSV translation tables, useful if a German version comes later);
- art as plain PNG files named after the data ids.

**Asset pipeline (works for either engine)**
1. **Pick one art style before producing more.** The folder mixes painted AI tiles (512 px, OpenArt) with pixel art (Pixelwood Valley, 16–70 px). Mixed styles read as two different games.
2. **Name files after data ids** so the game finds art automatically: `assets/items/<item_id>.png`, `assets/nodes/<node_id>.png` (with `_stage1`, `_stage2` for staged builds), `assets/crops/<crop_id>_stage0…3.png`, `assets/animals/<animal_id>.png`. Missing art falls back to the emoji in the JSON, the same way the prototype now shows a label for missing building art.
3. **Fixed sizes per kind:** item icons one square size (128×128 painted, or 32×32 pixel art shown at ×4), building slots 384×256 as now, field tiles 512×512, transparent PNG for anything that sits on terrain.
4. **Pixel art:** in Godot set the default texture filter to Nearest and keep sizes multiples of 16; in HTML use `image-rendering: pixelated`.
5. **Volume:** the full tree needs roughly 250 pictures (132 item icons, the buildings and their stages, crop growth stages). Produce them chapter by chapter, chapter 1 first, and keep the prompts or source files so the set stays consistent.
6. **Licences:** check the Pixelwood Valley free licence before shipping anything. Some files in the free pack carry a "PREMIUM" watermark (for example `Houses/Tents/1.png`) and cannot be used as they are.

---

## 35. Review Notes *(1.1)*

### Fixed in the prototype during this pass

1. **The farm didn't fit one screen.** Image sizes set the row heights, so on an iPhone 6 the two building rows sat below the fold and the top bar ran off the right edge (the page scrolled sideways). Now the layout is the viewport height, images never push it taller, and the column scales up on iPad. Checked from 320×568 to 1024×1366 and in landscape.
2. **Nine placeholder images don't exist** (cow, sheep, beehive, market, workshop, well, windmill, barn, extra), so broken-image icons showed. A missing image now shows an emoji and the slot's name instead.
3. **Cooking could delete the dish.** Ingredients were used before the Sell/Save choice, and Cancel or Close threw the dish away. The dish now goes to the pantry first; closing keeps it.
4. **Training's 3-second timer outlived its window.** Closing Training with the bottom button left the timer running, and its "Too late" result replaced whatever window opened next. The Close button on the Training result screen did nothing. Both fixed.
5. **The pantry's "Sell (+3 each)" sold the whole stack.** The button now says "Sell all (+total)".
6. **Older saves crashed** when tapping the three newer patches or upgrading the well. Loading now fills in missing patches and fields.
7. **Animals jumped back to their start spot** after every action; they now keep wandering from where they are.
8. **Time Quiz:** the disabled "Next question" button looked active, and the same question could come twice in a row. Both fixed.

The previous versions of these files are in `archive/farm-game.zip`.

### Found but not changed (needs a decision)

1. The Time Quiz rewards guessing (§4.1), and its bank has 4 questions for ≈1,350 answers.
2. The prototype's chicken loses money and the cow only breaks even (§8.1). The tree fixes the numbers; the prototype config was left alone in this bug-fix-only pass.
3. The prototype's Bread is 3 raw wheat at the Farmhouse (§9.2).
4. Native `alert()` and `confirm()` pop-ups (38 places) stop the game and look out of place on an iPad. Replace them with in-game messages when the modals are reworked.
5. The market sells one at a time and the pantry sells everything at once. Pick one model; tapping the whole card to sell one (§22) fits children best.
6. The four animal areas are copy-pasted code with prices written into `farm-game-core.js` rather than the config. Phase C should drive animals, recipes and buildings from the progression JSON.
7. Chests at 20% with a pixie game each time (§16).
8. Training load: about one Training answer every 40 seconds of play (§31).
9. Pet bonuses in §15.1 are suggestions; earlier versions never gave pets a bonus.

---

## 36. Version 1.2 — Energy, patches, perpetual tasks, helpers, side quests, extra fields

*Merged from `archive/design-doc-v1.2-changes.md`. Where numbers differ, the 1.3 numbers in §37 win (data v0.3).*

### 36.1 Decisions now settled

Replaces the matching items under "Open questions".

| Topic | Decision |
|---|---|
| Manure | Becomes compost (Compost Bin: 1 manure + 1 straw → 3 compost in 3 questions). Compost is fertilizer (see §36.5). |
| Bees | Never fed sugar. They need flowering crops nearby (clover, sunflower, flax, berries, herbs, fruit trees) and a water dish. |
| "Extra" building slot | Becomes the **Lumbermill** (Ch3), upgraded to the **hardwood grove** in Ch4. |
| Silk | Removed. Replaced by **linen** (flax → retting at the pond → linen cloth) and **plant-dyed wool** (woad, madder, weld at the Dye Vat in Ch5). |
| Import Broker | Arrives with the **4th pet** (Pony) and opens Chapter 5. |
| Fifth pet | **Alpaca.** |
| Pet names | The player names each pet. If they skip naming, each pet has a default: **Pip** (bunny), **Mossy** (tortoise), **Bramble** (goat), **Hazel** (pony), **Alfie** (alpaca). The name is saved with the game; the data's `defaultName` field holds the default. |
| Quiz content | The game architect swaps question packs in and out. The packs cover what the child is learning in real life (continents, times tables, spelling, and so on). See §36.2. |
| Amount of Training | Kept as it is. About 1,980 Training answers in a playthrough, roughly 77 an hour. Per hour it falls from 113 in Ch1 to 58 in Ch5 as the home improves (see §36.3). The setting to tune is `energyPerTraining` on the home buildings and beds. |

---

### 36.2 Time Quiz question packs

New section. Replaces "Time Quiz has a fixed 4-question bank".

- Questions now live in **`farm-quiz-questions.js`**, next to `farm-quiz-engine.html`. Content can change without touching game code.
- A **pack** is `{ id, title, subject, questions: [...] }`. Each question has `q`, 2–4 `answers`, `correct` (position of the right answer, 0 = first), and optional `right` / `wrong` feedback.
- **`QUIZ_SETTINGS`** sets which packs are on (`activePacks`) and how wrong answers work:
  - `"retry"` — try again until right (the prototype's behaviour; guessing always gets there in the end);
  - `"reveal"` — show the right answer and move on **without** advancing farm time.
- Answers are shuffled each time a question is shown, and a question doesn't come back within `avoidRepeatWithin` questions.
- If the file is missing or broken, the engine falls back to one built-in question so the game still runs.
- Two packs ship as examples: *Farm basics* (the original 4) and *Continents* (12).
- **How many questions?** A playthrough is about **2,040 correct Time Quiz answers**. With 16 questions, each one comes up about 130 times. A live set of **40–80 questions**, swapped as the child learns (one pack per school topic or term), keeps it fresh.
- **Godot:** the same structure saved as one `.json` file per pack in a `quiz_packs/` folder, loaded with `JSON.parse_string`. The settings become an exported `Resource`.

---

### 36.3 Energy: every job costs effort, and later jobs cost more

New section. Replaces the per-action energy notes in "Core loop" and "Training".

**Rule:** anything the player *does* costs energy in proportion to how much work it is: building, crafting, smithing, baking, cooking, milking, weeding, gathering, planting, harvesting and deliveries. Every recipe and build has a **category**, and tools, home and helpers reduce the cost per category.

Categories: `field` (digging), `plant`, `harvest`, `weed`, `gather`, `wood`, `build`, `craft`, `smith`, `kiln`, `cook`, `prep`, `mill`, `process`, `textile`, `animal`, `errand`.

**How big jobs get.** Build energy = number of material units × a chapter factor (0.5 / 0.6 / 0.75 / 0.9 / 1.0), +20% for tools. It is capped at 20 / 30 / 30 / 40 / 50 so one job always fits the energy bar of the home the player has by then. Examples from the data:

| | Ch1 | Ch2 | Ch3 | Ch4 | Ch5 |
|---|---|---|---|---|---|
| Building | Workbench ⚡3 · Well winch ⚡7 | Kiln ⚡13 · Barn ⚡18 | Forge ⚡17 · Barn cellar ⚡30 | Warehouse ⚡40 · Barn stable ⚡40 | Master Oven ⚡28 · Sun room ⚡34 |
| Baking / cooking | Porridge ⚡2 | Bread ⚡2 · Pancakes ⚡4 | Simple cake ⚡6 · Honey oat cake ⚡7 | Apple-carrot cake ⚡11 | Golden honey cake ⚡12 |
| Materials | Rope, ash ⚡2 | Bricks ⚡3 | Iron bar ⚡4 | Steel bar ⚡5 · Glass ⚡4 | — |

**Getting more energy.** The home sets the energy bar and how much each Training answer restores. Beds and a few helpers add to it:

| Home | Energy max | Energy per Training answer | Add-ons |
|---|---|---|---|
| Tent (Ch1) | 20 | 5 | Straw Bed +1 per answer |
| Cottage (Ch2) | 30 | 6 | Brick Hearth +5 max |
| Cottage loft (Ch3) | 40 | 7 | Wool Mattress +2 per answer (replaces Straw Bed) |
| Farmhouse (Ch4) | 50 | 8 | Linen Bedding +3 per answer · Lanterns +5 max |
| Farmhouse sun room (Ch5) | 65 | 9 | — |

**What the simulation shows.** "Bare hands" is the cost of a chapter's goals with no tools, home upgrades or helpers. "With upgrades" is the cost for a player who builds them as they come.

| Chapter | Energy per goal, bare hands | With upgrades | Saved | Training answers | Training per hour |
|---|---|---|---|---|---|
| 1 · Ashes | 26 | 22 | 14% | 110 | 113 |
| 2 · Homestead | 71 | 57 | 20% | 376 | 105 |
| 3 · Smallholding | 111 | 83 | 25% | 506 | 99 |
| 4 · Village Trade | 210 | 135 | 36% | 500 | 67 |
| 5 · Master Farm | 453 | 238 | 47% | 485 | 58 |

Raw effort per goal grows about 17× from Ch1 to Ch5. Upgrades cut the Ch5 cost almost in half. Even so, the arithmetic per hour falls because each answer restores more. A player who skips upgrades feels it: by Ch5 the same goals cost nearly twice the energy, and each Training answer restores less.

---

### 36.4 Basic materials, any time

New section.

- **Wild Edge** (always open, 3 slots): *Gather sticks* (2 sticks), *Pick stones* (1 stone), *Pull wild weeds* (2 plant fiber). Each takes 1 question and 1–2 energy.
- With the Wooden Shovel: *Dig out stones* (3 stones, 5 energy).
- At the pond (Ch2): *Dig clay* (2 clay).
- Sticks, stones and fiber sell for **0 coins**, so gathering is never a money farm. They are always there as a way out when a recipe is one stick short.
- Weeding field patches (§36.6) also gives fiber, so the perpetual chore feeds rope and compost.
- Gathering Basket (−25% gathering energy), Hand Axe, Saw and Master Saw make gathering cheaper.

---

### 36.5 Patch levels and fertilizer

New section. Replaces "patch upgrades" in "Farm grid".

Patches improve in **9 levels**: 3 in Chapter 1, then at least one per chapter through Chapter 5. Some levels let more plants of **the same crop** share one patch (1 → 6). Others cut weeds, water or effort. Each level is bought **per patch** (cost shown is for one patch), so upgrading a whole field is a project of its own. Higher levels need better tools and more energy.

| Ch | Level | Needs | Cost per patch | Effect |
|---|---|---|---|---|
| 1 | Dug beds | Wooden Shovel | ⚡4 | Loosen the soil: 2 plants of the same crop fit in one patch. |
| 1 | Stick edging | Dug beds, Stone Knife | 3 stick, 1 rope, ⚡2 | A woven stick border keeps weeds out: weeds grow 20% slower. |
| 1 | Raised log beds | Stick edging, Hand Axe | 1 log, 2 stick, ⚡5 | 3 plants per patch. Every plant beyond 2 needs 1 fertilizer point per planting (wood ash at first). |
| 2 | Stone borders & paths | Raised log beds, Log Shed | 4 stone, ⚡6 | Weeds −15%, and paths make harvesting −10% energy. |
| 3 | Double-dug beds | Stone borders & paths, Iron Shovel | 2 compost, ⚡9 | 4 plants per patch (2 fertilizer points per planting). |
| 3 | Irrigation channels | Double-dug beds, Dig out the pond | 3 stone, 2 plank, ⚡8 | Water flows from the pond to the roots: field water −15%. |
| 4 | Deep-worked beds | Irrigation channels, Steel Shovel | 3 compost, ⚡12 | 5 plants per patch (3 fertilizer points per planting). |
| 4 | Glass cloches | Deep-worked beds, Glass Kiln | 1 glass, 2 plank, ⚡8 | Little glass hats keep seedlings warm: crops grow 15% faster. |
| 5 | Living-soil beds | Glass cloches, Worm Bin | 2 worm castings, 1 hardwood, ⚡15 | 6 plants per patch (4 fertilizer points per planting). The weeds love it too. |

**Fertilizer.** The first 2 plants in a patch need nothing. **Each plant beyond 2 needs 1 fertilizer point every time it's planted.**

| Fertilizer | Points | Made from |
|---|---|---|
| Wood Ash (Ch1) | 1 | Campfire: 2 fiber + 1 stick → 2 ash |
| Compost (Ch2) | 2 | Compost Bin: 3 straw or 3 fiber → 2 (4 questions); 1 manure + 1 straw → 3 (3 questions); oilcake → compost |
| Worm Castings (Ch5) | 4 | Worm Bin: 1 compost + 2 straw → 1 (4 questions) |

Fertilizer is the trade-off: **more plants per patch, but weeds grow faster** (§36.6). Higher densities also need more fertilizer per planting, so the compost chain grows with the farm. The Goat pet adds 1 compost every 4 questions. The Compost Fork makes compost 25% faster.

---

### 36.6 Perpetual tasks

New section.

#### 36.6.1 How Factorio does it, and what carries over

| What Factorio does | How it carries over to the farm |
|---|---|
| **The pressure comes from your own growth.** Your machines make the pollution that wakes the biters, so a bigger factory means more pressure. | Weeds grow **on every field patch**. They grow faster with more plants per patch and more fertilizer. More fields means more weeding. |
| **It ratchets up.** Biter evolution rises over time and never goes back. | **Weed tier per chapter**: dandelions → docks → thistles → brambles → bindweed (×1 → ×2.5 growth). |
| **Every pressure has a tech answer that is a project in itself.** Walls, turrets and efficiency modules. | Stick edging, stone borders, hoes (stick → iron → steel), Weeder Geese, the Goat, Insect Hotel, Straw Mulch. |
| **The answer is automation, not more clicking.** Once turrets are supplied, defence looks after itself and attention moves on. | The late answers must cut **taps**, not only energy. Geese, Goat and Mulch slow weed growth. Proposal: one Ch5 helper that weeds one field on its own (§36.6.4). |
| **It's visible and announced in advance.** The pollution cloud, attack alerts. | Weeds sprout visibly on patches, with a small weed meter per field. |
| **You can opt out.** Peaceful mode. | A **"gentle weeds"** setting for the youngest players (weeds ×0.3, no slowdown). |
| **Losses are recoverable but hurt.** | For an 8-year-old, **nothing is ever lost** (§36.6.3). |

#### 36.6.2 What is in the data now

- **Weeds:** per field patch, per Time Quiz answer, planted or not: `0.15 × chapter weed tier × (1 + 0.4 × fertilizer points the patch density needs) × weed multipliers`. One weeding tap clears 3 weeds. Each weed costs 1 energy (less with hoes) and gives 1 fiber. Orchard spots grow half as many.
- **Fertilizer** per planting for density above 2 (§36.5).
- **Bedding straw** for animals: chickens 0.5, cows 1, sheep 1 per feeding. So wheat and oats stay needed for their straw.
- **Water for every animal product** (§36.7).
- **Simulated weeding share of all energy:** 12% · 12% · 10% · 12% · 20% (Ch1–Ch5). It stays a steady background chore and peaks at the end, when patches are dense and the field count is highest.

#### 36.6.3 Rules that keep it kind

1. **Farm time only moves when a Time Quiz answer is correct**, so chores never pile up while the child is away.
2. Weeds **cap** (proposal: 6 per patch). A weedy patch grows **slower** (proposal: −10% per weed above 3, never below half speed). Crops never die.
3. Missing fertilizer never blocks planting. The patch just takes 2 plants that time.
4. Animals without water, feed or bedding **pause** production. They never get sick or leave.
5. One new chore per chapter at most, introduced with a short helper message, the way Factorio introduces one new threat at a time.

#### 36.6.4 More ideas (not in the data yet)

Recommended next, because each one teaches something real and reuses things that already exist:

- **A. Crop rotation and tired soil.** The same crop twice in a row in one patch needs +1 fertilizer point or grows 20% slower. Following with clover or beans (legumes) resets it. This scales with the number of patches and teaches a real farming idea.
- **B. Tool sharpening.** Tools lose their energy bonus after about 40 uses. The Whetstone or Grindstone restores it for a little stone and energy. This gives the two helpers a lasting job.
- **C. Mucking out.** Manure piles up in sheds and needs mucking out (energy). Since manure → compost, the chore feeds the fertilizer loop, like Factorio's by-products becoming inputs.
- **D. Ch5 automation helper:** *Weeding Rota* (village children weed one field each 10 questions for a jam-sandwich wage). This is the Factorio "turret" moment for weeds.

Also possible, parked for now:

- **Scarecrow re-stuffing.** One scarecrow per field (already true), refilled with straw every ~80 questions.
- **Thatch upkeep.** Straw roofs need re-thatching. Brick or tile roof upgrades remove the chore: an upgrade that works like automation.
- **Well silting.** Output drops slowly; cleaning restores it; the brick lining slows silting.
- **Market saturation.** Selling a lot of one item lowers its price for a while. This rewards a varied farm (the Pony and the Market Stall soften it).
- **Village growth and standing orders.** Bread for the bakery and milk for the school, growing each chapter.
- **Weather forecasts.** A dry spell is announced 10 questions ahead. The Rain Barrel, pond, channels and Drip Line are the defence.
- **Firewood for the home.** Warmth keeps the per-answer energy bonus. The Woodlot and Lumbermill automate it.

Adding A–C, one in each of Ch2, Ch3 and Ch4, would give one new perpetual chore per chapter without overwhelming anyone.

---

### 36.7 Water for animal products

Change to "Animals".

Every animal product now needs water as well as feed:

| Animal | Feed per collection | Water | Gives |
|---|---|---|---|
| Chickens | 2 wheat, 0.5 straw | 1 | 1 egg per question |
| Cows | 3 clover, 1 straw | 3 | 1 milk + 1 manure every 2 questions |
| Bees | none (need flowering crops) | 1 (water dish) | 1 honeycomb every 2 questions |
| Sheep | 2 clover, 1 straw | 2 | 2 wool + 1 manure every 3 questions |

More water comes from the well ladder (2 → 4 → 6 → 8 → 11 per question), the pond (+2), the Tortoise (+1), the Rain Barrel (+1), the Wind Pump (+4) and River Meadow (+2). Less is used with the Water Trough (animals −20%), Watering Can and Drip Line (plants −25% / −50%), Irrigation channels (−15%), the Carrying Yoke and Straw Mulch (−5% each).

---

### 36.8 Optional helpers: things that make life cheaper

New section. None of these is required for anything. Each makes some build, craft, recipe or chore cheaper for good. There are 36 in the data: 6 / 11 / 10 / 6 / 3 by chapter, most of them in Ch2–3 while the farm is building up.

| Ch | Helper | Needs | Costs | Effect |
|---|---|---|---|---|
| 1 | 🧺 Gathering Basket | Workbench | 4 plant fiber, 2 stick, ⚡3 | Carry more per trip: gathering −25% energy. |
| 1 | 🔥 Stone Fire Ring | Campfire, Clear the rocks (2 patches) | 8 stone, ⚡4 | Holds the heat: cooking −15% energy. |
| 1 | 🛏️ Straw Bed | Workbench | 8 straw, 4 plant fiber, 4 stick, ⚡8 | Sleep better: +1 energy per Training answer. |
| 1 | 🪺 Nest Boxes | Chicken Coop | 4 straw, 4 stick, ⚡4 | Calm hens lay more: +25% eggs. |
| 1 | 🪨 Whetstone | Stone Knife, Hand Axe | 3 stone, ⚡2 | Sharp blades: cutting and wood work −10% energy. |
| 1 | 🪣 Carrying Yoke | Workbench, Well · deeper shaft | 4 stick, 2 rope, ⚡3 | Two buckets at once, less spilled: planting −10% energy, field water −5%. |
| 2 | 🏺 Pot Shelf & Clay Pots | Stove, Kiln | 6 plank, 3 clay jar, ⚡5 | Everything in reach: cooking −15% energy. |
| 2 | 🥖 Dough Trough & Rolling Pin | Oven | 4 plank, 1 log, ⚡3 | Prep work −15% energy. |
| 2 | 🪣 Milking Stool & Pail | Cows | 3 plank, 1 clay jar, ⚡2 | Animal work −20% energy. |
| 2 | 🚰 Water Trough | Barn | 6 plank, 8 stone, ⚡8 | No spilled buckets: animals use 20% less water. |
| 2 | 🌾 Hay Rack | Barn | 4 plank, 3 rope, ⚡4 | Less trampled fodder: cows and sheep eat 15% less. |
| 2 | 🧂 Salt Lick | Cows, Spice Merchant | 6 salt, 3 stone, ⚡5 | Healthy cows: +20% milk and manure. |
| 2 | 💨 Bee Smoker | Bees (straw skeps), Kiln | 3 clay, 4 plant fiber, ⚡4 | Calm bees: +25% honeycomb. |
| 2 | 🪜 Scaffolding | Carpenter's Bench | 8 plank, 6 rope, 3 log, ⚡10 | Building −15% energy. |
| 2 | 🧱 Brick Hearth | Cottage, Kiln | 12 brick, 8 stone, ⚡12 | A warm room: energy max +5. |
| 2 | 🔱 Compost Fork | Compost Bin, Carpenter's Bench | 1 plank, 3 stick, ⚡2 | Turned heaps rot faster: compost −25% time. |
| 2 | 🧰 Tool Rack | Carpenter's Shed | 6 plank, 1 log, ⚡4 | No searching: crafting −10%, field work −5% energy. |
| 3 | 🌬️ Bellows | Forge | 5 plank, 2 wool cloth, 3 nails, ⚡8 | Hotter fire: the forge needs half the charcoal. |
| 3 | ⚙️ Grindstone | Whetstone, Sawbench | 16 stone, 3 plank, 3 nails, ⚡17 | Replaces the whetstone: cutting and wood work −15% energy. |
| 3 | ✂️ Shearing Table | Sheep | 6 plank, 3 nails, ⚡7 | Cleaner fleeces: +25% wool. |
| 3 | 🛏️ Wool Mattress | Straw Bed, Hand Loom | 3 wool cloth, 6 straw, ⚡7 | Replaces the straw bed: +2 energy per Training answer. |
| 3 | 🧀 Cheese Moulds | Cheese Vat & Press | 3 plank, 3 nails, 2 linen cloth, ⚡6 | Less spilled curd: cheese needs 25% less milk. |
| 3 | 🛢️ Oak Barrels | Fermenting Crocks, Raw Materials · hardwood & sand | 3 hardwood, 2 iron bar, 3 nails, ⚡6 | Fermenting −25% time, aging −15% time. |
| 3 | 🛒 Hand Cart | Sawbench | 10 plank, 3 iron bar, 6 nails, ⚡14 | Haul more at once: harvesting −15%, building −10% energy. |
| 3 | 🐞 Insect Hotel | Bees (straw skeps), Sawbench | 3 plank, 6 straw, 6 stick, ⚡11 | Wild bees and beetles move in: +20% honeycomb, weeds −5%. |
| 3 | 🍳 Iron Pans | Stove · iron top | 3 iron bar, ⚡2 | Cooking −15% energy. |
| 3 | 🪿 Weeder Geese | Dig out the pond, Sawbench | 6 plank, 300 coins, ⚡5 | Geese graze between the rows: weeds −20%. (Real old practice.) |
| 4 | 🛏️ Linen Bedding | Wool Mattress, Textile Loom | 5 linen cloth, 2 wool cloth, ⚡6 | Replaces the mattress: +3 energy per Training answer. |
| 4 | 🏮 Lanterns | Glass Kiln, Anvil | 3 glass, 2 iron bar, 6 candle, ⚡10 | Work into the evening: energy max +5. |
| 4 | 🌱 Seed Drill | Master Saw | 5 hardwood, 2 steel bar, 6 nails, ⚡12 | Sows a whole row in one pass: planting −40% energy. |
| 4 | 🧺 Bread Peel & Proofing Baskets | Farmhouse | 3 hardwood, 2 linen cloth, ⚡5 | Cooking and baking −15% energy. |
| 4 | 🧈 Rotary Churn | Butter Churn, Smith's Hammer | 3 hardwood, 2 steel bar, ⚡5 | Butter needs 25% less milk. |
| 4 | 🌾 Straw Mulch | Deep-worked beds, Warehouse | 30 straw, 125 coins, ⚡27 | A straw blanket on every bed: weeds −15%, field water −5%. |
| 5 | 🧰 Master Tool Chest | Master Workshop, Import Broker | 10 hardwood, 3 steel bar, 3 linen cloth, ⚡16 | Crafting −15%, field and wood work −10% energy. |
| 5 | 🧱 Paved Yard | Warehouse, Import Broker | 50 stone, 16 brick, ⚡50 | Dry feet everywhere: harvesting and animal work −10% energy. |
| 5 | 🌿 Herb Drying Loft | Farmhouse · sun room | 10 plank, 3 linen cloth, 10 herbs, ⚡23 | Dried herbs on hand: cooking and prep −10% energy. |

**Things already in the tree that work the same way** (on the main path but also cost cutters):

- **Tools** replace each other and cut a category: Wooden → Iron → Steel Shovel (field −10/−20/−30%), Rock → Iron Hammer → Smith's Hammer (build −20/−35%), Hand Axe → Saw → Master Saw (wood −25/−40%), Stone → Iron → Steel Knife (prep −20/−35%), Stick → Iron → Steel Hoe (weeding −25/−45/−60%), Wheelbarrow (harvest −25%), Bucket → Watering Can → Drip Line (plant water −25/−50%).
- **Scarecrows**: Stick (planting −50%), Dressed (−75%), Guardian (also harvest −40%). One per field.
- **Home**: energy max and energy per Training answer (§36.3).
- **Water**: well levels, pond, Rain Barrel, Wind Pump.
- **Automation**: Windmill (mills by itself), Woodlot and Lumbermill (logs over time), Compost Bin, Worm Bin.
- **Market**: Market Stall +10%, Pony +10%, Harvest Fair ribbons +5% each.
- **Pets**: Bunny (+1 carrot per harvest), Tortoise (+1 water per question), Goat (weeds −15%, compost), Pony (+10% sales), Alpaca (wool).
- **Patch levels**: Stick edging, Stone borders, Irrigation channels, Glass cloches (§36.5).
- **Seed Library** (Ch5): heirloom crops give 1 seed back per harvest, so they no longer have to be bought.

---

### 36.9 Side quests

New section.

Self-contained favours for villagers. They **unlock nothing** and never block the main path. The player hands over things they made or spends energy. The **reward is a picture for the farm album** of a happy person holding what the player made for them. Ch1 quests open as soon as the building they need exists. Later ones open once the previous chapter's pet has arrived, so they never crowd out a new chapter's first goals.

There are 27: 4 each in Ch1–Ch4 and **11 in Ch5**. Simulated cost is about 2.3 hours of play if the player does them all, 70 minutes of that in Ch5.

| Ch | Favour | Needs built | Hand over | Album picture |
|---|---|---|---|---|
| 1 | 🧒 Little shepherd Tom is freezing | Campfire | 6 stick, ⚡6 | Little Tom, grinning and warm, holding up a bundle of your firewood |
| 1 | 👵 Granny Maud's goat ran off | Pull the weeds (2 patches) | ⚡10 | Granny Maud laughing, hugging her muddy goat on the rope you found it with |
| 1 | 👧 Porridge for the hungry twins | Feed the travelling merchant | 3 porridge, ⚡2 | The twins beaming, each holding a bowl of your porridge (some on their noses) |
| 1 | 🧺 The miller's daughter needs a basket | Workbench | 6 plant fiber, 2 rope, ⚡4 | Ella twirling with your new basket full of flowers |
| 2 | 🧺 The washerwoman's line snapped | Carpenter's Bench | 4 rope, 2 plank, ⚡6 | Hilde smiling, holding the end of your new rope line full of flapping sheets |
| 2 | 🤒 Soup for a sick neighbour | Stove, Tomato | 2 tomato soup, ⚡4 | Old Jan sitting up in bed, cheeks pink, holding your bowl of tomato soup |
| 2 | 🌉 Mend the footbridge | Carpenter's Bench | 6 log, 8 stone, 4 plank, ⚡18 | Ferryman Otto waving a plank from your mended footbridge as children skip across |
| 2 | 🍯 Honey for the healer | Bees (straw skeps) | 2 honey, ⚡3 | Healer Wren smiling, holding a jar of your honey up to the light |
| 3 | 🔨 The smith's apprentice is short of nails | Anvil | 8 nails, 2 iron bar, ⚡6 | Apprentice Bo proudly holding up a gate made with your nails |
| 3 | 👶 A blanket for the newborn | Hand Loom, Sheep | 2 wool cloth, ⚡6 | A happy new mum holding her baby wrapped in your wool blanket |
| 3 | 💃 Cider for the harvest dance | Fermenting Crocks, Wooden Press | 3 cider, ⚡4 | Fiddler Rosa raising a mug of your cider at the harvest dance |
| 3 | ⛪ Fix the chapel roof | Sawbench | 10 plank, 10 straw, 6 nails, ⚡24 | Bell-ringer Ansel holding your last roof plank, waving from the dry chapel |
| 4 | 🏫 The schoolroom window is broken | Glass Kiln | 2 glass, 2 plank, ⚡8 | Teacher Ines and her pupils holding up your new glass pane |
| 4 | 💒 A wedding needs a cake | Oven · iron door, Berry Bush | 1 berry cake, 1 apple pie, ⚡6 | The bride and groom holding your cake between them, laughing |
| 4 | 🏮 A lantern for the night watchman | Glass Kiln, Anvil | 2 candle, 1 glass, 1 iron bar, ⚡6 | Night watchman Pieter holding your glowing lantern on the town wall |
| 4 | ⛵ Pickles for a long voyage | Cellar Racks | 4 pickled vegetables, ⚡4 | Sailor Mei waving a jar of your pickles from the deck of her boat |
| 5 | 🧣 A rainbow scarf for the little poet | Dye Vat | 1 rainbow yarn, 1 wool cloth, ⚡8 | Little poet Kit reciting proudly in your rainbow scarf |
| 5 | 🎨 Golden paint for the painter | Saffron Crocus | 1 saffron, ⚡4 | Painter Lucia holding a brush dipped in your golden saffron paint |
| 5 | 🌈 Seeds for the school garden | Rainbow Carrot | 4 rainbow carrot, 4 compost, ⚡10 | The school children each holding up one of your rainbow carrots |
| 5 | 🎭 Cheese for the travelling theatre | Cellar Racks | 2 aged cheese, 2 sourdough bread, ⚡6 | The lead actor taking a bow while holding your cheese wheel high |
| 5 | 🍓 Jam for the orphanage | Berry Bush, Stove · iron top | 4 berry jam, 4 sourdough bread, ⚡8 | Matron Elsie holding your jam jar while the children cheer with sandwiches |
| 5 | 🪔 Oil for the old lamp-maker | Olive Tree, Wooden Press | 3 olive oil, ⚡5 | Old lamp-maker Ferdinand holding a lamp filled with your olive oil, glowing |
| 5 | 🍽️ A feast for the village elders | Grinding Mill (kitchen) | 1 olive tapenade, 2 pumpkin soup, 2 sourdough bread, ⚡12 | Elder Agnes holding up your tapenade bowl as the elders laugh around the table |
| 5 | 🚩 Dye the festival flags | Dye Vat | 2 red dye, 2 yellow dye, 2 blue dye, 2 linen cloth, ⚡10 | Mayor Juno holding a string of your dyed flags over the village square |
| 5 | ⛲ Rebuild the village well | Smith's Hammer | 20 brick, 2 steel bar, 10 stone, ⚡40 | Young Sami holding a brimming bucket from the well you rebuilt |
| 5 | 🔭 The astronomer's telescope | Glass Kiln, Master Saw | 4 glass, 1 steel bar, 2 hardwood, ⚡14 | Astronomer Vega holding your telescope, pointing happily at the stars |
| 5 | 🌿 Herbs for the healer's garden | Herbs | 8 herbs, 4 compost, ⚡10 | Healer Wren kneeling in her new herb garden, holding a bunch of your herbs |

**Art:** 27 album pictures, one for each row above. Same style as the rest of the game. These are good first candidates for the image pipeline (one character sheet per villager keeps them consistent, since Healer Wren appears twice).

---

### 36.10 Extra fields

New section. Replaces "one 3×3 farm grid".

**What the simulation found:** with dense patches, patch *time* is never the limit (it peaks at 35% of available patch time in Ch2). Crop *variety* is: the goals of a chapter need 5 / 8 / 6 / 8 / 10 different field crops at once, on 9 patches. By Ch4, keeping flax, wheat, clover, sunflower and vegetables going side by side on one field becomes juggling.

**So there are two more fields to swipe to.** Buildings stay where they are on the home screen; only the field grid changes.

| Field | Chapter | Needs | Gives |
|---|---|---|---|
| Home Field | start | — | 3 cleared patches + 6 to clear (weeds, rocks, stumps) |
| **North Field** | 4 (main path) | Iron Hoe, Barn cellar → *clear the scrub* (⚡30, 400 coins), then Sawbench → *fence* (18 plank, 12 nails, ⚡20, 400 coins) | +9 patches |
| **River Meadow** | 5 (optional) | North Field, Import Broker, Steel Hoe → *drain the marsh* (⚡45, 30 stone, 16 plank, 1,250 coins), then Brickworks → *sluice* (25 brick, 3 steel, ⚡30, 1,250 coins) | +9 patches, +2 water per question |

New fields start at **level 1** and need their own patch levels and their own scarecrow. Weeds grow per patch, so every new field also adds to the perpetual weeding (§36.6), the Factorio trade-off. The orchard (3 trees, +2 with Orchard terraces in Ch5), the pond and the greenhouse (4 + 2 beds) stay as special patches.

---

### 36.11 Pacing (data v0.2)

Replaces the pacing table in v1.1.

| Chapter | Hours | Goals | Pet (target → simulated) |
|---|---|---|---|
| 1 · Ashes | 0 → 1.0 | 28 | Bunny 1 h → 1.0 h |
| 2 · Homestead | 1.0 → 4.6 | 43 | Tortoise 4.5 h → 4.6 h |
| 3 · Smallholding | 4.6 → 9.7 | 46 | Goat 10 h → 8.7 h |
| 4 · Village Trade | 9.7 → 17.2 | 36 | Pony 17.5 h → 17.2 h |
| 5 · Master Farm | 17.2 → 25.6 | 23 | Alpaca 25.5 h → 23.1 h |

**Totals:** 25.6 hours · 2,041 Time Quiz answers · 1,977 Training answers · 176 goals + 33 automatic unlocks · 36 optional helpers · 27 side quests (≈ 2.3 h on top) · 134 items · 101 recipes · 0 errors, 0 warnings.

**Soft spots to watch in playtests:**

- **The alpaca arrives at about 23 h, not 25.5 h.** Chapter 5 costs are already at the calibration ceiling. The last ~2.5 h are optional (River Meadow, Orchard terraces, the Ch5 side quests). To push the alpaca later, add one more Ch5 goal rather than inflating prices.
- In Ch4 and Ch5 there are short stretches where the nearest **main** goal is more than 22 minutes away (grey dots in the explorer). Side quests and helpers fill those gaps, which is one reason Ch5 has 11 side quests.

---

### 36.12 Notes for the game code and Godot

Addition to "Technical notes".

- The prototype's game code does **not** implement v0.2 yet. The scope so far was data, explorer and bug fixes, plus the quiz packs. To implement:
  - energy by category with multipliers;
  - patch levels per patch per field;
  - fertilizer per planting;
  - weed growth per patch with the kind rules in §36.6.3;
  - animal water and bedding;
  - helpers;
  - side quests with an album screen;
  - pet naming;
  - field swiping.
- The data stays engine-agnostic. In Godot, load `farm-progression.json` with `JSON.parse_string` into an autoload (`GameData`). Effects are plain dictionaries (`set`, `add`, `mult`, `produces`), so one small function can apply them all.
- Asset list for the art pipeline: 5 pets, 4 animals, 47 buildings, 38 stations, 21 tools, 22 crops, 9 patch looks (one per level), 5 weed tiers, 27 album pictures, 3 field backgrounds.

---

## 37. Version 1.3 — Knowledge, Rest, polish, seasons, pests, luck and the Godot prototype

*Merged from `archive/design-doc-v1.3-changes.md`. Data v0.3.*

### 37.1 Decisions in 1.3

| # | Topic | Decision |
|---|---|---|
| 1 | Food | Eating a dish lowers energy costs for **one or two Time Quiz questions** (−10% to −30% by dish). It never restores energy, so Rest stays necessary. |
| 1b | "Training" | Renamed **Rest** 😴 — sleep, eating, a sip of water, recuperating. Rest answers are still arithmetic. A better bed, pillow, water bottle and home give **more energy per answer**. Better shoes, gloves, bag and hat make work **cost less**. |
| 2 | Reviews in the Time Quiz | Yes. `knowledgeReviewShare` in `settings.json` sets the share of Time Quiz questions that review cards the child already learned. 0 turns it off; default 0.25. The rest come from the parent's packs. |
| 3 | Seasons | Light seasons: each one slows some things and makes others plentiful (§37.6). Nothing dies. |
| 4 | Freshness | Checked **at each change of season**. Food that has sat in the pantry long enough gets a "stale soon" badge and turns into feed mash or compost at the next change unless it is sold, eaten or cooked (§37.7). |
| 5 | Pests | No range and no "back to the bag". Pests **reduce the number of plants** on a patch, never below 1. More plants attract more pests. You **see them hopping**, and the scarecrow **throws fierce looks** that make them leave. Rising arrivals call for better scarecrows and fences (§37.8). |
| 6 | Farm layout bonuses | **No.** |
| 7 | Gift cards | Pick 1 of 3 at milestones; the other two go to the shop (§37.12). |
| 8 | Swappable ingredients | Many everyday recipes take "any of a kind" (any flour, fat, grain, sweetener, fodder…). **Signature dishes** asked for by deliveries and pets keep fixed ingredients. Different sweeteners make **different named dishes** that share a family: honey → Honey Cake, beet sugar → Simple Cake, both cakes (§37.13). |
| 9 | Village projects | Still a maybe — not built. |
| 10 | Quality stars | **No.** |
| 11 | Endless upgrades | Yes, from **chapter 1**, as **polish** with diminishing returns: the cost rises linearly, the gain halves each time, and use wears it off (§37.4). Weeding works the same way: you can always "root out" more, for less effect and more energy. |
| 12 | Card size | One card per idea. Some unlock things, some give a lasting boost, some both (§37.3). |
| 13 | Paying for knowledge | Coins (books) + time (reading) + the child **showing the knowledge** in a short quiz. No second currency. |
| 14 | Length | No hour target. The goal is **steady difficulty**: minutes per goal rise only gently, and Rest per hour stays in a band (§37.15). |
| — | Numbers | Every amount is exact in the background; **the player only sees whole numbers**: stocks rounded down, costs rounded up, halves shown as ½ (§37.5). |
| — | Luck | A hidden background value, raised for a while by side quests, little jobs and four-leaf clovers. It makes lucky events more likely (§37.9). |

---

### 37.2 Rest, gear and the home

- **Energy per Rest answer** comes from:
  - the home: Tent 5 → Cottage 6 → Loft 7 → Farmhouse 8 → Sun room 9;
  - the bed: Straw +1 → Wool mattress +2 → Linen bedding +3;
  - the pillow: +½ → +1 → +1½;
  - the water bottle: +½ → +1 → +1½ → +2;
  - the library chair: +½;
  - gift cards and polish (Air the bed: up to +1).
- **Cold house:** in winter with an empty woodpile, Rest gives 25% less.
- **Gear** (type `gear`, 23 items in 8 slots). Each slot is a ladder; a new item replaces the old one.

| Slot | Ladder (chapter) | Effect of each step |
|---|---|---|
| bed | 🛏️ Straw Bed (1) → 🛏️ Wool Mattress (3) → 🛏️ Linen Bedding (4) | +1 ⚡ per Rest answer / +2 ⚡ per Rest answer / +3 ⚡ per Rest answer |
| feet | 🩴 Straw Sandals (1) → 👞 Wooden Clogs (2) → 🥾 Hobnail Boots (3) → 🥾 Waxed Walking Boots (4) | planting −5%, harvesting −5%, gathering −5%, errands −5%, animal care −5% / planting −10%, harvesting −10%, gathering −10%, errands −10%, animal care −10% / planting −15%, harvesting −15%, gathering −15%, errands −15%, animal care −15% / planting −20%, harvesting −20%, gathering −20%, errands −20%, animal care −20% |
| hands | 🧤 Fibre Mitts (1) → 🧤 Wool Work Gloves (3) → 🧤 Waxed Linen Gloves (4) | weeding −10%, gathering −5% / weeding −15%, building −5%, gathering −5% / weeding −25%, building −10%, crafting −5% |
| back | 👜 Woven Bag (1) → 🧺 Wicker Pack Basket (2) → 🎒 Canvas Rucksack (3) → 🎒 Frame Rucksack (4) | gathering −10%, harvesting −5% / gathering −15%, harvesting −10% / gathering −20%, harvesting −15%, errands −10% / gathering −25%, harvesting −20%, errands −15% |
| bottle | 🏺 Clay Water Flask (2) → 🍶 Sealed Stoneware Jug (3) → 🫙 Glass Bottle & Sling (4) → 🧉 Wool-wrapped Flask (5) | +½ ⚡ per Rest answer / +1 ⚡ per Rest answer / +1½ ⚡ per Rest answer / +2 ⚡ per Rest answer |
| head | 👒 Straw Hat (1) → 🎩 Felt Hat (3) → 👒 Wide Linen Sunhat (4) | energy max +2, field work −3% / energy max +4, field work −5% / energy max +6, field work −10% |
| apron | 🥼 Linen Apron (3) → 🥼 Waxed Canvas Apron (4) | cooking −10%, prep −10% / cooking −15%, prep −15%, dairy & press −10% |
| pillow | 🛌 Straw Pillow (1) → 🛌 Feather Pillow (3) → 🛌 Wool & Down Pillow (4) | +½ ⚡ per Rest answer / +1 ⚡ per Rest answer / +1½ ⚡ per Rest answer |

---

### 37.3 Knowledge: cards, books and the library

**Learning a card**
1. Own its **book**.
2. Have **discovered** its item, if it lists one (e.g. hold iron ore once before "Smelting iron").
3. **Read** it. This takes a few Time Quiz questions and goes faster in a bigger library.
4. Answer its **quiz**: **2 new questions** about the card, plus **up to 3 review questions**, one from each of up to 3 earlier cards it builds on. Weakest and longest-unseen cards come first, so the quiz never gets long.
   - Wrong answers grey out, show a one-line "why" and can be retried.
   - Only first-try answers move a card up its review box (Leitner boxes 1–4).
   - A missed review never blocks learning.
5. Learned cards come back as single **reviews in the Time Quiz** (share set in `settings.json`). They are due after 12 / 40 / 100 / 250 questions, or 1 / 3 / 7 / 21 real days, whichever comes first.

**Content.** 67 cards. Each has a read-aloud page (2–4 sentences, Grade 2–3 reading level) and 3 questions with 3 answers and a one-line "why". The 🔊 button in the prototype reads them aloud where the system has a voice.

**Books and library.** Books are bought from the **Book Cart**, which arrives with the travelling merchant.

| Library level | Holds | Reading | Needs |
|---|---|---|---|
| 📦 Book box in the tent | 2 books | — | start (the free *Little Farm Book* is in it) |
| 📚 Bookshelf | 5 | 10% faster | 5 cards learned, Carpenter's Bench |
| 🪑 Bookcase & reading chair | 10 | 20% faster | 15 cards, Carpenter's Bench |
| 🏛️ Library room | 12 (all) | 30% faster, +½ ⚡ per Rest answer | 30 cards, Farmhouse |

| Book | Chapter | Coins | Arrives with |
|---|---|---|---|
| 📗 The Little Farm Book | 1 | free | start |
| 📘 Village Crafts | 1 | 15 | start |
| 📙 Grandma's Kitchen | 2 | 25 | Cottage |
| 📕 Animals & Bees | 2 | 30 | Chicken Coop |
| 📒 Soil & Seasons | 2 | 40 | Log Shed |
| 📓 The Smith's Book | 3 | 150 | Raw Materials · iron ore |
| 📔 From Fleece to Fabric | 3 | 125 | Barn |
| 📚 Cellar & Larder | 3 | 150 | Barn |
| 📘 Fire, Glass & Steel | 4 | 125 | Raw Materials · hardwood & sand |
| 📗 Orchard & Oils | 4 | 100 | Clear the old orchard |
| 🎨 Colours of the Earth | 5 | 175 | Import Broker |
| 📜 The Master Farmer | 5 | 250 | Import Broker |

**The cards** (what each one opens; ✨ = a lasting boost):

- **📗 The Little Farm Book:** 🌾 Growing wheat → Wheat; 🔥 A safe little fire → Campfire ✨ fuel −5%; 🥕 Roots you can eat → Carrot, Onion; 🪢 Twisting rope from fibres → Rope (fiber), Rope (straw); 🪨 Stone tools → Stone Knife, Hand Axe, Wooden Shovel, Stick Hoe; 🌿 Why weeds come back → Stick edging ✨ weeds −5%; 🪣 Water and the well → Well · deeper shaft, Well · winch ✨ +5 water storage; 🪏 Loose soil, happy roots → Dug beds; 🩶 Ash feeds the soil → Wood ash (burn weeds & twigs), Raised log beds; 🐔 Keeping hens → Chicken Coop; 🧍 Birds, seeds and scarecrows → Stick Scarecrow, Stick Fence ✨ pests −5%; ♻️ How compost works → Compost Bin, Compost (straw), Compost (weeds) ✨ Compost Bin time −10%
- **📘 Village Crafts:** ⚙️ Grinding grain into flour → Hand Quern, Flour (hand quern); 🪙 Fair prices ✨ +3% sales; 🪵 Logs, planks and grain → Carpenter's Shed, Carpenter's Bench, Planks (split); 🟤 Clay and bricks → Kiln, Brick, Clay Jar; ⚫ Charcoal → Charcoal; 🏗️ Walls and roofs → Cottage · log walls, Barn · frame, Log Shed; 🌾 Thatching with straw → Cottage · thatched roof
- **📙 Grandma's Kitchen:** 🍞 Why bread rises → Oven, Sourdough Starter, Sourdough Bread; ♨️ Cooking on a stove → Stove; 🧈 Cream into butter → Butter Churn, Butter; 🍯 From comb to honey → Honey (crush & strain), Candle; 🧂 Salt keeps food → Hearty Vegetable Stew, Bean Stew
- **📕 Animals & Bees:** 🐄 Cows: grass in, milk out → Barn; 🐝 Bees and flowers → Bee Yard ✨ Bees (straw skeps) output +5%; 💩 Muck and manure → Compost (manure) ✨ muck −10%; 🌾 What animals eat ✨ Chickens feed −5%, Cows feed −5%, Sheep feed −5%; 🐞 Pests and their enemies → Insect Hotel, Picket Fence, Owl Box ✨ pests −10%
- **📒 Soil & Seasons:** 🔄 Crop rotation ✨ rested soil +5%; 🍂 The four seasons ✨ winter growth +10%; 🧊 Frost heave: stones that grow → Stone borders & paths ✨ stones −15%; 🦆 Ponds and wetlands → Dig out the pond; 🌳 Planting trees → Woodlot, Clear the old orchard; ⛏️ Double digging → Double-dug beds
- **📓 The Smith's Book:** 🔩 Smelting iron → Smithy · chimney, Forge, Iron Bar; ⚒️ Hammer and anvil → Anvil, Iron Hammer; 📌 Nails and joints → Nails, Sawbench; 🌬️ Wind power → Windmill · stone tower; 💧 Channels and irrigation → Irrigation channels, Watering Can
- **📔 From Fleece to Fabric:** 🐑 Shearing and spinning → Sheep Pen, Hand Spindle, Yarn; 🧶 Warp and weft → Hand Loom, Wool Cloth; 🪻 Flax to linen → Soak (ret) flax, Linen Thread, Linen Cloth
- **📚 Cellar & Larder:** 🍇 Pressing oil and juice → Wooden Press, Apple Juice, Sunflower Oil; 🟣 Sugar from beets → Sugar; 🏺 Friendly microbes → Fermenting Crocks, Yogurt, Cider; 🧀 Making cheese → Cheese Vat & Press, Fresh Cheese; 🧀 The cool cellar → Barn · cellar, Cellar Racks ✨ food keeps +1 season; 🫙 Pickling and vinegar → Vinegar, Pickled Vegetables
- **📘 Fire, Glass & Steel:** ⚙️ From iron to steel → Blast Forge, Steel Bar; 🪟 Sand into glass → Glass Kiln, Glass; 🪴 Greenhouses → Greenhouse · frame, Glass cloches; 🧱 Brick houses → Farmhouse · foundation, Brickworks
- **📗 Orchard & Oils:** 🍎 Caring for fruit trees → Walnut Tree, Olive Tree ✨ yield Clear the old orchard +10%; 🫒 Olives: oil and curing → Olive Oil, Cured Olives; 🍝 Pasta and dough → Fresh Pasta, Tomato Sauce, Pizza Dough; 🪵 Hardwood and joinery → Master Saw, Lumbermill · hardwood grove; 🟫 Deep soil and humus → Deep-worked beds; 🌾 Mulching → Straw Mulch
- **🎨 Colours of the Earth:** 🎨 Dyes from plants → Dye Vat; 🌈 Mixing colours → Orange Dye, Green Dye, Purple Dye
- **📜 The Master Farmer:** 🪱 Worms make soil → Worm Bin, Worm Castings; 🫘 Saving seeds → Seed Library; 🌸 Saffron, the precious spice → Saffron Crocus; 🎂 Master baking → Master Oven, Fine Flour; 🌬️ Pumping water with wind → Wind Pump; 🍄 Living soil → Living-soil beds

---

### 37.4 Polish: endless upgrades with diminishing returns

New type `polish`, 22 entries, available from chapter 1.

- **Gain:** each polish adds 1 point P. The listed effect is the cap.
  - Gain = cap × (1 − 0.5^P): the first time gives **half**, the second a quarter more, the third an eighth…
- **Cost:** the next polish costs base × (1 + whole P), so it rises by the base every time.
- **Wear:** using the thing (or time passing) takes P down slowly. Polish is maintenance as well as an upgrade.
- **Why:** a new **kind** of upgrade is always worth more than grinding the same one, yet there is always something useful to do.
- **Weeding** follows the same rule: *Root out the weeds* keeps regrowth down, with less effect and more energy each time.

| Polish | Ch | Needs | Base cost | Cap (endless) | Wears off |
|---|---|---|---|---|---|
| 🔪 Sharpen the knife | 1 | Stone Knife | 1 stone, ⚡1 | prep −15% | 0.05 per prep job |
| 🪓 Sharpen the axe & saw | 1 | Hand Axe | 1 stone, ⚡1 | wood work −15%, gathering −5% | 0.05 per wood work job |
| 🪏 Clean & oil the shovel | 1 | Wooden Shovel | 1 plant fiber, ⚡1 | field work −10% | 0.03 per field work job |
| ⛏️ Sharpen the hoe | 1 | Stick Hoe | 1 stone, ⚡1 | weeding −15% | 0.01 per weeding job |
| 🌱 Root out the weeds | 1 | Three cleared patches | ⚡2 | weeds −25% | 0.03 per question |
| 🛏️ Air the bed & fresh straw | 1 | Straw Bed | 2 straw, ⚡1 | +1 ⚡ per Rest answer | 0.02 per question |
| 🪣 Clean out the well | 1 | Well · deeper shaft | 1 rope, ⚡3 | +1½ 💧 per question | 0.015 per question |
| 🧹 Sweep the fire pit | 1 | Campfire | ⚡1 | cooking −8%, fuel −15% | 0.05 per cooking job |
| ⚙️ Dress the millstones | 1 | Hand Quern | 1 stone, ⚡2 | milling −20%, Windmill time −15% | 0.05 per milling job |
| 🧍 Re-stuff the scarecrow | 1 | Stick Scarecrow | 2 straw, ⚡1 | chases +½ pests | 0.02 per question |
| 🪵 Mend the fence | 1 | Stick Fence | 2 stick, ⚡1 | +15% pests kept out | 0.02 per question |
| 🪺 Fresh nest straw | 1 | Chicken Coop | 2 straw, ⚡1 | Chickens output +15% | 0.02 per question |
| 🧰 Tidy the workbench | 1 | Workbench | ⚡1 | crafting −10% | 0.01 per question |
| 🔥 Patch the kiln lining | 2 | Kiln | 1 clay, ⚡2 | Kiln time −15%, fuel −8% | 0.05 per kiln job |
| 🥾 Wax the boots | 2 | Wooden Clogs | 1 beeswax | errands −10%, planting −5%, harvesting −5% | 0.02 per question |
| 🐄 Brush the cows | 2 | Cows | ⚡2 | Cows output +15% | 0.02 per question |
| 🐝 Clean the hive frames | 2 | Bee Yard | ⚡2 | Bees (straw skeps) output +15% | 0.02 per question |
| 🪶 Dust the shelves | 2 | Bookshelf | 1 feather, ⚡1 | read −15% | 0.01 per question |
| 🧶 Oil the loom & spindle | 3 | Hand Loom | 1 any oil, ⚡1 | textiles −15% | 0.05 per textiles job |
| 🔨 Re-wedge the hammer | 3 | Iron Hammer | 1 stick, 1 nails, ⚡1 | building −10%, smithing −5% | 0.05 per building job |
| ✂️ Sharpen the shears | 3 | Shears | 1 stone, ⚡1 | Sheep output +10%, animal care −5% | 0.03 per animal care job |
| 🌬️ Tune the bellows | 3 | Forge | 1 any oil, ⚡2 | Charcoal at Forge −15%, smithing −5% | 0.05 per smithing job |

---

### 37.5 Numbers: exact underneath, whole on screen

- Everything (stocks, energy, water, plants on a patch, polish, luck) is a float, so percentages multiply exactly. A harvest of 2.7 wheat shows **2**, and the 0.7 is kept.
- **Display rule:**
  - stocks round **down** and costs round **up**, so whatever looks affordable is;
  - halves in descriptions show as ½;
  - no decimals anywhere.

---

### 37.6 Seasons

- A year is 4 seasons of 30 Time Quiz questions each; the top bar shows how many questions are left.
- Nothing dies; seasons only change speeds and amounts.

| Season | Slower | Plenty |
|---|---|---|
| 🌱 Spring | — | weeds sprout (+50%, more fibre); rain 30% |
| ☀️ Summer | thirstier fields (+30% water), more pests (+50%) | crops grow 20% faster, bees +30% honeycomb |
| 🍂 Autumn | crops 15% slower | orchard +40%, fallen branches (sticks ×2) |
| ❄️ Winter | crops at half speed, home burns firewood | frost lifts **stones** in every patch, stones from the field edge ×2, indoor work −10% energy, thick fleece +20%, few weeds and pests |

---

### 37.7 Freshness (at the change of season)

- Each pantry batch remembers the season it arrived in.
- **Shelf life** is counted in season changes:
  - lettuce, berries, tomatoes, herbs, clover, olives, eggs, milk, butter, fresh cheese, yogurt, juices, sauce, fresh pasta, dough and dishes: 1;
  - roots, apples and beans: 2;
  - pumpkins: 3;
  - everything preserved keeps for ever: flour, grain, honey, jam, pickles, aged cheese, oils, cider, vinegar, nuts.
- **"Stale soon" badge** on anything that will turn at the next change.
- **At the change:** plant food becomes 🥣 **Feed Mash** (hens, cows and sheep eat it; the compost takes it); eggs and dairy go to **compost**.
- **Keeps longer:** Cellar Racks +1 season, the Cool Cellar card +1, the Cool Cellar gift card +1.

---

### 37.8 Pests

- **Arrivals** per question = 0.05 × plants growing × chapter tier (1 / 1.4 / 1.8 / 2.3 / 2.8) × season × (1 − fence share kept out).
- **Defence:**
  - the scarecrow chases up to its **scare** value per question: Stick 0.6 → Dressed 1.2 → Guardian 2 → Whirligig 3, +½ when re-stuffed;
  - the barn cat, owl box and ducks add 0.4 / 0.4 / 0.3;
  - 20% of the pests left wander off by themselves.
- **Damage:** each pest still around eats 0.15 plants per question from growing patches; a patch never drops below 1 plant.
- **Fences:** Stick 15% → Wattle 30% → Picket 45% → Field Stone Wall 55% (made of frost-heaved stones) → Hedgerow 65%.
- **On screen:** pests (🐦🐇🐌🐛🐭, by chapter) hop between growing patches. The scarecrow throws fierce looks (💢😠👀) that fly across the field, and the pests it chases fly off.
- **Simulated losses:** about 10% in chapter 1 before the first scarecrow, a few percent in chapter 2, near zero once defences keep up. Leave the scarecrow un-stuffed or skip a fence and losses come back as arrivals grow.

---

### 37.9 Luck and lucky events

- Luck is hidden; a 🍀 appears in the top bar while it is high.
- Every event's chance is multiplied by (1 + luck).
- **Sources:**
  - side quest +0.5 for 30 questions;
  - little job +0.1 for 10;
  - four-leaf clover +0.3 for 20;
  - each pet +0.05 for good;
  - Lucky Horseshoe gift card +0.15 for good.

| Event | When | Base chance | What happens |
|---|---|---|---|
| weed coin | pulling weeds | 4% | A lost coin in the weeds! |
| weed seed | pulling weeds | 2% | An old seed packet! |
| weed clover | pulling weeds | 1% | A four-leaf clover! You feel lucky. |
| weed relic | pulling weeds | 0.7% | Something old in the soil: a relic for the album! |
| stone quartz | picking stones | 2% | A sparkling quartz crystal inside a stone! |
| rain | each Time Quiz answer | by season (30% / 10% / 30% / 20%) | It rained: no watering needed, and the well fills a little. |
| double harvest | harvesting | 3% | Bumper crop: double harvest! |
| double yolk | collecting from Chickens | 5% | A double-yolk egg! |
| honey flow | collecting from Bees (straw skeps) | 5% | A honey flow: extra comb! |
| thick fleece | collecting from Sheep | 5% | An extra-thick fleece! |
| neighbour gift | each Time Quiz answer | 1% | A neighbour drops off a little gift basket. |
| seed bargain | buying seeds | 5% | The seed merchant adds one for free. |
| golden acorn | pulling weeds | 0.2% | A golden acorn glints under a leaf! |

---

### 37.10 Perpetual pressures that grow with the farm (adopted)

All are soft: things get slower, never lost.

| Pressure | Grows with | Answer (upgrade ladder) |
|---|---|---|
| Weeds | patches, plants per patch, fertilizer, chapter | edging, borders, hoes, gloves, geese, goat, mulch, **Root out** polish |
| Frost stones (winter) | patches, deep beds, bare beds | pick them (stones for walls and paths), Stone Sense card |
| Pests | plants growing, chapter, summer | scarecrow ladder + re-stuffing, fences, cat, owl, ducks, insect hotel |
| Firewood | heat stations (campfire 1, oven 2, kiln 3, forge 2 per batch) + the home in winter | woodpile size (basket 20 → shed 40 → warehouse 80), fire ring, tripod, tall chimney, hearth, sweep the fire pit, Firekeeper card |
| Muck | animals (hens 0.3, cows 1, sheep 0.6 per collection) | muck out (gives manure); perches, drain gutter, Clean Barn card. Above 4 per animal: −25% output; above 8: −50% |
| Tired soil | planting the same crop twice in a row (−15% growth) | rotate; after beans or clover +10% |
| Blunt tools and worn machines | use | polish (sharpen, oil, dress the millstones, tune the bellows…), quench trough |
| Freshness | food stored across seasons | sell, eat or cook into something that keeps; cellar |

---

### 37.11 Food

| Dishes | Effect |
|---|---|
| Porridge, roast carrots, flatbread, baked potato, salad, omelette | −10% energy for 1 question |
| Soups, stews, bread, pancakes, honey porridge, mash, onions, pickles, yogurt bowl, pasta, sandwich | −20% for 2 questions |
| Cakes, pies, pizza, pasta pomodoro, pumpkin soup, tapenade, pesto, cheese board | −30% for 2 questions |

Pet dishes are not eaten.

---

### 37.12 Gift cards, little jobs, golden acorns, practice stars, choice slots

- **Gift cards:** 24 in the pool.
  - Offered 3 at a time when a pet arrives, at each library level and every 12 goals.
  - The two not picked go to the shop (20 / 50 / 100 / 180 / 300 coins by chapter).
  - Effects include +5 storage, +½ water per question, +3 energy max, growth +5%, luck, +½ per Rest answer, pests −10%, reading +20%, +3% sales, winter growth, food keeps longer, firewood −15%, muck −20% and stones −20%.
- **Little jobs:** three small tasks that refill themselves as soon as one is done. They only offer what you can do right now: harvest, weed, make, sell, collect, stones, rest. The reward is 4 coins × chapter and a little luck.
- **Golden acorns (7):**
  - first favour, a bookshelf, the first winter, 100 weeds, the first pet, 10 cards, and one found by luck while weeding;
  - each gives energy max +3 for good.
- **Practice stars:** every station counts its uses. At 10, 40 and 120 uses it earns a star: −5% energy for its recipes per star.
- **Choice slots:** ten stations or buildings have one slot with two items (e.g. Campfire: Fire Ring −15% cooking energy *or* Cooking Tripod −30% firewood). Only one works at a time; you can swap freely.

---

### 37.13 Every item has more than one use

**Audit before 1.3:** 134 items, median 2 uses besides selling, 64 with one use or none (dishes worst).

**Added in 1.3:**
- **Eating** — every dish except pet dishes gives a food bonus.
- **Firewood:** sticks, straw, logs, planks, hardwood, charcoal.
- **Composting:** any scraps.
- **Feeding animals:** any grain or fodder.
- **New items:**
  - 🪶 feathers from hens: pillows, the library feather duster;
  - 🥣 feed mash: from stale food or chopped vegetables;
  - 🟤 linseed from flax: hen feed, linseed oil;
  - 🫗 linseed oil: oiling tools and looms;
  - 💎 quartz and 🏺 relics: lucky finds.
- **Other new uses:**
  - beeswax: boots, gloves, aprons;
  - wool and linen: gear;
  - stones: the field wall;
  - the new Honey Cake and honey jam.
- **Swappable recipe inputs:** porridge (any grain), flatbread and pancakes (any flour), mash, caramel onions and pumpkin soup (any fat), tomato sauce and pizza dough (any cooking oil), yogurt bowl (any sweetener).

---

### 37.14 Data model additions (for whoever codes the game)

- **New node types:**
  - `knowledge` (fields `discover`, `unlocks`, `page`, `questions`, `cost.read`);
  - `book`;
  - `gear` (slot `gear:<slot>`);
  - `polish` (fields `target`, `wear`).
- **New node fields:** `requiresCards`, `attach` (choice slot), `muck` (animals).
- **New recipe field:** `fuel`. **New item field:** `buff`.
- **New effect keys:**
  - `scare`, `pestBlock`, `fuel`, `fuel:<station>`, `muck`, `muck:<animal>`;
  - `stones`, `pests`, `read`, `yield:orchard`, `slots:<station>`, `wear`;
  - `shelfLife`, `restedSoil`, `winterGrow`, `woodpileCap`, `homeFuel`, `bookSlots`, `luck`, `luckDuration`, `energyPerRest`.
- **New meta blocks:** `rest`, `quiz`, `knowledge`, `seasons`, `freshness`, `pests`, `stones`, `fuel`, `muck`, `rotation`, `polish`, `luck`, `giftCards`, `jobs`, `practice`, `acorns`, `numbers`.

---

### 37.15 Pacing (data v0.3): steady instead of fixed hours

| Chapter | Hours | Main goals | Minutes per goal (target) | Rest per hour | Energy per goal, bare hands → with upgrades | Saved | Cards | Weeding · stones share | Pest loss |
|---|---|---|---|---|---|---|---|---|---|
| 1 · Ashes | 0.0 → 1.4 | 36 | 2.4 (2.5) | 73 | 13 → 11 | 21% | 13 | 9% · 2% | 10% |
| 2 · Homestead | 1.4 → 5.5 | 56 | 4.3 (4) | 50 | 27 → 20 | 28% | 20 | 14% · 3% | 3% |
| 3 · Smallholding | 5.5 → 10.0 | 56 | 4.9 (5) | 59 | 47 → 32 | 31% | 16 | 7% · 1% | 0% |
| 4 · Village Trade | 10.0 → 14.7 | 43 | 6.5 (6) | 56 | 94 → 60 | 36% | 10 | 4% · 1% | 0% |
| 5 · Master Farm | 14.7 → 18.2 | 28 | 7.5 (7) | 51 | 152 → 79 | 48% | 8 | 6% · 2% | 0% |

- **Totals:**
  - 18.5 hours on the main path, plus ≈ 2.4 h of side quests and the optional River Meadow;
  - 1,466 Time Quiz answers, 1,009 Rest answers;
  - 67 cards (≈ 1 h of card quizzes);
  - 315 goals + 35 automatic;
  - 0 errors, 0 warnings.
- **Pets:** 1.5 / 5.5 / 9.6 / 14.3 / 18.2 h.
- **Reading the table:**
  - Raw effort per goal grows 12× from chapter 1 to 5, while upgrades cut chapter 5's cost almost in half. The tinkering pays.
  - Rest per hour stays between 50 and 73, so arithmetic never disappears and never floods.
  - The simulated player buys every defence as soon as it can, so its pest losses fall to zero after chapter 2; a player who skips scarecrow and fence upgrades loses more as arrivals grow.

---

### 37.16 The Godot prototype

`godot-prototype/` opens in **Godot 4.7** (Import → `project.godot` → F5). Everything comes from the same `farm-progression.json`; emojis stand in for art.

**What's in it**
- Time Quiz (packs plus card reviews), Rest, fields with 3 areas (fields, orchard, greenhouse) and swiping between fields.
- Weeds, frost stones, pests hopping with scarecrow looks, rain, seasons and freshness.
- Animals with muck, stations with a woodpile and choice slots, the market and merchants.
- Library with books, reading and card quizzes; gear; polish; food; luck events.
- Gift cards, little jobs, golden acorns, the album, pet naming, autosave.
- **⏩ Cheat:** lets time pass until everything is done, then fills energy and water. **🪙+100** adds coins.

**Tested**
- A headless bot plays the rules engine from the start into **chapter 4** (goat home by question ~490) without errors.
- A UI smoke test clicks through the opening: first card, planting, Time Quiz, Rest, every place on the map (1.3.2: on the isometric map).
- Screenshots of every screen are in `godot-prototype/screenshots/`.

**Simplified**
- Patch upgrades are paid patch by patch but apply to all patches.
- One scarecrow and one fence cover all fields.
- No sound, no avatar, no pixie chest yet.

---

### 37.17 Where the ideas came from (research summary)

- **Knowledge discovered by doing:** Factorio 2.0 trigger technologies, Valheim and Minecraft recipe unlocks.
- **The library growing as you learn:** the Animal Crossing museum.
- **Books from a visiting seller, permanent-perk books:** Stardew Valley 1.6.
- **Reading over time:** Kingdom Come: Deliverance.
- **Reviews woven into the quiz:**
  - Khan Academy Mastery Challenges and Leitner boxes;
  - feedback after every pick (with feedback, second-graders' wrong answers carried forward fell from 26% to 5%, Marsh et al. 2012);
  - intrinsic integration (Habgood & Ainsworth 2011).
- **Pressure tied to your own growth, with soft failure:**
  - Factorio pollution, RimWorld wealth;
  - Banished tool wear, Rune Factory soil;
  - Farthest Frontier and Farming Simulator stones and weeds.
- **One slot with two options:** Stardew sprinkler attachments.
- **Permanent energy finds:** Stardew Stardrops.
- **Refilling small tasks:** Animal Crossing Nook Miles+.
- **Polish with diminishing returns:** the user's Cookie Clicker idea.

---

### 37.18 Still open

- Village projects (bundles with substitutes): still a maybe.
- Cider is alcoholic. It is needed for vinegar; rename it "apple must" for young players if wanted.
- Art for the 67 card pages, 27 album pictures, 23 gear items and pests.
- Playtest with real 8-year-olds:
  - how many review questions they tolerate;
  - whether 30 questions per season feels right;
  - whether pest pressure is noticeable but not annoying.

---

### 37.19 The farm map on the iPad, the browser version and the art pipeline *(1.3.1)*

**Layout (iPad held upright, 834×1194 design size, other screens stretch to fit).** The prototype's tabs are gone. Like the HTML5 prototype, every action lives where it happens on one farm map that scrolls up and down:
- **Top bar:** coins, water, energy (tap → Rest), season; pantry 🎒, quest book 📖, album 🖼️, settings ⚙️.
- **Map:** home yard at the top (home, library, kitchen, well, storage, workshop), the field in the middle, animal pens and later buildings below (pet corner, cows, sheep, bees, barn, windmill, compost, pond, orchard, greenhouse).
- **Forest edge** on the left (gathering, later the woodlot) and **village road** on the right (market stall, book cart, notice board with little jobs and favours, later the Import Broker).
- **Tap a place → a sheet slides up** with what to build there, its stations and recipes, its animals and its polish. Unbuilt places show 🔒 and what opens them.
- **Signs on places:** 🔨 build, 🧺 animals ready, ❓ card quiz, 📖 card to read, 🍂 going stale, ⏳ cooking, 😴 tired.
- **Bottom bar:** the next story goal (tap → the map jumps there and the place glows) and the ❓ Time Quiz button.
- **Animals and pets** walk around their places; the fence around the field shows its level.
- **Font:** Andika (SIL), made for beginning readers; emojis from Noto Color Emoji on every device.

Each data node belongs to one place through its `slot` (`scripts/spots.gd`). *(1.3.2: where the places stand now comes from `data/map_layout.json` and the layout editor, §37.20.)*

**Browser version.** Godot exports the game as a web page (`web-build/`, single-threaded, installable to the Home Screen, portrait). Any free HTTPS host works (Netlify Drop, Cloudflare Pages, GitHub Pages, itch.io). On the iPad: open the link in Safari → Share → Add to Home Screen. Saves stay in that browser. First download about 50 MB (about 15 MB compressed).

**Art pipeline.**
- **Style:** C, bold cartoon (thick rounded outlines, flat colours, chunky proportions, three-quarter top-down view).
- **Making them:** generated with OpenArt (Nano Banana 2) as 3×3 sprite sheets on white, with the first sheet as the style reference so everything matches.
- **Into the game:** `tools/import_art.py` cuts sheets into transparent sprites and makes seamless ground tiles.
- **File names:** follow the data ids (`assets/map/tent.png`, `assets/tiles/grass.png`, `assets/animals/animal_chicken.png`). A missing picture shows the emoji; an upgrade without its own picture keeps the previous one.
- **To-do list:** `art-inbox/ART_LIST.csv` lists every picture in the order worth drawing, with prompts (105 in total, 32 done as of 1.3.2; about 30 make chapter 1 look finished).

### 37.20 The map seen at an angle (isometric), the layout editor and the shadows *(1.3.2)*

**Why.** Most pictures are drawn in a three-quarter view: buildings show their front and roof, weeds sit in a squashed diamond. On a
square, top-down grid those pictures leave empty corners and look like they float. Farm games with this look (Hay Day, FarmVille,
Township) solve it the same way, and the prototype now does too:
- the **ground is a diamond grid** (2:1 isometric: a tile is twice as wide as it is high);
- every picture has **feet** — the bottom middle of the picture — and is placed by its feet, not by a box;
- a picture may **reach up** over whatever is behind it; things are drawn **from the top of the screen down**, so what stands lower is in front;
- only a picture's **visible pixels** react to taps (and the name label under it), so a tall roof never steals a tap from the place behind.

**What it looks like now.**
- **Field:** 3×3 diamond patches that fit into each other, on a soft shadow, with the fence drawn as a diamond around it when built.
  Patch pictures: `soil_heap` (empty or growing), `sprout_patch` (just planted), `overgrown_patch` (not cleared yet); weeds and stones
  sit on the patch. Crop icons and the "tap to plant / ⏳ / ✅ Ready!" pills are drawn **above every patch**, so tall weeds in front
  never hide them. Only the diamond itself reacts to a tap. ◀ ▶ under the field switch fields.
- **Home Field signpost** next to the field opens clearing land, better patches, scarecrow and fence (so does tapping an overgrown patch).
- **Places** stand on their feet with their name under them; unbuilt places show their empty lot with 🔒.
- **Forest edge** is the same grass, shaded darker, with trees; the **village road** runs down the right side.
- The **orchard and greenhouse** still use the square patch grid inside their sheets (open: give them diamond rows too).

**Layout as data.** Where everything stands and how big it is lives in `godot-prototype/data/map_layout.json`:
places (`x`, `y` = feet, `w` = width; the height follows the picture), the field (middle and tile width), the scarecrow, the field
buttons, forest width, road position and a list of decorations (trees, bushes, stones, flowers). No code change is needed to move things.

**Layout editor.** A page where pictures are dragged and resized by hand, starting from the current layout:
- online: *Farm Map Layout* — https://claude.ai/artifact/U7XSKLW8GcAacyAx1Uh7uV — with **Send to Claude** (Claude then puts the
  layout into the game and rebuilds the web version);
- offline: `godot-prototype/tools/layout-editor.html` — **Copy as text** or **Download layout file**;
- it can show the farm as on day one (empty lots), a diamond grid, and every picture's feet; it has Undo and remembers unsent changes;
- rebuild it after new pictures: `python3 tools/make_layout_editor.py`.

**Shadows.** The image generator draws light grey shadows (about `#b6b3b4`) meant for a white page; on grass they looked lighter than
the ground. The sprite cutter (`tools/import_art.py`) now turns grey that touches the white background into a **see-through dark blue**
(`#161e4a`; darker grey → stronger, at most half see-through). The shadow then darkens whatever it falls on — grass, path or snow —
like a real one. All current pictures were cut again this way (`python3 tools/import_art.py all`).

**Art to come.** New pictures should be drawn in the same three-quarter view, standing on a flat base whose footprint is a diamond
about twice as wide as deep, with the shadow falling down-right. `art-inbox/ART_LIST.csv` has the list and prompts.

---

## 38. Appendices

### Appendix A — Starting State: Target vs. Current

| Value | Target (Primer, prioritized) | Current prototype |
|---|---|---|
| Coins | 0 | 200 *(testing convenience)* |
| Wheat seeds | 5 *(Decision)* | 5 |
| Water | — | 8 |
| Water capacity | — | 20 |
| Energy | — | 10 |
| Energy max | — | 20 |
| Living Quarters | Tent | Tent |
| First recipe available | Porridge (Fire + Tin Pot) | Bread (Farmhouse) |
| Digging tool | Hands | Hands (conceptual) |
| Plots | 9 barren (original concept) | 12 (9 ordinary + 3 reserved) |
| Well | Functional, level 1 | Functional, level 1 |
| Marketplace | Present, mostly locked | Present, seeds only |

### Appendix B — File Responsibilities

```text
farm-game-main.html
    ├── Farm layout
    ├── Top bar
    ├── Animal slots
    ├── Field slots
    ├── Building slots
    ├── Quiz modal
    └── Generic UI modal

farm-game-style.css
    ├── Layout
    ├── Responsive structure
    ├── Cards/buttons
    ├── Modals
    ├── Requirement bars
    ├── Crop animation
    └── Animal wandering animation

farm-game-config.js
    ├── Crops
    ├── Recipes
    ├── Well levels
    ├── Action costs
    ├── Product prices
    └── Starting state

farm-game-core.js
    ├── Save/load
    ├── Time advancement
    ├── Rendering
    ├── Farming
    ├── Pantry
    ├── Market
    ├── Animals
    ├── Crafting
    ├── Well
    ├── Training
    └── Event wiring

farm-quiz-engine.html
    ├── Time Quiz question bank
    ├── Answer handling
    ├── Feedback
    ├── Next question
    └── Farm communication via postMessage
```

### Appendix C — Full Recipe Template Catalog *(reinstated from Primer, in full)*

> **Superseded in 1.1** by the concrete recipe list in `progression/farm-progression.json` (94 recipes, browsable in the explorer). The template idea survives as `tag:` inputs ("any vegetable", "any oil"). Kept here for reference.

**Bread and Dough**
- Bread (basic): [grain:milled] + water + yeast; Oven L1
- Enriched Bread: [grain:milled] + water + yeast + [fat-source]; Oven L2; Iron Knife+
- Flatbread: [grain:milled] + water + [fat-source:optional]; Stove L1 or Oven L1
- Pizza Dough: [grain:milled] + water + yeast + oil; Prep L1 (assembly), Oven L2 (bake)

**Cakes and Baked Sweets**
- Simple Cake: [grain:milled] + [sweet] + [dairy] + egg; Oven L1
- Honey Oat-style Cake: [grain:milled] + honey/sugar + [dairy] + egg + [spice:optional]; Oven L2
- Berry Cake: [grain:milled] + [sweet:berry jam or sugar] + [dairy] + egg; Oven L2

**Pasta and Noodles**
- Basic Pasta: [grain:milled] + water + egg; Prep L1 (dough) + Stove L1 (boil)
- Buttered Pasta: pasta + butter + [aromatic:optional]; Stove L1

**Soups and Stews**
- Vegetable Soup: [vegetable] + [aromatic] + water + salt; Stove L1
- Legume Stew: [legume:cooked] + [vegetable] + [aromatic] + water + salt; Stove L2
- Tomato Soup: tomato + [aromatic] + water + salt; Stove L1

**Sauces and Purees**
- Tomato Sauce: tomato + [aromatic] + salt; Stove L2; Iron Knife+
- Vegetable Puree: [vegetable] + [fat-source:optional]; Processor L1 or Stove L1
- Tapenade (if olives): olives + oil + salt; Processor L1; requires prior aging/curing of olives

**Roasted and Baked Vegetables**
- Roasted Vegetables: [vegetable] + oil + salt; Oven L1
- Baked Potato: potato + oil + salt; Oven L1
- Caramelized Onions: onion + [fat-source]; Stove L2 or Oven L2

**Salads and Sandwiches (Prep Station)**
- Simple Salad: [leafy-green] + [vegetable] + oil + vinegar + salt; Prep L1
- Nut-Seed Salad: [leafy-green] + [vegetable] + [nut-seed] + oil + vinegar; Prep L1
- Sandwich (template): bread + [leafy-green] + [vegetable] + [fat-source or spread] + [protein-rich:optional]; Prep L1
- Yogurt Bowl: yogurt + [sweet] + [fruit/berry]; Prep L1

**Spreads and Butters**
- Nut/Seed Butter: [nut-seed]; Processor L1
- Mashed Bean Spread: [legume:cooked]; Processor L1 or Stove L1 (soften)
- Mayo (vegetarian emulsion): oil + yogurt or plant-based binder; Processor L2

**Preserves and Pickles**
- Jam: [berry/fruit] + sugar + heat; Stove L1
- Pickles: [vegetable:pickleable] + vinegar + salt; Prep L1 (assembly) + optional Aging Station maturation
- Dried Fruit: [fruit/berry]; Oven L1 (low heat) or Aging (optional)

**Dairy Conversions**
- Butter: milk → butter; Churn L1–L3
- Yogurt: milk + yogurt culture → yogurt; Fermenter L1–L3
- Cheese (fresh): milk + cheese culture → cheese; Cheese Station (requires Press)
- Aged Cheese: fresh cheese → Aging Station, N questions; unlocks advanced recipes

**Oils, Juices, Sugar**
- Oil: [nut-seed:pressable-oil]; Press L1
- Juice: [fruit/root:pressable-juice]; Press L1
- Sugar/Syrup: beet → sugar/syrup; Press L1 + Stove L1 (if a reduction step is needed) — *see §8.4/§31 for the unresolved Beet-vs-Sugar-Carrot naming question*

**Vinegar and Curing**
- Cider: apple juice → ferment; Fermenter/Aging, N questions
- Vinegar: cider → age; Aging Station, N questions
- Cured Olives (if olives): raw olives + brine → Aging, N questions; unlocks olives for prep, tapenade, pizza

**Honey and Wax**
- Honey: Honey Extractor L1–L3; Bee Area
- Beeswax: Beeswax Extractor (higher level); Bee Area

**Pizza and Assemblies (multi-step example)**
- Pizza: dough + tomato sauce + [dairy:cheese] + [vegetable:optional]; Oven L2; requires a built Cheese Station and unlocked Tomato Sauce; Iron Knife+ for toppings

*Note: every template carries tool/appliance prerequisites. Higher-tier variants require Iron/Steel Knife or higher appliance levels (Stove L2+, Oven L2+, Prep L2+) and may require prior conversions (flour via Mill, oil via Press).*

### Appendix D — Appliance–Tag Compatibility Table

*(Duplicate of §9.5, reproduced here for standalone reference alongside Appendix C.)*

| Appliance | Compatible tags |
|---|---|
| Stove | cookable, fermentable (heat step), mashable, pureeable (if processor not required) |
| Oven | bakeable, roastable |
| Prep Station | raw-edible, assembly-only components |
| Food Processor | pureeable, nut-seed (butters), small-batch milling (early only) |
| Press | pressable-oil, pressable-juice, pressable-sugar |
| Mill | millable (grains, nuts/seeds for flours) |
| Churn | dairy (milk → butter) |
| Fermenter | fermentable + culture-agent (yogurt, cultured cheese prep) |
| Aging Station | age-able (cheese, vinegar, honey, cured olives) |

### Appendix E — Status Label Definitions

See "How to read this document" at the top of this file for the full definitions of Implemented, Partially Implemented, Placeholder, Conceptual/Planned, Dormant, and Inferred.

### Appendix F — Source and Confidence Notes

**High confidence** (repeatedly established, or directly represented in the prototype): medieval rebuild-a-farm premise; five secret vegetarian pets; dishes as key progression objectives; quiz-driven time; the Time/Training energy split; water as a core resource; sell/save choice; single-screen farm; contextual modals; four animal types; 3×4 field layout; the five-file architecture; placeholder-art strategy; animal wandering; the corrected Porridge → Bread sequence; the 5-decision resolutions in §30.

**Medium confidence / design direction** (established conceptually, needs balancing or final spec): exact machine progression; exact final recipe graph beyond Appendix C's draft; precise tool effects; detailed pet behavior/reveal structure; merchant unlock timing; final economy formulas; exact reward tables.

**Dormant** (specified once in the Primer, not reaffirmed since — see §32 for the full index): avatar system, NPC hints, bee pollination/biodiversity, pixie mini-game, manure, barter purchasing, raw material tiers, scarecrow's mechanical effect, tool mechanical effects.

**Explicitly inferred**: the target audience being children (§1.2); the four-tag-set reconstruction (§9.8); a deeper modular data schema for all content types; formal save-state migration strategy; the phased roadmap sequencing.

### Appendix G — Asset and Reference Links

See §17.7–17.8 above.

---

# End of Document
