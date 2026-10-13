extends RefCounted
## The pet corner.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")

var M
var G

func _part_pets() -> void:
	var any := false
	for pid in G.pet_ids():
		if not G.done(pid): continue
		any = true
		var n: Dictionary = G.nodes[pid]
		var row := UI.hbox(6)
		row.add_child(UI.label("%s %s — %s" % [n.get("emoji", ""), G.S["pet_names"].get(pid, n.get("defaultName", "")), M.ui_widgets._effect_text(n.get("effects", {}))], 17, UI.INK, true))
		row.add_child(UI.soft_button(M.tr("✏️ Name"), M.ui_postcards._show_name.bind(pid, str(G.S["pet_names"].get(pid, n.get("defaultName", "")))), true, 15))
		M.content.add_child(row)
	if not any: M.content.add_child(UI.label(M.tr("Your first pet, a bunny, comes home at the end of chapter 1."), 16, UI.MUTED, true))
