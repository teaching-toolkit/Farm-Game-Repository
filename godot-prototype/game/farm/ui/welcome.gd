extends RefCounted
## The welcome at the very start.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")

var M
var G

func _show_welcome() -> void:
	var box = M.ui_modal._open_modal(M.tr("🔥 Ashes"))
	box.add_child(UI.header(null, "🔥", 72))
	box.add_child(UI.label(M.tr("Your farm burned down. All that's left: a tent, an old bucket by a wild pond, a tin pot, a few sticks and stones, one wheat seed — and a box with a book in it."), 20, UI.INK, true))
	box.add_child(UI.label(M.tr("Tap places on the farm to see what you can do there. Every right answer in the ❓ Time Quiz moves farm time forward. When you're tired, tap ⚡ to rest."), 17, UI.MUTED, true))
	var ob := UI.button(M.tr("📗 Open the book"), _open_first_book, true, UI.GREEN, 20)
	ob.custom_minimum_size = Vector2(0, 56)
	box.add_child(ob)

func _open_first_book() -> void:
	M.ui_modal._close_modal()
	M.ui_card._show_card("k_wheat")
