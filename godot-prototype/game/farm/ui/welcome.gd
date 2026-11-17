extends RefCounted
class_name FarmUiWelcome
## The first minutes: who is playing, the welcome text, naming a new pet.

const UI = preload("res://kits/ui/ui.gd")
const AvatarPicker = preload("res://kits/avatar/avatar_picker.gd")


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
	first_minutes()
	M.interrupts.restore()      # this farm's waiting celebrations, after the welcome or the story box

## The first minutes of a farm that has only just begun, in order: the farmer is made (once; a farm that never asks keeps the default look), then
## the story's opening or the welcome. Tests, the bot and screenshots have no named player, so they skip the screen.
func first_minutes() -> void:
	if G.player != "" and M.shot_path == "" and G.people.farmer_to_make(): show_farmer()
	elif G.S["step"] == 0 and not G.done("k_wheat") and not M.story.pump(): show_welcome()

## "Make your farmer" (people/02): no words, no name, no photo. The figure stands big and changes as the child taps colours and small figures
## (kits/avatar/avatar_picker.gd offers exactly what data/avatar.json offers); the round tick keeps the look in the farm save and goes on.
## There is no ✖: the tick is the one way on, and the default look is already chosen.
func show_farmer() -> void:
	var box := M.modals.open_modal("🧑‍🌾", false)
	var picker := AvatarPicker.new()
	picker.name = "FarmerPicker"
	box.add_child(picker)
	var ok := UI.button("", _farmer_done.bind(picker), true, UI.GREEN, 38)       # a round button with a tick drawn on it (no text)
	ok.name = "FarmerDone"
	ok.custom_minimum_size = Vector2(76, 76)
	ok.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	for st in ["normal", "hover", "pressed", "disabled"]:
		var sb: StyleBoxFlat = ok.get_theme_stylebox(st).duplicate()
		sb.set_corner_radius_all(38)
		ok.add_theme_stylebox_override(st, sb)
	ok.draw.connect(_draw_tick.bind(ok))
	picker.side.add_child(ok)

func _draw_tick(ok: Button) -> void:
	if not is_instance_valid(ok): return
	var pts := PackedVector2Array([Vector2(0.27, 0.53), Vector2(0.43, 0.69), Vector2(0.75, 0.33)])
	for i in pts.size(): pts[i] *= ok.size
	ok.draw_polyline(pts, Color.WHITE, 9.0, true)
	for p in pts: ok.draw_circle(p, 4.5, Color.WHITE)

func _farmer_done(picker: Control) -> void:
	G.people.set_farmer_look(picker.look)
	M.modals.close_modal()
	first_minutes()

## The first words of the game. After the opening story (`after_story`) only the hints are left: what to do first, and how it works.
func show_welcome(after_story := false) -> void:
	var box := M.modals.open_modal(tr("💡 How to play") if after_story else tr("🔥 Ashes"))
	box.add_child(UI.header(null, "💡" if after_story else "🔥", 72))
	if after_story:
		box.add_child(UI.label(tr("In the tent is a box with a book in it. Open it, and your seed can grow."), 20, UI.INK, true))
	else:
		box.add_child(UI.label(tr("Your farm burned down. All that's left: a tent, an old bucket by a wild pond, a tin pot, a few sticks and stones, one wheat seed — and a box with a book in it."), 20, UI.INK, true))
	box.add_child(UI.label(tr("Tap places on the farm to see what you can do there. Every right answer in the ❓ Time Quiz moves farm time forward. When you're tired, tap ⚡ to rest."), 17, UI.MUTED, true))
	var ob := UI.button(tr("📗 Open the book"), _open_first_book, true, UI.GREEN, 20)
	ob.custom_minimum_size = Vector2(0, 56)
	box.add_child(ob)

func _open_first_book() -> void:
	M.modals.close_modal()
	M.cards.show_card("k_wheat")
