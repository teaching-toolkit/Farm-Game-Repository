extends Control
## Trial look C: a 2D cut-out puppet. Flat painted shapes with a thick dark-brown outline drawn in code, jointed at the
## shoulders and hips and swung by code. Takes the same look dictionary as the avatar (colours and parts). Origin = the feet.
const INK := Color("4a3322")
var look := {}
var facing := 1.0          # 1 = looks right, -1 = mirrored (left)
var swing := 0.0           # radians: legs and arms swing opposite to each other
var bob := 0.0

func setup(lk: Dictionary, face_dir := 1.0, swing_angle := 0.0) -> void:
	look = lk
	facing = face_dir
	swing = swing_angle
	bob = absf(sin(swing_angle * 2.0)) * 2.0 if swing_angle != 0.0 else 0.0
	queue_redraw()

func _c(v, def: String) -> Color:
	return Color(str(v)) if str(v) != "" else Color(def)

func _poly(pts: PackedVector2Array, col: Color) -> void:
	draw_colored_polygon(pts, col)
	var closed := pts.duplicate()
	closed.append(pts[0])
	draw_polyline(closed, INK, 2.6, true)

func _ell(c: Vector2, rx: float, ry: float, col: Color, rot := 0.0) -> void:
	var pts := PackedVector2Array()
	for i in 28:
		var a := TAU * i / 28.0
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry).rotated(rot))
	_poly(pts, col)

func _rr(r: Rect2, rad: float, col: Color) -> void:
	var pts := PackedVector2Array()
	var cs := [[r.position + Vector2(rad, rad), PI], [r.position + Vector2(r.size.x - rad, rad), 1.5 * PI],
		[r.position + r.size - Vector2(rad, rad), 0.0], [r.position + Vector2(rad, r.size.y - rad), 0.5 * PI]]
	for cc in cs:
		for i in 6:
			var a: float = cc[1] + (PI / 2.0) * i / 5.0
			pts.append(cc[0] + Vector2(cos(a), sin(a)) * rad)
	_poly(pts, col)

func _at(pos: Vector2, rot := 0.0) -> void:
	draw_set_transform_matrix(Transform2D(Vector2(facing, 0), Vector2(0, 1), Vector2.ZERO) * Transform2D(rot, pos))

func _draw() -> void:
	if look.is_empty(): return
	var skin := _c(look.get("skin", ""), "#f1c7a0")
	var hair: Dictionary = look.get("hair", {})
	var shirt: Dictionary = look.get("shirt", {})
	var trou: Dictionary = look.get("trousers", {})
	var hat: Dictionary = look.get("hat", {})
	var shirt_c := _c(shirt.get("color", ""), "#e86a4a")
	var trou_c := _c(trou.get("color", ""), "#4a6fa5")
	var shoe_c := _c(look.get("shoes", {}).get("color", ""), "#6b4a2b")
	var hair_c := _c(hair.get("color", ""), "#7a4a26")
	var short_sleeve: bool = str(shirt.get("style", "tee")) != "long"
	var shorts: bool = str(trou.get("style", "")) == "shorts"
	var top := Vector2(0, -bob)
	var sh_pts := PackedVector2Array()
	for i in 20: sh_pts.append(Vector2(cos(TAU * i / 20.0) * 19, 1 + sin(TAU * i / 20.0) * 4.5))
	draw_colored_polygon(sh_pts, Color(0.1, 0.12, 0.05, 0.25))
	# legs (hips at y = -26): swing opposite
	for sd in [-1.0, 1.0]:
		_at(Vector2(6.5 * sd, -26.0 - bob), swing * sd)
		_rr(Rect2(-5.5, -2, 11, 22), 4, trou_c)
		if shorts: _rr(Rect2(-5.0, 11, 10, 9), 3, skin)
		_ell(Vector2(1.5, 25), 8.5, 5, shoe_c)
	# arms behind the body are drawn after: first the torso
	_at(top)
	_rr(Rect2(-14, -54, 28, 30), 9, shirt_c)
	if str(trou.get("style", "")) == "overalls":
		_rr(Rect2(-12, -40, 24, 17), 5, trou_c)
		for sd in [-1.0, 1.0]: _rr(Rect2(7 * sd - 2.5, -52, 5, 14), 2, trou_c)
		for sd in [-1.0, 1.0]: draw_circle(Vector2(7 * sd, -40), 1.8, Color("f2d23c"))
	else:
		_rr(Rect2(-14, -30, 28, 6), 3, trou_c)
	var apron: Dictionary = look.get("apron", {})
	if not apron.is_empty():
		_rr(Rect2(-11, -38, 22, 15), 3, _c(apron.get("color", ""), "#fffaf0"))
		_rr(Rect2(-6, -50, 12, 13), 3, _c(apron.get("color", ""), "#fffaf0"))
	var skirt: Dictionary = look.get("skirt", {})
	if not skirt.is_empty():
		_poly(PackedVector2Array([Vector2(-13, -30), Vector2(13, -30), Vector2(18, -2), Vector2(-18, -2)]), _c(skirt.get("color", ""), "#a35dd8"))
	# arms: shoulders at y = -52
	for sd in [-1.0, 1.0]:
		_at(Vector2(15.5 * sd, -50.0 - bob), -swing * sd * 1.2 + 0.05 * sd)
		_rr(Rect2(-4.5, -3, 9, 19 if short_sleeve else 26), 4, shirt_c)
		if short_sleeve: _rr(Rect2(-3.6, 12, 7.2, 12), 3, skin)
		_ell(Vector2(0, 27), 4.8, 4.8, skin)
	# head (drawn in the torso's frame)
	_at(top)
	_rr(Rect2(-4, -58, 8, 8), 2, skin)
	if str(hair.get("style", "short")) == "long":
		_rr(Rect2(-17, -78, 34, 36), 12, hair_c)
	_ell(Vector2(0, -68), 16.5, 15.5, skin)
	var hs := str(hair.get("style", "short"))
	if hs != "none":
		var pts := PackedVector2Array()
		for i in 15:
			var a := PI + PI * i / 14.0
			pts.append(Vector2(0, -70) + Vector2(cos(a) * 17.5, sin(a) * 16.5))
		pts.append(Vector2(11, -72)); pts.append(Vector2(0, -75)); pts.append(Vector2(-11, -72))
		_poly(pts, hair_c)
		if hs == "bun": _ell(Vector2(0, -88), 6.5, 6, hair_c)
		if hs == "pigtails":
			for sd in [-1.0, 1.0]: _ell(Vector2(19 * sd, -64), 5.5, 6, hair_c)
	if not (look.get("beard", {}) as Dictionary).is_empty():
		_ell(Vector2(0, -59), 12, 8, _c(look["beard"].get("color", ""), "#5a3519"))
		_ell(Vector2(0, -66), 16.5, 15.5, skin)   # face over the beard's top
		_ell(Vector2(0, -66), 0.01, 0.01, skin)
	# face: eyes look the way it faces
	var fx := 1.5
	for sd in [-1.0, 1.0]:
		_ell(Vector2(7 * sd + fx, -67), 3.6, 4.6, _c(look.get("eyes", ""), "#3a2a22"))
		draw_circle(Vector2(7 * sd + fx + 1.2, -69), 1.3, Color.WHITE)
		_ell(Vector2(11.5 * sd + fx, -59), 3.6, 2.4, _c(look.get("cheeks", ""), "#f29a9a").lerp(skin, 0.15))
	draw_arc(Vector2(fx, -62.5), 4.6, 0.25 * PI, 0.75 * PI, 8, Color("7a3b30"), 1.8, true)
	# hat
	match str(hat.get("style", "none")):
		"straw":
			var hm := _c(hat.get("color", ""), "#e9c46a")
			_ell(Vector2(0, -80), 27, 6.5, hm)
			_rr(Rect2(-12, -95, 24, 17), 8, hm)
			_rr(Rect2(-12.5, -84, 25, 5.5), 2, _c(hat.get("band", ""), "#c0392b"))
		"cap":
			var cm := _c(hat.get("color", ""), "#3f8fd8")
			var pts2 := PackedVector2Array()
			for i in 15:
				var a := PI + PI * i / 14.0
				pts2.append(Vector2(0, -75) + Vector2(cos(a) * 17.5, sin(a) * 15))
			_poly(pts2, cm)
			_rr(Rect2(2, -79, 19, 4.5), 2, cm)
	draw_set_transform_matrix(Transform2D.IDENTITY)
