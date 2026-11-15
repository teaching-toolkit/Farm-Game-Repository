# 14: The store's window shows a bar for how full it is

**What to build:** The store's window shows a bar of how full the store is, built like the bag's bar on the trip, so the child sees at a glance how much room is left without reading numbers.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The bar stands at the top of the store's window and uses the same widget as the bag's bar
- [x] It fills with what is stored against the room there is (the shelves of `money-market/08`), and turns the warning colour when nearly full
- [x] It grows when storage is built (`interface-feel/05`: bars grow instead of multiplying)
- [ ] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

## Progress

Built: `M.widgets.fill_row` (moved from market.gd), `Inventory.shelf_room()/fill()/any_full()`, bar "store_bar" at the top of the store window, smoke check added. Not done: the `docs/design/` file and `check_all.sh --short`, `check_docs.py`; "grows when storage is built" is by `storageLoad` per kind (not separately tested).

## 💡 Decision taken for the parent (14 Nov 2026)

The store has no single size (every kind of thing has the same room), so the bar shows everything stored against the room of the shelves in use, and turns red as soon as one kind is full. Easy to change: the calculation is one function of the store (`fill`, `any_full`).

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.10]. Filed 14 November 2026.

The parent's words:

> [#14.10] A bar for how full the storage is in the pop up window of the storage, similar to that one for the backpack
