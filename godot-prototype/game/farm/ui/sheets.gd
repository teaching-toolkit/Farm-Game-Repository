extends RefCounted
## The sheet that slides up (and the insides of buildings with their corners): opening, sizing, closing, rebuilding.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")
const SlotScript = preload("res://game/farm/map/slot.gd")

var M
var G

## A tap on a place: a building with an inside opens its inside, everything else its sheet.
func _open_spot(sid: String) -> void:
	M.ui_sounds._animal_voice(sid)
	if Spots.INTERIORS.has(sid) and M.ui_map._built(sid):
		_open_interior(sid)
		return
	_open_sheet_for(sid)

## The sheet of a place or of a corner inside a building. Before a barn or workshop stands, its corners share one sheet.
func _open_sheet_for(sid: String) -> void:
	var parent := Spots.parent_of(sid)
	var target := sid
	if parent != "" and parent != "home" and not M.ui_map._built(parent): target = parent
	_open_sheet("spot:" + target)
	M.get_tree().create_timer(0.1).timeout.connect(_reveal_spot.bind(target))

func _reveal_spot(sid: String) -> void:
	M.ui_map._reveal(M.map.spot_rect(M.ui_map._map_sid(sid)))

## A window over the farm (the farm stays visible, dimmed, behind it) with the building's inside: every corner
## (bed, books, kitchen; cellar, crocks …; benches, kiln & forge …) is tappable and opens its own sheet.
func _open_interior(parent: String) -> void:
	var info: Dictionary = Spots.INTERIORS[parent]
	var box = M.ui_modal._open_modal("%s %s" % [M.ui_map._spot_emoji(parent), M.ui_map._spot_title(parent)])
	var w = M.ui_modal._modal_w() - 40.0
	var bg_tex: Texture2D = Art.tex("interiors", str(info["art"]))
	var h = w * 0.8
	if bg_tex: h = w * float(bg_tex.get_height()) / float(bg_tex.get_width())
	var room := Control.new()
	room.custom_minimum_size = Vector2(w, h)
	room.mouse_filter = Control.MOUSE_FILTER_PASS
	box.add_child(room)
	if bg_tex:
		var tr := TextureRect.new()
		tr.texture = bg_tex
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_SCALE
		tr.size = Vector2(w, h)
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		room.add_child(tr)
	else:
		room.draw.connect(_draw_room.bind(room))
	var spots: Dictionary = M.map.L.get("interiors", {}).get(parent, {})
	var corners := []
	for m in info["members"]:
		var at: Dictionary = spots.get(m, {"x": 0.5, "y": 0.6, "w": 0.2})
		corners.append([float(at.get("y", 0.6)), m, at])
	corners.sort_custom(func(a, b): return a[0] < b[0])
	for c in corners:
		var m: String = c[1]
		var at: Dictionary = c[2]
		var cw = float(at.get("w", 0.2)) * w
		var s = SlotScript.new()
		s.setup(m, Vector2(float(at.get("x", 0.5)) * w, float(at.get("y", 0.6)) * h), cw, Vector2i(1, 1), cw * 0.9)
		room.add_child(s)
		var keys: Array = Spots.HOTSPOT_ART.get(m, []).filter(func(id): return G.nodes.has(id) and G.done(id))
		keys.reverse()
		var key = M.ui_map._first_key("interior", keys)
		var tex: Texture2D = Art.tex("interior", key) if key != "" else null
		if tex == null:
			key = M.ui_map._first_key("map", keys)
			tex = Art.tex("map", key) if key != "" else null
		var open = M.ui_map._is_open(m) or m in ["barn_build", "ws_build"]
		var info2: Array = Spots.SPOTS.get(m, [m.capitalize(), "❔"]).duplicate()
		info2[0] = tr(str(info2[0]))
		s.set_state(info2[0], info2[1], tex, not open, M.ui_map._badge(m), key)
		s.tapped.connect(_enter_corner.bind(parent))
	if parent == "workshop" and G.nodes.has("tool_rack") and G.done("tool_rack"):
		var rack: Dictionary = spots.get("ws_tools", {"x": 0.5, "y": 0.5, "w": 0.2})
		var tools := []
		for b in Spots.BENCH:
			if b.get("item", false) or not G.nodes.has(b["id"]) or not G.satisfied(b["id"]): continue
			var tt: Texture2D = Art.tex("tools", str(b["pic"]))
			if tt: tools.append(tt)
		for ti in range(tools.size()):
			var tr2 := TextureRect.new()
			tr2.texture = tools[ti]
			tr2.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr2.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr2.rotation = -PI / 2.0                       # hanging handle down
			var tw2 = w * 0.07
			tr2.size = Vector2(tw2 * 1.6, tw2)
			tr2.pivot_offset = tr2.size / 2.0
			tr2.position = Vector2((float(rack["x"]) - 0.12 + ti * 0.035) * w, (float(rack["y"]) - 0.22) * h)
			tr2.mouse_filter = Control.MOUSE_FILTER_IGNORE
			room.add_child(tr2)
	box.add_child(UI.label(tr("Tap a corner to see what you can do there."), 15, UI.MUTED, true))
	M.ui_modal._fit_modal()

## Placeholder inside (until assets/interiors/<name>.png exists): a floor diamond and two back walls.
func _draw_room(room: Control) -> void:
	var w := room.size.x
	var h := room.size.y
	var top := Vector2(w / 2.0, h * 0.22)
	var lft := Vector2(0, h * 0.6)
	var rgt := Vector2(w, h * 0.6)
	var bot := Vector2(w / 2.0, h * 0.98)
	var up := Vector2(0, -h * 0.2)
	room.draw_colored_polygon(PackedVector2Array([lft + up, top + up, top, lft]), Color("efe3c8"))
	room.draw_colored_polygon(PackedVector2Array([top + up, rgt + up, rgt, top]), Color("e6d6b4"))
	room.draw_colored_polygon(PackedVector2Array([top, rgt, bot, lft]), Color("d9b98a"))
	room.draw_polyline(PackedVector2Array([lft + up, top + up, rgt + up, rgt, bot, lft, lft + up]), Color("8a6a44"), 3.0)
	room.draw_line(top + up, top, Color("8a6a44"), 3.0)

func _enter_corner(m: String, parent: String) -> void:
	M.ui_modal._close_modal()
	_open_sheet("spot:" + m)
	M._interior_back = parent

func _open_pantry() -> void: _open_spot("storage")

func _open_goals() -> void: _open_sheet("goals")

func _open_album() -> void: _open_sheet("album")

func _open_sheet(kind: String) -> void:
	M._interior_back = ""
	M._patch_note = -1
	var was = M.sheet.visible
	M.sheet_kind = kind
	M.sheet_scroll.scroll_vertical = 0
	M.sheet.visible = true
	_rebuild_sheet()
	_fit_sheet()
	call_deferred("_fit_sheet")
	M.get_tree().create_timer(0.06).timeout.connect(_fit_sheet)
	if not was:
		M.ui_sounds._sfx("open")
		M._slide = 0.0
		var tw = M.create_tween()
		tw.tween_method(_set_slide, 0.0, 1.0, 0.22).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

## 0 = hidden below the screen, 1 = fully up (used for the slide-in).
func _set_slide(v: float) -> void:
	M._slide = v
	_place_sheet()

func _close_sheet() -> void:
	if M.sheet.visible: M.ui_sounds._sfx("close")
	M.sheet.visible = false
	M.sheet_kind = ""
	M.sheet_h = 0.0
	M.map.set_extra_bottom(0.0)
	M._clear(M.content)
	if M._interior_back != "":
		var p = M._interior_back
		M._interior_back = ""
		_open_interior(p)

## The sheet grows with its content, up to 60% of the screen.
func _fit_sheet() -> void:
	if not M.sheet.visible: return
	var want = M.content.get_combined_minimum_size().y + 96.0
	M.sheet_h = clampf(want, 240.0, M.size.y * 0.6)
	_place_sheet()
	M.map.set_extra_bottom(M.sheet_h)
	M.ui_notes._place_toasts()

func _place_sheet() -> void:
	M.sheet.size = Vector2(M.size.x, M.sheet_h)
	M.sheet.position = Vector2(0, M.size.y - M.sheet_h + (1.0 - M._slide) * M.sheet_h)

func _rebuild_sheet() -> void:
	M._clear(M.content)
	var k = M.sheet_kind
	if k.begins_with("spot:"):
		var sid = k.substr(5)
		if M.ui_map._mystery(sid):
			M.sheet_title.text = "❔"
			M.ui_place._part_mystery()
			return
		M.sheet_title.text = "%s %s" % [M.ui_map._spot_emoji(sid), M.ui_map._spot_title(sid)]
		M.content.add_child(M.ui_place._spot_header(sid))
		M.ui_place._sheet_spot(sid)
	elif k.begins_with("patch:"):
		var parts = k.split(":")
		M.ui_fields._sheet_patch(parts[1], int(parts[2]))
	else:
		match k:
			"mystery":
				M.sheet_title.text = "❔"
				M.ui_place._part_mystery()
			"goals":
				M.sheet_title.text = M.tr("📖 Quest book")
				M.content.add_child(UI.header(null, "📖", 80))
				M.ui_menus._sheet_goals()
			"album":
				M.sheet_title.text = M.tr("🖼️ Album")
				M.content.add_child(UI.header(null, "🖼️", 80))
				M.ui_menus._sheet_album()
			"log":
				M.sheet_title.text = M.tr("📜 What happened")
				M.ui_menus._sheet_log()
