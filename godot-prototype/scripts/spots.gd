extends RefCounted
## Which place on the farm map every node of the data belongs to.
## Where the places stand comes from data/map_layout.json; the keys here are their ids.
## Some places have an inside (house, barn, workshop): once the building stands, tapping it opens a window with
## its corners (bed, books, kitchen …), and every corner is a place of its own (a "member") with its own sheet.

const SPOTS := {
	"home": ["House", "🏠"], "living": ["Bed & home", "🛏️"], "library": ["Library", "📦"], "kitchen": ["Kitchen", "🔥"],
	"well": ["Well", "🪣"], "storage": ["Storage", "🧺"], "workshop": ["Workshop", "🪚"],
	"field": ["Field", "🪧"], "forest": ["Forest edge", "🌳"], "lumber": ["Woodlot", "🌲"],
	"coop": ["Chickens", "🐔"], "cows": ["Cows", "🐄"], "sheep": ["Sheep", "🐑"], "bees": ["Bees", "🐝"],
	"barn": ["Barn", "🛖"], "windmill": ["Windmill", "🌬️"], "compost": ["Compost", "♻️"],
	"pond": ["Pond", "🦆"], "orchard": ["Orchard", "🍎"], "greenhouse": ["Greenhouse", "🪴"], "pets": ["Pet corner", "🐾"],
	"market": ["Market", "🧑‍🌾"], "bookcart": ["Book cart", "🛒"], "board": ["Notice board", "📋"], "broker": ["Import Broker", "🧳"],
	"road": ["Road", "🛤️"],
	# corners inside the barn and the workshop
	"barn_build": ["Barn", "🛖"], "barn_cellar": ["Cellar", "🧀"], "barn_ferment": ["Crocks", "🫙"],
	"barn_hay": ["Hay & water", "🌾"], "barn_seeds": ["Seed library", "🌱"],
	"ws_build": ["Workshop", "🪚"], "ws_bench": ["Benches", "🪚"], "ws_fire": ["Kiln & forge", "🔥"],
	"ws_loom": ["Spinning & weaving", "🧶"], "ws_tools": ["Tools", "🛠️"],
}

## Buildings with an inside. "built": once this (or an upgrade of it) is done, the map shows the building and a tap opens
## the inside; before that the members stand outside on their own (house) or the place opens one sheet for all (barn, workshop).
const INTERIORS := {
	"home": {"built": "cottage", "art": "house", "members": ["living", "library", "kitchen"]},
	"barn": {"built": "barn_1", "art": "barn", "members": ["barn_build", "barn_cellar", "barn_ferment", "barn_hay", "barn_seeds"]},
	"workshop": {"built": "workshop_1", "art": "workshop", "members": ["ws_build", "ws_bench", "ws_fire", "ws_loom", "ws_tools"]},
}

## Pictures of the corners inside (assets/interior/<id>.png, then assets/map/<id>.png): the newest one built is shown.
const HOTSPOT_ART := {
	"living": ["straw_bed", "wool_mattress", "linen_bedding"],
	"library": ["library_box", "library_shelf", "library_bookcase", "library_room"],
	"kitchen": ["campfire", "stove_1", "stove_2", "stove_3"],
	"barn_cellar": ["cellar", "cellar_2"], "barn_ferment": ["fermenter"], "barn_hay": ["hay_rack", "water_trough"],
	"barn_seeds": ["seed_library"],
	"ws_bench": ["workbench", "carpenter_bench", "sawbench", "press"],
	"ws_fire": ["kiln", "forge", "anvil", "kiln_2", "forge_2", "glass_kiln"],
	"ws_loom": ["hand_loom", "spinning_wheel", "textile_loom", "dye_vat"],
	"ws_tools": ["tool_rack", "master_tool_chest"],
}

## The upgrade chain of a place, first to last: its picture follows the newest one built (tent → cottage → …).
## An upgrade without its own picture keeps the previous one; the place's own name (map/<spot>.png) comes last.
## Pictures are named after the FIRST stage they stand for (the farmhouse picture is cottage.png until the cottage
## gets its own), so a new building shows a picture from the moment it stands.
const ART_CHAINS := {
	"home": ["cottage", "cottage_loft", "farmhouse", "farmhouse_sunroom"],
	"living": ["tent"],
	"library": ["library_box", "library_shelf", "library_bookcase", "library_room"],
	"kitchen": ["campfire", "stove_1", "stove_2", "stove_3"],
	"well": ["well_1", "well_2", "well_3", "well_4", "well_5"],
	"road": ["road_1", "road_2", "road_3", "road_4", "road_5"],
	"storage": ["basket", "shed", "warehouse"],
	"workshop": ["workbench", "workshop_1", "workshop_2", "workshop_3"],
	"barn": ["barn_1", "barn_2", "barn_3"],
	"windmill": ["windmill_1", "windmill_2"],
	"compost": ["compost_bin", "compost_bin_2"],
	"greenhouse": ["greenhouse", "greenhouse_2"],
	"lumber": ["woodlot", "lumbermill", "lumbermill_2"],
	"market": ["market_stall"],
}

## Places that lie flat on the ground (a fenced pen, a garden, the pond): their picture is in assets/plots/<id>.png,
## and what gets built there stands on them as add-ons (see "addons" in map_layout.json).
const PLOT_CHAINS := {
	"coop": ["coop_1", "coop_2"], "cows": ["animal_cow"], "sheep": ["sheep_pen"], "bees": ["cap_bees_1", "animal_bees"],
	"pets": ["pet_bunny", "pet_tortoise", "pet_goat", "pet_pony", "pet_alpaca"], "pond": ["pond"], "orchard": ["orchard"],
}

## Places that are always open, even before anything is built there (the wild pond is where the bucket gets water).
const ALWAYS_OPEN := ["board", "field", "forest", "market", "pond", "road"]

## What is left of a building before it stands again (remnants of walls on its footprint): "stone" or "wood".
const RUINS := {"home": "stone", "well": "stone", "windmill": "stone", "workshop": "stone", "greenhouse": "stone",
	"barn": "wood", "lumber": "wood", "storage": "wood", "market": "wood", "compost": "wood",
	"board": "wood", "kitchen": "stone", "library": "wood", "living": "wood"}

## The workbench shows what has been made: a picture in assets/tools/ appears on the bench once its node is done
## (or, for an item, once there is one in the store). x, y = where on the bench picture (fractions), w = width (fraction).
## Inside the workshop the same tools hang in a row on the wall once the tool rack is built.
const BENCH := [
	{"id": "rope", "item": true, "pic": "rope", "x": 0.30, "y": 0.30, "w": 0.24},
	{"id": "rock", "pic": "stone_hammer", "x": 0.50, "y": 0.22, "w": 0.26},
	{"id": "stone_knife", "pic": "flint_knife", "x": 0.70, "y": 0.30, "w": 0.20},
	{"id": "stone_axe", "pic": "stone_axe", "x": 0.44, "y": 0.38, "w": 0.28},
	{"id": "wooden_shovel", "pic": "wooden_shovel", "x": 0.64, "y": 0.40, "w": 0.34},
	{"id": "stick_hoe", "pic": "wooden_rake", "x": 0.30, "y": 0.42, "w": 0.32},
	{"id": "saw", "pic": "hand_saw", "x": 0.56, "y": 0.30, "w": 0.28},
	{"id": "iron_hammer", "pic": "iron_hammer", "x": 0.78, "y": 0.24, "w": 0.22},
]

## Pens and gardens: no picture of their own — a generic fence round the footprint and a ground, with what is built
## standing inside (add-ons). Before they open only broken posts and bare earth are left.
## fence: a picture in assets/fences/ ("" = no fence), ground: earth | grass | meadow, dirt: how much bare earth shows.
const PENS := {
	"coop": {"fence": "wattle_fence", "ground": "earth", "dirt": 0.75},
	"cows": {"fence": "stick_fence", "ground": "grass", "dirt": 0.3},
	"sheep": {"fence": "wattle_fence", "ground": "grass", "dirt": 0.3},
	"pets": {"fence": "picket_fence", "ground": "grass", "dirt": 0.2},
	"orchard": {"fence": "stick_fence", "ground": "grass", "dirt": 0.15},
	"bees": {"fence": "", "ground": "meadow", "dirt": 0.1},
}

static var _by_spot := {}
static var _of := {}

static func spot_of(G, id: String) -> String:
	if _of.is_empty(): _build(G)
	return _of.get(id, "field")

static func nodes_at(G, spot: String) -> Array:
	if _of.is_empty(): _build(G)
	return _by_spot.get(spot, [])

static func _build(G) -> void:
	_of.clear(); _by_spot.clear()
	for id in G.nodes:
		var s := _rule(G, id, 0)
		_of[id] = s
		if not _by_spot.has(s): _by_spot[s] = []
		_by_spot[s].append(id)
	# a building with an inside holds everything of its corners
	for parent in INTERIORS:
		var all := []
		for m in INTERIORS[parent]["members"]: all.append_array(_by_spot.get(m, []))
		_by_spot[parent] = all

## The building a corner belongs to ("library" → "home"), or "" for a place of its own.
static func parent_of(sid: String) -> String:
	for parent in INTERIORS:
		if sid in INTERIORS[parent]["members"]: return parent
	return ""

## Does node id belong to place sid (directly, or to one of its corners)?
static func in_spot(G, id: String, sid: String) -> bool:
	var s := spot_of(G, id)
	return s == sid or parent_of(s) == sid

static func _rule(G, id: String, depth: int) -> String:
	var n: Dictionary = G.nodes[id]
	if id.begins_with("ruins_"):      # clearing the ruins of a place happens at that place
		var p := id.substr(6)
		return {"workshop": "ws_build", "barn": "barn_build"}.get(p, p)
	if n.has("attach") and depth < 3 and G.nodes.has(n["attach"]): return _rule(G, n["attach"], depth + 1)
	var s := str(n.get("slot", ""))
	if s.begins_with("gear:"): return "living"
	if s.begins_with("tool:"): return "ws_tools"
	match s:
		"living", "library", "kitchen", "well", "storage", "windmill", "lumber", "orchard", "greenhouse":
			return s
		"barn":
			if id in ["cellar", "cellar_2", "oak_barrels"]: return "barn_cellar"
			if id == "fermenter": return "barn_ferment"
			if id in ["hay_rack", "water_trough"]: return "barn_hay"
			if id == "seed_library": return "barn_seeds"
			return "barn_build"
		"workshop":
			if id in ["workbench", "carpenter_bench", "sawbench", "press", "polish_workbench"]: return "ws_bench"
			if id in ["kiln", "kiln_2", "glass_kiln", "forge", "forge_2", "anvil", "smithy_chimney", "polish_kiln", "polish_forge"]: return "ws_fire"
			if id in ["hand_loom", "textile_loom", "spinning_wheel", "dye_vat", "polish_loom"]: return "ws_loom"
			if id in ["tool_rack", "master_tool_chest", "whetstone", "grindstone"]: return "ws_tools"
			return "ws_build"
		"chicken_area": return "coop"
		"cow_area": return "cows"
		"sheep_area": return "sheep"
		"bee_yard": return "bees"
		"village": return "board"
		"pet": return "pets"
		"fence", "field2", "field3": return "field"
		"market":
			if id == "book_cart": return "bookcart"
			if id == "import_broker": return "broker"
			return "market"
		"road": return "road"
		"special":
			if id.begins_with("orchard"): return "orchard"
			if id.begins_with("greenhouse"): return "greenhouse"
			return "pond"
		"field":
			if id == "wild_edge" or id == "gathering_basket": return "forest"
			if id.begins_with("compost") or id.begins_with("worm"): return "compost"
			return "field"
	return "field"
