# 07: The village square is its own screen: a mockup made from the assets the game already has

**What to build:** Being in the square switches to a screen that is not the farm. This ticket builds a mockup of that screen from the pictures and assets already in the game folder. The parent will make better pictures later (`pictures/` M9).

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The square is a separate screen, not a window over the farm
- [x] It is composed from existing assets; every placeholder is marked in the ticket
- [x] The sell, buy, deliver and Back home actions work on it
- [x] Replacing the mockup with painted pictures later needs only picture swaps

---

**Feature:** `money-market` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.42]. Filed 23 October 2026.

The parent's words:

> [#23.42] being at the square switches the screen to one that is not the farm, you can make a mockup of the market square with the assets and pictures available in the game folder. I will create better stuff later on.

## Built (13 Nov 2026)

**What it is now.** While the farmer is in the village, a scene of the square stands where the farm was; the farm is not seen and cannot be
tapped. The stalls are pictures with a symbol (no words): 🪙 selling, 🌱 seeds, 🧺 the other traders (once one trades with the farm), 📦 a
cart for the orders (only while an order can be handed over), 📋 the notice board (parent, 13 Nov: it belongs on the square as well; it shows
what the farm's board shows and stays on the farm too), 🏠 the sign for the walk home. A tap shows that stall in the window below (always 60 % of the
screen high, no ✖); the open stall stands on a light spot. On arrival the likeliest stall is open (selling if something in the bag sells, else
the orders, else the seeds). The bag, quest book and album open over the scene and close back to the stall that was open. Coins fly between
the purse and the stall. No rule changed: the golden runs are identical.

**Built as a deep module (parent, 13 Nov).** `ui/square.gd` owns the scene, which stall is open and the window's frame, behind a small
interface (`add_stall`, `set_head`, `build_window`, `pick`, `sync`, `stalls`); it does not know what any stall offers. The part that owns
a stall's things registers it: `market.register_stalls` (selling, seeds, traders, orders), `placesheet.register_stalls` (the notice board).
A new stall is one entry in the data and one `add_stall` line; the notice board was added exactly so, reusing the farm board's sheet.

**Files.** New `game/farm/ui/square.gd` (`M.square`); `ui/places/market.gd` (one part per stall, registered); `ui/places/placesheet.gd` (the board);
`ui/sheets.gd`, `main.gd`, `ui/feedback.gd` (hooks); data `rules/49-trip.json` "square"; `tools/check_data.py` checks that block;
dev flag `--stall=`; smoke test line "village square" (and the grey-button sweep taps every stall); one new text, "🏘️ The village" /
"🏘️ Das Dorf". Saves: nothing new is saved (the open stall is not kept).

**Placeholders (every picture in the scene is one), all in `rules/49-trip.json` "square":**

| In the scene | Stand-in picture | To be replaced by |
|---|---|---|
| sky, hills, ground | two colours and the tile `tiles/path` | the painted square, `pictures/04`: save it as `assets/square/square.png` and it replaces sky, ground and all deco at once |
| houses, mill, trees, well, bench (deco) | `map/cottage`, `map/farmhouse`, `map/windmill_1`, `deco/tree_oak`, `deco/tree_pine`, `map/well_3`, `deco/bench` | part of the painted square |
| 🪙 selling stall | `map/market_stall` (the farm's own Market Stall picture) | a village stall, or an area of the painted square |
| 🌱 seed merchant | `map/market` (the old seed-market picture) | the seed seller with a face, `pictures/06` |
| 🧺 traders | `map/broker` (the Import Broker's cart) for all traders together | one picture and face per trader, `pictures/06` |
| 📦 orders | `addons/hand_cart` (the farm's hand cart) | the person who ordered, or a delivery spot of the painted square |
| 📋 notice board | `map/board` (the farm's notice board, the same picture) | a village notice board |
| 🏠 walk home | `map/village_sign` (the sign that points to the village) | a sign pointing home |

**Swapping later.** A stall's `art` is a picture name; with `art` empty a stall is an invisible tap area of `w` × `h` over the painted backdrop.
Places are shares of the scene (`x`, `y` = the middle of the lower edge, `w` = width).

**Assumed for the notice board (easy to undo, say if wrong):** it is on the square *and* still on the farm, with the same content; favours
are paid from the store as at home (only orders need the things in the bag).

**Not done, for the parent to decide (no ticket yet):** the stalls show all traders in one cart (one stall per trader would need `pictures/06`
first); the farm's goal button and Time Quiz clock stay usable in the village, as before; there is no village music.
