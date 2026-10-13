extends RefCounted
class_name FarmMapCritters
## Animals and pets walking about their pens, drawn among the standing things by their feet.
const UI = preload("res://kits/ui/ui.gd")


var map: FarmMap   # the map: its layers and the other parts

func _init(owner_map: FarmMap) -> void:
	map = owner_map

var by_place := {}      # place id -> the animals and pets walking about it
var _crit_sig := {}
var _hop_t := 0.0

# ------------------------------------------------------------------ animals and pets walking around

## spec: { spot_id: [[emoji, texture or null], …] } — one entry per animal or pet walking around that place.
func set_critters(spec: Dictionary) -> void:
	for sid in by_place.keys():
		if not spec.has(sid):
			for c in by_place[sid]: c.queue_free()
			by_place.erase(sid)
			_crit_sig.erase(sid)
	for sid in spec:
		if not map.slots.has(sid): continue
		var sig := str(spec[sid].map(func(e): return e[0]))
		if _crit_sig.get(sid, "") == sig: continue
		for c in by_place.get(sid, []): c.queue_free()
		_crit_sig[sid] = sig
		var arr := []
		for e in spec[sid]:
			var c: Control
			var tex: Texture2D = e[1]
			if tex:
				var tr := TextureRect.new()
				tr.texture = tex
				tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				tr.size = Vector2(34, 34)
				c = tr
			else:
				c = UI.label(e[0], 22)
			c.mouse_filter = Control.MOUSE_FILTER_IGNORE
			c.position = _spot_point(sid)
			c.set_meta("left", bool(e[3]) if e.size() > 3 else false)   # e = [emoji, picture, node id, faces left (the node's "facesLeft")]
			sort_in(c, c.position.y + c.size.y)
			arr.append(c)
		by_place[sid] = arr

## Somewhere inside a pen (or on the grass in front of a building) — on the visible part of the farm.
func _spot_point(sid: String) -> Vector2:
	var s = map.slots[sid]
	var fp: PackedVector2Array = s.foot_points()
	var inside := Rect2(Vector2(8, 30), map.design - Vector2(50, 40))
	var q := Vector2.ZERO
	for _try in range(12):
		var i := randf_range(0.2, 0.85)
		var j := randf_range(0.2, 0.85)
		var p: Vector2 = fp[0] + (fp[1] - fp[0]) * i + (fp[3] - fp[0]) * j
		if s.kind != "plot": p = Vector2(randf_range(-0.5, 0.5) * s.pic_w, randf_range(0.0, 0.3) * map.tile)
		q = s.anchor + p - Vector2(17, 30)
		if inside.has_point(q): return q
	return q.clamp(inside.position, inside.end)

## Puts a node among the standing things by its feet (y): what stands lower on the screen is drawn in front.
func sort_in(node: Control, y: float) -> void:
	node.set_meta("sy", y)
	if node.get_parent() == map.objects: map.objects.remove_child(node)
	elif node.get_parent() != null: node.get_parent().remove_child(node)
	var idx := map.objects.get_child_count()
	for i in range(map.objects.get_child_count()):
		if float(map.objects.get_child(i).get_meta("sy", 0.0)) > y:
			idx = i
			break
	map.objects.add_child(node)
	map.objects.move_child(node, idx)

## Every now and then some of them hop to another spot in their place.
func tick(delta: float) -> void:
	_hop_t += delta
	if _hop_t < 0.9: return
	_hop_t = 0.0
	for sid in by_place:
		for c in by_place[sid]:
			if not is_instance_valid(c) or randf() > 0.45: continue
			var target := _spot_point(sid)
			if c is TextureRect and absf(target.x - c.position.x) > 2.0:
				(c as TextureRect).flip_h = (target.x < c.position.x) != bool(c.get_meta("left", false))
			c.pivot_offset = c.size / 2.0
			var tilt := randf_range(0.06, 0.14) * (1.0 if target.x > c.position.x else -1.0)
			var mid: Vector2 = c.position.lerp(target, 0.5) + Vector2(0, -8)
			sort_in(c, maxf(c.position.y, target.y) + c.size.y)
			var tw := map.create_tween()
			tw.tween_property(c, "position", mid, 0.2)
			tw.parallel().tween_property(c, "rotation", tilt, 0.2)
			tw.tween_property(c, "position", target, 0.2)
			tw.parallel().tween_property(c, "rotation", 0.0, 0.2)
