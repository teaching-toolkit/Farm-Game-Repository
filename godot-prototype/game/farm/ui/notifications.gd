extends RefCounted
## Notifications: toasts, hints and the "like" pop.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")

var M
var G

## A short note when a bar is tapped (what it shows); it goes away sooner than other notes and not into the log.
func _hint(t: String) -> void:
	_toast(t, 3.0)

## A note like a phone's (J5): it appears at the top, just below the bar, newest on top (three at most); it goes by itself
## after a while that depends on its length (hints: 3 s), and a swipe in any direction sends it away sooner.
func _toast(t: String, secs := -1.0) -> void:
	if t.begins_with("⚡"): M.ui_sounds._sfx("tired")             # too tired: a soft "not now"
	# what flies to the store needs no words (it still goes into the log)
	# harvests, collections and finished recipes fly to the store instead of a toast (in any language: the message's
	# translated wording without its %s parts)
	if _like(t, M.tr("🧺 Harvested %s: %s")) or _like(t, M.tr("%s Collected: %s")) or _like(t, M.tr("✨ %s ready: %s")): return
	if secs < 0.0: secs = clampf(3.5 + 0.035 * t.length(), 4.0, 7.0)
	var p := SwipeCard.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(1, 0.98, 0.9, 0.97), 14, UI.LINE, 1, 10))
	var l := UI.label(t, 18, UI.INK, true)
	l.custom_minimum_size = Vector2(_width(), 0)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(l)
	M.toasts.add_child(p)
	M.toasts.move_child(p, 0)
	while M.toasts.get_child_count() > 3:
		var old = M.toasts.get_child(M.toasts.get_child_count() - 1)
		M.toasts.remove_child(old); old.queue_free()
	_place_toasts()
	call_deferred("_place_toasts")
	var tw = M.create_tween()
	tw.tween_interval(secs)
	tw.tween_property(p, "modulate:a", 0.0, 0.6)
	tw.tween_callback(_free_if_valid.bind(p))

func _width() -> float:
	return minf(M.size.x - 200.0, 620.0)

## Does message t come from this format (its fixed words in the same order)?
func _like(t: String, fmt: String) -> bool:
	var at := 0
	for part in fmt.split("%s"):
		if part.strip_edges() == "": continue
		var k := t.find(part.strip_edges(), at)
		if k < 0: return false
		at = k + part.strip_edges().length()
	return true

func _place_toasts() -> void:
	if M.toasts == null: return
	var ts = M.toasts.get_combined_minimum_size()
	M.toasts.size = ts
	M.toasts.position = Vector2((M.size.x - ts.x) / 2.0, M.ui_top.bottom_y() + 8.0)

func _free_if_valid(n) -> void:      # untyped: the toast may be gone already (removed early when too many came)
	if is_instance_valid(n): n.queue_free()

## A note that a swipe sends away (left, right or up, whichever way the finger goes).
class SwipeCard extends PanelContainer:
	var _from := Vector2.ZERO
	var _down := false

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP

	func _gui_input(e: InputEvent) -> void:
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			_down = e.pressed
			_from = e.position
		elif e is InputEventMouseMotion and _down and e.position.distance_to(_from) > 30.0:
			_down = false
			var d: Vector2 = (e.position - _from).normalized()
			mouse_filter = Control.MOUSE_FILTER_IGNORE
			var tw := create_tween()
			tw.tween_property(self, "position", position + d * 500.0, 0.25)
			tw.parallel().tween_property(self, "modulate:a", 0.0, 0.25)
			tw.tween_callback(queue_free)
