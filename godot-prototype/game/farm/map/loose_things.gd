extends RefCounted
class_name FarmMapLoose
## The sticks and small stones lying about on the farm (visible-work/03). The rules give each one a share u, v of the farm's area;
## here it is put at the nearest free spot: not on a building, a patch, a pen, the forest or the road, and not on another one.
## A tap on one emits loose_tapped(id). Drawn among the standing things by their feet.

const Art = preload("res://kits/ui/art.gd")
const W := 26.0               # the width of a picture, farm pixels
const MARGIN := Vector2(24, 70)

var map: FarmMap   # the map: its layers and the other parts

signal loose_tapped(id: int)

func _init(owner_map: FarmMap) -> void:
	map = owner_map

var _nodes := {}     # id -> the picture
var _cell := {}      # id -> the grid cell it lies on
var _last := {}      # id -> where it lay (kept a moment, so a thing just picked up can still fly from there)

## What lies about: [{"id", "k", "u", "v"}], as the rules give it. Things that are gone are removed, new ones appear, and one whose
## spot has become a building is put elsewhere.
func set_loose(list: Array) -> void:
	map.walker._grid_update()
	var ids := {}
	for t in list: ids[int(t["id"])] = true
	for id in _nodes.keys():
		if not ids.has(id):
			_last[id] = _nodes[id].position + Vector2(W / 2.0, _nodes[id].size.y / 2.0)
			_nodes[id].queue_free()
			_nodes.erase(id)
			_cell.erase(id)
	for t in list:
		var id := int(t["id"])
		if _nodes.has(id) and _free(_cell[id], id): continue
		if _nodes.has(id):
			_nodes[id].queue_free()
			_nodes.erase(id)
			_cell.erase(id)
		var c := _spot(t, id)
		var tex := Art.tex("deco", "loose_%s_%d" % [str(t["k"]), 1 + id % 2])
		var feet: Vector2 = map.walker._cell_center(c)
		var node: TextureRect = map._standing(tex, feet, W)
		if node == null: continue
		node.mouse_filter = Control.MOUSE_FILTER_STOP
		node.gui_input.connect(_on_input.bind(id))
		FarmSeasonLook.shade(node)
		_nodes[id] = node
		_cell[id] = c
		map.critters.sort_in(node, feet.y)

## Where a thing flies from: where it lies, or lay a moment ago.
func point(id: int) -> Vector2:
	if _nodes.has(id): return _nodes[id].position + Vector2(W / 2.0, _nodes[id].size.y / 2.0)
	return _last.get(id, map.spot_point("storage"))

func shown() -> int:
	return _nodes.size()

## The cell of a thing: the free one nearest to its share of the farm's area.
func _spot(t: Dictionary, id: int) -> Vector2i:
	var want := Vector2(lerpf(MARGIN.x, map.design.x - MARGIN.x, float(t["u"])), lerpf(MARGIN.y, map.design.y - MARGIN.y, float(t["v"])))
	var c0: Vector2i = map.walker._cell(want)
	for rad in range(0, 40):
		var best := Vector2i(-1, -1)
		var bd := 1e9
		for dx in range(-rad, rad + 1):
			for dy in range(-rad, rad + 1):
				if maxi(absi(dx), absi(dy)) != rad: continue
				var q := c0 + Vector2i(dx, dy)
				if not _free(q, id): continue
				var dd := Vector2(dx, dy).length()
				if dd < bd:
					bd = dd
					best = q
		if best.x >= 0: return best
	return c0

func _free(c: Vector2i, id: int) -> bool:
	var a = map.walker.astar
	if not a.region.has_point(c) or a.is_point_solid(c): return false
	var p: Vector2 = map.walker._cell_center(c)
	if p.x < MARGIN.x or p.y < MARGIN.y or p.x > map.design.x - MARGIN.x or p.y > map.design.y - MARGIN.y: return false
	var rb: PackedVector2Array = map.ground.road_band()
	if rb.size() >= 3 and Geometry2D.is_point_in_polygon(p, rb): return false
	for other in _cell:
		if other != id and _cell[other] == c: return false
	return true

func _on_input(e: InputEvent, id: int) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		loose_tapped.emit(id)
