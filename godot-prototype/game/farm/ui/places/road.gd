extends RefCounted
## The road and who can come along it.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")

var M
var G

## The road: how good it is, and who can come along it to the market.
func _part_road() -> void:
	var lv := int(round(G.g("roadLevel", 1.0)))
	var rc := UI.card(Color("f6efe0"))
	var rv := UI.vbox(4)
	rc.add_child(rv)
	var stars := UI.hbox(4)
	for i in range(5): stars.add_child(UI.label("🟫" if i < lv else "▫️", 22))
	rv.add_child(stars)
	var who := []
	for mid in G.nodes:
		var mn: Dictionary = G.nodes[mid]
		if mn["type"] == "merchant" and G.done(mid): who.append(str(mn.get("emoji", "🧑")))
	if who.size() > 0: rv.add_child(UI.label(M.tr("Coming to your market:  ") + " ".join(who), 17, UI.INK, true))
	var blocked := 0
	for mid in G.nodes:
		var mn2: Dictionary = G.nodes[mid]
		if mn2["type"] != "merchant" or G.done(mid) or not M.ui_map._in_chapter(mid): continue
		var road_only := false
		var other := false
		for q in mn2.get("requires", []):
			if G.satisfied(q): continue
			if str(q).begins_with("road_"): road_only = true
			else: other = true
		if road_only and not other: blocked += 1
	if blocked > 0: rv.add_child(UI.label(M.tr("🚧 %s can't get through yet — a better road lets them come.") % "🧑‍🌾".repeat(mini(blocked, 5)), 16, UI.RED, true))
	M.content.add_child(rc)
