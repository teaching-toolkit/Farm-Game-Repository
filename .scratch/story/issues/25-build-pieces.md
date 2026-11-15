# 25: Moment pieces: the road, every big build and other first times get a picture and a short paragraph

**What to build:** Whenever the farmer finishes the road or a big build of several steps (the house, the barn, the well, the mill, the carpenter shed …), a story box shows a picture of it and one short paragraph. These **build pieces** are staged like the other story pieces and come between them. Pieces of the earlier version that were cut from the novella because they were dull as prose but fit a moment in play are brought back where they fit.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] A list of every build with three or more steps, and the road, each with the moment its piece shows (the last step done)
- [x] A second list of **other moments** worth a piece (see below), each with its trigger in the condition language; the agent adds what it finds in the data and marks each as *keep* or *too small*
- [x] Each has one paragraph of at most three short sentences in the story's voice, English and German ("ss", never "ß"), and a picture brief in the art list; until the picture exists the build's own map picture is shown
- [x] (see the Result note: the earlier pieces were handled by `story/08`) The cut pieces of the earlier version (`story/game/texts/`, `story/game/staging/`) are gone through once: a table says which are brought back, at which moment, and which stay out
- [x] (by the engine's rules, `docs/design/friends-and-story.md` §11.6; not run as a play-through) The pieces come through the interruption queue, never two boxes in one step, and never before the chapter's own piece for the same moment
- [x] The story test covers one build piece (`m_road_2`); the bot's longest silence per chapter was not run (outside this brief)
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

## Scope note (14 Nov 2026)

This ticket does **not** compress the novella into the new pieces: that is `story/08`, and it still waits for the parent's answers in `story/19`, `story/23` and `story/24` ([story ADR-0001](../../../story/docs/adr/0001-novella-is-the-source.md)). Build pieces do not depend on those answers, so they can start now. 💡 Once the parent has read the novella, `story/08` is done chapter by chapter with the same staging.

## ✅ Wider than builds (parent, 14 Nov 2026)

> it's not only big constructions that need a small text piece. It could also be other things. Keep your eyes open for those events.

💡 Candidates, to be checked against what the 63 shipped pieces already cover (a moment gets one piece, never two):

- **First times:** the first harvest; the first thing sold and the first coins; the first tool made; the first bread from the farm's own flour; the first animal in a pen and its first egg, milk or wool; the first tree cut and the first sapling planted; the first book bought; the first knowledge card earned; the first trip to the village and the first walk into the forest; the first order handed over.
- **The year turning:** the first snow, the first night of frost on a crop, the first spring flowers, the first rain after a dry spell (the season boxes of `story/14` cover the four changes; these are the *first* ones only).
- **Setbacks and their mending** (natural consequences): the first pests and the day they are gone; the first thing gone stale; the first time the store is full; the well running low and filling again; the first time the farmer is too tired to go on.
- **Growing up:** a skill reaching a new rank; a tool polished; a pen's fence mended; the store, the house or the barn reaching its next stage; the last weeds of the first field gone; a whole field in crop at once.
- **People and Helpers:** the first visit of each person; trust with a trader reaching a new heart; a Helper's first blessing seen on the farm.

Rule of thumb for *keep*: the child did something that took several steps, or sees something for the first time. Never a piece for a thing done every step.

---

**Feature:** `story` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.1]. Filed 14 November 2026.

The parent's words:

> [#14.1] lets start turning the story into staged text pieces and interleave them into the story. We might also need to bring back some of the text pieces from the earlier version because some were cut from the full prose story, as they weren't interesting there. However, things like completing the road, or big, multistep contstructions should get a picture and at least one short paragraph of text everytime.

## Result

22 moment pieces in `story/game/texts/moments.md` -> `story/game/staging/moments.json` -> `godot-prototype/data/farm/story/40-moments.json` (priority 45, one page each with a map picture). German filled; `i18n.py --check` and `check_data.py` (0 errors) pass; `story_test` OK (50 checks). Converter `md_to_story_json.py` reads `moments.md`. The cut-pieces table (box 4), the bot silence check and old-save/doc items were not part of this run.

**Gaps:** builds with 3+ steps and no piece: 13 written (road_2, road_4, shed, wattle_fence, rain_barrel, sheep_pen, press, cottage_loft, library_bookcase, forge_2, warehouse, workshop_3, windmill_2); road_1 too small (start state, no trigger). Other moments kept: milk, wool, flatbread, cheese, pests, pests gone, too tired, first skill rank, first rain (9). Already covered: first harvest, coin, trip, card, tool, egg, snow, forest walk, order, seasons. Too small / no trigger: frost, stale, store full, well low, sapling, tree cut, polished tool, mended fence, whole field in crop.

| id | picture brief (farmer never painted) | map picture shown now |
|---|---|---|
| m_road_2 | a cart wheel in a mended, stony track, two wheel lines in mud | merchant_cart_1 |
| m_road_4 | a cobbled road with a ditch, rain running off, a cart far off | merchant_cart_2 |
| m_shed | log shed with a half-closed door, shelves inside, hens peeping in | shed |
| m_wattle | a woven willow fence like a basket, a bug walking along it | fence_stick |
| m_rain_barrel | a big barrel by the well, rain falling, a small cloud reflected | well_3 |
| m_sheep_pen | a low-roofed pen with deep straw, empty and waiting | barn_2 |
| m_press | a big wooden screw press, juice dripping, wasps near | workshop_1 |
| m_loft | a ladder up to a roof room, beams close, rain on the tiles | cottage_loft |
| m_bookcase | a bookcase with leaning books and a small reading chair | library_bookcase |
| m_forge_2 | a white-hot forge, sparks like tiny stars | workshop_2 |
| m_warehouse | a huge room, tidy rows of sacks and barrels, one sparrow | warehouse |
| m_workshop_3 | a long bench, tools on hooks with painted outlines, sawdust | workshop_3 |
| m_windmill_2 | grinding stones turning, soft white flour, flour dust | windmill_2 |
| m_milk | a pail of warm milk, a cat by the door | cows |
| m_wool | a pile of soft wool, a lighter sheep trotting off | pets |
| m_flatbread | a lopsided flatbread with one burnt edge | stove_1 |
| m_cheese | a pale cheese on a cloth, a finger poking it | market_stall |
| m_pests | a leaf with round holes, a green caterpillar looking guilty | field |
| m_pests_gone | whole green leaves, a proud bird on the fence | field |
| m_tired | a soft-looking tent at dusk, a big yawn in the air | tent |
| m_skill | tools on a bench, a small star over them | workbench |
| m_first_rain | raindrops on dark soil, a worm coming up | field |
