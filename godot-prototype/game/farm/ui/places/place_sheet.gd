extends RefCounted
## A place's sheet: header, goals here, polish, mysteries, tiles and grids, the pantry.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")

var M
var G

const CAT_ORDER := ["crop", "animal", "ingredient", "dish", "material", "textile", "fertilizer", "byproduct", "feed", "fuel", "container", "craft", "find", "seed", "keeper", "pet-item"]

## A locked place with nothing within reach: only a weathered sign and a promise.
func _part_mystery() -> void:
	M.content.add_child(UI.header(Art.first("deco", ["mystery_sign", "signpost"]), "🪧", 130))
	var l := UI.label(M.tr("Something stood here once…\nYou will find out what belongs here later — when you have what it needs."), 19, UI.MUTED, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	M.content.add_child(l)

## The picture at the top of a place's sheet: what stands there now (or the first thing built in a pen).
func _spot_header(sid: String) -> Control:
	if sid == "road": return UI.header(Art.first("map", M.ui_map._art_keys("road")), "🛤️", 90)
	var ms = M.ui_map._map_sid(sid)
	var tex: Texture2D = null
	if M.map.slots.has(ms) and M.map.slots[ms].visible and M.map.slots[ms].pic.texture: tex = M.map.slots[ms].pic.texture
	if Spots.parent_of(sid) != "" and M.ui_map._built(Spots.parent_of(sid)):
		var keys: Array = Spots.HOTSPOT_ART.get(sid, []).filter(func(id): return G.nodes.has(id) and G.done(id))
		keys.reverse()
		var kk = M.ui_map._first_key("interior", keys)
		tex = Art.tex("interior", kk) if kk != "" else null
	if tex == null and Spots.PENS.has(sid):
		for a in M.map.addon_nodes:
			if a["sid"] == sid and a["node"].visible: tex = a["node"].texture
	return UI.header(tex, M.ui_map._spot_emoji(sid), 100)

func _sheet_spot(sid: String) -> void:
	if sid == "field" and M._patch_note >= 0: M.ui_fields._part_patch_note(M._patch_note)
	var head = M.ui_map._headline(sid)
	if head != "" and str(G.nodes[head].get("desc", "")) != "" and not (sid in ["market", "board"]):
		M.content.add_child(UI.label(str(G.nodes[head]["desc"]), 16, UI.MUTED, true))
	elif not M.ui_map._is_open(sid):
		M.content.add_child(UI.label(M.tr("Build it to open this place."), 17, UI.MUTED, true))
	var lists := _goal_lists(sid)
	if sid != "market" and sid != "field": _part_main_goals(sid, lists[0])   # (the field: in "The whole field")   # what to do here comes first (the market: selling first, orders at the bottom)
	match sid:
		"living": M.ui_home._part_home()
		"library": M.ui_village._part_library()
		"storage": _part_pantry()
		"market": M.ui_village._part_market()
		"bookcart": M.ui_village._part_bookcart()
		"board": M.ui_board._part_jobs()
		"field":
			M.ui_fields._part_whole_field()
			return
		"orchard": M.ui_fields._part_area("orchard")
		"greenhouse": M.ui_fields._part_area("gh")
		"pets": M.ui_pets._part_pets()
		"kitchen", "forest": M.ui_stations._part_woodpile()
		"pond", "well": M.ui_water._part_water(sid)
		"road": M.ui_road._part_road()
	for aid in Spots.nodes_at(G, sid):
		if G.nodes[aid]["type"] != "animal": continue
		if not G.missing_reqs(aid).is_empty() and not G.done(aid): continue
		M.content.add_child(M.ui_animals._animal_card(aid))
	for root in G.stations():
		if Spots.in_spot(G, root, sid): M.content.add_child(M.ui_stations._station_card(root))
	_part_more_goals(sid, lists[0], lists[1], lists[2])
	_part_polish_here(sid)
	if sid == "market": _part_main_goals(sid, lists[0])

## [main goals open now, optional upgrades open now, [id, missing] one step away] at a place.
func _goal_lists(sid: String) -> Array:
	var main := []
	var opt := []
	var soon := []
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not (n["type"] in M.GOAL_TYPES): continue
		if G.done(id) or G.satisfied(id) or not M.ui_map._in_chapter(id): continue
		var mr: Array = G.missing_reqs(id)
		if mr.is_empty():
			if n.get("optional", false): opt.append(id)
			else: main.append(id)
		elif mr.size() == 1 and not n.get("optional", false):
			soon.append([id, mr[0]])
	var key := func(a): return int(G.nodes[a].get("chapter", 1)) * 10 + (0 if G.can_unlock(a)["ok"] else 1)
	main.sort_custom(func(a, b): return key.call(a) < key.call(b))
	opt.sort_custom(func(a, b): return key.call(a) < key.call(b))
	return [main, opt, soon]

func _part_main_goals(sid: String, main: Array) -> void:
	if main.is_empty(): return
	M.ui_widgets._section(M.tr("🤝 Favours for neighbours") if sid == "board" else (M.tr("📦 Orders to deliver") if sid == "market" else M.tr("🔨 To do here")),
		M.tr("Help someone: the reward is a picture for your album, and a bit of luck.") if sid == "board" else "")
	M.content.add_child(M.ui_widgets._node_grid(main))

func _part_more_goals(sid: String, main: Array, opt: Array, soon: Array) -> void:
	if not opt.is_empty():
		M.ui_widgets._section(M.tr("🧰 Upgrades (optional)"), M.tr("Never required — they make work cheaper for good."))
		M.content.add_child(M.ui_widgets._node_grid(opt))
	# what comes later is not shown here: only what can be done now (the quest book has this chapter's next steps)

func _part_polish_here(sid: String) -> void:
	var ids := []
	for pid in G.polish_ids:
		if Spots.in_spot(G, pid, sid) and G.polish_open(pid): ids.append(pid)
	if ids.is_empty(): return
	M.ui_widgets._section(M.tr("✨ Polish"), M.tr("Sharpen, oil, clean… The first time helps most; every next time adds half as much and costs more. Use wears it off slowly."))
	var g := _grid(2)
	for pid in ids: g.add_child(_polish_card(pid))
	M.content.add_child(g)

func _polish_card(pid: String) -> PanelContainer:
	var n: Dictionary = G.nodes[pid]
	var p: float = G.polish_level(pid)
	var pc := UI.card()
	pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(3)
	pc.add_child(v)
	v.add_child(UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 17, UI.INK, true))
	var h := UI.hbox(6)
	h.add_child(UI.explain(UI.bar(G.polish_gain(pid, p), 120, 10, UI.AMBER), M.tr("✨ How polished it is: the fuller, the stronger it works.")))
	h.add_child(UI.label("%d%%→%d%%" % [int(round(G.polish_gain(pid, p) * 100)), int(round(G.polish_gain(pid, floorf(p) + 1.0) * 100))], 14, UI.MUTED))
	v.add_child(h)
	v.add_child(UI.label(M.tr("At full polish: ") + M.ui_widgets._effect_text(n.get("effects", {})), 14, UI.GREEN_DARK, true))
	var c: Dictionary = G.polish_cost(pid)
	_tile_button(v, UI.button("✨ " + G.cost_text(c), G.do_polish.bind(pid), G.missing_cost(c).is_empty(), UI.AMBER, 16))
	return pc

## A grid for long lists (the store, the market): 3 tiles in a row (4 on wide screens).
func _grid(cols := 3) -> GridContainer:
	var g := GridContainer.new()
	g.columns = cols + 1 if M.size.x >= 900 else cols
	g.add_theme_constant_override("h_separation", 8)
	g.add_theme_constant_override("v_separation", 8)
	return g

## One tile of a grid: a picture (or emoji), a name, and room below for amounts and buttons.
func _tile(pic: Texture2D, emoji: String, title: String, bg := UI.PAPER) -> VBoxContainer:
	var pc := UI.card(bg)
	pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(3)
	pc.add_child(v)
	var top := UI.hbox(6)
	if pic:
		var tr := TextureRect.new()
		tr.texture = pic
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.custom_minimum_size = Vector2(40, 40)
		top.add_child(tr)
	else:
		top.add_child(UI.label(emoji, 28))
	var tl := UI.label(title, 14, UI.MUTED, true)
	tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(tl)
	v.add_child(top)
	v.set_meta("panel", pc)
	return v

## The action button at the bottom of a tile: as wide as the tile, pushed to the bottom so the buttons of a row line up.
func _tile_button(t: VBoxContainer, btn: Button) -> void:
	var sp := Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	t.add_child(sp)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.custom_minimum_size = Vector2(0, maxf(btn.custom_minimum_size.y, 52))
	t.add_child(btn)

func _part_pantry() -> void:
	var ready_n = M.ui_fields._ready_count("field") + M.ui_fields._ready_count("orchard") + M.ui_fields._ready_count("gh")
	var hb := UI.button(M.tr("🧺 Harvest all  (%d ready)") % ready_n if ready_n > 0 else M.tr("🧺 Harvest all — nothing is ready yet"), _harvest_everything, ready_n > 0, UI.GREEN, 20)
	hb.custom_minimum_size = Vector2(0, 58)
	M.content.add_child(hb)
	M.ui_widgets._section(M.tr("🧺 What you have"), M.tr("🍂 = goes stale at the next change of season — sell it, eat it or cook it into something that keeps. 🪙 = what one sells for; ↓ = the market has had lots of it lately and pays less for a while."))
	var grid := _grid()
	M.content.add_child(grid)
	var cap: float = G.storage_cap()
	var keys: Array = G.S["inv"].keys()
	keys.sort_custom(func(a, b):
		return CAT_ORDER.find(G.items[a].get("category", "")) * 1000 + G.items.keys().find(a) < CAT_ORDER.find(G.items[b].get("category", "")) * 1000 + G.items.keys().find(b))
	for k in keys:
		var q: float = G.count(k)
		if q < 0.999 and G.items[k].get("category", "") != "keeper": continue
		var it: Dictionary = G.items[k]
		var v := _tile(Art.first("items", [k]), str(it.get("emoji", "")), str(it["name"]) + ("  🍂" if G.stale_soon(k) >= 1.0 else ""))
		var keeper: bool = it.get("category", "") == "keeper"
		v.add_child(UI.explain(UI.stock_bar(q, q if keeper else cap, UI.item_color(k, G.items), 190),
			("%s %d %s" % [str(it.get("emoji", "")), G.down(q), str(it["name"])]) + ("" if keeper else M.tr(" — your store holds %d of each.") % G.down(cap))))
		var row := HFlowContainer.new()
		if it.has("buff"): row.add_child(UI.soft_button("😋", G.eat.bind(k), true, 20))
		if G.fuel_value(k) > 0.0: row.add_child(UI.soft_button("🔥", M.ui_stations._stack.bind(k), true, 20))
		if G.sellable(k):
			# "1 🥣 = 4 🪙" and "5 🥕 = 10 🪙": what you give and what you get
			var em := str(it.get("emoji", "📦"))
			var have: int = G.down(q)
			row.add_child(UI.soft_button("1 %s = %d 🪙" % [em, G.down(G.sell_total(k, 1))], G.sell.bind(k, 1.0), true, 17))
			if have > 1: row.add_child(UI.soft_button("%d %s = %d 🪙" % [have, em, G.down(G.sell_total(k, have))], G.sell.bind(k, 999.0), true, 17))
			if G.demand_factor(k) < 0.999: v.add_child(UI.label(M.tr("↓ lots sold lately — pays less for a while"), 13, Color("b5562b"), true))
		if row.get_child_count() > 0: v.add_child(row)
		grid.add_child(v.get_meta("panel"))
	var seeds := []
	for cid in G.S["seeds"]:
		if float(G.S["seeds"][cid]) >= 1.0: seeds.append(cid)
	if seeds.size() > 0:
		M.ui_widgets._section(M.tr("🌱 Seeds"))
		var sg := _grid()
		M.content.add_child(sg)
		for cid in seeds:
			var sv := _tile(Art.tex("crops", cid), str(G.nodes[cid].get("emoji", "")), str(G.nodes[cid]["name"]))
			sv.add_child(UI.explain(UI.stock_bar(float(G.S["seeds"][cid]), maxf(10.0, ceilf(float(G.S["seeds"][cid]))), Color("a3c26a"), 190), M.tr("🌰 Seeds you have to plant.")))
			sg.add_child(sv.get_meta("panel"))

func _harvest_everything() -> void:
	var n = M.ui_fields._ready_count("field") + M.ui_fields._ready_count("orchard") + M.ui_fields._ready_count("gh")
	for a in ["field", "orchard", "gh"]: M.ui_fields._harvest_all(a)
	if n > 0 and G.perk_on("perk_confetti"):
		var fx = UI.Celebration.new()
		M.add_child(fx)
		fx.size = M.size
		fx.start("confetti", M.size / 2.0)
		M.ui_sounds._sfx("confetti")
