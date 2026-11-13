# 02: Tapping a greyed-out button says why it is grey and what it needs

**What to build:** A greyed-out button answers a tap with a short note: why it cannot be used now and what it will need (energy, an item, a card, a season).

**Blocked by:** the whole `farm-actions` feature: its "what would this cost, and can I do it?" answer carries the child-friendly reason (the parent can lift this block if they want it sooner)

**Status:** done

**Milestone:** prototype

- [x] Every greyed-out action button gives a reason on tap, never a silent grey
- [x] The reason comes from the same rule that greys the button, so button and rule cannot disagree
- [x] German through `tools/i18n.py`; a test covers at least one reason per kind (energy, item, season, unlock)

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.31]. Filed 23 October 2026.

The parent's words:

> [#23.31] tapping an item or a bar should give additional info. tapping a grayed out button should give some info as why it is grayed out and what it will need.

## What was built (9 Nov 2026)

- **The catch:** a disabled Godot `Button` does not emit `pressed`, but it still gets `gui_input`. Every button made by the helper (`UI.button`, `soft_button`, `action_button` in `kits/ui/ui.gd`) listens to it
  (`UI.grey`); a press and release on a disabled button calls `UI.grey_hook`, which `info.gd` answers with the note. No overlay, no per-call-site code. `UI.grey(button, why)` does the same for a Button made by hand
  (the overgrown patch in `field_view.gd`).
- **One rule, one answer:** the helper's `enabled` argument may be the rule's own answer (a Dictionary with `ok`): then the button is grey exactly when the rule says no and the note reads that answer's
  `unmet` list (`{"key", "text"}`, the shape `G.actions.check` always had) and shows the `cost` with its cubes when something is short. A button greyed by a plain condition gets one sentence (`why`, last argument).
  `G.progression.can_unlock` now also returns `unmet`, `cost` and `base` (its old `why` is unchanged for the log and the bot); `G.pace.cost_check(price)` is `missing_cost` in the same shape.
- **Call sites** (39 of 139 button calls had a computed `enabled`, all now give a reason; found with a scan of every `UI.button/soft_button/action_button` call): goals (`widgets.node_row`, the quest book and every place), snow, cutting a tree,
  the forest tasks, party and visit, the village trip, polish, recipes (the check without "keeps", as the button always used it), stoking, buying an animal, the water trip, the gate's barter and sales, orders, book cart, reading, packing in the
  store pop-up, harvest all / weeds / stones, planting, pet jobs, the settings' steppers.
- **No silent grey, tested:** the smoke test walks every place's sheet, the quest book and the bag (a new game at home and on the village square, and the chapter 3 fixture, tired and with no coins): 87 greyed-out buttons, none without a reason.
- **Per kind** (real taps on the real buttons): energy (a chore's check, "⚡ Too tired. Rest a little (tap ⚡)." with the energy cubes hollow), season (a real patch sheet: "Winter wheat is sown in autumn / winter."),
  item ("Missing: 🪵 3 more, 🌿 4 more" with the cost cubes, from `can_unlock`), unlock ("Needs first: 🌿 Lay brushwood over the mud"), and the full bag in the store pop-up (the note is above the pop-up).
- **German** through `tools/i18n.py`.

## 💡 Decisions to confirm

- A button that is **not** grey but would fail (Plant, Harvest, a recipe when too tired) still does what it always did: a tap performs the chore, which says "⚡ Too tired" and plays the tired sound. Only buttons that were already grey got the note;
  greying more buttons is a design change (it would also change what the bot sees), so it was left.
- The settings' ➖ ➕ and the pet jobs' ✔ buttons (grey because they are at their end or chosen already) say "That is as low as it goes." and "That is its job already."
