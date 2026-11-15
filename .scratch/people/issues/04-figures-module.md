# 04: The figures module: people who stand, walk about, can be tapped and say a line

**What to build:** One deep module for every person who is not the farmer. A scene (the square, the farm) asks it for a figure by the person's id; the figure appears, strolls between a few points of that scene, stops, turns to the farmer when tapped and says one short line in a speech bubble. Who the people are, how they look, where they stroll and what they say is data. How a figure is drawn (the 3D rig or a 2D puppet) is hidden behind the module, so the look can change later without touching the scenes.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The parent has said yes to the shared understanding below (14 Nov 2026)
- [x] The interface is small: put a person into a scene, take them out, and a signal that they were tapped. A scene never asks how a figure is drawn
- [x] People are data: id, name, look, a few lines (English and German), the scenes they belong to and when (a condition in the condition language)
- [x] What a tapped person says comes from one function that takes the person and the game's state, so story lines and moods can be added later without touching a scene
- [x] A line is short, is shown in a bubble over the head, and a small sound and a wave back it up (the child need not read it)
- [x] A test puts a figure into an empty scene, steps time, taps it and checks the line and that it stays inside its strolling points
- [x] The glossary has the word (figure, person) and the design file `friends-and-story.md` describes it

## 💡 Shared understanding to confirm (14 Nov 2026)

- **Start with the farmer's own rig.** The farmer is a small 3D figure built from simple shapes and rendered into a flat picture (`kits/avatar`); its look is already data (head, hair, shirt, trousers, shoes, hat). A person is the same rig with another look, plus two or three new parts (apron, beard, long skirt, cap). That gives walking, turning and waving for every person with **no pictures at all**, and everybody matches the farmer by construction.
- **Why not 2D pictures per person now:** a walking 2D person needs at least front and back views with a walk cycle, each generated and kept consistent per person; picture tools are poor at that. The one 2D way that avoids it is a **cut-out puppet** (one painted sheet of body parts per person, moved by code). That is the alternative `people/05` tries.
- **The generic look is a separate problem** and is solved for the farmer and the people at once: `people/05` shows three looks side by side on the same scene and the parent picks from screenshots.
- **The module hides the drawing**, so the choice of `people/05` changes one file, not the scenes.
- **Lines are shallow for now:** three generic lines per person that fit their trade and character; the function that picks a line is the place where depth goes later.

## ✅ Parent's answer (14 Nov 2026)

**Yes.** Start with the farmer's rig behind the figures module; the look is picked from `people/05`'s screenshots.

---

**Feature:** `people` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.2]. Filed 14 November 2026.

The parent's words:

> [#14.2] I want to rethink npc characters. how can we make them appear (especially in the village square) and walk around. And sometimes visit the farm. [...] I wonder if they need to be 3d, since their clothes don't need to change and they don't need so many poses.
