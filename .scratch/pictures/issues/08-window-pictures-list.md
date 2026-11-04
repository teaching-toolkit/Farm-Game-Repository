# 08: List every window and write the prompt for its picture

**What to build:** Every window in the game (the road, the market, every station and sheet) gets a generated picture. This ticket makes the list: each window, what the picture should show, and a prompt ready for the picture tool.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] Every window is on the list with a short picture brief
- [x] The list is added to the art list (`ART_LIST.csv` style) next to the other generated pictures
- [x] The picture rules (the farmer never in a painted picture) are applied in the briefs

---

**Feature:** `pictures` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.33]. Filed 23 October 2026.

The parent's words:

> [#23.33] every window needs a generated picture. Like the road, the market, everything. Put that on the list of generated pictures.

## Result (3 Nov 2026)

- **The list:** `godot-prototype/tools/window_pictures.json`, 58 windows, each with where it opens, a chapter, a priority (1 = seen most: store, road to the
  village, square, Time Quiz, Rest, forest edge, fields, patch, kitchen, workshop, well, road, library, bed, quest book, bag; 6 = grown-up windows), a short
  brief and a prompt. Its `noPicture` part names the seven kinds of window that keep their own content picture (cutaway interiors, a store item,
  celebrations, postcards, story boxes, the forest's find and pick, the mystery sign) and why.
- **In the art list:** `tools/art_list.py` reads the file and adds the rows to `ART_LIST.csv` in the same columns (`assets/windows/<id>.webp`,
  `768x512 full-bleed (window style)`), with a second style line, the *window* style, because these are painted full-bleed scenes like the story
  pictures, not sprites on white. Tried: the tool writes 555 rows, 58 of them windows (the test output was moved out of the project).
- **Picture rules applied:** no farmer at all, not even a hand (the window is seen through the farmer's eyes); no words, numbers or letters (signs
  and books blank or with wavy lines); no particular pet, friend or upgrade stage, so one picture fits every stage; a named person only in Wren's check
  (look from `canon-for-pictures.md`); the forest pictures show none of the plants a task asks for.
- **Agent's choices (easy to undo):** one picture per window rather than one per upgrade stage; the square row is the same picture as `pictures/04`
  (M9); the Time Quiz's walks get "where you are" backgrounds (farm, road to the village, forest path) from the `time-question` spec; file names
  `assets/windows/<id>.webp` (like the story pictures; the import is `pictures/09`); 3:2 landscape at 768×512.
- **For the parent:** read the briefs and prompts (above all the people in Wren's check and the square), then `pictures/09` generates them in 2×2
  sheets with an earlier picture as the style reference. The game does not show window pictures yet: that is `pictures/09`.
