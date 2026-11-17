# 05: Stubble stays on a patch after the grain is cut, until it is sown again

**What to build:** When a grain patch (wheat, winter wheat, oats: the crops that give straw) is harvested, short golden stalks stay standing on it, instead of bare soil at once. They stay until the patch is sown again (or snow covers it). The child sees at a glance which patches were harvested and are waiting for the next crop. No new pictures: the stalks are drawn in code, a few short strokes standing on the soil, placed with the patch's own seed like the weeds.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

**Size:** quick

- [x] Which crops leave stubble is data on the crop node (a `stubble` flag on the grain crops), not a list in the drawing code
- [x] The rule (this patch is harvested, not sown again, no snow on it) lives in the fields system as one function that reads what the patch already saves (`last` is the crop harvested there and `crop` is empty until the next sowing); no new save key, old saves show stubble on their harvested grain patches
- [x] `IsoField.patch_spec` carries it; `IsoPatch.draw_top` draws a few short stalks per patch (number and look in the drawing's own constants, one place); the orchard and greenhouse leave none
- [x] A test harvests wheat (stubble), then sows (gone), harvests carrots (none), and loads an old save
- [x] A screenshot of a harvested wheat patch next to a harvested carrot patch; the short golden run is identical (draw only)
- [x] The `docs/design/farming.md` section for patches says what a harvested patch shows

## Finding (16 Nov 2026): the game does not do it

Nothing in the code or the data says stubble, sheaf or straw on a patch. After a harvest the patch is plain soil (`fields.gd` `_harvest_effect`: `crop` is emptied, `last` keeps the crop for the rotation rule). Sheaves that stand on the patch until they are carried in need a new picture: leave them out of this ticket; 💡 if the parent wants them, they join `pictures/15` and become their own small ticket.

## Progress

Built 16 Nov 2026. The flag is `"stubble": true` on `crop_wheat`, `crop_winter_wheat` and `crop_oats` (the three crops that give straw; hay and the rest leave none). The rule is `Fields.has_stubble(p)` in `systems/fields.gd`: the patch is empty, its `last` crop has the flag, and no `snow` lies on it (clearing the snow shows the stubble again). It reads only `crop`, `last` and `snow`, so there is no new save key and an old save shows stubble on its harvested grain patches. `IsoField.patch_spec` carries it as `stubble`; `IsoPatch.draw_top` draws 9 tufts of 4 short straw strokes each (the `STUBBLE_*` constants in `IsoPatch`), placed after the weeds and stones with the patch's own seed, so the weeds and stones keep their places. The orchard and the greenhouse have none because no grain grows there (slot by data), not because of a check in the drawing. Test: `_stubble()` in `tests/crops_test.gd` (wheat harvested: stubble; weeds do not hide it; snow covers it; an old save loads with it; sown again: gone; carrots harvested: none; a never-planted, a wild and a cut-apple patch: none). Dev flag `--stubble` (harvested) and `--stubble=ripe` (the same patches still ripe) for screenshots, with `--unlock=clear_thistles,clear_weeds,clear_rocks,clear_stumps --nostory --spot=field`: wheat, carrots and oats patches side by side; the stubble shows on the wheat and oats patches and not on the carrot patch. Short golden identical (draw only). The game has no per-patch "dig" chore (`patch_dug` is a field upgrade), so "sown again" is the only way the stubble goes besides snow. 💡 If the stalks look too faint or too many, change only the `STUBBLE_*` numbers.

---

**Feature:** `visible-work` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.7]. Filed 16 November 2026 from `visible-work/01` idea 8.

The parent's words:

> [#14.7] I have noticed that stuff that changes visually when the player performs work like clearing the field from weeds, and of course, crops is inherently satisfying. Please check the game for easy wins on adding more things that could be made visually visible.
