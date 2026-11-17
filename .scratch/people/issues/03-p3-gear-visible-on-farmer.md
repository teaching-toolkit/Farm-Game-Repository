# 03: P3: Gear is visible on the farmer

**What to build:** Tools and gear the farmer owns show on the farmer, fitting the acts' props. It is an idea (upgrade idea 15); the parent decides whether and how much.

**Blocked by:** `people/02` (both work on the farmer's look data, so one after the other)

**Status:** ready-for-agent

**Milestone:** later

**Size:** sitting

- [x] The parent has said yes and which gear (decided for the parent while away, see Decision)
- [ ] Gear shows on the farmer without breaking the acts
- [ ] The look stays data

---

**Id:** P3 · **Feature:** `people` · **Moved from** `archive/todo-2026-10.md` §12 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **P3. Gear visible on the farmer** (fits the acts' props; upgrade idea 15). (Was "Later 2".)

## Decision (17 Nov 2026, parent away, easy to undo)

- [x] Yes, in a small way: four groups of gear show on the farmer, the best one owned in each: **hat** (straw, felt, sunhat), **footwear** (sandals, clogs, boots), **apron** (linen, canvas) and the **pack on the back** (woven bag, basket, rucksacks). Gloves and flasks do not show (too small to read at map size). Why: these four read at a glance and each already exists as a gear item.
- Made from simple shapes like the rest of the farmer, as data in the look: no pictures, so no credits.
- Gear is drawn over the child's chosen look (`people/02`); a gear hat replaces the chosen hat while it is owned.
- The acts' props must keep working (the tool in the hand during an act still shows); check every act pose with the pose sheet.
