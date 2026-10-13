extends RefCounted
class_name FarmMapGround
## The ground: grass, earth, the road (mud to paved) and the forest, drawn onto the board; the season changes the colours.
const Art = preload("res://kits/ui/art.gd")
const Slot = preload("res://game/farm/map/slot.gd")


var map: FarmMap   # the map: its layers and the other parts

func _init(owner_map: FarmMap) -> void:
	map = owner_map

const EXTEND := 1500.0   # ground shapes that touch the edge continue beyond it (wide or tall screens)

const ROAD_TILES := {1.0: [1, 2], 1.5: [2, 3], 2.0: [3, 4], 2.5: [4, 5], 3.0: [5, 6], 3.5: [6, 7], 4.0: [7, 8], 4.5: [8, 9], 5.0: [9]}

var fence_level := 0

# ------------------------------------------------------------------ ground

## A soft round patch of another grass picture on the background (fading towards its edge).
func _grass_blob(c: Vector2, rad: float, tex: Texture2D, tint: Color) -> void:
	var ts := Vector2(tex.get_width(), tex.get_height()) * map.GRASS_SCALE
	for ring in range(7):
		var k := 1.0 - ring * 0.12
		var pts := PackedVector2Array()
		var uvs := PackedVector2Array()
		for j in range(24):
			var a := TAU * j / 24.0
			var p := c + Vector2(cos(a), sin(a) * 0.6) * rad * k * (1.0 + 0.12 * sin(a * 3.0 + c.x))
			pts.append(p)
			uvs.append(p / ts)
		map.board.draw_polygon(pts, PackedColorArray([Color(tint.r, tint.g, tint.b, 0.1)]), uvs, tex)

## Little things growing in the grass (assets/deco/grass_1 … grass_9): drawn under everything else.
func _draw_grass_bits() -> void:
	var bits := []
	for i in range(1, 10):
		var t: Texture2D = Art.tex("deco", "grass_%d" % i)
		if t: bits.append(t)
	if bits.is_empty(): return
	var r := RandomNumberGenerator.new()
	r.seed = 53
	var fp := forest_poly()
	for _k in range(90):
		var p := Vector2(r.randf_range(-20, map.design.x + 20), r.randf_range(-10, map.design.y + 30))
		var t: Texture2D = bits[r.randi() % bits.size()]
		if fp.size() >= 3 and Geometry2D.is_point_in_polygon(p, fp): continue
		var w := r.randf_range(18, 34)
		var h := w * float(t.get_height()) / float(t.get_width())
		map.board.draw_texture_rect(t, Rect2(p - Vector2(w / 2.0, h), Vector2(w, h)), false)

## Ground shapes in farm coordinates: forest, road, the house yard, shadows and fences of the fields.
func _draw_board() -> void:
	var gr: Dictionary = map.L.get("ground", {})
	var tint: Color = map.GRASS_TINT.get(map.season, Color.WHITE)
	# soft patches of the other grass pictures, so the meadow is not the same everywhere (fixed places on the farm)
	var r := RandomNumberGenerator.new()
	r.seed = 31
	for gi in range(2, 5):
		var gt: Texture2D = Art.tex("tiles", "grass_%d" % gi)
		if gt == null: continue
		for _k in range(7):
			_grass_blob(Vector2(r.randf() * map.design.x, r.randf() * map.design.y), r.randf_range(80, 170), gt, tint)
	# the forest has no floor of its own: its trees stand on the meadow (forest_poly is still where taps open the forest)
	_draw_grass_bits()
	# the village road: a band along a line, as good as it has been made
	_draw_road()
	# the house yard (until the house is built): packed earth on the house's footprint
	if not map.house_built and map.slots.has("home"):
		var hs = map.slots["home"]
		var yard := Art.tex("plots", "home")
		var fpts: PackedVector2Array = hs.foot_points()
		var w: float = fpts[1].x - fpts[3].x
		var earth: Array = Slot.earth_tiles()
		if earth.size() > 0:
			# flat earth tiles that blend into the grass, one on each tile of the plot and a few half-way out
			var rr := RandomNumberGenerator.new()
			rr.seed = 77
			var a: int = hs.foot.x
			var b: int = hs.foot.y
			for i in range(-1, a + 1):
				for j in range(-1, b + 1):
					var inside := i >= 0 and j >= 0 and i < a and j < b
					if not inside and rr.randf() > 0.35: continue
					var t: Texture2D = earth[rr.randi() % earth.size()]
					var c2: Vector2 = hs.anchor + hs.foot_at((i + 0.5) / a, (j + 0.5) / b)
					var tw2: float = map.tile * 1.12
					var th: float = tw2 * float(t.get_height()) / float(t.get_width())
					map.board.draw_texture_rect(t, Rect2(c2 - Vector2(tw2, th) / 2.0, Vector2(tw2, th)), false)
		elif yard:
			var h := w * 1.06 * float(yard.get_height()) / float(yard.get_width())
			var c: Vector2 = hs.anchor + hs.foot_center()
			map.board.draw_texture_rect(yard, Rect2(Vector2(c.x - w * 0.53, hs.anchor.y + w * 1.06 * Slot.PLOT_DROP - h), Vector2(w * 1.06, h)), false)
		else:
			var yp := PackedVector2Array()
			for p in fpts: yp.append(p + hs.anchor)
			map.board.draw_colored_polygon(yp, Color(0.78, 0.66, 0.46, 0.75))
			yp.append(yp[0])
			map.board.draw_polyline(yp, Color(0.45, 0.33, 0.2, 0.5), 2.0)
	_draw_earth()
	# (no shadows under the fields: they lie flat on the ground)

## The road's middle line, continued beyond the farm's edges.
## Bare earth of every place (ruins, pens, building sites), on the ground and back to front.
func _draw_earth() -> void:
	var cells := []
	for sid in map.slots:
		var s = map.slots[sid]
		if s.visible: cells.append_array(s.earth_cells())
	cells.sort_custom(func(a, b): return (a[1] as Rect2).position.y < (b[1] as Rect2).position.y)
	for c in cells: map.board.draw_texture_rect(c[0], c[1], false)

func _road_line() -> PackedVector2Array:
	var rd: Dictionary = map.L.get("ground", {}).get("road", {})
	if not rd.has("points") or rd["points"].size() < 2: return PackedVector2Array()
	var line := _pts(rd["points"])
	line[0] = line[0] + (line[0] - line[1]).normalized() * EXTEND
	var n := line.size()
	line[n - 1] = line[n - 1] + (line[n - 1] - line[n - 2]).normalized() * EXTEND
	return line

func _road_w() -> float:
	return float(map.L.get("ground", {}).get("road", {}).get("w", 64))

func road_band() -> PackedVector2Array:
	var line := _road_line()
	if line.size() < 2: return PackedVector2Array()
	return _band(line, _road_w())

func _draw_road() -> void:
	var line := _road_line()
	if line.size() < 2: return
	var w := _road_w()
	var tl := _road_tiles()
	if not tl.is_empty():
		_draw_road_tiles(line, w, tl)
		return
	var path_tex := Art.tex("tiles", "path")
	var winter := map.season == "winter"
	var n := line.size()
	var rng := RandomNumberGenerator.new()
	rng.seed = 4242
	var dir := (line[n - 1] - line[0]).normalized()
	var nrm := Vector2(-dir.y, dir.x)
	var lvl := int(floor(map.road_level + 0.01))
	if lvl <= 1:
		# a muddy track: two wheel ruts with grass between them, puddles and potholes
		var faint := _band(line, w)
		map.board.draw_colored_polygon(faint, Color(0.45, 0.35, 0.2, 0.14))
		for side in [-1.0, 1.0]:
			var rut := PackedVector2Array()
			for p in line: rut.append(p + nrm * side * w * 0.22)
			var band := _band(rut, w * 0.2)
			if path_tex: _textured(band, path_tex, Color(0.78, 0.66, 0.5))
			else: map.board.draw_colored_polygon(band, Color("a88a5e"))
		for i in range(9):
			var t := rng.randf_range(0.42, 0.58) + (i - 4) * 0.012
			var c := line[0].lerp(line[n - 1], t) + nrm * rng.randf_range(-0.3, 0.3) * w
			_blob(c, rng.randf_range(10, 20), Color(0.36, 0.42, 0.45, 0.75) if not winter else Color(0.85, 0.92, 0.97, 0.9))
		return
	var full := _band(line, w)
	var tint := Color.WHITE
	match lvl:
		2: tint = Color(0.9, 0.82, 0.68)
		3: tint = Color(0.95, 0.93, 0.86)
		4: tint = Color(0.78, 0.78, 0.76)
		_: tint = Color(0.72, 0.72, 0.74)
	if path_tex: _textured(full, path_tex, tint)
	else: map.board.draw_colored_polygon(full, Color("d8bf8e") * tint)
	if winter: map.board.draw_colored_polygon(full, Color(1, 1, 1, 0.25))
	var left := full.slice(0, n)
	var right := full.slice(n)
	var edge := Color(0, 0, 0, 0.12)
	if lvl >= 4: edge = Color(0.35, 0.35, 0.33, 0.7)
	map.board.draw_polyline(left, edge, 4.0 if lvl < 4 else 6.0)
	map.board.draw_polyline(right, edge, 4.0 if lvl < 4 else 6.0)
	var a := line[0].lerp(line[n - 1], 0.4)
	var b := line[0].lerp(line[n - 1], 0.6)
	match lvl:
		2:  # filled potholes: a few stones and old ruts
			for i in range(14):
				map.board.draw_circle(a.lerp(b, rng.randf()) + nrm * rng.randf_range(-0.4, 0.4) * w, rng.randf_range(2.0, 4.0), Color(0.55, 0.53, 0.5, 0.8))
		3:  # gravel
			for i in range(160):
				map.board.draw_circle(a.lerp(b, rng.randf()) + nrm * rng.randf_range(-0.45, 0.45) * w, 1.3, Color(0.55, 0.52, 0.48, 0.6))
		_:  # cobbles
			var steps := 70
			for i in range(steps):
				for j in range(-3, 4):
					var p := a.lerp(b, (i + (0.5 if j % 2 == 0 else 0.0)) / steps) + nrm * (j / 7.0) * w * 0.9
					map.board.draw_rect(Rect2(p - Vector2(4, 2.5), Vector2(8, 5)), Color(0.5, 0.5, 0.48, 0.35), false, 1.0)

func _road_tiles() -> Array:
	var key := clampf(snappedf(map.road_level, 0.5), 1.0, 5.0)
	var out := []
	for i in ROAD_TILES.get(key, [1, 2]):
		var t: Texture2D = Art.tex("road", "road_%d" % i)
		if t: out.append(t)
	return out

## The road as flat diamond tiles laid edge to edge along it (as wide as the road), back to front.
func _draw_road_tiles(line: PackedVector2Array, w: float, tl: Array) -> void:
	var W := w * 2.236            # a diamond W wide makes a strip W/√5 wide when they are laid along one side
	var H := W / 2.0
	var rng := RandomNumberGenerator.new()
	rng.seed = 777
	var cells := []
	for i in range(line.size() - 1):
		var a: Vector2 = line[i]
		var b: Vector2 = line[i + 1]
		var d := b - a
		var step := Vector2(signf(d.x) * W / 2.0, signf(d.y) * H / 2.0)
		if step.x == 0.0: step.x = W / 2.0
		if step.y == 0.0: step.y = H / 2.0
		var n := int(ceil(d.length() / step.length()))
		for k in range(n + 1):
			cells.append(a + d.normalized() * step.length() * k)
	cells.sort_custom(func(p, q): return p.y < q.y)
	for c in cells:
		var t: Texture2D = tl[rng.randi() % tl.size()]
		var h := W * float(t.get_height()) / float(t.get_width())
		map.board.draw_texture_rect(t, Rect2(c - Vector2(W, h) / 2.0, Vector2(W, h)), false)
	if map.season == "winter": map.board.draw_colored_polygon(_band(line, w), Color(1, 1, 1, 0.22))

func _blob(c: Vector2, r: float, col: Color) -> void:
	var pts := PackedVector2Array()
	for j in range(12):
		var a := TAU * j / 12.0
		pts.append(c + Vector2(cos(a) * r * (1.0 + 0.15 * sin(a * 3.0)), sin(a) * r * 0.5))
	map.board.draw_colored_polygon(pts, col)

## The forest floor shape, continued beyond the farm's edges (for drawing and for taps).
func forest_poly() -> PackedVector2Array:
	var fp: Array = map.L.get("ground", {}).get("forest", [])
	if fp.size() < 3: return PackedVector2Array()
	return _extended(_pts(fp))

func _pts(arr: Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in arr: out.append(Vector2(float(p[0]), float(p[1])))
	return out

## Corners lying on the farm's edge are pushed outward along their inner edge, so the shape continues off the farm.
func _extended(poly: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	var n := poly.size()
	for i in range(n):
		var p := poly[i]
		var on := _edges_of(p)
		if on.is_empty():
			out.append(p)
			continue
		var prev := poly[(i - 1 + n) % n]
		var nxt := poly[(i + 1) % n]
		var dir := Vector2.ZERO
		for q in [prev, nxt]:
			var shared := false
			for e in _edges_of(q):
				if e in on: shared = true
			if not shared: dir = (p - q).normalized()
		if dir == Vector2.ZERO:   # a corner of the farm: straight outwards
			dir = Vector2(-1.0 if p.x < map.design.x / 2.0 else 1.0, -1.0 if p.y < map.design.y / 2.0 else 1.0).normalized()
		out.append(p + dir * EXTEND)
	return out

func _edges_of(p: Vector2) -> Array:
	var e := []
	if p.x <= 0.5: e.append("l")
	if p.x >= map.design.x - 0.5: e.append("r")
	if p.y <= 0.5: e.append("t")
	if p.y >= map.design.y - 0.5: e.append("b")
	return e

## A band of width w along a line: left side forwards, then right side backwards.
func _band(line: PackedVector2Array, w: float) -> PackedVector2Array:
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

func _textured(poly: PackedVector2Array, tex: Texture2D, tint: Color) -> void:
	var uvs := PackedVector2Array()
	var ts := Vector2(tex.get_width(), tex.get_height()) * (map.GRASS_SCALE if tex == Art.tex("tiles", "grass") else 1.0)
	for p in poly: uvs.append(p / ts)
	map.board.draw_polygon(poly, PackedColorArray([tint]), uvs, tex)

func set_season(s: String, fence: int) -> void:
	if map.perk_fx: map.perk_fx.set_season(s)
	if s != map.season or fence != fence_level:
		map.season = s
		fence_level = fence
		map.queue_redraw()
		map.board.queue_redraw()
