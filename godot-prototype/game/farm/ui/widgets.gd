extends RefCounted
## Small helpers for texts and rows: numbers, costs, effects, node rows and grids, unlocking from a row.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Spots = preload("res://game/farm/spots.gd")

var M
var G

const CAT_LABEL := {"field": "Field work", "weed": "Weeding", "plant": "Planting", "harvest": "Harvesting", "gather": "Gathering", "wood": "Wood work",   # i18n
	"build": "Building", "craft": "Crafting", "smith": "Smithing", "kiln": "Kiln work", "cook": "Cooking", "prep": "Prep", "mill": "Milling",   # i18n
	"process": "Dairy & press", "textile": "Textiles", "animal": "Animal care", "errand": "Errands"}   # i18n

## A picture for what the button of a goal does.
const VERB := {"building": "🔨", "station": "🔨", "tool": "🛠️", "gear": "🧵", "helper": "🔨", "land": "💪",
	"patch": "🟫", "delivery": "📦", "pet": "🐾", "sidequest": "🤝", "book": "🛒"}

## Whole numbers for kids: 0.5 shows as ½, 1.5 as 1½, anything else is rounded.
func _num(v: float) -> String:
	var r := snappedf(v, 0.5)
	if absf(v - r) > 0.15: return str(int(round(v)))
	var whole := int(floor(r))
	if absf(r - whole) > 0.01: return ("%d½" % whole) if whole > 0 else "½"
	return str(whole)

func _pct(v: float) -> String:
	return ("−%d%%" % int(round((1.0 - v) * 100))) if v < 1.0 else ("+%d%%" % int(round((v - 1.0) * 100)))

func _effect_text(e: Dictionary) -> String:
	var out := []
	for k in e.get("set", {}):
		var v = e["set"][k]
		match k:
			"energyMax": out.append(M.tr("energy max %d") % int(v))
			"energyPerRest": out.append(M.tr("%s ⚡ per Rest answer") % _num(float(v)))
			"waterPerStep": out.append(M.tr("+%s 💧 per question") % _num(float(v)))
			"waterCap": out.append(M.tr("holds %d 💧") % int(v))
			"storageCap": out.append(M.tr("holds %d of each item") % int(v))
			"patchCap": out.append(M.tr("%d plants per patch") % int(v))
			"scare": out.append(M.tr("chases %s pests per question") % _num(float(v)))
			"pestBlock": out.append(M.tr("%d%% fewer pests get in") % int(round(float(v) * 100)))
			"bookSlots": out.append(M.tr("holds %d books") % int(v))
			"waterMult": out.append(M.tr("plants need %d%% water") % int(round(float(v) * 100)))
			_:
				if k.begins_with("cap_"): out.append(M.tr("room for %d %s") % [int(v), k.substr(4)])
	for k in e.get("add", {}):
		var v2 := float(e["add"][k])
		if k == "energyPerRest": out.append(M.tr("+%s ⚡ per Rest answer") % _num(v2))
		elif k == "energyMax": out.append(M.tr("energy max +%d") % int(v2))
		elif k == "plots": out.append(M.tr("+%d field patches") % int(v2))
		elif k == "waterPerStep": out.append(M.tr("+%s 💧 per question") % _num(v2))
		elif k == "scare": out.append(M.tr("chases %s more pests") % _num(v2))
		elif k == "sellBonusPct": out.append(M.tr("+%d%% when selling") % int(v2))
		elif k.begins_with("slots:"): out.append(M.tr("+%d batch at %s") % [int(v2), G.nodes.get(k.substr(6), {}).get("name", k.substr(6))])
		elif k.begins_with("yield_"): out.append(M.tr("+%d %s per harvest") % [int(v2), G.iname(k.substr(6))])
		elif k == "shelfLife": out.append(M.tr("food keeps %d season longer") % int(v2))
		else: out.append("%s +%s" % [k, _num(v2)])
	for k in e.get("mult", {}):
		var v3 := float(e["mult"][k])
		var parts: PackedStringArray = k.split(":")
		var kind: String = parts[0]
		var a: String = parts[1] if parts.size() > 1 else ""
		match kind:
			"energy": out.append("%s %s" % [M.tr(str(CAT_LABEL.get(a, a))), _pct(v3)])
			"water": out.append("%s water %s" % ["field" if a == "field" else "animal", _pct(v3)])
			"weeds": out.append("weeds %s" % _pct(v3))
			"grow": out.append(M.tr("growing time %s") % _pct(v3))
			"pests": out.append("pests %s" % _pct(v3))
			"stones": out.append("stones %s" % _pct(v3))
			"fuel": out.append("firewood %s" % _pct(v3))
			"muck": out.append("muck %s" % _pct(v3))
			"read": out.append(M.tr("reading time %s") % _pct(v3))
			"out": out.append("%s output %s" % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"feed": out.append("%s eat %s" % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"time": out.append("%s time %s" % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"in": out.append("%s needed %s" % [G.iname(parts[2]) if parts.size() > 2 else a, _pct(v3)])
			_: out.append("%s %s" % [k, _pct(v3)])
	for k in e.get("produces", {}): out.append(M.tr("+1 %s every %d questions") % [G.iname(k), int(round(1.0 / maxf(0.01, float(e["produces"][k]))))])
	return ", ".join(out)

func _cost_bb(c: Dictionary) -> String:
	var parts := []
	for k in c:
		var need := float(c[k])
		var have: float = G.have(k)
		var col := "#3b6a26" if have + 0.0001 >= need else "#b9472f"
		var t := "%s%d" % [G.iemoji(k), G.up(need)]
		if have + 0.0001 < need and k != "energy": t += M.tr(" (have %d)") % G.down(have)
		parts.append("[color=%s]%s[/color]" % [col, t])
	return "  ".join(parts)

## Costs as cube bars: filled = you have it, hollow = still missing, faint grey = saved by upgrades, practice and meals.
func _costs(c: Dictionary, base := {}) -> Control:
	return UI.cost_row(c, base, _have_any, _emoji_any, G.items)

func _have_any(k: String) -> float:
	if k == "fuel": return float(G.S["woodpile"])     # only what is on the woodpile burns: stoke it first
	return G.have(k)

func _emoji_any(k: String) -> String:
	if k == "fuel": return "🔥"
	return G.iemoji(k)

## How many questions until patch p is grown.
func _grow_left(a: String, p: Dictionary) -> int:
	var left: float = G.grow_target(p) - float(p["growth"])
	return maxi(1, int(ceil(left / maxf(0.05, G.grow_speed(a, p)) - 0.001)))

func _section(title: String, note := "") -> void:
	var l := UI.label(title, 20, UI.INK)
	M.content.add_child(l)
	if note != "": M.content.add_child(UI.label(note, 15, UI.MUTED, true))

## A goal as a card. tile = true: for a grid (the button goes to the bottom, as wide as the card).
func _node_row(id: String, show_button := true, show_place := false, tile := false) -> PanelContainer:
	var n: Dictionary = G.nodes[id]
	var pc := UI.card()
	if tile: pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var bottom: Button = null
	var v := UI.vbox(3)
	pc.add_child(v)
	var h := UI.hbox(6)
	v.add_child(h)
	h.add_child(UI.label("%s %s" % [n.get("emoji", ""), n["name"]], 19, UI.INK, true))
	if show_place:
		var sid := Spots.spot_of(G, id)
		var pb := UI.soft_button("📍 " + M.tr(str(Spots.SPOTS.get(sid, [sid])[0])), _go_spot.bind(sid), true, 15)
		h.add_child(pb)
	var ck: Dictionary = G.can_unlock(id)
	var steps: Array = G.steps_of(id)
	if show_button:
		var verb: String = VERB.get(n["type"], "✔")
		if steps.size() > 0: verb = str(steps[mini(G.step_index(id), steps.size() - 1)].get("emoji", verb))
		if n.get("perPatch", false): verb += " %d/%d" % [G.patch_progress(id), G.plots()]
		var b: Button
		if str(ck.get("why", "")) == "wait":
			b = UI.wait_button(int(ck["wait"]), M.ui_quiz._show_time_quiz)      # the mortar is drying: wait for the next step
		else:
			b = UI.action_button("", _do_unlock.bind(id), ck["ok"], UI.GREEN, verb, _node_word(id))
		if tile: bottom = b
		else: h.add_child(b)
	if steps.size() > 0:
		# done in steps: how far it is (cubes) and what the next step is
		var sr := UI.hbox(6)
		sr.add_child(UI.explain(UI.stock_bar(float(G.step_index(id)), float(steps.size()), Color("7cc04a"), 160), M.tr("🔨 Steps done so far.")))
		var nx: Dictionary = steps[mini(G.step_index(id), steps.size() - 1)]
		sr.add_child(UI.label("%s %s" % [nx.get("emoji", ""), nx.get("name", "")], 16, UI.INK, true))
		var gv := ""
		for k in nx.get("gives", {}): gv += G.iemoji(k).repeat(clampi(int(round(float(nx["gives"][k]))), 1, 5))
		if gv != "": sr.add_child(UI.label("→ " + gv, 16))
		if int(nx.get("wait", 0)) > 0 and G.step_index(id) < steps.size() - 1: sr.add_child(UI.label(M.tr("then ⏳%d") % int(nx["wait"]), 15, UI.MUTED))
		v.add_child(sr)
	var c: Dictionary = G.node_cost(id)
	if not c.is_empty():
		if n.get("perPatch", false): v.add_child(UI.label(M.tr("each patch:"), 13, UI.MUTED))
		v.add_child(_costs(c, G.node_cost_base(id)))
	var d := str(n.get("desc", ""))
	if d != "": v.add_child(UI.label(d, 15, UI.MUTED, true))
	if G.flex_on() and not c.is_empty():
		var tip: String = G.flex_tip(id)       # dynamic difficulty: the improvement that makes this quicker
		if tip != "": v.add_child(UI.label(M.tr("💡 Quicker with: %s %s") % [G.nodes[tip].get("emoji", ""), G.nodes[tip]["name"]], 15, UI.BLUE, true))
	if n.has("effects"):
		var et := _effect_text(n["effects"])
		if et != "": v.add_child(UI.label("✨ " + et, 15, UI.GREEN_DARK, true))
	if bottom: M.ui_place._tile_button(v, bottom)
	return pc

## Goals as a grid of cards (two per row: they carry more words than a recipe).
func _node_grid(ids: Array) -> GridContainer:
	var g = M.ui_place._grid(2)
	for id in ids: g.add_child(_node_row(id, true, false, true))
	return g

## One word for a goal's button: the step's own word ("Lay", "Raise", "Pull" …), the node's "verb", or by its kind.
func _node_word(id: String) -> String:
	var n: Dictionary = G.nodes[id]
	if n.has("verb"): return str(n["verb"])
	var st: Array = G.steps_of(id)
	if st.size() > 0: return str(st[mini(G.step_index(id), st.size() - 1)].get("name", M.tr("Go"))).split(" ")[0]
	var first := str(n["name"]).split(" ")[0]
	if first in ["Fill", "Dig", "Clear", "Clean", "Lay", "Plant", "Edge", "Mend", "Fix", "Feed", "Pull", "Root", "Oil", "Sharpen"]: return first
	match str(n["type"]):
		"building", "station", "helper", "patch": return M.tr("Build")
		"tool": return {"smith": M.tr("Forge"), "wood": M.tr("Carve")}.get(G.node_cat(id), M.tr("Craft"))
		"gear": return M.tr("Sew") if G.node_cat(id) == "textile" else M.tr("Craft")
		"land": return M.tr("Clear")
		"delivery": return M.tr("Give") if id.begins_with("present_") else M.tr("Deliver")
		"pet": return M.tr("Welcome")
		"sidequest": return M.tr("Help")
		"book": return M.tr("Buy")
		"knowledge": return M.tr("Learn")
		"animal": return M.tr("Buy")
	return M.tr("Go")

func _go_spot(sid: String) -> void:
	M.ui_sheets._open_sheet_for(sid)
	M.ui_map._pulse(sid)

func _do_unlock(id: String) -> void:
	if G.unlock(id):
		var land: bool = str(G.nodes[id].get("type", "")) == "land"
		M.ui_acts._act("dig" if land else "build", M.map.stand_point(M.ui_map._map_sid(Spots.spot_of(G, id))))
