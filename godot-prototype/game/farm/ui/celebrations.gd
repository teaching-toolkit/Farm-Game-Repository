extends RefCounted
class_name FarmUiCelebrations
## The big pop-up with confetti for something new: a building, tool or helper.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

var _last_fx := ""             # the celebration effect shown last time (the next one is different)

# ------------------------------------------------------------------ celebrations: something new was built or made

func celebrate(id: String) -> void:
	if (not G.nodes.has(id) and not id.begins_with("perk:")) or M.celebration_queue.has(id): return
	M.celebration_queue.append(id)
	if not M.modal.visible: show_celebration.call_deferred()

## The picture of a node for its celebration (the building, the tool on the bench, the helper, the cat).
func _node_picture(id: String) -> Texture2D:
	if id == "barn_cat": return Art.first("animals", ["cat_sit", "cat_walk_1"])
	var t: Texture2D = Art.first("map", [id])
	if t: return t
	t = Art.first("helpers", [id])
	if t: return t
	for b in Spots.bench():
		if b["id"] == id: return Art.first("tools", [str(b["pic"])])
	return Art.first("interior", [id])

func show_celebration() -> void:
	if M.modal.visible or M.celebration_queue.is_empty(): return
	var id: String = M.celebration_queue.pop_front()
	M.feedback.sfx("celebrate")
	if M.map.avatar: M.feedback.play_act("cheer", M.map.avatar.feet)
	var perk := id.begins_with("perk:")
	var n: Dictionary = G.rewards.perk_def(id.substr(5)) if perk else G.nodes[id]
	var box := M.modals.open_modal(tr("✨ A new perk!") if perk else tr("✨ New!"))
	box.add_child(UI.header(null if perk else _node_picture(id), str(n.get("emoji", "✨")), 180, Color.WHITE, true))
	var tl := UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 30, UI.INK, true)
	tl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(tl)
	if perk: box.add_child(UI.label("🏅 " + M.album.perk_reason(n), 20, UI.GREEN_DARK, true))     # why it came, before what it does
	if str(n.get("desc", "")) != "": box.add_child(UI.label(str(n["desc"]), 18, UI.MUTED, true))
	if n.has("effects"):
		var et := M.widgets.effect_text(n["effects"])
		if et != "": box.add_child(UI.label("✨ " + et, 18, UI.GREEN_DARK, true))
	if perk: box.add_child(UI.label(tr("It only makes the farm prettier or livelier. Switch it on or off in the album 🖼️."), 16, UI.MUTED, true))
	var ok := UI.button(tr("Hooray! 🎉"), M.modals.close_modal, true, UI.GREEN, 24)
	ok.custom_minimum_size = Vector2(0, 62)
	box.add_child(ok)
	# a different effect every time: confetti, stars, fireworks, balloons, sun rays
	var kinds: Array = UI.Celebration.KINDS.duplicate()
	kinds.erase(_last_fx)
	_last_fx = kinds[randi() % kinds.size()]
	var fx = UI.Celebration.new()
	M.add_child(fx)
	fx.position = Vector2.ZERO
	fx.size = M.size
	fx.start(_last_fx, M.size / 2.0)
	M.modal_card.pivot_offset = M.modal_card.size / 2.0
	M.modal_card.scale = Vector2(0.4, 0.4)
	var tw := M.create_tween()
	tw.tween_property(M.modal_card, "scale", Vector2.ONE, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
