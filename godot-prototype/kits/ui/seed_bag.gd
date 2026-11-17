extends RefCounted
## The seed bag: one tied cloth pouch the game draws itself, with the crop's small picture on its belly (pictures/02).
## Wherever bought seed is shown (the seed stall on the square, the store's seeds), it stands in for the bare crop picture, so
## a carrot seed reads as "seed" at a glance and no picture per crop is needed. Plain shapes and a thick dark-brown outline, like
## the game's pictures; no words. One picture could replace the whole shape later (a painted bag) without touching its callers.
##
##   SeedBag.make(pic, emoji, px) -> Control   a square px × px control; `pic` is the crop's small picture (Art.icon), null when
##                                             it has none, and then `emoji` sits on the belly (nothing at all when both are empty)

const OUTLINE := Color("4a3020")     # the dark brown of the game's picture outlines
const CLOTH := Color("dcc189")       # sacking
const CLOTH_DARK := Color("c3a56a")
const STRING := Color("b5532f")      # the tie
const LABEL := Color("fff6df")       # the round patch the picture sits on

static func make(pic: Texture2D, emoji := "", px := 44.0) -> Control:
	var b := Bag.new()
	b.name = "SeedBag"
	b.pic = pic
	b.custom_minimum_size = Vector2(px, px)
	b.size = Vector2(px, px)
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE      # a tap goes to the tile it sits in
	if pic == null and emoji != "":
		var l := Label.new()
		l.text = emoji
		l.add_theme_font_size_override("font_size", int(round(px * 0.34)))
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.size = Vector2(px, px * 0.5)
		l.position = Vector2(0, px * 0.64 - px * 0.25)
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(l)
	return b


class Bag extends Control:
	var pic: Texture2D

	func _draw() -> void:
		var s := minf(size.x, size.y)
		var line := maxf(2.0, s * 0.07)
		var body := _body(0.25, 0.62, 0.95, 0.13, 0.43)
		var ruffle := PackedVector2Array([Vector2(0.37, 0.27), Vector2(0.23, 0.09), Vector2(0.34, 0.10), Vector2(0.41, 0.03), Vector2(0.5, 0.13),
			Vector2(0.59, 0.03), Vector2(0.66, 0.10), Vector2(0.77, 0.09), Vector2(0.63, 0.27)])
		_poly(ruffle, CLOTH_DARK, s, line)
		_poly(body, CLOTH, s, line)
		# a soft shine on the left of the belly and a fold on the right
		_poly(PackedVector2Array([Vector2(0.22, 0.52), Vector2(0.27, 0.42), Vector2(0.31, 0.46), Vector2(0.27, 0.66), Vector2(0.23, 0.70)]), Color(1, 1, 1, 0.28), s, 0.0)
		draw_polyline(PackedVector2Array([Vector2(0.78, 0.47) * s, Vector2(0.81, 0.62) * s, Vector2(0.76, 0.78) * s]), Color(OUTLINE, 0.35), maxf(1.0, line * 0.4), true)
		# the tie: a cord round the neck and a small bow
		draw_line(Vector2(0.34, 0.27) * s, Vector2(0.66, 0.27) * s, OUTLINE, line * 1.9, true)
		draw_line(Vector2(0.34, 0.27) * s, Vector2(0.66, 0.27) * s, STRING, line * 0.9, true)
		for sx in [-1.0, 1.0]:
			_poly(PackedVector2Array([Vector2(0.5, 0.28), Vector2(0.5 + 0.11 * sx, 0.40), Vector2(0.5 + 0.04 * sx, 0.41)]), STRING, s, line * 0.6)
		# the round patch on the belly, and what is on it
		var c := Vector2(0.5, 0.65) * s
		draw_circle(c, 0.26 * s, LABEL)
		draw_arc(c, 0.26 * s, 0.0, TAU, 28, OUTLINE, maxf(1.5, line * 0.6), true)
		if pic != null:
			var box := 0.40 * s
			var k := minf(box / maxf(1.0, pic.get_width()), box / maxf(1.0, pic.get_height()))
			var sz := Vector2(pic.get_width(), pic.get_height()) * k
			draw_texture_rect(pic, Rect2(c - sz * 0.5, sz), false)

	## The body's outline from the neck down and round (left side, then right): a pouch widest low down, with a rounded bottom.
	func _body(neck_y: float, belly_y: float, bottom_y: float, neck_w: float, belly_w: float) -> PackedVector2Array:
		var left := PackedVector2Array()
		var right := PackedVector2Array()
		var steps := 14
		for i in range(steps + 1):
			var y := lerpf(neck_y, belly_y, float(i) / steps)
			var w := neck_w + (belly_w - neck_w) * sin(float(i) / steps * PI * 0.5)
			left.append(Vector2(0.5 - w, y))
			right.append(Vector2(0.5 + w, y))
		for i in range(1, steps + 1):
			var a := float(i) / steps * PI * 0.5
			var y := belly_y + (bottom_y - belly_y) * sin(a)
			var w := belly_w * cos(a)
			left.append(Vector2(0.5 - w, y))
			right.append(Vector2(0.5 + w, y))
		right.reverse()
		left.append_array(right)
		return left

	## A filled shape in the 0..1 box with the thick outline.
	func _poly(pts: PackedVector2Array, fill: Color, s: float, line: float) -> void:
		var p := PackedVector2Array()
		for v in pts: p.append(v * s)
		draw_colored_polygon(p, fill)
		if line > 0.0:
			p.append(p[0])
			draw_polyline(p, OUTLINE, line, true)
