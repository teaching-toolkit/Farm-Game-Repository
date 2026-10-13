# The farm map (`game/farm/map/`)

The farm on one screen, seen at an angle: grass, the forest and the road, three diamond fields, pens and gardens lying flat, buildings
standing on their footprints. Where things stand is data (`data/map_layout.json`, edited with `tools/layout-editor.html`); which place
is which comes from `data/farm/places.json`.

| Script | Does |
|---|---|
| `farm_map.gd` (`FarmMap`, a Control) | builds the layers from the layout, fits the board to the screen, fields and add-ons, things flying to the store, perk effects (`fx.gd`); `find_path` and `sort_in` are what the avatar kit asks of its map |
| `ground.gd` (`map.ground`) | the ground: grass, earth, the road (mud to paved), the forest edge, the season's colours |
| `critters.gd` (`map.critters`) | animals and pets walking about their pens, sorted among the standing things by their feet |
| `cat.gd` (`map.farmcat`) | the farm cat |
| `walker.gd` (`map.walker`) | the farmer's walking: a grid, path-finding around what stands there, taps on the ground |
| `slot.gd` | one place: its footprint, picture, ruins, pen, inside view |
| `iso_field.gd` | one field: diamond patches, borders, fence, **pests and the scarecrow's looks (drawn here only)**, rain |
| `../ui/field_view.gd` | the square patch grid in the orchard and greenhouse sheets (no pests: they only bother the fields) |

Not made into a reusable kit (`kits/world`): that waits for a second game that needs it (architecture plan §4.2, decision d).
