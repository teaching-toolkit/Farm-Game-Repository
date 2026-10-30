# 01: Grill and spec: farm actions, one module that prices, checks and pays

**What to build:** Settle candidate 1 of `docs/architecture-review-2026-10-22.md` with the parent, then write the spec and the build tickets. One module, owned by the rules, answers "what would this cost and can I do it?" and "do it" for every action (plant, harvest, weed, clear snow, cut tree, fetch water, muck out, party, visit, buy, go to the village). The interface's buttons then show the price the rule charges. The review recommends starting here. `fields.plant_plan()` is the working prototype of the first half.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** refactor

- [x] `/grill-with-docs` run with the parent on this candidate; the seams for testing agreed (the highest seam possible, ideally one)
- [x] `.scratch/farm-actions/spec.md` written in this folder from the `/to-spec` template
- [x] Build tickets filed (02–16) in this folder with `/to-tickets`, blockers set
- [x] The plan keeps the golden runs identical: this changes no game rule

---

**Feature:** `farm-actions` · **Source:** `docs/architecture-review-2026-10-22.md`, Part B, candidate 1 (Strong). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.

---

## Decisions so far (grilling with the parent, 23 October 2026)

Words are in `GLOSSARY.md` (chore, effective cost, requirement, check, perform, report). The review used "action", "quote" and "cost"; read those as chore, check and effective cost.

**Round 1, settled**
- **Scope.** A chore is a field-type act (plant, harvest, weed, pick stones, clear snow, cut tree, fetch water, muck out, collect, party, visit, forest, go to the village) or a recipe at a station. Spending coins (buying, goal and building costs, Wren's favour) is not a chore, but it pays through the same function, so energy, water, items and coins are checked and spent in one place. Selling and earning stay out.
- **First build changes no behaviour.** The golden runs stay identical. Three oddities are fixed afterwards, each as its own ticket and decision: Wren's coin favour skips the Lord's-share check; `plant()` has a seed-buying path that never runs; orchard trees use a different energy multiplier.
- **Golden runs.** They do not have to run through all chapters every time. Prototype and check with chapters 1 and 2. The list below names what that leaves untested. When the full run (to chapter 6) happens is an open question for round 2.
- **Whole-field chores** are a batch of single chores: stop at the first one that cannot be paid, save once, redraw once, give one summary message. The single chore stays the unit (its cost is shown per patch).
- **`perform` returns a report.** The module alone says the message, saves once and tells the interface once. The report carries a reason key and the child-friendly sentence, so the grey-button explanation (`interface-feel/02`) uses the same words.
- **Seams.** `check` and `perform` are the only seam. Tests: a new price-match test (for every chore, the effective cost on the button equals what perform takes), the golden run, and the bot calling `perform` instead of copying the steps.
- **Home.** A farm system, `G.actions`, in `game/farm/systems/`. Designed so the generic part can move to a kit later with little work: a small interface, and farm words only in data and registrations, not in the module's code (a deep module).
- **Cost is an open dictionary** (energy, water, items, coins, later more). The time cost of `action-budget` is not built now.

**Late features the chapter 1–2 golden runs do not reach (test later; list to verify)**
- The Lord's share blocking coin spending (chapter 3 on): purchases, goal costs, Wren's favour.
- Wren's check and the poisoning buff that doubles job costs for 6 questions (chapter 5): it changes the effective cost.
- The forest: each trip in and out costs a Time Quiz question (chapter 5); the basket's room.
- The medicine chapter's recipes and the healing skill family (chapter 5); skill rank gates from Skilled on.
- Pets' duties and the WHEN cards of levels 3–4 (free play): whether pets use chores.
- Wellbeing starts in chapter 2, so its energy dial and drain are covered; its parties and visits are only partly.
- Planned features that add costs or reasons: store capacity by bulk (`money-market/08`), the grey-button reasons (`interface-feel/02`), the action budget (`action-budget/01`), the "going back takes a question" walk (`money-market/04`).

**Round 2, settled (23 October 2026)**
- **Pets' work is not a "duty".** The pets are a kind of demi-gods (they are not called that) who bless the farm with services out of grace; what they do is something the farm is *rewarded with*, not a job they have. The word for it is still to be chosen (proposed: *blessing*); "job" stays only for the child's little paid jobs. A rename ticket goes into `later` once the word is chosen.
- **One rule for every coin payment.** Every coin payment is blocked while the Lord's share is owed, makes the coins fly to the payee, and the share's own payment is exempt. **Wren never asks for coins.** She may ask for something that takes energy, time or water, or something the player can craft or cook at any time without coins. So the "Wren's coin favour skips the Lord's-share check" oddity becomes a content change: the coin option leaves her check. The first build still changes nothing; this is a follow-up ticket.
- **Numbers in data, effects in code.** One entry per chore in a data file (base cost, which energy modifier applies, which skill family trains). The effect stays in the system that owns it and registers under the chore's name. Recipes are read from `recipes.json`, with no second copy.
- **Only end-of-chore follow-ups move into the module:** polish wear, skill practice, save, redraw signal. Job progress, perk checks, luck rolls and statistics stay in the effect code for now, so the order of random rolls is unchanged.
- **Golden runs.** After every slice: a short run to the end of chapter 2 for seeds 1 and 2 (new short golden files; `golden.sh` gets a chapter limit, a first small ticket). The full run to chapter 6 when a slice touches a late system from the list above, and once at the end of the feature.
- **Order of the move.** (1) short golden run and the price-match test harness; (2) the module with the seven field chores (plant, harvest, weed, stones, snow, tree, water) and their buttons; (3) animals, party and visit, forest, the village trip; (4) recipes at stations; (5) coin payments through the one pay function; (6) delete the old duplicated code, then the oddities as separate tickets.
- **Pets can perform chores like the farmer.** `perform` must not assume the farmer. How a pet's chore is paid is open (round 3).

**Round 3, settled (23 October 2026)**
- **Word: blessing.** What a pet does for the farm out of grace, for free, by its own effect. This is what the pets' "jobs" in the code do today (weeds, stones, pests, water, makes), and they do not use the farmer's chores. A rename ticket (pets' "job" and "duty" words in text and code become "blessing") goes into `later`.
- **A blessing and an automated chore are two separate things.** Besides its blessings, a pet can be set to do the farmer's chores. **An automated chore costs the farmer the effective cost, exactly as if the farmer had done it.** The automation itself does not exist yet: it is a new feature (own folder, own grilling), not part of this refactor.
- **What farm-actions must allow for that:** `perform` is not allowed to assume the farmer does it. The check and the perform take "who does it" as an input, so automation can call the same chore later. Nothing in the refactor builds automation.
- **Automated chores have the same effect as the farmer's, without the farmer's extras** (no skill practice, no polish wear for the farmer). The farmer still pays the effective cost. Open for the automation grilling: the reason to keep the extras off (the farmer did nothing) against the reason to keep them on (the farmer paid).
- **Edge cases.** Planting: the check returns the total effective cost of the whole plan, as the working planting check does. A chore can be done with exactly the energy it costs; the button is grey only when energy is below the cost.
