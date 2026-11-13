# 01: Tapping an item or a bar tells more about it

**What to build:** Tapping an item tile or a bar (energy, water, bag, coins) opens a short note: what it is, the numbers, and what fills or drains it.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] An item tap shows name, a short description, count, grade and how much room it takes
- [x] A bar tap explains what raises and lowers it, in the child's words
- [x] Works on the iPad (tap, no hover); read-aloud mode is respected
- [x] German through `tools/i18n.py`; smoke test checks one item and one bar

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.31]. Filed 23 October 2026.

The parent's words:

> [#23.31] tapping an item or a bar should give additional info. tapping a grayed out button should give some info as why it is grayed out and what it will need.

## What was built (9 Nov 2026)

- **One mechanism for 01 and 02:** `game/farm/ui/info.gd` (`FarmUiInfo`, `M.info`): a small card with a picture or an emoji and a few words, just below (or
  above) what was tapped, above everything (also above a pop-up), one at a time. It goes by itself after 8 s (`notes.infoSecs`, `rules/65-feel.json`), when it is
  tapped, or when anything else is tapped. The kit only reports taps: `UI.info(control, kind, id)` and `UI.explain` (`kits/ui/ui.gd`); `info.gd` knows what to say.
- **Bars:** tapping energy, water (top bar), the thin bar under the 🎒 (its tap place is a bit taller now) and the purse gives the numbers (cubes and "You have 7 of 20"),
  what fills it and what drains it. The bag says "N of M room is used" and, on the village square, that selling makes room and buying fills it. Energy and water carry a button
  for the old job (😴 Rest, 🪣 Get water). Every older `UI.explain` bar (season, steps, seeds, polish, pests, store …) now shows the same card (icon, read aloud, above pop-ups) instead of the old toast.
- **Items:** a tap on an item's tile (the bag, the travelling merchant's, the village shop's, a recipe's; `widgets.tile(..., item)`) or on an item's little picture in any cost (`UI.cost_row`) gives name, a few words (`desc`), "It needs 3. You have 1.", the grades and, from the first packed thing, the room it
  takes in the bag (½, 1, 2, 4, or "hardly any"). The store's item pop-up (tap a tile) now also has the words and the room. `tag:` kinds ("any flour") list what will do.
- **Read aloud:** "off" says nothing and shows no 🔊; "button" shows a 🔊; "auto" reads the note as it opens. Emojis are not read, a line of stars is skipped.
- **German** through `tools/i18n.py` (44 new texts, "ss"); `--note=…` screenshot flag; docs: `docs/design/map-and-interface.md` ("The short note on tap").
- **Checked** (smoke test block `interface-feel/01+02`, real taps through the viewport's input path): item (name, words, count, grade, room), a cost's picture, the four bars, inside the screen,
  above a pop-up, a tap elsewhere closes, fades by itself, read aloud in the three modes.

## 💡 Decisions to confirm

- **A tap on the energy or water bar now shows the note first**; the old job is the note's button (😴 Rest, 🪣 Get water), one tap more. Undo: in `main.gd` connect `ep.pressed` to `rest.go_rest` and `wp.pressed` to `sheets.open_spot.bind("well")` again.
- **The note stays 8 seconds** (a child may need time, or the voice). One number: `notes.infoSecs`.
- The old toast for `UI.explain` bars is not used any more (`notes.hint` and `notes.hintSecs` stay but nothing calls them). Undo: `UI.explain_hook = notes.hint` in `info.connect_hooks()`.
- The item note shows no sale price (interface-feel/03 removes price hints).
