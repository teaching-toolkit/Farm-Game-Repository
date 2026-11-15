extends RefCounted
class_name FarmMapPiles
## The piles of sticks, small stones and big rocks beside the store (visible-work/02): four sizes of picture each, the size follows the
## stored amount, things fly to their pile, and when the store is full the top of the pile tumbles. Drawn among the standing things
## by their feet; they never catch a tap (the tap opens the store). Data: data/farm/rules/67-piles.json (looks only).
const Art = preload("res://kits/ui/art.gd")

var map: FarmMap   # the map: its layers and the other parts

func _init(owner_map: FarmMap) -> void:
	map = owner_map

var _nodes := {}      # item -> the picture standing now
var _size := {}       # item -> the size shown now (0 = no pile)

## Which size a pile shows for a stored amount: 0 (no pile) … steps.size(); steps = the amount from which size 1, 2, 3 … shows.
static func size_for(amount: float, steps: Array) -> int:
	var n := 0
	for i in range(steps.size()):
		if amount + 0.0001 >= float(steps[i]): n = i + 1
	return n

func _data() -> Dictionary:
	var g = map.get_node_or_null("/root/Game")
	return {} if g == null else g.meta.get("piles", {})

func _things() -> Dictionary:
	return _data().get("things", {})

## Which things have a pile.
func items() -> Array:
	return _things().keys()

## What the store holds, { item: amount }: every pile shows the size of its amount at once (a small pop when the size changes).
func set_amounts(amounts: Dictionary) -> void:
	for item in _things():
		var spec: Dictionary = _things()[item]
		var n := size_for(float(amounts.get(item, 0.0)), spec.get("steps", []))
		var old: int = _size.get(item, 0)
		if n == old and (n == 0 or _nodes.has(item)): continue
		_size[item] = n
		if _nodes.has(item):
			_nodes[item].queue_free()
			_nodes.erase(item)
		if n == 0: continue
		var node := _make(item, spec, n)
		if node == null: continue
		_nodes[item] = node
		map.critters.sort_in(node, _feet(spec).y)
		if old > 0 and n != old: _pop(node)          # (the first time they are drawn nothing pops)

func size_shown(item: String) -> int:
	return int(_size.get(item, 0))

## Where things fly to: the top of the pile; the store's point when the thing has no pile (yet).
func point(item: String) -> Vector2:
	if _nodes.has(item):
		var nd: Control = _nodes[item]
		return nd.position + Vector2(nd.size.x / 2.0, nd.size.y * 0.35)
	return map.spot_point("storage")

## The pile jumps a little: something landed on it.
func bump(item: String) -> void:
	if _nodes.has(item): _pop(_nodes[item])

## The top of the pile wobbles and a piece falls off (the store has no room for more).
func tumble(item: String) -> void:
	if not _nodes.has(item): return
	var nd: Control = _nodes[item]
	var tw := map.create_tween()
	for a in [0.09, -0.09, 0.06, -0.06, 0.0]: tw.tween_property(nd, "rotation", a, 0.05)
	var piece := TextureRect.new()
	piece.texture = (nd as TextureRect).texture
	piece.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	piece.stretch_mode = TextureRect.STRETCH_SCALE
	piece.mouse_filter = Control.MOUSE_FILTER_IGNORE
	piece.size = nd.size * 0.4
	piece.pivot_offset = piece.size / 2.0
	piece.position = nd.position + Vector2(nd.size.x * 0.3, nd.size.y * 0.1)
	map.fx_layer.add_child(piece)
	var away := piece.position + Vector2(randf_range(24.0, 44.0) * (-1.0 if randf() < 0.5 else 1.0), nd.size.y * 0.9)
	var tw2 := map.create_tween()
	tw2.tween_property(piece, "position", away, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw2.parallel().tween_property(piece, "rotation", randf_range(-3.0, 3.0), 0.5)
	tw2.parallel().tween_property(piece, "modulate:a", 0.0, 0.5)
	tw2.tween_callback(piece.queue_free)

# ------------------------------------------------------------------ drawing

## The pile's feet: the store's standing point and the pile's own place beside it.
func _feet(spec: Dictionary) -> Vector2:
	return map.stand_point("storage") + Vector2(float(spec.get("dx", 0)), float(spec.get("dy", 0)))

func _make(item: String, spec: Dictionary, n: int) -> TextureRect:
	var scales: Array = _data().get("scales", [1.0])
	var tex := Art.tex(str(spec.get("art", "piles/" + item)).get_base_dir(), "%s_%d" % [str(spec.get("art", "piles/" + item)).get_file(), n])
	var sc := float(scales[mini(n - 1, scales.size() - 1)])
	var node: TextureRect = map._standing(tex, _feet(spec), float(spec.get("w", 50)) * sc)
	if node == null: return null
	node.pivot_offset = Vector2(node.size.x / 2.0, node.size.y)
	FarmSeasonLook.shade(node)
	return node

func _pop(node: Control) -> void:
	var tw := map.create_tween()
	tw.tween_property(node, "scale", Vector2(1.15, 0.88), 0.08)
	tw.tween_property(node, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
