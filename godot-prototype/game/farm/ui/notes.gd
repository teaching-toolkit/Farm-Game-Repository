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

func toast(t: String, secs := 5.0) -> void:
	if t.begins_with("⚡"): M.feedback.sfx("tired")             # too tired: a soft "not now"
	# what flies to the store needs no words (it still goes into the log)
	# harvests, collections and finished recipes fly to the store instead of a toast (in any language: the message's
	# translated wording without its %s parts)
	if _like(t, tr("🧺 Harvested %s: %s")) or _like(t, tr("%s Collected: %s")) or _like(t, tr("✨ %s ready: %s")): return
	M.toasts.notify(t, secs)

## Does message t come from this format (its fixed words in the same order)?
func _like(t: String, fmt: String) -> bool:
	var at := 0
	for part in fmt.split("%s"):
		if part.strip_edges() == "": continue
		var k := t.find(part.strip_edges(), at)
		if k < 0: return false
		at = k + part.strip_edges().length()
	return true

## The stack starts just below the top bar.
func place_toasts() -> void:
	if M.toasts == null or M.hud_panel == null: return
	M.toasts.top = M.hud_panel.size.y + 8.0
	M.toasts.place()

## A part of the interface comes into view for the first time (G.reveal): say so, and let its icon hop.
func on_revealed(id: String) -> void:
	var what := ""
	match id:
		"coins": what = tr("🪙 your purse")
		"album": what = tr("🖼️ the album")
		_: return
	toast(tr("✨ New: %s") % what, 6.0)
	var node: Control = M.lbl_coins if id == "coins" else M.icon_buttons.get(id)
	if node == null: return
	node.visible = true
	node.pivot_offset = node.size / 2.0
	var tw := node.create_tween()
	tw.tween_property(node, "scale", Vector2(1.5, 1.5), 0.2)
	tw.tween_property(node, "scale", Vector2.ONE, 0.25)
