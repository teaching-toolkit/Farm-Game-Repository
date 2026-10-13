extends RefCounted
class_name FarmUiWaterRoad
## The well (carrying water) and the road.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ what a place shows

## Water: how much there is (cubes), and the bucket trips to the wild pond.
func part_water(sid: String) -> void:
	var wc := UI.card(Color("e8f2f8"))
	var wv := UI.vbox(6)
	wc.add_child(wv)
	var wr := UI.hbox(8)
	wr.add_child(UI.label("💧", 24))
	wr.add_child(UI.explain(UI.stock_bar(float(G.S["water"]), G.needs.water_cap(), UI.item_color("water"), 320), tr("💧 Water you carry: planting and cooking use it.")))
	wv.add_child(wr)
	wv.add_child(UI.label(tr("🪣 Every trip brings %s 💧 · holds %s") % [M.widgets.num(G.fields.fetch_amount()), M.widgets.num(G.needs.water_cap())], 16, UI.INK, true))
	if G.S.get("rain", false): wv.add_child(UI.label(tr("🌧️ It rained: planting costs no water until the next question."), 15, UI.GREEN_DARK, true))
	var fr := UI.hbox(8)
	var room: float = G.needs.water_cap() - float(G.S["water"])
	var fb := UI.button("🪣  %s" % "💧".repeat(clampi(int(round(minf(room, G.fields.fetch_amount()))), 1, 8)), _fetch_water, room >= 0.5, UI.BLUE, 22)
	fb.custom_minimum_size = Vector2(0, 54)
	fb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fr.add_child(fb)
	fr.add_child(M.widgets.costs({"energy": G.fields.fetch_cost()}, {"energy": float(G.meta.get("water", {}).get("fetchEnergy", 1.0))}))
	wv.add_child(fr)
	M.content.add_child(wc)
	if sid == "pond" and not G.done("pond"):
		M.content.add_child(UI.label(tr("A wild pond, full of reeds. Someday it could be dug out again."), 15, UI.MUTED, true))

func _fetch_water() -> void:
	G.fields.fetch_water()

## The road: how good it is, and who can come along it to the market.
func part_road() -> void:
	if G.gate.here(): _part_gate()
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
	if who.size() > 0: rv.add_child(UI.label(tr("Coming to your market:  ") + " ".join(who), 17, UI.INK, true))
	var blocked := 0
	for mid in G.nodes:
		var mn2: Dictionary = G.nodes[mid]
		if mn2["type"] != "merchant" or G.done(mid) or not M.mapview.in_chapter(mid): continue
		var road_only := false
		var other := false
		for q in mn2.get("requires", []):
			if G.satisfied(q): continue
			if str(q).begins_with("road_"): road_only = true
			else: other = true
		if road_only and not other: blocked += 1
	if blocked > 0: rv.add_child(UI.label(tr("🚧 %s can't get through yet — a better road lets them come.") % "🧑‍🌾".repeat(mini(blocked, 5)), 16, UI.RED, true))
	M.content.add_child(rc)

## The travelling merchant at the gate: what he buys from the store (no packing, no trip), a little cheaper than the village, until his cart is full.
func _part_gate() -> void:
	M.widgets.section(tr("🛒 The travelling merchant"), tr("He buys a lot at once, at a little less than the village pays. He stays for a few questions."))
	var head := UI.hbox(10)
	head.add_child(UI.label("🛒", 28))
	var bv := UI.vbox(2)
	bv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bv.add_child(UI.label(tr("His cart: %s of %s room used") % [str(snappedf(G.gate.cart_size() - G.gate.cart_room(), 0.1)).trim_suffix(".0"), str(int(G.gate.cart_size()))], 16))
	bv.add_child(UI.bar(G.gate.fill(), 240, 12, UI.AMBER if G.gate.fill() < 0.999 else UI.RED))
	head.add_child(bv)
	M.content.add_child(head)
	var ks: Array = G.S["inv"].keys().filter(func(k): return G.gate.wants(k) and G.inventory.count(k) >= 1.0)
	if ks.is_empty():
		M.content.add_child(UI.label(tr("He has nothing to buy from you right now."), 16, UI.MUTED, true))
		return
	var grid := M.widgets.grid()
	M.content.add_child(grid)
	for k in ks:
		var q: int = G.gate.can_take(k)
		var em := G.iemoji(k)
		var v := M.widgets.tile(Art.first("items", [k]), em, "%s\n%d" % [G.iname(k), G.down(G.inventory.count(k))])
		var row := HFlowContainer.new()
		row.add_child(UI.soft_button("1 %s = %s" % [em, G.money(G.gate.price(k))], G.trade.sell_gate.bind(k, 1.0), q >= 1, 17))
		if q > 1: row.add_child(UI.soft_button("%d %s = %s" % [q, em, G.money(G.gate.price(k, q))], G.trade.sell_gate.bind(k, 999.0), true, 17))
		v.add_child(row)
		grid.add_child(v.get_meta("panel"))
