extends RefCounted
class_name FarmUiSquare
## The village square as its own screen (money-market/07). While the farmer is in the village (G.trip.at_square()), a scene of the square stands
## where the farm was: nothing of the farm is seen or can be tapped. Its stalls are pictures to tap; the window below the scene (the sheet,
## kind "spot:market", without ✖ and always the same height) shows the stall that was tapped. Other windows (the bag, the quest book) open
## over the scene and close back to it.
##
## This part owns the scene, which stall is open, and the window's frame. It does NOT know what a stall offers: the part that owns a
## stall's content registers it (`add_stall`: main.gd `_make_parts` lists them), so a new stall is one data entry (where it stands, its
## picture and symbol) and one `add_stall` line, and nothing here changes. The sign for the walk home ("home") is the square's own.
##   WHERE a stall stands and how it looks   rules/49-trip.json "square" (a mockup from pictures the game already has; a painted
##                                           `backdrop` replaces sky, ground and deco at once, so painted pictures need no code)
##   WHAT a stall offers                     its owner's `build` (ui/places/market.gd: selling, seeds, traders, orders; placesheet: the board)
##   The rules                               G.trade, G.trip, G.progression

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const SHEET_SHARE := 0.6       # the window below the scene: this share of the screen's height (the most a sheet may take)

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

var stall := "sell"            # the stall whose things the window shows
var _root: Control = null      # the scene (hidden at home)
var _box := Vector2.ZERO       # the size the scene was laid out for
var _sig := ""                 # which stalls stood there and which was picked, when it was laid out
var _was_here := false
var _stall_nodes := {}         # id -> the stall's control
var _stalls := {}              # id -> {"build": fills the window, "shown": does it stand there now, "wanted": did the farmer come for it}
var _head := Callable()        # fills the top of the window, above every stall's things (the walk home, the bag's bars)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

func data() -> Dictionary:
	return G.trip.data().get("square", {})

# ------------------------------------------------------------------ what stands on the square (the parts that own a stall's things say so)

## Registers a stall: `build` fills the window (M.content) with what it offers; `shown` says whether it stands there now (always, when
## left out); `wanted` says whether the farmer most likely came for it (it is then open on arrival). The id is the stall's in the data.
func add_stall(id: String, build: Callable, shown := Callable(), wanted := Callable()) -> void:
	_stalls[id] = {"build": build, "shown": shown, "wanted": wanted}
	_sig = ""

## What stands at the top of the window whatever stall is open.
func set_head(build: Callable) -> void:
	_head = build

## Fills the window below the scene: the head, then the open stall's things.
func build_window() -> void:
	if not (stall in stalls()): stall = _first_stall()
	if _head.is_valid(): _head.call()
	if _stalls.has(stall): _stalls[stall]["build"].call()

# ------------------------------------------------------------------ state (the sheet, the feedback and the tests ask)

## Is the square on screen (instead of the farm)?
func active() -> bool:
	return _root != null and _root.visible

func root() -> Control:
	return _root

## The stalls that stand on the square now, in the data's order: the sign for the walk home, and every registered stall that says it is there.
func stalls() -> Array:
	var out := []
	for s in data().get("stalls", []):
		var id := str(s.get("id", ""))
		if id != "home":
			if not _stalls.has(id): continue
			var shown: Callable = _stalls[id]["shown"]
			if shown.is_valid() and not shown.call(): continue
		out.append(id)
	return out

## Where a stall stands on the screen (its middle), for coins flying to and from it; the middle of the scene when it is not there.
func stall_point(id: String) -> Vector2:
	if _stall_nodes.has(id) and is_instance_valid(_stall_nodes[id]): return _stall_nodes[id].get_global_rect().get_center()
	return _root.get_global_rect().get_center() if _root != null else M.size / 2.0

## How high the window below the scene is.
func sheet_height() -> float:
	return M.size.y * SHEET_SHARE

# ------------------------------------------------------------------ taps

## A tap on a stall: the sign takes the walk home (one Time Quiz question), every other stall shows its things in the window.
func pick(id: String) -> void:
	if not G.trip.at_square(): return
	M.feedback.sfx("open")
	if id == "home":
		M.timequiz.show_home_question()
		return
	if not (id in stalls()): return
	stall = id
	if M.sheet_kind != "spot:market": M.sheets.open_sheet("spot:market")
	else:
		M.sheet_scroll.scroll_vertical = 0
		M.sheets.rebuild_sheet()
		M.sheets.fit_sheet.call_deferred()
	sync()

## The stall that is open on arrival: the first one the farmer most likely came for (its `wanted`), else the data's `first`, else the first there.
func _first_stall() -> String:
	var here := stalls().filter(func(id): return id != "home")
	for id in here:
		var wanted: Callable = _stalls[id]["wanted"]
		if wanted.is_valid() and wanted.call(): return id
	var first := str(data().get("first", ""))
	if first in here: return first
	return str(here[0]) if not here.is_empty() else ""

# ------------------------------------------------------------------ showing and hiding (called from the main screen's refresh)

## Shows the scene while the farmer is in the village and hides it at home; lays it out again when the screen, the stalls or the pick changed.
func sync() -> void:
	var here: bool = G.trip.at_square()
	if here and not _was_here: stall = _first_stall()
	_was_here = here
	if not here:
		if _root != null: _root.visible = false
		return
	if not (stall in stalls()): stall = _first_stall()
	if _root == null: _make_root()
	_root.visible = true
	place()

## Puts the scene where the farm map is, and draws it for that size.
func place() -> void:
	if _root == null or not _root.visible: return
	var r: Rect2 = M.scroll.get_global_rect()
	_root.position = r.position - M.get_global_rect().position
	_root.size = r.size
	var box := Vector2(r.size.x, maxf(120.0, M.size.y - sheet_height() - _root.position.y))
	var sig := "%s|%s" % [",".join(PackedStringArray(stalls())), stall]
	if box.is_equal_approx(_box) and sig == _sig: return
	_box = box
	_sig = sig
	_draw(box)

func _make_root() -> void:
	_root = Control.new()
	_root.name = "VillageSquare"
	_root.mouse_filter = Control.MOUSE_FILTER_STOP      # nothing of the farm behind it can be tapped
	_root.clip_contents = true
	M.add_child(_root)
	M.move_child(_root, M.scroll.get_parent().get_index() + 1)      # over the farm, under the clock, the windows and the pop-ups

# ------------------------------------------------------------------ the scene

## Draws the scene into the upper `box` of the root (the window covers the rest).
func _draw(box: Vector2) -> void:
	for c in _root.get_children():
		_root.remove_child(c)
		c.queue_free()
	_stall_nodes = {}
	var d := data()
	var under := ColorRect.new()                  # what shows below the scene's box before the window has slid up
	under.color = Color(str(d.get("hills", "9cc98a")))
	under.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	under.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(under)
	var painted := _tex(str(d.get("backdrop", "")))
	if painted != null:
		var p := TextureRect.new()
		p.texture = painted
		p.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		p.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		p.size = box
		p.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_root.add_child(p)
	else:
		var hz := box.y * float(d.get("horizon", 0.4))
		var sky := ColorRect.new()
		sky.color = Color(str(d.get("sky", "bfe3f0")))
		sky.size = Vector2(box.x, hz)
		sky.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_root.add_child(sky)
		var ground := TextureRect.new()
		ground.texture = _tex(str(d.get("ground", "")))
		ground.stretch_mode = TextureRect.STRETCH_TILE
		ground.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ground.position = Vector2(0, hz)
		ground.size = Vector2(box.x, _root.size.y - hz)
		ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_root.add_child(ground)
		for e in d.get("deco", []):
			var t := _tex(str(e.get("art", "")))
			if t == null: continue
			var pic := _picture(t, _rect(e, t, box))
			pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_root.add_child(pic)
	var here := stalls()
	for s in d.get("stalls", []):
		var id := str(s.get("id", ""))
		if not (id in here): continue
		var tex := _tex(str(s.get("art", "")))
		var r: Rect2 = _rect(s, tex, box)
		var b := Button.new()                       # a flat button the size of the picture: the picture is the thing to tap
		b.name = "stall_" + id
		b.flat = true
		b.focus_mode = Control.FOCUS_NONE
		for st in ["normal", "hover", "pressed", "focus", "disabled"]: b.add_theme_stylebox_override(st, StyleBoxEmpty.new())
		b.position = r.position
		b.size = r.size
		b.pivot_offset = Vector2(r.size.x / 2.0, r.size.y)
		b.pressed.connect(pick.bind(id))
		_root.add_child(b)
		_stall_nodes[id] = b
		var on := id == stall
		if on:                                      # the picked stall stands on a light spot and is a little bigger
			var spot := Panel.new()
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color(1, 0.97, 0.75, 0.75)
			sb.set_corner_radius_all(int(r.size.y))
			spot.add_theme_stylebox_override("panel", sb)
			spot.size = Vector2(r.size.x * 1.1, r.size.y * 0.3)
			spot.position = Vector2(-r.size.x * 0.05, r.size.y * 0.76)
			spot.mouse_filter = Control.MOUSE_FILTER_IGNORE
			b.add_child(spot)
			b.scale = Vector2(1.08, 1.08)
		if tex != null:
			var pic2 := _picture(tex, Rect2(Vector2.ZERO, r.size))
			pic2.mouse_filter = Control.MOUSE_FILTER_IGNORE
			if not on and id != "home": pic2.modulate = Color(0.93, 0.93, 0.93)
			b.add_child(pic2)
		var badge := PanelContainer.new()            # what the stall is for, as a symbol (no words on the square)
		badge.add_theme_stylebox_override("panel", UI.box(UI.PAPER if not on else Color("fff3c4"), 18, UI.LINE, 2, 4))
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		badge.add_child(UI.label(str(s.get("emoji", "")), 24))
		b.add_child(badge)
		badge.position = Vector2(r.size.x / 2.0 - 22.0, -18.0)

## Where a picture stands: the middle of its lower edge at x, y of the box, `w` of the box wide, never taller than `maxH` of it
## (without a picture: an area of w x h of the box).
func _rect(e: Dictionary, tex: Texture2D, box: Vector2) -> Rect2:
	var w := box.x * float(e.get("w", 0.1))
	var h := box.y * float(e.get("h", 0.3))
	if tex != null:
		h = w * float(tex.get_height()) / maxf(1.0, float(tex.get_width()))
		var top := box.y * float(data().get("maxH", 0.62))
		if h > top:
			w *= top / h
			h = top
	return Rect2(box.x * float(e.get("x", 0.5)) - w / 2.0, box.y * float(e.get("y", 1.0)) - h, w, h)

func _picture(tex: Texture2D, r: Rect2) -> TextureRect:
	var t := TextureRect.new()
	t.texture = tex
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.position = r.position
	t.size = r.size
	return t

## A picture by "folder/name" (null when the file is not there, or the name is empty).
func _tex(path: String) -> Texture2D:
	var at := path.find("/")
	if at <= 0: return null
	return Art.tex(path.substr(0, at), path.substr(at + 1))
