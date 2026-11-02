# 14: Wren stops asking for coins

**What to build:** Content change after the refactor. Wren never asks for coins. She may ask for something that takes energy, time or water, or something the player can craft or cook at any time without coins. The parent decides what she asks for instead; the coin option leaves her check.

**Blocked by:** farm-actions/13

**Status:** done

**Milestone:** refactor

- [x] The parent has said what Wren asks for instead of coins (a 💡 recommendation is written in this ticket first)
- [x] Her favour never asks for coins; no path asks for coins without the Lord's-share rule
- [x] Her story texts (English and German) match
- [x] Full golden runs are re-saved on purpose and the change is explained in the log

## 💡 Recommendation (30 Oct 2026)

Wren takes the cheapest dish or remedy from the store, as now. **If there is none, she asks you to fetch her a bucket of water**
(a chore: energy and water, through the actions module). If you can't do that either, she checks the basket for free today. She
never asks for coins, and the child is never stuck.

Other options: (b) only a chore, never an item: simpler, but it loses the nice "she takes a dish" moment; (c) she always checks for
free: simplest, but the plant check stops costing anything, and the poisoning (ADR-0004) loses its point.

## ✅ Parent's answer (30 Oct 2026)

Yes, with one change: **what she asks for is worth about 30 coins** (it need not be exact). So she takes the dish or remedy whose
value is closest to about 30 coins (several cheap ones together are fine), not simply the cheapest. If there is none, she asks for a
chore of about that worth (fetching her water); if that can't be done either, she checks for free. Never coins.

## Done (30 Oct 2026)

- **What she takes:** the dish or remedy whose value comes closest to her worth (`forest.wren.worth`, 30 bronze); then more units only
  while the sum comes closer. Every dish and remedy is worth at least 60 bronze, so today she always takes one, the cheapest, as
  before; the "several together" rule only shows if her worth is raised.
- **Else a chore:** `wren_water`, fetch her a bucket of water: 2 energy (the gathering energy, so skills make it cheaper) and 5 water,
  written in `forest.wren.chore` (by the price rule, ½ old coin per energy and 0.2 per water: about 30 bronze). Shown beside the
  button as energy and water cubes. Not enough water or energy: she checks for free. The coin path is gone.
- **Story:** Wren's rule now says "A biscuit will do, or a bucket of water." (German: "Ein Keks genügt, oder ein Eimer Wasser.")
- **Checks:** forest test 30 checks (new: the closest dish, two porridges for a raised worth, the bucket never takes coins, free
  without water); chores price-match test covers `wren_water` (28,243 checks); `check_all.sh --short` green, short golden identical.
  Full golden runs re-recorded on purpose: seed 1 differs from step 851 (chapter 5), seed 2 from step 976; at that step the farm
  keeps its 30 bronze and spends 5 water and some energy instead. The story ends at 906 and 1015 answers (were 893 and 1017).

Independent review (30 Oct 2026): the bucket is now paid after the basket is checked, so the forest sheet no longer redraws with
a half-done check; if the chore can't be done at that moment she checks for free. Golden runs unchanged by this. The reviewer's
other point (she may take a dish worth far more than 30) is `farm-actions/17`.

---

**Feature:** `farm-actions` · **Source:** `.scratch/farm-actions/spec.md` in this folder and the decisions in `.scratch/farm-actions/issues/01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
