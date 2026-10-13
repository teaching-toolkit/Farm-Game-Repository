# The farm's interface (`game/farm/ui/`)

`game/farm/main.gd` (class `FarmMain`, the scene root) is the composition root: it builds the screen (top bar, map, bottom bar, the sheet
and the pop-up), refreshes it when the farm changes (`refresh`, queued by `queue_refresh`), and creates the parts below. It holds the
widgets everyone needs (`M.map`, `M.sheet`, `M.content`, `M.modal`, `M.modal_box` …). Every part is a script
`class_name FarmUi<Name>` with two handles: `M` (this screen) and `G` (the rules, `G.<system>.<function>`; see `game/farm/systems/README.md`).
Parts call each other as `M.<part>.<function>`. Functions with a leading `_` are private to their part.

| Part (`M.…`) | Does |
|---|---|
| `mapview` | per place: picture, name, badge, open or mystery; animals and pets walking; things flying to the store; scrolling the map |
| `goalbar` | the bottom bar's next goal |
| `sheets` | the sheet that slides up: open, close, fit, rebuild; `open_spot` (a tap on a place) |
| `interiors` | the inside of the house, barn and workshop |
| `modals` | the centred pop-up: open, size, close |
| `notes` | toasts and the explanations of bars and buttons |
| `celebrations` | the big pop-up for something new |
| `timequiz` | the Time Quiz question pop-up, read aloud |
| `playback` | after the Time Quiz: the farm keeps its old look while the quiz is open, then a pause, rain, plants flicking through their stages, bars pulsing, pests, notes; a tap skips (J4) |
| `rest` | Rest: start page and sums |
| `feedback` | the farmer's acts, animal voices, sounds, coins landing |
| `cards` | knowledge cards: page, quiz |
| `patches` | patch taps and sheets, planting, harvesting, the whole-field actions |
| `gifts`, `welcome`, `menu` | gift cards and postcards; who is playing, the welcome, naming a pet; settings and the grown-up part |
| `widgets` | building blocks: text helpers, cost lines, tiles, grids, node rows, section headers |
| `placesheet` | a place's sheet: header, goals, which kind of place |
| `stations`, `animalsheet`, `home`, `waterroad`, `pantry`, `market` (in `places/`) | the sheets of kitchen and workshop machines, animals, the house, the well and road, the pantry, the market, book cart and library |
| `album`, `questlog` | the album; the quest book and the log |

**Rules of the house:** a new screen or sheet is a new part (or a function in the part that owns that kind of place), not new lines in
`main.gd`; a part never writes into `G.S` (it calls the systems); the tests reach the screen only through `tests/ui_driver.gd`, the dev
flags (`dev/dev_flags.gd`) only through `main.<part>.<function>`. The generic hosts (`sheets`, `modals`, `notes`) become reusable kits
(`kits/ui/`) when the interface work of phase 3 (J5 notifications, J8 top bar) gives them their final shape.
