# 09: A stall on the square shows only its own things

**What to build:** Tapping the raw-material seller (the traders' stall) on the village square shows that trader's things and nothing else. Today the window also shows the seed merchant's seeds. The same holds for every stall: one stall, one seller's things.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Tapping each stall shows only what that stall offers (a test taps every stall and checks the window's sections)
- [x] The cause is named in a `## Progress` note (the stall's window, or the trader's own data listing seeds)
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

---

**Feature:** `money-market` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.4]. Filed 14 November 2026.

The parent's words:

> [#14.4] right now tapping the raw material seller shows the seeds merchants stuff as well

## Progress

Cause: the seed merchant's own node (`seed_1`, which `sells` wheat, winter wheat, hay) was in `traders()`, so the traders' stall listed it. Fix in `ui/places/market.gd`: `traders()` skips `seed_*` merchants; the seeds stall (`_part_seeds`) now shows `seed_sellers()` goods through the shared `_merchant_stock(mid)`. Check: `tests/ui_smoke.gd` ("one stall, one seller's things"). German/`docs/design/` and `check_all.sh --short` not done (left to the parent).
