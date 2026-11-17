# 01: Ideas: more work that shows on the farm

**What to build:** A list of places where the farmer's work could change what the child sees, sorted by how cheap they are, so the easy ones can be built first. The parent strikes out what they do not want.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

**Size:** quick

- [x] The parent has struck out or starred ideas (or said "take your order"): parent away: took order, ★ kept (16 Nov 2026)
- [x] Each kept idea is a ticket in this folder: 1 → `02`, 2 → `03`, 7 → `04`, 8 → `05`, 12 → `06`, 14 → `07`, 17 → `08`

## 💡 The ideas (14 Nov 2026), cheapest first within each group

An agent checks first which of these the game already does. ★ = recommended for the prototype.

**Piles and stores (what you own is seen)**
1. ★ **Piles beside the basket, later beside the store:** sticks, small stones, big rocks, each pile in four sizes; when the store is full the top tumbles off and the thing bounces back (`visible-work/02`).
2. ★ **Sticks and small stones lie about on the farm:** many at the start, fewer later, a few new ones after wind or a storm; a tap picks one up and it flies to its pile (`visible-work/03`).
3. **The woodpile by the fire shrinks as it burns**, and the fire is big, small or embers.
4. **The compost heap grows, steams, and shrinks when it is spread**; a manured patch is darker.
5. **Jars and sacks on the shelves** inside the house and barn match what is stored (three fill levels per shelf).
6. **A coin jar at home** that fills (bronze, then gold on top).

**Fields and plants**
7. ★ **Watered soil is dark and dries pale over the next steps** (shows when to water again without a symbol).
8. ★ **Stubble stays after the harvest** until the patch is dug or sown; sheaves stand on the patch until they are carried in.
9. **Hay lies drying and turns from green to gold.**
10. **A stump stays where a tree was cut; a sapling grows there.** Fruit hangs on the trees and is gone after picking.
11. **Cleared snow leaves a trodden path; rain leaves puddles** that dry.

**Animals**
12. ★ **Sheep are woolly, then shorn; a clean pen against a mucky one; a full trough against an empty one; eggs lie in the nest.**
13. **Pen fences mend rail by rail** (`upgrades/02`).

**Stations and buildings**
14. ★ **A station shows what it is doing:** the thing lies on the workbench, the herbs hang on the drying rack, the oven glows, smoke rises from the chimney while something cooks. (The workbench starts empty: `pictures/15`.)
15. **Tools you own hang on the workshop wall**, and a polished tool shines.
16. **Buildings go up in stages** (`pictures/05`); each road piece is laid one by one.

**Out of the box**
17. ★ **Paths wear in where the farmer walks most:** grass turns to a trodden track, so the farm slowly shows how this child plays. No pictures needed (a darker ground tile under the most-walked lines).
18. **The farmer carries what was just picked up** to its pile (the avatar's hand props already exist).
19. **Life comes back as the farm heals:** butterflies and bees over flowering crops, birds on mended fences, more of them as the nature numbers rise (a picture of the invisible nature score).
20. **Flowers come up around the house while wellbeing is high**; weeds creep back at the foot of a building that is not looked after.
21. **Light in the windows and a lantern** in the evening steps once the house is rebuilt.
22. **The notice board's notes come off** as orders are done.

**Recommended order:** 1, 2 (the parent's own examples), then 7, 8, 12, 14, 17. Each is one small ticket; 1, 2, 12 and 14 need a few pictures (they join `pictures/15`), 7, 8 and 17 can be drawn from what exists.

## Progress (16 Nov 2026)

The parent was away and said "take your order": every ★ idea is kept. An agent checked the code for each before filing:

| Idea | Does the game do it already? | Ticket |
|---|---|---|
| 1 piles, 2 loose sticks and stones | no, built before this check | `02`, `03` (done) |
| 7 watered soil dark, dries pale | **no**: a patch has no wetness, the water is spent at planting; the soil picture was the same for every worked patch. Derived from the growth the patch already counts and from the rain flag, so no new save key. **Built.** | `04` (done) |
| 8 stubble after the harvest | no (nothing says stubble or sheaf; a harvested patch is plain soil). Drawn in code, no pictures | `05` ready-for-agent |
| 12 sheep woolly or shorn, clean or mucky pen, trough, eggs | no (one picture per animal, always the same). All state is saved already (`ready`, `muck`); needs one new picture, the shorn sheep | `06` needs-parent (picture via `pictures/15`; "stand-in is fine" makes it ready) |
| 14 a station shows what it is doing | half: the ⏳ badge, and the tools made lie on the workbench. No smoke or glow. Smoke and glow drawn in code; the thing on the bench and herbs on the rack need pictures and are left out | `07` ready-for-agent |
| 17 paths wear in | no; needs its own small save key (a count per grid cell) | `08` ready-for-agent |

Idea 17 is a ★ of the recommended order too, so it got its ticket as well, though the order given to the agent named only 7, 8, 12 and 14. Only `04` was built; the others stay for the parent to order.

---

**Feature:** `visible-work` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.7]. Filed 14 November 2026.

The parent's words:

> [#14.7] I have noticed that stuff that changes visually when the player performs work like clearing the field from weeds, and of course, crops is inherently satisfying. Please check the game for easy wins on adding more things that could be made visually visible. [...] Please think of a bunch of other things that may be completely out of the box for me.
