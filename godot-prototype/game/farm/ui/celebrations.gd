extends RefCounted
## Celebrations: the big pop-up when something new is built, made or found.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")

var M
var G

func _celebrate(id: String) -> void:
	if (not G.nodes.has(id) and not id.begins_with("perk:")) or M._celebrations.has(id): return
	M._celebrations.append(id)
	if not M.modal.visible: call_deferred("_show_celebration")

## The picture of a node for its celebration (the building, the tool on the bench, the helper, the cat).
func _node_picture(id: String) -> Texture2D:
	if id == "barn_cat": return Art.first("animals", ["cat_sit", "cat_walk_1"])
	var t: Texture2D = Art.first("map", [id])
	if t: return t
	t = Art.first("helpers", [id])
	if t: return t
	for b in Spots.BENCH:
		if b["id"] == id: return Art.first("tools", [str(b["pic"])])
	return Art.first("interior", [id])

func _show_celebration() -> void:
	if M.modal.visible or M._celebrations.is_empty(): return
	var id: String = M._celebrations.pop_front()
	M.ui_sounds._sfx("celebrate")
	if M.map.avatar: M.ui_acts._act("cheer", M.map.avatar.feet)
	var perk := id.begins_with("perk:")
	var n: Dictionary = G.perk_def(id.substr(5)) if perk else G.nodes[id]
	var box = M.ui_modal._open_modal(M.tr("✨ A new perk!") if perk else M.tr("✨ New!"))
	box.add_child(UI.header(null if perk else _node_picture(id), str(n.get("emoji", "✨")), 180, Color.WHITE, true))
	var tl := UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 30, UI.INK, true)
	tl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(tl)
	if perk: box.add_child(UI.label("🏅 " + M.ui_menus._perk_reason(n), 20, UI.GREEN_DARK, true))     # why it came, before what it does
	if str(n.get("desc", "")) != "": box.add_child(UI.label(str(n["desc"]), 18, UI.MUTED, true))
	if n.has("effects"):
		var et = M.ui_widgets._effect_text(n["effects"])
		if et != "": box.add_child(UI.label("✨ " + et, 18, UI.GREEN_DARK, true))
	if perk: box.add_child(UI.label(M.tr("It only makes the farm prettier or livelier. Switch it on or off in the album 🖼️."), 16, UI.MUTED, true))
	var ok := UI.button(M.tr("Hooray! 🎉"), M.ui_modal._close_modal, true, UI.GREEN, 24)
	ok.custom_minimum_size = Vector2(0, 62)
	box.add_child(ok)
	# a different effect every time: confetti, stars, fireworks, balloons, sun rays
	var kinds: Array = UI.Celebration.KINDS.duplicate()
	kinds.erase(M._last_fx)
	M._last_fx = kinds[randi() % kinds.size()]
	var fx = UI.Celebration.new()
	M.add_child(fx)
	fx.position = Vector2.ZERO
	fx.size = M.size
	fx.start(M._last_fx, M.size / 2.0)
	M.modal_card.pivot_offset = M.modal_card.size / 2.0
	M.modal_card.scale = Vector2(0.4, 0.4)
	var tw = M.create_tween()
	tw.tween_property(M.modal_card, "scale", Vector2.ONE, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
