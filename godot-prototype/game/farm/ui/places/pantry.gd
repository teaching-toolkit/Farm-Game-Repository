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

var filter := "all"            # the store's filter row: "all" or the id of a filter in rules/49-trip.json

func part_pantry() -> void:
	var ready_n := M.patches.ready_count("field") + M.patches.ready_count("orchard") + M.patches.ready_count("gh")
	var hb := UI.button(tr("🧺 Harvest all  (%d ready)") % ready_n if ready_n > 0 else tr("🧺 Harvest all — nothing is ready yet"), _harvest_everything, ready_n > 0, UI.GREEN, 20)
	hb.custom_minimum_size = Vector2(0, 58)
	M.content.add_child(hb)
	M.widgets.section(tr("🧺 What you have"), tr("Tap a thing to see what you can do with it. 🍂 = goes stale at the next change of season — sell it, eat it or cook it into something that keeps. 🎒 = packed for the trip."))
	M.content.add_child(_filter_row())
	var grid := GridContainer.new()
	grid.columns = 5 if M.size.x >= 900 else 4
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	M.content.add_child(grid)
	for k in _store_keys():
		grid.add_child(_store_tile(k))
	var seeds := []
	for cid in G.S["seeds"]:
		if float(G.S["seeds"][cid]) >= 1.0: seeds.append(cid)
	if seeds.size() > 0 and filter in ["all", "crops"]:
		M.widgets.section(tr("🌱 Seeds"))
		var sg := M.widgets.grid()
		M.content.add_child(sg)
		for cid in seeds:
			var sv := M.widgets.tile(Art.tex("crops", cid), str(G.nodes[cid].get("emoji", "")), str(G.nodes[cid]["name"]))
			sv.add_child(UI.explain(UI.stock_bar(float(G.S["seeds"][cid]), maxf(10.0, ceilf(float(G.S["seeds"][cid]))), Color("a3c26a"), 190), tr("🌰 Seeds you have to plant.")))
			sg.add_child(sv.get_meta("panel"))

## The things in the store that the filter shows, in the order of the categories.
func _store_keys() -> Array:
	var cats := _filter_cats()
	var keys: Array = G.S["inv"].keys()
	keys = keys.filter(func(k): return (G.inventory.count(k) >= 0.999 or G.items[k].get("category", "") == "keeper") and (cats.is_empty() or cats.has(str(G.items[k].get("category", "")))))
	keys.sort_custom(func(a, b):
		return CAT_ORDER.find(G.items[a].get("category", "")) * 1000 + G.items.keys().find(a) < CAT_ORDER.find(G.items[b].get("category", "")) * 1000 + G.items.keys().find(b))
	return keys

func _filter_cats() -> Array:
	if filter == "all": return []
	for f in G.trip.data().get("storeFilters", []):
		if f["id"] == filter: return f["cats"]
	return []

func _filter_name(id: String) -> String:
	return {"all": tr("All"), "crops": tr("Crops"), "food": tr("Food"), "crafts": tr("Crafts"), "materials": tr("Materials")}.get(id, id)

## A row of filters on top of the store: all, then the kinds of things (more can be added in the data).
func _filter_row() -> Control:
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 6)
	row.add_theme_constant_override("v_separation", 6)
	var entries := [["all", "🧺"]]
	for f in G.trip.data().get("storeFilters", []): entries.append([f["id"], f.get("emoji", "")])
	for e in entries:
		var b := UI.soft_button("%s %s" % [e[1], _filter_name(e[0])], _set_filter.bind(e[0]), true, 16)
		b.custom_minimum_size = Vector2(0, 44)
		if filter == e[0]:
			b.add_theme_stylebox_override("normal", UI.box(Color("dcebc8"), 12, UI.GREEN, 2, 8))
		row.add_child(b)
	return row

func _set_filter(id: String) -> void:
	filter = id
	M.sheets.rebuild_sheet()

## One small tile of the store: picture, a short name, the count, badges (stale, packed, the grades there are). A tap opens the panel.
func _store_tile(k: String) -> Control:
	var it: Dictionary = G.items[k]
	var q: float = G.inventory.count(k)
	var keeper: bool = it.get("category", "") == "keeper"
	var pc := PanelContainer.new()
	pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pc.add_theme_stylebox_override("panel", UI.box(UI.PAPER, 10, UI.LINE, 2, 5))
	pc.mouse_filter = Control.MOUSE_FILTER_STOP
	var v := UI.vbox(1)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pc.add_child(v)
	var pic := Art.first("items", [k])
	var top: Control
	if pic:
		var tr := TextureRect.new()
		tr.texture = pic
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.custom_minimum_size = Vector2(46, 46)
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var cc := CenterContainer.new()
		cc.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cc.add_child(tr)
		top = cc
	else:
		var el := UI.label(str(it.get("emoji", "📦")), 34)
		el.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		el.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top = el
	v.add_child(top)
	var nl := UI.label(str(it["name"]), 12, UI.MUTED, true)
	nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(nl)
	var badges := "%d" % G.down(q) if not keeper else "✓"
	if G.inventory.stale_soon(k) >= 1.0: badges += " 🍂"
	var pk := int(G.trip.packed(k))
	if pk > 0: badges += " 🎒%d" % pk
	var cl := UI.label(badges, 15, UI.INK)
	cl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(cl)
	if G.quality.graded(k):
		var dots := ""
		var gs: Dictionary = G.inventory.grades(k)
		for g in range(G.quality.max_grade() + 1):
			if float(gs.get(g, 0.0)) >= 1.0: dots += "[color=%s]●[/color]" % ["#a0784a", "#6aa04a", "#e0a800"][mini(g, 2)]
		if dots != "":
			var dl := UI.rich("[center]%s[/center]" % dots, 12)
			dl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			v.add_child(dl)
	pc.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: item_panel(k))
	return pc

## What can be done with one thing from the store: eat, stack the fire, pack it for the trip, sell it (until the trip takes selling over).
func item_panel(k: String) -> void:
	if not G.items.has(k): return
	var it: Dictionary = G.items[k]
	var q: float = G.inventory.count(k)
	var box := M.modals.open_modal("%s %s" % [it.get("emoji", ""), it["name"]])
	box.add_child(UI.header(Art.first("items", [k]), str(it.get("emoji", "📦")), 96))
	box.add_child(UI.explain(UI.stock_bar(q, maxf(q, G.needs.storage_cap()), UI.item_color(k, G.items), 260),
		tr("%d %s — your store holds %d of each.") % [G.down(q), str(it["name"]), G.down(G.needs.storage_cap())]))
	if G.quality.graded(k):      # how many of each grade: ⭐⭐⭐ 2  ⭐⭐ 5
		var gs: Dictionary = G.inventory.grades(k)
		var gk := gs.keys()
		gk.sort()
		gk.reverse()
		var gparts := []
		for g in gk: gparts.append("%s %d" % [G.quality.stars(int(g)), G.down(float(gs[g]))])
		box.add_child(UI.label("   ".join(gparts), 16, UI.MUTED, true))
	if G.inventory.stale_soon(k) >= 1.0: box.add_child(UI.label(tr("🍂 %d of it goes stale at the next change of season.") % G.down(G.inventory.stale_soon(k)), 15, Color("b5562b"), true))
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 8)
	row.add_theme_constant_override("v_separation", 8)
	if it.has("buff"): row.add_child(_act_button("😋 " + tr("Eat"), G.trade.eat.bind(k), k))
	if G.crafting.fuel_value(k) > 0.0: row.add_child(_act_button("🔥 " + tr("Fire"), M.stations.stack.bind(k), k))
	var pk := int(G.trip.packed(k))
	var fit: int = G.trip.can_pack(k)
	if G.inventory.sellable(k) or G.trip.can_pack(k) > 0 or pk > 0:
		row.add_child(_act_button("🎒 +1", G.trip.pack.bind(k, 1), k, fit >= 1))
		row.add_child(_act_button(tr("🎒 + all that fits") if fit > 1 else "🎒 +all", G.trip.pack.bind(k, 9999), k, fit >= 1))
		if pk > 0: row.add_child(_act_button("↩ −1", G.trip.unpack.bind(k, 1), k))
	if G.inventory.sellable(k):
		var em := str(it.get("emoji", "📦"))
		var have: int = G.down(q)
		row.add_child(_act_button("1 %s = %s" % [em, G.money(G.trade.sell_total(k, 1))], G.trade.sell.bind(k, 1.0), k))
		if have > 1: row.add_child(_act_button("%d %s = %s" % [have, em, G.money(G.trade.sell_total(k, have))], G.trade.sell.bind(k, 999.0), k))
		if G.trade.demand_factor(k) < 0.999: box.add_child(UI.label(tr("↓ lots sold lately — pays less for a while"), 13, Color("b5562b"), true))
	box.add_child(row)
	if pk > 0 or fit > 0: box.add_child(UI.label(tr("🎒 packed: %d · room in the bag: %d") % [pk, int(G.trip.room() / maxf(0.05, G.inventory.weight_of(k)))], 14, UI.MUTED, true))
	var done := UI.button(tr("Done"), M.modals.close_modal, true, UI.GREEN, 20)
	done.custom_minimum_size = Vector2(0, 52)
	box.add_child(done)

## An action button inside the panel: does it, then shows the panel again with the new numbers.
func _act_button(text: String, act: Callable, k: String, enabled := true) -> Button:
	var b := UI.soft_button(text, func():
		act.call()
		if G.items.has(k) and (G.inventory.count(k) >= 0.999 or G.items[k].get("category", "") == "keeper"): item_panel(k)
		else: M.modals.close_modal(), enabled, 18)
	b.custom_minimum_size = Vector2(0, 50)
	return b

# ------------------------------------------------------------------ the bag

## The bag's window: how full it is, what is in it (tap to take one out), and what the farmer can carry.
func part_bag() -> void:
	var cap := G.trip.capacity()
	var ld := G.trip.load_now()
	var dev := G.trip.device()
	var head := UI.hbox(10)
	head.add_child(UI.label("🎒", 34))
	var bv := UI.vbox(2)
	bv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bv.add_child(UI.label(tr("%s of %s room used") % [str(snappedf(ld, 0.1)).trim_suffix(".0"), str(int(cap))], 18))
	bv.add_child(UI.bar(G.trip.fill(), 260, 14, UI.AMBER if G.trip.fill() < 0.999 else UI.RED))
	head.add_child(bv)
	M.content.add_child(head)
	M.content.add_child(UI.label((tr("Carried with: %s") % G.nodes[dev]["name"]) if dev != "" else tr("You carry it in your arms. A bag, a basket or a cart would hold more."), 15, UI.MUTED, true))
	if G.trip.is_empty():
		M.content.add_child(UI.label(tr("Nothing packed. Tap a thing in the store and pack it with 🎒."), 17, UI.MUTED, true))
	else:
		var grid := M.widgets.grid()
		M.content.add_child(grid)
		var ks: Array = G.trip.contents().keys()
		ks.sort_custom(func(a, b): return G.inventory.load_of(a, G.trip.packed(a)) > G.inventory.load_of(b, G.trip.packed(b)))    # what takes the most room first
		for k in ks:
			var v := M.widgets.tile(Art.first("items", [k]), G.iemoji(k), "%s\n%d  ·  %s" % [G.iname(k), int(G.trip.packed(k)), tr("room %s") % str(snappedf(G.inventory.load_of(k, G.trip.packed(k)), 0.1)).trim_suffix(".0")])
			M.widgets.tile_button(v, UI.soft_button("↩ −1", G.trip.unpack.bind(k, 1), true, 16))
			grid.add_child(v.get_meta("panel"))
		M.content.add_child(UI.soft_button(tr("↩ Unpack everything"), G.trip.unpack_all, true, 17))

func _harvest_everything() -> void:
	var n := M.patches.ready_count("field") + M.patches.ready_count("orchard") + M.patches.ready_count("gh")
	for a in ["field", "orchard", "gh"]: M.patches.harvest_all(a)
	if n > 0 and G.rewards.perk_on("perk_confetti"):
		var fx = UI.Celebration.new()
		M.add_child(fx)
		fx.size = M.size
		fx.start("confetti", M.size / 2.0)
		M.feedback.sfx("confetti")
