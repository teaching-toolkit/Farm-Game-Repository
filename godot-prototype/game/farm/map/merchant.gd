extends RefCounted
class_name FarmMapMerchant
## The travelling merchant at the farm's gate: his cart and he himself. The rest of the game says only `sync(here, fill)`: is he here, and how
## full is his cart (0 to 1); everything else lives here. The cart is one of three pictures (assets/map/merchant_cart_1 to 3: nearly empty, half
## full, full; thirds of `fill`); beside it stands the merchant as a figure (ui/figures.gd, person "merchant" of rules/58-people.json). When he
## arrives he walks in from the left edge of the map to his cart in about two seconds and the cart rolls in from the road's far end; when he
## leaves he walks off to the left and the cart fades. If the game starts with him there, he and the cart just stand. A tap on the cart opens
## the road's window (as before), a tap on him makes him say one of his lines (`G.people.line`). Coins fly as before: they do not know him.
## Where and how big: the cart's width is `pictureW` of rules/50-gate.json and his height and place are `scenes.gate` of rules/58-people.json,
## all shares of the map's width.
const Art = preload("res://kits/ui/art.gd")
const ID := "merchant"
const WALK_SECS := 2.0          # how long he walks in or out, and the cart rolls in
const CART_DROP := 10.0         # the cart stands this far below the middle of the road's spot (farm pixels)
const CART_DX := -28.0          # … and this far to the left of it, clear of the village sign
const ASPECT := 1.08            # a cart picture's height by its width (the three differ by little)

var map: FarmMap                 # the map: its layers and the other parts
var G: FarmGame                  # the rules (G.gate: how wide his cart picture is; G.people: his look and place)
var figures: FarmUiFigures       # the people (main hands it over; without it the cart stands alone)
var cart: TextureRect            # his cart while he is here (null when he is not)
var _layer: Control              # his own layer on the board, over the standing things (a figure is always sorted among its own scene's)
var _here := false
var _synced := false             # false until the first `sync`: a game that starts with him there does not show him walking in
var _level := 0

func _init(owner_map: FarmMap) -> void:
	map = owner_map
	G = Engine.get_main_loop().root.get_node("/root/Game")

## He is here (or not) with this much of his cart full: shows, moves or takes away what must change; does nothing when nothing changed.
func sync(here: bool, fill: float) -> void:
	var arriving := here and not _here and _synced
	var leaving := _here and not here
	_synced = true
	_here = here
	if leaving:
		_leave()
	elif here:
		if arriving or cart == null: _arrive(arriving, fill)
		_show_fill(fill)

## How full his cart looks: 1 (nearly empty) to 3 (full), 0 when there is no cart.
func level() -> int:
	return _level if cart != null else 0

## Where the middle of the cart's lower edge is, in the map's farm pixels.
func base() -> Vector2:
	return map.spot_point("road") + Vector2(CART_DX, CART_DROP + _cart_w() * ASPECT / 2.0)

# ------------------------------------------------------------------ coming and going

func _arrive(walking: bool, fill: float) -> void:
	if cart != null: cart.queue_free()
	cart = TextureRect.new()
	cart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	cart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	cart.mouse_filter = Control.MOUSE_FILTER_STOP
	cart.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: map.spot_tapped.emit("road"))
	_level = 0
	_show_fill(fill)
	var at := cart.position
	var from := at
	var rd: Dictionary = map.L.get("ground", {}).get("road", {})
	if walking and rd.has("points"):                      # it rolls in from the road's far end
		var pts: PackedVector2Array = map.ground._pts(rd["points"])
		from = pts[pts.size() - 1].clamp(Vector2.ZERO, map.design) - cart.size / 2.0
	cart.position = from
	map.critters.sort_in(cart, base().y)
	if from != at: map.create_tween().tween_property(cart, "position", at, WALK_SECS).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if figures == null: return
	figures.take(ID)                                       # (one that was still walking off)
	var h := _figure_h()
	var stand := _stand()
	var left := Vector2(-h * 0.5, stand.y)                # just beyond the left edge, on the line he walks along
	figures.put(ID, _own_layer(), left if walking else stand, h)
	if walking: figures.walk_to(ID, stand, WALK_SECS)

func _leave() -> void:
	if cart != null:                                       # the cart fades while he walks off
		var old := cart
		cart = null
		_level = 0
		var tw := map.create_tween()
		tw.tween_property(old, "modulate:a", 0.0, WALK_SECS)
		tw.tween_callback(old.queue_free)
		old.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if figures != null and ID in figures.ids(_own_layer()):
		figures.walk_to(ID, Vector2(-_figure_h(), figures.feet(ID).y), WALK_SECS, true)

# ------------------------------------------------------------------ the picture

## The cart's picture for this fill (thirds), at its place: the picture changes, the cart's lower middle stays where it is.
func _show_fill(fill: float) -> void:
	if cart == null: return
	var lv := clampi(1 + int(clampf(fill, 0.0, 1.0) * 3.0), 1, 3)
	if lv == _level: return
	_level = lv
	var tex: Texture2D = Art.first("map", ["merchant_cart_%d" % lv, "bookcart"])
	cart.texture = tex
	var w := _cart_w()
	var h := w * (float(tex.get_height()) / float(tex.get_width()) if tex != null else ASPECT)
	cart.size = Vector2(w, h)
	var b := base()
	cart.position = b - Vector2(w / 2.0, h)

func _cart_w() -> float:
	return map.design.x * float(G.gate.data().get("cart", {}).get("pictureW", 0.11))

# ------------------------------------------------------------------ he himself

func _own_layer() -> Control:
	if _layer == null or not is_instance_valid(_layer):
		_layer = Control.new()
		_layer.name = "merchant_layer"
		_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_layer.size = map.design
		map.board.add_child(_layer)
		map.board.move_child(_layer, map.objects.get_index() + 1)
	return _layer

func _spot() -> Dictionary:
	return G.people.spot(ID, "gate")

func _figure_h() -> float:
	return map.design.x * float(_spot().get("figureH", 0.07))

## Where he stands: beside the cart, on its left.
func _stand() -> Vector2:
	var s := _spot()
	return base() + Vector2(float(s.get("dx", -0.065)), float(s.get("dy", -0.03))) * map.design.x
