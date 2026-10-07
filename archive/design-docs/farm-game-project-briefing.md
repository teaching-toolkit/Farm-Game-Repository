# Farm Quiz Game — Comprehensive Project Briefing

**Document purpose:** A consolidated briefing of the game's vision, design, systems, prototype architecture, current implementation status, known gaps, and likely roadmap.

**Basis:** This document synthesizes the design primer established during the conversation, the iterative prototype decisions and testing feedback, and the latest five-file prototype snapshot available in the conversation workspace. It intentionally distinguishes established design decisions from current implementation and from forward-looking inference.

**Prototype snapshot referenced:**
- `farm-game-main.html`
- `farm-game-style.css`
- `farm-game-config.js`
- `farm-game-core.js`
- `farm-quiz-engine.html`

> **Important status note:** The conversation contains some requests made after the latest concrete five-file snapshot—especially the seed quantity bar, conversion time bar, Time Quiz clock icon, Training/energy-bar merge, and making conversion/pantry cards fully clickable. The snapshot currently available does not contain all of those later changes, so this briefing marks them as **pending** rather than assuming they were successfully implemented.

---

## 1. Executive Summary

This project is a **medieval farming-and-crafting game built around quiz-driven time progression**.

The player starts with a devastated farm and gradually rebuilds it. The long-term objective is not simply to become wealthy or reach an arbitrary level. The farm is a means to a more mysterious end: **five secret vegetarian pets are waiting to return home, and the player must discover and cook the dishes that coax them back.**

The core design deliberately combines several normally separate genres and learning activities:

- a light farming / resource-management game;
- a crafting and production-chain game;
- a puzzle of opportunity costs and resource allocation;
- a sustainability lesson, especially around water;
- light arithmetic and quick-recall practice;
- a discovery/progression game built around recipes, ingredients, tools, machines, and hidden goals.

The distinctive mechanic tying everything together is **time**. Instead of time simply passing in real time, the player advances farm time primarily by answering a **Time Quiz**. A correct quiz answer moves the farm forward by one question-step. That advance grows crops, produces passive resources such as water, and refreshes animal production cooldowns.

The second quiz type is the **Training Quiz**, which is separate conceptually from time. Training is a quick-recall energy mini-game. A correct answer restores energy; a wrong answer or a timeout gives nothing. The current prototype uses a three-second response window.

The intended experience is therefore:

> **Answer → time advances → farm produces/grows → make choices about limited water, energy, seeds, animals and ingredients → harvest/convert/craft → sell or save → unlock something new → repeat → eventually solve the pet-dish mystery.**

The prototype already demonstrates a meaningful slice of this loop. It has a single-screen farm, 12 central planting patches, four animal areas, a market, a farmhouse/recipe interface, pantry/inventory, a working Well, crop growth, harvesting, several animal converters, simple crafting, persistence through local storage, a separate Time Quiz engine, a Training Quiz, requirement bars, and rudimentary animal wandering.

However, the prototype is still a **vertical-slice foundation rather than the finished game**. Most of the deeper content system described in the design primer—full crop catalog, rich production chains, tools, workshops, storage progression, aging, machine progression, recipe-tag logic, marketplace categories, five pet goals, random reward chests, greenhouse, scarecrows, and complete educational progression—remains ahead.

---

## 2. What This Game Is Really About

### 2.1 The player fantasy

The fantasy is **rebuilding something ruined by making sensible choices from scarce resources**.

The farm begins in a poor, stripped-down state. The player must work from basic materials and gradually establish a production ecosystem. The player is not handed a fully developed farm and asked only to optimize it. The player constructs the chain from the bottom up.

This matters because the intended satisfaction is not merely:

> "I harvested a crop."

It is:

> "I figured out how to turn a handful of resources into something valuable, and that unlocks the next part of my farm."

That chain should eventually become quite deep:

**seed → crop → animal/processing input → intermediate ingredient → processed ingredient → recipe → finished dish → pet/progression key**

with water, energy, time, tools, and coins acting as competing constraints.

### 2.2 The hidden narrative goal

The five secret vegetarian pets are the game's central long-term mystery.

The player does not begin with a giant progress tree announcing every pet and every requirement. Instead, recipes, ingredients, appliances, tools, and marketplace content gradually reveal what is possible. Ultimately, the player learns how to create the dishes that matter.

This gives the game a stronger reason to exist than an endless production treadmill. The farm is being rebuilt **for someone—or something—to come home to**.

### 2.3 The educational goal

The educational layer is not intended to feel like a detached school exercise pasted onto a farm game. The goal is to make learning mechanics part of the game's economy and rhythm.

The stated aims include:

1. **Resource planning** — deciding where scarce resources should be spent.
2. **Opportunity cost** — saving an item for a future recipe may be more valuable than selling it immediately.
3. **Sustainability, especially water** — water is intentionally central and visible.
4. **Light arithmetic using two-digit numbers** — especially in quick training/recalculation tasks.
5. **Quick-recall practice** — the Training Quiz uses short response windows and repeated question exposure.

The player should ideally learn the economic logic of the farm because the farm itself makes that logic visible.

---

## 3. Core Design Principles

Several principles have emerged consistently across the conversation.

### 3.1 The farm should stay on one screen

The primary farm view is a **single-screen overview**. The player should see the farm rather than repeatedly navigating through different pages or scenes.

Detailed actions open contextual modals. This keeps the farm visually present while allowing the underlying systems to become richer without creating a complicated navigation hierarchy.

### 3.2 Minimal text, strong visual signals

The intended UX favors:

- icons;
- numbers;
- compact requirement bars;
- visible locks;
- short labels;
- contextual modals;
- simple cause/effect interactions.

The game should communicate most routine decisions visually rather than through long explanatory paragraphs.

### 3.3 Water is a strategic resource, not just a decoration

Water sits near the top of the interface and appears repeatedly in action requirements.

The Well produces water when quiz-driven time advances. Farming consumes water. Animal conversions consume water. That means every extra crop or animal indirectly competes for the same sustainable resource loop.

The intended lesson is not just "water exists". It is:

> **Every choice that uses water reduces what is available for another choice.**

### 3.4 Energy is for actions; training is how you replenish it

Manual actions consume energy.

Examples already represented in the prototype include:

- planting;
- harvesting;
- animal conversion;
- crafting.

Training is deliberately separated from Time Quiz. A Time Quiz advances the world but **does not give energy**. The Training Quiz is where the player replenishes energy through quick recall.

This creates a second resource loop:

**use energy → become energy-constrained → do quick training → restore energy → continue working**

### 3.5 The player should be able to choose between cash now and value later

A recurring interaction pattern is:

> **Sell now** or **save to pantry**.

This appears after harvesting, animal conversion, and crafting.

It is a foundational expression of opportunity cost. Immediate money may help buy seeds or animals, while saving an ingredient may unlock a more valuable recipe later.

### 3.6 Dependencies should be visible at the moment they matter

The design calls for dependencies to be shown **when an item is being unlocked or built**, but not to clutter the permanent interface.

Once something is unlocked, the system should show only the **immediate inputs** needed for the next action.

This is a key anti-clutter principle:

- unlock screens can explain prerequisites;
- routine action screens should stay local and understandable.

### 3.7 Upgrades should replace prior tools/items rather than create arbitrary parallel clutter

Tool and station progression is intended to be evolutionary.

For example:

**Hands → Wooden Shovel → Iron Shovel → Steel Shovel**

The player is not meant to manage four shovels forever. The new one replaces the old one as the active tool.

Likewise, production responsibilities migrate when the farm becomes more sophisticated. Flour may begin in one interface, then later move to a dedicated mill in the Workshop/Windmill system.

---

## 4. The Intended Core Loop

The complete intended loop can be described as seven steps.

### Step 1 — Answer the Time Quiz

The player answers a knowledge question.

A correct answer advances the farm's time state by one question.

That single time step can simultaneously:

- grow crops;
- trigger passive building production;
- refresh animal cooldowns;
- increase the quest/progression state represented by answered questions;
- produce water through the Well.

Importantly, the Time Quiz does **not** directly award energy.

### Step 2 — Inspect the changed farm

After the time advance, the player sees that things have moved:

- crops are closer to harvest;
- water has been produced;
- animals may be available again;
- passive systems have generated their outputs.

This makes the quiz answer feel like a meaningful game action rather than a detached educational interruption.

### Step 3 — Harvest and choose what to do with the output

When a crop is ready, the player harvests it.

The intended immediate choice is:

- **sell it for coins now**, or
- **save it to the pantry** for later crafting or unlocking.

The action consumes energy.

### Step 4 — Convert raw materials through animals and machines

Plants can be used as inputs for animal areas or processing stations.

The current prototype includes simplified animal conversion examples such as:

- wheat + water + energy → eggs;
- wheat + water + energy → milk;
- wheat + water + energy → wool;
- wheat + water + energy → honey.

These are intentionally simplified placeholders for the richer final production chains.

### Step 5 — Craft finished goods

Finished recipes consume ingredients and energy.

The player again chooses whether to:

- sell immediately;
- save the crafted product for a later recipe or goal.

The final design expands this into a much larger recipe and processing graph.

### Step 6 — Spend coins and materials on progression

Coins are intended to come primarily from **selling outputs**, not from simply answering quiz questions.

The player can use money to:

- buy seeds;
- buy animals;
- upgrade the Well;
- unlock/build production facilities;
- buy tools;
- obtain future marketplace items;
- expand storage and other systems.

### Step 7 — Progress toward secret dishes and pets

The long-term objective becomes increasingly visible through unlocked recipes, ingredients, tools, and stations.

Eventually the player creates the necessary dishes and unlocks/reunites the five hidden vegetarian pets.

---

## 5. The Two Quiz Systems

## 5.1 Time Quiz

The Time Quiz is the game's central time engine.

Current prototype behavior:

- it is embedded in the farm through `farm-quiz-engine.html`;
- it selects a random question from a small question bank;
- an incorrect answer shows feedback but does not advance time;
- a correct answer sends a message back to the farm;
- the farm increments `questionsAnswered`;
- all planted crops gain one growth unit;
- the Well adds water up to capacity;
- the game saves the result.

The current question bank is deliberately themed around the game's learning goals. Example subject matter includes water use, plant growth, saving ingredients, and the relative resource demands of plants versus animal products.

The current quiz engine also supports a **Next Question** action and a **Close Quiz** action.

### Important future direction

The Time Quiz should become a much stronger educational engine rather than staying as a four-question proof of concept. The intended direction is a real question bank with:

- better coverage;
- progression in difficulty;
- repetition rules;
- curriculum/topic tagging;
- potentially multiple question types;
- questions tied more deliberately to the farm's actual systems.

### Design constraint

Time Quiz should remain a **time mechanic**, not an energy faucet.

This distinction was explicitly corrected during prototyping and should remain a permanent rule.

---

## 5.2 Training Quiz

Training is the quick-recall mini-game that restores energy.

Current prototype behavior:

- generated arithmetic question;
- three answer choices;
- three-second response window;
- correct answer gives +5 energy, capped at energy maximum;
- incorrect answer gives 0;
- timeout counts as wrong and gives 0;
- result appears in the same modal flow;
- player can continue to the next question or close.

The current arithmetic is simple addition with small numbers. The broader design goal is **two-digit light arithmetic and rapid recall**, so the current generator is an early test rather than the final curriculum.

### Spaced-repetition intent

The original design specifically calls for spaced repetition:

- correct answers become less frequent;
- incorrect questions recur soon.

The current prototype does not yet implement a robust spaced-repetition scheduler. That belongs to the quiz-engine roadmap.

### Intended UX direction

Training was later requested to be **merged into the Energy indicator** rather than occupying a separate button.

The planned interaction is:

> **Tap the Energy indicator → start Training Quiz.**

That would make the resource itself the entry point to its replenishment mechanic and simplify the top bar.

The current five-file snapshot still has a separate `Training` button, so this merge remains pending.

---

## 6. Resource Economy

The game's economy is built around a small number of highly legible resources that eventually expand into a richer production system.

### 6.1 Coins

Coins are the main purchasing currency.

The fundamental rule is that coins come from selling outputs rather than directly from answering quiz questions.

Coins are spent on things like:

- seeds;
- animals;
- Well upgrades;
- future buildings, tools and machines;
- marketplace progression.

The current prototype starts with **200 coins** to make testing easier. This is a testing convenience rather than the intended final opening economy, which was originally centered around a much poorer starting state.

### 6.2 Water

Water is a finite capacity resource produced by the Well.

Current prototype Well levels:

| Well level | Water per Time Quiz | Capacity |
|---|---:|---:|
| 1 | +2 | 20 |
| 2 | +4 | 30 |
| 3 | +6 | 40 |

The Well upgrade cost currently increases from the free starting level to coin-paid higher levels.

Water is consumed by:

- planting;
- animal conversion;
- future processing/crafting actions.

The final game is intended to make water a much stronger strategic system.

### 6.3 Energy

Energy is a manual-action resource.

The original design establishes a starting cap of 20 under the Tent, eventually increasing to 30 in a Cottage and 50 in a Farmhouse.

The current prototype has:

- starting energy 10;
- maximum energy 20;
- planting cost 1;
- harvesting cost 1;
- conversion costs depending on the animal;
- crafting cost depending on the recipe;
- +5 from a successful Training Quiz.

Energy is deliberately not granted by Time Quiz.

### 6.4 Seeds

Seeds are not meant to be just another pantry item in the permanent UI. They are primarily bought through the Market.

The current prototype tracks seed inventory separately for each crop.

A key UX requirement that emerged during testing is that **seed quantity should be visibly represented with a requirement/progress bar**, not only as a number. That bar is currently pending in the latest concrete snapshot.

---

## 7. Farming System

### 7.1 Current field layout

The current prototype uses **12 central planting patches arranged as a 3 × 4 grid**, with no gaps between them.

The first nine are normal field patches; the remaining three are marked as special/reserved patches for later building or feature use.

This is a later evolution of the earlier 9-plot concept in the design primer. The 12-patch layout is the more recent spatial decision and therefore the relevant one for the prototype direction.

### 7.2 Planting

Planting currently requires:

- one seed;
- crop-specific water;
- one energy.

The planting modal shows:

- crop icon;
- seed quantity;
- water requirement;
- energy requirement;
- growth time in quiz questions.

The current code already attaches the click handler to the **whole field plot**, so a player can tap the plot itself rather than only a small button to open the planting flow.

The remaining UX issue is broader: the game should consistently use whole-card/whole-area click targets for related actions, especially the conversion and pantry interactions.

### 7.3 Crop growth

Growth is currently modeled as a simple integer increased once per successful Time Quiz.

The visual prototype uses emoji growth stages:

- early growth → sprout;
- later growth → crop emoji;
- ready → larger/pulsing crop.

This is explicitly temporary. The long-term plan is to replace the emoji representation with proper PNG crop-stage art supplied by the user.

The design goal is for crops to grow **in the middle of the dirt patch**, using straightforward scaling rather than clipping a plant out of the bottom of an image.

### 7.4 Crop set

The prototype currently contains three crops:

- Wheat
- Carrot
- Tomato

The broader canonical crop list established in the design primer is considerably larger:

- wheat
- tomato
- potato
- onion
- carrot
- beet
- lettuce
- beans
- olive
- walnut
- apple
- berries
- flax

Lettuce was specifically established as a canonical crop/tag item.

Thus the current crop system is intentionally a **small content test set**, not the final farm catalog.

### 7.5 Tomato unlock example

The tomato is currently a useful demonstration of the intended progression style.

It is visible as locked until the player accumulates the required egg quantity. The current implementation uses:

> **2 eggs → unlock tomato seeds once**

After unlocking, tomato seeds become purchasable with coins.

This is a prototype for a broader design in which ingredient/tag combinations and progression conditions reveal additional farm content.

---

## 8. Harvesting, Selling, and Pantry Decisions

A major UX pattern is the player's immediate choice after production.

### Harvest

When a crop is ready, the player harvests it.

The current prototype then offers:

- Sell now for coins;
- Save to pantry;
- Cancel.

The harvest action consumes energy.

### Animal products

The same pattern appears after animal conversion:

- Sell product now;
- Save to pantry.

### Crafted goods

The bread recipe also uses the same pattern:

- Sell now;
- Save to pantry.

### Pantry

The pantry is currently presented as a compact inventory UI reachable through the Storage building slot.

It groups items into:

- raw crops;
- animal/bee products;
- crafted goods.

The current prototype supports selling all currently shown pantry outputs.

A later UX request was explicit:

> Make the **whole pantry item card clickable** for selling, rather than requiring the user to hit the small Sell button.

That change is not present in the current concrete snapshot and should remain on the immediate UX backlog.

---

## 9. Animal System

The intended final game has four major animal areas:

1. Chicken
2. Cow
3. Sheep
4. Bee

The current prototype already has all four spatial areas.

### 9.1 Chickens

Current simplified conversion:

**3 Wheat + 3 Water + 1 Energy → 1 Egg**

Each chicken can convert only once per question-step. After conversion, the chicken must wait for another Time Quiz question.

Chickens can be bought for coins and have an area capacity.

### 9.2 Cows

Current simplified conversion:

**4 Wheat + 4 Water + 2 Energy → 1 Milk**

The current interface explicitly hints at future milk processing:

- butter;
- yogurt;
- cheese.

The final production chain is intended to become much more sophisticated than the current direct milk output.

### 9.3 Sheep

Current simplified conversion:

**3 Wheat + 3 Water + 1 Energy → 1 Wool**

The intended future direction is closer to:

**shearing → thread → weaving → textiles**

with weaving eventually living in the Workshop once the relevant Textile Machine/Loom system exists.

### 9.4 Bees

Current simplified conversion:

**2 Wheat + 2 Water + 1 Energy → 1 Honey**

The final system is intended to involve dedicated extraction tools/stations, including honey and beeswax processing.

### 9.5 Animal cooldown principle

The design uses question-based cooldowns rather than real-time timers.

This is important because the game's master clock is the quiz-driven question count. The farm does not need an independent real-time simulation clock.

### 9.6 Animal visualization

A particularly successful prototype improvement is simple animal wandering.

The current implementation:

- creates one emoji per owned animal/colony;
- places them within their own animal tile;
- gives them a small bob animation;
- periodically moves them by a small random amount;
- clamps them to an interior region of the field.

This was explicitly tested and reported as working well.

The eventual implementation should replace these emoji placeholders with proper animal art while preserving the same lightweight wandering concept.

### 9.7 Animal-area click behavior

The whole animal field currently opens the relevant animal modal, which is good for the broad interaction model.

However, **conversion within the modal is still button-based**. A later request was to make the whole conversion row/field clickable, matching the whole-card interaction philosophy used elsewhere.

That remains pending.

---

## 10. Crafting and Recipes

### 10.1 Current recipe system

The current prototype has one recipe:

**Bread**

with:

- 3 Wheat;
- 1 Energy;
- a fixed sell value.

The recipe appears through the Farmhouse/Recipe Book interface.

### 10.2 Intended recipe system

The final game is intended to be much more data-driven and modular.

A recipe can be unlocked once the player possesses the appropriate ingredient tags and appliance/tool prerequisites.

The recipe system should support:

- ingredient tags;
- process tags;
- function tags;
- appliance compatibility tags;
- multi-step assembly;
- different processing stations;
- persistent unlocked recipes even when ingredients are temporarily depleted;
- future/unseen recipes shown as locks when they are theoretically unlockable.

### 10.3 Appliance-first kitchen UX

The kitchen is meant to organize recipes around **the appliance or processing station first**, rather than forcing the player to scan one giant recipe list.

Planned kitchen appliances include:

- Stove
- Oven
- Prep Station
- Food Processor

Preservation/aging is associated with Storage rather than being another kitchen appliance category.

### 10.4 Example future chain: vinegar

The design establishes a deliberately multi-step example:

**juice → cider → vinegar → aging/processing**

The purpose is to show that the crafting system should eventually handle transformation chains rather than only one-step recipes.

### 10.5 Pricing philosophy

Prices are intended to emerge from the value and complexity of ingredients and processing rather than being arbitrary numbers attached to every final item.

The design mentions:

- ingredient value;
- processing multipliers;
- rarity;
- complexity.

The current prototype still uses straightforward fixed prices, so the economy is only a placeholder for the eventual pricing model.

---

## 11. Workshop and Production Infrastructure

The Workshop is supposed to become the technical heart of later-game production.

Planned stations include:

- Bulk Mill
- Textile Machine / Loom
- Pressing Machine
- Metalworking Station

The conversation also established that some production responsibilities should **migrate** to the logical station as the player upgrades.

A clear example is flour:

- early implementation may expose grinding in a simpler kitchen-like context;
- later, flour production belongs in a dedicated mill/workshop station.

This should feel like technological progression rather than duplicate menus.

### Current status

The current Workshop is a placeholder UI. It tells the player that future machines will live there but does not yet run the final machine systems.

A Windmill slot is also present as a placeholder for the future main flour mill.

---

## 12. Tools and Action Slots

The final design has distinct tool categories, each with upgrade progression.

### Digging

**Hands → Wooden Shovel → Iron Shovel → Steel Shovel**

Affects planting/plots and energy efficiency.

### Cutting

**Stone Knife → Iron Knife → Steel Knife**

### Hammering

**Rock → Iron Hammer → Smith's Hammer**

### Woodworking

**Hand Axe → Saw → Master Saw**

### Watering

**Wood Can → Crude Metal Can → Steel Can → Sprinkler**

The exact mechanical effects beyond the general intent still need implementation and tuning. The important design direction is clear: better tools should change what the player can do and/or reduce the resource burden of routine actions.

### Current status

The current prototype has only the conceptual beginnings of this system. No full tool inventory or upgrade UI is active yet.

---

## 13. Buildings and Farm Infrastructure

The intended building ecosystem includes several distinct categories.

### Living Quarters

**Tent → Cottage → Farmhouse**

Energy capacity rises with the upgrade:

- Tent: 20
- Cottage: 30
- Farmhouse: 50

The Farmhouse also becomes important as the player's Recipe Book interface.

### Workshop

Three conceptual tiers:

- Basic
- Advanced
- Master

### Storage

Progression concept:

**None / bag / box → Shed → Barn → Warehouse**

Storage eventually houses systems such as:

- Aging Station
- Cellar

### Well

The Well is the first fully active building in the prototype and already has upgrade mechanics.

### Lumbermill

Intended passive production:

- produces wood per question;
- upgrades production rate;
- eventually produces harder/more valuable wood types.

The current prototype's Windmill placeholder points toward a mill-style production system but does not yet implement the full planned infrastructure.

### Marketplace

The Marketplace is an interface rather than a conventional resource-production building. It is not intended to be a normal upgradeable building in the same way as the Workshop or Well.

### Greenhouse

A mid/late-game system, eventually occupying one of the reserved special areas/slots.

### Scarecrow

Progression:

**Stick → Dressed → Guardian**

The precise gameplay effect still needs to be implemented.

---

## 14. Marketplace and Unlock Economy

The Marketplace is one of the game's progression engines.

The intended structure includes multiple merchant categories, such as:

- Seed Merchant
- Spice Merchant
- Culture Specialist
- Raw Materials Merchant
- Import Broker
- Avatar Accessories Shop

The marketplace should not overwhelm the player with impossible options. Locked content should be shown only when it is **theoretically unlockable** according to the design rules.

The current prototype implements only a small piece of that system:

- wheat and carrot seeds are available;
- tomato seeds appear locked;
- tomato is unlocked by paying the specified egg requirement once;
- once unlocked, tomato seeds can be bought with coins.

This is a good proof of the intended lock/unlock pattern, but not yet the marketplace architecture.

---

## 15. Progression Philosophy

The game intentionally does **not** use a conventional XP/level progression bar.

There is no planned:

- character level 12;
- XP meter;
- permanent top-of-screen progress bar;
- giant tech-tree screen.

Instead, progression is embodied in the farm itself.

The player becomes more capable because they obtain:

- better tools;
- better buildings;
- new machines;
- new crops;
- new animals;
- new recipes;
- new production chains;
- more storage;
- more water capacity;
- better passive production;
- access to later merchants.

The player should therefore be able to **read their progress from what they can now do** rather than from an arbitrary numerical level.

---

## 16. The Pet Goal Structure

The five secret vegetarian pets are the intended narrative and mechanical destination.

The pet system is not yet implemented in the current prototype, but the rules established so far imply the following structure:

1. Pets are hidden/semi-hidden goals rather than the first thing shown to the player.
2. Their dishes are the meaningful keys.
3. Recipes and ingredient chains reveal the path.
4. Marketplace and processing unlocks supply missing pieces.
5. The player must manage resources carefully enough to assemble the final dishes.
6. Completing the relevant food objectives brings the pets home.

This structure gives the game a natural ending/progression arc without resorting to an XP level grind.

A future pet implementation should preserve the feeling of **discovery** rather than turning the entire game into a checklist from the beginning.

---

## 17. Random Reward / Chest System

The broader design includes a random reward mechanic:

- after a successful Time Quiz, there is intended to be a 20% chance of receiving a chest;
- common rewards can include seeds or coins;
- uncommon rewards can include a newly unlocked-but-not-yet-purchased seed;
- rare rewards can include variants or cosmetics.

This is currently not represented as a complete functioning system in the prototype snapshot.

The purpose of the mechanic is to add surprise without replacing the main economy. It should complement, not undermine, planning.

---

## 18. Visual and Layout Direction

The visual direction has been strongly constrained by usability and eventual asset replacement.

### 18.1 Single farm composition

The farm screen is divided into three major visual bands:

1. **Top bar** — resources and quiz access;
2. **Animal row** — four animal areas;
3. **Central crop area** — 3 × 4 planting grid;
4. **Bottom building rows** — eight building slots across two rows.

The central field is the visual heart of the farm.

### 18.2 No gaps between adjacent terrain/background tiles

A repeated design requirement is that adjacent image-backed areas should visually touch.

The current farm grid uses zero gaps. Animal tiles and building rows also use adjacent cells.

The intent is that the eventual PNGs can form continuous-looking bars or terrain bands rather than appearing like isolated floating cards.

### 18.3 Placeholder assets now, final art later

Current visuals intentionally use placeholders:

- field PNGs;
- animal-area PNGs;
- building PNGs;
- emoji plants;
- emoji animals.

The user intends to create the actual art later.

This means the code should avoid baking layout assumptions too deeply into image dimensions or art-specific hacks.

### 18.4 Static aspect-ratio philosophy

The established intent is:

- animal fields: fairly large and slightly taller than wide;
- central planting patches: consistent aspect ratios, allowed to absorb some overall screen-ratio distortion;
- building fields: smaller, arranged as 2 × 4;
- background elements should not be unnecessarily cropped.

The exact pixel dimensions previously discussed for the final artwork are not retained in the current briefing record, so they are intentionally not repeated here.

### 18.5 iPhone and iPad

The target is not merely desktop browser play.

The interface should remain usable on at least an **iPhone 6-sized screen**, while also scaling well to larger displays such as an iPad.

The current CSS snapshot still constrains the main root to `max-width: 480px`, so the current implementation does not yet fully satisfy the broader iPad presentation goal. This is a clear responsive-layout item to revisit once the composition and asset ratios are locked.

### 18.6 Current technical visual debt

There are two important asset-scaling considerations in the current CSS:

- field backgrounds use `object-fit: fill`, which preserves full visibility but can distort the art;
- animal/building backgrounds use `object-fit: cover`, which can crop artwork.

The original intention was to avoid unwanted cropping and to let the central field absorb some ratio variation. The final art integration phase should therefore revisit these rules rather than treating the current CSS as the final visual solution.

---

## 19. Current UI Structure

The latest concrete main HTML currently contains:

### Top bar

- Coins
- Water
- Energy
- Time Quiz button
- Training button

The intended evolution is to simplify this to:

- Coins
- Water
- Energy
- Time Quiz

with Training launched from the Energy indicator itself.

The Time Quiz button is currently labeled with a question-mark icon and text. The later request was to replace that with a **clock emoji** to make the purpose clearer and visually consistent with the time concept.

### Animal row

Four full-width tiles:

- chicken area;
- cow area;
- sheep area;
- bee area.

### Planting grid

Twelve central patches:

- nine normal fields;
- three reserved/special patches.

### Bottom buildings

Eight slots in two rows of four, currently representing:

**Row 1**
- Market
- Farmhouse
- Workshop
- Storage

**Row 2**
- Well
- Windmill
- Barn
- Extra/Future slot

The extra slot exists so later systems can be plugged in without redesigning the main farm composition.

---

## 20. Modal UX Philosophy

The main farm view is intentionally sparse. Detailed choices open contextual modals.

This makes the game modular:

- the player taps a field → planting/harvest modal;
- taps the Market → seed marketplace;
- taps the Farmhouse → recipes;
- taps Storage → pantry;
- taps an animal field → animal area;
- taps Well → upgrade interface;
- taps Training → energy quiz.

The modal system is therefore effectively the game's **secondary interaction layer**.

The goal is not a separate page for every feature.

---

## 21. Current Technical Architecture

The prototype was intentionally split into manageable files so future changes do not require rewriting a giant monolithic HTML file.

### `farm-game-main.html`

Responsible mainly for the persistent farm composition and wiring in the other files.

Current responsibilities include:

- top bar markup;
- animal slots;
- 3 × 4 field grid;
- building slots;
- quiz modal iframe;
- generic UI modal;
- loading CSS/config/core scripts.

This is intentionally the shortest and most visual file.

### `farm-game-style.css`

Responsible for:

- farm layout;
- responsive structure;
- tile sizing;
- modal styling;
- buttons;
- requirement bars;
- crop animation;
- animal animation;
- card styling.

### `farm-game-config.js`

Contains the data-oriented definitions that are easiest to change without touching the main engine.

Current examples:

- crop definitions;
- recipe definitions;
- Well level definitions;
- action energy costs;
- animal-output prices;
- starting state.

This is a crucial architectural direction. As the game grows, much more content should be moved into configuration/data tables rather than embedded directly inside procedural UI code.

### `farm-game-core.js`

Contains most current game behavior, including:

- state loading/saving;
- migrations/default handling;
- time advancement;
- field rendering;
- animal rendering/wandering;
- planting;
- harvesting;
- pantry;
- market;
- animal areas and conversion;
- recipe crafting;
- Well upgrades;
- placeholder buildings;
- Training Quiz;
- event wiring;
- communication with the quiz iframe.

It is the current gameplay engine.

### `farm-quiz-engine.html`

Contains the Time Quiz itself.

It is embedded as an iframe and communicates with the farm via `postMessage`.

This separation is intentional so the quiz system can evolve without forcing the farm UI into the same file.

---

## 22. Current Game State Model

The prototype stores a persistent state roughly organized into:

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

Persistence currently uses browser `localStorage` under a versioned storage key.

This structure is already good enough to support the next phase of content expansion, but the final architecture will likely need additional entities for:

- owned tools;
- building upgrade states;
- machines;
- recipe progression;
- item/tag definitions;
- animal-specific production systems;
- aging jobs;
- pet goals;
- merchant unlocks;
- chest/reward state;
- quiz progress and spaced repetition;
- more explicit progression flags.

---

## 23. What Is Already Established in the Prototype

The following are meaningful implemented foundations, based on the current concrete files and the successful testing history.

### Core farm presentation

- Single-screen farm layout.
- Four animal areas.
- 3 × 4 central field grid.
- Eight bottom building slots.
- No gaps between the major visual grid tiles.
- Placeholder PNG architecture ready for later art substitution.

### Resource display

- Coins visible.
- Water visible as current/capacity.
- Energy visible as current/capacity.

### Farming

- Seed inventory.
- Planting requirements.
- Water consumption.
- Energy consumption.
- Question-driven crop growth.
- Harvest readiness.
- Sell-versus-save harvest decision.
- Crop growth animation.

### Market

- Seed purchasing.
- Coin requirement bars.
- Locked crop presentation.
- One-time egg-based tomato unlock.

### Pantry

- Inventory categories.
- Persistent stored outputs.
- Selling of stored outputs.

### Animals

- Chicken area.
- Cow area.
- Sheep area.
- Bee area.
- Purchasable animals/colonies.
- Per-animal production cooldown tracking.
- Water/energy/input requirements.
- Sell-versus-save product decision.
- Visible emoji animals.
- Rudimentary wandering/bobbing animation.

### Crafting

- Recipe Book/Farmhouse access.
- Bread recipe.
- Ingredient checks.
- Energy check.
- Sell-versus-save output decision.

### Well

- Passive water generation from quiz-driven time.
- Upgrade levels.
- Capacity changes.
- Coin requirements.
- Requirement progress bar.

### Quiz systems

- Separate Time Quiz engine.
- Correct-answer time advance.
- Time Quiz does not grant energy.
- Training Quiz.
- Three-second Training timeout.
- Timeout treated as failure.
- Training gives energy only on success.
- Continue and Close flow.

### Technical foundations

- Persistent local state.
- Migration/default safeguards.
- Configuration separated from engine logic.
- Quiz isolated from the main farm file.
- Modal-based contextual UI.

---

## 24. Immediate Pending UX Changes

These are the most concrete next changes from the recent testing cycle.

### 24.1 Seed requirement bar

Add a visible progress/requirement bar for seed quantity in the planting interface.

Current status: **Pending.** The current planting cards show seed count as text but use bars for water and energy.

### 24.2 Whole-field / whole-card planting interaction

The current prototype already makes the **whole field plot** clickable to start planting or harvesting.

What still needs to be normalized is the same interaction philosophy across related UI cards—particularly seed purchasing, where the player should be able to tap the main seed card rather than having to hit a tiny button.

Current status: **Partially satisfied.**

### 24.3 Conversion time bar

The current animal cooldown is based on `questionsAnswered` and displays a text message such as “Answer a Time Quiz first.”

The requested improvement is a real visible **time/cooldown bar** so the player can immediately see how close the converter is to becoming available.

Current status: **Pending.**

### 24.4 Time Quiz clock icon

Replace the current question-mark presentation with a clock emoji/icon next to Time Quiz.

Current status: **Pending in the concrete snapshot.**

### 24.5 Training merged into Energy

Remove the separate Training button and make the Energy indicator itself the Training entry point.

Current status: **Pending in the concrete snapshot.**

### 24.6 Whole conversion row clickable

Instead of requiring a small Convert button inside each animal card, the entire row/field should initiate or focus the conversion action, with clear disabled-state feedback when requirements are unmet.

Current status: **Pending.**

### 24.7 Whole pantry card clickable

Make the whole inventory item card the interaction target for selling, instead of only a small Sell button.

Current status: **Pending.**

---

## 25. Content That Is Still Mostly Prototype/Placeholder

The deepest systems are not implemented yet.

### Farming/content expansion

- Full crop catalog.
- Crop-specific artwork.
- Multiple crop growth PNGs.
- Better yield/abundance visuals.
- Higher-level plot mechanics.

### Tools

- Tool inventory.
- Tool upgrades.
- Tool-specific energy/production effects.
- Unlock rules for tool tiers.

### Workshop

- Milling.
- Textile production.
- Pressing.
- Metalworking.
- Machine upgrades.

### Animal processing

- Churning.
- Yogurt fermentation.
- Cheese station.
- Shearing/thread/weaving chain.
- Honey/bewax extractor chain.
- More specialized animal behaviors.

### Storage

- Shed.
- Barn.
- Warehouse.
- Aging Station.
- Cellar.
- Actual preservation timers.

### Kitchen

- Stove.
- Oven.
- Prep Station.
- Food Processor.
- Appliance-first filtering.
- Multi-step recipes.

### Recipe system

- Full recipe graph.
- Tag-based unlocking.
- Tool/appliance prerequisite logic.
- Locked future recipe visibility.
- Persistent unlock state across ingredient depletion.

### Marketplace

- Multiple merchant categories.
- Conditional unlocks.
- Spice systems.
- Raw materials.
- Imports.
- Cosmetics/accessories.

### Progression

- Five pet goals.
- Dish/key progression.
- Larger unlock chain.
- End-goal completion state.

### Rewards

- 20% chest chance after successful Time Quiz.
- Tiered chest rewards.
- Rare variants.
- Cosmetics.

### Educational systems

- Larger Time Quiz bank.
- Spaced repetition.
- Two-digit arithmetic.
- Topic progression.
- Better question metadata.

---

## 26. Prototype History and What We Learned From Testing

The project has evolved significantly through hands-on testing. Several of these decisions are worth preserving because they reveal what the final interaction philosophy should be.

### Early farm prototypes

The earliest versions focused on proving that a quiz could drive a farming loop and that a simple farm could fit into a mobile-oriented screen.

### Marketplace discovery

A clear usability issue emerged when players had seeds but no coherent way to obtain additional seeds. The Marketplace was introduced as the obvious economic source for seeds.

### Animal-row relocation

The animal areas moved upward and the passive buildings moved downward. This created a stronger hierarchy:

**resources → animals → crops → buildings**

and gave the crop field more central visual importance.

### Field expansion and special slots

The design moved from the initial 9-plot concept toward a 12-patch central grid, with the extra three patches reserved for later systems.

This is valuable because it reserves space for future infrastructure without introducing another navigation layer.

### Plant visuals

The first plant visuals used simple emoji stages. Feedback then refined the visual goal:

- use a sprout in early growth;
- switch to the actual crop icon as it develops;
- keep the crop centered in the field;
- use scaling rather than clipping.

This is now a good temporary implementation pattern for later PNG art.

### Pantry bugs

Testing found cases where animal outputs did not initially appear in the pantry or did not expose the expected immediate sell/save flow. Those issues led to a broader requirement that every production output should have a predictable immediate decision point.

### Tomato unlock

A deliberate unlock test was added:

> Give 2 eggs once → tomato seeds become available.

This successfully tested the concept of a resource-based unlock that persists after the unlock.

### Requirement bars

The interface repeatedly moved toward compact visual requirement bars rather than text-only prerequisites. Water, energy, coins, and other requirements can therefore become visibly satisfied/unsatisfied.

### Separate quiz engine

The Time Quiz became a separate HTML engine so that quiz content and behavior could be improved independently of the farm screen.

### Training timeout

The Training Quiz was given an explicit three-second timeout. A timeout is treated exactly like a wrong answer and grants no energy.

### Animal wandering

Simple random movement was added after static animal emojis made the farm feel too lifeless. This was tested and reported as working well.

This is an important design lesson: **small amounts of ambient animation can add life without requiring a complex simulation.**

---

## 27. What the Current Prototype Can Be Used to Test

Even before the larger content systems exist, the current prototype is useful for testing the game's fundamental feel.

It can already answer questions such as:

- Does quiz-driven time feel understandable?
- Is water easy to read?
- Does spending water create meaningful tension?
- Is energy sufficiently scarce to make Training relevant?
- Does selling versus saving create meaningful decisions?
- Does the animal conversion loop feel satisfying?
- Does the player understand that Time Quiz advances the whole farm?
- Is the single-screen composition readable on mobile?
- Are the animal/crop/building zones visually distinct?
- Do modals feel faster than opening additional pages?
- Do requirement bars communicate enough without text overload?

Those questions should continue to drive the prototype phase before content breadth grows too large.

---

## 28. Current Design Vocabulary / Canonical Terms

To reduce naming drift, the following terms should be treated as the project's preferred vocabulary.

| Term | Meaning |
|---|---|
| **Time Quiz** | Knowledge quiz that advances farm time. Does not award energy. |
| **Training Quiz** | Quick-recall mini-game that restores energy. |
| **Question step** | One successful Time Quiz advancement unit. |
| **Well** | Passive water-producing building tied to question progression. |
| **Pantry** | Inventory/saved-output view. |
| **Marketplace** | Seed/merchant purchasing interface. |
| **Recipe Book** | Farmhouse-accessed recipe interface. |
| **Animal Area** | A field/slot containing chickens, cows, sheep, or bees. |
| **Conversion** | Turning inputs into an animal/product output. |
| **Requirement bar** | Visual progress indicator for an input requirement. |
| **Locked** | Content not currently available but intentionally visible when relevant. |
| **Special patch** | Reserved central plot for future infrastructure/content. |
| **Pet dish** | A high-level food objective tied to bringing back one of the secret pets. |

---

## 29. Architectural Direction for the Next Major Refactor

The current split between HTML, CSS, configuration, core logic, and quiz engine is a good foundation. The next step should be to move from a prototype that is **file-separated** to a game that is truly **data-driven**.

### Recommended data modules

Without committing to a particular final filename layout yet, the logical content definitions should eventually include:

- `items`;
- `crops`;
- `seeds`;
- `animals`;
- `animal conversions`;
- `recipes`;
- `appliances`;
- `machines`;
- `tools`;
- `buildings`;
- `unlocks`;
- `merchant inventories`;
- `pet goals`;
- `quiz questions`;
- `reward tables`.

The principle is:

> **A balance/content change should usually be possible by editing data, not rewriting engine code.**

### Example

Adding a new crop should ideally require something like:

1. add the crop definition;
2. add its seed definition;
3. add its unlock condition;
4. add its art assets;
5. optionally add recipes that consume it.

The engine should already know how to render and interact with a crop because it understands the crop schema.

---

## 30. Suggested Future Save-State Evolution

As content grows, the save state will likely need to become more explicit and migration-friendly.

A mature state could include:

```text
player
  tools
  equipment

resources
  coins
  water
  energy
  inventory

farm
  plots
  greenhouse
  scarecrow

buildings
  livingQuarters
  workshop
  storage
  well
  lumbermill
  marketplace

animals
  chickens
  cows
  sheep
  bees

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

quiz
  questionsAnswered
  timeQuestionHistory
  trainingQuestionHistory
  spacedRepetitionData

rewards
  chestHistory
  unlockedVariants
  cosmetics
```

The exact schema should be designed before the system grows much larger, because migrating a deeply nested local-storage structure becomes harder after many iterations.

---

## 31. Proposed Roadmap

The following roadmap is an **inferred project plan**, not a claim that all sequencing has already been formally approved. It follows naturally from the conversation's design decisions and the current prototype state.

### Phase A — Immediate prototype UX stabilization

Focus only on the interaction fixes already identified.

- Add seed requirement/progress bar.
- Standardize full-card/full-area click targets.
- Add conversion cooldown/time bars.
- Change Time Quiz icon to clock.
- Merge Training into Energy indicator.
- Make whole conversion rows clickable.
- Make whole pantry cards clickable.
- Verify no regression in modal close/continue behavior.

**Goal:** Make the existing vertical slice feel coherent before adding major content.

### Phase B — Responsive/layout hardening

- Validate iPhone 6-sized viewport.
- Validate iPad-sized viewport.
- Remove any unintended fixed-width assumptions.
- Revisit `max-width: 480px` behavior.
- Finalize field/animal/building aspect-ratio rules.
- Ensure placeholder PNGs are not unexpectedly cropped.
- Confirm continuous-background effect on all target sizes.

**Goal:** Lock the farm composition before final artwork is produced.

### Phase C — Data-driven systems refactor

- Expand config into clean item/crop/animal/recipe data models.
- Move repetitive conversion definitions out of procedural functions.
- Formalize unlock conditions.
- Formalize building/tool schemas.
- Formalize save-state migrations.

**Goal:** Make content expansion cheap and safe.

### Phase D — Core production expansion

- Full crop catalog.
- Better harvest/yield behavior.
- Proper animal production chains.
- Workshop machines.
- Milling.
- Textile production.
- Pressing.
- Metalworking.
- Kitchen appliance system.
- Storage progression.
- Aging/preservation.

**Goal:** Turn the simple vertical slice into the intended production sandbox.

### Phase E — Progression and economy

- Full Marketplace merchant system.
- Tool progression.
- Building upgrades.
- Better pricing formulas.
- Resource-value balancing.
- Locked content visibility rules.
- Greenhouse.
- Scarecrow.
- Lumbermill.

**Goal:** Create the game's mid-game strategic depth.

### Phase F — Pet and end-goal layer

- Define five pets.
- Define their dishes.
- Define recipe/ingredient chains.
- Connect pet objectives to progression.
- Add reveal moments.
- Add completion/reunion states.

**Goal:** Give the production system its narrative purpose.

### Phase G — Quiz/education expansion

- Larger Time Quiz bank.
- Question metadata.
- Topic coverage.
- Difficulty progression.
- Spaced repetition for Training.
- Two-digit arithmetic.
- Better feedback.
- More varied quick-recall question types.

**Goal:** Make the educational layer as deliberately designed as the farm layer.

### Phase H — Reward and polish systems

- Quiz-success chest system.
- Rare variants.
- Cosmetics.
- Avatar accessories.
- Final UI animation pass.
- Audio, if desired later.
- Accessibility review.
- Final balancing.

**Goal:** Turn the prototype into a complete product candidate.

---

## 32. Recommended Definition of “Done” for the Project

The project should not be considered complete merely because every building has an icon or every screen has a button.

A more meaningful completion definition is:

### Functional completion

A player can start from the devastated farm and, without developer intervention:

1. answer Time Quiz questions;
2. grow and harvest crops;
3. manage water;
4. manage energy;
5. train to restore energy;
6. buy and use animals;
7. produce intermediate goods;
8. use Workshop/Kitchen/Storage systems;
9. build multi-step recipes;
10. sell or save outputs;
11. unlock new content;
12. discover pet-related goals;
13. craft all required pet dishes;
14. bring all five pets home.

### Educational completion

The game should consistently reinforce:

- planning;
- opportunity cost;
- water sustainability;
- arithmetic/recall.

The educational mechanics should remain integrated with game decisions rather than feeling like two unrelated products glued together.

### UX completion

The player should understand the immediate next action primarily from:

- icons;
- numbers;
- requirement bars;
- color/state;
- locks;
- location of objects;
- short contextual text.

### Technical completion

Content expansion should not require repeatedly rebuilding the farm layout from scratch. The engine should be able to consume data definitions for most of the game's content.

---

## 33. Risks to Watch During Development

### Risk 1 — Too much content too early

The final design is potentially very rich. Adding every crop, machine, merchant and recipe before the basic loop is satisfying could bury the core experience.

**Countermeasure:** Keep validating the minute-to-minute loop after every systems expansion.

### Risk 2 — Resource complexity becoming opaque

Water, energy, coins, seeds, ingredients, machines, tools, animals and cooldowns can create cognitive overload.

**Countermeasure:** Show only the immediate requirements for an action; expose deeper dependencies during unlock/build moments.

### Risk 3 — Quiz fatigue

If the player must answer too many repetitive questions just to wait for crops, the quiz mechanic could feel like a toll booth.

**Countermeasure:** Improve question variety, pacing, feedback, spaced repetition and question relevance.

### Risk 4 — The economy becoming too generous

If the player can always buy everything immediately, opportunity cost disappears.

**Countermeasure:** Balance water, energy, seed supply, animal input requirements and processing throughput so choices matter without becoming frustrating.

### Risk 5 — Production chains becoming a checklist

A long dependency graph can look impressive in code but feel like paperwork to the player.

**Countermeasure:** Let the player discover chains contextually and move production to logical stations at the moment a new station becomes meaningful.

### Risk 6 — UI becoming button-heavy

The current prototype naturally tends to produce small Convert/Buy/Sell buttons inside cards.

**Countermeasure:** Continue moving toward whole-area interaction with clear visual states.

### Risk 7 — Art integration breaking composition

Replacing placeholders with richer art can expose cropping or aspect-ratio problems that are invisible with generic placeholder images.

**Countermeasure:** Lock the layout contract and asset ratio rules before the final asset pass.

---

## 34. High-Value Design Decisions Already Made

These decisions should be treated as strong anchors unless intentionally revisited.

1. **Medieval setting.**
2. **Rebuild-from-scratch farm.**
3. **Five secret vegetarian pets as the ultimate objective.**
4. **Dishes are the main high-level keys.**
5. **Single-screen farm.**
6. **Contextual modals instead of multi-screen navigation.**
7. **Time advances through the Time Quiz.**
8. **Time Quiz does not award energy.**
9. **Training restores energy.**
10. **Training has a short response window; timeout gives nothing.**
11. **Water is central and produced by the Well per question.**
12. **Coins primarily come from selling outputs.**
13. **Sell-now-or-save-to-pantry choices are fundamental.**
14. **Dependencies appear mainly at unlock/build time.**
15. **After unlock, show immediate inputs rather than the full dependency tree.**
16. **Tools and buildings upgrade rather than multiply into permanent clutter.**
17. **Marketplace is the seed acquisition hub.**
18. **Locked future content is visible only when it is meaningfully unlockable/theoretically relevant.**
19. **Animal production has question-based cooldowns.**
20. **The farm is visually contiguous—no decorative gaps between terrain tiles.**
21. **Placeholder art is acceptable during development.**
22. **Code should be split into manageable files.**
23. **Content should increasingly become data-driven.**

---

## 35. Decisions That Are Still Open or Need Detailed Design

These areas have direction but not a final specification.

### Pet identities and dish definitions

The five pets, their personalities/visuals, exact dishes, and reveal structure still need detailed design.

### Complete economy

The prototype prices are placeholders. A complete economy needs careful balancing across:

- input values;
- processing costs;
- animal upkeep;
- machine investment;
- water scarcity;
- energy scarcity;
- market prices.

### Exact tool effects

The tool tiers are established, but their precise gameplay benefits need definition.

### Machine recipes

The final input/output ratios and processing times need to be defined.

### Storage/aging rules

The design specifies Aging Stations and Cellars but not all exact durations and recipes.

### Quiz curriculum

The educational progression needs a proper content plan beyond the prototype question bank.

### Reward tables

Chest probabilities and reward classes exist conceptually, but the exact tables and anti-frustration rules remain to be designed.

### Final visual style

The broad composition is established, but the final art language, UI skin, typography, and exact asset dimensions are not fully locked in this record.

---

## 36. The Best Mental Model for the Project

The simplest way to think about the finished game is this:

> **It is a small, tactile medieval farm where every successful quiz answer moves the entire ecosystem forward by one step. The player uses that time strategically, balancing water, energy, materials, animals, machines and money to transform basic resources into increasingly meaningful foods—until they can cook the dishes that bring five hidden vegetarian pets home.**

The game's systems are therefore not independent modules. They form a deliberate chain:

```text
                    ┌──────────────────┐
                    │    TIME QUIZ     │
                    │ correct answer   │
                    └────────┬─────────┘
                             │
                         +1 question
                             │
       ┌─────────────────────┼──────────────────────┐
       │                     │                      │
       ▼                     ▼                      ▼
   Crop growth          Well produces         Animal cooldowns
       │                     water                  refresh
       ▼                     │                      │
   Harvest                  └──────────┬───────────┘
       │                               │
       ▼                               ▼
 Sell now / Pantry              Conversions
       │                               │
       │                         Eggs/Milk/Wool/
       │                         Honey/etc.
       │                               │
       └──────────────┬────────────────┘
                      │
                      ▼
                 Craft / Process
                      │
                      ▼
              Finished ingredients
                      │
             ┌────────┴────────┐
             │                 │
             ▼                 ▼
         Sell for coins     Save pantry
             │                 │
             └────────┬────────┘
                      ▼
                Unlock / Build
                      │
                      ▼
              More capabilities
                      │
                      ▼
                Pet dishes
                      │
                      ▼
            Five pets come home
```

Energy forms a parallel loop:

```text
Manual actions consume energy
            │
            ▼
      Energy gets low
            │
            ▼
      Tap Energy indicator
            │
            ▼
       Training Quiz
            │
      ┌─────┴─────┐
      │           │
   correct     wrong/timeout
      │           │
    +energy       0
```

Water forms another strategic constraint:

```text
             Well
               │
        water per question
               │
               ▼
          Water reserve
          /     |      \\
         /      |       \\
    Crops    Animals   Processing
       \        |        /
        \       |       /
             scarcity
                 │
                 ▼
          opportunity cost
```

Together, these loops create the game's identity.

---

## 37. Current Status at a Glance

| Area | Current state | Direction |
|---|---|---|
| Single-screen farm | Implemented | Keep and polish |
| Mobile-oriented layout | Implemented but needs responsive hardening | iPhone + iPad validation |
| 3 × 4 field grid | Implemented | Keep |
| Animal row | Implemented | Replace placeholders with art later |
| Animal wandering | Implemented and tested | Keep lightweight |
| Building slots | Implemented | Populate progressively |
| Coins | Implemented | Expand economy |
| Water | Implemented | Deepen sustainability loop |
| Energy | Implemented | Improve interaction and progression |
| Time Quiz | Implemented as separate engine | Expand content/system |
| Training Quiz | Implemented | Merge into Energy indicator; deepen repetition |
| Wheat/carrot/tomato prototype | Implemented | Expand to canonical crop set |
| Seed market | Implemented | Expand marketplace |
| Tomato unlock | Implemented | Generalize unlock architecture |
| Harvest | Implemented | Expand yield/content system |
| Pantry | Implemented | Improve clickability and storage progression |
| Chicken conversion | Implemented | Generalize/finalize chain |
| Cow conversion | Implemented in simplified form | Add processing chain |
| Sheep conversion | Implemented in simplified form | Add textile chain |
| Bee conversion | Implemented in simplified form | Add extractor/bee-product chain |
| Bread | Implemented | Expand into recipe system |
| Well upgrades | Implemented | Expand building progression |
| Workshop | Placeholder | Build machine system |
| Windmill | Placeholder | Implement flour production |
| Barn | Placeholder | Build storage/aging system |
| Tools | Conceptual | Implement |
| Advanced kitchen | Conceptual | Implement |
| Aging/preservation | Conceptual | Implement |
| Full recipe tags | Conceptual | Implement data model |
| Marketplace merchants | Mostly future | Implement progression |
| Greenhouse | Future slot/concept | Implement mid/late game |
| Scarecrow | Conceptual | Implement |
| Lumbermill | Conceptual | Implement |
| Five pets | Narrative/design goal | Implement late-game progression |
| Pet dishes | Goal concept | Define and implement |
| Random reward chests | Conceptual | Implement |
| Final art | Not yet | User-created PNG phase |

---

## 38. Practical Next-Step Order

Based on the current state, the cleanest immediate development sequence is:

### First: finish the current interaction language

Before adding new systems, make all current objects behave consistently:

- whole seed card;
- whole plot;
- whole animal conversion row;
- whole pantry card;
- visible requirement bars;
- visible cooldown bars;
- Energy as Training entry point;
- clear Time Quiz icon.

### Second: lock the responsive farm composition

Test the exact existing farm layout on the smallest target phone and on iPad-sized viewports, then finalize the layout contract for future artwork.

### Third: generalize the data model

Move repeated crop/animal/recipe/building definitions toward clean data tables.

### Fourth: expand the production chain

Add richer content only after the simple production loop is architecturally stable.

### Fifth: build progression around the pet goal

Once the production graph exists, connect it explicitly to the five hidden pets and their dishes.

### Sixth: deepen the quiz engines

After the farm has real context, enlarge the educational systems so questions can reinforce the concepts the player is actually using.

---

## 39. Final Project Assessment

The project has moved beyond the idea stage.

The current prototype already proves the essential interaction architecture:

- a persistent farm state;
- quiz-driven time;
- resource constraints;
- crop growth;
- animal converters;
- sell/save choices;
- unlocking;
- contextual modals;
- a separate quiz engine;
- lightweight animation;
- a layout deliberately designed for later artwork.

The most important thing now is **not adding dozens of features at once**. The strongest next step is to make the existing language of interaction extremely consistent and then use that stable foundation to build the deeper data-driven production system.

The project's eventual strength will come from how well its systems reinforce each other:

> **The quiz changes time. Time changes the farm. The farm creates scarce resources. Scarcity creates choices. Choices determine what gets sold, saved, unlocked, processed, and crafted. Those production choices determine how the player reaches the five dishes that bring the hidden pets home.**

That is the core identity of the game.

---

## Appendix A — Current Prototype Starting State

For testing, the concrete snapshot currently starts with approximately:

- **200 coins**
- **8 water**
- **20 maximum water capacity**
- **10 energy**
- **20 maximum energy**
- **5 wheat seeds**
- **0 carrot seeds**
- **0 tomato seeds**
- **0 harvested crops**
- **0 animal products**
- **0 bread**
- **Well level 1**
- **12 plots** (9 ordinary fields + 3 special/reserved)
- **Wheat unlocked**
- **Carrot unlocked**
- **Tomato locked**
- **Bread recipe unlocked**
- **No animals initially owned**

The 200-coin starting state is understood as a **prototype/testing convenience** rather than the intended final opening economy. The design primer's original fantasy is significantly more resource-constrained.

---

## Appendix B — Current Prototype File Responsibilities

```text
farm-game-main.html
    │
    ├── Farm layout
    ├── Top bar
    ├── Animal slots
    ├── Field slots
    ├── Building slots
    ├── Quiz modal
    └── Generic UI modal

farm-game-style.css
    │
    ├── Layout
    ├── Responsive structure
    ├── Cards/buttons
    ├── Modals
    ├── Requirement bars
    ├── Crop animation
    └── Animal wandering animation

farm-game-config.js
    │
    ├── Crops
    ├── Recipes
    ├── Well levels
    ├── Action costs
    ├── Product prices
    └── Starting state

farm-game-core.js
    │
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
    │
    ├── Time Quiz question bank
    ├── Answer handling
    ├── Feedback
    ├── Next question
    └── Farm communication via postMessage
```

---

## Appendix C — Status Labels Used in This Briefing

**Implemented** — verified in the concrete prototype snapshot or explicitly tested successfully during the conversation.

**Partially implemented** — the underlying mechanic exists, but a requested UX or final form is still missing.

**Placeholder** — the UI/location exists to reserve the concept, but the actual system is not implemented.

**Conceptual / planned** — established in the design direction but not yet built into the current prototype.

**Inferred** — a reasonable development or architectural conclusion drawn from the combined design decisions, not a previously stated hard requirement.

---

## Appendix D — Source/Confidence Notes

This briefing intentionally does not treat every detail as equally certain.

### High confidence

These are repeatedly established in the conversation or directly represented in the current prototype:

- medieval rebuild-a-farm premise;
- five secret vegetarian pets;
- dishes as key progression objectives;
- quiz-driven time;
- separate Training energy loop;
- water as a core resource;
- sell/save choice;
- single-screen farm;
- contextual modals;
- four animal types;
- 3 × 4 central field layout;
- split HTML/CSS/config/core/quiz architecture;
- placeholder art strategy;
- animal wandering;
- current prototype values and systems listed above.

### Medium confidence / design direction

These have been established conceptually but need detailed balancing or final technical specification:

- exact machine progression;
- exact final recipe graph;
- precise tool effects;
- detailed pet behavior/reveal structure;
- merchant unlock timing;
- final economy formulas;
- exact reward tables.

### Explicitly inferred

These are recommendations or likely consequences of the existing design rather than direct specifications:

- a deeper modular data schema for all content types;
- more formal save-state migration strategy;
- phased development sequence;
- some technical cleanup recommendations around asset fitting and responsive layout.

---

# End of Briefing
