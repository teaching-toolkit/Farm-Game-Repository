extends RefCounted
class_name FarmMapWalker
## The farmer walking: a grid over the map, path-finding around what stands there, taps on the ground.

var map: FarmMap   # the map: its layers and the other parts

func _init(owner_map: FarmMap) -> void:
	map = owner_map

var astar := AStarGrid2D.new()

var _grid_sig := ""

const CELL := 16.0

# ------------------------------------------------------------------ the farmer walking about

## The grass (or road, or forest floor) was tapped at p (farm coordinates): the farmer walks there.
func ground_tapped(p: Vector2) -> void:
	if map.actor: map.actor.stop()
	if map.avatar: map.avatar.walk_to(p)

func _walk_to_spot(sid: String) -> void:
	if map.avatar == null or not map.slots.has(sid): return
	if map.actor: map.actor.stop()
	map.avatar.walk_to(map.slots[sid].anchor + Vector2(0, 14))

func _walk_to_patch(_a: String, k: int, fv) -> void:
	if map.avatar == null: return
	if map.actor: map.actor.stop()
	map.avatar.walk_to(fv.position + fv.patch_center(k))

func _cell(p: Vector2) -> Vector2i:
	return Vector2i(clampi(int(p.x / CELL), 0, astar.region.size.x - 1), clampi(int(p.y / CELL), 0, astar.region.size.y - 1))

func _cell_center(c: Vector2i) -> Vector2:
	return Vector2((c.x + 0.5) * CELL, (c.y + 0.5) * CELL)

## The grid of where the farmer can walk: not through buildings, pens, ponds, fields or the forest. Made again when
## places appear (only visible ones block).
func _grid_update() -> void:
	var sig := ""
	for sid in map.slots: sig += "1" if map.slots[sid].visible else "0"
	if sig == _grid_sig and astar.region.size.x > 0: return
	_grid_sig = sig
	astar.region = Rect2i(0, 0, ceili(map.design.x / CELL), ceili(map.design.y / CELL))
	astar.cell_size = Vector2(CELL, CELL)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.update()
	var polys := []
	for sid in map.slots:
		var s = map.slots[sid]
		if not s.visible or s.kind == "sub": continue
		var fp: PackedVector2Array = s.foot_points()
		var poly := PackedVector2Array()
		var c: Vector2 = s.anchor + s.foot_center()
		for q in fp:
			var w: Vector2 = s.anchor + q
			poly.append(w + (w - c).normalized() * 4.0)
		polys.append(poly)
	for fv in map.fields:
		var x: float = fv.position.x + fv.size.x / 2.0
		var y: float = fv.position.y + fv.size.y
		polys.append(PackedVector2Array([Vector2(x, fv.position.y), Vector2(fv.position.x + fv.size.x, y - fv.size.y / 2.0),
			Vector2(x, y), Vector2(fv.position.x, y - fv.size.y / 2.0)]))
	var fpoly := map.ground.forest_poly()
	if fpoly.size() >= 3: polys.append(fpoly)
	for poly in polys:
		var r := Rect2(poly[0], Vector2.ZERO)
		for q in poly: r = r.expand(q)
		var a := _cell(r.position)
		var b := _cell(r.end)
		for cx in range(a.x, b.x + 1):
			for cy in range(a.y, b.y + 1):
				if Geometry2D.is_point_in_polygon(_cell_center(Vector2i(cx, cy)), poly): astar.set_point_solid(Vector2i(cx, cy), true)

func _nearest_free(c: Vector2i) -> Vector2i:
	if not astar.is_point_solid(c): return c
	for rad in range(1, 30):
		var best := Vector2i(-1, -1)
		var bd := 1e9
		for dx in range(-rad, rad + 1):
			for dy in range(-rad, rad + 1):
				if maxi(absi(dx), absi(dy)) != rad: continue
				var q := c + Vector2i(dx, dy)
				if not astar.region.has_point(q) or astar.is_point_solid(q): continue
				var dd := Vector2(dx, dy * 2.0).length()     # prefer cells beside or below (the front of things)
				if dd < bd:
					bd = dd
					best = q
		if best.x >= 0: return best
	return c

func _clear_line(a: Vector2, b: Vector2) -> bool:
	var n := int(a.distance_to(b) / (CELL * 0.4)) + 1
	for i in range(n + 1):
		if astar.is_point_solid(_cell(a.lerp(b, float(i) / float(n)))): return false
	return true

## A way from one point to another around everything that stands in the way (straightened where nothing is in between).
func find_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	_grid_update()
	var a := _nearest_free(_cell(from))
	var goal := _cell(to)
	var end_free: bool = not astar.is_point_solid(goal)
	var b := _nearest_free(goal)
	var ids: Array[Vector2i] = astar.get_id_path(a, b)
	if ids.is_empty(): return PackedVector2Array()
	var pts := PackedVector2Array([from])
	for c in ids: pts.append(_cell_center(c))
	pts[pts.size() - 1] = to.clamp(Vector2(4, 4), map.design - Vector2(4, 4)) if end_free else _cell_center(b)
	var out := PackedVector2Array([pts[0]])
	var i := 0
	while i < pts.size() - 1:
		var j := pts.size() - 1
		while j > i + 1 and not _clear_line(pts[i], pts[j]): j -= 1
		out.append(pts[j])
		i = j
	return out
