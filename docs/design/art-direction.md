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
- **Final look first, upgrades as add-ons:** each place gets a picture of its final look without anything that is an upgrade of
  its own; upgrades are separate pictures shown when built.
- **The to-do list** is `art-inbox/ART_LIST.csv` (every picture, in the order worth drawing, with a prompt; `tools/art_list.py`
  refreshes it). The folder layout of `assets/` is described in `godot-prototype/README.md`.
