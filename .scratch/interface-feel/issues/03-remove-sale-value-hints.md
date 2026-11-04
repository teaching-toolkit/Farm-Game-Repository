# 03: Remove the "how much money you get" hints from conversions, chopping and similar buttons

**What to build:** Action buttons and recipe tiles stop showing what the result would sell for. Selling prices stay where selling happens.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] No coin value is shown on crafting, chopping, cooking or conversion buttons
- [x] Prices are still shown in the market square, the store's sell panel and where a goal costs coins
- [x] Smoke test and screenshots checked

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.32]. Filed 23 October 2026.

The parent's words:

> [#23.32] the info about how much money you get out of a given conversion, chopping, etc. can be removed.

## Result (3 Nov 2026)

- **Built:** the recipe tiles of every station (kitchen, workbench, chopping, kiln, forge, loom …: one code path in
  `game/farm/ui/places/stations.gd`) no longer show the green "30 🟤 → 60 🟤" line. That was the only place a making button showed a
  sell value. `G.trade.recipe_worth` stays (the smoke test prints it as a number check).
- **Prices kept:** the square's sell buttons (`market.gd`), the merchant at the gate (`waterroad.gd`), the store's tile panel
  ("Sells for about … — pack it and take it to the village", `pantry.gd`), seed and ware prices, coin costs in cost rows, the Lord's share.
- **Checked:** smoke test without errors; all 21 unit tests OK; screenshots of the kitchen (EN) and the workbench (DE) at 834×1194:
  no coin line on any tile. `docs/design/money-and-market.md` §5.3b updated.
- **Play-test:** nothing to look for except that the child does not miss the hint.
