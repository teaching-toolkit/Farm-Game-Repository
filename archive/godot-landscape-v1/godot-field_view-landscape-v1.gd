extends Control
## The field grid (3×3 patches), the pests hopping around and the scarecrow's fierce looks.
const UI = preload("res://scripts/ui.gd")

signal patch_pressed(area: String, index: int)

var G
var area_name := "field"
var field_index := 0
var grid: GridContainer
var layer: Control
var scarecrow: Label
var critters: Array = []
var hop_t := 0.0
var look_t := 0.0
var kinds := ["🐦", "🐇", "🐌", "🐛", "🐭"]

func _ready() -> void:
	G = get_node("/root/Game")
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
	scarecrow = UI.label("", 38)
	scarecrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(scarecrow)
	G.step_done.connect(_on_step)
	refresh()

func show_area(a: String, f: int) -> void:
	area_name = a
	field_index = f
	for c in critters: c.queue_free()
	critters.clear()
	refresh()

func _patch_style(col: Color) -> StyleBoxFlat:
	return UI.box(col, 14, col.darkened(0.25), 2, 6)

func refresh() -> void:
	for c in grid.get_children():
		grid.remove_child(c)
		c.queue_free()
	var arr: Array = G.area(area_name)
	var start := field_index * 9 if area_name == "field" else 0
	var n := 9 if area_name == "field" else arr.size()
	grid.columns = 3
	if n == 0:
		var l := UI.label("Nothing here yet.", 18, UI.MUTED)
		grid.add_child(l)
	for k in range(n):
		var i := start + k
		var b := Button.new()
		b.focus_mode = Control.FOCUS_NONE
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.size_flags_vertical = Control.SIZE_EXPAND_FILL
		b.custom_minimum_size = Vector2(120, 96)
		b.add_theme_font_size_override("font_size", 17)
		b.add_theme_color_override("font_color", UI.INK)
		b.add_theme_color_override("font_hover_color", UI.INK)
		b.add_theme_color_override("font_pressed_color", UI.INK)
		b.add_theme_color_override("font_disabled_color", Color("e8efe0"))
		var col := Color("c9a77c")
		var txt := ""
		if i >= arr.size() or not G.patch_usable(area_name, i):
			col = Color("6b7f4b")
			txt = "🌿🌳🌿\nOvergrown\n(clear it in 🎯 Goals)"
			b.disabled = true
		else:
			var p = arr[i]
			var extra := ""
			if float(p["weeds"]) >= 1.0: extra += " 🌿×%d" % int(p["weeds"])
			if float(p["stones"]) >= 1.0: extra += " 🪨×%d" % int(p["stones"])
			if p["crop"] == "":
				txt = "🟫 empty\ntap to plant"
				if p.get("last", "") != "": txt += "\n(last: %s)" % G.nodes[p["last"]]["emoji"]
			else:
				var cn = G.nodes[p["crop"]]
				var em: String = cn.get("emoji", "🌱")
				var pl := maxi(1, int(round(float(p["plants"]))))
				var icons := ""
				for _j in range(pl): icons += em
				if p["ready"]:
					col = Color("f0c64a")
					txt = "%s\n✅ Ready!" % icons
				else:
					col = Color("9cc46a")
					var tgt: float = G.grow_target(p)
					txt = "%s\n⏳ %d / %d" % [icons, int(floor(float(p["growth"]))), int(ceil(tgt))]
				var soil := float(p.get("soil", 1.0))
				if soil < 0.99: txt += " 😴"
				elif soil > 1.01: txt += " 💚"
			if extra != "": txt += "\n" + extra.strip_edges()
		b.text = txt
		b.add_theme_stylebox_override("normal", _patch_style(col))
		b.add_theme_stylebox_override("hover", _patch_style(col.lightened(0.1)))
		b.add_theme_stylebox_override("pressed", _patch_style(col.darkened(0.1)))
		b.add_theme_stylebox_override("disabled", _patch_style(col))
		b.pressed.connect(_on_patch.bind(i))
		grid.add_child(b)
	_update_scarecrow()
	call_deferred("_sync_critters")

func _on_patch(i: int) -> void:
	patch_pressed.emit(area_name, i)

func _update_scarecrow() -> void:
	var em := ""
	for pair in [["scarecrow_4", "🎏"], ["scarecrow_3", "💂"], ["scarecrow_2", "🧑‍🌾"], ["scarecrow_1", "🧍"]]:
		if G.done(pair[0]) and em == "": em = pair[1]
	scarecrow.text = em if area_name == "field" else ""
	scarecrow.position = Vector2(maxf(0.0, size.x - 54.0), 2.0)

func _growing_rects() -> Array:
	var out := []
	if area_name != "field": return out
	var start := field_index * 9
	var kids := grid.get_children()
	for k in range(kids.size()):
		var i := start + k
		if i >= G.S["patches"].size(): continue
		var p = G.S["patches"][i]
		if p["crop"] == "" or p["ready"]: continue
		var c: Control = kids[k]
		if c.size.x < 10: continue
		out.append(Rect2(c.position, c.size))
	return out

func _sync_critters() -> void:
	var rects := _growing_rects()
	var want := 0
	if rects.size() > 0: want = mini(14, int(round(float(G.S["pests"]))))
	while critters.size() > want:
		var c: Label = critters.pop_back()
		var tw := create_tween()
		tw.tween_property(c, "modulate:a", 0.0, 0.3)
		tw.tween_callback(c.queue_free)
	while critters.size() < want and rects.size() > 0:
		var c := UI.label(kinds[mini(G.chapter() - 1, kinds.size() - 1) if randf() < 0.6 else randi() % kinds.size()], 24)
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var r: Rect2 = rects[randi() % rects.size()]
		c.position = Vector2(randf_range(-30, size.x), -30)
		layer.add_child(c)
		critters.append(c)
		var tw2 := create_tween()
		tw2.tween_property(c, "position", r.position + Vector2(randf() * maxf(10.0, r.size.x - 30.0), randf() * maxf(10.0, r.size.y - 30.0)), 0.6)

func _process(delta: float) -> void:
	if scarecrow: scarecrow.position = Vector2(maxf(0.0, size.x - 50.0), 0.0)
	hop_t += delta
	look_t += delta
	if hop_t > 0.8:
		hop_t = 0.0
		var rects := _growing_rects()
		for c in critters:
			if not is_instance_valid(c) or rects.is_empty(): continue
			if randf() < 0.5:
				var r: Rect2 = rects[randi() % rects.size()]
				var target := r.position + Vector2(randf() * maxf(10.0, r.size.x - 30.0), randf() * maxf(10.0, r.size.y - 30.0))
				var tw := create_tween()
				tw.tween_property(c, "position", c.position.lerp(target, 0.5) + Vector2(0, -8), 0.18)
				tw.tween_property(c, "position", c.position.lerp(target, 0.9), 0.18)
	if look_t > 2.6 and critters.size() > 0 and scarecrow.text != "":
		look_t = 0.0
		_throw_look(critters[randi() % critters.size()], false)

func _throw_look(target: Label, chase: bool) -> void:
	if not is_instance_valid(target): return
	var look := UI.label(["💢", "😠", "👀"][randi() % 3], 22)
	look.mouse_filter = Control.MOUSE_FILTER_IGNORE
	look.position = scarecrow.position + Vector2(10, 20)
	layer.add_child(look)
	var tw := create_tween()
	tw.tween_property(look, "position", target.position, 0.35)
	tw.tween_property(look, "modulate:a", 0.0, 0.15)
	tw.tween_callback(look.queue_free)
	if chase:
		var tw2 := create_tween()
		tw2.tween_interval(0.35)
		tw2.tween_property(target, "position", target.position + Vector2(randf_range(-200, 200), -260), 0.5)
		tw2.parallel().tween_property(target, "modulate:a", 0.0, 0.5)
		tw2.tween_callback(target.queue_free)

func _on_step(info: Dictionary) -> void:
	var removed := mini(int(info.get("removed", 0)), 6)
	if area_name == "field" and scarecrow.text != "":
		for _k in range(removed):
			if critters.is_empty(): break
			var c: Label = critters.pop_back()
			_throw_look(c, true)
	if info.get("rain", false):
		var rain := UI.label("🌧️🌧️🌧️", 30)
		rain.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rain.position = Vector2(-120, 4)
		layer.add_child(rain)
		var tw := create_tween()
		tw.tween_property(rain, "position", Vector2(size.x + 20, 4), 1.6)
		tw.tween_callback(rain.queue_free)
