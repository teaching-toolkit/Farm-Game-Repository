extends RefCounted
class_name FarmUiStations
## Stations and recipes (kitchen, workshop): the woodpile and fuel, station cards with their recipes, polish, flex tips.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ what a place shows

func part_polish_here(sid: String) -> void:
	var ids := []
	for pid in G.polish_ids:
		if Spots.in_spot(G, pid, sid) and G.crafting.polish_open(pid): ids.append(pid)
	if ids.is_empty(): return
	M.widgets.section(tr("✨ Polish"), tr("Sharpen, oil, clean… The first time helps most; every next time adds half as much and costs more. Use wears it off slowly."))
	var g := M.widgets.grid(2)
	for pid in ids: g.add_child(_polish_card(pid))
	M.content.add_child(g)

func _polish_card(pid: String) -> PanelContainer:
	var n: Dictionary = G.nodes[pid]
	var p: float = G.crafting.polish_level(pid)
	var pc := UI.card()
	pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(3)
	pc.add_child(v)
	v.add_child(UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 17, UI.INK, true))
	var h := UI.hbox(6)
	h.add_child(UI.explain(UI.bar(G.crafting.polish_gain(pid, p), 120, 10, UI.AMBER), tr("✨ How polished it is: the fuller, the stronger it works.")))
	h.add_child(UI.label("%d%%→%d%%" % [int(round(G.crafting.polish_gain(pid, p) * 100)), int(round(G.crafting.polish_gain(pid, floorf(p) + 1.0) * 100))], 14, UI.MUTED))
	v.add_child(h)
	v.add_child(UI.label(tr("At full polish: ") + M.widgets.effect_text(n.get("effects", {})), 14, UI.GREEN_DARK, true))
	var c: Dictionary = G.crafting.polish_cost(pid)
	M.widgets.tile_button(v, UI.button("✨ " + G.pace.cost_text(c), G.crafting.do_polish.bind(pid), G.pace.missing_cost(c).is_empty(), UI.AMBER, 16))
	return pc

func part_woodpile() -> void:
	var wp := UI.card(Color("f6ecd8"))
	var wv := UI.vbox(4)
	wp.add_child(wv)
	wv.add_child(UI.label(tr("🪵 Woodpile: %d / %d fuel — ovens, kilns and the forge burn it; the house too in winter.") % [G.down(G.S["woodpile"]), G.down(G.crafting.woodpile_cap())], 16, UI.INK, true))
	var wh := HFlowContainer.new()
	wv.add_child(wh)
	for k in G.meta.get("fuel", {}).get("values", {}):
		if G.inventory.count(k) >= 1.0:
			wh.add_child(UI.soft_button("+ %s %s (%d)" % [G.iemoji(k), G.iname(k), G.down(G.inventory.count(k))], stack.bind(k), true, 16))
	M.content.add_child(wp)

func stack(k: String) -> void:
	var n: float = G.crafting.stack_wood(k, G.inventory.count(k))
	if n > 0.0: G.say(tr("🪵 Stacked %d %s on the woodpile.") % [int(n), G.iname(k)])
	G.save_game(); M.queue_refresh()

func station_card(root: String) -> PanelContainer:
	var act: String = G.crafting.active_of(root)
	var n: Dictionary = G.nodes[act]
	var pc := UI.card()
	var v := UI.vbox(4)
	pc.add_child(v)
	var running: Array = G.S["running"].get(root, [])
	var stars: int = G.needs.stars(root)
	var now: bool = G.crafting.output_now(root)      # gathering: things come at once, each spot then refills (hourglass in its row)
	v.add_child(UI.label("%s %s   %s" % [n.get("emoji", ""), n["name"], "⭐".repeat(stars)], 19, UI.INK, true))
	var soonest := 999
	for job in running: soonest = mini(soonest, G.up(job["left"]))
	var att := []
	for hid in G.nodes:
		if G.nodes[hid].has("attach") and G.crafting.chain_members(root).has(G.nodes[hid]["attach"]): att.append(hid)
	if att.size() > 0:
		var ah := HFlowContainer.new()
		ah.add_child(UI.label(tr("Choice slot: "), 14, UI.MUTED))
		for hid in att:
			var hn: Dictionary = G.nodes[hid]
			if G.done(hid):
				var active: bool = G.S["attach"].get(hn["attach"], "") == hid
				if active: ah.add_child(UI.button("✔ " + hn.get("emoji", "") + " " + hn["name"], Callable(), true, UI.GREEN, 14))
				else: ah.add_child(UI.soft_button("use " + hn.get("emoji", "") + " " + hn["name"], G.progression.set_attach.bind(hn["attach"], hid), true, 14))
			else:
				ah.add_child(UI.label(tr("(%s %s: build it below) ") % [hn.get("emoji", ""), hn["name"]], 13, UI.MUTED))
		v.add_child(ah)
	# every open recipe is a tile in a grid (picture, name, what it gives, its cost, and its button at the bottom);
	# recipes waiting for something of this chapter are listed below the grid
	var grid := M.widgets.grid()
	var locked := []
	for rid in G.crafting.station_recipes_for(root):
		var r: Dictionary = G.recipes[rid]
		var out0: String = r["outputs"].keys()[0]
		var title := str(r.get("name", G.iname(out0)))
		if not G.crafting.recipe_open(rid):
			var why := []
			var later := false
			for q in r.get("requires", []):
				if not G.satisfied(q):
					why.append(G.nodes[q].get("emoji", "") + " " + G.nodes[q]["name"])
					if not M.mapview.in_chapter(q) or not G.progression.missing_reqs(q).is_empty(): later = true
			if not later: locked.append(tr("🔒 %s — needs %s") % [title, ", ".join(why)])
			continue
		var outs := []
		var batch: int = G.crafting.recipe_batch(rid)     # carrying gear: a bigger load per tap (and more energy)
		for k in r["outputs"]: outs.append("%s%s" % [G.iemoji(k), M.widgets.num(float(r["outputs"][k]) * G.m("out:" + r["station"]) * batch)])
		var pay: Dictionary = G.crafting.recipe_cost(rid)
		var c: Dictionary = pay.duplicate()
		var base: Dictionary = G.crafting.recipe_cost_base(rid)
		var fuel: float = G.crafting.recipe_fuel(rid)
		if fuel > 0.0:
			c["fuel"] = fuel
			base["fuel"] = float(r.get("fuel", 0))
		var extra := []
		var tm: float = G.crafting.recipe_time(rid)
		if batch > 1: extra.append("🧺×%d" % batch)
		if tm > 0.0: extra.append("⏳%d" % G.up(tm))
		for k in r.get("keeps", []): extra.append("keeps %s" % G.iemoji(k))
		var wv: Vector2 = G.trade.recipe_worth(rid)
		var t := M.widgets.tile(Art.first("items", [out0]), G.iemoji(out0), title)
		t.add_child(UI.rich("→ %s  [color=#7a705c]%s[/color]%s" % [" ".join(outs), " ".join(extra),
			("\n[color=#3c8a3c]🪙%s → 🪙%s[/color]" % [M.widgets.num(wv.x), M.widgets.num(wv.y)]) if wv.y > 0.0 else ""], 15))
		t.add_child(M.widgets.costs(c, base))
		var have_all: bool = G.pace.missing_cost(G.crafting.recipe_cost(rid, 1)).is_empty() and M.widgets.have_any("fuel") + 0.001 >= fuel   # a smaller load still works
		# everything else is there, only the woodpile needs wood first: then the button stokes it
		var stoke_now: bool = fuel > 0.0 and M.widgets.have_any("fuel") + 0.001 < fuel and G.pace.missing_cost(G.crafting.recipe_cost(rid, 1)).is_empty()
		var left: float = G.crafting.recipe_left(rid)
		var btn: Button
		if left > 0.0:
			btn = UI.wait_button(G.up(left), M.timequiz.show_time_quiz)                         # this one is cooking / refilling
		elif running.size() >= G.crafting.station_slots(root):
			btn = UI.wait_button(soonest if soonest < 999 else 1, M.timequiz.show_time_quiz)    # busy: wait for a batch
		elif stoke_now:
			var can: bool = G.crafting.fuel_in_store() + float(G.S["woodpile"]) + 0.001 >= fuel
			btn = UI.action_button("cook", _stoke.bind(fuel), can, UI.AMBER, "🪵", tr("Stoke") if can else tr("Need wood"))
			btn.tooltip_text = tr("Put wood on the woodpile first: %d fuel.") % G.up(fuel)
		else:
			btn = UI.action_button(G.crafting.recipe_cat(rid), G.crafting.start_recipe.bind(rid), have_all, UI.GREEN, "", str(r.get("verb", "")))
		M.widgets.tile_button(t, btn)
		grid.add_child(t.get_meta("panel"))
	if grid.get_child_count() > 0: v.add_child(grid)
	for line in locked: v.add_child(UI.label(line, 14, UI.MUTED, true))
	return pc

func do_cut_tree(a: String, i: int) -> void:
	if G.fields.cut_tree(a, i): M.sheets.open_sheet("patch:%s:%d" % [a, i])

func toggle_flex() -> void:
	G.pace.toggle_flex()
	M.modals.close_modal()
	M.menu.show_menu()

func _stoke(need: float) -> void:
	G.crafting.stoke(need)
	M.queue_refresh()
