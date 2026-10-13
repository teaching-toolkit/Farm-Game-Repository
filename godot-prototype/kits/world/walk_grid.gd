extends RefCounted
## World kit · where figures can walk: a grid over the map with blocked cells (buildings, pens, ponds, fields, forest …)
## and a path-finder that goes round them and straightens the way where nothing is in between.
##   var grid = preload("res://kits/world/walk_grid.gd").new()
##   grid.rebuild(map_size, [polygon, …])      # again whenever what blocks changes
##   var path = grid.find_path(from, to)

var astar := AStarGrid2D.new()
var cell := 16.0
var size := Vector2.ZERO

func ready() -> bool:
	return astar.region.size.x > 0

func rebuild(map_size: Vector2, polys: Array) -> void:
	size = map_size
	astar.region = Rect2i(0, 0, ceili(size.x / cell), ceili(size.y / cell))
	astar.cell_size = Vector2(cell, cell)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.update()
	for poly in polys:
		var r := Rect2(poly[0], Vector2.ZERO)
		for q in poly: r = r.expand(q)
		var a := cell_of(r.position)
		var b := cell_of(r.end)
		for cx in range(a.x, b.x + 1):
			for cy in range(a.y, b.y + 1):
				if Geometry2D.is_point_in_polygon(center_of(Vector2i(cx, cy)), poly): astar.set_point_solid(Vector2i(cx, cy), true)

func cell_of(p: Vector2) -> Vector2i:
	return Vector2i(clampi(int(p.x / cell), 0, astar.region.size.x - 1), clampi(int(p.y / cell), 0, astar.region.size.y - 1))

func center_of(c: Vector2i) -> Vector2:
	return Vector2((c.x + 0.5) * cell, (c.y + 0.5) * cell)

## The nearest cell that is free, preferring cells beside or below (the front of things).
func nearest_free(c: Vector2i) -> Vector2i:
	if not astar.is_point_solid(c): return c
	for rad in range(1, 30):
		var best := Vector2i(-1, -1)
		var bd := 1e9
		for dx in range(-rad, rad + 1):
			for dy in range(-rad, rad + 1):
				if maxi(absi(dx), absi(dy)) != rad: continue
				var q := c + Vector2i(dx, dy)
				if not astar.region.has_point(q) or astar.is_point_solid(q): continue
				var dd := Vector2(dx, dy * 2.0).length()
				if dd < bd:
					bd = dd
					best = q
		if best.x >= 0: return best
	return c

func clear_line(a: Vector2, b: Vector2) -> bool:
	var n := int(a.distance_to(b) / (cell * 0.4)) + 1
	for i in range(n + 1):
		if astar.is_point_solid(cell_of(a.lerp(b, float(i) / float(n)))): return false
	return true

## A way from one point to another around everything that stands in the way (straightened where nothing is in between).
func find_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	var a := nearest_free(cell_of(from))
	var goal := cell_of(to)
	var end_free: bool = not astar.is_point_solid(goal)
	var b := nearest_free(goal)
	var ids: Array[Vector2i] = astar.get_id_path(a, b)
	if ids.is_empty(): return PackedVector2Array()
	var pts := PackedVector2Array([from])
	for c in ids: pts.append(center_of(c))
	pts[pts.size() - 1] = to.clamp(Vector2(4, 4), size - Vector2(4, 4)) if end_free else center_of(b)
	var out := PackedVector2Array([pts[0]])
	var i := 0
	while i < pts.size() - 1:
		var j := pts.size() - 1
		while j > i + 1 and not clear_line(pts[i], pts[j]): j -= 1
		out.append(pts[j])
		i = j
	return out
