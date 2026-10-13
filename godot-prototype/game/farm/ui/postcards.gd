extends RefCounted
## Postcards and gift cards, naming a pet.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")

var M
var G

## A postcard from a friend (someone you helped) who heard of your success, with a gift: pick one of 1–3.
func _show_gift(_offer = null) -> void:
	if M.modal.visible: return
	var pc: Dictionary = G.postcard_pending()
	if pc.is_empty(): return
	M.ui_sounds._sfx("chime")
	var box = M.ui_modal._open_modal(M.tr("📬 A postcard!"))
	box.add_child(_postcard(pc))
	var offer: Array = pc.get("offer", [])
	box.add_child(UI.label(M.tr("Pick one gift:") if offer.size() > 1 else M.tr("A gift for you:"), 18, UI.MUTED))
	for gid in offer:
		var c: Dictionary = G.gift_card(gid)
		var b := UI.button("%s  %s\n%s" % [c.get("emoji", "🎁"), c["name"], c.get("desc", "")], _pick_gift.bind(gid), true, Color("7a9a4a"), 19)
		b.custom_minimum_size = Vector2(0, 96)
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(b)
	if G.friends().size() < 3:
		box.add_child(UI.label(M.tr("💡 More friends, more postcards — and more gifts to choose from. Help a neighbour (📖 Quest book)!"), 15, UI.MUTED, true))
	M.modal_card.pivot_offset = M.modal_card.size / 2.0
	M.modal_card.scale = Vector2(0.6, 0.6)
	M.create_tween().tween_property(M.modal_card, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	M.ui_modal.call_deferred("_fit_modal")

## The postcard itself: the friend's words on the left, a stamp with their picture on the right.
func _postcard(pc: Dictionary, small := false) -> PanelContainer:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", UI.box(Color("fffaf0"), 8, Color("c9b48a"), 2, 10 if small else 16))
	var h := UI.hbox(12)
	card.add_child(h)
	var txt := UI.vbox(6)
	txt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	txt.add_child(UI.label(str(pc.get("text", "")), 15 if small else 20, UI.INK, true))
	var sig := UI.label("— %s %s" % [pc.get("emoji", ""), pc.get("from", "")], 15 if small else 19, Color("6b4a2b"), true)
	sig.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	txt.add_child(sig)
	if small and pc.has("gift"):
		var c: Dictionary = G.gift_card(str(pc["gift"]))
		txt.add_child(UI.label("🎁 %s %s" % [c.get("emoji", ""), c.get("name", "")], 14, UI.MUTED))
	h.add_child(txt)
	var st := PanelContainer.new()
	st.add_theme_stylebox_override("panel", UI.box(Color("f6e7c8"), 3, Color("b5562b"), 3, 6))
	st.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var sv := UI.vbox(0)
	st.add_child(sv)
	# assets/friends/<side quest>.png when drawn; a friend helped twice has one portrait, under the first favour
	var pkeys := [str(pc.get("quest", ""))]
	for sq in G.nodes:
		if G.nodes[sq]["type"] == "sidequest" and str(G.nodes[sq].get("friend", {}).get("name", "")) == str(pc.get("from", "")): pkeys.append(sq)
	var portrait: Texture2D = Art.first("friends", pkeys)
	if portrait:
		var pt := TextureRect.new()
		pt.texture = portrait
		pt.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pt.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pt.custom_minimum_size = Vector2(48, 56) if small else Vector2(96, 112)
		sv.add_child(pt)
	else:
		var se := UI.label(str(pc.get("emoji", "💌")), 26 if small else 44)
		se.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		sv.add_child(se)
	var sl := UI.label(M.tr("FARM POST"), 9 if small else 11, Color("b5562b"))
	sl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sv.add_child(sl)
	h.add_child(st)
	return card

func _pick_gift(gid: String) -> void:
	G.pick_gift(gid)
	M.ui_modal._close_modal()

func _show_name(pet_id: String, default_name: String) -> void:
	var box = M.ui_modal._open_modal(M.tr("%s A new friend!") % G.nodes[pet_id].get("emoji", "🐾"))
	box.add_child(UI.label(M.tr("What should we call your new pet?"), 20))
	var le := LineEdit.new()
	le.text = default_name
	le.custom_minimum_size = Vector2(0, 56)
	le.add_theme_font_size_override("font_size", 24)
	box.add_child(le)
	var ok := UI.button(M.tr("That's the name! ✔"), _name_done.bind(pet_id, le), true, UI.GREEN, 20)
	ok.custom_minimum_size = Vector2(0, 56)
	box.add_child(ok)

func _name_done(pet_id: String, le: LineEdit) -> void:
	G.set_pet_name(pet_id, le.text)
	M.ui_modal._close_modal()
