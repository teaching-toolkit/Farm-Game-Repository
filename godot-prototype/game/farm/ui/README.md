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
| `notes` | toasts (the older hint toast is no longer used for bars) |
| `info` | the short note on tap: a bar (energy, water, bag, coins, every `UI.explain` bar), an item (tile or a cost's picture), a greyed-out button (why, from the rule that greyed it); read aloud as the settings say |
| `celebrations` | the big pop-up for something new |
| `timequiz` | the Time Quiz question pop-up, read aloud |
| `playback` | after the Time Quiz: the farm keeps its old look while the quiz is open, then a pause, rain, plants flicking through their stages, bars pulsing, pests, notes; a tap skips (J4) |
| `story` | the story on screen: box with pages, speech bubbles that stay until tapped, the 📜 scroll; which piece is ready is `G.story` (5.2), when it shows is `interrupts` |
| `interrupts` | what takes the screen next: sets up the interruption queue, watches the busy screens, hands it the waiting postcards and the story's next piece; `celebration`, `note`, `request` |
| `frame_scene` | the grandchildren's frame (a story piece of kind `frame`, at the start and after each chapter's last beat): a full-screen black scene, only a picture and words, taps go on page by page, its own music; counts as a pop-up for the queue |
| `figures` | people who are not the farmer, drawn into any scene: `put(id, scene, at, height)`, `stroll`, `walk_to(id, point, secs, leave)` (straight to a point in about that time; with `leave` out of the scene on arrival, as the travelling merchant walks in and off at the farm's gate), `move_all` (a scene laid out again), `take`, `clear`, `ids`, `feet`, signal `tapped`; a tap makes the figure turn to the farmer, wave and say `G.people.line` in a speech bubble. How a figure is drawn is private to `figures.gd` (today the farmer's 3D rig). **A new person = one entry in `rules/58-people.json`**; nothing else changes |
| `square` | the village square as its own screen (money-market/07): while the farmer is in the village, a scene of the square stands where the farm was (stalls to tap: 🪙 selling, 🌱 seeds, 🧺 traders, 📦 orders, 📋 the notice board, 🏠 the walk home); with no window open the scene fills the screen; a tap on a stall (or arriving for the stall one came for) opens its window (`spot:market`, closable, 60 % high), a tap on the bare scene or ✖ closes it. It owns the scene, which stall is open and the window's frame, and does not know what a stall offers: the part that owns a stall's things registers it (`square.add_stall(id, build, shown, wanted)`, listed in `main.gd` `_make_parts`: `market.register_stalls`, `placesheet.register_stalls`). **A new stall = one entry in `rules/49-trip.json` "square" (place, picture, symbol) + one `add_stall` line**; painted pictures need no code |
| `square_ground` | the village square's ground (money-market/12), a static module with no `M` or `G`: `build(box, layout)` returns one control that draws the diamond tiles (`assets/square_tiles/`) of the data's map (`rules/49-trip.json` "square" "ground": rows of letters + kinds) from the scene's top edge to its bottom, no sky and nothing tappable, and `cell(layout, col, row)` says which picture a cell has (a stable hash, so a redraw never changes the look); `square` only calls `build` |
| `rest` | Rest: start page and sums |
| `feedback` | the farmer's acts, animal voices, sounds, coins landing, the spark that flies to the clock when a chore is grey for lack of time (the ring of moments itself lives in the clock widget, `UI.ClockButton`: `set_moments`, `sweep`, `knock`) |
| `cards` | knowledge cards: page, quiz |
| `patches` | patch taps and sheets, planting, harvesting, the whole-field actions |
| `gifts`, `welcome`, `menu` | gift cards and postcards; who is playing, the welcome, naming a pet; settings and the grown-up part |
| `widgets` | building blocks: text helpers, cost lines, tiles, grids, node rows, section headers |
| `placesheet` | a place's sheet: header, goals, which kind of place |
| `stations`, `animalsheet`, `home`, `waterroad`, `pantry`, `market` (in `places/`) | the sheets of kitchen and workshop machines, animals, the house (its pet corner shows each rule of a pet with two groups of buttons: the blessings, and under them "⚡ Helps with", the chores whose place stands), the well and road, the pantry, the market, book cart and library |
| `album`, `questlog` | the album; the quest book and the log |

**What takes the screen next** (`interruption-queue`): things that arrive on their own (a celebration, a postcard, a story box, a bark, the
notes after a pop-up) are interruptions. One queue decides when each shows: `kits/ui/interruptions.gd` (draws nothing, tested by
`tests/interruption_test`), with the order of the kinds and what each waits for in `data/farm/rules/65-feel.json` ("interruptions").
A part that wants the screen hands its interruption to the queue instead of checking whether a pop-up, a sheet or the playback is busy.

**Rules of the house:** a new screen or sheet is a new part (or a function in the part that owns that kind of place), not new lines in
`main.gd`; a part never writes into `G.S` (it calls the systems); the tests reach the screen only through `tests/ui_driver.gd`, the dev
flags (`dev/dev_flags.gd`) only through `main.<part>.<function>`. The generic hosts (`sheets`, `modals`, `notes`) become reusable kits
(`kits/ui/`) when the interface work of phase 3 (J5 notifications, J8 top bar) gives them their final shape.
