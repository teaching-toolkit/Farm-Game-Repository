# 02: Animal pen fences start run down; upgrades bring nicer fences

**What to build:** The fence around the animal pens looks run down at first, so there are more upgrades to the pens that also give nicer fences (less snagging and so on). The parent decides what the fence stages and their effects are.

**Blocked by:** None for the rules (built first with the old fence look; the new look is wired in after `pictures/13`, a later step)

**Status:** needs-parent

**Milestone:** prototype

**Size:** short

- [x] The parent has said what the stages are and what each does (what "snagging" means in play)
- [ ] Pictures for the fence stages exist (listed in `pictures/`)
- [ ] Upgrades are added as data with the new fence look
- [ ] Bot and explorer re-run

## ✅ Parent's answer (30 Oct 2026)

Yes: three stages. **Broken** at the start (wool snags, hens wander: the pen gives about 10 % less), **mended** (the first upgrade: normal), **sturdy and painted** (the second upgrade: a small bonus). As above, show it, don't write it: a hen outside the fence, a tuft of wool on the wire. Pictures: `pictures/13`.

---

**Feature:** `upgrades` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.14]. Filed 23 October 2026.

The parent's words:

> [#23.14] fence around the animal pens needs to more run down at first so we can have more upgrades to the animal pens that also include nicer fences (less snagging, etc.)

## Decision (17 Nov 2026, parent away, easy to undo)

- [x] Build the rules now with the old fence look; the new look follows when `pictures/13` is done. Why: the parent's answer is complete, the pictures cost credits and wait for the parent, and the rules need no picture.
- Three stages as the parent said: broken at the start (the pen gives about 10 % less), mended (the first upgrade: normal), sturdy and painted (the second upgrade: a small bonus, about 5 %, one number to tune). The same numbers for every fenced pen (chickens, cows, sheep); bees have no fence.
- The two upgrades are an upgrade path (the second replaces the first); costs use the materials of the chapter the pen comes in (sticks and rope to mend, planks and nails to make it sturdy).
- Re-run the bot and the explorer: every pen now starts 10 % lower, so check that no chapter's hours move more than 10 % against the run before.

## Progress

Rules built 17 Nov 2026 with the old fence look; the new look, the pictures and the explorer re-run are still open (so the three boxes above stay unticked).

- **Numbers** (`fence` in `data/farm/rules/10-farming.json`): `broken` 0.9 (about 10 % less), `sturdyBonus` 0.05 (about 5 % more, the one number to tune); mended is 1.0. The same for every fenced pen.
- **Rule** in the owner, `FarmAnimals.fence_stage` / `fence_factor` (`game/farm/systems/animals.gd`), multiplied into the collection's yield. A pen is fenced by `"fenced": true` on its node (chickens, cows, sheep); the bees have none. The stage is the upgrades' effect `fence:<animal node>` (0 none, 1 mended, 2 sturdy), so an old save simply starts broken.
- **Upgrades** as data, `data/farm/nodes/15-pen-fences.json`: `pen_fence_<chicken|cow|sheep>_1` (mend) and `_2` (sturdy and painted, `replaces` the first), optional, shown in the pen's window under "Upgrades (optional)". Materials of the pen's chapter: chicken ch1 stick 6 + rope 2 / stick 8, rope 2, log 2; cow ch2 stick 8 + rope 2 / plank 6 + rope 2; sheep ch3 stick 8 + rope 3 / plank 8 + nails 4 (plus a little energy). 💡 They are `type: helper` (not `building`), so they do not count as main-path goals (a building would shift the gift every 12 goals and the golden's goals column).
- **Words:** one line in the broken pen's window ("The fence is broken: mend it and they give more!"), the effect lines on the cards ("the pen gives all it should" / "a little more"), all 12 node texts; German added with `tools/i18n.py`.
- **Checks:** new `tests/animals_test.gd` (60 checks: each fenced pen at stage 0 = 0.9x, mended 1.0x, sturdy 1.05x, order of the two upgrades, optional, materials, bees unaffected, old saves load broken, stages survive a save), added to `tests/check_all.sh`. `saves_test` 96 OK, `check_data` 0 errors, `i18n --check` complete, `ui_smoke` no FAIL.
- **Golden (short, not recorded):** it differs. Seed 1: 402 -> 436 steps (+8.5 %), first differing line 66 (q78: the bot buys the chicken together with the mend upgrade instead of another purchase). Seed 2: 415 -> 312 steps (-24.8 %), first differing line 75 (only the inventory hash at q85: the first chicken collection at 0.9x). Split: the 10 % malus alone (no upgrade nodes) gives 413 (+2.7 %) and 416 (+0.2 %); the nodes alone (no malus) give 329 (-18 %) and 441 (+6 %). So the big swings come from the bot's generic "unlock what we can" loop buying the new optional upgrades in file order (it changes what it saves for), not from the malus. The bot was left alone as the brief said; the run with the baseline files reproduced the recorded golden exactly, so the change is the cause.
- **Decision (17 Nov 2026, parent away, easy to undo):** the short golden was RE-RECORDED on purpose (seed 1: 436 steps, seed 2: 312 steps; the full chapter-6 run is re-recorded once at the end, after the last pace ticket). A bot that ignores optional upgrades is the other way (a change to `tests/bot.gd`, then record again); the parent may ask for it.
- **Still open:** (1) done, see the decision above; (2) re-run the explorer (`bash tools/update_explorer.sh`, about 12 minutes) and compare each chapter's hours with the previous pacing run (within 10 %); (3) the new fence look waits for `pictures/13`.
