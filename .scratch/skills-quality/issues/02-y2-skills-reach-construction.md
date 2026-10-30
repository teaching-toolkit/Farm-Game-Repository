# 02: Y2: Skill ranks reach construction jobs and building costs

**What to build:** Woodwork and construction ranks lower the cost of building and construction jobs, more than cooking or healing do, as decided. The skills system, ranks and effects for recipes are built; construction is not. Also check that the healing family really trains from the remedy recipes.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** later

- [ ] Construction jobs and building costs use the woodwork and construction rank, with a line that says why a saving happened
- [ ] The healing family trains from the still-room recipes (stations are mapped; check the remedies count)
- [ ] The "buy what you do not master" prices belong to M1, not here
- [ ] Bot, `skills_test` and the pace check pass; golden runs identical or re-recorded on purpose

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
