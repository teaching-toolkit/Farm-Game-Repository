extends RefCounted
class_name FarmUiModals
## The centred pop-up (quizzes, Rest, cards, gifts, menus): opening, sizing, closing, and what is shown when it closes.

const UI = preload("res://kits/ui/ui.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ pop-up helpers (quizzes, Rest, cards …)

func modal_w() -> float:
	return minf(M.size.x - 36.0, 760.0)

func open_modal(title: String) -> VBoxContainer:
	M.widgets.clear(M.modal_box)
	var h := UI.hbox(8)
	var tl := UI.label(title, 24, UI.INK, true)
	h.add_child(tl)
	var close := UI.soft_button("✖", close_modal, true, 20)
	close.custom_minimum_size = Vector2(52, 44)
	h.add_child(close)
	M.modal_box.add_child(h)
	M.modal.visible = true
	fit_modal()
	fit_modal.call_deferred()
	return M.modal_box

func fit_modal() -> void:
	var w := modal_w()
	M.modal_card.custom_minimum_size = Vector2(w, 0)
	var msc: ScrollContainer = M.modal_box.get_parent()
	M.modal_box.custom_minimum_size = Vector2(w - 40.0, 0)
	var h := M.modal_box.get_combined_minimum_size().y + 8.0
	msc.custom_minimum_size = Vector2(w - 24.0, clampf(h, 120.0, M.size.y - 120.0))
	M.get_tree().create_timer(0.05).timeout.connect(_fit_modal_again)

func _fit_modal_again() -> void:
	var msc: ScrollContainer = M.modal_box.get_parent()
	var h := M.modal_box.get_combined_minimum_size().y + 8.0
	msc.custom_minimum_size = Vector2(modal_w() - 24.0, clampf(h, 120.0, M.size.y - 120.0))

func close_modal() -> void:
	M.modal.visible = false
	M.widgets.clear(M.modal_box)
	M.rest_state = {}
	M.queue_refresh()
	M.mapview.play_fx.call_deferred()
	for t in M.after_close: M.notes.toast(t)
	M.after_close.clear()
	if G.S["gift_pending"].size() > 0: M.gifts.show_gift.call_deferred()
	elif M.celebration_queue.size() > 0: M.celebrations.show_celebration.call_deferred()
