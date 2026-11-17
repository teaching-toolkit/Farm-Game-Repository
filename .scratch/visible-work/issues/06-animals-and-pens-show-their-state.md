# 06: Sheep are woolly, then shorn; the pen is clean or mucky; eggs lie in the nest

**What to build:** What the animals are doing shows in their pen. A sheep with wool to take is woolly; just after it is shorn it is thin, and it grows woolly again by the time the next shearing is due. A mucky pen shows brown muck on the ground (two levels, as the slow-down has two); a pen that has been mucked out is clean. Hens' eggs lie in the nest when they can be collected, the nest is empty just after. A trough is full just after the animals were fed (at a collection) and empty when the next one is due. The child reads the pen without opening it.

**Blocked by:** None (can start immediately). The painted shorn sheep needs `pictures/15`; until it is there the woolly sheep stands in (the picture lookup falls back, so nothing changes in the code when the new picture is added).

**Status:** needs-parent

**Milestone:** prototype

**Size:** medium (one small module and one new picture)

- [ ] One function in the animals system says the state of a pen: ready or not, mucky level 0 to 2, fed or not; it reads what is saved already (`ready`, `muck`, `muck_factor`), so no new save key and old saves look right at once
- [ ] The animals walking about a pen (`map/critters.gd`) take their picture from that state: `animal_<kind>` when ready, `animal_<kind>_done` when not, falling back to the one picture; which animals have two pictures is found by looking for the file, not by a list
- [ ] Muck, eggs and the trough are drawn on the pen's ground in code (brown blobs, white ovals, the trough from `assets/deco/horse_trough.png` with a blue or empty look); the numbers and positions are data
- [ ] The state changes at once after collecting and mucking out, and when a question moves time on
- [ ] A test sets `ready` and `muck` and checks the state the function gives; a screenshot of the sheep pen in each state; the short golden run is identical (draw only)
- [ ] The `docs/design/animals.md` section for pens says what the pen shows

## Finding (16 Nov 2026): the game does not do it

The pen shows one picture per animal, always the same (`mapview.gd` `critter_spec`: `Art.tex("animals", aid)`), no trough, no eggs, no muck. The state is all there already: `animals.gd` saves `ready` (the step the animals can be collected again: wool, eggs, milk) and `muck` (`muck_factor` has the two slow-down levels), and `mapview.gd` `badge` already shows 🧺 when something can be collected. What is not there is a stock in the trough: the feed is paid at each collection (`feed_cost`), so "full just after, empty when due" is the honest way to show it.

💡 **Pictures needed, through `pictures/15`:** one, the shorn sheep (`assets/animals/animal_sheep_done.png`: the same sheep, thin and pinkish, same size and pose as `animal_sheep.png`). Optional later: painted muck, nest with eggs and trough to replace the code-drawn ones. 💡 If you say "the stand-in is fine", this ticket becomes `ready-for-agent` at once.

---

**Feature:** `visible-work` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.7]. Filed 16 November 2026 from `visible-work/01` idea 12.

The parent's words:

> [#14.7] I have noticed that stuff that changes visually when the player performs work like clearing the field from weeds, and of course, crops is inherently satisfying. Please check the game for easy wins on adding more things that could be made visually visible.
