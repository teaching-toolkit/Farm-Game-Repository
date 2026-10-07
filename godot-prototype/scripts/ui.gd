extends RefCounted
## Small UI helpers: colours, buttons, labels, panels. Use as:  const UI = preload("res://scripts/ui.gd")

const INK := Color("2f2a1f")
const MUTED := Color("7a705c")
const PAPER := Color("fffaf0")
const BG := Color("efe8d6")
const GREEN := Color("4f8a34")
const GREEN_DARK := Color("3b6a26")
const RED := Color("b9472f")
const AMBER := Color("c98a12")
const BLUE := Color("3f7fb5")
const SOIL := Color("8a5a2b")
const LINE := Color("d9cfb8")
## Tapping a bar shows a very short explanation of it: the game sets this (text -> shows it as a little note).
static var explain_hook: Callable

## Makes a bar (or any small display) explain itself when tapped: a one-line note, and the same text as tooltip.
## A finger dragging over it still scrolls the list.
static func explain(c: Control, text: String) -> Control:
	c.tooltip_text = text
	c.set_meta("explain", text)
	c.mouse_filter = Control.MOUSE_FILTER_PASS
	c.gui_input.connect(func(e): _explain_input(e, c))
	return c

static func _explain_input(e: InputEvent, c: Control) -> void:
	if not (e is InputEventMouseButton) or e.button_index != MOUSE_BUTTON_LEFT: return
	if e.pressed:
		c.set_meta("explain_down", e.position)
	elif e.position.distance_to(c.get_meta("explain_down", Vector2(-999, -999))) < 16.0 and explain_hook.is_valid():
		explain_hook.call(str(c.get_meta("explain", "")))

const SEASON_BG := {"spring": Color("e7f1d8"), "summer": Color("f4efc8"), "autumn": Color("f3e0c6"), "winter": Color("e6edf3")}

static func box(bg: Color, radius := 12, border := Color(0, 0, 0, 0), bw := 0, pad := 8) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_corner_radius_all(radius)
	if bw > 0:
		s.border_color = border
		s.set_border_width_all(bw)
	s.content_margin_left = pad; s.content_margin_right = pad
	s.content_margin_top = pad * 0.6; s.content_margin_bottom = pad * 0.6
	return s

static func label(text: String, size := 17, color := INK, wrap := false) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	if wrap:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return l

static func rich(bb: String, size := 16) -> RichTextLabel:
	var r := RichTextLabel.new()
	r.bbcode_enabled = true
	r.fit_content = true
	r.scroll_active = false
	r.text = bb
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.add_theme_font_size_override("normal_font_size", size)
	r.add_theme_font_size_override("bold_font_size", size)
	r.add_theme_color_override("default_color", INK)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r

static func button(text: String, cb: Callable, enabled := true, color := GREEN, size := 16) -> Button:
	var b := Button.new()
	b.text = text
	b.disabled = not enabled
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_filter = Control.MOUSE_FILTER_PASS   # lets a finger drag scroll the list; a drag cancels the press
	b.custom_minimum_size = Vector2(0, 40)
	b.add_theme_font_size_override("font_size", size)
	b.add_theme_color_override("font_color", Color.WHITE)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", Color.WHITE)
	b.add_theme_color_override("font_disabled_color", Color(1, 1, 1, 0.75))
	b.add_theme_stylebox_override("normal", box(color, 10, Color(0, 0, 0, 0), 0, 10))
	b.add_theme_stylebox_override("hover", box(color.lightened(0.12), 10, Color(0, 0, 0, 0), 0, 10))
	b.add_theme_stylebox_override("pressed", box(color.darkened(0.15), 10, Color(0, 0, 0, 0), 0, 10))
	b.add_theme_stylebox_override("disabled", box(Color("b8af9c"), 10, Color(0, 0, 0, 0), 0, 10))
	if cb.is_valid():
		b.pressed.connect(cb)
	return b

static func soft_button(text: String, cb: Callable, enabled := true, size := 15) -> Button:
	var b := button(text, cb, enabled, Color("e9dfc8"), size)
	b.add_theme_color_override("font_color", INK)
	b.add_theme_color_override("font_hover_color", INK)
	b.add_theme_color_override("font_pressed_color", INK)
	b.add_theme_color_override("font_disabled_color", MUTED)
	return b

static func card(bg := PAPER, border := LINE) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", box(bg, 12, border, 1, 10))
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.mouse_filter = Control.MOUSE_FILTER_PASS
	return p

static func hbox(sep := 8) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", sep)
	return h

static func vbox(sep := 6) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", sep)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return v

static func spacer() -> Control:
	var c := Control.new()
	c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return c

static func heading(text: String) -> Label:
	var l := label(text, 19, INK)
	return l

static func bar(frac: float, w := 120, h := 10, color := GREEN) -> ProgressBar:
	var p := ProgressBar.new()
	p.min_value = 0.0; p.max_value = 1.0; p.value = clampf(frac, 0.0, 1.0)
	p.show_percentage = false
	p.custom_minimum_size = Vector2(w, h)
	p.add_theme_stylebox_override("background", box(Color("e4dbc6"), 5, Color(0, 0, 0, 0), 0, 0))
	p.add_theme_stylebox_override("fill", box(color, 5, Color(0, 0, 0, 0), 0, 0))
	return p

## A small rounded label with a coloured background (map names, badges, chips).
static func pill(text: String, size := 14, bg := Color(1, 0.98, 0.92, 0.92), fg := INK) -> PanelContainer:
	var p := PanelContainer.new()
	var st := box(bg, 12, Color(0, 0, 0, 0.25), 1, 6)
	st.content_margin_top = 1; st.content_margin_bottom = 1
	p.add_theme_stylebox_override("panel", st)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var l := label(text, size, fg)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	p.add_child(l)
	return p

## One straight side of a diamond (fence, wall, border) from a to b: the picture as it is for a side rising to the right,
## mirrored for one falling to the right; without a picture a coloured line (with posts for a fence).
## fallback = [colour, thickness].
static func iso_side(ci: CanvasItem, a: Vector2, b: Vector2, tex: Texture2D, fallback: Array, posts: bool) -> void:
	if tex:
		var w := absf(b.x - a.x)
		var h := w * float(tex.get_height()) / float(tex.get_width())
		var mid := (a + b) / 2.0
		var topy := mid.y - (h - w / 4.0)
		if (b.x - a.x) * (b.y - a.y) > 0.0:     # falls to the right: mirror
			ci.draw_set_transform(Vector2(mid.x, 0.0), 0.0, Vector2(-1.0, 1.0))
			ci.draw_texture_rect(tex, Rect2(Vector2(-w / 2.0, topy), Vector2(w, h)), false)
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			ci.draw_texture_rect(tex, Rect2(Vector2(mid.x - w / 2.0, topy), Vector2(w, h)), false)
		return
	var col: Color = fallback[0]
	var th: float = fallback[1]
	if posts:
		var up := Vector2(0, -th * 2.2)
		ci.draw_line(a + up, b + up, col, th * 0.6)
		ci.draw_line(a + up * 0.45, b + up * 0.45, col, th * 0.6)
		for t in [0.0, 0.5, 1.0]:
			var pt: Vector2 = a.lerp(b, t)
			ci.draw_rect(Rect2(pt - Vector2(th * 0.5, th * 3.0), Vector2(th, th * 3.0)), col.darkened(0.25))
	else:
		ci.draw_line(a, b, col, th)

# ------------------------------------------------------------------ things shown as pictures instead of numbers
## Colour of an item's cubes. An item in the data can set its own ("color": "#rrggbb").
const ITEM_COLORS := {
	"energy": "f2c230", "water": "4aa3df", "coins": "e0b13a", "fuel": "a0642c",
	"stick": "9a6b3c", "log": "7a5230", "plank": "c99a5b", "hardwood": "6b4426", "stone": "9a9a92", "fiber": "7fae4a",
	"rope": "c8a46a", "straw": "e3c565", "clay": "b8734a", "brick": "b5523b", "charcoal": "3d3a38", "iron_ore": "8a6f5f",
	"iron": "7d8790", "nails": "a9b0b6", "steel": "9fb3c4", "sand": "e6d39a", "glass": "a8dcef", "ash": "b7b5b0",
	"compost": "5e4128", "manure": "6b4a2b", "worm_castings": "4a3324", "wheat": "e8c24a", "oats": "d9c27a",
	"carrot": "ee8a2b", "clover": "4f9f45", "onion": "d9a86b", "potato": "c6a067", "lettuce": "8cc63f", "beans": "8a5a3c",
	"tomato": "e0452e", "beet": "8e2f5a", "sunflower": "f4c21e", "flax": "8f7cc9", "pumpkin": "f08c22", "berries": "4e5ab8",
	"herbs": "5f9e4a", "apple": "d93b30", "walnut": "8a6a44", "olive": "6f7d33", "saffron": "c03ea3", "egg": "f3ead8",
	"milk": "f6f6f0", "wool": "efe8dc", "honeycomb": "f2b230", "honey": "e9a21c", "salt": "f0f0f0", "flour": "f1e9d2",
	"butter": "f6e27a", "bread": "c98b3d", "porridge": "e6d2a8", "feather": "f2f2f2", "beeswax": "f0cf6a", "yarn": "d8cfe8",
}
const CAT_COLORS := {"crop": "8cbf4a", "dish": "d9925a", "ingredient": "e3c58a", "material": "a08c74", "textile": "c9b4d9",
	"fertilizer": "5e4128", "feed": "c2a86a", "animal": "efe3c8", "seed": "a3c26a", "pet-item": "e6a9b8", "byproduct": "b0a090"}

static func item_color(k: String, items := {}) -> Color:
	var it: Dictionary = items.get(k, {})
	if it.has("color"): return Color(str(it["color"]))
	if ITEM_COLORS.has(k): return Color(ITEM_COLORS[k])
	return Color(CAT_COLORS.get(str(it.get("category", "")), "b8a888"))

## A picture for the kind of work a button does (instead of words like "Make").
const ACTION := {"gather": "💪", "weed": "💪", "field": "💪", "plant": "🌱", "harvest": "🧺", "wood": "🪓", "craft": "🤏",
	"build": "🔨", "smith": "🔨", "kiln": "🔥", "cook": "🍲", "prep": "🔪", "mill": "⚙️", "process": "🫙", "textile": "🧶",
	"animal": "🧺", "errand": "🤝"}

## One word that says what the button does (the recipes and goals have their own word in the data: "verb").
const WORD := {"gather": "Gather", "weed": "Pull", "field": "Clear", "plant": "Plant", "harvest": "Harvest", "wood": "Chop",   # i18n
	"craft": "Craft", "build": "Build", "smith": "Forge", "kiln": "Fire", "cook": "Cook", "prep": "Chop", "mill": "Grind",   # i18n
	"process": "Press", "textile": "Weave", "animal": "Collect", "errand": "Deliver"}   # i18n

## A green button with a picture and one word: "💪 Gather", "🤏 Twist", "🍲 Cook" (word "-" = the picture only).
static func action_button(cat: String, cb: Callable, enabled := true, color := GREEN, emoji := "", word := "") -> Button:
	var pic := emoji if emoji != "" else str(ACTION.get(cat, "💪"))
	if word == "": word = str(WORD.get(cat, ""))
	word = TranslationServer.translate(word)
	if word == "-": word = ""
	var b := button(pic + ("  " + word if word != "" else ""), cb, enabled, color, 22 if word != "" else 26)
	b.custom_minimum_size = Vector2(118 if word != "" else 72, 52)
	return b

## A grey button with an hourglass and the number of Time Quiz questions still to wait. Pressing it opens the quiz.
static func wait_button(questions: int, cb: Callable, size := 17) -> Button:
	var b := button("⏳ %d" % maxi(1, questions), cb, true, Color("a59c8a"), size)
	b.tooltip_text = (TranslationServer.translate("Wait %d Time Quiz question") if questions == 1 else TranslationServer.translate("Wait %d Time Quiz questions")) % questions
	b.custom_minimum_size = Vector2(86, 48)
	return b

## A big picture (or a big emoji when there is none) at the top of a sheet or pop-up.
static func header(tex: Texture2D, emoji := "", h := 110.0, tint := Color.WHITE, glow := false) -> Control:
	var box := CenterContainer.new()
	box.custom_minimum_size = Vector2(0, h)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var holder := Control.new()
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(holder)
	if glow:
		var g := Panel.new()
		var gs := StyleBoxFlat.new()
		gs.bg_color = Color(1, 0.86, 0.35, 0.35)
		gs.set_corner_radius_all(int(h / 2.0))
		gs.shadow_color = Color(1, 0.8, 0.2, 0.45)
		gs.shadow_size = 18
		g.add_theme_stylebox_override("panel", gs)
		g.mouse_filter = Control.MOUSE_FILTER_IGNORE
		g.size = Vector2(h * 0.9, h * 0.9)
		g.position = -g.size / 2.0
		holder.add_child(g)
	if tex:
		var tr := TextureRect.new()
		tr.texture = tex
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.size = Vector2(h * 1.6, h)
		tr.position = -tr.size / 2.0
		tr.modulate = tint
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		holder.add_child(tr)
	else:
		var l := label(emoji, int(h * 0.62))
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.size = Vector2(h * 1.6, h)
		l.position = -l.size / 2.0
		l.modulate = tint
		holder.add_child(l)
	return box

## A row of cube bars, one per key of a cost: [icon] ■■■□□ ▫▫  (filled = you have it, hollow = still missing,
## faint grey = what upgrades, practice and meals save compared with the first time). keys: energy, water, coins, items.
static func cost_row(c: Dictionary, base: Dictionary, have: Callable, emoji: Callable, items := {}) -> HFlowContainer:
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 14)
	row.add_theme_constant_override("v_separation", 4)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for k in c:
		var need := float(c[k])
		if need <= 0.0: continue
		var item := hbox(3)
		item.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item.add_child(label(str(emoji.call(k)), 18))
		var cb := CubeBar.new()
		cb.mode = "cost"
		cb.need = need
		cb.have = float(have.call(k))
		cb.saved = maxf(0.0, float(base.get(k, need)) - need)
		cb.color = item_color(k, items)
		item.add_child(cb)
		row.add_child(item)
	return row

## Cubes for a stock: filled for what you have, empty slots up to what fits.
static func stock_bar(have: float, cap: float, col: Color, max_w := 260.0) -> Control:
	var cb := CubeBar.new()
	cb.mode = "stock"
	cb.have = have
	cb.cap = cap
	cb.color = col
	cb.max_w = max_w
	return cb

## Quantities as little cubes in the item's colour (whole cubes, a partly filled one for halves). Up to 10 cubes in a row;
## more make more rows of smaller cubes (10 × 10 at most); beyond that one cube stands for 5, 10, 25 … (shown as ×5 …).
## A small number stands next to the cubes: how many you have (stock) or how many it takes (cost; red while missing).
class CubeBar extends Control:
	var mode := "stock"       # stock: have / cap · cost: need (filled up to have, hollow beyond) + saved (grey)
	var have := 0.0
	var cap := 0.0
	var need := 0.0
	var saved := 0.0
	var color := Color("e8c24a")
	var max_w := 240.0
	var show_num := true
	var num_text := ""        # instead of the automatic number
	var num_size := 14
	var unit := 1.0
	var cube := 16.0
	var per_row := 10
	var rows := 1
	var _cells := 0
	var _num_w := 0.0

	func _ready() -> void:
		if not has_meta("explain"): mouse_filter = Control.MOUSE_FILTER_IGNORE
		_layout()

	## Call after changing have / cap / need.
	func refresh() -> void:
		_layout()

	func _number() -> String:
		if num_text != "": return num_text
		if mode == "stock": return str(int(floorf(have + 0.0001)))
		return str(int(ceilf(need - 0.0001)))

	func _layout() -> void:
		var total := ceilf(cap) if mode == "stock" else ceilf(need) + ceilf(saved - 0.001)
		if mode == "stock": total = maxf(total, ceilf(have))
		unit = 1.0
		for u in [1.0, 5.0, 10.0, 25.0, 50.0, 100.0, 250.0, 1000.0]:
			unit = u
			if total / u <= 100.0: break
		_cells = maxi(1, int(ceilf(total / unit - 0.001)))
		per_row = mini(10, _cells)
		if _cells <= 20 and max_w >= _cells * 15.0: per_row = _cells     # up to 20 fit in one row when there is room
		rows = int(ceilf(float(_cells) / per_row))
		cube = 18.0 if rows == 1 else (13.0 if rows == 2 else (10.0 if rows <= 4 else 8.0))
		if mode == "cost" and rows == 1: cube = 16.0
		var w := per_row * (cube + 2.0)
		if w > max_w: cube = maxf(6.0, max_w / per_row - 2.0)
		var tag := 0.0 if unit <= 1.0 else 30.0
		_num_w = 0.0
		if show_num:
			var f: Font = get_theme_font("font", "Label")
			_num_w = f.get_string_size(_number(), HORIZONTAL_ALIGNMENT_LEFT, -1, num_size).x + 6.0
		custom_minimum_size = Vector2(per_row * (cube + 2.0) + tag + _num_w, maxf(rows * (cube + 2.0), num_size + 4.0))
		queue_redraw()

	func _cell(i: int) -> Rect2:
		var oy := maxf(0.0, (custom_minimum_size.y - rows * (cube + 2.0)) / 2.0)
		return Rect2(Vector2((i % per_row) * (cube + 2.0), oy + (i / per_row) * (cube + 2.0)), Vector2(cube, cube))

	func _draw() -> void:
		var filled := have / unit
		var n_need := need / unit
		var n_saved := saved / unit
		for i in range(_cells):
			var r := _cell(i)
			if mode == "stock":
				var f := clampf(filled - i, 0.0, 1.0)
				_slot(r)
				if f > 0.0: _cube(r, f, color)
			else:
				var whole := ceilf(n_need - 0.001)
				if i < int(whole):
					var part := clampf(n_need - i, 0.0, 1.0)      # the last cube can be a part of one
					var f2 := clampf(filled - i, 0.0, part)
					_slot(Rect2(r.position, Vector2(r.size.x * part, r.size.y)), Color(0.72, 0.28, 0.18, 0.9) if f2 < part - 0.001 else Color(0, 0, 0, 0.18))
					if f2 > 0.0: _cube(r, f2, color)
				elif i < int(whole + ceilf(n_saved - 0.001)):
					_cube(r, clampf(n_saved - (i - whole), 0.0, 1.0), Color(0.75, 0.73, 0.7, 0.55), true)
		var x := per_row * (cube + 2.0)
		var font: Font = get_theme_font("font", "Label")
		if unit > 1.0:
			draw_string(font, Vector2(x + 3.0, size.y / 2.0 + 4.0), "×%d" % int(unit), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("7a705c"))
			x += 30.0
		if show_num:
			var missing := mode == "cost" and have + 0.0001 < need
			var col := Color("b9472f") if missing else Color("2f2a1f")
			draw_string(font, Vector2(x + 4.0, size.y / 2.0 + num_size * 0.36), _number(), HORIZONTAL_ALIGNMENT_LEFT, -1, num_size, col)

	func _slot(r: Rect2, border := Color(0, 0, 0, 0.18)) -> void:
		draw_rect(r, Color(1, 1, 1, 0.35))
		draw_rect(r, border, false, 1.2)

	## A cube: front face, lighter top, darker right edge. f = how much of it is there (a half cube for ½).
	func _cube(r: Rect2, f: float, c: Color, faint := false) -> void:
		var rr := Rect2(r.position, Vector2(r.size.x * f, r.size.y))
		draw_rect(rr, c)
		if faint: return
		var top := maxf(2.0, r.size.y * 0.24)
		draw_rect(Rect2(rr.position, Vector2(rr.size.x, top)), c.lightened(0.35))
		draw_rect(Rect2(rr.position + Vector2(maxf(0.0, rr.size.x - 2.5), 0), Vector2(minf(2.5, rr.size.x), rr.size.y)), c.darkened(0.25))
		draw_rect(rr, c.darkened(0.45), false, 1.0)


## The season as a row of little bars, one per Time Quiz question of the season, in the season's colour:
## the ones already gone are filled. The number says how many questions are left until the next season.
class SeasonBar extends Control:
	const COLORS := {"spring": Color("7cc04a"), "summer": Color("e8b923"), "autumn": Color("d9772b"), "winter": Color("8fb8d8")}
	var season := "spring"
	var length := 30
	var passed := 0
	var next_emoji := ""

	func _ready() -> void:
		if not has_meta("explain"): mouse_filter = Control.MOUSE_FILTER_IGNORE
		custom_minimum_size = Vector2(length * 4.0 + 52.0, 18)

	func set_state(s: String, len_q: int, done_q: int, nxt: String) -> void:
		season = s; length = maxi(1, len_q); passed = done_q; next_emoji = nxt
		custom_minimum_size = Vector2(length * 4.0 + 52.0, 18)
		queue_redraw()

	func _draw() -> void:
		var col: Color = COLORS.get(season, Color("7cc04a"))
		var h := 14.0
		var y := (size.y - h) / 2.0
		for i in range(length):
			var r := Rect2(Vector2(i * 4.0, y), Vector2(3.0, h))
			draw_rect(r, col if i < passed else Color(col.r, col.g, col.b, 0.22))
		var font: Font = get_theme_font("font", "Label")
		draw_string(font, Vector2(length * 4.0 + 5.0, y + h - 2.0), "%d %s" % [length - passed, next_emoji], HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("2f2a1f"))


## A panel that acts like a button (for the energy cubes in the top bar: tap to rest).
class TapPanel extends PanelContainer:
	signal pressed
	var _down := Vector2.ZERO

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP

	func _gui_input(e: InputEvent) -> void:
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				_down = e.position
				modulate = Color(0.9, 0.9, 0.9)
			else:
				modulate = Color.WHITE
				if e.position.distance_to(_down) < 16.0: pressed.emit()


## The Time Quiz button: an old clock. Tapped, its hour hand goes once round (and the minute hand twelve times),
## then it says "pressed". Pictures: assets/ui/clock_face.png, clock_hour.png, clock_minute.png (hands pointing up,
## their hub at the bottom); without them a clock is drawn.
class ClockButton extends Control:
	signal pressed
	const Artc = preload("res://scripts/art.gd")
	var face: Texture2D
	var hour_tex: Texture2D
	var min_tex: Texture2D
	var face_c := Vector2.ZERO    # middle of the dial in the face picture (pixels; the ornament on top makes it lower than the picture's middle)
	var hour_hub := Vector2.ZERO  # middle of the round hub at the lower end of each hand picture (pixels)
	var min_hub := Vector2.ZERO
	var hour := 0.0          # angle of the hour hand (radians)
	var minute := 0.0
	var spinning := false
	var _down := Vector2.ZERO

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		face = Artc.tex("ui", "clock_face")
		hour_tex = Artc.tex("ui", "clock_hour")
		min_tex = Artc.tex("ui", "clock_minute")
		if face: face_c = _widest(face, 0.25, 0.8)
		if hour_tex: hour_hub = _widest(hour_tex, 0.6, 1.0)
		if min_tex: min_hub = _widest(min_tex, 0.6, 1.0)
		hour = TAU * 10.0 / 12.0
		minute = 0.0

	## The hands show the farm time: one full turn of the hour hand per season.
	func show_time(fraction: float) -> void:
		if spinning: return
		hour = TAU * fraction
		minute = TAU * fmod(fraction * 12.0, 1.0)
		queue_redraw()

	func _gui_input(e: InputEvent) -> void:
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				_down = e.position
				scale = Vector2(0.95, 0.95)
			else:
				scale = Vector2.ONE
				if e.position.distance_to(_down) < 16.0 and not spinning: spin()

	func spin() -> void:
		spinning = true
		pivot_offset = size / 2.0
		var tw := create_tween()
		tw.tween_method(_spin_step.bind(hour), 0.0, 1.0, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tw.tween_callback(_spin_done)

	func _spin_step(t: float, h0: float) -> void:
		hour = h0 + TAU * t
		minute = TAU * 12.0 * t
		queue_redraw()

	func _spin_done() -> void:
		spinning = false
		pressed.emit()

	func _draw() -> void:
		var c := size / 2.0
		var r := minf(size.x, size.y) / 2.0 - 2.0
		if face:
			var fs := Vector2(face.get_width(), face.get_height())
			var k := minf(size.x / fs.x, size.y / fs.y)
			draw_texture_rect(face, Rect2(c - fs * k / 2.0, fs * k), false)
			c = c - fs * k / 2.0 + face_c * k
			r = fs.x * k / 2.0 - 2.0
		else:
			draw_circle(c, r, Color("8a6a3a"))
			draw_circle(c, r * 0.9, Color("f4ead2"))
			for i in range(12):
				var a := TAU * i / 12.0
				var d := Vector2(sin(a), -cos(a))
				draw_line(c + d * r * 0.72, c + d * r * 0.84, Color("5a4630"), 2.0 if i % 3 == 0 else 1.0)
		_hand(c, minute, r * 0.74, min_tex, 2.0, min_hub)
		_hand(c, hour, r * 0.5, hour_tex, 3.5, hour_hub)
		draw_circle(c, r * 0.07, Color("3a2e22"))

	func _hand(c: Vector2, ang: float, length: float, tex: Texture2D, width: float, hub: Vector2) -> void:
		if tex:
			var ts := Vector2(tex.get_width(), tex.get_height())
			var k := length / maxf(1.0, hub.y)
			draw_set_transform(c, ang, Vector2(k, k))
			draw_texture_rect(tex, Rect2(-hub, ts), false)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			var d := Vector2(sin(ang), -cos(ang))
			draw_line(c, c + d * length, Color("2a2018"), width)


	## The middle of the widest row of a picture between y0 and y1 (fractions of its height): the middle of a round dial,
	## or of the round hub at the end of a clock hand.
	func _widest(tex: Texture2D, y0: float, y1: float) -> Vector2:
		var w := tex.get_width()
		var h := tex.get_height()
		var fallback := Vector2(w / 2.0, h - w / 2.0)
		var img: Image = tex.get_image()
		if img == null: return fallback
		if img.is_compressed(): img.decompress()
		var best_w := -1
		var best := fallback
		for y in range(int(h * y0), mini(h, int(h * y1)), 2):
			var x0 := -1
			var x1 := -1
			for x in range(w):
				if img.get_pixel(x, y).a > 0.2:
					if x0 < 0: x0 = x
					x1 = x
			if x0 >= 0 and x1 - x0 > best_w:
				best_w = x1 - x0
				best = Vector2((x0 + x1) / 2.0, y)
		return best


## A celebration drawn over a pop-up when something new is built or made. kind: confetti, stars, fireworks, balloons, rays.
## It plays for about 4 seconds and then frees itself.
class Celebration extends Control:
	const KINDS := ["confetti", "stars", "fireworks", "balloons", "rays"]
	const COLS := [Color("e8453c"), Color("f2b632"), Color("4caf50"), Color("3f8fd8"), Color("a35dd8"), Color("ff8fb1"), Color("ffd84d")]
	var kind := "confetti"
	var centre := Vector2.ZERO
	var t := 0.0
	var parts := []
	var rng := RandomNumberGenerator.new()

	func start(k: String, c: Vector2) -> void:
		kind = k
		centre = c
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		rng.randomize()
		parts.clear()
		match kind:
			"confetti":
				for i in range(120):
					parts.append({"p": Vector2(rng.randf() * size.x, -rng.randf() * size.y * 0.6), "v": Vector2(rng.randf_range(-40, 40), rng.randf_range(120, 260)),
						"r": rng.randf() * TAU, "w": rng.randf_range(-6, 6), "c": COLS[rng.randi() % COLS.size()], "s": rng.randf_range(6, 12)})
			"stars":
				for i in range(40):
					var a := rng.randf() * TAU
					parts.append({"a": a, "sp": rng.randf_range(180, 420), "c": COLS[rng.randi() % COLS.size()], "s": rng.randf_range(8, 18), "r": rng.randf() * TAU})
			"fireworks":
				for b in range(4):
					var bc := Vector2(rng.randf_range(0.15, 0.85) * size.x, rng.randf_range(0.12, 0.5) * size.y)
					var col: Color = COLS[rng.randi() % COLS.size()]
					var t0 := b * 0.55
					for i in range(36):
						var a2 := TAU * i / 36.0 + rng.randf() * 0.1
						parts.append({"o": bc, "a": a2, "sp": rng.randf_range(120, 220), "c": col, "t0": t0})
			"balloons":
				for i in range(14):
					parts.append({"x": rng.randf() * size.x, "y": size.y + rng.randf() * size.y * 0.5, "v": rng.randf_range(110, 190),
						"c": COLS[rng.randi() % COLS.size()], "s": rng.randf_range(22, 34), "ph": rng.randf() * TAU})
			"rays":
				for i in range(30):
					parts.append({"p": centre + Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * size * 0.4, "t0": rng.randf() * 3.0, "c": COLS[rng.randi() % COLS.size()]})
		set_process(true)

	func _process(d: float) -> void:
		t += d
		queue_redraw()
		if t > 4.2: queue_free()

	func _fade() -> float:
		return clampf((4.2 - t) / 1.0, 0.0, 1.0)

	func _star(c: Vector2, r: float, rot: float, col: Color) -> void:
		var pts := PackedVector2Array()
		for i in range(10):
			var rr := r if i % 2 == 0 else r * 0.45
			var a := rot + TAU * i / 10.0 - PI / 2.0
			pts.append(c + Vector2(cos(a), sin(a)) * rr)
		draw_colored_polygon(pts, col)

	func _draw() -> void:
		var f := _fade()
		match kind:
			"confetti":
				for p in parts:
					var pos: Vector2 = p["p"] + p["v"] * t + Vector2(sin(t * 3.0 + float(p["r"])) * 20.0, 0)
					var s: float = p["s"]
					draw_set_transform(pos, float(p["r"]) + float(p["w"]) * t, Vector2(1.0, absf(cos(t * 4.0 + float(p["r"])))))
					var c: Color = p["c"]
					draw_rect(Rect2(-s / 2.0, -s / 4.0, s, s / 2.0), Color(c.r, c.g, c.b, f))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			"stars":
				for p in parts:
					var dist: float = float(p["sp"]) * (1.0 - exp(-t * 2.2))
					var pos2: Vector2 = centre + Vector2(cos(float(p["a"])), sin(float(p["a"]))) * dist
					var c2: Color = p["c"]
					_star(pos2, float(p["s"]) * (1.0 + 0.2 * sin(t * 8.0)), float(p["r"]) + t * 2.0, Color(c2.r, c2.g, c2.b, f))
			"fireworks":
				for p in parts:
					var lt := t - float(p["t0"])
					if lt < 0.0 or lt > 2.2: continue
					var dir := Vector2(cos(float(p["a"])), sin(float(p["a"])))
					var pos3: Vector2 = p["o"] + dir * float(p["sp"]) * (1.0 - exp(-lt * 3.0)) + Vector2(0, 30.0 * lt * lt)
					var c3: Color = p["c"]
					var a3 := clampf(1.0 - lt / 2.2, 0.0, 1.0) * f
					draw_line(pos3 - dir * 10.0, pos3, Color(c3.r, c3.g, c3.b, a3), 3.0)
					draw_circle(pos3, 2.5, Color(1, 1, 0.85, a3))
			"balloons":
				for p in parts:
					var y: float = float(p["y"]) - float(p["v"]) * t
					var x: float = float(p["x"]) + sin(t * 2.0 + float(p["ph"])) * 14.0
					var s4: float = p["s"]
					var c4: Color = p["c"]
					var pts := PackedVector2Array()
					for j in range(20):
						var a4 := TAU * j / 20.0
						pts.append(Vector2(x, y) + Vector2(cos(a4) * s4 * 0.8, sin(a4) * s4))
					draw_colored_polygon(pts, Color(c4.r, c4.g, c4.b, f))
					draw_circle(Vector2(x - s4 * 0.3, y - s4 * 0.35), s4 * 0.18, Color(1, 1, 1, 0.5 * f))
					draw_line(Vector2(x, y + s4), Vector2(x + sin(t * 3.0) * 6.0, y + s4 * 2.6), Color(0.3, 0.3, 0.3, 0.7 * f), 1.5)
			"rays":
				for i in range(16):
					var a5 := TAU * i / 16.0 + t * 0.6
					var r1 := 40.0
					var r2 := maxf(size.x, size.y) * 0.7
					var w := 0.09
					var poly := PackedVector2Array([centre + Vector2(cos(a5 - w), sin(a5 - w)) * r1, centre + Vector2(cos(a5 - w * 2.0), sin(a5 - w * 2.0)) * r2,
						centre + Vector2(cos(a5 + w * 2.0), sin(a5 + w * 2.0)) * r2, centre + Vector2(cos(a5 + w), sin(a5 + w)) * r1])
					draw_colored_polygon(poly, Color(1, 0.86, 0.35, 0.22 * f))
				for p in parts:
					var tw := fmod(t + float(p["t0"]), 1.2) / 1.2
					var c5: Color = p["c"]
					_star(p["p"], 10.0 * sin(tw * PI), t, Color(c5.r, c5.g, c5.b, f))


## "No water": a big drop with a red line through it.
class NoWater extends Control:
	func _ready() -> void:
		custom_minimum_size = Vector2(0, 110)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var c := Vector2(size.x / 2.0, 55)
		var font: Font = get_theme_font("font", "Label")
		draw_string(font, c + Vector2(-34, 26), "💧", HORIZONTAL_ALIGNMENT_LEFT, -1, 68)
		draw_arc(c, 46, 0, TAU, 40, Color("c0392b"), 7.0)
		draw_line(c + Vector2(-32, -32), c + Vector2(32, 32), Color("c0392b"), 7.0)
