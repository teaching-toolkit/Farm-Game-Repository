# 02: What do rocks and weeds really do to a field? Decide if they should cost crops

**What to build:** The parent noticed that rocks and weeds do not seem to change the number of crops. They don't: in the code they slow growth (each weed and each stone by 4 %, down to half speed at worst), lower the grade of the whole harvest, and cost energy to clear. The number of plants is not affected. Decide whether they should also reduce the yield, or something else should hinder the player.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The parent has decided: keep as is, or also reduce the number of plants (and by how much)
- [x] Whatever is decided is shown to the child (the patch's note says what the weeds and stones cost)
- [x] If the rules change: numbers in data, bot and golden runs re-checked, German

## ✅ Parent's answer (30 Oct 2026)

Swap: weeds and stones no longer slow growth; each one takes **4 % of the harvest, at most 75 %**. The effect on the grade stays. **Don't rely on reading:** the loss must be *seen*, not written: for example fewer plants drawn on a crowded patch, and at harvest the lost crops shown leaving or greyed out next to the weeds and stones. Text may follow, but the picture carries it.

---

**Feature:** `crops-and-items` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.13]. Filed 23 October 2026.

The parent's words:

> [#23.13] rocks and weeds don't seem to influence the number of crops growing on a field right now, do they only influence the speed of the growth or how do they hinder the player?

## What was built (9 Nov 2026)

The parent's swap, as decided on 30 Oct 2026:

- **Rule** (`game/farm/systems/fields.gd`, numbers in `data/farm/rules/10-farming.json` under `crowding`: `perThing` 0.04, `max` 0.75, `keepMain` 1): weeds and stones no longer
  slow growth (`slow_factor` and `stones.slowPerStone` are gone). At harvest every **whole** weed and every **whole** stone on the patch takes 4 % of the harvest, together at most 75 %;
  the loss is applied to the whole harvest (crop, by-products, upgrade bonuses), the fraction rounded at random so the average holds, and the main crop never drops below 1.
  The grade still falls with weeds and stones (`quality.gd` is untouched). "Stone" is generic (the patch's `stones` number), so `nature/04` can split small stones and big rocks later without touching this.
- **Seen, not read:** on the map the plants the weeds and stones take (`round(plants × loss)`) stand small, grey and drooping while the rest stay green (a grey copy of the crop's own picture, made once
  and cached); at harvest the lost crops rise from the patch as grey ghosts, one per piece, beside the weeds and stones that stay (`G.crowded_out` → `mapview.on_crowded` → `FarmMap.ghosts`, queued while a pop-up is open).
  The patch's window shows a red 🌿🪨 −48 % with the lost crops in grey, the plants row greys the crowded ones, the harvest button shows only what stays, and one line says
  "each weed and each stone takes 4 % of the harvest" (the weed and stone tiles say the same). The log adds "Weeds and stones took …". German through `ui-de.json`.
- **Tests:** `tests/crowding_test.gd` (new, in `check_all.sh`: the numbers in data, whole things, the 75 % cap, no slowing, the mean of many harvests falls by the share, the lost crops are told,
  the main crop keeps 1, pulling gives it back, no new save key); `ui_smoke.gd` has one block at its very end (named `crops-and-items/02`).
- **Bot:** pulls the weeds and picks the stones of a ripe patch before harvesting it (when two or more stand on it), and prints how much of the harvest the weeds and stones cost per chapter
  (`--noclear` plays the old way). The explorer's data copy was synced (`tools/sync_progression.py`); its own model never used the slowing, only the weeding energy, so nothing else changed there.
- **Docs:** `docs/design/farming.md` §6.2, §6.3 (and `map-and-interface.md` §13.4), `godot-prototype/README.md` (and the new `--crowded` screenshot flag).

## 💡 Decisions to confirm

All easy to undo (a number in data, a line of code):

- **Whole weeds and stones count** (a weed at 0.6 is neither drawn nor pullable, so it costs nothing). Undo: use the float in `crowd_things`.
- **The main crop never drops to nothing** (`keepMain` 1): a one-plant patch under 75 % still gives 1. Undo: set `keepMain` to 0.
- **The loss is worked out at harvest, not while growing**: weeds that come and go during the growing time cost nothing, only the ones standing there on harvest day; pulling before gives it all back (the "never stuck, can always be corrected" rule).
- **Wilted plants are whole plants** (`round(plants × share)`): on a patch of 1 or 2 plants a few weeds show nothing grey (the harvest still loses its 4 % each, shown by the −% and the ghosts).
- **Ghosts:** at most 8 per kind of crop. By-products (straw) are lost and shown in the same way.

## Pace and difficulty (the bot, 9 Nov 2026)

A deliberate rule change, so the golden runs changed and were **not** recorded (the orchestrator records them after merging): the short run (to chapter 3) is now 356 steps for seed 1
(was 304) and 411 for seed 2 (was 447). The first difference is at step 3: a half weed used to slow the first wheat just enough to delay its harvest by one step.

Chapter 5 reached after this many steps of time (the bot plays randomly and the spread between seeds is wide, so only the mean means something):

| seed | old rule | new rule, bot as before (`--noclear`) | new rule, bot clears a ripe patch first |
|---|---|---|---|
| 1 | 864 | 1033 | 968 |
| 2 | 986 | 987 | 872 |
| 3 | 852 | 925 | 999 |
| 4 | 902 | – | 868 |
| mean | 901 | 982 (seeds 1–3; the old rule 901 on the same seeds) | 927 (+3 %, inside the noise) |

What the weeds and stones cost, measured at every field harvest: a bot that clears a ripe patch first (two or more on it) loses **about 2 %** of its harvests (1.7–2.5 % per chapter, 43–63 % of the
patches had something on them); the old bot, which only cleared from 3 weeds / 2 stones, loses **5–9 %** (rising per chapter as the weeds grow faster). The old rule slowed growth by 5 % (clearing bot) to 8–13 %
(old bot) *at harvest* (about half of that on average over the growing time). So the swap is about as hard as before: slightly **easier** for a player who pulls weeds before harvesting, slightly
**harder** for one who lets them stand (up to 9 % of every harvest), and much **harder only in the extreme**: a neglected patch with 12 weeds and 6 stones now gives 28 % of a harvest (the old rule only
doubled its growing time). The worst case is a loss the child can see and undo with one tap on "Pick all weeds / stones". No change to `meta.flex.basePace` is needed: the bot's pace per goals done
stayed in the same range (explorer data copy synced).

Not run: the explorer check (Playwright is not installed here); the explorer's own model never used the slowing, so it does not change.

