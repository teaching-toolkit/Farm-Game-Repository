extends RefCounted
## World kit · things flying: pieces fly from one point to another in an arc, growing and then shrinking (3 carrots
## harvested = 3 carrots flying); pieces that do not fit hit the target, bounce off and spin away.
##   const Flight = preload("res://kits/world/flight.gd")
##   Flight.fly(layer, from, to, pieces, bounce, on_landed, on_full)
## pieces / bounce = [[emoji, texture or null], …]; on_landed(node) is called for each landed piece, on_full() when a
## bouncing piece hits the target. layer is the Control the pieces are drawn on (its tweens run them).
const UI = preload("res://kits/ui/ui.gd")

static func fly(layer: Control, from: Vector2, to: Vector2, pieces: Array, bounce: Array, on_landed: Callable, on_full: Callable) -> void:
	var delay := 0.0
	var all := []
	for pc in pieces: all.append([pc, false])
	for pc in bounce: all.append([pc, true])
	for item in all:
		var pc: Array = item[0]
		var off: bool = item[1]
		var node: Control
		var tex: Texture2D = pc[1]
		if tex:
			var tr := TextureRect.new()
			tr.texture = tex
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr.size = Vector2(36, 36)
			node = tr
		else:
			node = UI.label(str(pc[0]), 26)
			node.size = Vector2(36, 36)
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
		node.pivot_offset = Vector2(18, 18)
		var start := from + Vector2(randf_range(-14, 14), randf_range(-10, 6))
		node.position = start - Vector2(18, 18)
		node.scale = Vector2(0.7, 0.7)
		node.modulate.a = 0.0
		layer.add_child(node)
		var lift := maxf(110.0, start.distance_to(to) * 0.45)
		var ctrl := (start + to) / 2.0 + Vector2(randf_range(-30, 30), -lift)
		var tw := layer.create_tween()
		tw.tween_interval(delay)
		tw.tween_property(node, "modulate:a", 1.0, 0.08)
		if off:
			tw.tween_method(step.bind(node, start, ctrl, to + Vector2(0, -26)), 0.0, 0.92, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			tw.tween_callback(on_full)
			var away := to + Vector2(randf_range(60, 120) * (-1.0 if randf() < 0.5 else 1.0), -150)
			tw.tween_property(node, "position", away - Vector2(18, 18), 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tw.parallel().tween_property(node, "rotation", randf_range(-6.0, 6.0), 0.55)
			tw.tween_property(node, "position", away + Vector2(0, 160), 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			tw.parallel().tween_property(node, "modulate:a", 0.0, 0.45)
			tw.tween_callback(node.queue_free)
		else:
			tw.tween_method(step.bind(node, start, ctrl, to), 0.0, 1.0, 0.85).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tw.tween_callback(on_landed.bind(node))
		delay += 0.11

## One moment of a flight (t from 0 to 1 along the arc a → c → b).
static func step(t: float, node: Control, a: Vector2, c: Vector2, b: Vector2) -> void:
	if not is_instance_valid(node): return
	var p := a.lerp(c, t).lerp(c.lerp(b, t), t)
	node.position = p - Vector2(18, 18)
	var s := 0.7 + 0.9 * sin(PI * minf(1.0, t * 1.15))      # grows on the way up, shrinks into the target
	if t > 0.85: s = lerpf(s, 0.35, (t - 0.85) / 0.15)
	node.scale = Vector2(s, s)
