extends RefCounted
## World kit · shapes: small polygon helpers for a one-screen map drawn in "design" pixels.
##   const Shapes = preload("res://kits/world/shapes.gd")

## [[x, y], …] from the data → points.
static func pts(arr: Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in arr: out.append(Vector2(float(p[0]), float(p[1])))
	return out

## The rectangle around a polygon, cut to clip.
static func poly_rect(poly: PackedVector2Array, clip: Rect2) -> Rect2:
	if poly.is_empty(): return Rect2()
	var r := Rect2(poly[0], Vector2.ZERO)
	for p in poly: r = r.expand(p)
	return r.intersection(clip)

## A band of width w along a line: left side forwards, then right side backwards.
static func band(line: PackedVector2Array, w: float) -> PackedVector2Array:
	var n := line.size()
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for i in range(n):
		var d := Vector2.ZERO
		if i > 0: d += (line[i] - line[i - 1]).normalized()
		if i < n - 1: d += (line[i + 1] - line[i]).normalized()
		var nrm := Vector2(-d.y, d.x).normalized() * w / 2.0
		left.append(line[i] + nrm)
		right.append(line[i] - nrm)
	right.reverse()
	left.append_array(right)
	return left

## Which edges of the map (size) a point lies on: "l", "r", "t", "b".
static func edges_of(p: Vector2, size: Vector2) -> Array:
	var e := []
	if p.x <= 0.5: e.append("l")
	if p.x >= size.x - 0.5: e.append("r")
	if p.y <= 0.5: e.append("t")
	if p.y >= size.y - 0.5: e.append("b")
	return e

## Corners lying on the map's edge are pushed outward (by reach) along their inner edge, so a ground shape continues
## off the map on wide or tall screens.
static func extended(poly: PackedVector2Array, size: Vector2, reach: float) -> PackedVector2Array:
	var out := PackedVector2Array()
	var n := poly.size()
	for i in range(n):
		var p := poly[i]
		var on := edges_of(p, size)
		if on.is_empty():
			out.append(p)
			continue
		var prev := poly[(i - 1 + n) % n]
		var nxt := poly[(i + 1) % n]
		var dir := Vector2.ZERO
		for q in [prev, nxt]:
			var shared := false
			for e in edges_of(q, size):
				if e in on: shared = true
			if not shared: dir = (p - q).normalized()
		if dir == Vector2.ZERO:   # a corner of the map: straight outwards
			dir = Vector2(-1.0 if p.x < size.x / 2.0 else 1.0, -1.0 if p.y < size.y / 2.0 else 1.0).normalized()
		out.append(p + dir * reach)
	return out
