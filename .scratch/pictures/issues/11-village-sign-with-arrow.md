# 11: Replace the seed market picture with a sign pointing towards the village

**What to build:** The picture at the road where the player starts a trip becomes a sign with an arrow pointing to the village, made from an existing sign picture with an arrow added.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The seed market picture is gone from the road
- [x] A sign picture with an arrow pointing towards the village stands there and opens the trip window
- [x] `deco/signpost.png` (unused since J2) is checked as the base
- [x] Screenshots checked

---

**Feature:** `pictures` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.44]. Filed 23 October 2026.

The parent's words:

> [#23.44] seed market picture needs to be replaced by a sign pointing towards the village (use a sign picture and put an arrow on it)

## What was built

- **The base fits.** `deco/signpost.png` (316×501) is the same bold cartoon as its neighbours: thick dark-brown outline (`#432016`), flat wood colours, the same
  see-through blue shadow as the other map pictures, and the same board-on-a-post shape as `map/field.png` (the sign by the Home Field) and `deco/mystery_sign.png`,
  only blank and clean. Its board's long side runs down to the right at about the slope of the village road (the road goes from the top of the map down to the right edge,
  where the village is; the travelling merchant's cart also rolls in from that end), so an arrow along the board points along the road.
- **The new picture** `godot-prototype/assets/map/village_sign.png` (new file; `map/market.png` is untouched and no longer referenced): the blank sign with a cream arrow
  (the colour of the paper on `map/field.png`) with the board's own dark-brown outline, a slightly darker rim on its lower right and rounded corners, pointing right along the board.
  No words.
- **How it was made:** Pillow is not installed here (and nothing may be installed), so it is drawn by Godot itself: `godot --headless --path . --script res://tools/make_village_sign.gd`
  (`godot-prototype/tools/make_village_sign.gd`, `Image` class, no Python). It reads `deco/signpost.png`, measures the board's four corners, draws the arrow as a rounded
  shape with signed distances (smooth edges, no jaggies) and saves `map/village_sign.png`; run it again to redo the picture. Import once afterwards.
- **Wiring (data, one tiny code change):** `data/farm/places.json` has a new `placeArt` (`{"market": "village_sign"}`): the picture a place uses for itself when nothing built there has one.
  `Spots.place_art(sid)` reads it and `FarmUiMapView.art_keys` ends with it instead of the bare place name (a place without an entry behaves as before). `data/map_layout.json`:
  the market place's width for the new picture, `ws: {"village_sign": 80}` (was `{"market": 120}`; the sign is taller than wide, so 80 gives a sign about two farmers high).
  The place keeps its footprint and position, so the tap (on the picture's visible pixels, board and post) opens the trip window as before.
- **Lists and tools:** `tools/art_list.py` lists `assets/map/village_sign.png` instead of `map/market.png` (the CSV in `art-inbox/` is refreshed with `python3 tools/art_list.py`);
  `tools/check_data.py` checks `placeArt` (place exists; picture exists = warning); `tools/make_layout_editor.py` shows the sign for the market place
  (run it once to rebuild `tools/layout-editor.html`: needs Pillow, which this copy does not have). `tests/places_test.gd`: three checks for `placeArt`.
- **Screenshots** (834 wide, the game's normal view): the sign stands at the road's lower edge at the right of the map, the arrow points down the road towards the right edge;
  seen in spring, autumn and winter (the season look adds a bit of snow on the board in winter; the cream arrow stays clear); the market window opens with the sign as its picture
  and the *Go to the village* button; with the Market Stall built the stall stands there (see 💡).
  The arrow is a flat painted shape on the wood with no shine, no rounded-button frame and no shadow of its own, so it reads as a sign painting, not as a button.

## 💡 Decisions to confirm

- **After the Market Stall (a building in chapter 2, +10 % on sales) is built, its own picture (`map/market_stall.png`) still takes over the place on the road**, as before; the tap still opens
  the trip window. Only the *seed market* picture is replaced, as the ticket says. To keep the sign always (the stall then shows nowhere on the map): set `artChains.market` to `[]` in
  `data/farm/places.json`; the places golden's `art_chains.market` then changes from `["market_stall"]` to `[]` (record it again with `places_test … --record`).
- **Size:** the sign is 80 px wide (about 125 px high) at the design size, smaller than the old stall (120 wide). Change `ws.village_sign` in `data/map_layout.json` (or in the layout editor) to taste.
- **Arrow style:** cream with a dark outline. Another colour or a thinner arrow is a change of the constants at the top of `tools/make_village_sign.gd` and one run.

