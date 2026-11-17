extends HFlowContainer
## "Make your farmer": a control that offers exactly what the look data offers (data/avatar.json "options": skin, hair style and colour, shirt style and
## colour, trousers style and colour, hat) and shows the figure as it is now. No words, the child may not read: a colour is a round swatch, a style is a
## small figure with only that part changed (drawn by the same figure code as the farm's farmer, kits/avatar/avatar.gd), and the figure itself stands big
## beside them. Nothing says boy or girl: hair and clothes are chosen one by one.
## It holds no game logic: it keeps `look` (what is chosen: only the parts that can be chosen, as avatar.gd's set_look takes them) and says
## `changed(look)`. Whoever hosts it decides what happens with the look (the game keeps it in the farm save: game/farm/ui/welcome.gd).
##   var p := AvatarPicker.new()          # starts with the default look; p.set_look(look) to start from another
##   host.add_child(p);  p.changed.connect(...);  p.look;  p.side.add_child(my_button)      # `side`: a column under the figure for the host's own button
##   p.rows() / p.offered("skin") / p.tile("skin", "#d9a17a") / p.choose("skin", "#d9a17a") / p.chosen("skin")      # what a tap on a tile does, for hosts and tests

const Avatar = preload("res://kits/avatar/avatar.gd")
const UI = preload("res://kits/ui/ui.gd")

signal changed(look: Dictionary)

## The rows, top to bottom. id: the key of the list in the data's "options"; slot / key: the part of the look the choice sets (key "" = the slot is
## the value itself); show: "swatch" (a round colour) or "figure" (a small figure with that part changed, framed on `frame`).
const ROWS := [
	{"id": "skin", "slot": "skin", "key": "", "options": "skin", "show": "swatch"},
	{"id": "hairStyle", "slot": "hair", "key": "style", "options": "hairStyle", "show": "figure", "frame": "head"},
	{"id": "hairColor", "slot": "hair", "key": "color", "options": "hairColor", "show": "swatch"},
	{"id": "shirtStyle", "slot": "shirt", "key": "style", "options": "shirtStyle", "show": "figure", "frame": "body"},
	{"id": "shirtColor", "slot": "shirt", "key": "color", "options": "clothes", "show": "swatch"},
	{"id": "trousersStyle", "slot": "trousers", "key": "style", "options": "trousersStyle", "show": "figure", "frame": "legs"},
	{"id": "trousersColor", "slot": "trousers", "key": "color", "options": "clothes", "show": "swatch"},
	{"id": "hatStyle", "slot": "hat", "key": "style", "options": "hatStyle", "show": "figure", "frame": "head"},
]
## What a small figure shows: a part of the figure's 200 x 200 picture (avatar.gd VIEW).
const FRAMES := {"head": Rect2(48, 2, 104, 104), "body": Rect2(45, 70, 110, 110), "legs": Rect2(45, 90, 110, 110)}
const ZOOM_OUT := 2.2                # the camera's size (avatar.gd: 1.95): a little more room, so a hat is not cut off at the top
const SWATCH := 42.0
const TILE := 62.0
const PREVIEW := 220.0
const GAP := 6
const RING := Color("2f2a1f")

var look := {}                     # what is chosen now
var preview: Avatar                # the big figure
var side: VBoxContainer            # under the big figure: the host may put its own button here
var _default := {}                 # the data's default look
var _options := {}                 # the data's lists
var _tiles := {}                   # row id -> [{"value", "button", "face"}]

func _init() -> void:
	var d = JSON.parse_string(FileAccess.get_file_as_string(Avatar.LOOK_PATH))
	var data: Dictionary = d if typeof(d) == TYPE_DICTIONARY else {}
	_default = data.get("default", {})
	_options = data.get("options", {})
	look = _parts_of(_default)
	alignment = FlowContainer.ALIGNMENT_CENTER
	add_theme_constant_override("h_separation", 18)
	add_theme_constant_override("v_separation", 14)
	_build()
	_after_change(false)

# ------------------------------------------------------------------ what it offers and what is chosen

## The ids of the rows, top to bottom.
func rows() -> Array:
	var out := []
	for r in ROWS: out.append(str(r["id"]))
	return out

## What a row offers (the data's list, in its order).
func offered(row_id: String) -> Array:
	return (_options.get(str(_row(row_id).get("options", "")), []) as Array).duplicate()

## What is chosen in a row now.
func chosen(row_id: String) -> Variant:
	return _value_of(_row(row_id), look)

## The tile of one offered value (null when the row does not offer it).
func tile(row_id: String, value: Variant) -> Button:
	for t in _tiles.get(row_id, []):
		if _same(t["value"], value): return t["button"]
	return null

## What a tap on a tile does: the figure takes it. Only what is offered can be chosen.
func choose(row_id: String, value: Variant) -> void:
	if tile(row_id, value) == null: return
	look = _apply(look, _row(row_id), value)
	_after_change(true)

## Starts from another look (parts it lacks keep the default).
func set_look(lk: Dictionary) -> void:
	look = _parts_of(_default)
	var mine := _parts_of(lk)
	for slot in mine: look[slot] = mine[slot]
	_after_change(false)

# ------------------------------------------------------------------ the look
func _row(id: String) -> Dictionary:
	for r in ROWS:
		if r["id"] == id: return r
	return {}

## Only the parts that can be chosen (never the style of the drawing, the eyes or the shoes: those stay the data's).
func _parts_of(src: Dictionary) -> Dictionary:
	var out := {}
	for r in ROWS:
		var slot := str(r["slot"])
		if src.has(slot): out[slot] = src[slot].duplicate(true) if typeof(src[slot]) == TYPE_DICTIONARY else src[slot]
	return out

func _value_of(row: Dictionary, lk: Dictionary) -> Variant:
	if row.is_empty(): return null
	var slot := str(row["slot"])
	if row["key"] == "": return lk.get(slot, "")
	return (lk.get(slot, {}) as Dictionary).get(str(row["key"]), "")

func _same(a: Variant, b: Variant) -> bool:
	return str(a).to_lower() == str(b).to_lower()

func _has_row(slot: String, key: String) -> bool:
	for r in ROWS:
		if r["slot"] == slot and r["key"] == key: return true
	return false

## A look with one choice made. A new style keeps the colour chosen for its part; a part that has no colour to choose (the hat) takes the colours the
## data's default gives that style, if it has them (the straw hat's band).
func _apply(lk: Dictionary, row: Dictionary, v: Variant) -> Dictionary:
	var out := lk.duplicate(true)
	var slot := str(row["slot"])
	var key := str(row["key"])
	if key == "":
		out[slot] = v
		return out
	var part: Dictionary = (out.get(slot, {}) as Dictionary).duplicate(true)
	if key == "style":
		var np := {"style": v}
		var def_part: Dictionary = _default.get(slot, {})
		if _has_row(slot, "color"): np["color"] = part.get("color", def_part.get("color", ""))
		elif str(def_part.get("style", "")) == str(v): np = def_part.duplicate(true)
		part = np
	else:
		part[key] = v
	out[slot] = part
	return out

## The look a small figure shows for an offered value: the look as it is, with only that value changed (and no hat over the hair being chosen).
func _thumb_look(row: Dictionary, v: Variant) -> Dictionary:
	var out := _apply(look, row, v)
	if row["slot"] == "hair": out["hat"] = {"style": "none"}
	return out

# ------------------------------------------------------------------ what it draws
func _build() -> void:
	side = VBoxContainer.new()
	side.add_theme_constant_override("separation", 10)
	add_child(side)
	var stage := Panel.new()
	stage.custom_minimum_size = Vector2(PREVIEW, PREVIEW)
	stage.add_theme_stylebox_override("panel", UI.box(UI.PAPER, 28, UI.LINE, 3, 0))
	side.add_child(stage)
	preview = Avatar.new()
	preview.ready.connect(_preview_ready.bind(preview))
	stage.add_child(preview)
	var col := VBoxContainer.new()
	col.custom_minimum_size = Vector2(SWATCH * 9 + GAP * 8 + 26, 0)
	col.add_theme_constant_override("separation", 10)
	add_child(col)
	var card: VBoxContainer = null
	var last_slot := ""
	for row in ROWS:
		if row["slot"] != last_slot:              # a card for each part (hair has two rows)
			last_slot = str(row["slot"])
			var pc := PanelContainer.new()
			pc.add_theme_stylebox_override("panel", UI.box(Color("fff5df"), 18, UI.LINE, 2, 10))
			col.add_child(pc)
			card = VBoxContainer.new()
			card.add_theme_constant_override("separation", 8)
			pc.add_child(card)
		var flow := HFlowContainer.new()
		flow.add_theme_constant_override("h_separation", GAP)
		flow.add_theme_constant_override("v_separation", GAP)
		card.add_child(flow)
		_tiles[row["id"]] = []
		for v in _options.get(str(row["options"]), []):
			var b := _make_tile(row, v)
			flow.add_child(b)

func _make_tile(row: Dictionary, v: Variant) -> Button:
	var swatch: bool = row["show"] == "swatch"
	var b := Button.new()
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_filter = Control.MOUSE_FILTER_PASS          # a finger drag still scrolls the window
	var edge := SWATCH if swatch else TILE
	b.custom_minimum_size = Vector2(edge, edge)
	b.pressed.connect(_tapped.bind(str(row["id"]), v))
	var face: Avatar = null
	if not swatch:
		var clip := Control.new()
		clip.clip_contents = true
		clip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		clip.position = Vector2(5, 5)
		clip.size = Vector2(edge - 10, edge - 10)
		b.add_child(clip)
		face = Avatar.new()
		var rect: Rect2 = FRAMES[str(row["frame"])]
		face.ready.connect(_face_ready.bind(face, rect, edge - 10.0))
		clip.add_child(face)
	_tiles[row["id"]].append({"value": v, "button": b, "face": face})
	return b

## The big figure is in the tree (avatar.gd sets its own size and place first, so this comes after).
func _preview_ready(a: Avatar) -> void:
	a.vp.size = Vector2i(Avatar.VIEW) * 2          # sharper than on the map: it is shown big
	a.cam.size = ZOOM_OUT
	a.size = Vector2(PREVIEW, PREVIEW)
	a.position = Vector2.ZERO

## A small figure is in the tree: still, facing front, drawn once per look, showing only its frame of the picture.
func _face_ready(a: Avatar, rect: Rect2, px: float) -> void:
	a.mouse_filter = Control.MOUSE_FILTER_IGNORE
	a.set_process(false)
	a.cam.size = ZOOM_OUT
	a.vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	var k := px / rect.size.x
	a.size = Vector2(Avatar.VIEW) * k
	a.position = -rect.position * k

func _tapped(row_id: String, v: Variant) -> void:
	Sound.play("tap")
	choose(row_id, v)

func _after_change(wave: bool) -> void:
	preview.set_look(look.duplicate(true))
	if wave: preview.greet()
	for r in ROWS:
		for t in _tiles.get(r["id"], []):
			var b: Button = t["button"]
			var on: bool = _same(t["value"], _value_of(r, look))
			var swatch: bool = r["show"] == "swatch"
			var bg: Color = Color(str(t["value"])) if swatch else UI.PAPER
			var rad := int(SWATCH / 2.0) if swatch else 16
			var sb := UI.box(bg, rad, RING if on else UI.LINE, 5 if on else 2, 0)
			var sp := UI.box(bg.darkened(0.12), rad, RING if on else UI.LINE, 5 if on else 2, 0)
			for st in ["normal", "hover", "focus", "disabled"]: b.add_theme_stylebox_override(st, sb)
			b.add_theme_stylebox_override("pressed", sp)
			var face: Avatar = t["face"]
			if face != null:
				face.set_look(_thumb_look(r, t["value"]))
				if face.vp != null: face.vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	changed.emit(look.duplicate(true))
