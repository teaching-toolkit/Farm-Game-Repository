# 11: The book cart stands on the village square for good

**What to build:** The book cart is a stall on the village square, always there once it has first come by, and its books are bought there. It no longer comes and goes on the farm.

**Blocked by:** `money-market/10`

**Status:** done

**Milestone:** prototype

- [x] The book cart is a stall on the square (one entry in the square's data and one registration, as the interface README describes)
- [x] It stands there from the first village trip after the book cart's requirements are met; before that the place is empty
- [x] Buying a book works there exactly as it did at the cart on the farm; the old place on the farm is gone and old saves still load
- [x] It uses the book cart's own picture once `pictures/15` has one; until then the current picture
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

## Leftovers (14 Nov 2026)

The empty "bookcart" place in the places data and its slot in the map layout are still there (harmless, nothing is shown); the German of the old "The book cart comes by once you have" line is unused. Remove them with the next change to those files.

---

**Feature:** `money-market` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.6]. Filed 14 November 2026.

The parent's words:

> [#14.6] book cart needs to be permanently in the village square

## Progress

Stall "books" (rules/49-trip.json + `add_stall` in market.gd, shown while `G.done("book_cart")`); `places.json` no longer maps book_cart to the "bookcart" place and placesheet has no bookcart case. Left: the empty "bookcart" place name in places.json and its slot in data/map_layout.json (outside my files; goldens tests/golden/places.json change). Not done: German (no new text; the old "The book cart comes by once you have" string is now unused), `docs/design/`, `check_all.sh`.
