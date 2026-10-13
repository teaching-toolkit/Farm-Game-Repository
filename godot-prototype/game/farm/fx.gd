## Perk effects: lightning for quick sums, flying coins, and the
## things drawn over the farm (butterflies, sparkles, a rainbow after rain, petals / leaves / snow).
extends RefCounted


## A bolt of lightning from the top of the pop-up down to a point, flickering, with a flash. Frees itself.
class Lightning extends Control:
	var t := 0.0
	var target := Vector2.ZERO
	var pts := PackedVector2Array()
	var branch := PackedVector2Array()

	func start(to: Vector2) -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		target = to
		_shape()
		set_process(true)

	func _jag(a: Vector2, b: Vector2, n: int, w: float) -> PackedVector2Array:
		var out := PackedVector2Array()
		for i in range(n + 1):
			var f := float(i) / float(n)
			var p := a.lerp(b, f)
			if i > 0 and i < n: p += Vector2(randf_range(-w, w), randf_range(-w * 0.3, w * 0.3))
			out.append(p)
		return out

	func _shape() -> void:
		var top := Vector2(clampf(target.x + randf_range(-120.0, 120.0), 20.0, size.x - 20.0), 0.0)
		pts = _jag(top, target, 10, 26.0)
		var k := randi_range(3, 6)
		var from := pts[k]
		branch = _jag(from, from + Vector2(randf_range(-90.0, 90.0), randf_range(60.0, 120.0)), 5, 14.0)

	func _process(d: float) -> void:
		var before := int(t / 0.08)
		t += d
		if t < 0.3 and int(t / 0.08) != before: _shape()
		queue_redraw()
		if t > 0.65: queue_free()

	func _draw() -> void:
		var a := clampf(1.0 - t / 0.65, 0.0, 1.0)
		var flash := maxf(0.0, 1.0 - t / 0.22)
		draw_rect(Rect2(Vector2.ZERO, size), Color(1.0, 1.0, 0.85, 0.32 * flash))
		for line in [pts, branch]:
			if line.size() < 2: continue
			var w := 1.0 if line == pts else 0.6
			draw_polyline(line, Color(1.0, 0.9, 0.3, 0.35 * a), 16.0 * w)
			draw_polyline(line, Color(1.0, 0.97, 0.6, 0.9 * a), 6.0 * w)
			draw_polyline(line, Color(1, 1, 1, a), 2.5 * w)
		draw_circle(target, 18.0 * a, Color(1.0, 0.95, 0.5, 0.5 * a))


## Coins flying in an arc from a point to the coin counter; on_land is called for each coin that arrives.
class CoinShower extends Control:
	var coins := []
	var t := 0.0
	var on_land: Callable

	func start(from: Vector2, to: Vector2, n: int, land: Callable) -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		on_land = land
		for i in range(n):
			var a := from + Vector2(randf_range(-40.0, 40.0), randf_range(-20.0, 20.0))
			var c := (a + to) / 2.0 + Vector2(randf_range(-80.0, 80.0), -160.0)
			coins.append({"a": a, "b": to, "c": c, "t0": i * 0.07, "done": false, "rot": randf() * TAU})
		set_process(true)

	func _process(d: float) -> void:
		t += d
		var all := true
		for c in coins:
			var f: float = (t - float(c["t0"])) / 0.7
			if f >= 1.0 and not c["done"]:
				c["done"] = true
				if on_land.is_valid(): on_land.call()
			if f < 1.0: all = false
		queue_redraw()
		if all: queue_free()

	func _draw() -> void:
		for c in coins:
			var f: float = (t - float(c["t0"])) / 0.7
			if f < 0.0 or f >= 1.0: continue
			var e := f * f * (3.0 - 2.0 * f)
			var p: Vector2 = (c["a"] as Vector2).lerp(c["c"], e).lerp((c["c"] as Vector2).lerp(c["b"], e), e)
			var r := 11.0 * (1.0 - 0.35 * f)
			var squash := absf(cos(t * 9.0 + float(c["rot"])))
			draw_set_transform(p, 0.0, Vector2(maxf(0.25, squash), 1.0))
			draw_circle(Vector2.ZERO, r, Color("c98a1c"))
			draw_circle(Vector2.ZERO, r * 0.82, Color("f4c542"))
			draw_circle(Vector2(-r * 0.25, -r * 0.25), r * 0.25, Color(1, 1, 1, 0.55))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## Drawn over the farm (in farm coordinates): butterflies over the fields, sparkles where you tap, a rainbow after rain,
## and the season breeze (petals, fluff, leaves, snow). on = {"butterflies": bool, "sparkles": …, "rainbow": …, "breeze": …}.
class MapFx extends Control:
	const WING := [Color("f4a3c0"), Color("ffd166"), Color("9ad1f5"), Color("c3a6ff"), Color("ffffff")]
	var on := {}
	var areas: Array = []          # Rect2s the butterflies like (the fields)
	var season := "spring"
	var flies := []
	var sparks := []
	var drift := []
	var glow := []                 # fireflies (perk)
	var star_t := -1.0             # a shooting star crossing the sky (perk); < 0: none now
	var star_wait := 6.0
	var star_from := Vector2.ZERO
	var rainbow_t := -1.0
	var rainbow_len := 40.0
	var t := 0.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		set_process(true)

	func set_on(flags: Dictionary) -> void:
		on = flags
		if not on.get("butterflies", false): flies.clear()
		elif flies.is_empty():
			for i in range(4):
				var p := _spot()
				flies.append({"p": p, "to": _spot(), "ph": randf() * TAU, "c": WING[i % WING.size()], "rest": 0.0})
		if not on.get("breeze", false): drift.clear()
		elif drift.is_empty():
			for i in range(22): drift.append(_flake(true))
		if not on.get("rainbow", false): rainbow_t = -1.0
		if not on.get("fireflies", false): glow.clear()
		elif glow.is_empty():
			for i in range(14): glow.append({"p": _spot(), "ph": randf() * TAU, "v": Vector2(randf_range(-9.0, 9.0), randf_range(-6.0, 6.0))})
		if not on.get("stars", false): star_t = -1.0

	func set_season(s: String) -> void:
		if s == season: return
		season = s
		drift.clear()
		if on.get("breeze", false):
			for i in range(22): drift.append(_flake(true))

	func _spot() -> Vector2:
		if areas.is_empty(): return Vector2(randf_range(0.2, 0.8) * size.x, randf_range(0.4, 0.8) * size.y)
		var r: Rect2 = areas[randi() % areas.size()]
		return r.position + Vector2(randf() * r.size.x, randf() * r.size.y * 0.8)

	func _flake(anywhere: bool) -> Dictionary:
		var p := Vector2(randf_range(-0.1, 1.0) * size.x, randf_range(0.0, 1.0) * size.y if anywhere else -20.0)
		return {"p": p, "v": Vector2(randf_range(14.0, 34.0), randf_range(16.0, 30.0)), "ph": randf() * TAU, "s": randf_range(0.7, 1.3), "rot": randf() * TAU}

	func sparkle(at: Vector2) -> void:
		if not on.get("sparkles", false): return
		for i in range(9):
			var a := TAU * i / 9.0 + randf() * 0.3
			sparks.append({"p": at, "v": Vector2(cos(a), sin(a)) * randf_range(40.0, 95.0), "t": 0.0, "c": WING[randi() % WING.size()], "s": randf_range(5.0, 9.0)})

	func rainbow() -> void:
		if on.get("rainbow", false): rainbow_t = 0.0

	func _process(d: float) -> void:
		t += d
		var busy := not flies.is_empty() or not sparks.is_empty() or not drift.is_empty() or rainbow_t >= 0.0 or not glow.is_empty() or on.get("stars", false)
		if not busy: return
		for g in glow:
			g["ph"] = float(g["ph"]) + d * 2.4
			g["p"] = g["p"] + (g["v"] as Vector2) * d
			if g["p"].x < 0.0 or g["p"].x > size.x or g["p"].y < size.y * 0.3 or g["p"].y > size.y: g["v"] = -(g["v"] as Vector2)
		if on.get("stars", false):
			if star_t >= 0.0:
				star_t += d
				if star_t > 1.1: star_t = -1.0; star_wait = randf_range(14.0, 30.0)
			else:
				star_wait -= d
				if star_wait <= 0.0: star_t = 0.0; star_from = Vector2(randf_range(0.2, 0.8) * size.x, randf_range(0.02, 0.15) * size.y)
		for f in flies:
			f["ph"] = float(f["ph"]) + d * 16.0
			if float(f["rest"]) > 0.0:
				f["rest"] = float(f["rest"]) - d
				continue
			var to: Vector2 = f["to"] - f["p"]
			if to.length() < 6.0:
				f["to"] = _spot()
				f["rest"] = randf_range(0.5, 2.5) if randf() < 0.5 else 0.0
			else:
				f["p"] = f["p"] + to.normalized() * 34.0 * d + Vector2(0, sin(t * 3.0 + float(f["ph"]) * 0.1) * 0.6)
		for s in sparks:
			s["t"] = float(s["t"]) + d
			s["p"] = s["p"] + s["v"] * d
			s["v"] = s["v"] * 0.93
		sparks = sparks.filter(func(s): return float(s["t"]) < 0.8)
		for i in range(drift.size()):
			var fl: Dictionary = drift[i]
			fl["ph"] = float(fl["ph"]) + d * 2.0
			fl["rot"] = float(fl["rot"]) + d * 1.5
			fl["p"] = fl["p"] + (fl["v"] as Vector2) * d + Vector2(sin(float(fl["ph"])) * 0.5, 0)
			if fl["p"].y > size.y + 20.0 or fl["p"].x > size.x + 20.0: drift[i] = _flake(false)
		if rainbow_t >= 0.0:
			rainbow_t += d
			if rainbow_t > rainbow_len: rainbow_t = -1.0
		queue_redraw()

	func _draw() -> void:
		if rainbow_t >= 0.0:
			var a := clampf(rainbow_t / 2.0, 0.0, 1.0) * clampf((rainbow_len - rainbow_t) / 6.0, 0.0, 1.0)
			var cols := [Color("e8453c"), Color("f28c28"), Color("f2d23c"), Color("5bb34a"), Color("3f8fd8"), Color("5a4fcf"), Color("9b59b6")]
			var c := Vector2(size.x * 0.5, size.y * 0.72)
			var r0 := size.x * 0.62
			for i in range(cols.size()):
				var col: Color = cols[i]
				draw_arc(c, r0 - i * 9.0, PI * 1.08, PI * 1.92, 64, Color(col.r, col.g, col.b, 0.38 * a), 9.0, true)
		for fl in drift:
			_flake_draw(fl)
		for g in glow:
			var b := 0.5 + 0.5 * sin(float(g["ph"]))
			draw_circle(g["p"], 7.0, Color(1.0, 0.92, 0.45, 0.10 + 0.18 * b))
			draw_circle(g["p"], 2.6, Color(1.0, 0.95, 0.6, 0.55 + 0.45 * b))
		if star_t >= 0.0:
			var k2 := star_t / 1.1
			var head := star_from + Vector2(260.0, 150.0) * k2
			var tail := head - Vector2(80.0, 46.0) * sin(k2 * PI)
			draw_line(tail, head, Color(1, 1, 0.85, 0.9 * (1.0 - k2)), 3.0, true)
			draw_circle(head, 3.5, Color(1, 1, 0.9, 1.0 - k2))
		for f in flies:
			var p: Vector2 = f["p"]
			var flap := absf(sin(float(f["ph"])))
			var col: Color = f["c"]
			for side in [-1.0, 1.0]:
				draw_set_transform(p + Vector2(side * 3.0 * flap, 0), 0.0, Vector2(maxf(0.15, flap), 1.0))
				draw_circle(Vector2(side * 5.0, -2.0), 5.5, col)
				draw_circle(Vector2(side * 4.0, 4.0), 3.8, col.darkened(0.1))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			draw_line(p + Vector2(0, -5), p + Vector2(0, 6), Color("3b2f2a"), 2.0)
		for s in sparks:
			var k := 1.0 - float(s["t"]) / 0.8
			var col2: Color = s["c"]
			_star4(s["p"], float(s["s"]) * (0.6 + 0.4 * k), Color(col2.r, col2.g, col2.b, k))
			_star4(s["p"], float(s["s"]) * 0.45 * k, Color(1, 1, 1, k))

	func _star4(c: Vector2, r: float, col: Color) -> void:
		var pts := PackedVector2Array([c + Vector2(0, -r), c + Vector2(r * 0.25, -r * 0.25), c + Vector2(r, 0), c + Vector2(r * 0.25, r * 0.25),
			c + Vector2(0, r), c + Vector2(-r * 0.25, r * 0.25), c + Vector2(-r, 0), c + Vector2(-r * 0.25, -r * 0.25)])
		draw_colored_polygon(pts, col)

	func _flake_draw(fl: Dictionary) -> void:
		var p: Vector2 = fl["p"]
		var s: float = fl["s"]
		match season:
			"spring":
				draw_set_transform(p, float(fl["rot"]), Vector2(1.0, 0.55) * s)
				draw_circle(Vector2.ZERO, 4.5, Color(1.0, 0.78, 0.86, 0.85))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			"summer":
				draw_circle(p, 2.2 * s, Color(1, 1, 1, 0.75))
				for k in range(6):
					var a := TAU * k / 6.0 + float(fl["rot"])
					draw_line(p, p + Vector2(cos(a), sin(a)) * 5.0 * s, Color(1, 1, 1, 0.45), 1.0)
			"autumn":
				draw_set_transform(p, float(fl["rot"]), Vector2(1.0, 0.5) * s)
				draw_circle(Vector2.ZERO, 5.5, Color("d9822b") if int(fl["ph"] * 10.0) % 2 == 0 else Color("b5562b"))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			"winter":
				draw_circle(p, 3.0 * s, Color(1, 1, 1, 0.9))
