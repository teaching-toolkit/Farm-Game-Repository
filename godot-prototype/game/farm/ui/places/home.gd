extends RefCounted
## The house: bed, gear and what the farmer wears.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Spots = preload("res://game/farm/spots.gd")

var M
var G

const GEAR_SLOTS := [["feet", "👣"], ["hands", "🧤"], ["back", "🎒"], ["bottle", "🫗"], ["head", "👒"], ["apron", "🥼"], ["pillow", "🛌"], ["bed", "🛏️"]]

func _part_home() -> void:
	var rc := UI.card(Color("e8f0f7"))
	var rv := UI.vbox(4)
	rc.add_child(rv)
	var eh := UI.hbox(6)
	eh.add_child(UI.label("⚡", 22))
	eh.add_child(UI.explain(UI.stock_bar(float(G.S["energy"]), G.energy_max(), UI.item_color("energy")), M.tr("⚡ Your energy: work uses it, rest fills it.")))
	rv.add_child(eh)
	var rb := UI.button(M.tr("😴 Rest"), M.ui_rest._show_rest, true, UI.BLUE, 19)
	rb.custom_minimum_size = Vector2(0, 50)
	rv.add_child(rb)
	M.content.add_child(rc)
	var foods := []
	for k in G.S["inv"]:
		if G.items.has(k) and G.items[k].has("buff") and G.count(k) >= 1.0: foods.append(k)
	if foods.size() > 0:
		M.ui_widgets._section(M.tr("😋 Eat something"), M.tr("A good meal makes work cheaper for the next few questions."))
		for k in foods:
			var it: Dictionary = G.items[k]
			var row := UI.hbox(6)
			row.add_child(UI.label("%s %s × %d" % [it.get("emoji", ""), it["name"], G.down(G.count(k))], 17, UI.INK, true))
			row.add_child(UI.soft_button(M.tr("😋 Eat (−%d%% ⚡ for %d)") % [int(round((1.0 - float(it["buff"]["energy"])) * 100)), int(it["buff"]["questions"])], G.eat.bind(k), true, 16))
			M.content.add_child(row)
	var worn := []
	for s in GEAR_SLOTS:
		var cur := ""
		for id in Spots.nodes_at(G, "living"):
			if str(G.nodes[id].get("slot", "")) == "gear:" + s[0] and G.nodes[id]["type"] in ["gear", "helper"] and G.done(id): cur = id
		worn.append("%s %s" % [s[1], G.nodes[cur]["name"] if cur != "" else "—"])
	M.ui_widgets._section(M.tr("👕 What you wear and sleep on"))
	M.content.add_child(UI.label("   ".join(worn), 15, UI.INK, true))
