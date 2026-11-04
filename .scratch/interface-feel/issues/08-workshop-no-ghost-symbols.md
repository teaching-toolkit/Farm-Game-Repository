# 08: The workshop shows no ghost symbols that give away what will come

**What to build:** Nothing in the workshop hints at recipes or stations the player has not reached yet: no faded symbols, no empty slots. It follows the rule "what is shown when" (D4).

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] No ghost or silhouette symbols for locked recipes or stations in any workshop window
- [x] Anything that is hidden is hidden through `G.reveal`, with a row in the D4 table
- [x] Smoke test: a fresh game shows only what is unlocked

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.2]. Filed 23 October 2026.

The parent's words:

> [#23.2] no ghost symbols in the workshop that give away what will come

## Result (3 Nov 2026)

- **The ghost symbols** were the workshop window's corners: every corner was drawn, and a corner with nothing built showed its emoji at half strength (🧶 for the loom in chapter 1, 🛠️, 🔪). Now a corner that is not reached is not drawn at all, and a drawn corner is never faded.
- **Through `G.reveal`:** four new elements in `data/farm/rules/60-reveal.json` (`ws_bench`, `ws_fire`, `ws_loom`, `ws_tools`): a corner comes into view, for good, when something of it is built or can be built now (`done:` / `open:` of its first stations; the fire corner also needs chapter 2, the loom corner chapter 3, so a card learned early cannot bring it in too soon). `ws_build` (the shed itself) has no rule and is always there. Row added to the D4 table (`docs/design/map-and-interface.md` §13.2b). The interior code is generic: any corner with a reveal rule is hidden until shown; the house and barn have no rules, so they are unchanged.
- **Also:** a station's "Choice slot: (… build it below)" line named choices that could not be built yet (possibly of a later chapter); it now names only choices built or buildable now (`ui/places/stations.gd`).
- **Agent's choice:** the "🔒 *recipe* — needs …" lines under a station stay. They list only recipes one step away whose needs are all in this chapter (later ones were already left out), as text, not symbols. If the parent wants those gone too, it is one line in `stations.gd` (`locked`).
- **Agent's choice:** a corner appearing makes no "✨ New: …" note (the reveal note only knows the top-bar elements); the corner simply is there next time the window opens.
- **Checked:** smoke test line "workshop corners (id: faded): now {ws_bench, ws_build, ws_tools, none faded}, before the workbench {ws_build, ws_tools}, with it {ws_bench, ws_build, ws_tools}; only what is reached true, the bench comes true"; save fixtures, save versions (new game unchanged), places, conditions OK; `check_data.py` 0 errors (the new conditions are valid). Screenshots `08-workshop-before.png` (faded 🧶 and others) and `08-workshop-after.png` (only the shed, the bench and the tool corner).
- **Play-test:** in chapter 2, when the Carpenter's Shed stands, the workshop shows only the corners you can use; the kiln corner appears when the kiln can be built.
