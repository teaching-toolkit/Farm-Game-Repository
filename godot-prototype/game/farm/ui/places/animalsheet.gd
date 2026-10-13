extends RefCounted
class_name FarmUiAnimalSheet
## Animal cards: feeding, collecting, cleaning.

const UI = preload("res://kits/ui/ui.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ what a place shows

func animal_card(aid: String) -> PanelContainer:
	var n: Dictionary = G.nodes[aid]
	var a: Dictionary = G.animals.animal(aid)
	var pc := UI.card()
	var v := UI.vbox(4)
	pc.add_child(v)
	var h := UI.hbox(6)
	v.add_child(h)
	h.add_child(UI.label("%s %s  %d / %d" % [n.get("emoji", ""), n["name"], int(a["count"]), G.animals.animal_cap(aid)], 20, UI.INK, true))
	var can_buy: bool = int(a["count"]) < G.animals.animal_cap(aid) and G.pace.missing_cost(G.animals.animal_price(aid)).is_empty()
	h.add_child(UI.button(tr("Buy one  ") + G.pace.cost_text(G.animals.animal_price(aid)), G.animals.buy_animal.bind(aid), can_buy, UI.GREEN, 16))
	v.add_child(UI.label(str(n.get("desc", "")), 15, UI.MUTED, true))
	if G.animals.animal_cap(aid) <= 0: v.add_child(UI.label(tr("No room yet: build them a home first."), 15, UI.RED, true))
	var ag := M.widgets.grid(2)
	if int(a["count"]) > 0:
		var ready: bool = G.S["step"] >= int(a["ready"])
		var ct := M.widgets.tile(null, "🧺", tr("Collect · they need:"))
		ct.add_child(M.widgets.costs(G.animals.feed_needs(aid), _feed_base(aid)))
		if ready: M.widgets.tile_button(ct, UI.action_button("animal", G.animals.collect_animal.bind(aid), true))
		else: M.widgets.tile_button(ct, UI.wait_button(int(a["ready"]) - G.S["step"], M.timequiz.show_time_quiz))
		ag.add_child(ct.get_meta("panel"))
		if n.get("needsFlowers", false):
			v.add_child(UI.label(tr("🌼 Flowers on the farm: %s") % ("yes" if G.animals.has_flowers() else tr("none — plant clover, flax or sunflowers")), 15, UI.GREEN_DARK if G.animals.has_flowers() else UI.RED, true))
		if float(n.get("muck", 0.0)) > 0.0:
			var mf: float = G.animals.muck_factor(aid)
			var mt := M.widgets.tile(null, "💩", tr("Muck %d") % G.down(a["muck"]))
			if mf < 1.0: mt.add_child(UI.label(tr("Animals give %d%% less!") % int(round((1.0 - mf) * 100)), 15, UI.RED, true))
			mt.add_child(M.widgets.costs({"energy": G.needs.ecost("animal", float(a["muck"]) * 0.5)}, {"energy": float(a["muck"]) * 0.5}))
			M.widgets.tile_button(mt, UI.action_button("animal", G.animals.muck_out.bind(aid), float(a["muck"]) >= 0.5, UI.SOIL, "🧹", tr("Clean")))
			ag.add_child(mt.get_meta("panel"))
	if ag.get_child_count() > 0: v.add_child(ag)
	return pc

## What a collection would need without any upgrade (to show the saving as grey cubes).
func _feed_base(aid: String) -> Dictionary:
	var n: Dictionary = G.nodes[aid]
	var cnt := int(G.animals.animal(aid)["count"])
	var out := {}
	for k in n.get("feed", {}): out[k] = float(n["feed"][k]) * cnt
	if float(n.get("feedWater", 0)) > 0.0: out["water"] = float(n["feedWater"]) * cnt
	out["energy"] = float(n.get("collectEnergy", 1)) * cnt
	return out
