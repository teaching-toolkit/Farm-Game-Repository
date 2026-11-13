# 08: Store capacity depends on how bulky things are, like the bag, instead of 10 of everything

**What to build:** Today the store holds 10 of each thing at first. Instead its capacity is counted in load units, like the bag: it holds many feathers and few logs. Upgrades raise it.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] A short plan is written into this ticket first (session skill §3): units, starting numbers, upgrades, saves
- [x] The store counts the weight classes of M4 instead of a count per item
- [x] Store upgrades raise the capacity; old saves load
- [x] Bot and golden runs re-checked (re-recorded on purpose if the pace changes)
- [x] The store tile or bar shows the room left; German through `tools/i18n.py`

---

**Feature:** `money-market` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.37]. Filed 23 October 2026.

The parent's words:

> [#23.37] capacities for stuff in the storage is 10 for all at first and more later on. It needs to be scaled to the bulk/size/weight or whatever the parameter is called. So it can hold a lot of some things but not others. Similar to the bag.

## Plan (written before building, 10 Nov 2026)

- **Units.** The weights of M4 (feather 0.1 … heavy 4). The store gives **each kind of thing its own shelf** of `storageLoad` load units (data key, was `storageCap`); the count that fits is the shelf divided by one's weight (`needs.storage_cap(k)`). Basket 40, Log Shed 100, Warehouse 240 (= the old 10 / 25 / 60 at the weight of a heavy thing, 4), Deep Pockets gift +20 (was +5).
- **Why a shelf per kind and not one shared load.** The farm's passive producers (woodlot, pets) and the harvests put things in by themselves; a shared total would let a woodlot full of logs block eggs and carrots, and the 35 big rocks of the paved yard would not fit with anything else. A shelf per kind keeps heavy things exactly where they were, and everything lighter holds more. Easy to turn into a shared total later (one function). 💡
- **Saves.** Nothing is stored: the data key changed only. An old save above a new cap cannot happen (caps only grew for lighter things; heavy ones are the same).
- **Bot / pace.** It reads `storage_cap(k)` where it read the single cap; the pace check of `money-market/04` is re-run. Light things overflow less, so the pace can only get a little faster.
- **Shown.** A thing's pop-up (`pantry.item_panel`) says "room for N" with its stock bar; the upgrade's effect line says what a shelf is. German through `tools/i18n.py` and `set_de`.

## What was built

`needs.storage_load()` / `storage_cap(k)`; `inventory.add_item`, `trade.buy_item` and the price flex's ceiling (`pace.flexed`) use it; data keys, descriptions and the gift renamed; docs (`store-and-materials.md`, `building-and-upgrading.md`); the bot's three reads. The store sheet's tiles do not show a bar per tile yet (they never did); the pop-up does.

## 💡 Decisions to confirm

- A shelf per kind of thing (not one shared total). Undo/change: `needs.storage_cap`, one function.
- Numbers 40 / 100 / 240 and the gift's +20: heavy things hold what they held. Undo: `storageLoad` in the three nodes and `gc_deep_pockets`.
- Seeds are not part of it (they were never in the per-kind cap).

## Pace (parent decided 11 Nov 2026: keep it as built)

Bot, steps to chapter 5 (seeds 1/2/3): **912 / 885 / 887**, was 1091 / 1090 / 1099 on the wave-1 tree (same bot fix); that is 18 % shorter and back at the pace before the walk home (about 900). Cause: light things (sticks, fibre, small stones, most crops) no longer hit a cap of 10, so the bot makes far fewer forced selling trips, and builds that needed more than 10 of a light thing no longer wait for the shed. The parent chose to keep the longer pace of wave 1: if that still holds, the next ticket (`money-market/01`, prices and `meta.flex`) is the place to win it back (or a smaller shelf for light things only: a per-class factor in `needs.storage_cap`). Left as built. Goldens re-recorded: short 185 / 202, full 567 / 540.

**Decision, 11 Nov 2026:** the parent said "Keep it": the faster pace (about 890 steps to chapter 5) stays. Nothing to undo; `money-market/01` does not need to win it back.
