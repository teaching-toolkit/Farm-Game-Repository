# 07: A station that is working shows it: smoke from the chimney, a glow at the fire

**What to build:** While something is cooking, baking, firing or forging, the place shows it: a few soft puffs of smoke rise from the chimney of the house or the workshop, and the fire's mouth glows warm; when the batch is done the smoke thins out and stops. The child sees that the work is going on, and does not need the ⏳ symbol. Drawn in code (small grey circles that rise and fade, and the soft glow the ripe plants already use): no new pictures.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

**Size:** quick

- [x] "Is something running at this place?" is asked once, in one function that reads `S["running"]` (the same count the ⏳ badge of `mapview.gd` uses; the badge then calls the function too)
- [x] Where the chimney and the fire stand on each building's picture is data (fractions of the picture, like `bench` in `places.json`); a place without an entry shows nothing
- [x] The puffs are drawn by the place's own slot (`map/slot.gd`), a few at a time, rising and fading, slow enough not to be busy, straight up
- [x] Smoke starts at once when a batch starts and stops when it is done or collected; the farm map and the inside view of the house and workshop agree
- [x] A test starts a batch and checks the function; a screenshot of the house with a loaf in the oven and without; the short golden run is identical (draw only)
- [x] The `docs/design/making-things.md` section for stations says what a working station shows

## Finding (16 Nov 2026): the game only half does it

A working station shows only the ⏳ badge on its place (`mapview.gd` `badge`). The workbench shows the tools that have been **made** lying on it (`mapview.gd` `_bench_things`, `places.json` `bench`), which is not the same as showing what it is doing. No smoke, no glow, nothing hangs on the drying rack.

💡 **Left out because it needs pictures (through `pictures/15`):** the thing being made lying on the bench, and herbs hanging on the drying rack. They need a picture for each thing, so they become a later ticket once the picture list is made; smoke and glow carry the idea without them.

---

**Feature:** `visible-work` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.7]. Filed 16 November 2026 from `visible-work/01` idea 14.

The parent's words:

> [#14.7] I have noticed that stuff that changes visually when the player performs work like clearing the field from weeds, and of course, crops is inherently satisfying. Please check the game for easy wins on adding more things that could be made visually visible.

## Progress (16 Nov 2026)

Built as written. `G.crafting.place_state(sid)` ("working" / "idle", from `S["running"]`, same count as before) is the one answer; the ⏳ badge in `mapview.gd`, the map slot and the corner slots inside the house and workshop all ask it. `places.json` `fires` holds where the chimney (`smoke`) and fire mouth (`glow`) stand on each picture (`map/…` and `interior/…`, fractions of the picture; no entry = nothing). `map/work_fx.gd` (a child of the slot, `slot.working` set before `set_state`) draws four slow puffs (5 s to rise, straight up) and a breathing glow (the ripe plants' `glow_tex`, tinted warm), from `Time.get_ticks_msec()` only. When the work ends no new puff starts and the glow fades in 1.2 s.
Checked: `tests/places_test.tscn` (starts sourdough starter in the oven: kitchen and home working, workshop idle; steps to the end: idle, the starter in the store; then bricks in the kiln: ws_fire and workshop working; every `fires` entry is a point on a real picture); ui_smoke no FAIL; short golden same for seeds 1 and 2. Screenshots (`--load=res://tests/fixtures/ch3-seed1.json --cook=oven_1,kiln`): the map with and without work, the inside of the workshop (kiln glow and smoke) and of the house (stove glow and pipe smoke).
💡 Easy-to-undo choices: there is no "ready" state (a finished batch goes to the store at once, so idle is the only state after working); the fractions are by eye from the pictures (the thatched `cottage_loft` has no chimney: no entry; the pot of the campfire and stove 2/3 steam instead of smoking); new dev flag `--cook=station,station` for screenshots (README); the season shader skips nodes with the meta `plain` (one extra condition in `season.gd apply_tree`).
