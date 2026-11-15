# Spec: pets do the farmer's chores (automated chores)

Decided by Claude on the parent's standing permission ("everything except the four needs-parent tickets Claude can solve with a good recommendation"), 15 Nov 2026, after the action budget was built. Everything here is data or one small rule, so the parent can change any of it after the first play-test. Nothing is built before `02`.

## What it is

Besides its **blessings** (free, small, by the pet's own effect: they stay as they are), a pet can be set to **help with one of the farmer's care chores**: it does the same chore the farmer would do, the farmer pays its **energy** (and water or items where the chore takes them), but **no moments**. So a pet gives the farmer *time*, not energy: the child still has to keep energy for itself, and the budget of moments (`action-budget`) is what the help is worth.

## Rules (the answers to the ticket's questions)

- **Which chores:** only the care chores that repeat all day: `weed`, `pick_stones`, `pick_loose`, `fetch_water`, `clear_snow`, `muck_out`, `collect_animal`. Not: planting and harvesting (the child's choices and joy), cooking and recipes (the child's craft and sums), the forest, trips, visits, parties, felling trees. Harvest may join later if the parent wants it (one line of data).
- **Which pet does which:** each pet can help with two chores that suit it (data in `54-pets.json`, e.g. bunny: weeds, loose things; tortoise: water, snow; goat: weeds, muck; pony: loose things, water; badger: stones, muck; alpaca: collect from the pens, muck). A pet is **never** set to a chore of a place that is not built.
- **How the child sets it:** in the pet's window, the same place as the job choice: under the blessings a second group "Helps with" lists the pet's two chores with the ⚡ symbol (no number). Choosing one takes the pet's rule slot (a pet's first rule or its second, level 4) exactly like a blessing does: **a rule is either a blessing or a chore**. From **level 3** (the level that has WHEN cards): the WHEN card is what keeps the farmer from being drained: the chore card's default is "only when my energy is above" with a slider, default high enough to leave a third of the bar.
- **When it runs:** at every question, in the pets' step, after the farmer's own turn, one chore per pet per question, as the pets' blessings do today. It runs through `G.actions.check` / `perform` with the pet as the doer (module is ready: `Doer`, `moments_of` is 0 for anyone but the farmer).
- **Too little energy (or anything else missing):** the rule simply waits: the pet shows 💤 ("waiting for you to rest") in the pets' window and on the board, nothing is spent, nothing is lost. The pet never takes the farmer below what the WHEN card leaves.
- **What the target is:** each owner of a chore registers how a pet picks its target (`G.actions.register_auto(chore, picker)`; the picker returns the chore's `args` or `{}` when there is nothing to do): the patch with most weeds, the stoniest patch, the pen with most muck, the pen with the most ready, the nearest loose thing. One function per owner, the actions module only calls it.
- **Same effect, no farmer extras** (the parent's choice for now): no skill practice, no tool wear, no skill-rank discount. The effect is exactly the farmer's.
- **In the playback:** the existing pets' walk: the pet runs to the patch or pen, the chore's own picture happens there (the weed disappears), then back. The chore's emoji is shown over the pet.
- **Does it make the child's play pointless?** No, because: it costs the farmer's energy (one chore per pet per question is small against 18–32 moments); it covers only the care chores; planting, harvesting, selling, cooking, the forest and the quiz stay the child's; and there are six pets at most, the first ones only from chapter 3 (level 3).
- **Word:** the glossary keeps **automated chore** for the builders; the child's text says "Helps with" (German "Hilft bei") and never "automated".
- **Old saves:** the rules already store job ids per pet (`G.S["pets"]`); a chore is one more job id, so no new save key.

## Pieces

`pets-automation/02` the module (jobs of kind `chore`, the pet's doer, targets, no moments, tests) → `03` the targets and the pets' chores in data (owners register pickers) → `04` the child's side (window, WHEN card, playback) → `05` the bot uses it, tuning and one play-test.
