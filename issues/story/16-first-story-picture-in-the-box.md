# 16: One kept story picture shows big in the story box (tracer bullet for the import)

**What to build:** A story box with a reviewed, kept picture shows that picture large and sharp on the iPad, above the text. It works end to end for a handful of pieces: a full-bleed scene goes in through a new import path, small enough for the web build, and the box shows it at a size you can enjoy. A piece without a picture still shows its emoji. The same path later takes every other picture without new code (story/17, and I11 for the regenerated ones).

**Blocked by:** None (can start immediately)

**Status:** done

**Assumptions (💡, taken because they are easy to undo; log §2.6 when built):** the pictures are shrunk to about 768 px and saved as 256-colour PNG, so the picture loader stays as it is. If the measured size is too big for the web build (W2), switch to lossy WebP in a later ticket.

## Plan (written first, per the session skill §3)

- The old import tool's `one` mode cuts an object out of a white background and would damage a full-bleed scene. A separate, re-runnable import step reads a small mapping (piece id → original file), shrinks each picture and saves it under the piece's id; a missing file is skipped (the game falls back to the emoji).
- The story box draws its picture in a thin 140 px strip today; a square scene would be a thumbnail on the 834-wide screen. Make the picture about 480–560 px wide. Coordinate with `story/11` (full-screen frames), which also changes how the box looks.
- Old saves are not touched (no save data changes). The bot does not need to learn anything.

## Checkboxes

- [x] A trial on 3 pictures: the real size per picture and the effect on the web export are written into this ticket (Pillow and numpy must be installed on the Mac; they are not now) (see Progress)
- [x] The import step for full-bleed scenes exists, can be run again, skips missing files and never changes the originals in `art-inbox/`
- [x] The mapping starts with 3–5 KEEP pieces from `art-inbox/Story pictures/picture_review.csv` (4: `c1_stalk` page 2, `c1_bells`, `c1_bunny` page 1, `c1_board`). No `picture` value in the story JSON: the box finds a scene by the piece id
- [x] The story box shows a picture big enough to enjoy on the iPad, and text and the "Got it" button still fit without scrolling (screenshot of one box)
- [x] A piece without a picture still shows its emoji (pages 1 and 3 of `c1_stalk`); the 📜 scroll re-reads through the same box
- [x] Godot import run after the new pictures; smoke test, bot and golden runs unchanged (`farm-game-check`): `check_all.sh --short` all passed, run on a copy of the folder
- [x] One row in `PROJECT-LOG.md` §1 and the assumption in §2.6; `godot-prototype/README.md` ("Pictures") describes the story pictures. `ART_LIST.csv` is written by `tools/art_list.py`, so story rows are not added by hand (moved to `story/17`); the design document does not describe picture files

## Progress (23 Oct 2026)

- **Changed afterwards (23 Oct 2026, the parent chose WebP):** the pictures are lossy WebP, not 256-colour PNG, and the loader takes a `.webp`; see `story/17`. The sizes below are the trial that led to it.

- Built: `tools/import_story_pictures.py`, `tools/story_pictures.json`, `assets/story/` (4 pictures), the story box (`storybox.gd`, scene 520 px high).
- Measured on 3 pictures: the original is about 1.6 MB; at 768 px as 256-colour PNG about 0.31 MB (1024 px: 0.55 MB; 640 px: 0.23 MB); lossy WebP at 768 px about 0.07–0.10 MB. Godot's import keeps the size (the four pictures are 0.22–0.30 MB each in the imported form). 60 pictures ≈ 18 MB on top of the 89 MB pack, which goes over GitHub's 100 MB limit (W2): plan needed before `story/17`, WebP is the 💡 answer.
- Not seen: page 2 of `c1_stalk` and `c1_bunny` page 1 on screen (the same code path as `c1_bells`, whose screenshot is fine); the iPad.
- Parent to try on the iPad: start a new game and clear the thistles: the box with the bell and the sticks should show the picture big, text and button fully visible.

---

**Id:** none · **Feature:** `story` · **Where it came from:** the plan of 23 Oct 2026 for getting `art-inbox/Story pictures/openart outputs` into the game (found: 94 PNGs of 1024×1024, about 155 MB; 59 mapped to a story piece, 50 of them KEEP; 0 of 80 pieces had a `picture` value; the box's picture strip is 140 px high). Part of I11's "import path for full-bleed scenes".
