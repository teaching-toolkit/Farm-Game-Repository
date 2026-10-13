extends Control
## The square patch grid inside the orchard and greenhouse sheets (the fields on the map are game/farm/map/iso_field.gd, which draws the
## pests and the scarecrow). 💡 Z3: these two get diamond rows like the fields one day, and this file goes.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")

signal patch_pressed(area: String, index: int)

var G
var area_name := "field"
var field_index := 0
var grid: GridContainer
var layer: Control

func _ready() -> void:
	G = get_node("/root/Game")
	mouse_filter = Control.MOUSE_FILTER_PASS
	clip_contents = true
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid = GridContainer.new()
	grid.columns = 3
	grid.set_anchors_preset(Control.PRESET_FULL_RECT)
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	add_child(grid)
	layer = Control.new()
	layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(layer)
	G.step_done.connect(_on_step)
	refresh()

func show_area(a: String, f: int) -> void:
	area_name = a
	field_index = f
	refresh()

## Soil picture (assets/tiles/soil.png, overgrown.png) when it exists, tinted by state; a coloured box otherwise.
func _patch_style(col: Color, tex_key := "", tint := Color.WHITE) -> StyleBox:
	var t: Texture2D = Art.tex("tiles", tex_key) if tex_key != "" else null
	if t:
		var s := StyleBoxTexture.new()
		s.texture = t
		s.modulate_color = tint
		s.content_margin_left = 6; s.content_margin_right = 6; s.content_margin_top = 4; s.content_margin_bottom = 4
		return s
	return UI.box(col, 14, col.darkened(0.25), 2, 6)

func refresh() -> void:
	for c in grid.get_children():
		grid.remove_child(c)
		c.queue_free()
	var arr: Array = G.fields.area(area_name)
	var start := field_index * 9 if area_name == "field" else 0
	var n := 9 if area_name == "field" else arr.size()
	grid.columns = 3
	if n == 0:
		var l := UI.label(tr("Nothing here yet."), 18, UI.MUTED)
		grid.add_child(l)
	for k in range(n):
		var i := start + k
		var b := Button.new()
		b.focus_mode = Control.FOCUS_NONE
		b.mouse_filter = Control.MOUSE_FILTER_PASS
		b.clip_text = true
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.size_flags_vertical = Control.SIZE_EXPAND_FILL
		b.custom_minimum_size = Vector2(90, 80)
		b.add_theme_font_size_override("font_size", 18)
		b.add_theme_color_override("font_color", UI.INK)
		b.add_theme_color_override("font_hover_color", UI.INK)
		b.add_theme_color_override("font_pressed_color", UI.INK)
		b.add_theme_color_override("font_disabled_color", Color("e8efe0"))
		var col := Color("c9a77c")
		var tex_key := "soil"
		var tint := Color.WHITE
		var icon := ""
		var icon_tex: Texture2D = null
		var icon_size := 40
		var txt := ""
		var n_weeds := 0
		var n_stones := 0
		if i >= arr.size() or not G.fields.patch_usable(area_name, i):
			col = Color("6b7f4b")
			tex_key = "overgrown"
			icon = "🌿🌳🌿"
			icon_size = 26
			txt = tr("Overgrown") if area_name == "field" else ""
			b.disabled = true
			if Art.tex("deco", "overgrown_patch") != null:
				# a bramble patch drawn on wild green ground
				tex_key = ""
				col = Color("7d9a4e")
				icon_tex = Art.tex("deco", "overgrown_patch")
		else:
			var p = arr[i]
			var extra := ""
			n_weeds = int(p["weeds"])
			n_stones = int(p["stones"])
			if Art.tex("deco", "weeds") == null:
				if n_weeds >= 1: extra += " 🌿×%d" % n_weeds
				if n_stones >= 1: extra += " 🪨×%d" % n_stones
			if p["crop"] == "":
				icon = "" if Art.tex("tiles", "soil") != null else "🟫"
				icon_size = 26
				txt = tr("tap to plant")
				if p.get("last", "") != "": txt += tr("\n(last: %s)") % G.nodes[p["last"]]["emoji"]
			else:
				var cn = G.nodes[p["crop"]]
				var em: String = cn.get("emoji", "🌱")
				var pl := maxi(1, int(round(float(p["plants"]))))
				if p["ready"]:
					col = Color("f0c64a")
					tint = Color(1.15, 1.05, 0.7)
					icon_tex = Art.tex("crops", p["crop"])
					icon = em.repeat(mini(pl, 3)) if pl <= 3 else "%s×%d" % [em, pl]
					txt = tr("✅ Ready!")
				else:
					col = Color("9cc46a")
					tint = Color(0.92, 1.0, 0.88)
					var young: bool = float(p["growth"]) < G.fields.grow_target(p) * 0.5
					if young and Art.tex("tiles", "soil_sprouts") != null:
						tex_key = "soil_sprouts"   # the sprouts are in the picture
						icon = ""
					else:
						icon = "🌱" if young else em
						icon = icon.repeat(mini(pl, 3)) if pl <= 3 else "%s×%d" % [icon, pl]
					txt = "⏳ %d / %d" % [int(floor(float(p["growth"]))), int(ceil(G.fields.grow_target(p)))]
				var soil := float(p.get("soil", 1.0))
				if soil < 0.99: txt += " 😴"
				elif soil > 1.01: txt += " 💚"
			if extra != "": txt += "\n" + extra.strip_edges()
		b.text = ""
		var on_pic := tex_key != "" and Art.tex("tiles", tex_key) != null
		var vb := VBoxContainer.new()
		vb.set_anchors_preset(Control.PRESET_FULL_RECT)
		vb.alignment = BoxContainer.ALIGNMENT_CENTER
		vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vb.add_theme_constant_override("separation", 0)
		b.add_child(vb)
		if icon_tex:
			var tr := TextureRect.new()
			tr.texture = icon_tex
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr.custom_minimum_size = Vector2(0, 58 if not b.disabled else 74)
			tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
			vb.add_child(tr)
		elif icon != "":
			var il := UI.label(icon, icon_size)
			il.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			il.mouse_filter = Control.MOUSE_FILTER_IGNORE
			vb.add_child(il)
		if txt != "":
			var tl := UI.label(txt, 17, Color("fffaf0") if (on_pic or b.disabled) else UI.INK)
			tl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			tl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			if on_pic or b.disabled:
				tl.add_theme_color_override("font_outline_color", Color(0.18, 0.12, 0.05, 0.85))
				tl.add_theme_constant_override("outline_size", 6)
			vb.add_child(tl)
		if n_weeds + n_stones > 0 and Art.tex("deco", "weeds") != null:
			# little weed and stone pictures along the bottom of the patch, one per weed or stone (up to 4 each)
			var row := HBoxContainer.new()
			row.alignment = BoxContainer.ALIGNMENT_CENTER
			row.mouse_filter = Control.MOUSE_FILTER_IGNORE
			row.add_theme_constant_override("separation", -6)
			for kind in [["weeds", n_weeds], ["stone", n_stones]]:
				for _k in range(mini(4, kind[1])):
					var dr := TextureRect.new()
					dr.texture = Art.tex("deco", kind[0])
					dr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
					dr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
					dr.custom_minimum_size = Vector2(30, 28)
					dr.mouse_filter = Control.MOUSE_FILTER_IGNORE
					row.add_child(dr)
			vb.add_child(row)
		b.add_theme_stylebox_override("normal", _patch_style(col, tex_key, tint))
		b.add_theme_stylebox_override("hover", _patch_style(col.lightened(0.1), tex_key, tint.lightened(0.08)))
		b.add_theme_stylebox_override("pressed", _patch_style(col.darkened(0.1), tex_key, tint.darkened(0.1)))
		b.add_theme_stylebox_override("disabled", _patch_style(col, tex_key, tint))
		b.pressed.connect(_on_patch.bind(i))
		grid.add_child(b)

func _on_patch(i: int) -> void:
	patch_pressed.emit(area_name, i)

func _on_step(info: Dictionary) -> void:
	if info.get("rain", false):
		var rain := UI.label("🌧️🌧️🌧️", 30)
		rain.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rain.position = Vector2(-120, 4)
		layer.add_child(rain)
		var tw := create_tween()
		tw.tween_property(rain, "position", Vector2(size.x + 20, 4), 1.6)
		tw.tween_callback(rain.queue_free)
