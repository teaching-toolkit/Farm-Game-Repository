# 03: Audit the recipes: ingredients must make sense (flatbread needs flour, not wheat)

**What to build:** Every recipe is checked so that it uses the right form of its ingredient (baked goods from flour, not raw grain; porridge from grain, and so on). In the data, flatbread already asks for flour (two of anything tagged flour), so ask the parent where they saw wheat: a card, a goal text, or a recipe tile.

**Blocked by:** None (can start immediately)

**Status:** needs-parent

**Milestone:** prototype

**Size:** quick

- [x] Every recipe's inputs are listed and checked against the processed-form logic
- [x] Each wrong one is fixed; the list of fixes is in the log (none was wrong, see below)
- [ ] The parent is asked where flatbread appeared to need wheat (screenshot), and that place is fixed
- [ ] Data checker and bot pass; goldens re-recorded only if a recipe changed

---

**Feature:** `crops-and-items` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.17]. Filed 23 October 2026.

The parent's words:

> [#23.17] Flatbread would require flour not wheat, check the other recipes for similar errors

## Audit (3 Nov 2026, agent)

All 131 recipes were listed with their inputs (tags resolved to their items) and checked. **None uses the wrong form:** every baked
or pan thing that needs flour asks for flour (flatbread, bread, pancakes, cakes, pies, pasta, pizza dough, sourdough starter); porridge
takes any grain (wheat, oats, winter wheat), honey porridge takes wheat; flour comes from wheat at the quern or mill; oils come from the
press, sugar from beet juice, vinegar from cider, dried herbs from the drying rack. No data was changed.

**Most likely cause of what the parent saw:** flour has the same emoji as wheat (🌾, also straw, oats and yarrow). Wherever an item
is shown by its emoji, "flatbread: 🌾 × 2" reads as two wheat. `interface-feel/04` (item pictures in cost rows, built 3 Nov 2026)
shows flour's own picture there, which should end the mix-up. Other recipe pairs that share an emoji and have no picture yet (so they
still look alike after `interface-feel/04`): the herbal chain (plantain → plantain paste, yarrow → yarrow paste, every herb → its dried
form on the drying rack, dried lavender → lavender water, honey → thyme syrup). Their pictures belong in the pictures list.

## 💡 Questions for the parent

1. **Where did flatbread seem to need wheat?** 💡 It was the 🌾 emoji of flour; play-test the flatbread recipe tile once
   `interface-feel/04` is in, and if it still looks wrong, send a screenshot.
2. **Winter wheat is tagged "millable" but no recipe mills it** (the quern and the mill take only wheat). 💡 Let both flour recipes
   take any millable grain (wheat or winter wheat): it makes sense and is a small data change; the golden runs would be re-recorded
   if the bot starts milling winter wheat. Size: quick.
