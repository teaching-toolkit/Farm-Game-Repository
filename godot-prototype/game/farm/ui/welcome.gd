extends RefCounted
class_name FarmUiWelcome
## The first minutes: who is playing, the welcome text, naming a new pet.

const UI = preload("res://kits/ui/ui.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ gift cards, names, menu, welcome

func show_name(pet_id: String, default_name: String) -> void:
	var box := M.modals.open_modal(tr("%s A new friend!") % G.nodes[pet_id].get("emoji", "🐾"))
	box.add_child(UI.label(tr("What should we call your new pet?"), 20))
	var le := LineEdit.new()
	le.text = default_name
	le.custom_minimum_size = Vector2(0, 56)
	le.add_theme_font_size_override("font_size", 24)
	box.add_child(le)
	var ok := UI.button(tr("That's the name! ✔"), _name_done.bind(pet_id, le), true, UI.GREEN, 20)
	ok.custom_minimum_size = Vector2(0, 56)
	box.add_child(ok)

func _name_done(pet_id: String, le: LineEdit) -> void:
	G.progression.set_pet_name(pet_id, le.text)
	M.modals.close_modal()

## Who is playing? Everyone has their own farm and their own record of sums and questions practised.
func ask_player() -> void:
	var box := M.modals.open_modal(tr("👋 Who is playing?"))
	box.add_child(UI.label(tr("Your name keeps your own farm and remembers which sums and questions you have practised."), 18, UI.MUTED, true))
	var known: Array = G.players()
	if known.size() > 0:
		var fl := HFlowContainer.new()
		fl.add_theme_constant_override("h_separation", 8)
		fl.add_theme_constant_override("v_separation", 8)
		for nm in known:
			var b := UI.button("🧑‍🌾 " + str(nm), _player_chosen.bind(str(nm)), true, UI.GREEN, 22)
			b.custom_minimum_size = Vector2(0, 58)
			fl.add_child(b)
		box.add_child(fl)
		box.add_child(UI.label(tr("Someone new?"), 18))
	var le := LineEdit.new()
	le.placeholder_text = tr("Your name")
	le.custom_minimum_size = Vector2(0, 58)
	le.add_theme_font_size_override("font_size", 26)
	box.add_child(le)
	var ok := UI.button(tr("That's me! ✔"), _player_typed.bind(le), true, UI.GREEN, 22)
	ok.custom_minimum_size = Vector2(0, 58)
	box.add_child(ok)

func _player_typed(le: LineEdit) -> void:
	if le.text.strip_edges() != "": _player_chosen(le.text.strip_edges())

func _player_chosen(name: String) -> void:
	G.set_player(name)
	M.field_idx = 0
	for f in range(M.map.fields.size()): M.map.fields[f].show_area("field", f)
	M.sheets.close_sheet()
	M.modals.close_modal()
	M.refresh()
	M.notes.toast(tr("👋 Hello, %s!") % name)
	if G.S["step"] == 0 and not G.done("k_wheat"): show_welcome()

func show_welcome() -> void:
	var box := M.modals.open_modal(tr("🔥 Ashes"))
	box.add_child(UI.header(null, "🔥", 72))
	box.add_child(UI.label(tr("Your farm burned down. All that's left: a tent, an old bucket by a wild pond, a tin pot, a few sticks and stones, one wheat seed — and a box with a book in it."), 20, UI.INK, true))
	box.add_child(UI.label(tr("Tap places on the farm to see what you can do there. Every right answer in the ❓ Time Quiz moves farm time forward. When you're tired, tap ⚡ to rest."), 17, UI.MUTED, true))
	var ob := UI.button(tr("📗 Open the book"), _open_first_book, true, UI.GREEN, 20)
	ob.custom_minimum_size = Vector2(0, 56)
	box.add_child(ob)

func _open_first_book() -> void:
	M.modals.close_modal()
	M.cards.show_card("k_wheat")
