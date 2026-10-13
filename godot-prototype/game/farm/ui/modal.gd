extends RefCounted
## The pop-up window: opening, sizing, closing (and what waits for it to close).
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")

var M
var G

func _modal_w() -> float:
	return minf(M.size.x - 36.0, 760.0)

func _open_modal(title: String) -> VBoxContainer:
	M._clear(M.modal_box)
	var h := UI.hbox(8)
	var tl := UI.label(title, 24, UI.INK, true)
	h.add_child(tl)
	var close := UI.soft_button("✖", _close_modal, true, 20)
	close.custom_minimum_size = Vector2(52, 44)
	h.add_child(close)
	M.modal_box.add_child(h)
	M.modal.visible = true
	_fit_modal()
	call_deferred("_fit_modal")
	return M.modal_box

func _fit_modal() -> void:
	var w := _modal_w()
	M.modal_card.custom_minimum_size = Vector2(w, 0)
	var msc: ScrollContainer = M.modal_box.get_parent()
	M.modal_box.custom_minimum_size = Vector2(w - 40.0, 0)
	var h = M.modal_box.get_combined_minimum_size().y + 8.0
	msc.custom_minimum_size = Vector2(w - 24.0, clampf(h, 120.0, M.size.y - 120.0))
	M.get_tree().create_timer(0.05).timeout.connect(_fit_modal_again)

func _fit_modal_again() -> void:
	var msc: ScrollContainer = M.modal_box.get_parent()
	var h = M.modal_box.get_combined_minimum_size().y + 8.0
	msc.custom_minimum_size = Vector2(_modal_w() - 24.0, clampf(h, 120.0, M.size.y - 120.0))

func _close_modal() -> void:
	M.modal.visible = false
	M._clear(M.modal_box)
	M._rest = {}
	M._queue_refresh()
	if M.ui_play.hold: M.ui_play.end()          # after the Time Quiz: the playback (it plays the pests too)
	else: M.ui_map.call_deferred("_play_fx")
	for t in M._after_close: M.ui_notes._toast(t)
	M._after_close.clear()
	if G.S["gift_pending"].size() > 0: M.ui_postcards.call_deferred("_show_gift")
	elif M._celebrations.size() > 0: M.ui_celebrate.call_deferred("_show_celebration")
