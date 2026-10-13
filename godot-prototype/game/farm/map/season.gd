extends RefCounted
class_name FarmSeasonLook
## The season over the pictures of the farm map (N7): one shader (kits/ui/season.gdshader) on every picture that stands on the farm:
## buildings, trees, fences, patches, add-ons. Words (names, badges) and the farmer, animals and the cat do not get it.
## `set_season` is called when the season changes; `apply_tree` once, when the map is built; `shade` for pictures made later.

const SHADER = preload("res://kits/ui/season.gdshader")

static var _mat: ShaderMaterial        # for pictures with roofs, tops and rails: snow caps in winter
static var _flat: ShaderMaterial       # for what lies flat or grows (soil, plants): muted in winter, no caps, and green stays green in autumn

static func material() -> ShaderMaterial:
	if _mat == null:
		_mat = ShaderMaterial.new()
		_mat.shader = SHADER
	return _mat

static func flat_material() -> ShaderMaterial:
	if _flat == null:
		_flat = ShaderMaterial.new()
		_flat.shader = SHADER
		_flat.set_shader_parameter("snow", 0.0)
	return _flat

static func set_season(s: String) -> void:
	for m in [material(), flat_material()]:
		m.set_shader_parameter("winter", 1.0 if s == "winter" else 0.0)
	material().set_shader_parameter("autumn", 1.0 if s == "autumn" else 0.0)

## A picture made after the map was built (the overlays on a workbench …).
static func shade(n: CanvasItem) -> void:
	n.material = material()

## Puts the season on every picture below `root`. Not on words, panels and buttons (their text would get snow on top), nor on
## whatever `skip` holds (the farmer: a node and everything below it). A node with the meta "flat" (soil, the layer of plants)
## and everything below it gets the flat material.
static func apply_tree(root: Node, skip: Array = [], flat := false) -> void:
	for c in root.get_children():
		if c in skip or c is Label or c is Button or c is PanelContainer: continue
		var f: bool = flat or bool(c.get_meta("flat", false))
		if c is CanvasItem: c.material = flat_material() if f else material()
		apply_tree(c, skip, f)
