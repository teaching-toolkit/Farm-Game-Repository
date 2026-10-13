extends RefCounted
class_name FarmUiMarket
## The market stall, the book cart and the library (reading cards).

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ what a place shows

func part_market() -> void:
	match G.trip.phase():
		"square": _part_square()
		"walk": _part_walk()
		_: _part_signpost()

# ------------------------------------------------------------------ at the signpost: preparing the trip

## The village is a walk away: what is packed, the orders that wait, and the button that starts the trip.
func _part_signpost() -> void:
	M.content.add_child(UI.label(tr("The village is a walk away. Pack what you want to sell or hand over, then go: it takes one Time Quiz question and some energy."), 17, UI.MUTED, true))
	_bag_summary()
	var ords := _orders()
	if not ords.is_empty():
		M.widgets.section(tr("📦 Orders to deliver"), tr("Hand them over in the village. What they need must be in your bag."))
		for id in ords: M.content.add_child(_order_card(id, false))
	var ck: Dictionary = G.trip.can_go()
	var go := UI.button(tr("🚶 Go to the village  (−%d ⚡)") % G.trip.energy_cost(), _go, ck["ok"], UI.GREEN, 22)
	go.custom_minimum_size = Vector2(0, 62)
	M.content.add_child(go)
	if not ck["ok"]: M.content.add_child(UI.label(str(ck["why"]), 15, UI.RED, true))
	M.content.add_child(UI.label(tr("You can go with an empty bag too, just to buy things."), 14, UI.MUTED, true))

func _bag_summary() -> void:
	var head := UI.hbox(10)
	head.add_child(UI.label("🎒", 30))
	var bv := UI.vbox(2)
	bv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bv.add_child(UI.label(tr("%s of %s room used") % [str(snappedf(G.trip.load_now(), 0.1)).trim_suffix(".0"), str(int(G.trip.capacity()))], 17))
	bv.add_child(UI.bar(G.trip.fill(), 240, 12, UI.AMBER if G.trip.fill() < 0.999 else UI.RED))
	head.add_child(bv)
	head.add_child(UI.soft_button(tr("🎒 Open the bag"), M.sheets.open_bag, true, 16))
	M.content.add_child(head)

## The deliveries that can be made now (what they need from earlier goals is done).
func _orders() -> Array:
	var out := []
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		if n["type"] != "delivery" or G.done(id) or G.satisfied(id) or not M.mapview.in_chapter(id): continue
		if not G.progression.missing_reqs(id).is_empty(): continue
		out.append(id)
	return out

## An order as a card: what it asks for (with what the store and the bag hold) and the button: pack it, or hand it over in the village.
func _order_card(id: String, at_square: bool) -> PanelContainer:
	var n: Dictionary = G.nodes[id]
	var pc := UI.card()
	var v := UI.vbox(4)
	pc.add_child(v)
	v.add_child(UI.label("%s %s" % [n.get("emoji", "📦"), n["name"]], 18, UI.INK, true))
	if str(n.get("desc", "")) != "": v.add_child(UI.label(str(n["desc"]), 14, UI.MUTED, true))
	var cost: Dictionary = G.pace.node_cost(id)
	v.add_child(M.widgets.costs(cost))
	if at_square:
		var ok: bool = G.trip.bag_covers(cost) and G.S["energy"] + 0.0001 >= float(cost.get("energy", 0.0))
		var b := UI.button(tr("🤝 Hand over"), M.widgets.do_unlock.bind(id), ok, UI.GREEN, 20)
		b.custom_minimum_size = Vector2(0, 52)
		v.add_child(b)
		if not G.trip.bag_covers(cost): v.add_child(UI.label(tr("It is not all in your bag. Pack it next time."), 14, UI.MUTED, true))
	else:
		var can := G.trip.can_pack_cost(cost)
		var b2 := UI.soft_button(tr("🎒 Pack what it needs"), G.trip.pack_cost.bind(cost), can, 18)
		b2.custom_minimum_size = Vector2(0, 48)
		v.add_child(b2)
	return pc

# ------------------------------------------------------------------ on the way

func _part_walk() -> void:
	M.content.add_child(UI.label(tr("You are on your way to the village. One question, and you are there."), 18, UI.INK, true))
	var b := UI.button(tr("❓ Answer the question"), M.timequiz.show_trip_question, true, UI.GREEN, 22)
	b.custom_minimum_size = Vector2(0, 62)
	M.content.add_child(b)

# ------------------------------------------------------------------ in the village

## The village square: sell from the bag, hand over orders, buy within the room left, go home.
func _part_square() -> void:
	var home := UI.button(tr("🏠 Back home"), _back_home, true, UI.BLUE, 20)
	home.custom_minimum_size = Vector2(0, 52)
	M.content.add_child(home)
	M.content.add_child(UI.label(tr("🎒 Room to carry things home: %s of %s") % [str(snappedf(G.trip.buy_room(), 0.1)).trim_suffix(".0"), str(int(G.trip.capacity()))], 15, UI.MUTED, true))
	# sell
	var bag: Dictionary = G.trip.contents()
	var sellable := bag.keys().filter(func(k): return G.inventory.sellable(k))
	M.widgets.section(tr("🪙 Sell"), tr("Only what is in your bag. The market pays less for a pile of the same thing."))
	if sellable.is_empty():
		M.content.add_child(UI.label(tr("Nothing to sell in your bag."), 16, UI.MUTED, true))
	else:
		var sg := M.widgets.grid()
		M.content.add_child(sg)
		for k in sellable:
			var q: int = int(G.trip.packed(k))
			var em := G.iemoji(k)
			var v := M.widgets.tile(Art.first("items", [k]), em, "%s\n%d" % [G.iname(k), q])
			var row := HFlowContainer.new()
			row.add_child(UI.soft_button("1 %s = %s" % [em, G.money(G.trade.sell_total(k, 1))], G.trade.sell.bind(k, 1.0), true, 17))
			if q > 1: row.add_child(UI.soft_button("%d %s = %s" % [q, em, G.money(G.trade.sell_total(k, q))], G.trade.sell.bind(k, 999.0), true, 17))
			v.add_child(row)
			if G.trade.demand_factor(k) < 0.999: v.add_child(UI.label(tr("↓ lots sold lately"), 13, Color("b5562b"), true))
			sg.add_child(v.get_meta("panel"))
	# orders
	var ords := _orders()
	if not ords.is_empty():
		M.widgets.section(tr("📦 Orders to deliver"))
		for id in ords: M.content.add_child(_order_card(id, true))
	# buy
	_part_shops()
	var home2 := UI.button(tr("🏠 Back home"), _back_home, true, UI.BLUE, 20)
	home2.custom_minimum_size = Vector2(0, 52)
	M.content.add_child(home2)

func _back_home() -> void:
	G.trip.leave()
	M.sheets.close_sheet()


## Confirms the packed bag: the energy is taken and the one Time Quiz question on the way opens.
func _go() -> void:
	if G.trip.go(): M.timequiz.show_trip_question()

## The seed merchant and the other traders on the square: buying within the room left for the way home.
func _part_shops() -> void:
	M.widgets.section(tr("🌱 Seed merchant"), tr("Only seeds you have can be planted — buy them here."))
	var sg := M.widgets.grid()
	M.content.add_child(sg)
	for cid in G.nodes:
		var n: Dictionary = G.nodes[cid]
		if n["type"] != "crop" or not G.done(cid) or n.has("seedItem"): continue
		var v := M.widgets.tile(Art.tex("crops", cid), str(n.get("emoji", "")), "%s\n%s · 🌰 %d" % [n["name"], G.money_up(float(n.get("seedCost", 0))), G.down(G.fields.seed_have(cid))])
		var row := UI.hbox(6)
		row.add_child(UI.soft_button("🛒 1", G.trade.buy_seeds.bind(cid, 1), G.S["coins"] + 0.001 >= float(n.get("seedCost", 0)) and G.trip.can_buy(G.inventory.seed_weight()) >= 1, 18))
		row.add_child(UI.soft_button("🛒 5", G.trade.buy_seeds.bind(cid, 5), G.S["coins"] + 0.001 >= 5.0 * float(n.get("seedCost", 0)) and G.trip.can_buy(G.inventory.seed_weight()) >= 5, 18))
		v.add_child(row)
		sg.add_child(v.get_meta("panel"))
	for mid in G.nodes:
		var mn: Dictionary = G.nodes[mid]
		if mn["type"] != "merchant" or not G.done(mid) or mid == "book_cart": continue
		if mn.get("sells", {}).is_empty() and mn.get("barter", {}).is_empty(): continue
		M.widgets.section("%s %s" % [mn.get("emoji", ""), mn["name"]], str(mn.get("desc", "")))
		var mg := M.widgets.grid()
		M.content.add_child(mg)
		for k in mn.get("sells", {}):
			var v2 := M.widgets.tile(Art.first("items", [k]), G.iemoji(k), "%s\n%s" % [G.iname(k), G.money_up(float(mn["sells"][k]))])
			var row2 := UI.hbox(6)
			row2.add_child(UI.soft_button("🛒 1", G.trade.buy_item.bind(mid, k, 1), G.trip.can_buy(G.inventory.weight_of(k)) >= 1, 18))
			row2.add_child(UI.soft_button("🛒 5", G.trade.buy_item.bind(mid, k, 5), G.trip.can_buy(G.inventory.weight_of(k)) >= 5, 18))
			v2.add_child(row2)
			mg.add_child(v2.get_meta("panel"))
		for k in mn.get("barter", {}):
			var row3 := UI.hbox(6)
			var c := {}
			for x in mn["barter"][k]: c[x] = float(mn["barter"][k][x])
			var bq := int(mn.get("barterGives", {}).get(k, 1))
			row3.add_child(UI.rich("%s%s %s  for  %s" % ["%d × " % bq if bq > 1 else "", G.iemoji(k), G.iname(k), M.widgets.cost_bb(c)], 17))
			row3.add_child(UI.soft_button("🤝", G.trade.barter.bind(mid, k), true, 20))
			M.content.add_child(row3)

func part_bookcart() -> void:
	if not G.done("book_cart"):
		var mr: Array = G.progression.missing_reqs("book_cart")
		M.content.add_child(UI.label(tr("The book cart comes by once you have: ") + ", ".join(mr), 17, UI.MUTED, true))
		return
	M.content.add_child(UI.label(tr("Books hold new cards. Your library holds %d books (%d now).") % [int(round(G.g("bookSlots", 1.0))), G.progression.books_owned()], 16, UI.MUTED, true))
	var books := []
	for bid in G.nodes:
		if G.nodes[bid]["type"] == "book" and not G.done(bid) and M.mapview.in_chapter(bid): books.append(bid)
	books.sort_custom(func(a, b): return int(G.nodes[a]["chapter"]) < int(G.nodes[b]["chapter"]))
	for bid in books:
		var bn: Dictionary = G.nodes[bid]
		var ck: Dictionary = G.progression.can_unlock(bid)
		var pc := UI.card()
		var v := UI.vbox(2)
		pc.add_child(v)
		var row := UI.hbox(6)
		row.add_child(UI.label("%s %s — %s" % [bn.get("emoji", ""), bn["name"], bn.get("desc", "")], 16, UI.INK if ck["ok"] else UI.MUTED, true))
		row.add_child(UI.button(tr("Buy"), M.widgets.do_unlock.bind(bid), ck["ok"], UI.GREEN, 16))
		v.add_child(row)
		v.add_child(M.widgets.costs(G.pace.node_cost(bid)))
		if not ck["ok"] and not G.progression.missing_reqs(bid).is_empty(): v.add_child(UI.label(str(ck["why"]), 14, UI.MUTED, true))
		M.content.add_child(pc)

func part_library() -> void:
	M.content.add_child(UI.label(tr("%d / %d books · %d of %d cards learned. Read a card (takes a few Time Quiz questions), then answer its quiz. Due reviews pop up in the Time Quiz.") % [G.progression.books_owned(), int(round(G.g("bookSlots", 1.0))), G.progression.cards_learned(), G.card_ids.size()], 16, UI.MUTED, true))
	if G.S["reading"] != "":
		var rc: String = G.S["reading"]
		var row := UI.hbox(8)
		row.add_child(UI.label("📖 %s" % G.nodes[rc]["name"], 18))
		row.add_child(UI.explain(UI.stock_bar(float(G.S["read_progress"]), ceilf(G.knowledge.read_needed(rc)), UI.BLUE, 160), tr("📖 Pages read: each Time Quiz question turns one.")))
		row.add_child(UI.wait_button(maxi(1, G.up(G.knowledge.read_needed(rc) - float(G.S["read_progress"]))), M.timequiz.show_time_quiz))
		M.content.add_child(row)
	var due: int = G.knowledge.due_cards().size()
	if due > 0: M.content.add_child(UI.label((tr("🔁 %d card due for a review — it will show up in the Time Quiz.") if due == 1 else tr("🔁 %d cards due for a review — they'll show up in the Time Quiz.")) % due, 16, UI.BLUE, true))
	for bid in G.nodes:
		if G.nodes[bid]["type"] != "book" or not G.done(bid): continue
		var bn2: Dictionary = G.nodes[bid]
		M.widgets.section("%s %s" % [bn2.get("emoji", ""), bn2["name"]])
		var cg := M.widgets.grid()
		for cid in G.card_ids:
			if G.nodes[cid]["requires"][0] != bid: continue
			if not M.mapview.in_chapter(cid) and not G.done(cid): continue
			cg.add_child(_card_tile(cid))
		M.content.add_child(cg)

## Starting to read a card shows its page at once (and the reading takes a few Time Quiz questions).
func _start_reading(cid: String) -> void:
	if G.knowledge.start_reading(cid):
		M.feedback.sfx("page")
		M.feedback.play_act("read", M.map.stand_point(M.mapview.map_sid("library")))
		M.cards.card_page(cid)

## A knowledge card as a tile: what it is about, where it stands (learned with stars, quiz waiting, being read, can be read,
## locked) and the button for the next thing to do with it at the bottom.
func _card_tile(cid: String) -> PanelContainer:
	var n: Dictionary = G.nodes[cid]
	var st: String = G.knowledge.card_status(cid)
	var bg: Color = {"learned": Color("eef6e4"), "quiz": Color("fdf3dc"), "reading": Color("e8f0f8"), "readable": UI.PAPER}.get(st, Color("f1ede4"))
	var t := M.widgets.tile(null, str(n.get("emoji", "📄")), str(n["name"]), bg)
	match st:
		"learned":
			var box_n := int(G.S["cards"].get(cid, {}).get("box", 1))
			t.add_child(UI.label("✅ " + "⭐".repeat(box_n), 16, UI.GREEN_DARK))
			M.widgets.tile_button(t, UI.soft_button(tr("📖 Read again"), M.cards.card_page.bind(cid), true, 16))
		"quiz":
			t.add_child(UI.label(tr("Read! Now its quiz."), 15, UI.INK, true))
			M.widgets.tile_button(t, UI.button(tr("❓ Quiz"), M.cards.show_card.bind(cid), true, UI.GREEN, 20))
		"reading":
			t.add_child(UI.explain(UI.stock_bar(float(G.S["read_progress"]), ceilf(G.knowledge.read_needed(cid)), UI.BLUE, 120), tr("📖 Pages read: each Time Quiz question turns one.")))
			M.widgets.tile_button(t, UI.wait_button(maxi(1, G.up(G.knowledge.read_needed(cid) - float(G.S["read_progress"]))), M.timequiz.show_time_quiz))
		"readable":
			var rq: int = G.up(G.knowledge.read_needed(cid) * G.m("read"))
			t.add_child(UI.label((tr("Reading takes %d question") if rq == 1 else tr("Reading takes %d questions")) % rq, 15, UI.MUTED, true))
			M.widgets.tile_button(t, UI.button(tr("📖 Read"), _start_reading.bind(cid), G.S["reading"] == "", UI.BLUE, 20))
		"prereq":
			var miss := []
			for r in n["requires"]:
				if not G.satisfied(r): miss.append(G.nodes[r]["name"])
			t.add_child(UI.label(tr("🔒 First: %s") % ", ".join(miss), 14, UI.MUTED, true))
		"discover":
			var miss2 := []
			for k in n.get("discover", []):
				if not G.S["seen"].has(k): miss2.append(G.iemoji(k) + " " + G.iname(k))
			t.add_child(UI.label(tr("🔍 Find %s first") % ", ".join(miss2), 14, UI.MUTED, true))
		_:
			t.add_child(UI.label("🔒", 15, UI.MUTED))
	return t.get_meta("panel")
