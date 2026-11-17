# 02: Y2: Skill ranks reach construction jobs and building costs

**What to build:** Woodwork and construction ranks lower the cost of building and construction jobs, more than cooking or healing do, as decided. The skills system, ranks and effects for recipes are built; construction is not. Also check that the healing family really trains from the remedy recipes.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** later

- [x] Construction jobs and building costs use the woodwork and construction rank, with a line that says why a saving happened
- [x] The healing family trains from the still-room recipes (stations are mapped; check the remedies count)
- [x] The "buy what you do not master" prices belong to M1, not here (left alone)
- [x] Bot, `skills_test` and the pace check pass; golden runs re-recorded on purpose (16 Nov 2026, my 💡: see the Progress note on the pace)

---

## Progress

**Built (Sonnet agent, 16 Nov 2026).** Building is a job of its own: woodwork and construction now trains from paid builds and its rank makes the next build cheaper, with the same effect numbers as a recipe.
- **What counts as a build (data, `rules/48-skills.json` `builds`):** the node types `building`, `station`, `helper` and the cost category `build` (the clearing of ruins). Tools, gear, patches, deliveries, animals, cards are not.
- **Where it lives:** `skills.family_of_build(id)` says the family ("wood" or ""); `pace.node_cost(id)` is the one place that prices it (the button, the price row, the bot and `unlock` all read it): materials times `skills.input_mult(wood)` (craft shares 4 / 8 / 11 / 14 %), energy through `needs.ecost(…, family)` (−8 % from Handy, stacking with the scaffolding and the season as before); coins and water stay as written. `progression.unlock` counts one batch for the family for every paid build or step of one (`skills.practice`), a free automatic unlock counts nothing. A cook's or healer's rank changes nothing for a build, so at the same rank a carpenter saves more (food 4 % vs craft 8 % at Skilled).
- **No hand multiplication, but not `G.actions` (💡):** a build is a node, not a chore of `G.actions` (ADR-0013's module takes chores); nodes were already priced by `pace.node_cost` and paid by `progression.unlock`, so the discount lives there, in that one function. Moving builds into `G.actions` would be a refactor of its own.
- **What the child sees, without words:** the price row (`widgets.costs`) already reads the lower cost against the base, so lighter cubes and faint grey cubes show the saving. The one line that says why: a muted line under the price on the build's card ("🪚 Handy: building costs less now.", `skills.build_note`, only when the rank is above Beginner and the price has more than coins) and the rank-up note adds "cheaper building" for woodwork and construction. German added to `ui-de.json`.
- **Healing:** checked, nothing missing. All seven still-room stations (cellar and cellar_2, fermenter, drying rack, mortar, tea pot, syrup pan, salve pot) map to healing; `skills_test` runs a remedy (plantain paste at the mortar) and a drying (chamomile on the rack) through `G.actions` and sees the batches rise; and checks that only `clay_pit` and `wild_edge` (gathering) have no family.
- **Tests:** `skills_test` 55 checks (was 31), 0 failed: rank 0 full cost and no line; Handy and Skilled `workshop_1` (4 logs -> 3.84 -> 3.68, energy 8 -> 7.36, coins as written); a Skilled cook pays the full price; at equal rank cooking saves less than woodwork (0.04 < 0.08); paying the campfire counts a batch and charges the lower price; `ui_smoke` gets a build-note check ("build note: Beginner none true, Handy … true"). `saves_test` 89, `quality_test` 48, `actions_test` 29550, `market_test` 24, `pets_test` 107, `trip_test` 58, all 0 failed; `ui_smoke` no FAIL; `check_data` 0 errors; `i18n --check` clean.
- **The golden runs now differ (NOT recorded: the parent decides).** With `builds` switched off the short golden is identical, so the whole difference is this feature (the bot's builds cost a little less, and Handy comes at about the tenth build, step ~20). Chapter starts, steps (golden -> now): **short, seed 1:** ch2 185 -> 176, ch3 401 -> 402; **seed 2:** ch2 196 -> 175, ch3 416 -> 415. So chapter 1 is 5 to 11 % shorter, chapter 3 is reached at the same step (chapter 2 gets longer by as much). **Full run to chapter 6 (a throwaway, not recorded):** seed 1: ch4 778 -> 877, ch5 1296 -> 1081, ch6 1423 -> 1189 (-16 %); seed 2: ch4 811 -> 817, ch5 1296 -> 1210, ch6 1432 -> 1307 (-9 %). The late chapters are noisy in the bot (a chapter can swing by 100 steps from a small change), but the end of the story comes about 9 to 16 % sooner.
- **Decision for the parent (💡):** accept and re-record both golden pairs (`bash tests/golden.sh --short --record`, and the full pair), or slow it down. 💡 Levers, easiest first: (1) data: lower the shares for builds (a `builds` entry could get its own `inputs` row) or turn off the energy share; (2) code, one line: stop `progression.unlock` counting builds as practice (`G.skills.practice(G.skills.family_of_build(id))`, twice), so that only carpentry and sawing train the rank; (3) raise the Handy threshold. Neither the 4 % at Handy nor the 8 % less energy shows in a single price (a price of 3 sticks reads 2.88), so the child sees it mostly as a faint grey cube; the bigger shares come at Skilled and Expert.
- **Not built, on purpose:** "faster" (Master: 80 % of the time) for a build's waits; the "buy what you do not master" prices (M1).

---

**Id:** Y2 · **Feature:** `skills-quality` · **Moved from** `archive/todo-2026-10.md` §8 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **Y2. Skills and mastery** ✅ (R4, R5). **Built 13 Oct 2026 (phase 4.4):** `game/farm/systems/skills.gd` + `data/farm/rules/48-skills.json` (families, ranks, gates, effects, which station trains which family); save keys `skills` (batches per family) and `skill_rank` (announced ranks), `SAVE_VERSION` 3 turns the old station practice into batches; recipes cost fewer inputs / less energy / less time by rank, grades get the bonus, planting, harvesting and collecting count; the album lists the skills from the first rank-up (`reveal` element `skills`); the old practice stars are gone. `tests/skills_test.tscn` (31 checks). Pace: the bot now reaches chapter 5 in 640 / 620 steps (729 / 647 before, 741 / 639 at the start of phase 4): ranks make things cheaper, to be re-balanced with the prices (4.5). Not yet: construction jobs and building costs (woodwork), the healing family's recipes, the "buy what you do not master" prices. The parent: honing a skill (and better tools and buildings) lowers energy and raises
  carrying, as decided, but some learning also means **less waste of inputs** (fewer reeds for the same basket), and less time and
  energy. Becoming good at everything is possible in theory, but it should pay to **specialise**, master some areas first and **buy the
  rest** (making steel from bought iron ore is possible, but needs much knowledge, training and upgraded tools, so it only pays on the
  metal path). Practice is **tracked even when not visible**, "in a way that doesn't get out of hand", usable without losing detail.
  - **Eight families** ✅: planting and harvesting · animal tending · cooking and baking · fibre and weaving · woodwork and construction
    · pottery and glass · smithing · healing and preserving. Every batch (or job) counts for its family, so similar work trains it too.
  - **Five ranks** (💡, accepted by silence in R5): Beginner → Handy → Skilled → Expert → Master. A rank needs a number of batches (e.g.
    10 / 30 / 80 / 200) and, from Skilled on, a gate the game already has: a card (Skilled), a tool tier (Expert), a station or building
    (Master), so grinding cheap recipes can't make a master early.
  - **What every rank brings** ✅ (R5):
    - **fewer inputs at every rank**, with diminishing returns, and **more for construction and crafting** than for cooking or healing;
    - **a bit better quality chances at every rank**, Master included;
    - plus Handy: less energy; Master: faster.
    - Field and animal work gain **less** from training (buildings, tools and books already cover much), mostly through **fewer
      beginner's mistakes** (dropped eggs, a seedling pulled with the weeds) and better quality.
  - **How savings show:** amounts stay exact underneath (the game already works that way); a saving that hasn't reached a whole piece yet
    shows as the faint grey cubes the cost bars already use for upgrade savings, so no decimals appear.
  - **Every saving says why** ✅ (R6): when training, an upgrade or new knowledge reduces the inputs, time or energy, a line explains it in
    the world's terms ("You drop the eggs less often now", "Your hands know baskets: 5 reeds instead of 6").
  - **No beginner's mishaps when making things** ✅ (R6): there, a beginner's "mistake" is a Lumpy result; materials are not lost.
  - **Shown when it first matters:** the first rank-up comes with a small celebration ("Your hands know baskets now"); then the rank
    shows on recipe tiles and a skills page appears (in the farmer's dashboard or the album).
  - **No fading, no hard limit** on how many families reach Master; time and energy limit it naturally.
  - **The price rule** (M1): a made thing's market price lies between a beginner's cost to make it and a master's, so buying pays for a
    beginner and making pays for a master.
  - **Replaces the per-station practice stars** that exist today (`meta.practice`: −5 % energy per star at 10/40/120 uses).
  - First numbers go into D1 and are tuned in the explorer.


## Pace decision (16 Nov 2026, ask-matt pass, easy to undo)

The build discount shortens the bot's full run to chapter 6 by about 9-16 % (chapter 6 start step: seed 1 1423 → 1189, seed 2 1432 → 1307; short runs: chapter 2 starts at 176/175 instead of 185/196). The ticket wanted woodwork to matter, so I took the 💡 to keep it and **re-recorded the golden runs on purpose**. If the parent finds the game too short, the levers (all data, easiest first): lower the build shares in `48-skills.json`; stop counting builds as practice (one line in two places in `progression.unlock`); raise the Handy threshold. Not built: Master's faster builds and the M1 "buy what you do not master" prices.
