# Art direction

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

## 14. Art direction

- **Style C, bold cartoon:** thick rounded outlines, flat colours, chunky proportions, three-quarter top-down view, soft
  daylight. Pictures stand on a flat base whose footprint is a diamond about twice as wide as deep; shadow falls down-right.
- **Made with OpenArt** (Nano Banana 2, later Nano Banana 2 Lite at 1K) as **sprite sheets on white** (3×3 or 4×4 objects), with
  an earlier sheet as the style reference so everything matches; several versions per sheet, the parent picks the best.
- **Into the game:** `tools/import_art.py` cuts a sheet into transparent sprites by the names in `tools/art_sheets.json`
  (reading order; `-` skips one), makes seamless ground tiles, and turns the generator's grey shadows into see-through dark blue
  so they darken whatever is beneath them.
- **Names follow the data ids** (`assets/map/tent.png`, `assets/items/egg.png`, `assets/animals/animal_cow.png`). A missing picture
  shows the emoji; an upgrade without its own picture keeps the previous one. So pictures can be added one at a time, no code.
- **Icons are small pictures** (interface-feel/04): wherever an item or a tool appears next to an amount (cost rows, recipe tiles and
  what they give, goal cards such as the hand axe, the store, the bag, the square), it shows a small version of its own picture
  (`assets/items/<id>.png`, tools `assets/tools/`), cut to its edges and scaled down once, then kept; the emoji only while it has no picture.
- **Final look first, upgrades as add-ons:** each place gets a picture of its final look without anything that is an upgrade of
  its own; upgrades are separate pictures shown when built.
- **Window pictures** *(planned: listed, not generated yet, `pictures/09`)*: every window (a place's sheet, the store, the bag, the quest book,
  the Time Quiz, Rest, the square …) gets a painted full-bleed scene on top, seen through the farmer's eyes: no farmer, not even a hand, no
  words, one picture per window that fits every upgrade stage. The list with a brief and a prompt for each is `godot-prototype/tools/window_pictures.json`
  (58 windows, most-seen first; its `noPicture` part names the windows that keep their own content picture); `tools/art_list.py` adds them to
  `ART_LIST.csv` as `assets/windows/<id>.webp` after a second, *window* style prompt.
- **The to-do list** is `art-inbox/ART_LIST.csv` (every picture, in the order worth drawing, with a prompt; `tools/art_list.py`
  refreshes it). The folder layout of `assets/` is described in `godot-prototype/README.md`.
