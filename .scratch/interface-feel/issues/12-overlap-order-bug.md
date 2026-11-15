# 12: Things overlap each other in the wrong way

**What to build:** The parent has seen things drawn in front of or behind each other wrongly. Where exactly is not known yet, so nothing can be fixed until the parent names the screens (a screenshot each is best).

**Blocked by:** `interface-feel/15` (the agent's screenshots and list)

**Status:** needs-parent

**Milestone:** prototype

**Size:** short (look at the agent's screenshots, add what is missing)

- [ ] The parent has named the screens or situations (screenshots)
- [ ] Each is fixed or ticketed on its own
- [ ] The draw order rule is written into the interface README

## ✅ Parent's answer (30 Oct 2026)

Still wrong in places; come back to it later. 💡 Before asking the parent again, an agent takes screenshots of every screen and lists the wrong overlaps it finds; the parent adds the ones it missed.

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.43]. Filed 23 October 2026.

The parent's words:

> [#23.43] things overlapping each other in the wrong way

## Overlap survey (15 Nov 2026, agent)

Ticket `interface-feel/15`. 87 real-window pictures at 834 x 1194 (plus 3 re-shoots to check the two fixes), every one looked at; no SCRIPT ERROR in any run. 7 wrong overlaps found: 7 *ugly*, 0 *unreadable*, 0 *blocks a tap*. 2 are fixed, 5 are for the parent. No window picture covers a title or a close button; German texts (farm late, goals, settings) fit their boxes; story boxes, settings, grown-up menu, rest, Time Quiz, celebration, postcard and the knowledge card were all clean.

| picture | what overlaps | how bad | fixed? / for the parent |
|---|---|---|---|
| farm_early, farm_winter, farm_moments24 | On the short top bar of the first days the clock ring (top right) pokes up into the corner of the ⚙️ button | ugly | **fixed** in `game/farm/main.gd` (`_place_quiz_button()` now hangs the ring under the ⚙️ button when the bar is short; it re-places itself when the button moves). Re-shot `farm_early_fix`: clear gap; `farm_late_fix`: ring where it was |
| restgo | In the Rest sum page the little level bar hung above its words ("By heart 1/13 · Tiny sums") instead of on their line | ugly | **fixed** in `kits/learn/number_pad_quiz.gd` (bar centred on the line). Re-shot `restgo_fix` |
| every window with a picture (about 30: spot_*, early_*, end_*, patch0, sheet_forest, pests_water, ...) | The painted picture across the top of a window has square corners, the window and the cards around it are rounded; the picture's corners stick out over the window's round corners | ugly | **for the parent** (stop rule: needs a design decision on how to round it). Suggestion: a small rounded-mask shader on the picture (compute the corner from a `varying` local position set in `vertex()` plus a `rect_size` uniform; `UV` is not 0..1 under `STRETCH_KEEP_ASPECT_COVERED`, and `clip_children` is unreliable in gl_compatibility). Alternative: wrap the picture in a rounded panel. Keep the node name `WindowPicture` (`tests/ui_smoke.gd` looks it up). Code: `game/farm/ui/sheets.gd`, `_window_picture()` |
| toasts, toasts_early, news | A toast stack and the farm-news banner sit over the notice board and its 😴 marker at the top of the map | ugly (comes and goes after a few seconds) | **for the parent**: either let the toasts start lower on the map, or shift them to the middle band; a design decision, not one line |
| note_grey (kitchen, a greyed button) | The note popup that explains why the button is grey sits on top of the card's cost rows, the very thing it explains | ugly | **for the parent**: place the popup above the card instead of over it (needs the popup placement rule in `sheets.gd`, so more than a margin) |
| sq_seeds, sq_sell, sq_market (village square) | The farmer's hat overlaps Granny's skirt | ugly, minor | **for the parent**: painting detail of the square scene; move one figure a little (scene data), or leave |
| sq_seeds, sq_sell, sq_market (village square) | The jumping kid's shoe touches the 📦 bubble | ugly, minor | **for the parent**: same as above |

Not overlaps, but seen while looking (for the parent, no action taken):
- Mystery places (`windmill`, `greenhouse`, `sheep`, `bookcart`, `broker`, `barn_cellar`, `barn_ferment`, `barn_hay`, `barn_seeds`, `ws_loom`, `ws_tools`, and the early workshop and kitchen) show a faint "?" title but the full painted picture, so the picture gives the surprise away. `window_key()` in `sheets.gd` does not leave out places for which `M.mapview.mystery(sid)` is true; a one-line fix there is probably enough.
- Under every window picture the same big emoji is repeated; it reads as a double.
- The Cows sheet shows its description text twice.

Flags: all used flags existed. There is no separate forest flag; `--spot=forest` and `--sheet=forest` both open the forest window. Page 2 of a story piece cannot be reached (no page flag), so only page 1 of each story box was shot. The rocking of the clock cannot be judged in a still.

Pictures taken (names, in `scratchpad/ov/`, not in the project):
- Farm: farm_early, farm_mid, farm_late, farm_winter, farm_moments24, de_farm_late.
- Village square: sq_market, sq_seeds, sq_sell.
- Sheets and menus: sheet_bag, sheet_goals, sheet_album, sheet_scroll, sheet_log, sheet_forest, early_goals, de_goals, menu, menu_grownup, de_menu.
- Rest and quiz: rest, restgo, quiz, qid_pic.
- Patch windows: patch0, patch0_early, end_patch0, pests_water.
- Place windows (spot_): barn, barn_cellar, barn_ferment, barn_hay, barn_seeds, bees, board, bookcart, broker, compost, coop, cows, field, greenhouse, home, kitchen, library, living, lumber, market, orchard, pets, pond, road, sheep, storage, well, windmill, workshop, ws_bench, ws_fire, ws_loom, ws_tools.
- Place windows, early and late farm: early_forest, early_kitchen, early_storage, early_well, early_workshop, end_coop, end_kitchen, end_storage, end_well.
- Farm news, celebration, toasts: news, celebrate_shed, coins_big, postcard, card_wheat, toasts, toasts_early, note_coins, note_energy, note_grey.
- Story boxes (page 1): story_c1_book, story_c1_letter, story_c1_seller, story_c1_stalk, story_frame0, story_m_press_late, story_m_shed.
- Re-shoots after the fixes: farm_early_fix, farm_late_fix, restgo_fix.

Smoke test (`ui_smoke`, seed 1) after the two fixes: nothing printed (no FAIL, no SCRIPT ERROR). `check_all.sh` and golden runs were not run (forbidden for this agent). No new text was added, so no `i18n.py` run was needed.

**Orchestrator, 15 Nov 2026 (after the survey):** decided and fixed here: (1) the painted window pictures now have rounded corners and a thin outline like the cards (`UI.round_picture` in `kits/ui/ui.gd`, called from `sheets.gd`; shot with the store's window); (2) a mystery place shows no window picture (`window_key()` answers `""`). **Left for the parent** (look at these when playing): the toasts and farm news over the notice board; the note popup over the cost rows it explains; the farmer's hat and Granny's skirt, and the jumping kid's shoe on the village square (scene data); the same big picture of what stands there under every window picture (`spot_header`: 💡 keep, it shows what the child built; hide it only if the parent finds it a double); the Cows window's description twice (the place's text and the animal card's text are the same data). Still open: the story box's page 2 cannot be shot (no page flag).
