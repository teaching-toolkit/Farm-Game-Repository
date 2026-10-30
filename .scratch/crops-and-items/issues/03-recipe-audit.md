# 03: Audit the recipes: ingredients must make sense (flatbread needs flour, not wheat)

**What to build:** Every recipe is checked so that it uses the right form of its ingredient (baked goods from flour, not raw grain; porridge from grain, and so on). In the data, flatbread already asks for flour (two of anything tagged flour), so ask the parent where they saw wheat: a card, a goal text, or a recipe tile.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** prototype

- [ ] Every recipe's inputs are listed and checked against the processed-form logic
- [ ] Each wrong one is fixed; the list of fixes is in the log
- [ ] The parent is asked where flatbread appeared to need wheat (screenshot), and that place is fixed
- [ ] Data checker and bot pass; goldens re-recorded only if a recipe changed

---

**Feature:** `crops-and-items` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.17]. Filed 23 October 2026.

The parent's words:

> [#23.17] Flatbread would require flour not wheat, check the other recipes for similar errors
