# 08: Paths wear in where the farmer walks most: the farm shows how this child plays

**What to build:** Every walk of the farmer wears the ground a little. Where he walks most (from the house to the field, from the field to the basket) the grass turns into a trodden brown track, slowly, over many days of play. The farm ends up showing where this child spends their time. No new pictures: the existing earth tile is laid under the most-walked stretches with a see-through strength that grows with the wear, and the wear is capped so it never becomes a road.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

**Size:** medium (a new small save key and one drawing layer)

- [x] One small module owns the wear (a system in `game/farm/systems/`, registered like the others): it counts the steps over the cells of the walking grid, and says how worn a cell is, 0 to 1; its numbers (how many walks make a track, the cap, how fast it fades if nobody walks there for a season) are data in `rules/`
- [x] The only thing the walker tells it is "the farmer walked this line" (where `walker.gd` finds a path); everything else is the module's business
- [x] A new save key in the module's `save_defaults()` (cell → count, small); old saves load with no wear; the count stays small (a cell is dropped at zero)
- [x] The ground layer (`map/ground.gd`) draws the earth tile under worn cells, as soft patches that join up (not squares), never over buildings, patches, pens or the road, and muted in winter like the rest of the ground
- [x] A test walks a line again and again and checks that the wear rises, is capped, and survives a save and a load; a screenshot of a farm after a long run (the bot's)
- [x] The short golden run is identical or recorded anew once on purpose (the wear is draw only, but a new save key changes the saved state: say which)
- [x] The `docs/design/map-and-interface.md` section for the map says what the ground shows

## Finding (16 Nov 2026): the game does not do it

Nothing counts where the farmer walks: `walker.gd` finds a way around what stands in the way and the farmer follows it, and the ground (`ground.gd`) is the same grass, earth and road whatever was walked. The road is fixed by the story, not by walking. Unlike idea 7 and 8 this one cannot be worked out from what is saved: it needs its own small save key.

💡 Slow on purpose: the first visible track should come after about one chapter of play, not after one afternoon; the numbers are data so it can be tuned by looking.

## Plan (16 Nov 2026, Sonnet agent)

1. **Goal:** every walk the farmer's path-finder plans adds one to each cell of the walking grid it crosses; the cell's wear (0 to a cap below 1) tints the ground there brown, as soft earth patches under everything else. Cosmetic only.
2. **Files:** new system `game/farm/systems/trodden.gd` (`G.trodden.wear(cell)`, `wear_of(cell)`, `worn()`, the season fade) + data `data/farm/rules/69-trodden.json` (walks for a full track, cap, first-visible wear, fade per season, drawing numbers); `game.gd` (register, clock step), `map/walker.gd` (the one call in `find_path`), `map/ground.gd` + `map/farm_map.gd` (a ground layer below the road, flat winter material), `tests/places_test.gd`, `tools/check_data.py`, `dev_flags.gd` (`--worn=N` for the screenshot), `map-and-interface.md`, GLOSSARY.
3. **Old saves:** one sparse save key `trodden` (cell "x,y" to a count), absent until the first walk; `save_defaults()` is `{}`, so a new game and `tests/golden/newgame.json` stay as they are and any old save loads with no wear (cells dropped at 0).
4. **The bot:** nothing. It has no map and never walks, so it never writes the key: the golden runs stay identical (the new clock step returns at once unless a season changed AND cells exist).
5. **Check:** a unit check in `places_test.gd` (wear rises monotonically to the cap, unwalked cells stay 0, fade drops cells, save and load keeps it, a save without the key loads); `ui_smoke` has no FAIL; one screenshot of a worn farm; short golden identical; `check_data.py`.

## Progress (16 Nov 2026)

Built by a Sonnet agent. `G.trodden` (`systems/trodden.gd`, `FarmTrodden`): `wear(cell)`, `wear_of(cell)`, `worn()`, `step` (the fade at a new season); numbers in `rules/69-trodden.json` (300 walks make a full track, cap 0.85 so at most 255 walks are counted, first patch at 0.12 = 36 walks, 6 walks forgotten per season, alpha 0.3 to 0.9, tile 2.6 cells wide). `walker.gd` `find_path` is the one caller (every cell of the planned line once per walk; cells that are solid are skipped). `ground.gd` draws it on its own layer made before the road's (so below the road, the fields and everything standing), with the flat season material (muted in winter, no snow caps).
- **Save key:** `trodden` ("x,y" to a count), sparse: `save_defaults()` is `{}`, the key appears with the first walk and goes again when the last cell is forgotten. `tests/golden/newgame.json` untouched; short golden identical, also `--strict` (the bot never walks).
- **Test:** `tests/places_test.gd` `_trodden_paths` (wear rises monotonically to the cap, unwalked cell 0, count stays at the cap, fade drops cells, save and load, an old save without the key); `ui_smoke` checks that the walks it plans are counted (no FAIL). Screenshot: `--load=res://tests/fixtures/ch3-seed1.json --nostory --worn=300` (new dev flag `--worn=N`, in the dev-flag list in `README.md`); the bot's own farm cannot show it, it has no map.
- 💡 Taken: wear counts when a path is *found* (as the ticket says), so a walk the child cuts short still counts; a fade of a few walks per season for every cell (not "since last walked"), so a cell stays only if it gets more than that per season. Both easy to change in the data.
- Left for the parent: tune by looking at a real play (the numbers assume about 3 walks per step and about 120 steps a chapter; the ticket's wish is the first track after about a chapter). The 3 chapters of the bot cannot show it.

---

**Feature:** `visible-work` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.7], "completely out of the box". Filed 16 November 2026 from `visible-work/01` idea 17.

The parent's words:

> [#14.7] [...] Please think of a bunch of other things that may be completely out of the box for me.
