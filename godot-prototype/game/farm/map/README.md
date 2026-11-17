# The farm map (`game/farm/map/`)

The farm on one screen, seen at an angle: grass, the forest and the road, three diamond fields, pens and gardens lying flat, buildings
standing on their footprints. Where things stand is data (`data/map_layout.json`, edited with `tools/layout-editor.html`); which place
is which comes from `data/farm/places.json`.

| Script | Does |
|---|---|
| `farm_map.gd` (`FarmMap`, a Control) | builds the layers from the layout, fits the board to the screen, fields and add-ons, things flying to the store, perk effects (`fx.gd`); `find_path` and `sort_in` are what the avatar kit asks of its map |
| `ground.gd` (`map.ground`) | the ground: grass, earth, the road (mud to paved), the forest edge, the season's colours, and the worn paths (`_draw_trodden`: its own layer below the road, the earth tile laid on the cells `G.trodden.worn()` lists; visible-work/08) |
| `critters.gd` (`map.critters`) | animals and pets walking about their pens, sorted among the standing things by their feet |
| `piles.gd` (`map.piles`) | the piles of sticks, small stones and rocks beside the store: four sizes by the stored amount (`size_for`), where things fly to, the tumble when the store is full (`rules/67-piles.json`) |
| `loose_things.gd` (`map.loose`) | the sticks and stones lying about: each at the free spot nearest to its share of the farm's area, a tap tells its id |
| `cat.gd` (`map.farmcat`) | the farm cat |
| `merchant.gd` (`map.merchant`) | the travelling merchant at the gate: `sync(here, fill)` is all the game says; his cart (three pictures `merchant_cart_1..3` by thirds of its fill) and he himself as a figure (`ui/figures.gd`, person `merchant`) who walks in from the left edge, stands beside the cart, says a line when tapped and walks off to the left |
| `visitor.gd` (`map.visitor`) | a story visitor at the farmhouse door: `sync(id)` is all the game says (who visits now, or ""); the figure (`ui/figures.gd`, one of the seven persons with a `door` scene in `rules/58-people.json`) walks in from the left edge to the door in about two seconds, stands, walks off to the left when the visit is over (`G.people.visitor()`) and a tap makes them say a line; nothing is saved |
| `walker.gd` (`map.walker`) | the farmer's walking: a grid, path-finding around what stands there (every path it finds is told to `G.trodden.wear`, once per cell), taps on the ground |
| `slot.gd` | one place: its footprint, picture, ruins, pen, inside view; `working` sets its smoke and glow |
| `work_fx.gd` (`FarmWorkFx`) | the smoke and glow of a working place, a child of its slot: puffs rise from the chimney, a warm glow breathes at the fire; where they stand on each picture is `places.json` `fires`; "is it working" is `G.crafting.place_state(sid)`; clock-driven, nothing reads it |
| `iso_field.gd` | one field: diamond patches, borders, fence, **pests and the scarecrow's looks (drawn here only)**, rain |
| `../ui/field_view.gd` | the orchard and greenhouse sheets' patches in diamond rows, laid out by `IsoField.cell_center` and drawn by `IsoField.IsoPatch` like the fields (no pests: they only bother the fields) |

Not made into a reusable kit (`kits/world`): that waits for a second game that needs it (architecture plan §4.2, decision d).


## The season on the pictures (`season.gd`, N7)

`FarmSeasonLook` puts one shader (`kits/ui/season.gdshader`) on every picture of the map: snow caps on every top edge and muted colours in winter, golden greens in autumn. `apply_tree` runs once when the map is built (words, panels, buttons and the farmer are left out); a node with the meta `flat` (soil, the layer of plants) gets the muted winter without caps and without the golden shift. `ground.set_season(G.seasons.blend(), …)` sets the season at every question: the look fades from the last season to this one over the first questions of a season (`FarmSeasonLook.share` and `mix` give the weight and the colour of the moment; the grass tint and the road's frost use them too). A picture made later calls `FarmSeasonLook.shade(node)`.
