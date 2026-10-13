extends RefCounted
class_name FarmUiNotes
## Short notices on the farm (toasts) and the explanations that pop up when a bar or button is held.

const UI = preload("res://kits/ui/ui.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ inside a building

## A short note when a bar is tapped (what it shows); it goes away sooner than other notes and not into the log.
func hint(t: String) -> void:
	toast(t, 3.0)

func toast(t: String, secs := 6.5) -> void:
	if t.begins_with("⚡"): M.feedback.sfx("tired")             # too tired: a soft "not now"
	# what flies to the store needs no words (it still goes into the log)
	# harvests, collections and finished recipes fly to the store instead of a toast (in any language: the message's
	# translated wording without its %s parts)
	if _like(t, tr("🧺 Harvested %s: %s")) or _like(t, tr("%s Collected: %s")) or _like(t, tr("✨ %s ready: %s")): return
	var p := UI.card(Color(1, 0.98, 0.9, 0.97), UI.LINE)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var l := UI.label(t, 22, UI.INK, true)
	l.custom_minimum_size = Vector2(minf(M.size.x - 40.0, 720.0), 0)
	p.add_child(l)
	M.toasts.add_child(p)
	while M.toasts.get_child_count() > 3:
		var old := M.toasts.get_child(0)
		M.toasts.remove_child(old); old.queue_free()
	place_toasts()
	place_toasts.call_deferred()
	var tw := M.create_tween()
	tw.tween_interval(secs)
	tw.tween_property(p, "modulate:a", 0.0, 1.0)
	tw.tween_callback(_free_if_valid.bind(p))

## Does message t come from this format (its fixed words in the same order)?
func _like(t: String, fmt: String) -> bool:
	var at := 0
	for part in fmt.split("%s"):
		if part.strip_edges() == "": continue
		var k := t.find(part.strip_edges(), at)
		if k < 0: return false
		at = k + part.strip_edges().length()
	return true

func place_toasts() -> void:
	if M.toasts == null: return
	var ts := M.toasts.get_combined_minimum_size()
	M.toasts.size = ts
	var floor_y: float = M.sheet.position.y if M.sheet.visible else M.bottom.global_position.y
	M.toasts.position = Vector2((M.size.x - ts.x) / 2.0, floor_y - ts.y - 10.0)

func _free_if_valid(n) -> void:      # untyped: the toast may be gone already (removed early when too many came)
	if is_instance_valid(n): n.queue_free()
