# Spec: farm actions, one module that checks and performs every chore

**Status:** ready-for-agent

Words are in `GLOSSARY.md` (chore, act, base cost, effective cost, requirement, check, perform, report, price, blessing, automated chore). The architecture review of 22 October 2026 (candidate 1) and the grilling notes in `.scratch/farm-actions/issues/01-grill-and-spec.md` are the background. **This is a refactor: the golden runs must stay identical.**

## Problem Statement

Every time the child presses a chore button, the game works out the same questions in a different place: what does it cost now (skills, tools, season, buffs), is there enough energy, water or items, is the Lord's share paid. Each system answers them on its own. There are twelve separate "Too tired" checks across five systems, each button multiplies the energy by hand, and the cost drawn on a button can drift from the cost the rule charges. Coin payments check the Lord's share in different ways, and one of them (Wren's favour) does not check it at all. Because the answer is spread out, three planned features have nowhere to stand: the grey-button reasons, the action budget and automated chores by pets. For the parent and for every session that changes a cost, one change means hunting through many files and hoping none was missed.

## Solution

One farm module (a deep module with a small interface) answers two questions for every chore. **Check** says what the chore costs now (the effective cost) and which requirements are unmet, and changes nothing. **Perform** takes the effective cost, applies the chore's effect and the end-of-chore follow-ups, and returns a report. Buttons, the grey-button explanation, the bot and later the pets all ask this one module. Base costs and the skill a chore trains are written in data. Effects stay in the systems that own them. Every coin payment goes through one pay function that applies the Lord's-share rule the same way each time. The child sees no difference when this is done: same prices, same results, same random rolls. What changes is that a price on a button is the price the rule charges, by construction.

## User Stories

1. As the child, I want the energy on a chore's button to be exactly what the chore takes, so that I can trust what I read.
2. As the child, I want a chore I can afford to always work, so that a button is never grey when I have enough.
3. As the child, I want a chore with exactly the energy it costs to work, so that I can use my last energy.
4. As the child, I want the game to behave exactly as before after the change, so that my farm and my saved game are not disturbed.
5. As the child, I want one clear sentence when a chore cannot be done, so that I know what is missing.
6. As the child, I want skills, tools, the season and buffs to change what a chore costs everywhere in the same way, so that a better tool always feels better.
7. As the child, I want clearing a whole field to stop at the first patch I cannot pay for and tell me once, so that I am not shown many messages.
8. As the child, I want planting a plan to show the total cost of the whole plan, so that I know before I start.
9. As the child, I want the cost of a recipe at a station to be shown the same way as the cost of a field chore, so that I learn one way to read costs.
10. As the child, I want buying and goal payments to be blocked while the Lord's share is owed, in every shop and for every goal, so that the rule is the same everywhere.
11. As the child, I want the coins to fly to whoever I pay, every time I pay, so that paying always feels the same.
12. As the child, I want Wren to ask only for things that take energy, time, water or something I can make, so that no favour is ever stuck behind the Lord's share. (Follow-up ticket.)
13. As the child, I want a pet's blessing to stay free and to keep working as it does today, so that my helpers do not suddenly cost me.
14. As the child, I want a game that saves once after a whole-field chore, so that nothing is lost and the game does not stutter.
15. As the parent, I want one place where a chore's cost is written, so that I can change a number and see it everywhere.
16. As the parent, I want the base cost of every chore written in a data file, so that I can read all costs together.
17. As the parent, I want the rule that coin payments follow the Lord's share written once, so that I can check it once.
18. As the parent, I want the first build to change no number and no behaviour, so that I can trust the refactor without play-testing it all.
19. As the parent, I want the odd cases (Wren's coin favour, the dead seed-buying path, the orchard energy multiplier) kept out of the refactor and filed as their own decisions, so that each one is my choice.
20. As an agent building a feature, I want to ask the module for the cost of a chore instead of copying the energy math, so that I cannot get it wrong.
21. As an agent, I want to add a new chore by adding a data entry and one registered effect, so that a new chore needs no change in other systems.
22. As an agent, I want a test that fails when a button's cost differs from what perform takes, so that drift is caught at once.
23. As an agent, I want the check to be read-only, so that I can call it from the interface on every redraw without side effects.
24. As an agent, I want perform to return a report with a reason key and a child-friendly sentence, so that the interface and the grey-button reasons use the same words.
25. As an agent, I want the order of random rolls (luck, grade, per item) kept as it is, so that the golden runs stay identical.
26. As an agent, I want the end-of-chore follow-ups (polish wear, skill practice, save, redraw signal) in one place, so that no chore forgets one.
27. As an agent, I want job progress, perk checks, luck rolls and statistics to stay in the effect code for now, so that this change stays small and safe.
28. As an agent, I want the module to take "who does it" as an input, so that a pet can perform the same chore later.
29. As an agent, I want a requirement to be a named thing with a reason key, so that new requirements (store capacity, time) can be added without changing callers.
30. As an agent, I want cost to be an open set of kinds (energy, water, items, coins, later time), so that the action budget can be added without a new interface.
31. As an agent, I want the bot to call perform instead of copying each chore's steps, so that the bot and the game cannot diverge.
32. As an agent, I want short golden runs to the end of chapter 2 after every slice, so that I get fast feedback.
33. As an agent, I want a full golden run to chapter 6 when a slice touches a late system, so that the chapters the short run does not reach are still protected.
34. As an agent, I want a clear list of late features that the short runs do not reach, so that I know what to test by hand or with the full run.
35. As an agent, I want the old duplicated checks deleted at the end, so that no second copy of the rule remains to drift.
36. As the child's future pets, I want an automated chore to cost the farmer exactly the effective cost, so that automation is fair. (Not built here; the interface leaves room.)
37. As an agent, I want old saves to load unchanged, so that the child's game continues.
38. As an agent, I want German text for new reason sentences to go through the translation tool, so that the game stays bilingual.

## Implementation Decisions

- **Home.** A farm system called actions, in the farm layer's systems folder. It is designed so its generic part can later move to a kit with little work: a small interface, and farm words only in data and in registrations, not in the module's code.
- **Interface: two calls.** `check(chore, who, args)` returns the effective cost (an open dictionary of kinds: energy, water, items, coins; later time) and the list of unmet requirements, each with a reason key and a child-friendly sentence. It changes nothing. `perform(chore, who, args)` spends the effective cost, calls the chore's effect, runs the end-of-chore follow-ups and returns a report (done or not, the failed requirement, what was spent, what was gained, the message). The module alone says the message, saves once and tells the interface once.
- **Who does it.** Both calls take the doer as an input. In this build it is always the farmer. The module must not read the farmer's state directly except through that input, so a pet can be the doer in a later feature, with the farmer paying.
- **Scope of chores.** Field acts (plant, harvest, weed, pick stones, clear snow, cut tree, fetch water, muck out, collect), party, visit, the forest, the village trip, and recipes at stations. Spending coins (buying, goal and building costs) is not a chore but pays through the same function. Selling and earning stay out.
- **Numbers in data.** One entry per chore: base cost, which energy modifier applies (including winter-indoor and the village trip's errand multiplier), and which skill family trains. Recipes are read from the recipes data with no second copy. The energy math that is now in the needs system (modifiers, skill family multiplier, buff) is called by the module; callers stop multiplying by the chore's modifier themselves.
- **Effects in code.** Each chore's effect stays in the system that owns it and is registered under the chore's name. Job progress, perk checks, luck rolls and statistics stay in the effect code. The order of random rolls (luck, then grade, then per item) does not change.
- **Follow-ups in the module.** Only these four move: polish wear, skill practice, save, redraw signal.
- **Whole-field chores** are a batch of single chores: stop at the first one that cannot be paid, save once, redraw once, one summary message. The single chore is the unit and its cost is shown per patch. Planting checks the total of the whole plan, as the working planting check does today.
- **Energy rule.** A chore works with exactly its cost in energy; it is refused only when energy is below the cost. This is how it works today and must stay.
- **One pay function for coins.** Every coin payment is blocked while the Lord's share is owed, makes the coins fly to the payee, and the payment of the share itself is exempt. The trade, pace and Lord systems call this function instead of each checking for themselves. In the first build, Wren's favour keeps its current behaviour so the golden runs stay identical; her coin option is removed later in its own ticket (the content change: she never asks for coins).
- **Report reason keys** are the same words that `interface-feel/02` (grey-button reasons) will use for its sentences.
- **Blessings** (the pets' free work) are not touched. They keep their own effects and do not call the module.
- **Left alone on purpose** (each its own ticket and decision afterwards): Wren's coin favour, the unused seed-buying path in planting, and the different energy multiplier for orchard trees. The module must reproduce the orchard multiplier as it is.
- **Order of the move:** (1) short golden runs and the price-match test harness; (2) the module with the seven field chores (plant, harvest, weed, stones, snow, tree, water) and their buttons; (3) animals, party and visit, forest, the village trip; (4) recipes at stations; (5) coin payments through the one pay function; (6) delete the old duplicates, then the three oddity tickets and the Wren content change.

## Testing Decisions

- **A good test here** checks what the child or the bot can see: the cost on a button, what perform takes, the report, the farm state after a sequence of chores. It never checks which function called which.
- **One seam: check and perform.** Tests call these two, or the bot does.
- **Price-match test (new).** For every registered chore, over a set of situations (season, tools, skill ranks, buffs, indoors, winter), the effective cost that check returns equals what perform takes from the energy, water and items. It also checks that the cost the interface shows is the cost check returns.
- **Golden runs.** The bot plays a fixed-seed game; the farm state after each question is compared with saved text. Because this is a refactor, the existing full golden runs (seeds 1 and 2, chapters 1 to 6) must stay byte-identical. New short runs to the end of chapter 2 for seeds 1 and 2 are added, and `golden.sh` gets a chapter limit. After every slice run the short runs; run the full run to chapter 6 when a slice touches a late system, and once at the end of the feature.
- **Late systems the short runs do not reach** (for the full run or a hand test): the Lord's share blocking coins from chapter 3, Wren's check and the poisoning buff that doubles job costs, forest trips and the basket's room, the medicine recipes and the healing skill family with its rank gates, pets' blessings and WHEN cards in free play, wellbeing parties and visits.
- **Bot.** The bot calls perform instead of copying each chore's steps. Its fixed-seed behaviour is the golden run.
- **Prior art.** `tests/golden.sh` and the golden files; `tests/check_all.sh`; the per-system tests in the tests folder (crops, forest, lord, market, money, pets); the working `plant_plan` check as the first half of the idea.
- **Every game change** still needs what `.claude/skills/farm-game-check/SKILL.md` asks for: German through the translation tool, the smoke test, the bot, old saves loading, the design document.

## Out of Scope

- Any change to a number, a rule or a random roll (this is a refactor).
- Automated chores by pets (a new feature with its own grilling) and any change to blessings.
- The time cost of the action budget (`action-budget/01`), the grey-button wording (`interface-feel/02`), store capacity by bulk (`money-market/08`) and "going back takes a question" (`money-market/04`). The interface leaves room for all four.
- Selling and earning coins.
- Moving the generic part to a kit (designed to be easy later, not done now).
- Changing Wren's coin favour, the dead seed-buying path or the orchard multiplier; the pets' rename to "blessing".

## Further Notes

- The review used "action", "quote" and "cost"; read those as chore, check and effective cost.
- Facts found in the code: twelve "Too tired" copies (fields 7, well 2, animals 1, forest 1, trip 1); the energy math in the needs system (modifiers, winter indoor, skill family multiplier, buff); the planting check as the working prototype; harvest roll order luck, then grade, then per item; the pace and trade systems check the Lord's share, and the trade system sends the paid signal.
- A farm system must not know the interface. The report is the only thing that goes back to it.
