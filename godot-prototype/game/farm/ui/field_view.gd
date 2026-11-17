extends Control
## The patches inside the orchard and greenhouse sheets, in diamond rows like the fields on the map. The layout, each patch's picture
## and its taps come from game/farm/map/iso_field.gd (the same soil and plant pictures); there are no fences, pests or scarecrow here:
## they only bother the fields.
const UI = preload("res://kits/ui/ui.gd")
const IsoField = preload("res://game/farm/map/iso_field.gd")

signal patch_pressed(area: String, index: int)

const PATCH_W := 170.0       # width of one diamond in a sheet (a field's is about 144 on the map)
const GAP := 14.0
const HEAD := 52.0           # room above the top row: the soil heap and the plants stand taller than the diamond

var G
var area_name := "orchard"
var board: Control           # the diamonds, centred in this control
var layer: Control           # rain
var patches: Array = []      # IsoField.IsoPatch, by patch number in the area (a tap on it says the same number)
var _sway_t := 0.0

func _ready() -> void:
	G = get_node("/root/Game")
	mouse_filter = Control.MOUSE_FILTER_PASS
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layer = Control.new()
	layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(layer)
	G.step_done.connect(_on_step)
	refresh()

func refresh() -> void:
	var n: int = G.fields.area(area_name).size()
	if n != patches.size(): _build(n)
	for k in range(n):
		patches[k].show_state(IsoField.patch_spec(G, area_name, k, hash([area_name, k])))

## n diamonds back to front (the one nearest the top first), with the plants, weeds and stones of each above all of them.
func _build(n: int) -> void:
	if board != null:
		remove_child(board)
		board.queue_free()
	patches.clear()
	patches.resize(n)
	var box := IsoField.grid_size(n, PATCH_W, GAP)
	custom_minimum_size = Vector2(box.x, box.y + HEAD) if n > 0 else Vector2.ZERO
	board = Control.new()
	board.mouse_filter = Control.MOUSE_FILTER_IGNORE
	board.size = box
	board.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP, Control.PRESET_MODE_KEEP_SIZE)
	board.position.y = HEAD
	add_child(board)
	move_child(board, 0)              # under the rain
	var cols := IsoField.grid_cols(n)
	var order := range(n)
	order.sort_custom(func(a, b): return (a / cols + a % cols) < (b / cols + b % cols))
	for k in order:
		var p := IsoField.IsoPatch.new()
		p.setup(k, PATCH_W, IsoField.cell_center(k, n, PATCH_W, GAP), PATCH_W + GAP)
		p.pressed_patch.connect(_on_patch)
		board.add_child(p)
		patches[k] = p
	var tops := Control.new()
	tops.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tops.size = box
	board.add_child(tops)
	for k in order:
		var p: IsoField.IsoPatch = patches[k]
		var t := Control.new()
		t.mouse_filter = Control.MOUSE_FILTER_IGNORE
		t.position = p.position
		t.size = p.size
		tops.add_child(t)
		p.top = t
		t.draw.connect(p.draw_top.bind(t))

func _on_patch(k: int) -> void:
	patch_pressed.emit(area_name, k)

func _process(delta: float) -> void:
	# ripe plants sway: redraw their patches about 20 times a second (as on the map)
	_sway_t += delta
	if _sway_t > 0.05:
		_sway_t = 0.0
		for p in patches:
			if p.any_ready() and p.top: p.top.queue_redraw()

func _on_step(info: Dictionary) -> void:
	if info.get("rain", false):
		var rain := UI.label("🌧️🌧️🌧️", 30)
		rain.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rain.position = Vector2(-120, 4)
		layer.add_child(rain)
		var tw := create_tween()
		tw.tween_property(rain, "position", Vector2(size.x + 20, 4), 1.6)
		tw.tween_callback(rain.queue_free)
