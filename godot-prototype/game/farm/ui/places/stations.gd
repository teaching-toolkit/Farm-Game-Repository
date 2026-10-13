extends RefCounted
## Places with stations: the station cards, the woodpile, stoking, cutting trees.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")

var M
var G

func _part_woodpile() -> void:
	var wp := UI.card(Color("f6ecd8"))
	var wv := UI.vbox(4)
	wp.add_child(wv)
	wv.add_child(UI.label(M.tr("🪵 Woodpile: %d / %d fuel — ovens, kilns and the forge burn it; the house too in winter.") % [G.down(G.S["woodpile"]), G.down(G.woodpile_cap())], 16, UI.INK, true))
	var wh := HFlowContainer.new()
	wv.add_child(wh)
	for k in G.meta.get("fuel", {}).get("values", {}):
		if G.count(k) >= 1.0:
			wh.add_child(UI.soft_button("+ %s %s (%d)" % [G.iemoji(k), G.iname(k), G.down(G.count(k))], _stack.bind(k), true, 16))
	M.content.add_child(wp)

func _stack(k: String) -> void:
	var n: float = G.stack_wood(k, G.count(k))
	if n > 0.0: G.say(M.tr("🪵 Stacked %d %s on the woodpile.") % [int(n), G.iname(k)])
	G.save_game(); M._queue_refresh()

func _station_card(root: String) -> PanelContainer:
	var act: String = G.active_of(root)
	var n: Dictionary = G.nodes[act]
	var pc := UI.card()
	var v := UI.vbox(4)
	pc.add_child(v)
	var running: Array = G.S["running"].get(root, [])
	var stars: int = G.stars(root)
	var now: bool = G.output_now(root)      # gathering: things come at once, each spot then refills (hourglass in its row)
	v.add_child(UI.label("%s %s   %s" % [n.get("emoji", ""), n["name"], "⭐".repeat(stars)], 19, UI.INK, true))
	var soonest := 999
	for job in running: soonest = mini(soonest, G.up(job["left"]))
	var att := []
	for hid in G.nodes:
		if G.nodes[hid].has("attach") and G.chain_members(root).has(G.nodes[hid]["attach"]): att.append(hid)
	if att.size() > 0:
		var ah := HFlowContainer.new()
		ah.add_child(UI.label(M.tr("Choice slot: "), 14, UI.MUTED))
		for hid in att:
			var hn: Dictionary = G.nodes[hid]
			if G.done(hid):
				var active: bool = G.S["attach"].get(hn["attach"], "") == hid
				if active: ah.add_child(UI.button("✔ " + hn.get("emoji", "") + " " + hn["name"], Callable(), true, UI.GREEN, 14))
				else: ah.add_child(UI.soft_button("use " + hn.get("emoji", "") + " " + hn["name"], G.set_attach.bind(hn["attach"], hid), true, 14))
			else:
				ah.add_child(UI.label(M.tr("(%s %s: build it below) ") % [hn.get("emoji", ""), hn["name"]], 13, UI.MUTED))
		v.add_child(ah)
	# every open recipe is a tile in a grid (picture, name, what it gives, its cost, and its button at the bottom);
	# recipes waiting for something of this chapter are listed below the grid
	var grid = M.ui_place._grid()
	var locked := []
	for rid in G.station_recipes_for(root):
		var r: Dictionary = G.recipes[rid]
		var out0: String = r["outputs"].keys()[0]
		var title := str(r.get("name", G.iname(out0)))
		if not G.recipe_open(rid):
			var why := []
			var later := false
			for q in r.get("requires", []):
				if not G.satisfied(q):
					why.append(G.nodes[q].get("emoji", "") + " " + G.nodes[q]["name"])
					if not M.ui_map._in_chapter(q) or not G.missing_reqs(q).is_empty(): later = true
			if not later: locked.append(M.tr("🔒 %s — needs %s") % [title, ", ".join(why)])
			continue
		var outs := []
		var batch: int = G.recipe_batch(rid)     # carrying gear: a bigger load per tap (and more energy)
		for k in r["outputs"]: outs.append("%s%s" % [G.iemoji(k), M.ui_widgets._num(float(r["outputs"][k]) * G.m("out:" + r["station"]) * batch)])
		var pay: Dictionary = G.recipe_cost(rid)
		var c: Dictionary = pay.duplicate()
		var base: Dictionary = G.recipe_cost_base(rid)
		var fuel: float = G.recipe_fuel(rid)
		if fuel > 0.0:
			c["fuel"] = fuel
			base["fuel"] = float(r.get("fuel", 0))
		var extra := []
		var tm: float = G.recipe_time(rid)
		if batch > 1: extra.append("🧺×%d" % batch)
		if tm > 0.0: extra.append("⏳%d" % G.up(tm))
		for k in r.get("keeps", []): extra.append("keeps %s" % G.iemoji(k))
		var wv: Vector2 = G.recipe_worth(rid)
		var t = M.ui_place._tile(Art.first("items", [out0]), G.iemoji(out0), title)
		t.add_child(UI.rich("→ %s  [color=#7a705c]%s[/color]%s" % [" ".join(outs), " ".join(extra),
			("\n[color=#3c8a3c]🪙%s → 🪙%s[/color]" % [M.ui_widgets._num(wv.x), M.ui_widgets._num(wv.y)]) if wv.y > 0.0 else ""], 15))
		t.add_child(M.ui_widgets._costs(c, base))
		var have_all: bool = G.missing_cost(G.recipe_cost(rid, 1)).is_empty() and M.ui_widgets._have_any("fuel") + 0.001 >= fuel   # a smaller load still works
		# everything else is there, only the woodpile needs wood first: then the button stokes it
		var stoke_now: bool = fuel > 0.0 and M.ui_widgets._have_any("fuel") + 0.001 < fuel and G.missing_cost(G.recipe_cost(rid, 1)).is_empty()
		var left: float = G.recipe_left(rid)
		var btn: Button
		if left > 0.0:
			btn = UI.wait_button(G.up(left), M.ui_quiz._show_time_quiz)                         # this one is cooking / refilling
		elif running.size() >= G.station_slots(root):
			btn = UI.wait_button(soonest if soonest < 999 else 1, M.ui_quiz._show_time_quiz)    # busy: wait for a batch
		elif stoke_now:
			var can: bool = G.fuel_in_store() + float(G.S["woodpile"]) + 0.001 >= fuel
			btn = UI.action_button("cook", _stoke.bind(fuel), can, UI.AMBER, "🪵", M.tr("Stoke") if can else M.tr("Need wood"))
			btn.tooltip_text = M.tr("Put wood on the woodpile first: %d fuel.") % G.up(fuel)
		else:
			btn = UI.action_button(G.recipe_cat(rid), G.start_recipe.bind(rid), have_all, UI.GREEN, "", str(r.get("verb", "")))
		M.ui_place._tile_button(t, btn)
		grid.add_child(t.get_meta("panel"))
	if grid.get_child_count() > 0: v.add_child(grid)
	for line in locked: v.add_child(UI.label(line, 14, UI.MUTED, true))
	return pc

func _do_cut_tree(a: String, i: int) -> void:
	if G.cut_tree(a, i): M.ui_sheets._open_sheet("patch:%s:%d" % [a, i])

func _stoke(need: float) -> void:
	G.stoke(need)
	M._queue_refresh()
