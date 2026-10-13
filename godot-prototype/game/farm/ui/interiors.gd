extends RefCounted
class_name FarmUiInteriors
## The inside of a building (house, barn, workshop): the room with its corners, each tappable and opening its own sheet.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")
const SlotScript = preload("res://game/farm/map/slot.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ inside a building

## A window over the farm (the farm stays visible, dimmed, behind it) with the building's inside: every corner
## (bed, books, kitchen; cellar, crocks …; benches, kiln & forge …) is tappable and opens its own sheet.
func open_interior(parent: String) -> void:
	var info: Dictionary = Spots.interior(parent)
	var box := M.modals.open_modal("%s %s" % [M.mapview.spot_emoji(parent), M.mapview.spot_title(parent)])
	var w := M.modals.modal_w() - 40.0
	var bg_tex: Texture2D = Art.tex("interiors", str(info["art"]))
	var h := w * 0.8
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
		var cw := float(at.get("w", 0.2)) * w
		var s = SlotScript.new()
		s.setup(m, Vector2(float(at.get("x", 0.5)) * w, float(at.get("y", 0.6)) * h), cw, Vector2i(1, 1), cw * 0.9)
		room.add_child(s)
		var keys: Array = Spots.corner_art(m).filter(func(id): return G.nodes.has(id) and G.done(id))
		keys.reverse()
		var key := M.mapview.first_key("interior", keys)
		var tex: Texture2D = Art.tex("interior", key) if key != "" else null
		if tex == null:
			key = M.mapview.first_key("map", keys)
			tex = Art.tex("map", key) if key != "" else null
		var open := M.mapview.is_open(m) or m in ["barn_build", "ws_build"]
		s.set_state(tr(Spots.name_of(m)), Spots.emoji_of(m), tex, not open, M.mapview.badge(m), key)
		s.tapped.connect(enter_corner.bind(parent))
	if parent == "workshop" and G.nodes.has("tool_rack") and G.done("tool_rack"):
		var rack: Dictionary = spots.get("ws_tools", {"x": 0.5, "y": 0.5, "w": 0.2})
		var tools := []
		for b in Spots.bench():
			if b.get("item", false) or not G.nodes.has(b["id"]) or not G.satisfied(b["id"]): continue
			var tt: Texture2D = Art.tex("tools", str(b["pic"]))
			if tt: tools.append(tt)
		for ti in range(tools.size()):
			var tr2 := TextureRect.new()
			tr2.texture = tools[ti]
			tr2.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr2.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr2.rotation = -PI / 2.0                       # hanging handle down
			var tw2 := w * 0.07
			tr2.size = Vector2(tw2 * 1.6, tw2)
			tr2.pivot_offset = tr2.size / 2.0
			tr2.position = Vector2((float(rack["x"]) - 0.12 + ti * 0.035) * w, (float(rack["y"]) - 0.22) * h)
			tr2.mouse_filter = Control.MOUSE_FILTER_IGNORE
			room.add_child(tr2)
	box.add_child(UI.label(tr("Tap a corner to see what you can do there."), 15, UI.MUTED, true))
	M.modals.fit_modal()

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

func enter_corner(m: String, parent: String) -> void:
	M.modals.close_modal()
	M.sheets.open_sheet("spot:" + m)
	M.interior_back = parent
