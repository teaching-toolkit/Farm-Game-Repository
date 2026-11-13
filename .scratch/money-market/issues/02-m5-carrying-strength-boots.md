# 02: M5: Carrying grows with strength; boots and a borrowed donkey make trips cheaper

**What to build:** How much the farmer can carry also depends on strength, and the trip's energy gets cheaper with boots or a borrowed donkey (a favour). Today only the carrying device and the road count; strength is not used in the trip at all. The notes also hold a 💡 question (does the room count each way separately?); if the parent is there, ask it first.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Strength (from the wellbeing model) raises carrying capacity
- [x] Boots lower the trip's energy cost; a borrowed donkey does too, as a favour from someone helped
- [x] The each-way question is answered and what the game does is written down
- [x] Pace re-checked with the bot (trips)
- [x] Golden runs re-recorded on purpose (not recorded by the session that built this: see `## Progress`)
- [x] German through `tools/i18n.py`; the data checker passes

---

**Id:** M5 · **Feature:** `money-market` · **Moved from** `archive/todo-2026-10.md` §7 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **M5. Carrying and the trip's energy** [#1], [#2]: how much the farmer can carry depends on the carrying device (backpack → basket →
  cart; the existing carrying gear for gathering can count too), and on **strength** (L2). The trip's energy is a farmer number too: a
  flat cost that gets cheaper with a better road, a better cart, boots, strength, or a borrowed donkey (a favour). Later: the wheelbarrow,
  the hand cart, the **pony** (job card "carry surplus to market and sell it", S2).
  💡 The room counts **each way separately** (a full load there, a full load back), the same size both ways (proposed in R1; the
  answer reshaped the trip and didn't say; confirm when D1 is written).

## What was built (9 Nov 2026)

**What existed.** Strength is the wellbeing parameter `strength` (`G.well.value("strength")`, 0 to 1; every farm starts at 0.5, it is frozen there until chapter 2, and its target is 0.35 + 0.05 per skill rank + gear, so it rises as the farmer practises); it only moved the energy maximum, not the trip. **Boots already existed**: straw sandals, wooden clogs, hobnail boots, waxed walking boots and the polish for the boots all carry `energy:errand` (−5 %, −10 %, −15 %, −20 %, −10 %), and the trip's chore already multiplies by that (`rules/46-chores.json`: `mult: energy:errand`; the two big rucksacks and the gift card *Light Step* are on that key too). So "boots lower the trip's energy" was true, but the cost is `3 ⚡` rounded **up** to whole ⚡, so a boots saving of 5 to 20 % shows only once the road is better: at road level 3 (0.7 × 3 = 2.1) a pair of boots makes the trip 2 ⚡ instead of 3; on the muddy track and the first roads nothing shows. No donkey existed anywhere in the data.

**Strength carries more.** `capacity()` is now the plain capacity (arms or the best carrying thing) × `strength_mult()`, in whole load units. Above `strength.from` (0.5) every point of strength adds `strength.perPoint` (0.6) of the capacity: full strength carries 30 % more, a farmer at the middle (every farm at the start) carries exactly what he carried, and a weak farmer is **not** made to carry less. Before chapter 2 the wellbeing is frozen, so nothing changes there. The numbers are `strength` in `rules/49-trip.json`. The bag's window gets one line when strength adds something: "💪 You are strong: your strength adds N room." (German through `i18n.py`); the strength row on the wellbeing dashboard says "…and you can carry more". Nothing else needed to change: the 🎒 bars, the room for buying on the square and the bot all read `capacity()`.

**A borrowed donkey, as a favour.** New data only, in the existing style: the favour *Soup for a sick neighbour* (chapter 2, Old Jan; needs the stove, tomatoes and the bunny) now has a helper as its reward, like other favours: `jans_donkey`, "Old Jan's donkey" 🫏, a gift helper (given when the favour is done, with the usual celebration pop-up), effect `energy:trip ×0.6`. The trip's chore reads the new key `energy:trip` next to the road (`_energy_factor` in `trip.gd`), so the donkey makes the walk to the village cheaper **and nothing else** (deliveries and favours keep their energy). With ×0.6 a trip at the first roads costs 2 ⚡ instead of 3. **Where it comes in the story:** in chapter 2, after the first pet (the bunny) has come home and the child has cooked tomato soup, so at about the time the gravel road (level 3, 300 🪙) is built and trips begin to be frequent. **The bot learned it:** `_needed_items` in `tests/bot.gd` now wants the soup for Old Jan (an exemption like the hand cart's axle, since optional things are otherwise skipped), so the bot does the favour and gets the donkey (checked: seed 1 has `sq_sick_neighbour` and `jans_donkey` at the end of chapter 2).

**Does the room count each way separately?** Yes. What the game does today, and what is now written in `docs/design/money-and-market.md` §5.3b: the capacity is the room for the way there (what is packed to sell or hand over) **and** the same size room for the way home (what is bought on the square, `buy_room()`); the two are counted separately and are the same size, they do not share one load. Strength, the carrying thing and nothing else change both together.

**Tests, written first:** `tests/trip_test.gd` (strength: nothing before chapter 2, +30 % at full strength, +15 % at three quarters, nothing at the middle or below, whole units, on the carrying thing that is owned; boots lower the cost at road level 3; the donkey lowers it and only the trip; the favour's reward is the donkey; they failed when the rule and the data were taken out), `tests/actions_test.gd` (the trip's price-match now includes `energy:trip`, with a situation that has the donkey). `docs/design/` updated: `money-and-market.md` §5.3b, `energy-and-wellbeing.md`, `friends-and-story.md`; German for the new texts through `i18n.py`; `check_data.py` passes.

**Pace.** See the table in `04-going-back-takes-a-question.md` (both tickets are in the same patch, so the bot runs measure them together). On its own `02` is small: strength becomes more than 0.5 only after about three skill ranks, so capacity grows by a few load units in the middle of chapter 2 and by 10 to 20 % later; the bot makes about as many trips as before (222 before, 210 to 231 after).

## Progress (9 Nov 2026)

Built and checked in a private copy, together with `money-market/04`. Open: the golden runs, which change on purpose (the walks home from `04`, strength and the donkey) and are not recorded by this session. Also changed on purpose: `tests/golden/places.json` (two entries: `spot_of` gets `jans_donkey: field`, and `nodes_at.field` lists it after `sq_sick_neighbour`; the places test reports exactly these two differences). Record: `$G --headless --path . res://tests/places_test.tscn -- --seed=1 --record` and the golden runs of `04`. Then tick the box above and set the status to done. Not done: `python3 tools/sync_progression.py` (the explorer's copy of the data does not know the donkey yet; `Update explorer.command` does it).

## 💡 Decisions to confirm

- 💡 **Strength: `from` 0.5, `perPoint` 0.6** (`strength` in `rules/49-trip.json`): full strength carries 30 % more, the same top as the energy dial (×1.3). Chosen so that nothing changes at the start and a weak farmer is never made to carry less ("never stuck"). To change: the two numbers; `perPoint: 0` switches it off. To make weakness cost room as the energy dial does, `strength_mult()` in `trip.gd` would need to drop the `maxf(0.0, …)`.
- 💡 **The donkey: ×0.6 on the trip's energy, `energy:trip` in `jans_donkey` (`nodes/09-side-quests.json`)**, a trip 3 → 2 ⚡ at the first roads (because of rounding up, 0.6 is about the smallest number that shows a saving on its own). To change: that number.
- 💡 **The donkey comes from Old Jan** (the favour *Soup for a sick neighbour*, chapter 2: he is ill in bed, so his donkey has nothing to do). Any other favour without a helper would do (the twins, Bo the apprentice, the miller …). To change: move `"helper": "jans_donkey"` and the helper's `requires` to another favour. The story has no donkey line yet (`story/game/texts/more-ch2.md`, the scene `c2_jan`); the story track may add one.
- 💡 **The donkey sits in the slot `board`** like the other gift helpers, so it lands at the `field` place (same as the horseshoe, the bell, the chime). A 🫏 picture `helpers/jans_donkey` does not exist; the emoji shows until it does (a picture for `pictures`).
- 💡 **A new modifier key `energy:trip`** instead of `energy:errand`, so the donkey makes only the walk to the village cheaper and not every delivery and favour. To change: put `energy:errand` in the helper's effect and drop the factor from `_energy_factor`.
- 💡 **Boots left as they are** (errand −5 to −20 %). Rounding the trip up to whole ⚡ hides a boots saving on the first roads; if the parent wants boots to show from the start, the base `energy.base` would have to be larger or the trip rounded to the nearest whole ⚡ (`round` in `rules/46-chores.json`), both of which move the pace of every trip. Not done.
- 💡 **The wellbeing hint and the bag line:** "…and you can carry more" on the strength row and "💪 You are strong: your strength adds N room." in the bag window. Two texts.
- 💡 **Each way separately, the same size** is kept as the rule (see above), since it is what the game did and what the parent's answer in `money-market` shaped.

## Golden runs recorded (9 Nov 2026, after merging wave 1)

Recorded on purpose on the merged result of five tickets (weeds and stones, the walk home and carrying, the chapter frame, tap notes, the sign picture): short runs 312 and 322 steps (were 304 and 447), full runs 623 and 642 steps (were 636 and 771), places golden with `jans_donkey` (placed at `field`). The new numbers come from all five changes together, not from this ticket alone.
