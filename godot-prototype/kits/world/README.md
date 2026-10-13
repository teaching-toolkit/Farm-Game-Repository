# kits/world — a one-screen map

Farm-free parts of the map (phase 2, slice R6, 12 Oct 2026). Each file explains itself at the top.

| File | Does |
|---|---|
| `shapes.gd` | polygon helpers: points from data, the rectangle round a polygon, a band along a line, shapes continued off the map's edge |
| `walk_grid.gd` | where figures can walk: a grid with blocked cells and a path-finder that straightens the way |
| `flight.gd` | things flying in an arc to a target, bouncing off when it is full |

Still in the farm (`game/farm/map/`) because only the farm has them so far: the layout of places (`farm_map.gd`, `slot.gd`),
the road, forest, grass and fences, the fields at an angle with pests and the scarecrow (`iso_field.gd`), the cat. They move
here when a second game needs them (decision §11 of the architecture plan). Rules: no `class_name`, no autoloads, nothing
about farming.
