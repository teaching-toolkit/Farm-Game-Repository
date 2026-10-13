extends RefCounted
## Water: the pond and the well.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")

var M
var G

## Water: how much there is (cubes), and the bucket trips to the wild pond.
func _part_water(sid: String) -> void:
	var wc := UI.card(Color("e8f2f8"))
	var wv := UI.vbox(6)
	wc.add_child(wv)
	var wr := UI.hbox(8)
	wr.add_child(UI.label("💧", 24))
	wr.add_child(UI.explain(UI.stock_bar(float(G.S["water"]), G.water_cap(), UI.item_color("water"), 320), M.tr("💧 Water you carry: planting and cooking use it.")))
	wv.add_child(wr)
	wv.add_child(UI.label(M.tr("🪣 Every trip brings %s 💧 · holds %s") % [M.ui_widgets._num(G.fetch_amount()), M.ui_widgets._num(G.water_cap())], 16, UI.INK, true))
	if G.S.get("rain", false): wv.add_child(UI.label(M.tr("🌧️ It rained: planting costs no water until the next question."), 15, UI.GREEN_DARK, true))
	var fr := UI.hbox(8)
	var room: float = G.water_cap() - float(G.S["water"])
	var fb := UI.button("🪣  %s" % "💧".repeat(clampi(int(round(minf(room, G.fetch_amount()))), 1, 8)), _fetch_water, room >= 0.5, UI.BLUE, 22)
	fb.custom_minimum_size = Vector2(0, 54)
	fb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fr.add_child(fb)
	fr.add_child(M.ui_widgets._costs({"energy": G.fetch_cost()}, {"energy": float(G.meta.get("water", {}).get("fetchEnergy", 1.0))}))
	wv.add_child(fr)
	M.content.add_child(wc)
	if sid == "pond" and not G.done("pond"):
		M.content.add_child(UI.label(M.tr("A wild pond, full of reeds. Someday it could be dug out again."), 15, UI.MUTED, true))

func _fetch_water() -> void:
	G.fetch_water()
