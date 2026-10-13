extends VBoxContainer
## Phone-like notifications: small cards that stack from the top of the screen (just below the top bar), each stays for a while
## (its own number of seconds: a hint is gone sooner than news) and goes away by itself, or at once when it is swiped
## sideways. Taps outside the cards go through to the farm. At most `max_shown` at a time (the oldest leaves first).
## Knows nothing about any game: the game decides what to say and for how long, and where the stack starts.
##   var n = Notifications.new();  parent.add_child(n)
##   n.top = 120.0                 # y of the first card (just below the top bar); n.place() after the size of the screen changes
##   n.notify("A bunny came home!", 5.0)

const UI = preload("ui.gd")

var top := 0.0                 # where the stack starts (screen y)
var max_shown := 4
var max_width := 560.0         # cards are never wider than this (or the screen minus a margin)
var font_size := 17
var swipe_distance := 70.0     # a swipe of this many pixels sends a card away
signal dismissed(text: String)
signal tapped(text: String)    # a sticky card was tapped (it goes away)

func _init() -> void:
	add_theme_constant_override("separation", 4)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

## A sticky card (`sticky`: a speech bubble) stays until it is tapped or swiped away; it is the last to be pushed out by newer cards.
func notify(text: String, secs := 5.0, sticky := false) -> void:
	var card := UI.card(Color(1, 0.98, 0.9, 0.97), UI.LINE)
	card.mouse_filter = Control.MOUSE_FILTER_STOP
	card.size_flags_horizontal = Control.SIZE_FILL
	var l := UI.label(text, font_size, UI.INK, true)
	var parent_w: float = get_parent().size.x if get_parent() is Control else 834.0
	l.custom_minimum_size = Vector2(minf(max_width, parent_w - 60.0), 0)
	card.add_child(l)
	var slot := Control.new()                   # the card lives inside a slot so that it can be moved sideways while the stack stays in order
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slot.set_meta("text", text)
	slot.set_meta("sticky", sticky)
	slot.add_child(card)
	add_child(slot)
	slot.custom_minimum_size = card.get_combined_minimum_size()
	card.gui_input.connect(_on_card_input.bind(slot, card))
	while get_child_count() > max_shown:
		var old := get_child(0)
		for c in get_children():
			if not c.get_meta("sticky", false): old = c; break
		remove_child(old); old.queue_free()
	place()
	place.call_deferred()
	if sticky: return
	var tw := create_tween()
	tw.tween_interval(secs)
	tw.tween_property(card, "modulate:a", 0.0, 0.8)
	tw.tween_callback(_remove.bind(slot))

## Puts the stack at the top, in the middle of the screen's width.
func place() -> void:
	var ts := get_combined_minimum_size()
	size = ts
	var w: float = get_parent().size.x if get_parent() is Control else ts.x
	position = Vector2((w - ts.x) / 2.0, top)

func _remove(slot) -> void:                      # untyped: the slot may be gone already (removed early when too many came)
	if is_instance_valid(slot):
		slot.queue_free()
		place.call_deferred()

var _drag := {}

func _on_card_input(e: InputEvent, slot: Control, card: Control) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		if e.pressed:
			_drag = {"slot": slot, "x": e.global_position.x}
		elif _drag.get("slot") == slot:
			var dx: float = card.position.x
			_drag = {}
			if absf(dx) >= swipe_distance: _swipe_away(slot, card, signf(dx))
			elif absf(dx) < 8.0 and slot.get_meta("sticky", false):
				tapped.emit(str(slot.get_meta("text", "")))
				_swipe_away(slot, card, 1.0)
			else: create_tween().tween_property(card, "position:x", 0.0, 0.12)
	elif e is InputEventMouseMotion and _drag.get("slot") == slot:
		card.position.x = e.global_position.x - float(_drag["x"])
		card.modulate.a = clampf(1.0 - absf(card.position.x) / 400.0, 0.3, 1.0)

func _swipe_away(slot: Control, card: Control, dir: float) -> void:
	dismissed.emit(str(slot.get_meta("text", "")))
	var tw := create_tween()
	tw.tween_property(card, "position:x", dir * (card.size.x + 80.0), 0.18)
	tw.parallel().tween_property(card, "modulate:a", 0.0, 0.18)
	tw.tween_callback(_remove.bind(slot))
