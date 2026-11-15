extends RefCounted
class_name FarmUiFigures
## The people who are not the farmer, drawn into any scene (people/04). A scene asks for a figure by the person's id (`put`), may let it
## stroll between points (`stroll`), keeps it in place when the scene is laid out for another size (`move_all`) and takes it away again
## (`take`, `clear`); `walk_to` sends one straight to a point (and out of the scene when it is leaving). A tapped figure stops, turns to the front (to the farmer, whose eyes the scene is seen through), waves, plays a small
## sound and says what `G.people.line(id)` says in a speech bubble over its head for a few seconds; `tapped(id)` is emitted and the tap
## is used up, so nothing behind the figure reacts.
##   WHO the people are, how they look, where they stand and stroll   data/farm/rules/58-people.json   (rules: systems/people.gd)
##   HOW a figure is drawn   ONLY `_make_body` and the private calls on its result (today the farmer's little 3D rig, kits/avatar/avatar.gd).
##   A different look (a flat puppet, pictures) changes that one function; no scene and no other file knows what a figure is made of.
## Coordinates are the scene's own (pixels, the scene's top left is 0, 0). Nothing is saved; strolling uses its own random numbers, never the game's.

const Avatar = preload("res://kits/avatar/avatar.gd")
const UI = preload("res://kits/ui/ui.gd")
const BODY_H := 54.0          # how many of the rig's own pixels (Avatar.SHOW is 76 high) the figure itself is tall: the scale for `height`
const WALK_H := 0.5           # strolling speed: this many figure heights a second
const SAY_TIME := 3.0         # how long a bubble stays
const FONT := 17              # the bubble's text size
const STAND := Vector2(2.0, 5.0)   # a strolling figure stands this many seconds (from, to) at each point

signal tapped(id: String)

var M: FarmMain   # the main screen (null in tests)
var G: FarmGame   # the rules (G.people)
var _figs := {}   # id -> {"scene", "holder", "body", "hit", "height", "points", "idx", "state", "t", "bubble", "text", "goal", "leave", "secs"}
var _ground := _Ground.new()
var _rng := RandomNumberGenerator.new()      # for how long a figure stands: NOT the game's random numbers
var _last := 0
var _hooked := false

func _init(main: FarmMain = null) -> void:
	M = main
	G = main.G if main != null else Engine.get_main_loop().root.get_node("/root/Game")
	_rng.randomize()
	_ground.sorter = _sort_from

# ------------------------------------------------------------------ the interface

## Puts a person into a scene with the feet at `at` and `height` pixels tall (the same id again only moves and resizes it).
func put(id: String, scene: Control, at: Vector2, height: float) -> Control:
	if _figs.has(id) and _figs[id]["scene"] != scene: take(id)
	if not _figs.has(id):
		var holder := Control.new()               # scales the figure; its own size is nothing
		holder.name = "figure_" + id
		holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
		scene.add_child(holder)
		var body := _make_body(G.people.person(id).get("look", {}))
		holder.add_child(body)
		var f := {"scene": scene, "holder": holder, "body": body, "height": height, "points": [], "idx": 0, "state": "stand", "t": 0.0, "bubble": null, "text": "", "goal": null, "leave": false, "secs": 2.0}
		f["hit"] = _make_hit(body, id)
		_figs[id] = f
		_hook(scene)
	var fg: Dictionary = _figs[id]
	fg["height"] = height
	_apply(fg, at)
	_sort(scene)
	return fg["holder"]

## Lets a figure wander between these points of its scene: walk to one, stand 2 to 5 seconds, walk to the next.
## The ways are straight lines, so choose points no line between crosses something.
func stroll(id: String, points: Array) -> void:
	if not _figs.has(id): return
	var f: Dictionary = _figs[id]
	f["goal"] = null
	f["points"] = points.duplicate()
	f["idx"] = 0
	f["state"] = "wait" if points.size() >= 2 else "stand"
	f["t"] = 0.5

## Sends a figure straight to a point of its scene in about `secs` seconds, where it then stands, turned to the front. With `leave` it is
## taken out of its scene when it gets there (somebody going away). A tap on the way stops it for its line, then it goes on.
func walk_to(id: String, to: Vector2, secs := 2.0, leave := false) -> void:
	if not _figs.has(id): return
	var f: Dictionary = _figs[id]
	f["points"] = []
	f["goal"] = to
	f["leave"] = leave
	f["secs"] = maxf(0.2, secs)
	_go(f)

## When a scene is laid out for a new size every figure in it keeps its relative place, height and strolling points.
func move_all(scene: Control, from_box: Vector2, to_box: Vector2) -> void:
	if from_box.x <= 0.0 or from_box.y <= 0.0 or to_box.is_equal_approx(from_box): return
	var r := Vector2(to_box.x / from_box.x, to_box.y / from_box.y)
	for id in ids(scene):
		var f: Dictionary = _figs[id]
		var at := feet(id) * r
		var pts := []
		for p in f["points"]: pts.append(p * r)
		f["points"] = pts
		f["height"] = float(f["height"]) * r.x      # like the pictures of a scene, a figure is sized by the scene's width
		_body_stop(f)
		_apply(f, at)
		if f["goal"] != null:
			f["goal"] = f["goal"] * r
			_go(f)
		elif f["state"] == "walk": f["state"] = "wait"; f["t"] = 0.2

## Takes a person out of their scene.
func take(id: String) -> void:
	if not _figs.has(id): return
	var f: Dictionary = _figs[id]
	_drop_bubble(f)
	if is_instance_valid(f["holder"]):
		if f["holder"].get_parent() != null: f["holder"].get_parent().remove_child(f["holder"])
		f["holder"].queue_free()
	_figs.erase(id)

## Takes everybody out of a scene.
func clear(scene: Control) -> void:
	for id in ids(scene): take(id)

## The people standing in a scene.
func ids(scene: Control) -> Array:
	var out := []
	for id in _figs:
		if _figs[id]["scene"] == scene: out.append(id)
	return out

## Where a person's feet are, in their scene (Vector2.ZERO when not there).
func feet(id: String) -> Vector2:
	if not _figs.has(id): return Vector2.ZERO
	var f: Dictionary = _figs[id]
	return _feet_of(f)

## What the person's speech bubble says now ("" when there is none).
func saying(id: String) -> String:
	return str(_figs[id]["text"]) if _figs.has(id) and _figs[id]["bubble"] != null else ""

## One step of time (called every frame once a figure stands somewhere; the tests call it themselves).
func step(d: float) -> void:
	for id in _figs.keys():
		var f: Dictionary = _figs[id]
		if not is_instance_valid(f["scene"]) or not is_instance_valid(f["holder"]):
			_figs.erase(id)
			continue
		f["t"] = float(f["t"]) - d
		match str(f["state"]):
			"talk":
				if float(f["t"]) <= 0.0:
					_drop_bubble(f)
					if f["goal"] != null:
						_go(f)                      # it was on its way: it goes on
					else:
						f["state"] = "wait" if f["points"].size() >= 2 else "stand"
						f["t"] = 1.0
			"wait":
				if float(f["t"]) <= 0.0 and f["points"].size() >= 2:
					f["idx"] = (int(f["idx"]) + 1) % f["points"].size()
					_body_walk(f, f["points"][f["idx"]])
					f["state"] = "walk"
			"walk":
				if not _body_moving(f):
					_body_face_front(f)
					if f["goal"] != null:           # it got where it was sent
						f["goal"] = null
						_apply(f, _feet_of(f))      # its ordinary pace again
						if bool(f["leave"]):
							take(id)
							continue
						f["state"] = "stand"
					else:
						f["state"] = "wait"
						f["t"] = _rng.randf_range(STAND.x, STAND.y)
		_place_bubble(f)

## Sends the figure to its goal at the pace that gets it there in its `secs` (the body's pace is in the rig's own pixels).
func _go(f: Dictionary) -> void:
	var s := float(f["holder"].scale.x)
	f["body"].speed = _feet_of(f).distance_to(f["goal"]) / float(f["secs"]) / s
	_body_walk(f, f["goal"])
	f["state"] = "walk"

# ------------------------------------------------------------------ taps

## A tap on a figure: it stops, turns to the farmer, waves, says its line, a small sound; the scene is told.
func _tapped(id: String) -> void:
	if not _figs.has(id): return
	var f: Dictionary = _figs[id]
	_body_stop(f)
	_body_greet(f)
	f["state"] = "talk"
	f["t"] = SAY_TIME
	f["text"] = G.people.line(id)
	_show_bubble(f)
	Sound.play("pop")
	tapped.emit(id)

# ------------------------------------------------------------------ the speech bubble (a rounded paper box with a small tail, inside the scene's edges)

func _show_bubble(f: Dictionary) -> void:
	var text := str(f["text"])
	_drop_bubble(f)
	var scene: Control = f["scene"]
	if text == "": return
	var font := ThemeDB.fallback_font
	var maxw := maxf(120.0, minf(260.0, scene.size.x - 40.0))
	var w := minf(font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, FONT).x + 2.0, maxw)
	var lab := UI.label(text, FONT, UI.INK, true)
	lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lab.custom_minimum_size = Vector2(w, font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, w, FONT).y)
	var b := PanelContainer.new()
	b.name = "bubble"
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_theme_stylebox_override("panel", UI.box(UI.PAPER, 14, UI.LINE, 2, 8))
	b.add_child(lab)
	for k in 2:                                 # the tail: a line-coloured triangle with a paper one on it
		var t := Polygon2D.new()
		t.name = "tail%d" % k
		t.color = UI.LINE if k == 0 else UI.PAPER
		b.add_child(t)
	scene.add_child(b)
	b.size = b.get_combined_minimum_size()
	f["bubble"] = b
	f["text"] = text
	_place_bubble(f)

func _place_bubble(f: Dictionary) -> void:
	var b = f["bubble"]
	if b == null: return
	if not is_instance_valid(b):
		f["bubble"] = null
		return
	var scene: Control = f["scene"]
	var at := _feet_of(f)
	var bs: Vector2 = b.size
	var x := clampf(at.x - bs.x / 2.0, 4.0, maxf(4.0, scene.size.x - bs.x - 4.0))
	var y := clampf(at.y - float(f["height"]) - bs.y - 12.0, 4.0, maxf(4.0, scene.size.y - bs.y - 4.0))
	b.position = Vector2(x, y)
	var tx := clampf(at.x - x, 16.0, maxf(16.0, bs.x - 16.0))
	for k in 2:
		var o := 2.0 if k == 0 else 0.0
		b.get_node("tail%d" % k).polygon = PackedVector2Array([Vector2(tx - 8.0 - o, bs.y - 2.0 + o * 0.0), Vector2(tx + 8.0 + o, bs.y - 2.0), Vector2(tx, bs.y + 10.0 + o)])

func _drop_bubble(f: Dictionary) -> void:
	var b = f["bubble"]
	f["bubble"] = null
	f["text"] = ""
	if b != null and is_instance_valid(b):
		if b.get_parent() != null: b.get_parent().remove_child(b)
		b.queue_free()

# ------------------------------------------------------------------ housekeeping

func _hook(scene: Control) -> void:
	if _hooked: return
	_hooked = true
	_last = Time.get_ticks_msec()
	scene.get_tree().process_frame.connect(_frame)

func _frame() -> void:
	var now := Time.get_ticks_msec()
	var d := minf(0.1, float(now - _last) / 1000.0)
	_last = now
	step(d)

## The figure's feet in its scene.
func _feet_of(f: Dictionary) -> Vector2:
	return _body_feet(f) * float(f["holder"].scale.x)

## Stands the figure with its feet at `at` and `height` tall.
func _apply(f: Dictionary, at: Vector2) -> void:
	var s := maxf(0.05, float(f["height"]) / BODY_H)
	f["holder"].scale = Vector2(s, s)
	_body_set(f, at / s, WALK_H * float(f["height"]) / s)

## Keeps the figures of a scene in order: the one lower on the screen is in front; the bubbles on top.
func _sort(scene: Control) -> void:
	var list := []
	for id in ids(scene): list.append(_figs[id])
	list.sort_custom(func(a, b): return _feet_of(a).y < _feet_of(b).y)
	for f in list: scene.move_child(f["holder"], -1)
	for f in list:
		if f["bubble"] != null and is_instance_valid(f["bubble"]): scene.move_child(f["bubble"], -1)

func _sort_from(node: Node) -> void:
	var holder := node.get_parent()
	if holder != null and holder.get_parent() is Control: _sort(holder.get_parent())

## What the rig asks of its ground: a way (here a straight line) and a place among the standing things.
class _Ground extends RefCounted:
	var sorter := Callable()
	func find_path(from: Vector2, to: Vector2) -> PackedVector2Array:
		return PackedVector2Array([from, to])
	func sort_in(node: Node, _y: float) -> void:
		if sorter.is_valid(): sorter.call(node)

# ------------------------------------------------------------------ how a figure is drawn: ONLY here (today the farmer's 3D rig)

func _make_body(look: Dictionary) -> Control:
	var b := Avatar.new()
	b.map = _ground
	b.set_look(look)
	return b

## A tap area over the body (it takes the press too, so nothing behind it hears the tap).
func _make_hit(body: Control, id: String) -> Control:
	var h := Control.new()
	h.mouse_filter = Control.MOUSE_FILTER_STOP
	h.position = Vector2(Avatar.SHOW.x * 0.33, Avatar.SHOW.y * 0.05)
	h.size = Vector2(Avatar.SHOW.x * 0.34, Avatar.SHOW.y * 0.9)
	h.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			h.accept_event()
			if not e.pressed: _tapped(id))
	body.add_child(h)
	return h

func _body_set(f: Dictionary, at: Vector2, speed: float) -> void:
	f["body"].speed = speed
	f["body"].set_feet(at)

func _body_feet(f: Dictionary) -> Vector2: return f["body"].feet
func _body_moving(f: Dictionary) -> bool: return f["body"].moving
func _body_walk(f: Dictionary, p: Vector2) -> void: f["body"].walk_to(p / float(f["holder"].scale.x))
func _body_stop(f: Dictionary) -> void: f["body"].stop_walking()
func _body_greet(f: Dictionary) -> void: f["body"].greet()
func _body_face_front(f: Dictionary) -> void: f["body"].face_point(f["body"].feet + Vector2(0, 100))
