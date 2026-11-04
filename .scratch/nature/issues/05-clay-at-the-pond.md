# 05: Digging for clay happens at the pond, not at the forest edge

**What to build:** The clay pit is at the pond. The clay pool and its slow refill live there; the forest edge keeps sticks, stones and trees.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The dig-clay action is offered at the pond, not at the forest edge
- [x] The clay pool shows in the pond's window
- [x] Old saves keep their clay count; pool state moves with the place
- [x] Data checker, `nature_test` and the bot pass

---

**Feature:** `nature` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.35]. Filed 23 October 2026.

The parent's words:

> [#23.35] digging for clay should be at the pond, not the forest edge

## Result (3 Nov 2026)

Built: a new station `clay_pit` (*Clay Pit*, always open, in the start list, slot "special", so it stands at the pond) in
`data/farm/nodes/07-hoes-patches-and-extras.json`; the recipe `dig_clay` now belongs to it (`recipes.json`). The forest edge keeps
sticks, stones and trees. `G.nature.pools_at(root)` says which pools a station shows; the station card shows each place's own
pools (the clay bar in the pond's window, once the card *Take only what grows back* is learned, as before). Texts: item and node
descriptions say "pond" (German in `data-de.json`: Lehmgrube, Teich). The bot (`tests/bot.gd`) treats the clay pit like the forest
edge. Design: `docs/design/forest-and-still-room.md` (5.9).

Old saves: the pool state (`nature.pool.clay`) and the clay in the store are untouched; the clay pit is unlocked on load; a clay
dig still refilling at the forest edge is finished after one question (`nature_test` builds such a save and checks all three).

Agent's choice: the pond window shows the clay pit as its own card under the water card (no clay pool bar at the forest edge).

Checked: `nature_test` 29 checks, 0 failed (new lines for station, place, pools, dig, refill, old save); data checks 0 errors;
the other unit tests pass. This ticket changes a rule on purpose (clay no longer shares the forest edge's three refill spots; one
more unlocked station at the start), so the short golden runs were re-recorded: seed 1 332 -> 308 steps, seed 2 525 -> 449 steps
(the bot is a little faster; chapter 3 reached as before). The long golden runs were NOT re-recorded and are stale until the next
full record. Screenshot `/home/claude/patches/places-shots/clay-pond.png` (pond window: Clay Pit with its bar and *Dig clay*).

Play-test: does the clay pit feel like a place at the pond (the farmer walks there)? Is a separate refill (1 spot) too slow or
fast for clay?
