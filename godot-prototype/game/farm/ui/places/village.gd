extends RefCounted
## Market, book cart and library.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")

var M
var G

func _part_market() -> void:
	M.ui_widgets._section(M.tr("🌱 Seed merchant"), M.tr("Only seeds you have can be planted — buy them here."))
	var sg = M.ui_place._grid()
	M.content.add_child(sg)
	for cid in G.nodes:
		var n: Dictionary = G.nodes[cid]
		if n["type"] != "crop" or not G.done(cid) or n.has("seedItem"): continue
		var v = M.ui_place._tile(Art.tex("crops", cid), str(n.get("emoji", "")), "%s\n🪙%s · 🌰 %d" % [n["name"], str(n.get("seedCost", 0)), G.down(G.seed_have(cid))])
		var row := UI.hbox(6)
		row.add_child(UI.soft_button("🛒 1", G.buy_seeds.bind(cid, 1), G.S["coins"] + 0.001 >= float(n.get("seedCost", 0)), 18))
		row.add_child(UI.soft_button("🛒 5", G.buy_seeds.bind(cid, 5), G.S["coins"] + 0.001 >= 5.0 * float(n.get("seedCost", 0)), 18))
		v.add_child(row)
		sg.add_child(v.get_meta("panel"))
	for mid in G.nodes:
		var mn: Dictionary = G.nodes[mid]
		if mn["type"] != "merchant" or not G.done(mid) or mid == "book_cart": continue
		if mn.get("sells", {}).is_empty() and mn.get("barter", {}).is_empty(): continue
		M.ui_widgets._section("%s %s" % [mn.get("emoji", ""), mn["name"]], str(mn.get("desc", "")))
		var mg = M.ui_place._grid()
		M.content.add_child(mg)
		for k in mn.get("sells", {}):
			var v2 = M.ui_place._tile(Art.first("items", [k]), G.iemoji(k), "%s\n🪙%s" % [G.iname(k), str(mn["sells"][k])])
			var row2 := UI.hbox(6)
			row2.add_child(UI.soft_button("🛒 1", G.buy_item.bind(mid, k, 1), true, 18))
			row2.add_child(UI.soft_button("🛒 5", G.buy_item.bind(mid, k, 5), true, 18))
			v2.add_child(row2)
			mg.add_child(v2.get_meta("panel"))
		for k in mn.get("barter", {}):
			var row3 := UI.hbox(6)
			var c := {}
			for x in mn["barter"][k]: c[x] = float(mn["barter"][k][x])
			var bq := int(mn.get("barterGives", {}).get(k, 1))
			row3.add_child(UI.rich("%s%s %s  for  %s" % ["%d × " % bq if bq > 1 else "", G.iemoji(k), G.iname(k), M.ui_widgets._cost_bb(c)], 17))
			row3.add_child(UI.soft_button("🤝", G.barter.bind(mid, k), true, 20))
			M.content.add_child(row3)

func _part_bookcart() -> void:
	if not G.done("book_cart"):
		var mr: Array = G.missing_reqs("book_cart")
		M.content.add_child(UI.label(M.tr("The book cart comes by once you have: ") + ", ".join(mr), 17, UI.MUTED, true))
		return
	M.content.add_child(UI.label(M.tr("Books hold new cards. Your library holds %d books (%d now).") % [int(round(G.g("bookSlots", 1.0))), G.books_owned()], 16, UI.MUTED, true))
	var books := []
	for bid in G.nodes:
		if G.nodes[bid]["type"] == "book" and not G.done(bid) and M.ui_map._in_chapter(bid): books.append(bid)
	books.sort_custom(func(a, b): return int(G.nodes[a]["chapter"]) < int(G.nodes[b]["chapter"]))
	for bid in books:
		var bn: Dictionary = G.nodes[bid]
		var ck: Dictionary = G.can_unlock(bid)
		var pc := UI.card()
		var v := UI.vbox(2)
		pc.add_child(v)
		var row := UI.hbox(6)
		row.add_child(UI.label("%s %s — %s" % [bn.get("emoji", ""), bn["name"], bn.get("desc", "")], 16, UI.INK if ck["ok"] else UI.MUTED, true))
		row.add_child(UI.button(M.tr("Buy"), M.ui_widgets._do_unlock.bind(bid), ck["ok"], UI.GREEN, 16))
		v.add_child(row)
		v.add_child(M.ui_widgets._costs(G.node_cost(bid)))
		if not ck["ok"] and not G.missing_reqs(bid).is_empty(): v.add_child(UI.label(str(ck["why"]), 14, UI.MUTED, true))
		M.content.add_child(pc)

func _part_library() -> void:
	M.content.add_child(UI.label(M.tr("%d / %d books · %d of %d cards learned. Read a card (takes a few Time Quiz questions), then answer its quiz. Due reviews pop up in the Time Quiz.") % [G.books_owned(), int(round(G.g("bookSlots", 1.0))), G.cards_learned(), G.card_ids.size()], 16, UI.MUTED, true))
	if G.S["reading"] != "":
		var rc: String = G.S["reading"]
		var row := UI.hbox(8)
		row.add_child(UI.label("📖 %s" % G.nodes[rc]["name"], 18))
		row.add_child(UI.explain(UI.stock_bar(float(G.S["read_progress"]), ceilf(G.read_needed(rc)), UI.BLUE, 160), M.tr("📖 Pages read: each Time Quiz question turns one.")))
		row.add_child(UI.wait_button(maxi(1, G.up(G.read_needed(rc) - float(G.S["read_progress"]))), M.ui_quiz._show_time_quiz))
		M.content.add_child(row)
	var due: int = G.due_cards().size()
	if due > 0: M.content.add_child(UI.label((M.tr("🔁 %d card due for a review — it will show up in the Time Quiz.") if due == 1 else M.tr("🔁 %d cards due for a review — they'll show up in the Time Quiz.")) % due, 16, UI.BLUE, true))
	for bid in G.nodes:
		if G.nodes[bid]["type"] != "book" or not G.done(bid): continue
		var bn2: Dictionary = G.nodes[bid]
		M.ui_widgets._section("%s %s" % [bn2.get("emoji", ""), bn2["name"]])
		var cg = M.ui_place._grid()
		for cid in G.card_ids:
			if G.nodes[cid]["requires"][0] != bid: continue
			if not M.ui_map._in_chapter(cid) and not G.done(cid): continue
			cg.add_child(_card_tile(cid))
		M.content.add_child(cg)

## Starting to read a card shows its page at once (and the reading takes a few Time Quiz questions).
func _start_reading(cid: String) -> void:
	if G.start_reading(cid):
		M.ui_sounds._sfx("page")
		M.ui_acts._act("read", M.map.stand_point(M.ui_map._map_sid("library")))
		M.ui_card._card_page(cid)

## A knowledge card as a tile: what it is about, where it stands (learned with stars, quiz waiting, being read, can be read,
## locked) and the button for the next thing to do with it at the bottom.
func _card_tile(cid: String) -> PanelContainer:
	var n: Dictionary = G.nodes[cid]
	var st: String = G.card_status(cid)
	var bg: Color = {"learned": Color("eef6e4"), "quiz": Color("fdf3dc"), "reading": Color("e8f0f8"), "readable": UI.PAPER}.get(st, Color("f1ede4"))
	var t = M.ui_place._tile(null, str(n.get("emoji", "📄")), str(n["name"]), bg)
	match st:
		"learned":
			var box_n := int(G.S["cards"].get(cid, {}).get("box", 1))
			t.add_child(UI.label("✅ " + "⭐".repeat(box_n), 16, UI.GREEN_DARK))
			M.ui_place._tile_button(t, UI.soft_button(M.tr("📖 Read again"), M.ui_card._card_page.bind(cid), true, 16))
		"quiz":
			t.add_child(UI.label(M.tr("Read! Now its quiz."), 15, UI.INK, true))
			M.ui_place._tile_button(t, UI.button(M.tr("❓ Quiz"), M.ui_card._show_card.bind(cid), true, UI.GREEN, 20))
		"reading":
			t.add_child(UI.explain(UI.stock_bar(float(G.S["read_progress"]), ceilf(G.read_needed(cid)), UI.BLUE, 120), M.tr("📖 Pages read: each Time Quiz question turns one.")))
			M.ui_place._tile_button(t, UI.wait_button(maxi(1, G.up(G.read_needed(cid) - float(G.S["read_progress"]))), M.ui_quiz._show_time_quiz))
		"readable":
			var rq: int = G.up(G.read_needed(cid) * G.m("read"))
			t.add_child(UI.label((M.tr("Reading takes %d question") if rq == 1 else M.tr("Reading takes %d questions")) % rq, 15, UI.MUTED, true))
			M.ui_place._tile_button(t, UI.button(M.tr("📖 Read"), _start_reading.bind(cid), G.S["reading"] == "", UI.BLUE, 20))
		"prereq":
			var miss := []
			for r in n["requires"]:
				if not G.satisfied(r): miss.append(G.nodes[r]["name"])
			t.add_child(UI.label(M.tr("🔒 First: %s") % ", ".join(miss), 14, UI.MUTED, true))
		"discover":
			var miss2 := []
			for k in n.get("discover", []):
				if not G.S["seen"].has(k): miss2.append(G.iemoji(k) + " " + G.iname(k))
			t.add_child(UI.label(M.tr("🔍 Find %s first") % ", ".join(miss2), 14, UI.MUTED, true))
		_:
			t.add_child(UI.label("🔒", 15, UI.MUTED))
	return t.get_meta("panel")
