extends Control
class_name FarmMap
## The farm map on one screen, seen at an angle like Hay Day: grass, the forest coming in from one side and the
## village road from the other, three diamond fields, pens and gardens lying flat, and every building standing on
## its footprint. Lower things are drawn in front of higher ones. The whole farm (design size 834×1000) is scaled
## to fit the screen, so nothing needs scrolling.
## Positions and sizes come from data/map_layout.json — move things with tools/layout-editor.html.
## The forest and the road have no picture of their own: a tap on the trees opens the forest, a tap on the road the road.
## The road looks like what it is: a muddy track with puddles at first, then filled, gravel, cobbles, paved.

signal spot_tapped(spot_id: String)

const Art = preload("res://kits/ui/art.gd")
const UI = preload("res://kits/ui/ui.gd")
const Slot = preload("res://game/farm/map/slot.gd")
const IsoField = preload("res://game/farm/map/iso_field.gd")
const Avatar = preload("res://kits/avatar/avatar.gd")
const Actor = preload("res://kits/avatar/actor.gd")
const Fx = preload("res://game/farm/fx.gd")
const LAYOUT_PATH := "res://data/map_layout.json"
const GRASS := {"spring": Color("9cc86a"), "summer": Color("b3c95c"), "autumn": Color("c4b46a"), "winter": Color("dfe8e6")}
const GRASS_TINT := {"spring": Color(1, 1, 1), "summer": Color(1.05, 1.03, 0.85), "autumn": Color(1.1, 0.95, 0.7), "winter": Color(0.95, 1.0, 1.08)}
const FENCES := [["", Color(0, 0, 0, 0), 0.0], ["stick_fence", Color("8a6239"), 3.0], ["wattle_fence", Color("9a7444"), 5.0],
	["picket_fence", Color("f4efe3"), 5.0], ["stone_wall", Color("9a9a92"), 8.0], ["hedge_row", Color("3f7a34"), 10.0]]
const GRASS_SCALE := 0.5  # the grass picture is drawn at half its size (finer blades)

var L: Dictionary = {}
## The parts of the map (game/farm/map/): each does one job and works through `map` (this node).
var critters: FarmMapCritters
var farmcat: FarmMapCat
var ground: FarmMapGround
var walker: FarmMapWalker
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
var road_badge: PanelContainer
var field_badge: PanelContainer       # a little sign above the first field when there is something to do on the fields (they have no sign of their own)
var avatar                    # the farmer: walks to wherever the player taps (kits/avatar/avatar.gd)
var actor                     # … and acts out what the player did there (kits/avatar/actor.gd, data/acts.json)
var perk_fx                   # butterflies, sparkles, rainbow, season breeze (fx.gd MapFx)
var fields: Array = []      # IsoField per field (0 = Home Field)
var scarecrow: TextureRect
var scarecrow_emoji: Label
var pests_box: PanelContainer
var pest_lbl: Label
var slots := {}
var addon_nodes: Array = [] # [{"node", "sid", "id", "until"}]
var season := "spring"
var usable_fields := 1
var house_built := false
var extra_bottom := 0.0
var view := Vector2.ZERO
var fit_scale := 1.0


func _make_parts() -> void:
	critters = FarmMapCritters.new(self)
	farmcat = FarmMapCat.new(self)
	ground = FarmMapGround.new(self)
	walker = FarmMapWalker.new(self)

func _ready() -> void:
	_make_parts()
	mouse_filter = Control.MOUSE_FILTER_PASS
	_load_layout()
	board = _layer(self)
	board.size = design
	board.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	board.draw.connect(ground._draw_board)
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
		s.tapped.connect(walker._walk_to_spot)
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
	field_badge = UI.pill("", 18, Color(1, 1, 1, 0.95))
	field_badge.visible = false
	board.add_child(field_badge)
	perk_fx = Fx.MapFx.new()
	perk_fx.size = design
	for fv in fields:
		perk_fx.areas.append(Rect2(fv.position + Vector2(fv.size.x * 0.15, fv.size.y * 0.1), fv.size * Vector2(0.7, 0.7)))
		fv.patch_pressed.connect(walker._walk_to_patch.bind(fv))
	board.add_child(perk_fx)
	fx_layer = _layer(board)
	# the farmer, in front of the house
	avatar = Avatar.new()
	avatar.map = self
	avatar.feet = Vector2(float(L.get("avatar", {}).get("x", 417)), float(L.get("avatar", {}).get("y", 262)))
	sort_in(avatar, avatar.feet.y)
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
	if sid == "road": r = _poly_rect(ground.road_band(), Rect2(Vector2.ZERO, design))
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
	if sid == "field": return patch_point(0, 4)       # the fields have no sign: the middle of the first one
	if sid == "road":
		var rd: Dictionary = L.get("ground", {}).get("road", {})
		if rd.has("points"):
			var pts := ground._pts(rd["points"])
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

## Redraws the fields, the scarecrow and the pests (called by the main screen on every change).
func refresh_fields(G) -> void:
	usable_fields = maxi(1, int(ceilf(float(G.progression.plots()) / 9.0)))
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
	var share: float = G.fields.pest_eat_share()
	var any_growing := total > 0
	pests_box.visible = any_growing and share >= 0.005
	pest_lbl.text = "🐦 %d%%" % int(round(share * 100.0))
	pests_box.tooltip_text = tr("Pests eat about this much of what is growing, every question.")
	_layout_pill()
	var rl := snappedf(G.g("roadLevel", 1.0), 0.5)
	if rl != road_level:
		road_level = rl
	board.queue_redraw()

func set_field_badge(text: String) -> void:
	field_badge.get_child(0).text = text
	field_badge.visible = text != "" and fields.size() > 0
	var s := field_badge.get_combined_minimum_size()
	field_badge.size = s
	if fields.size() > 0: field_badge.position = fields[0].position + Vector2(fields[0].size.x / 2.0 - s.x / 2.0, -s.y * 0.2)

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

## What the avatar kit (kits/avatar/avatar.gd) asks of its map: a path around what stands there, and a place among the standing things.
func find_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	return walker.find_path(from, to)

func sort_in(node: Control, y: float) -> void:
	critters.sort_in(node, y)

func _process(delta: float) -> void:
	farmcat.tick(delta)
	critters.tick(delta)

func set_perks(flags: Dictionary) -> void:
	if perk_fx: perk_fx.set_on(flags)

func rainbow() -> void:
	if perk_fx: perk_fx.rainbow()

## A tap somewhere on the screen (global position): sparkles there, if the perk is on.
func sparkle_global(gp: Vector2) -> void:
	if perk_fx == null or not perk_fx.on.get("sparkles", false): return
	perk_fx.sparkle(board.get_global_transform().affine_inverse() * gp)
	Sound.play("sparkle")


class GroundTap extends Control:
	var map
	var _press := Vector2.ZERO
	var _pressing := false
	var _what := ""

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_PASS

	func _which(p: Vector2) -> String:
		var fp: PackedVector2Array = map.ground.forest_poly()
		if fp.size() >= 3 and Geometry2D.is_point_in_polygon(p, fp): return "forest"
		var rb: PackedVector2Array = map.ground.road_band()
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
					map.walker.ground_tapped(e.position)
					if _what != "": map.spot_tapped.emit(_what)
		elif e is InputEventMouseMotion and _pressing and e.position.distance_to(_press) >= 16.0:
			_pressing = false
