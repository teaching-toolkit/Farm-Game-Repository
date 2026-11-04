extends RefCounted
class_name FarmSeasonLook
## The season over the pictures of the farm map (N7): one shader (kits/ui/season.gdshader) on every picture that stands on the farm:
## buildings, trees, fences, patches, add-ons. Words (names, badges) and the farmer, animals and the cat do not get it.
## `set_season` is called when the season changes; `apply_tree` once, when the map is built; `shade` for pictures made later.

const SHADER = preload("res://kits/ui/season.gdshader")

static var _mat: ShaderMaterial        # for pictures with roofs, tops and rails: snow caps in winter
static var _flat: ShaderMaterial       # for what lies flat or grows (soil, plants): muted in winter, no caps, and green stays green in autumn
static var _frost: ShaderMaterial      # for the field patches' soil and the road: muted in winter with a thin rim of frost on the top edge, no golden autumn

static func material() -> ShaderMaterial:
	if _mat == null:
		_mat = ShaderMaterial.new()
		_mat.shader = SHADER
		var g = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("/root/Game")
		if g != null: _mat.set_shader_parameter("snow_depth", g.feel("season.snowDepth"))     # rules/65-feel.json
	return _mat

static func flat_material() -> ShaderMaterial:
	if _flat == null:
		_flat = ShaderMaterial.new()
		_flat.shader = SHADER
		_flat.set_shader_parameter("snow", 0.0)
	return _flat

## Whether a creature (an animal or pet node id, "pest_…", "butterflies", "fireflies", "farm_cat") can be seen in this season:
## its "seasons" list in rules/66-season-look.json (season-look/03). One without a list is always out (check_data.py warns).
static func critter_out(G, id: String, season := "") -> bool:
	var e = G.meta.get("seasonLook", {}).get("critters", {}).get(id, null)
	if typeof(e) != TYPE_DICTIONARY or not e.has("seasons"): return true
	return (e["seasons"] as Array).has(season if season != "" else G.seasons.season())

## The pests' emojis that can come to the fields in this season, in the data's order (the chapter's own kind first).
static func pest_kinds(G) -> Array:
	var out := []
	var cr: Dictionary = G.meta.get("seasonLook", {}).get("critters", {})
	for id in cr:
		if typeof(cr[id]) == TYPE_DICTIONARY and cr[id].get("pest", false) and critter_out(G, id): out.append(str(cr[id].get("emoji", "")))
	return out

## The frost on the top edge of the field patches and on the road tiles (season-look/04): the same snow cap, thinner and lighter
## (season.frostDepth and season.frostStrength in rules/65-feel.json).
static func frost_material() -> ShaderMaterial:
	if _frost == null:
		_frost = ShaderMaterial.new()
		_frost.shader = SHADER
		var g = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("/root/Game")
		if g != null:
			_frost.set_shader_parameter("snow_depth", g.feel("season.frostDepth"))
			_frost.set_shader_parameter("snow", g.feel("season.frostStrength"))
	return _frost

## How many flowers stand in the grass now (season-look/02): the season's number from rules/66-season-look.json "flowers", reached
## over the first changeQuestions questions of the season, starting from the last season's number.
static func flower_count(G) -> int:
	var fl: Dictionary = G.meta.get("seasonLook", {}).get("flowers", {})
	var cnt: Dictionary = fl.get("count", {})
	var no: int = G.seasons.season_no()
	var now := float(cnt.get(G.SEASON_NAMES[no % 4], 0))
	var before := float(cnt.get(G.SEASON_NAMES[(no + 3) % 4], 0))
	var q := float(int(G.S["step"]) % G.seasons.season_len())
	var k := clampf(q / maxf(1.0, float(fl.get("changeQuestions", 1))), 0.0, 1.0)
	return int(round(lerpf(before, now, k)))

static func set_season(s: String) -> void:
	for m in [material(), flat_material(), frost_material()]:
		m.set_shader_parameter("winter", 1.0 if s == "winter" else 0.0)
	material().set_shader_parameter("autumn", 1.0 if s == "autumn" else 0.0)

## A picture made after the map was built (the overlays on a workbench …).
static func shade(n: CanvasItem) -> void:
	n.material = material()

## Puts the season on every picture below `root`. Not on words, panels and buttons (their text would get snow on top), nor on
## whatever `skip` holds (the farmer: a node and everything below it). A node with the meta "flat" (soil, the layer of plants)
## and everything below it gets the flat material; a node with the meta "frost" (the soil picture of a field patch) gets the frost.
static func apply_tree(root: Node, skip: Array = [], flat := false) -> void:
	for c in root.get_children():
		if c in skip or c is Label or c is Button or c is PanelContainer: continue
		var f: bool = flat or bool(c.get_meta("flat", false))
		if c is CanvasItem: c.material = frost_material() if c.get_meta("frost", false) else (flat_material() if f else material())
		apply_tree(c, skip, f)
