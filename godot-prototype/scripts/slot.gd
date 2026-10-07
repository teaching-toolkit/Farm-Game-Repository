extends Control
## One place on the farm map (a building, a pen, the market stall …), standing on its footprint.
## Position, footprint and picture width come from data/map_layout.json (change them with tools/layout-editor.html).
## The footprint is a diamond of a×b ground tiles; its front (lowest) corner is the place's "feet".
## The picture stands centred on the footprint with its bottom at the feet and may reach up over what is behind it.
## Only the visible part of the picture reacts to a tap; a flat place (a pen, the pond) reacts on its whole footprint.
##
## Without a picture a place is drawn from simple parts (style):
##   "pen"   a fence round the footprint and a ground (earth, grass, meadow); before it opens only broken posts and
##           patches of bare earth are left ("there used to be something here")
##   "ruin"  what is left of a building: the outline of its walls, a few broken wall pieces (stone or wood),
##           rocks or planks lying about, bare earth
##   "pond"  water: wild and overgrown, or dug out and clear
##   "ghost" nothing at all (the forest: its trees are the place) — only the badge shows
##   "fireplace" an old fire spot: a few blackened rocks round a burnt log (deco/old_fireplace.png when there is one)

signal tapped(spot_id: String)
signal ground_changed            # the bare earth under the place changed (the map draws it on the ground, under every fence)

const UI = preload("res://scripts/ui.gd")
const Art = preload("res://scripts/art.gd")
const LABEL_H := 24.0
## Pictures of flat places (pens, gardens) show the plot as a thick slab of earth: its top surface is the footprint,
## so the picture reaches this much of its width below the footprint's front corner.
const PLOT_DROP := 0.2
static var _images := {}   # texture -> Image, for tap tests

var spot_id := ""
var anchor := Vector2.ZERO   # the feet, in map coordinates
var pic_w := 150.0           # picture width in use (layout "w", or "ws" for the current picture)
var pic_h := 120.0
var base_w := 150.0
var widths := {}             # picture name -> width (layout "ws")
var foot := Vector2i(1, 1)
var tile := 88.0
var kind := "obj"            # obj | plot | sub
var locked := false
var style := ""              # "" (picture or emoji) | pen | ruin | pond | ghost
var look := {}               # pen: {fence, ground, dirt}; ruin: {material}; pond: {wild}
var inside: Array = []       # things drawn inside a pen, back to front: [{"tex": Texture2D, "emoji": String, "w": float}]
var show_name := false       # the name pill under the place (off: the pictures speak for themselves)
var overlays: Array = []     # pictures on top of the place's picture: [{"tex", "x", "y", "w"}] in fractions of it
var _over_nodes: Array = []

var pic: TextureRect
var emo: Label
var name_box: PanelContainer
var name_lbl: Label
var badge_box: PanelContainer
var badge_lbl: Label
var ring: Panel
var _img: Image
var _o := Vector2.ZERO       # the feet in this control's coordinates
var _press := Vector2.ZERO
var _pressing := false
var _pulse: Tween
var _has_pic := false
var earth_share := 0.0       # share of the footprint's tiles that are bare earth (drawn by the map on the ground)
var earth_salt := 1
var front: Control           # a pen's front fence: the map puts it among the standing things, so animals and huts are behind it

func setup(id: String, feet: Vector2, width: float, foot_tiles := Vector2i(1, 1), tile_w := 88.0, k := "obj", ws := {}) -> void:
	spot_id = id
	anchor = feet
	base_w = width
	pic_w = width
	foot = foot_tiles
	tile = tile_w
	kind = k
	widths = ws
	front = FrontLayer.new()
	front.slot = self
	front.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	ring = Panel.new()
	ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var rs := StyleBoxFlat.new()
	rs.bg_color = Color(1, 0.95, 0.5, 0.16)
	rs.border_color = Color(1, 0.85, 0.2, 0.95)
	rs.set_border_width_all(4)
	rs.set_corner_radius_all(22)
	ring.add_theme_stylebox_override("panel", rs)
	ring.visible = false
	add_child(ring)
	pic = TextureRect.new()
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_SCALE
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(pic)
	emo = UI.label("", 40)
	emo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	emo.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	emo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(emo)
	name_box = UI.pill("", 14)
	name_lbl = name_box.get_child(0)
	add_child(name_box)
	badge_box = UI.pill("", 18, Color(1, 1, 1, 0.95))
	badge_lbl = badge_box.get_child(0)
	badge_box.visible = false
	add_child(badge_box)

## Footprint corners relative to the feet: top, right, front (= the feet), left.
func foot_points() -> PackedVector2Array:
	var u := Vector2(tile / 2.0, tile / 4.0)
	var v := Vector2(-tile / 2.0, tile / 4.0)
	var top := -(u * foot.x + v * foot.y)
	return PackedVector2Array([top, top + u * foot.x, Vector2.ZERO, top + v * foot.y])

## Middle of the footprint relative to the feet.
func foot_center() -> Vector2:
	var p := foot_points()
	return (p[0] + p[2]) / 2.0

## A point on the footprint from tile coordinates (0..1 along each side), relative to the feet.
func foot_at(s: float, t: float) -> Vector2:
	var p := foot_points()
	return p[0] + (p[1] - p[0]) * s + (p[3] - p[0]) * t

## Called by the main screen whenever the game changes. pic_name picks the width from "ws" if it has one.
## st = style ("" = picture or emoji; see the top of this file), lk = its look.
func set_state(title: String, emoji: String, tex: Texture2D, is_locked: bool, badge := "", pic_name := "", st := "", lk := {}) -> void:
	locked = is_locked
	style = st if tex == null else ""
	look = lk
	pic_w = float(widths.get(pic_name, base_w)) if pic_name != "" else base_w
	pic.texture = tex
	_has_pic = tex != null
	pic.visible = _has_pic
	emo.visible = not _has_pic and style == ""
	emo.text = emoji
	if _has_pic:
		pic_h = pic_w * float(tex.get_height()) / float(tex.get_width())
		_img = _image_of(tex)
	else:
		pic_h = 0.0
		_img = null
	emo.modulate = Color(1, 1, 1, 0.5) if is_locked else Color.WHITE
	name_lbl.text = title
	name_box.visible = show_name and style != "ghost" and not is_locked
	badge_lbl.text = badge
	badge_box.visible = badge != ""
	var plan := _earth_plan()
	if plan[0] != earth_share or plan[1] != earth_salt:
		earth_share = plan[0]
		earth_salt = plan[1]
		ground_changed.emit()
	_place()

## How much bare earth lies on the footprint, and which pattern: [share, salt].
func _earth_plan() -> Array:
	if _has_pic: return [0.0, 0]
	match style:
		"pen":
			if locked: return [0.45, 1]
			var ground := str(look.get("ground", "grass"))
			if ground == "earth": return [float(look.get("dirt", 0.7)), 2]
			if ground == "meadow": return [0.0, 0]
			return [float(look.get("dirt", 0.3)), 2]
		"ruin": return [1.0 if bool(look.get("cleared", false)) else 0.8, 3]
		"pond", "ghost", "fireplace": return [0.0, 0]
	return [0.7, 4]

## The bare-earth tiles of this place: [texture, rect in map coordinates], one per footprint tile that is bare.
## They are a little bigger than a ground tile and lie on the grid, so neighbours join into one patch.
func earth_cells() -> Array:
	var out := []
	if earth_share <= 0.0: return out
	var tl := earth_tiles()
	if tl.is_empty(): return out
	var r := _rng(earth_salt + 40)
	for i in range(foot.x):
		for j in range(foot.y):
			var keep := r.randf() <= earth_share
			var t: Texture2D = tl[r.randi() % tl.size()]
			if not keep: continue
			var c := anchor + foot_at((i + 0.5) / foot.x, (j + 0.5) / foot.y)
			var w := tile * 1.12
			var h := w * float(t.get_height()) / float(t.get_width())
			out.append([t, Rect2(c - Vector2(w, h) / 2.0, Vector2(w, h))])
	return out

func _place() -> void:
	var fp := foot_points()
	var fc := foot_center()
	var ns := name_box.get_combined_minimum_size()
	var bs := badge_box.get_combined_minimum_size()
	# bounding box of footprint, picture and label, relative to the feet
	var fr := Rect2(Vector2(fp[3].x, fp[0].y), Vector2(fp[1].x - fp[3].x, -fp[0].y))
	var r := fr.grow_individual(0, 26, 0, 4)        # fence posts and wall pieces reach up a little
	var drop := pic_w * PLOT_DROP if kind == "plot" else 0.0
	var pr := Rect2(fc.x - pic_w / 2.0, -pic_h + drop, pic_w, pic_h)
	if _has_pic: r = r.merge(pr)
	var er := Rect2(fc.x - 40.0, fc.y - 62.0, 80.0, 72.0)    # emoji standing on the footprint
	if emo.visible: r = r.merge(er)
	var nr := Rect2(fc.x - ns.x / 2.0, 3.0 + (drop * 0.75 if _has_pic else 0.0), ns.x, ns.y)
	if name_box.visible: r = r.merge(nr)
	_o = -r.position
	position = anchor - _o
	size = r.size
	pivot_offset = _o
	pic.position = _o + pr.position
	pic.size = pr.size
	var fs := int(clampf(tile * (foot.x + foot.y) * 0.16, 26, 56))
	emo.add_theme_font_size_override("font_size", fs)
	emo.position = _o + er.position
	emo.size = er.size
	name_box.size = ns
	name_box.position = _o + nr.position
	var hr := pr if _has_pic else (er if emo.visible else fr.grow_individual(0, 16, 0, 0))
	_place_overlays()
	ring.position = _o + hr.position - Vector2(8, 8)
	ring.size = hr.size + Vector2(16, 16)
	badge_box.size = bs
	var bpos := Vector2(hr.end.x - bs.x * 0.7, hr.position.y - bs.y * 0.3)
	if style in ["pen", "pond", "ghost"]: bpos = fc + Vector2(-bs.x / 2.0, -bs.y)     # a sign in the middle of the pen
	badge_box.position = _o + bpos
	queue_redraw()
	if front:
		front.position = position
		front.size = size
		front.queue_redraw()

## Puts the overlay pictures (tools on the workbench …) on top of the place's picture.
func _place_overlays() -> void:
	for nd in _over_nodes: nd.queue_free()
	_over_nodes.clear()
	if not _has_pic: return
	for o in overlays:
		var t: Texture2D = o["tex"]
		var tr := TextureRect.new()
		tr.texture = t
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_SCALE
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var w: float = float(o["w"]) * pic.size.x
		var h := w * float(t.get_height()) / float(t.get_width())
		tr.size = Vector2(w, h)
		tr.position = pic.position + Vector2(float(o["x"]) * pic.size.x, float(o["y"]) * pic.size.y) - Vector2(w, h) / 2.0
		add_child(tr)
		move_child(tr, pic.get_index() + 1)
		_over_nodes.append(tr)

# ------------------------------------------------------------------ drawing without a picture
func _draw() -> void:
	if _has_pic: return
	match style:
		"pen": _draw_pen()
		"ruin": _draw_ruin()
		"pond": _draw_pond()
		"fireplace": _draw_fireplace()
		"ghost": pass
		_:
			# no picture yet: bare earth (drawn by the map on the ground); soft blobs when there are no earth pictures
			if earth_tiles().is_empty(): _earth(0.7, 4)

func _foot_poly(grow := 0.0) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var c := foot_center()
	for p in foot_points(): pts.append(p + (p - c).normalized() * grow + _o)
	return pts

## A random generator that gives the same numbers for this place every time (things don't jump around).
func _rng(salt := 0) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = hash(spot_id) + salt * 7919
	return r

static var _earth_tex: Array = []

## The bare-earth tile pictures there are (assets/ground/earth_1.png … earth_9.png).
static func earth_tiles() -> Array:
	if _earth_tex.is_empty():
		for i in range(1, 13):
			var t: Texture2D = Art.tex("ground", "earth_%d" % i)
			if t: _earth_tex.append(t)
		if _earth_tex.is_empty(): _earth_tex.append(null)
	return _earth_tex.filter(func(t): return t != null)

## Bare earth on about `share` of the footprint's tiles: a flat earth tile (several kinds, soft grassy edges) on each,
## or soft blobs when there are no tile pictures.
func _earth(share: float, salt := 1) -> void:
	var tl := earth_tiles()
	if tl.is_empty():
		_dirt(int(ceil(foot.x * foot.y * share * 1.3)), Art.tex("tiles", "path"), Color(0.86, 0.76, 0.62, 1.0), 0.5, salt)
		return
	var r := _rng(salt + 40)
	for i in range(foot.x):
		for j in range(foot.y):
			if r.randf() > share: continue
			var t: Texture2D = tl[r.randi() % tl.size()]
			# bigger than a tile and a little off the grid: the soft-edged tiles run into each other as patches, not a floor
			var c := foot_at((i + 0.5) / foot.x, (j + 0.5) / foot.y) + _o + Vector2(r.randf_range(-0.22, 0.22), r.randf_range(-0.11, 0.11)) * tile
			var w := tile * r.randf_range(1.35, 1.7)
			var h := w * float(t.get_height()) / float(t.get_width())
			draw_texture_rect(t, Rect2(c - Vector2(w, h) / 2.0, Vector2(w, h)), false)

## Soft patches of bare earth: n blobs, each a few rings that fade towards the edge.
func _dirt(n: int, tex: Texture2D, col: Color, size_tiles := 0.55, salt := 1) -> void:
	var r := _rng(salt)
	for _i in range(n):
		var c := foot_at(r.randf_range(0.12, 0.88), r.randf_range(0.12, 0.88)) + _o
		var rx := tile * size_tiles * r.randf_range(0.6, 1.25)
		var ph := r.randf() * TAU
		for ring_i in range(5):
			var k := 1.0 - ring_i * 0.12
			var pts := PackedVector2Array()
			var uvs := PackedVector2Array()
			for j in range(14):
				var a := TAU * j / 14.0
				var w := 1.0 + 0.2 * sin(a * 3.0 + ph) + 0.1 * sin(a * 5.0 - ph)
				var p := c + Vector2(cos(a) * rx, sin(a) * rx * 0.5) * w * k
				pts.append(p)
				if tex: uvs.append((p + position) / Vector2(tex.get_width(), tex.get_height()))
			var cc := Color(col.r, col.g, col.b, col.a * 0.2)
			if tex: draw_polygon(pts, PackedColorArray([cc]), uvs, tex)
			else: draw_colored_polygon(pts, cc)

## Fence or wall sides along the footprint. front = the two sides facing the viewer. keep(i) decides which pieces stand.
func _sides(tex: Texture2D, fallback: Array, front_sides: bool, keep: Callable, posts := true, remnants := false, ci: CanvasItem = null) -> void:
	if ci == null: ci = self
	var fp := foot_points()
	var sides := [[fp[3], fp[2], foot.x], [fp[2], fp[1], foot.y]] if front_sides else [[fp[3], fp[0], foot.y], [fp[0], fp[1], foot.x]]
	var idx := 0 if not front_sides else 100
	for sd in sides:
		var n := maxi(1, int(round(float(sd[2]) / 2.0)))
		for i in range(n):
			idx += 1
			if not keep.call(idx): continue
			var a: Vector2 = (sd[0] as Vector2).lerp(sd[1], float(i) / n) + _o
			var b: Vector2 = (sd[0] as Vector2).lerp(sd[1], float(i + 1) / n) + _o
			if remnants:
				# what is left of an old fence: a broken piece (one of several pictures) or a lone post
				var hv := absi(hash(spot_id + "r" + str(idx)))
				if hv % 3 == 0:
					var post: Texture2D = Art.first("deco", ["post_%d" % (1 + hv % 4), "post_1", "fence_stick"])
					if post:
						var pw := tile * 0.16
						var ph := pw * float(post.get_height()) / float(post.get_width())
						var at: Vector2 = a.lerp(b, 0.3 + float(hv % 5) * 0.1)
						ci.draw_texture_rect(post, Rect2(at - Vector2(pw / 2.0, ph * 0.92), Vector2(pw, ph)), false)
						continue
				var vt: Texture2D = Art.first("fences", ["stick_broken_%d" % (1 + hv % 3), "stick_broken"])
				UI.iso_side(ci, a, b, vt, fallback, posts)
			else:
				UI.iso_side(ci, a, b, tex, fallback, posts)

func _draw_pen() -> void:
	var open := not locked
	var ground := str(look.get("ground", "grass"))
	var tiles := foot.x * foot.y
	var soft := earth_tiles().is_empty()      # no earth pictures: soft blobs drawn here (else the map draws the earth)
	if open:
		match ground:
			"earth":
				if soft: _earth(float(look.get("dirt", 0.7)), 2)
			"meadow":
				draw_colored_polygon(_foot_poly(), Color(0.35, 0.6, 0.2, 0.10))
				_flowers(tiles * 9)
			_:
				draw_colored_polygon(_foot_poly(), Color(0.25, 0.5, 0.12, 0.10))
				if soft: _earth(float(look.get("dirt", 0.3)), 2)
	else:
		# what is left: patches of bare earth, a few lone posts and broken pieces
		if soft: _earth(0.45, 1)
		_tufts(tiles * 2)
	var pf := _pen_fence()
	if pf[3]: _sides(pf[0], pf[1], false, pf[2], true, not open)
	_draw_inside()
	# the front sides are drawn by the front layer (in front of the animals and what stands inside)

## The pen's fence: [picture, look without picture, which pieces stand, is there a fence at all].
func _pen_fence() -> Array:
	var open := not locked
	var fence := str(look.get("fence", "stick_fence"))
	var ftex: Texture2D = null
	var flook := [Color("8a6239"), 3.0]
	var keep := func(_i): return true
	if fence != "" and open:
		ftex = Art.tex("fences", fence)
	elif not open:
		flook = [Color("7a5a3a"), 2.5]
		keep = func(i): return (hash(spot_id + str(i)) % 4) == 0     # only a few pieces still stand
	return [ftex, flook, keep, fence != "" or not open]

## Drawn by the front layer: the fence sides facing the viewer.
func _draw_front(ci: CanvasItem) -> void:
	if _has_pic or style != "pen": return
	var pf := _pen_fence()
	if pf[3]: _sides(pf[0], pf[1], true, pf[2], true, locked, ci)

func _draw_ruin() -> void:
	var mat := str(look.get("material", "stone"))
	var stone := mat == "stone"
	var prog := clampf(float(look.get("progress", 0.0)), 0.0, 1.0)     # how much of it has been cleared away
	if earth_tiles().is_empty(): _earth(0.75, 3)
	if bool(look.get("cleared", false)): return                         # cleared: bare earth, ready to build on
	if stone and Art.tex("ruins", "half_wall") != null:
		_stone_ruin(prog)
		return
	# broken wall pieces: a picture from assets/ruins/ if there is one, else the broken fences and walls
	var wtex: Texture2D = Art.first("ruins", [mat + "_wall"])
	if wtex == null: wtex = Art.tex("fences", "stone_broken" if stone else "picket_broken")
	var wlook := [Color("9a9a92"), 6.0] if stone else [Color("8a6239"), 4.0]
	var keep := func(i): return ((hash(spot_id + "w" + str(i)) % 2) == 0 or foot.x + foot.y <= 2) and float(absi(hash(spot_id + "c" + str(i))) % 100) / 100.0 >= prog
	_sides(wtex, wlook, false, keep)
	# rocks or planks lying about (fewer as it is cleared)
	var r := _rng(5)
	var pieces := ["rubble", "debris_1", "debris_2", "debris_3", "stone"] if stone else ["planks", "debris_4", "debris_5", "fence_stick"]
	var n := int(round((2 + (foot.x + foot.y) / 2) * (1.0 - prog)))
	for i in range(n):
		var at := foot_at(r.randf_range(0.2, 0.8), r.randf_range(0.2, 0.8)) + _o
		var w := tile * r.randf_range(0.18, 0.28)
		var piece: Texture2D = Art.first("deco", [pieces[i % pieces.size()], pieces[0], "stone"])
		if piece:
			var h := w * float(piece.get_height()) / float(piece.get_width())
			draw_texture_rect(piece, Rect2(at - Vector2(w / 2.0, h), Vector2(w, h)), false, Color(0.92, 0.9, 0.86))
		else:
			draw_circle(at, w * 0.22, Color("8f8f86") if stone else Color("7a5230"))
	_sides(wtex, wlook, true, keep)

## An old stone building: one half-standing wall at the back, and loose rocks lying roughly along where the walls were.
## Every clearing step takes some of them away.
func _stone_ruin(prog: float) -> void:
	var r := _rng(21)
	var rocks := []
	for key in [["ruins", "rocks"], ["ruins", "block"], ["deco", "debris_1"], ["deco", "debris_2"], ["deco", "debris_3"]]:
		var t: Texture2D = Art.tex(key[0], key[1])
		if t: rocks.append(t)
	var fp := foot_points()
	var things := []      # [feet, texture, width]
	if not rocks.is_empty():
		for e in [[fp[3], fp[0]], [fp[0], fp[1]], [fp[3], fp[2]], [fp[2], fp[1]]]:
			var a: Vector2 = e[0]
			var b: Vector2 = e[1]
			var n := maxi(2, int(ceil(a.distance_to(b) / (tile * 0.3))))
			for i in range(n):
				var gone := r.randf() < 0.3 + prog * 0.65
				var at := a.lerp(b, (i + 0.5) / n) + Vector2(r.randf_range(-6, 6), r.randf_range(-3, 3))
				var t2: Texture2D = rocks[r.randi() % rocks.size()]
				var w := tile * r.randf_range(0.15, 0.24)
				if not gone: things.append([at, t2, w])
	var wall: Texture2D = Art.tex("ruins", "half_wall")
	if prog < 0.75:
		things.append([foot_at(0.32, 0.32), wall, tile * minf(foot.x, foot.y) * 0.62])
	things.sort_custom(func(x, y): return (x[0] as Vector2).y < (y[0] as Vector2).y)
	for th in things:
		var tex: Texture2D = th[1]
		var w2: float = th[2]
		var h := w2 * float(tex.get_height()) / float(tex.get_width())
		draw_texture_rect(tex, Rect2(th[0] + _o - Vector2(w2 / 2.0, h * 0.9), Vector2(w2, h)), false)

## An old fire spot on the grass: a picture (deco/old_fireplace) or a ring of blackened rocks, a little ash and a burnt log.
func _draw_fireplace() -> void:
	var c := foot_center() + _o + Vector2(0, tile * 0.06)
	var pic_t: Texture2D = Art.tex("deco", "old_fireplace")
	if pic_t != null:
		var w := tile * 0.95
		var h := w * float(pic_t.get_height()) / float(pic_t.get_width())
		draw_texture_rect(pic_t, Rect2(c - Vector2(w / 2.0, h * 0.62), Vector2(w, h)), false)
		return
	var rx := tile * 0.3
	var ry := rx * 0.5
	var ash := PackedVector2Array()
	for j in range(16): ash.append(c + Vector2(cos(TAU * j / 16.0) * rx * 0.72, sin(TAU * j / 16.0) * ry * 0.72))
	draw_colored_polygon(ash, Color(0.42, 0.4, 0.38, 0.75))
	var rock: Texture2D = Art.tex("deco", "stone")
	var r := _rng(33)
	var back := []
	var front := []
	for j in range(7):
		var a := TAU * (j + r.randf_range(-0.2, 0.2)) / 7.0
		var p := c + Vector2(cos(a) * rx, sin(a) * ry)
		if p.y <= c.y: back.append(p)
		else: front.append(p)
	back.sort_custom(func(x, y): return (x as Vector2).y < (y as Vector2).y)
	front.sort_custom(func(x, y): return (x as Vector2).y < (y as Vector2).y)
	for p in back: _fire_rock(p, rock, r)
	# the burnt log: charred wood, its cut end still brown
	draw_set_transform(c + Vector2(0, -2), -0.35, Vector2.ONE)
	var lw := tile * 0.36
	var lh := tile * 0.085
	draw_rect(Rect2(-lw / 2.0, -lh / 2.0, lw, lh), Color("3b2a20"))
	draw_rect(Rect2(-lw / 2.0, -lh / 2.0, lw * 0.4, lh), Color("1d1714"))
	draw_circle(Vector2(lw / 2.0, 0), lh * 0.5, Color("6b4a33"))
	draw_circle(Vector2(lw / 2.0, 0), lh * 0.28, Color("4a3424"))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	for p in front: _fire_rock(p, rock, r)

func _fire_rock(p: Vector2, rock: Texture2D, r: RandomNumberGenerator) -> void:
	var w := tile * r.randf_range(0.11, 0.15)
	if rock != null:
		var h := w * float(rock.get_height()) / float(rock.get_width())
		draw_texture_rect(rock, Rect2(p - Vector2(w / 2.0, h * 0.8), Vector2(w, h)), false, Color(0.55, 0.52, 0.5))
	else:
		draw_circle(p, w * 0.45, Color("5f5a55"))

func _draw_pond() -> void:
	var wild := bool(look.get("wild", true))
	var c := foot_center() + _o
	var hw := tile * (foot.x + foot.y) / 4.0 * 0.86
	var r := _rng(9)
	var pts := PackedVector2Array()
	var ph := r.randf() * TAU
	var shrink := 0.78 if wild else 0.95
	for j in range(20):
		var a := TAU * j / 20.0
		var w := (1.0 + 0.12 * sin(a * 3.0 + ph) + 0.06 * sin(a * 7.0)) * shrink
		pts.append(c + Vector2(cos(a) * hw, sin(a) * hw * 0.5) * w)
	var rim := PackedVector2Array()
	for p in pts: rim.append(c + (p - c) * 1.12)
	draw_colored_polygon(rim, Color(0.45, 0.36, 0.22, 0.55) if wild else Color(0.62, 0.6, 0.55, 0.9))
	draw_colored_polygon(pts, Color(0.33, 0.43, 0.3) if wild else Color(0.36, 0.62, 0.85))
	var inner := PackedVector2Array()
	for p in pts: inner.append(c + (p - c) * 0.6 + Vector2(0, -3))
	draw_colored_polygon(inner, Color(1, 1, 1, 0.08 if wild else 0.18))
	if wild:
		# duckweed, lily pads and reeds all round: nobody has looked after it for years
		for _i in range(7):
			var lp := c + Vector2(r.randf_range(-0.6, 0.6) * hw, r.randf_range(-0.25, 0.25) * hw)
			draw_circle(lp, r.randf_range(3.0, 6.0), Color(0.42, 0.58, 0.25, 0.9))
		for j in range(0, 20, 2):
			var base := c + (pts[j] - c) * 1.05
			for k in range(3):
				var x := base + Vector2(k * 4.0 - 4.0, 0)
				draw_line(x, x + Vector2(r.randf_range(-3, 3), -r.randf_range(10, 18)), Color(0.24, 0.42, 0.16), 2.0)
	_draw_inside()

func _flowers(n: int) -> void:
	var r := _rng(11)
	var cols := [Color("fff7e8"), Color("f6d34a"), Color("e98bb8"), Color("a98be0")]
	for _i in range(n):
		var at := foot_at(r.randf_range(0.06, 0.94), r.randf_range(0.06, 0.94)) + _o
		draw_circle(at, r.randf_range(1.6, 2.8), cols[r.randi() % cols.size()])

func _tufts(n: int) -> void:
	var r := _rng(13)
	for _i in range(n):
		var at := foot_at(r.randf_range(0.08, 0.92), r.randf_range(0.08, 0.92)) + _o
		for k in range(3):
			draw_line(at + Vector2(k * 3.0 - 3.0, 0), at + Vector2(k * 4.0 - 4.0, -r.randf_range(5, 9)), Color(0.27, 0.45, 0.16, 0.8), 1.6)

## Things inside a pen or garden (orchard trees …), on a grid, back to front.
func _draw_inside() -> void:
	if inside.is_empty(): return
	var n := inside.size()
	var cols := int(ceil(sqrt(float(n))))
	var rows := int(ceil(float(n) / cols))
	for i in range(n):
		var e: Dictionary = inside[i]
		var at := foot_at((i % cols + 0.5) / cols, (i / cols + 0.5) / rows) + _o
		var w := float(e.get("w", tile * 0.5))
		var t: Texture2D = e.get("tex")
		if e.get("hole", false):
			var pts := PackedVector2Array()
			for j in range(12): pts.append(at + Vector2(cos(TAU * j / 12.0) * w * 0.4, sin(TAU * j / 12.0) * w * 0.2))
			draw_colored_polygon(pts, Color(0.45, 0.33, 0.2, 0.7))
		elif t:
			var h := w * float(t.get_height()) / float(t.get_width())
			draw_texture_rect(t, Rect2(at - Vector2(w / 2.0, h), Vector2(w, h)), false)
		elif str(e.get("emoji", "")) != "":
			var f: Font = get_theme_font("font", "Label")
			var fs := int(w * 0.6)
			draw_string(f, at - Vector2(fs * 0.6, 0), str(e["emoji"]), HORIZONTAL_ALIGNMENT_LEFT, -1, fs)

## A pen's front fence, drawn among the standing things (sorted by its front corner) so what is inside stays behind it.
class FrontLayer extends Control:
	var slot

	func _draw() -> void:
		if slot != null and is_instance_valid(slot) and slot.visible: slot._draw_front(self)


static func _image_of(tex: Texture2D) -> Image:
	var key := tex.get_rid()
	if not _images.has(key):
		var im := tex.get_image()
		if im and im.is_compressed(): im.decompress()
		_images[key] = im
	return _images[key]

## Is p (this control's coordinates) on the footprint? Tested in tile coordinates, so a×b footprints work too.
func _in_foot(p: Vector2) -> bool:
	var fp := foot_points()
	var u := Vector2(tile / 2.0, tile / 4.0)
	var v := Vector2(-tile / 2.0, tile / 4.0)
	var q := p - _o - fp[0]
	var det := u.x * v.y - u.y * v.x
	var i := (q.x * v.y - q.y * v.x) / det
	var j := (u.x * q.y - u.y * q.x) / det
	return i >= 0.0 and j >= 0.0 and i <= foot.x and j <= foot.y

## Taps count on the picture's visible pixels (not its see-through corners or its shadow) and on the name label;
## a flat place or one without a picture also on its footprint.
func _has_point(p: Vector2) -> bool:
	if name_box and name_box.visible and Rect2(name_box.position, name_box.size).has_point(p): return true
	if badge_box and badge_box.visible and Rect2(badge_box.position, badge_box.size).has_point(p): return true
	if kind == "plot" or not _has_pic:
		if _in_foot(p): return true
		if not _has_pic: return emo.visible and Rect2(emo.position, emo.size).has_point(p)
	if not Rect2(pic.position, pic.size).has_point(p): return false
	if _img == null: return true
	var lp := p - pic.position
	var uu := clampi(int(lp.x / pic.size.x * _img.get_width()), 0, _img.get_width() - 1)
	var vv := clampi(int(lp.y / pic.size.y * _img.get_height()), 0, _img.get_height() - 1)
	return _img.get_pixel(uu, vv).a > 0.6

## Where the place is on the map (picture and label), for scrolling to it.
func map_rect() -> Rect2:
	return Rect2(position, size)

## Where the place's middle is on the map (things fly to it).
func map_center() -> Vector2:
	if _has_pic: return position + pic.position + pic.size * Vector2(0.5, 0.55)
	return anchor + foot_center()

## A gentle glow and bounce that says "look here" (used by the next-goal bar).
func pulse(on := true) -> void:
	if ring == null: return
	if _pulse: _pulse.kill()
	ring.visible = on
	scale = Vector2.ONE
	if not on: return
	_pulse = create_tween().set_loops(4)
	_pulse.tween_property(self, "scale", Vector2(1.08, 1.08), 0.28)
	_pulse.tween_property(self, "scale", Vector2.ONE, 0.28)
	_pulse.finished.connect(func(): ring.visible = false)

## A quick bounce when something arrives (the store when harvested things fly in).
func bump() -> void:
	var tw := create_tween()
	tw.tween_property(self, "scale", Vector2(1.08, 0.94), 0.08)
	tw.tween_property(self, "scale", Vector2.ONE, 0.12)

func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		if e.pressed:
			_press = e.position
			_pressing = true
			scale = Vector2(0.96, 0.96)
		elif _pressing:
			_pressing = false
			scale = Vector2.ONE
			if e.position.distance_to(_press) < 16.0:
				tapped.emit(spot_id)
	elif e is InputEventMouseMotion and _pressing and e.position.distance_to(_press) >= 16.0:
		_pressing = false
		scale = Vector2.ONE

func _notification(what: int) -> void:
	if what == NOTIFICATION_SCROLL_BEGIN and _pressing:
		_pressing = false
		scale = Vector2.ONE
