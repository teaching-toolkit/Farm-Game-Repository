# 01: D1: Bring the design document up to date for the systems that are built

**What to build:** The design document describes the game as it now is. Every system built in phases 4–12 has its chapter, and no *(planned)* mark is left on anything that is built. Today eight *(planned)* marks remain; several in the §13.2b table are stale (wellbeing, happy boost, sustainability, merchant trust, the Lord's share, the forest screen are all built).

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Each of the *(planned)* marks in `docs/design/README.md` is checked against the game and the data: removed where built, kept only where truly unbuilt (for example "at least Proper" deliveries, "make your farmer")
- [x] A chapter exists for each system listed in the notes below (energy model and wellbeing, trips, packing and the store, quality and skills, seeds, money, prices and the Lord's share, sustainability and seasons, what is shown when) and describes the game as it is, not the change
- [x] The rule changes decided in R1–R4 (log §2.8) are in
- [x] `PROJECT-LOG.md` has a row (written by the helper to its log file for the parent to merge; helpers do not edit the log)

---

**Id:** D1 · **Feature:** `design-paper` · **Moved from** `archive/todo-2026-10.md` §3 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **D1. The design document's *(planned)* chapters**, one per new system, describing the game as it will be (not the change):
  the energy model and wellbeing (L), trips, packing and the store (M), quality and skills (Y), seeds (U), money, prices and the
  Lord's share (M), sustainability and seasons (N), what is shown when (O). Including the rule changes decided in R1–R4 (§2.8 of the
  log): the Time Quiz can give and drain energy; natural consequences instead of "nothing punishes"; quality stars are back; deliveries
  ride in the bag; a right *first* try moves time.

## Result (3 Nov 2026)

Checked against the code and the data of 3 Nov 2026 (the data won wherever a file disagreed). Not available to this pass: `archive/log-2026-10.md`
§2.8 (the R1–R4 wording); the rule changes were taken from the ticket's notes, ADR-0003, -0004, -0005, -0009 and the code. Systems that other
helpers were changing at the same time (season look, HUD, Rest walk, clay at the pond, story boxes, the Lumpy baseline, weeds taking a share of the
harvest, the grown-up Rest share) are described as they were before those changes.

- ***(planned)* marks:** removed where built: the six stale rows of the §13.2b table (wellbeing, happy boost, sustainability, merchant trust, the Lord's
  share, the forest screen), the skill bonus on grades (§8.5), "healing when medicine exists" and "with the new prices" (§8.6), the bag in the first
  screen. Kept, because nothing in the code or data does it: deliveries that ask for at least Proper (§8.5), "make your farmer" (§13.5), the Lord's
  share eased in chapter 6 (`easedFraction` exists, no story piece sets `lord.eased`) and Quill counting (§5.3c), construction jobs training woodwork
  (§8.6), the painted square (`pictures/04`), the forest's planned items (badger's check, painted forest, arnica look-alikes, water pool and herbs,
  the Helper's pause), the season-look items (§12).
- **Chapters:** energy and wellbeing (`energy-and-wellbeing.md`: hats, the dashboard as built, the R1 rule), trips, packing and the store
  (`money-and-market.md` §5.3b: the hand cart; `store-and-materials.md` §5.5: the store window, filters, tiles, item window), quality and skills
  (`making-things.md` §8.5–8.6), seeds (`store-and-materials.md` §5.4 rewritten: grain is its own seed, one wheat grain at the start, seed prices,
  the merchant's ladder, heirlooms), money, prices and the Lord's share (`money-and-market.md`: first coin, season prices from the data), sustainability
  and seasons (`seasons.md`: a new §12.2, the table filled in from `rules/10-farming.json`), what is shown when (`map-and-interface.md` §13.2b rewritten
  from `rules/60-reveal.json` and the systems' own gates; the top bar in §13.3).
- **R1–R4:** the Time Quiz may give or drain energy (`vision.md` §1.5, `time-quiz.md`, §5.1), natural consequences instead of "nothing is ever lost"
  (`vision.md` §1.5), quality stars (§8.5, already in), deliveries in the bag (§5.3b, already in), a right *first* try moves time (`vision.md` §3,
  §4.1); the index (`README.md`) lists them with their ADRs.
- **Facts corrected on the way:** six pets, not five (`vision.md`, `progression.md`); 43 stations, 131 recipes, 182 items (§8.1–8.4, the still-room's
  five stations in the table, the chapter-6 stations moved to their chapter); dig clay is at the forest edge with the wooden shovel (§5.5); spring
  prices are not the list price for crafts and cloth (§5.3b); forest-edge pools work from the start (not frozen as ADR-0009 says: the data wins).
  The key numbers' data counts are updated; the explorer playthrough was not re-run.
- **Found, not fixed (code, not this ticket):** the store's filter row shows the *Herbs* filter as the untranslated id "herbs" (`pantry.gd`
  `_filter_name` lacks it); the bag window shows decimals ("12.5 of 20 room used", `pantry.gd` `part_bag`), against the whole-numbers rule.
