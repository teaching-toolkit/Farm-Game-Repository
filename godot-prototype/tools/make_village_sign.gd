extends SceneTree
## Makes assets/map/village_sign.png: the blank wooden signpost (assets/deco/signpost.png) with a painted arrow on its board.
## The arrow points along the board's long side, which runs down to the right, like the village road on the map
## (data/map_layout.json: ground.road runs from the top of the farm down to the right edge, where the village is).
## It is the picture of the market place (places.json "placeArt"), the spot where the player starts a trip.
##
## Run from godot-prototype/ (headless; needs no Python, Pillow or numpy; run it again to redo the picture):
##   godot --headless --path . --script res://tools/make_village_sign.gd
## Reads  assets/deco/signpost.png  (never changed), writes  assets/map/village_sign.png  (the old assets/map/market.png is not touched).
## Then import once (godot --headless --path . --import).
##
## How it is drawn: the board's face is a four-cornered patch of the picture (the corners are measured on signpost.png).
## The arrow is made in "board space" (a along the board, b across it, in about picture pixels), rounded like the
## game's other pictures, with a dark brown outline (the board's own outline colour), a cream fill (the colour of the paper on
## map/field.png) and a darker cream rim on its lower right side, and pasted onto the board with a smooth edge.

const SRC := "res://assets/deco/signpost.png"
const OUT := "res://assets/map/village_sign.png"

# the board's face in signpost.png (pixels): top left, top right, bottom right, bottom left
const TL := Vector2(19, 42)
const TR := Vector2(257, 154)
const BR := Vector2(267, 324)
const BL := Vector2(22, 202)
const BOARD := Vector2(262, 165)        # the face in board space: length along the top edge, height down the side

const OUTLINE := Color("432016")        # the dark brown outline of the board
const FILL := Color("f6e6c4")           # cream paint
const SHADE := Color("e0c593")          # cream in shade (lower right rim of the arrow)
const OUTLINE_W := 6.0                  # the outline, in board pixels
const ROUND := 7.0                      # how round the arrow's corners are
const RIM := 4.5                        # width of the shaded rim

# the arrow in board space: it points to the right (towards bigger a)
const MID := 82.0                       # its middle line (b)
const SHAFT := Vector2(36.0, 150.0)     # shaft from a = x to a = y (the head covers its end)
const SHAFT_HALF := 19.0                # half the shaft's thickness
const HEAD_BASE := 134.0                # where the head's flat back is (a)
const HEAD_TIP := 234.0                 # the tip (a)
const HEAD_HALF := 59.0                 # half the head's height at its back

func _init() -> void:
	var img := Image.new()
	if img.load(SRC) != OK:
		push_error("cannot read " + SRC)
		quit(1)
		return
	if img.get_format() != Image.FORMAT_RGBA8: img.convert(Image.FORMAT_RGBA8)
	var head := _inset_triangle(Vector2(HEAD_BASE, MID - HEAD_HALF), Vector2(HEAD_BASE, MID + HEAD_HALF), Vector2(HEAD_TIP, MID), ROUND)
	var box_c := Vector2((SHAFT.x + SHAFT.y) / 2.0, MID)
	var box_h := Vector2((SHAFT.y - SHAFT.x) / 2.0 - ROUND, SHAFT_HALF - ROUND)
	var x0 := int(minf(TL.x, BL.x)) - 2
	var x1 := int(maxf(TR.x, BR.x)) + 2
	var y0 := int(minf(TL.y, TR.y)) - 2
	var y1 := int(maxf(BL.y, BR.y)) + 2
	var painted := 0
	for y in range(y0, y1):
		for x in range(x0, x1):
			var st := _to_board(Vector2(x + 0.5, y + 0.5))
			if st.x < -0.05 or st.x > 1.05 or st.y < -0.05 or st.y > 1.05: continue
			var p := Vector2(st.x * BOARD.x, st.y * BOARD.y)
			var d := _arrow(p, box_c, box_h, head)
			if d > OUTLINE_W + 1.0: continue
			var c := img.get_pixel(x, y)
			var out_a := clampf(0.5 - (d - OUTLINE_W), 0.0, 1.0)
			c = c.lerp(OUTLINE, out_a)
			var fill_a := clampf(0.5 - d, 0.0, 1.0)
			var rim := clampf(0.5 + _arrow(p + Vector2(RIM, RIM * 0.8), box_c, box_h, head), 0.0, 1.0)      # near the lower right edge
			c = c.lerp(FILL.lerp(SHADE, rim), fill_a)
			c.a = maxf(c.a, out_a)
			img.set_pixel(x, y, c)
			painted += 1
	var path := ProjectSettings.globalize_path(OUT)
	var err := img.save_png(path)
	print("village sign: %d pixels painted, saved %s (error code %d)" % [painted, path, err])
	quit(0 if err == OK else 1)

## Where a picture pixel is on the board: (s, t), both 0..1 across the face (inverse of the four corners, by Newton's method).
func _to_board(p: Vector2) -> Vector2:
	var st := Vector2(0.5, 0.5)
	for i in range(8):
		var f := _from_board(st) - p
		var ds := ((TR - TL) * (1.0 - st.y)) + ((BR - BL) * st.y)      # d point / d s
		var dt := ((BL - TL) * (1.0 - st.x)) + ((BR - TR) * st.x)      # d point / d t
		var det := ds.x * dt.y - ds.y * dt.x
		if absf(det) < 0.0001: break
		st -= Vector2((f.x * dt.y - f.y * dt.x) / det, (ds.x * f.y - ds.y * f.x) / det)
	return st

func _from_board(st: Vector2) -> Vector2:
	return TL * (1.0 - st.x) * (1.0 - st.y) + TR * st.x * (1.0 - st.y) + BR * st.x * st.y + BL * (1.0 - st.x) * st.y

# ---------------------------------------------------------------- shapes (signed distance: below 0 inside)

## The arrow: a rounded shaft and a rounded head.
func _arrow(p: Vector2, box_c: Vector2, box_h: Vector2, head: PackedVector2Array) -> float:
	var q := (p - box_c).abs() - box_h
	var shaft := Vector2(maxf(q.x, 0.0), maxf(q.y, 0.0)).length() + minf(maxf(q.x, q.y), 0.0) - ROUND
	return minf(shaft, _poly(p, head) - ROUND)

## Distance to a convex polygon (negative inside), corners in any order round.
func _poly(p: Vector2, v: PackedVector2Array) -> float:
	var best := INF
	var inside := true
	var turn := signf((v[1] - v[0]).cross(v[2] - v[1]))
	for i in range(v.size()):
		var a := v[i]
		var b := v[(i + 1) % v.size()]
		var ab := b - a
		var t := clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0)
		best = minf(best, p.distance_to(a + ab * t))
		if ab.cross(p - a) * turn < 0.0: inside = false
	return -best if inside else best

## A triangle moved inwards by r on every side (its corners are rounded again by r when drawn).
func _inset_triangle(a: Vector2, b: Vector2, c: Vector2, r: float) -> PackedVector2Array:
	var la := b.distance_to(c)
	var lb := a.distance_to(c)
	var lc := a.distance_to(b)
	var s := la + lb + lc
	var centre := (a * la + b * lb + c * lc) / s                     # the incentre
	var area := absf((b - a).cross(c - a)) / 2.0
	var k := (2.0 * area / s - r) / (2.0 * area / s)                 # (inradius - r) / inradius
	return PackedVector2Array([centre + (a - centre) * k, centre + (b - centre) * k, centre + (c - centre) * k])
