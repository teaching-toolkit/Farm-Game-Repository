extends RefCounted
class_name FarmUiPantry
## The pantry: what the farm holds, grouped, with eating and harvesting everything.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

const CAT_ORDER := ["crop", "animal", "ingredient", "dish", "material", "textile", "fertilizer", "byproduct", "feed", "fuel", "container", "craft", "find", "seed", "keeper", "pet-item"]

# ------------------------------------------------------------------ what a place shows

func part_pantry() -> void:
	var ready_n := M.patches.ready_count("field") + M.patches.ready_count("orchard") + M.patches.ready_count("gh")
	var hb := UI.button(tr("🧺 Harvest all  (%d ready)") % ready_n if ready_n > 0 else tr("🧺 Harvest all — nothing is ready yet"), _harvest_everything, ready_n > 0, UI.GREEN, 20)
	hb.custom_minimum_size = Vector2(0, 58)
	M.content.add_child(hb)
	M.widgets.section(tr("🧺 What you have"), tr("🍂 = goes stale at the next change of season — sell it, eat it or cook it into something that keeps. 🪙 = what one sells for; ↓ = the market has had lots of it lately and pays less for a while."))
	var grid := M.widgets.grid()
	M.content.add_child(grid)
	var cap: float = G.needs.storage_cap()
	var keys: Array = G.S["inv"].keys()
	keys.sort_custom(func(a, b):
		return CAT_ORDER.find(G.items[a].get("category", "")) * 1000 + G.items.keys().find(a) < CAT_ORDER.find(G.items[b].get("category", "")) * 1000 + G.items.keys().find(b))
	for k in keys:
		var q: float = G.inventory.count(k)
		if q < 0.999 and G.items[k].get("category", "") != "keeper": continue
		var it: Dictionary = G.items[k]
		var v := M.widgets.tile(Art.first("items", [k]), str(it.get("emoji", "")), str(it["name"]) + ("  🍂" if G.inventory.stale_soon(k) >= 1.0 else ""))
		var keeper: bool = it.get("category", "") == "keeper"
		v.add_child(UI.explain(UI.stock_bar(q, q if keeper else cap, UI.item_color(k, G.items), 190),
			("%s %d %s" % [str(it.get("emoji", "")), G.down(q), str(it["name"])]) + ("" if keeper else tr(" — your store holds %d of each.") % G.down(cap))))
		if G.quality.graded(k):      # how many of each grade: ⭐⭐⭐ 2  ⭐⭐ 5
			var gs: Dictionary = G.inventory.grades(k)
			var gk := gs.keys()
			gk.sort()
			gk.reverse()
			var gparts := []
			for g in gk: gparts.append("%s %d" % [G.quality.stars(int(g)), G.down(float(gs[g]))])
			v.add_child(UI.label("   ".join(gparts), 14, UI.MUTED, true))
		var row := HFlowContainer.new()
		if it.has("buff"): row.add_child(UI.soft_button("😋", G.trade.eat.bind(k), true, 20))
		if G.crafting.fuel_value(k) > 0.0: row.add_child(UI.soft_button("🔥", M.stations.stack.bind(k), true, 20))
		if G.inventory.sellable(k):
			# "1 🥣 = 4 🪙" and "5 🥕 = 10 🪙": what you give and what you get
			var em := str(it.get("emoji", "📦"))
			var have: int = G.down(q)
			row.add_child(UI.soft_button("1 %s = %d 🪙" % [em, G.down(G.trade.sell_total(k, 1))], G.trade.sell.bind(k, 1.0), true, 17))
			if have > 1: row.add_child(UI.soft_button("%d %s = %d 🪙" % [have, em, G.down(G.trade.sell_total(k, have))], G.trade.sell.bind(k, 999.0), true, 17))
			if G.trade.demand_factor(k) < 0.999: v.add_child(UI.label(tr("↓ lots sold lately — pays less for a while"), 13, Color("b5562b"), true))
		if row.get_child_count() > 0: v.add_child(row)
		grid.add_child(v.get_meta("panel"))
	var seeds := []
	for cid in G.S["seeds"]:
		if float(G.S["seeds"][cid]) >= 1.0: seeds.append(cid)
	if seeds.size() > 0:
		M.widgets.section(tr("🌱 Seeds"))
		var sg := M.widgets.grid()
		M.content.add_child(sg)
		for cid in seeds:
			var sv := M.widgets.tile(Art.tex("crops", cid), str(G.nodes[cid].get("emoji", "")), str(G.nodes[cid]["name"]))
			sv.add_child(UI.explain(UI.stock_bar(float(G.S["seeds"][cid]), maxf(10.0, ceilf(float(G.S["seeds"][cid]))), Color("a3c26a"), 190), tr("🌰 Seeds you have to plant.")))
			sg.add_child(sv.get_meta("panel"))

func _harvest_everything() -> void:
	var n := M.patches.ready_count("field") + M.patches.ready_count("orchard") + M.patches.ready_count("gh")
	for a in ["field", "orchard", "gh"]: M.patches.harvest_all(a)
	if n > 0 and G.rewards.perk_on("perk_confetti"):
		var fx = UI.Celebration.new()
		M.add_child(fx)
		fx.size = M.size
		fx.start("confetti", M.size / 2.0)
		M.feedback.sfx("confetti")
