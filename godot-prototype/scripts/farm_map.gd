extends Control
## The farm map on one screen, seen at an angle like Hay Day: grass, the forest coming in from one side and the
## village road from the other, three diamond fields, pens and gardens lying flat, and every building standing on
## its footprint. Lower things are drawn in front of higher ones. The whole farm (design size 834×1000) is scaled
## to fit the screen, so nothing needs scrolling.
## Positions and sizes come from data/map_layout.json — move things with tools/layout-editor.html.
## The forest and the road have no picture of their own: a tap on the trees opens the forest, a tap on the road the road.
## The road looks like what it is: a muddy track with puddles at first, then filled, gravel, cobbles, paved.

signal spot_tapped(spot_id: String)

const Art = preload("res://scripts/art.gd")
const UI = preload("res://scripts/ui.gd")
const Slot = preload("res://scripts/slot.gd")
const IsoField = preload("res://scripts/iso_field.gd")
const Avatar = preload("res://scripts/avatar.gd")
const Actor = preload("res://scripts/actor.gd")
const Fx = preload("res://scripts/fx.gd")
const LAYOUT_PATH := "res://data/map_layout.json"
const GRASS := {"spring": Color("9cc86a"), "summer": Color("b3c95c"), "autumn": Color("c4b46a"), "winter": Color("dfe8e6")}
const GRASS_TINT := {"spring": Color(1, 1, 1), "summer": Color(1.05, 1.03, 0.85), "autumn": Color(1.1, 0.95, 0.7), "winter": Color(0.95, 1.0, 1.08)}
const FENCES := [["", Color(0, 0, 0, 0), 0.0], ["stick_fence", Color("8a6239"), 3.0], ["wattle_fence", Color("9a7444"), 5.0],
	["picket_fence", Color("f4efe3"), 5.0], ["stone_wall", Color("9a9a92"), 8.0], ["hedge_row", Color("3f7a34"), 10.0]]
const EXTEND := 1500.0   # ground shapes that touch the edge continue beyond it (wide or tall screens)
const GRASS_SCALE := 0.5  # the grass picture is drawn at half its size (finer blades)

var L: Dictionary = {}
var design := Vector2(834, 1000)
var tile := 88.0            # ground tile (footprints of the places)
var patch := 144.0          # field patch width, and the gap between patches
var gap := 14.0
var board: Control          # the whole farm in design pixels, scaled to fit and centred
var flat: Control           # fields, pens and gardens (lie on the ground)
var objects: Control        # buildings, add-ons, decorations, scarecrow — sorted by their feet
var critter_layer: Control  # animals and pets walking around
var fx_layer: Control       # things flying to the store
var ground_tap: Control     # taps on the forest and the road
var road_level := 1.0
## Road tiles (assets/road/road_1 … road_9) for each road level: a mix of the two kinds of the level.
const ROAD_TILES := {1.0: [1, 2], 1.5: [2, 3], 2.0: [3, 4], 2.5: [4, 5], 3.0: [5, 6], 3.5: [6, 7], 4.0: [7, 8], 4.5: [8, 9], 5.0: [9]}
## Animal pictures that look to the left (the others look to the right): they are mirrored as they walk.
const FACES_LEFT := {"animal_chicken": true, "pet_bunny": false}
var cat: TextureRect          # the farm cat (from the side quest): walks about, chases pests, naps
var cat_emoji: Label
var _cat := {"state": "", "until": 0.0, "target": Vector2.ZERO, "frame": 0.0}
var _cat_sort := 0.0
var road_badge: PanelContainer
var avatar                    # the farmer: walks to wherever the player taps (scripts/avatar.gd)
var actor                     # … and acts out what the player did there (scripts/actor.gd, data/acts.json)
var perk_fx                   # butterflies, sparkles, rainbow, season breeze (fx.gd MapFx)
var astar := AStarGrid2D.new()
var _grid_sig := ""
const CELL := 16.0
var fields: Array = []      # IsoField per field (0 = Home Field)
var scarecrow: TextureRect
var scarecrow_emoji: Label
var pests_box: PanelContainer
var pest_lbl: Label
var slots := {}
var addon_nodes: Array = [] # [{"node", "sid", "id", "until"}]
var season := "spring"
var fence_level := 0
var usable_fields := 1
var house_built := false
var extra_bottom := 0.0
var view := Vector2.ZERO
var fit_scale := 1.0
var _critters := {}
var _crit_sig := {}
var _hop_t := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	_load_layout()
	board = _layer(self)
	board.size = design
	board.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	board.draw.connect(_draw_board)
	ground_tap = GroundTap.new()
	ground_tap.map = self
	ground_tap.size = design
	board.add_child(ground_tap)
	flat = _layer(board)
	objects = _layer(board)
	critter_layer = _layer(board)
	var flat_items := []
	var items := []
	# the fields: feet = front corner of a 3×3 diamond of patches with gaps
	var fl: Array = L.get("fields", [])
	for f in range(fl.size()):
		var fv = IsoField.new()
		fv.setup(patch, gap)
		fv.field_index = f
		fv.position = Vector2(float(fl[f]["x"]) - fv.size.x / 2.0, float(fl[f]["y"]) - fv.size.y)
		fields.append(fv)
		flat_items.append([float(fl[f]["y"]), fv])
	# places
	for sid in L["places"]:
		var p: Dictionary = L["places"][sid]
		var s = Slot.new()
		var ft: Array = p.get("foot", [1, 1])
		s.setup(sid, Vector2(float(p["x"]), float(p["y"])), float(p.get("w", 140)), Vector2i(int(ft[0]), int(ft[1])), tile,
			str(p.get("k", "obj")), p.get("ws", {}))
		s.tapped.connect(func(id): spot_tapped.emit(id))
		s.tapped.connect(_walk_to_spot)
		s.ground_changed.connect(board.queue_redraw)
		slots[sid] = s
		if str(p.get("k", "obj")) == "plot":
			flat_items.append([float(p["y"]), s])
			items.append([float(p["y"]) + 0.3, s.front])     # its front fence stands in front of what is inside
		else: items.append([float(p["y"]), s])
	# add-ons: things built on a place (a bigger chicken house, nest boxes, hives …)
	var ad: Dictionary = L.get("addons", {})
	for sid in ad:
		if not L["places"].has(sid): continue
		var pp: Dictionary = L["places"][sid]
		for a in ad[sid]:
			var feet := Vector2(float(pp["x"]) + float(a.get("dx", 0)), float(pp["y"]) + float(a.get("dy", 0)))
			var keys := [str(a.get("pic", a["id"])), str(a["id"])]
			var atex := Art.first("addons", keys)
			if atex == null: atex = Art.first("map", keys)
			var node := _standing(atex, feet, float(a.get("w", 50)))
			if node == null: continue    # no picture yet: the add-on only shows in the place's sheet
			node.visible = false
			addon_nodes.append({"node": node, "sid": sid, "id": str(a["id"]), "until": str(a.get("until", ""))})
			items.append([feet.y + 0.2, node])
	# decorations
	for d in L.get("deco", []):
		var node2 := _standing(Art.tex("deco", str(d["pic"])), Vector2(float(d["x"]), float(d["y"])), float(d.get("w", 60)))
		if node2: items.append([float(d["y"]), node2])
	# the scarecrow (one for all fields)
	var sc: Dictionary = L.get("scarecrow", {"x": 572, "y": 592, "w": 56})
	scarecrow = TextureRect.new()
	scarecrow.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	scarecrow.stretch_mode = TextureRect.STRETCH_SCALE
	scarecrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scarecrow.set_meta("feet", Vector2(float(sc["x"]), float(sc["y"])))
	scarecrow.set_meta("w", float(sc.get("w", 56)))
	items.append([float(sc["y"]), scarecrow])
	scarecrow_emoji = UI.label("", 36)
	scarecrow_emoji.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scarecrow_emoji.position = Vector2(float(sc["x"]) - 20, float(sc["y"]) - 48)
	items.append([float(sc["y"]) + 0.1, scarecrow_emoji])
	flat_items.sort_custom(func(a, b): return a[0] < b[0])
	for it in flat_items: flat.add_child(it[1])
	items.sort_custom(func(a, b): return a[0] < b[0])
	for it in items:
		it[1].set_meta("sy", it[0])
		objects.add_child(it[1])
	# how much the pests eat every question (a small sign by the fields: 🐦 6%)
	pests_box = UI.pill("", 15)
	pest_lbl = pests_box.get_child(0)
	pests_box.set_meta("at", Vector2(float(L.get("pests", {}).get("x", 417)), float(L.get("pests", {}).get("y", 640))))
	pests_box.visible = false
	board.add_child(pests_box)
	# a sign on the road when something can be done there (the road has no place of its own)
	road_badge = UI.pill("", 18, Color(1, 1, 1, 0.95))
	road_badge.visible = false
	board.add_child(road_badge)
	perk_fx = Fx.MapFx.new()
	perk_fx.size = design
	for fv in fields:
		perk_fx.areas.append(Rect2(fv.position + Vector2(fv.size.x * 0.15, fv.size.y * 0.1), fv.size * Vector2(0.7, 0.7)))
		fv.patch_pressed.connect(_walk_to_patch.bind(fv))
	board.add_child(perk_fx)
	fx_layer = _layer(board)
	# the farmer, in front of the house
	avatar = Avatar.new()
	avatar.map = self
	avatar.feet = Vector2(float(L.get("avatar", {}).get("x", 417)), float(L.get("avatar", {}).get("y", 262)))
	_sort_in(avatar, avatar.feet.y)
	actor = Actor.new()
	actor.avatar = avatar
	add_child(actor)
	resized.connect(_layout)
	_layout()

func _layer(parent: Control) -> Control:
	var c := Control.new()
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(c)
	return c

## A picture standing on its feet (or null without a texture).
func _standing(tex: Texture2D, feet: Vector2, w: float) -> TextureRect:
	if tex == null: return null
	var tr := TextureRect.new()
	tr.texture = tex
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_SCALE
	var h := w * float(tex.get_height()) / float(tex.get_width())
	tr.size = Vector2(w, h)
	tr.position = feet - Vector2(w / 2.0, h)
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return tr

func _load_layout() -> void:
	var txt := FileAccess.get_file_as_string(LAYOUT_PATH)
	var d = JSON.parse_string(txt) if txt != "" else null
	if typeof(d) != TYPE_DICTIONARY or int(d.get("version", 1)) < 2:
		push_warning(tr("map_layout.json missing, broken or old — using an empty farm"))
		d = {"version": 2, "size": {"w": 834, "h": 1000}, "tile": 88, "ground": {}, "fields": [{"x": 417, "y": 616}],
			"places": {}, "deco": []}
	L = d
	design = Vector2(float(L["size"]["w"]), float(L["size"]["h"]))
	tile = float(L.get("tile", 88))
	patch = float(L.get("field", {}).get("patch", 144))
	gap = float(L.get("field", {}).get("gap", 14))

# ------------------------------------------------------------------ fitting the screen
## The main screen tells the map how much room it has (the visible part of the scroll area).
func fit(view_size: Vector2) -> void:
	view = view_size
	_layout()

func _layout() -> void:
	var vw := view.x if view.x > 0.0 else maxf(size.x, design.x)
	var vh := view.y if view.y > 0.0 else design.y
	fit_scale = minf(vw / design.x, vh / design.y)
	board.scale = Vector2(fit_scale, fit_scale)
	board.position = Vector2(floorf((vw - design.x * fit_scale) / 2.0), floorf(maxf(0.0, (vh - design.y * fit_scale) / 2.0)))
	custom_minimum_size = Vector2(0, vh + extra_bottom)
	_layout_pill()
	queue_redraw()
	board.queue_redraw()

func set_extra_bottom(px: float) -> void:
	extra_bottom = px
	_layout()

## A rectangle in farm (design) coordinates → this map's coordinates.
func to_map(r: Rect2) -> Rect2:
	return Rect2(board.position + r.position * fit_scale, r.size * fit_scale)

## Rectangle of a place, in this map's coordinates (for scrolling to it when a sheet covers the bottom).
func spot_rect(sid: String) -> Rect2:
	var r := Rect2()
	if slots.has(sid) and slots[sid].visible: r = slots[sid].map_rect()
	if sid == "field" and fields.size() > 0:
		var fr := Rect2(fields[0].position, fields[0].size)
		r = fr.merge(r) if r.size != Vector2.ZERO else fr
	if sid == "road": r = _poly_rect(_road_band(), Rect2(Vector2.ZERO, design))
	if r.size == Vector2.ZERO: return r
	return to_map(r)

func _poly_rect(poly: PackedVector2Array, clip: Rect2) -> Rect2:
	if poly.is_empty(): return Rect2()
	var r := Rect2(poly[0], Vector2.ZERO)
	for p in poly: r = r.expand(p)
	return r.intersection(clip)

## Where a place's middle is, in farm (board) coordinates — things fly from and to it.
func spot_point(sid: String) -> Vector2:
	if slots.has(sid): return slots[sid].map_center()
	if sid == "road":
		var rd: Dictionary = L.get("ground", {}).get("road", {})
		if rd.has("points"):
			var pts := _pts(rd["points"])
			var a := pts[0].clamp(Vector2.ZERO, design)
			var b := pts[pts.size() - 1].clamp(Vector2.ZERO, design)
			return (a + b) / 2.0
	return design / 2.0

## Where the farmer stands to do something at a place: just in front of it.
func stand_point(sid: String) -> Vector2:
	if slots.has(sid): return slots[sid].anchor + Vector2(0, 14)
	return spot_point(sid)

## Middle of patch k of field f, in farm coordinates.
func patch_point(f: int, k: int) -> Vector2:
	if f < 0 or f >= fields.size(): return design / 2.0
	return fields[f].position + fields[f].patch_center(k)

## Lets things fly from one place to another in an arc, growing and then shrinking: one picture per piece
## (3 carrots harvested = 3 carrots flying). pieces = [[emoji, texture or null], …]. The target bounces when they land.
func fly(from: Vector2, to_sid: String, pieces: Array, bounce: Array = []) -> void:
	var to := spot_point(to_sid)
	var delay := 0.0
	var all := []
	for pc in pieces: all.append([pc, false])
	for pc in bounce: all.append([pc, true])
	for item in all:
		var pc: Array = item[0]
		var off: bool = item[1]
		var node: Control
		var tex: Texture2D = pc[1]
		if tex:
			var tr := TextureRect.new()
			tr.texture = tex
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr.size = Vector2(36, 36)
			node = tr
		else:
			node = UI.label(str(pc[0]), 26)
			node.size = Vector2(36, 36)
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
		node.pivot_offset = Vector2(18, 18)
		var start := from + Vector2(randf_range(-14, 14), randf_range(-10, 6))
		node.position = start - Vector2(18, 18)
		node.scale = Vector2(0.7, 0.7)
		node.modulate.a = 0.0
		fx_layer.add_child(node)
		var lift := maxf(110.0, start.distance_to(to) * 0.45)
		var ctrl := (start + to) / 2.0 + Vector2(randf_range(-30, 30), -lift)
		var tw := create_tween()
		tw.tween_interval(delay)
		tw.tween_property(node, "modulate:a", 1.0, 0.08)
		if off:
			# the store is full: it flies there, hits it and bounces off, spinning away
			tw.tween_method(_fly_step.bind(node, start, ctrl, to + Vector2(0, -26)), 0.0, 0.92, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			tw.tween_callback(_store_full.bind(to_sid))
			var away := to + Vector2(randf_range(60, 120) * (-1.0 if randf() < 0.5 else 1.0), -150)
			tw.tween_property(node, "position", away - Vector2(18, 18), 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tw.parallel().tween_property(node, "rotation", randf_range(-6.0, 6.0), 0.55)
			tw.tween_property(node, "position", away + Vector2(0, 160), 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			tw.parallel().tween_property(node, "modulate:a", 0.0, 0.45)
			tw.tween_callback(node.queue_free)
		else:
			tw.tween_method(_fly_step.bind(node, start, ctrl, to), 0.0, 1.0, 0.85).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tw.tween_callback(_landed.bind(node, to_sid))
		delay += 0.11

## The store shakes and shows that it is full.
func _store_full(sid: String) -> void:
	if not slots.has(sid): return
	var s = slots[sid]
	var tw := create_tween()
	var x0: float = s.position.x
	for k in [8.0, -8.0, 6.0, -6.0, 0.0]:
		tw.tween_property(s, "position:x", x0 + k, 0.05)
	var mark := UI.label("🚫", 30)
	mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mark.position = spot_point(sid) - Vector2(18, 70)
	fx_layer.add_child(mark)
	var tw2 := create_tween()
	tw2.tween_property(mark, "position:y", mark.position.y - 30, 0.8)
	tw2.parallel().tween_property(mark, "modulate:a", 0.0, 0.8)
	tw2.tween_callback(mark.queue_free)

func _fly_step(t: float, node: Control, a: Vector2, c: Vector2, b: Vector2) -> void:
	if not is_instance_valid(node): return
	var p := a.lerp(c, t).lerp(c.lerp(b, t), t)
	node.position = p - Vector2(18, 18)
	var s := 0.7 + 0.9 * sin(PI * minf(1.0, t * 1.15))      # grows on the way up, shrinks into the store
	if t > 0.85: s = lerpf(s, 0.35, (t - 0.85) / 0.15)
	node.scale = Vector2(s, s)

func _landed(node: Control, sid: String) -> void:
	if is_instance_valid(node): node.queue_free()
	if slots.has(sid) and slots[sid].visible: slots[sid].bump()

## Rectangle of one patch (field f, patch k), in this map's coordinates.
func patch_rect(f: int, k: int) -> Rect2:
	if f < 0 or f >= fields.size(): return Rect2()
	var r: Rect2 = fields[f].patch_rect(k)
	r.position += fields[f].position
	return to_map(r)

# ------------------------------------------------------------------ fields, scarecrow, add-ons
## Redraws the fields, the scarecrow and the pests (called by the main screen on every change).
func refresh_fields(G) -> void:
	usable_fields = maxi(1, int(ceilf(float(G.plots()) / 9.0)))
	var sid := ""
	var em := ""
	var level := 0
	for pair in [["scarecrow_4", "🎏", 4], ["scarecrow_3", "💂", 3], ["scarecrow_2", "🧑‍🌾", 2], ["scarecrow_1", "🧍", 1]]:
		if G.done(pair[0]) and sid == "":
			sid = pair[0]; em = pair[1]; level = pair[2]
	var tex: Texture2D = Art.first("map", [sid, "scarecrow_1"]) if sid != "" else null
	var feet: Vector2 = scarecrow.get_meta("feet")
	var w: float = scarecrow.get_meta("w")
	scarecrow.texture = tex
	scarecrow.visible = tex != null
	scarecrow_emoji.text = em if tex == null else ""
	var h := w * 1.3
	if tex:
		h = w * float(tex.get_height()) / float(tex.get_width())
		scarecrow.size = Vector2(w, h)
		scarecrow.position = feet - Vector2(w / 2.0, h)
	# pests are shared out over the fields that have something growing
	var growing := []
	var total := 0
	for fv in fields:
		var n: int = fv.growing_count()
		growing.append(n)
		total += n
	for f in range(fields.size()):
		var fv = fields[f]
		fv.pest_share = float(growing[f]) / float(total) if total > 0 else 0.0
		fv.has_scarecrow = sid != ""
		fv.scare_level = level
		fv.scare_from = feet - Vector2(0, h * 0.75) - fv.position
		fv.refresh()
	var share: float = G.pest_eat_share()
	var any_growing := total > 0
	pests_box.visible = any_growing and share >= 0.005
	pest_lbl.text = "🐦 %d%%" % int(round(share * 100.0))
	pests_box.tooltip_text = tr("Pests eat about this much of what is growing, every question.")
	_layout_pill()
	var rl := snappedf(G.g("roadLevel", 1.0), 0.5)
	if rl != road_level:
		road_level = rl
	board.queue_redraw()

func set_road_badge(text: String) -> void:
	road_badge.get_child(0).text = text
	road_badge.visible = text != ""
	var s := road_badge.get_combined_minimum_size()
	road_badge.size = s
	road_badge.position = spot_point("road") - s / 2.0

func _layout_pill() -> void:
	var at: Vector2 = pests_box.get_meta("at")
	var ps := pests_box.get_combined_minimum_size()
	pests_box.size = ps
	pests_box.position = at - Vector2(ps.x / 2.0, 0)

## What happened while a pop-up was open (pests eating) plays when the farm is visible again.
func play_pending() -> void:
	for fv in fields: fv.play_pending()

## Shows the add-ons that are built (and not replaced by a newer one).
func refresh_addons(G) -> void:
	for a in addon_nodes:
		var id: String = a["id"]
		var on: bool = G.nodes.has(id) and G.done(id) and not G.superseded(id)
		if on and a["until"] != "" and G.nodes.has(a["until"]) and G.satisfied(a["until"]): on = false
		a["node"].visible = on

func set_house_built(b: bool) -> void:
	if b != house_built:
		house_built = b
		board.queue_redraw()

# ------------------------------------------------------------------ ground
func _draw() -> void:
	# grass everywhere (also around the farm on screens with another shape)
	var full := Rect2(Vector2.ZERO, size)
	var grass_tex := Art.tex("tiles", "grass")
	var tint: Color = GRASS_TINT.get(season, Color.WHITE)
	if grass_tex:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(GRASS_SCALE, GRASS_SCALE))
		draw_texture_rect(grass_tex, Rect2(Vector2.ZERO, size / GRASS_SCALE), true, tint)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		# (the soft patches of the other grass pictures lie on the farm itself, see _draw_board: they must not move)
	else:
		draw_rect(full, GRASS.get(season, GRASS["spring"]))
	if season == "winter":
		draw_rect(full, Color(1, 1, 1, 0.12))

## A soft round patch of another grass picture on the background (fading towards its edge).
func _grass_blob(c: Vector2, rad: float, tex: Texture2D, tint: Color) -> void:
	var ts := Vector2(tex.get_width(), tex.get_height()) * GRASS_SCALE
	for ring in range(7):
		var k := 1.0 - ring * 0.12
		var pts := PackedVector2Array()
		var uvs := PackedVector2Array()
		for j in range(24):
			var a := TAU * j / 24.0
			var p := c + Vector2(cos(a), sin(a) * 0.6) * rad * k * (1.0 + 0.12 * sin(a * 3.0 + c.x))
			pts.append(p)
			uvs.append(p / ts)
		board.draw_polygon(pts, PackedColorArray([Color(tint.r, tint.g, tint.b, 0.1)]), uvs, tex)

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
		var p := Vector2(r.randf_range(-20, design.x + 20), r.randf_range(-10, design.y + 30))
		var t: Texture2D = bits[r.randi() % bits.size()]
		if fp.size() >= 3 and Geometry2D.is_point_in_polygon(p, fp): continue
		var w := r.randf_range(18, 34)
		var h := w * float(t.get_height()) / float(t.get_width())
		board.draw_texture_rect(t, Rect2(p - Vector2(w / 2.0, h), Vector2(w, h)), false)

## Ground shapes in farm coordinates: forest, road, the house yard, shadows and fences of the fields.
func _draw_board() -> void:
	var gr: Dictionary = L.get("ground", {})
	var tint: Color = GRASS_TINT.get(season, Color.WHITE)
	# soft patches of the other grass pictures, so the meadow is not the same everywhere (fixed places on the farm)
	var r := RandomNumberGenerator.new()
	r.seed = 31
	for gi in range(2, 5):
		var gt: Texture2D = Art.tex("tiles", "grass_%d" % gi)
		if gt == null: continue
		for _k in range(7):
			_grass_blob(Vector2(r.randf() * design.x, r.randf() * design.y), r.randf_range(80, 170), gt, tint)
	# the forest has no floor of its own: its trees stand on the meadow (forest_poly is still where taps open the forest)
	_draw_grass_bits()
	# the village road: a band along a line, as good as it has been made
	_draw_road()
	# the house yard (until the house is built): packed earth on the house's footprint
	if not house_built and slots.has("home"):
		var hs = slots["home"]
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
					var tw2: float = tile * 1.12
					var th: float = tw2 * float(t.get_height()) / float(t.get_width())
					board.draw_texture_rect(t, Rect2(c2 - Vector2(tw2, th) / 2.0, Vector2(tw2, th)), false)
		elif yard:
			var h := w * 1.06 * float(yard.get_height()) / float(yard.get_width())
			var c: Vector2 = hs.anchor + hs.foot_center()
			board.draw_texture_rect(yard, Rect2(Vector2(c.x - w * 0.53, hs.anchor.y + w * 1.06 * Slot.PLOT_DROP - h), Vector2(w * 1.06, h)), false)
		else:
			var yp := PackedVector2Array()
			for p in fpts: yp.append(p + hs.anchor)
			board.draw_colored_polygon(yp, Color(0.78, 0.66, 0.46, 0.75))
			yp.append(yp[0])
			board.draw_polyline(yp, Color(0.45, 0.33, 0.2, 0.5), 2.0)
	_draw_earth()
	# (no shadows under the fields: they lie flat on the ground)

## The road's middle line, continued beyond the farm's edges.
## Bare earth of every place (ruins, pens, building sites), on the ground and back to front.
func _draw_earth() -> void:
	var cells := []
	for sid in slots:
		var s = slots[sid]
		if s.visible: cells.append_array(s.earth_cells())
	cells.sort_custom(func(a, b): return (a[1] as Rect2).position.y < (b[1] as Rect2).position.y)
	for c in cells: board.draw_texture_rect(c[0], c[1], false)

func _road_line() -> PackedVector2Array:
	var rd: Dictionary = L.get("ground", {}).get("road", {})
	if not rd.has("points") or rd["points"].size() < 2: return PackedVector2Array()
	var line := _pts(rd["points"])
	line[0] = line[0] + (line[0] - line[1]).normalized() * EXTEND
	var n := line.size()
	line[n - 1] = line[n - 1] + (line[n - 1] - line[n - 2]).normalized() * EXTEND
	return line

func _road_w() -> float:
	return float(L.get("ground", {}).get("road", {}).get("w", 64))

func _road_band() -> PackedVector2Array:
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
	var winter := season == "winter"
	var n := line.size()
	var rng := RandomNumberGenerator.new()
	rng.seed = 4242
	var dir := (line[n - 1] - line[0]).normalized()
	var nrm := Vector2(-dir.y, dir.x)
	var lvl := int(floor(road_level + 0.01))
	if lvl <= 1:
		# a muddy track: two wheel ruts with grass between them, puddles and potholes
		var faint := _band(line, w)
		board.draw_colored_polygon(faint, Color(0.45, 0.35, 0.2, 0.14))
		for side in [-1.0, 1.0]:
			var rut := PackedVector2Array()
			for p in line: rut.append(p + nrm * side * w * 0.22)
			var band := _band(rut, w * 0.2)
			if path_tex: _textured(band, path_tex, Color(0.78, 0.66, 0.5))
			else: board.draw_colored_polygon(band, Color("a88a5e"))
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
	else: board.draw_colored_polygon(full, Color("d8bf8e") * tint)
	if winter: board.draw_colored_polygon(full, Color(1, 1, 1, 0.25))
	var left := full.slice(0, n)
	var right := full.slice(n)
	var edge := Color(0, 0, 0, 0.12)
	if lvl >= 4: edge = Color(0.35, 0.35, 0.33, 0.7)
	board.draw_polyline(left, edge, 4.0 if lvl < 4 else 6.0)
	board.draw_polyline(right, edge, 4.0 if lvl < 4 else 6.0)
	var a := line[0].lerp(line[n - 1], 0.4)
	var b := line[0].lerp(line[n - 1], 0.6)
	match lvl:
		2:  # filled potholes: a few stones and old ruts
			for i in range(14):
				board.draw_circle(a.lerp(b, rng.randf()) + nrm * rng.randf_range(-0.4, 0.4) * w, rng.randf_range(2.0, 4.0), Color(0.55, 0.53, 0.5, 0.8))
		3:  # gravel
			for i in range(160):
				board.draw_circle(a.lerp(b, rng.randf()) + nrm * rng.randf_range(-0.45, 0.45) * w, 1.3, Color(0.55, 0.52, 0.48, 0.6))
		_:  # cobbles
			var steps := 70
			for i in range(steps):
				for j in range(-3, 4):
					var p := a.lerp(b, (i + (0.5 if j % 2 == 0 else 0.0)) / steps) + nrm * (j / 7.0) * w * 0.9
					board.draw_rect(Rect2(p - Vector2(4, 2.5), Vector2(8, 5)), Color(0.5, 0.5, 0.48, 0.35), false, 1.0)

func _road_tiles() -> Array:
	var key := clampf(snappedf(road_level, 0.5), 1.0, 5.0)
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
		board.draw_texture_rect(t, Rect2(c - Vector2(W, h) / 2.0, Vector2(W, h)), false)
	if season == "winter": board.draw_colored_polygon(_band(line, w), Color(1, 1, 1, 0.22))

func _blob(c: Vector2, r: float, col: Color) -> void:
	var pts := PackedVector2Array()
	for j in range(12):
		var a := TAU * j / 12.0
		pts.append(c + Vector2(cos(a) * r * (1.0 + 0.15 * sin(a * 3.0)), sin(a) * r * 0.5))
	board.draw_colored_polygon(pts, col)

## The forest floor shape, continued beyond the farm's edges (for drawing and for taps).
func forest_poly() -> PackedVector2Array:
	var fp: Array = L.get("ground", {}).get("forest", [])
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
			dir = Vector2(-1.0 if p.x < design.x / 2.0 else 1.0, -1.0 if p.y < design.y / 2.0 else 1.0).normalized()
		out.append(p + dir * EXTEND)
	return out

func _edges_of(p: Vector2) -> Array:
	var e := []
	if p.x <= 0.5: e.append("l")
	if p.x >= design.x - 0.5: e.append("r")
	if p.y <= 0.5: e.append("t")
	if p.y >= design.y - 0.5: e.append("b")
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
	var ts := Vector2(tex.get_width(), tex.get_height()) * (GRASS_SCALE if tex == Art.tex("tiles", "grass") else 1.0)
	for p in poly: uvs.append(p / ts)
	board.draw_polygon(poly, PackedColorArray([tint]), uvs, tex)

func set_season(s: String, fence: int) -> void:
	if perk_fx: perk_fx.set_season(s)
	if s != season or fence != fence_level:
		season = s
		fence_level = fence
		queue_redraw()
		board.queue_redraw()

# ------------------------------------------------------------------ animals and pets walking around
## spec: { spot_id: [[emoji, texture or null], …] } — one entry per animal or pet walking around that place.
func set_critters(spec: Dictionary) -> void:
	for sid in _critters.keys():
		if not spec.has(sid):
			for c in _critters[sid]: c.queue_free()
			_critters.erase(sid)
			_crit_sig.erase(sid)
	for sid in spec:
		if not slots.has(sid): continue
		var sig := str(spec[sid].map(func(e): return e[0]))
		if _crit_sig.get(sid, "") == sig: continue
		for c in _critters.get(sid, []): c.queue_free()
		_crit_sig[sid] = sig
		var arr := []
		for e in spec[sid]:
			var c: Control
			var tex: Texture2D = e[1]
			if tex:
				var tr := TextureRect.new()
				tr.texture = tex
				tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				tr.size = Vector2(34, 34)
				c = tr
			else:
				c = UI.label(e[0], 22)
			c.mouse_filter = Control.MOUSE_FILTER_IGNORE
			c.position = _spot_point(sid)
			c.set_meta("left", FACES_LEFT.get(str(e[2]) if e.size() > 2 else "", false))
			_sort_in(c, c.position.y + c.size.y)
			arr.append(c)
		_critters[sid] = arr

## Somewhere inside a pen (or on the grass in front of a building) — on the visible part of the farm.
func _spot_point(sid: String) -> Vector2:
	var s = slots[sid]
	var fp: PackedVector2Array = s.foot_points()
	var inside := Rect2(Vector2(8, 30), design - Vector2(50, 40))
	var q := Vector2.ZERO
	for _try in range(12):
		var i := randf_range(0.2, 0.85)
		var j := randf_range(0.2, 0.85)
		var p: Vector2 = fp[0] + (fp[1] - fp[0]) * i + (fp[3] - fp[0]) * j
		if s.kind != "plot": p = Vector2(randf_range(-0.5, 0.5) * s.pic_w, randf_range(0.0, 0.3) * tile)
		q = s.anchor + p - Vector2(17, 30)
		if inside.has_point(q): return q
	return q.clamp(inside.position, inside.end)

## Puts a node among the standing things by its feet (y): what stands lower on the screen is drawn in front.
func _sort_in(node: Control, y: float) -> void:
	node.set_meta("sy", y)
	if node.get_parent() == objects: objects.remove_child(node)
	elif node.get_parent() != null: node.get_parent().remove_child(node)
	var idx := objects.get_child_count()
	for i in range(objects.get_child_count()):
		if float(objects.get_child(i).get_meta("sy", 0.0)) > y:
			idx = i
			break
	objects.add_child(node)
	objects.move_child(node, idx)

func _process(delta: float) -> void:
	_cat_tick(delta)
	_hop_t += delta
	if _hop_t < 0.9: return
	_hop_t = 0.0
	for sid in _critters:
		for c in _critters[sid]:
			if not is_instance_valid(c) or randf() > 0.45: continue
			var target := _spot_point(sid)
			if c is TextureRect and absf(target.x - c.position.x) > 2.0:
				(c as TextureRect).flip_h = (target.x < c.position.x) != bool(c.get_meta("left", false))
			c.pivot_offset = c.size / 2.0
			var tilt := randf_range(0.06, 0.14) * (1.0 if target.x > c.position.x else -1.0)
			var mid: Vector2 = c.position.lerp(target, 0.5) + Vector2(0, -8)
			_sort_in(c, maxf(c.position.y, target.y) + c.size.y)
			var tw := create_tween()
			tw.tween_property(c, "position", mid, 0.2)
			tw.parallel().tween_property(c, "rotation", tilt, 0.2)
			tw.tween_property(c, "position", target, 0.2)
			tw.parallel().tween_property(c, "rotation", 0.0, 0.2)

# ------------------------------------------------------------------ the farm cat
## The cat (pictures assets/animals/cat_walk_1, cat_walk_2, cat_sit, cat_sleep, cat_leap, cat_run, cat_stretch,
## cat_lick, cat_lie — all looking to the right): she strolls about, sits, washes, stretches, naps, and runs at the pests.
func set_cat(on: bool) -> void:
	if on and cat == null:
		cat = TextureRect.new()
		cat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		cat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		cat.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cat.size = Vector2(48, 40)
		cat.position = Vector2(design.x * 0.55, design.y * 0.62)
		cat_emoji = UI.label("", 28)
		cat_emoji.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cat.add_child(cat_emoji)
		_sort_in(cat, cat.position.y + cat.size.y)
		_cat_next()
	elif not on and cat != null:
		cat.queue_free()
		cat = null

func _cat_pic(name: String) -> void:
	var t: Texture2D = Art.first("animals", ["cat_" + name, "cat_sit", "cat_walk_1"])
	cat.texture = t
	cat_emoji.text = "" if t else ("💤" if name == "sleep" else "🐈")

func _cat_next() -> void:
	var now := Time.get_ticks_msec() / 1000.0
	# pests on a field? she goes for them (but not every time)
	var hunt := Vector2.INF
	var hunt_field = null
	for fv in fields:
		var at: Vector2 = fv.pest_spot()
		if at != Vector2.INF:
			hunt = at
			hunt_field = fv
			break
	var r := randf()
	if hunt != Vector2.INF and r < 0.55:
		_cat = {"state": "run", "until": now + 6.0, "target": hunt - Vector2(cat.size.x / 2.0, cat.size.y * 0.8), "field": hunt_field, "frame": 0.0}
		_cat_pic("run")
	elif r < 0.6:
		var tgt := Vector2(randf_range(0.08, 0.85) * design.x, randf_range(0.35, 0.92) * design.y)
		_cat = {"state": "walk", "until": now + 14.0, "target": tgt, "frame": 0.0}
		_cat_pic("walk_1")
	else:
		var pick: Array = [["sit", 4.0], ["lick", 4.0], ["stretch", 2.5], ["lie", 6.0], ["sleep", 12.0]][randi() % 5]
		_cat = {"state": pick[0], "until": now + pick[1] * randf_range(0.8, 1.4), "target": cat.position, "frame": 0.0}
		_cat_pic(pick[0])

func _cat_tick(delta: float) -> void:
	if cat == null: return
	var now := Time.get_ticks_msec() / 1000.0
	var st: String = _cat["state"]
	if st == "walk" or st == "run":
		var speed := 38.0 if st == "walk" else 120.0
		var to: Vector2 = _cat["target"] - cat.position
		if to.length() > 3.0:
			cat.flip_h = to.x < 0.0
			cat.position += to.normalized() * minf(speed * delta, to.length())
			_cat["frame"] = float(_cat["frame"]) + delta
			if st == "walk": _cat_pic("walk_1" if int(float(_cat["frame"]) / 0.28) % 2 == 0 else "walk_2")
		else:
			if st == "run" and _cat.get("field") != null:
				_cat_pic("leap")
				_cat["field"].shoo_one()
				_cat = {"state": "sit", "until": now + 2.5, "target": cat.position, "frame": 0.0}
				return
			_cat["until"] = 0.0
	_cat_sort += delta
	if _cat_sort > 0.4:
		_cat_sort = 0.0
		_sort_in(cat, cat.position.y + cat.size.y)
	if now >= float(_cat["until"]): _cat_next()


# ------------------------------------------------------------------ the farmer walking about
## The grass (or road, or forest floor) was tapped at p (farm coordinates): the farmer walks there.
func ground_tapped(p: Vector2) -> void:
	if actor: actor.stop()
	if avatar: avatar.walk_to(p)

func _walk_to_spot(sid: String) -> void:
	if avatar == null or not slots.has(sid): return
	if actor: actor.stop()
	avatar.walk_to(slots[sid].anchor + Vector2(0, 14))

func _walk_to_patch(_a: String, k: int, fv) -> void:
	if avatar == null: return
	if actor: actor.stop()
	avatar.walk_to(fv.position + fv.patch_center(k))

func _cell(p: Vector2) -> Vector2i:
	return Vector2i(clampi(int(p.x / CELL), 0, astar.region.size.x - 1), clampi(int(p.y / CELL), 0, astar.region.size.y - 1))

func _cell_center(c: Vector2i) -> Vector2:
	return Vector2((c.x + 0.5) * CELL, (c.y + 0.5) * CELL)

## The grid of where the farmer can walk: not through buildings, pens, ponds, fields or the forest. Made again when
## places appear (only visible ones block).
func _grid_update() -> void:
	var sig := ""
	for sid in slots: sig += "1" if slots[sid].visible else "0"
	if sig == _grid_sig and astar.region.size.x > 0: return
	_grid_sig = sig
	astar.region = Rect2i(0, 0, ceili(design.x / CELL), ceili(design.y / CELL))
	astar.cell_size = Vector2(CELL, CELL)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.update()
	var polys := []
	for sid in slots:
		var s = slots[sid]
		if not s.visible or s.kind == "sub": continue
		var fp: PackedVector2Array = s.foot_points()
		var poly := PackedVector2Array()
		var c: Vector2 = s.anchor + s.foot_center()
		for q in fp:
			var w: Vector2 = s.anchor + q
			poly.append(w + (w - c).normalized() * 4.0)
		polys.append(poly)
	for fv in fields:
		var x: float = fv.position.x + fv.size.x / 2.0
		var y: float = fv.position.y + fv.size.y
		polys.append(PackedVector2Array([Vector2(x, fv.position.y), Vector2(fv.position.x + fv.size.x, y - fv.size.y / 2.0),
			Vector2(x, y), Vector2(fv.position.x, y - fv.size.y / 2.0)]))
	var fpoly := forest_poly()
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
	pts[pts.size() - 1] = to.clamp(Vector2(4, 4), design - Vector2(4, 4)) if end_free else _cell_center(b)
	var out := PackedVector2Array([pts[0]])
	var i := 0
	while i < pts.size() - 1:
		var j := pts.size() - 1
		while j > i + 1 and not _clear_line(pts[i], pts[j]): j -= 1
		out.append(pts[j])
		i = j
	return out

# ------------------------------------------------------------------ perk effects over the farm
func set_perks(flags: Dictionary) -> void:
	if perk_fx: perk_fx.set_on(flags)

func rainbow() -> void:
	if perk_fx: perk_fx.rainbow()

## A tap somewhere on the screen (global position): sparkles there, if the perk is on.
func sparkle_global(gp: Vector2) -> void:
	if perk_fx == null or not perk_fx.on.get("sparkles", false): return
	perk_fx.sparkle(board.get_global_transform().affine_inverse() * gp)
	Sound.play("sparkle")

## Catches taps on the ground (it lies under everything else, so places and patches come first): the farmer walks
## there; the forest floor and the road also open their sheet.
class GroundTap extends Control:
	var map
	var _press := Vector2.ZERO
	var _pressing := false
	var _what := ""

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_PASS

	func _which(p: Vector2) -> String:
		var fp: PackedVector2Array = map.forest_poly()
		if fp.size() >= 3 and Geometry2D.is_point_in_polygon(p, fp): return "forest"
		var rb: PackedVector2Array = map._road_band()
		if rb.size() >= 3 and Geometry2D.is_point_in_polygon(p, rb): return "road"
		return ""

	func _has_point(p: Vector2) -> bool:
		return Rect2(Vector2.ZERO, size).has_point(p)

	func _gui_input(e: InputEvent) -> void:
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				_press = e.position
				_pressing = true
				_what = _which(e.position)
			elif _pressing:
				_pressing = false
				if e.position.distance_to(_press) < 16.0:
					map.ground_tapped(e.position)
					if _what != "": map.spot_tapped.emit(_what)
		elif e is InputEventMouseMotion and _pressing and e.position.distance_to(_press) >= 16.0:
			_pressing = false
