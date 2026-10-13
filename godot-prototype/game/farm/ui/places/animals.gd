extends RefCounted
## Animal pens: the animal cards and feed.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")

var M
var G

func _animal_card(aid: String) -> PanelContainer:
	var n: Dictionary = G.nodes[aid]
	var a: Dictionary = G.animal(aid)
	var pc := UI.card()
	var v := UI.vbox(4)
	pc.add_child(v)
	var h := UI.hbox(6)
	v.add_child(h)
	h.add_child(UI.label("%s %s  %d / %d" % [n.get("emoji", ""), n["name"], int(a["count"]), G.animal_cap(aid)], 20, UI.INK, true))
	var can_buy: bool = int(a["count"]) < G.animal_cap(aid) and G.missing_cost(G.animal_price(aid)).is_empty()
	h.add_child(UI.button(M.tr("Buy one  ") + G.cost_text(G.animal_price(aid)), G.buy_animal.bind(aid), can_buy, UI.GREEN, 16))
	v.add_child(UI.label(str(n.get("desc", "")), 15, UI.MUTED, true))
	if G.animal_cap(aid) <= 0: v.add_child(UI.label(M.tr("No room yet: build them a home first."), 15, UI.RED, true))
	var ag = M.ui_place._grid(2)
	if int(a["count"]) > 0:
		var ready: bool = G.S["step"] >= int(a["ready"])
		var ct = M.ui_place._tile(null, "🧺", M.tr("Collect · they need:"))
		ct.add_child(M.ui_widgets._costs(G.feed_needs(aid), _feed_base(aid)))
		if ready: M.ui_place._tile_button(ct, UI.action_button("animal", G.collect_animal.bind(aid), true))
		else: M.ui_place._tile_button(ct, UI.wait_button(int(a["ready"]) - G.S["step"], M.ui_quiz._show_time_quiz))
		ag.add_child(ct.get_meta("panel"))
		if n.get("needsFlowers", false):
			v.add_child(UI.label(M.tr("🌼 Flowers on the farm: %s") % ("yes" if G.has_flowers() else M.tr("none — plant clover, flax or sunflowers")), 15, UI.GREEN_DARK if G.has_flowers() else UI.RED, true))
		if float(n.get("muck", 0.0)) > 0.0:
			var mf: float = G.muck_factor(aid)
			var mt = M.ui_place._tile(null, "💩", M.tr("Muck %d") % G.down(a["muck"]))
			if mf < 1.0: mt.add_child(UI.label(M.tr("Animals give %d%% less!") % int(round((1.0 - mf) * 100)), 15, UI.RED, true))
			mt.add_child(M.ui_widgets._costs({"energy": G.ecost("animal", float(a["muck"]) * 0.5)}, {"energy": float(a["muck"]) * 0.5}))
			M.ui_place._tile_button(mt, UI.action_button("animal", G.muck_out.bind(aid), float(a["muck"]) >= 0.5, UI.SOIL, "🧹", M.tr("Clean")))
			ag.add_child(mt.get_meta("panel"))
	if ag.get_child_count() > 0: v.add_child(ag)
	return pc

## What a collection would need without any upgrade (to show the saving as grey cubes).
func _feed_base(aid: String) -> Dictionary:
	var n: Dictionary = G.nodes[aid]
	var cnt := int(G.animal(aid)["count"])
	var out := {}
	for k in n.get("feed", {}): out[k] = float(n["feed"][k]) * cnt
	if float(n.get("feedWater", 0)) > 0.0: out["water"] = float(n["feedWater"]) * cnt
	out["energy"] = float(n.get("collectEnergy", 1)) * cnt
	return out
