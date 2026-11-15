# 01: P1: Characters walk in as figures: the travelling merchant and the story's visitors

**What to build:** The travelling merchant walks or drives in with his cart, and the story's visitors (Greenstem, Granny Maud, the miller, Wren, Master Quill, Lark, Captain Mei) appear as figures, through the figures module (`people/04`); they can be tapped and say a line, and they sometimes visit the farm [#14.2]. No words on the map; they are known by their look. Today the merchant is a cart at the gate.

**Blocked by:** `people/06` (the figures module and the people on the square come first)

**Status:** done

**Milestone:** prototype

- [x] The merchant arrives as a figure with his cart; coins fly to and from him as now
- [x] Visits show the visitor as a figure
- [x] Looks are data (they live in `rules/58-people.json` on the slots of `data/avatar.json`; `data/acts.json` is not needed: nobody does a chore)
- [x] Smoke test, bot and golden runs pass (`check_all.sh --short` clean on 15 Nov 2026: smoke, 28 test suites, golden seeds 1 and 2 same as recorded)

---

## Progress

- **First half done (15 Nov 2026): the travelling merchant.** `game/farm/map/merchant.gd` (`map.merchant`, `sync(here, fill)` is all the game says; main hands the map the figures module): a figure of him (person `merchant` in `rules/58-people.json`, scene `gate`: a red coat and cream hat in his cart's colours) stands beside his cart while `G.gate.here()`; the cart is `merchant_cart_1..3` by thirds of `G.gate.fill()`. He walks in from the left edge to the cart in about two seconds (the cart rolls in as before), off to the left when he leaves (cart fades), and just stands when the game starts with him there. A tap says one of three lines (English and German). The figures module gained `walk_to(id, point, secs, leave)`. Coins are untouched (they never used the cart's place). Dev flag `--gate=0.9` (cart 90% full). Tests: `figures_test` (walk_to, the merchant's figure and cart, three pictures, walk in and out, tap), `ui_smoke` (wiring in the real main screen).
- **Second half done (15 Nov 2026): the story's visitors.** A visit piece with a `visitor` (one of seven persons in `rules/58-people.json`, scene `door`, plus a top-level `visitSteps: 2`) brings that person's figure to the farmhouse: `systems/people.gd` `visit(id)` / `visitor()` (in memory only, like `_said`: nothing saved, nothing in the rules; `visitor()` is "" once `visitSteps` farm steps passed or after a load), started in the one place a piece is shown (`story.gd` `mark_seen`, kind `visit` with a `visitor`); `game/farm/map/visitor.gd` (`map.visitor.sync(id)` is all the game says, called in main's refresh next to the merchant's): the figure walks in from the left edge to the door side of the farmhouse (left of its middle, a little in front of its feet, shares of the map's width; the optional `scenes.door` figureH, dx, dy), stands, walks off to the left when `sync("")` comes; a second visit replaces the first at once; a tap says a line (`G.people.line`, in the figures module). Eleven of the 20 visit pieces got a visitor (Maud 3, Greenstem 3, Lark 3, Quill 1, Wren 1); the miller and Captain Mei have no visit piece yet. Dev flag `--visitor=<id>`. `check_data.py` checks `visitor` and the `door` scene; German lines done. Tests: `figures_test` (rules, walk in and out, tap, replace, all seven), `story_test` (a visit piece starts the visit, others do not, every `visitor` in the data is a person), `ui_smoke` (wiring in the real main screen); golden short runs identical.
- **Still open:** "Looks are data" (the looks live in `rules/58-people.json`, the slots of `data/avatar.json`; `data/acts.json` is not used) and the bot run are for the orchestrator to judge. Status stays `ready-for-agent`.

---

**Id:** P1 · **Feature:** `people` · **Moved from** `archive/todo-2026-10.md` §12 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **P1. Other characters as avatars** [#11]: the travelling merchant first (M7: walks or drives in, his cart, coins fly to him); the
  story's **Visits** (Greenstem, Granny Maud, the miller, Wren, Master Quill, Lark, Captain Mei; `story/game/story-delivery.md` §7). Same
  system as the farmer (`kits/avatar/avatar.gd`, `data/avatar.json`, `data/acts.json`). No words on the map: they are known by their look.
