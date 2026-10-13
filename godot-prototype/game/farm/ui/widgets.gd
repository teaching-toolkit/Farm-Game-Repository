extends RefCounted
class_name FarmUiWidgets
## Small building blocks of the sheets: text helpers, cost lines, tiles and grids, node rows, section headers.

const UI = preload("res://kits/ui/ui.gd")
const Spots = preload("res://game/farm/spots.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

const CAT_LABEL := {"field": "Field work", "weed": "Weeding", "plant": "Planting", "harvest": "Harvesting", "gather": "Gathering", "wood": "Wood work",   # i18n
	"build": "Building", "craft": "Crafting", "smith": "Smithing", "kiln": "Kiln work", "cook": "Cooking", "prep": "Prep", "mill": "Milling",   # i18n
	"process": "Dairy & press", "textile": "Textiles", "animal": "Animal care", "errand": "Errands"}   # i18n

const VERB := {"building": "🔨", "station": "🔨", "tool": "🛠️", "gear": "🧵", "helper": "🔨", "land": "💪",
	"patch": "🟫", "delivery": "📦", "pet": "🐾", "sidequest": "🤝", "book": "🛒"}

# ------------------------------------------------------------------ layout

func clear(c: Node) -> void:
	for k in c.get_children():
		c.remove_child(k)
		k.queue_free()

# ------------------------------------------------------------------ text helpers

## Whole numbers for kids: 0.5 shows as ½, 1.5 as 1½, anything else is rounded.
func num(v: float) -> String:
	var r := snappedf(v, 0.5)
	if absf(v - r) > 0.15: return str(int(round(v)))
	var whole := int(floor(r))
	if absf(r - whole) > 0.01: return ("%d½" % whole) if whole > 0 else "½"
	return str(whole)

func _pct(v: float) -> String:
	return ("−%d%%" % int(round((1.0 - v) * 100))) if v < 1.0 else ("+%d%%" % int(round((v - 1.0) * 100)))

func effect_text(e: Dictionary) -> String:
	var out := []
	for k in e.get("set", {}):
		var v = e["set"][k]
		match k:
			"energyMax": out.append(tr("energy max %d") % int(v))
			"energyPerRest": out.append(tr("%s ⚡ per Rest answer") % num(float(v)))
			"waterPerStep": out.append(tr("+%s 💧 per question") % num(float(v)))
			"waterCap": out.append(tr("holds %d 💧") % int(v))
			"storageCap": out.append(tr("holds %d of each item") % int(v))
			"patchCap": out.append(tr("%d plants per patch") % int(v))
			"scare": out.append(tr("chases %s pests per question") % num(float(v)))
			"pestBlock": out.append(tr("%d%% fewer pests get in") % int(round(float(v) * 100)))
			"bookSlots": out.append(tr("holds %d books") % int(v))
			"waterMult": out.append(tr("plants need %d%% water") % int(round(float(v) * 100)))
			"fetchWater": out.append(tr("%d 💧 per trip to the pond") % int(v))
			"woodpileCap": out.append(tr("woodpile holds %d") % int(v))
			"homeFuel": out.append(tr("the house burns %s firewood per question") % num(float(v)))
			"roadLevel": out.append(tr("road level %s") % num(float(v)))
			"autoMill": out.append(tr("grinds flour by itself"))
			"heirloomSeedSaving": out.append(tr("seeds can be saved from every crop"))
			_:
				if k.begins_with("cap_"): out.append(tr("room for %d %s") % [int(v), k.substr(4)])
				else: out.append("%s %s" % [k, str(v)])
	for k in e.get("add", {}):
		var v2 := float(e["add"][k])
		if k == "energyPerRest": out.append(tr("+%s ⚡ per Rest answer") % num(v2))
		elif k == "energyMax": out.append(tr("energy max +%d") % int(v2))
		elif k == "plots": out.append(tr("+%d field patches") % int(v2))
		elif k == "waterPerStep": out.append(tr("+%s 💧 per question") % num(v2))
		elif k == "scare": out.append(tr("chases %s more pests") % num(v2))
		elif k == "sellBonusPct": out.append(tr("+%d%% when selling") % int(v2))
		elif k == "carry": out.append(tr("+%d per gathering trip") % int(v2))
		elif k == "fetchWater": out.append(tr("+%d 💧 per trip to the pond") % int(v2))
		elif k == "greenhouseBeds": out.append(tr("+%d greenhouse beds") % int(v2))
		elif k == "orchardSpots": out.append(tr("+%d tree spots") % int(v2))
		elif k == "luck": out.append(tr("+%d%% luck") % int(round(v2 * 100)))
		elif k == "pestBlock": out.append(tr("%d%% fewer pests get in") % int(round(v2 * 100)))
		elif k == "restedSoil": out.append(tr("rested soil grows %d%% faster") % int(round(v2 * 100)))
		elif k == "winterGrow": out.append(tr("crops grow %d%% faster in winter") % int(round(v2 * 100)))
		elif k == "waterCap": out.append(tr("holds +%d 💧") % int(v2))
		elif k.begins_with("slots:"): out.append(tr("+%d batch at %s") % [int(v2), G.nodes.get(k.substr(6), {}).get("name", k.substr(6))])
		elif k.begins_with("yield_"): out.append(tr("+%d %s per harvest") % [int(v2), G.iname(k.substr(6))])
		elif k == "shelfLife": out.append(tr("food keeps %d season longer") % int(v2))
		elif k.begins_with("well_"):
			var wp: String = k.substr(5)
			var wsp: Dictionary = G.meta.get("well", {}).get("params", {}).get(wp, {})
			if not wsp.is_empty() and v2 >= 0.075: out.append("%s %s" % [wsp["emoji"], tr(str(wsp["name"]))])      # only what is felt: a small share stays unnamed
		else: out.append("%s +%s" % [k, num(v2)])
	for k in e.get("mult", {}):
		var v3 := float(e["mult"][k])
		var parts: PackedStringArray = k.split(":")
		var kind: String = parts[0]
		var a: String = parts[1] if parts.size() > 1 else ""
		match kind:
			"energy": out.append("%s %s" % [tr(str(CAT_LABEL.get(a, a))), _pct(v3)])
			"water": out.append(tr("%s water %s") % [tr("field") if a == "field" else tr("animal"), _pct(v3)])
			"weeds": out.append(tr("weeds %s") % _pct(v3))
			"grow": out.append(tr("growing time %s") % _pct(v3))
			"pests": out.append(tr("pests %s") % _pct(v3))
			"stones": out.append(tr("stones %s") % _pct(v3))
			"fuel": out.append(tr("firewood %s") % _pct(v3))
			"homeFuel": out.append(tr("house firewood %s") % _pct(v3))
			"muck": out.append(tr("muck %s") % _pct(v3))
			"read": out.append(tr("reading time %s") % _pct(v3))
			"wear": out.append(tr("wear %s") % _pct(v3))
			"yield": out.append(tr("harvest %s") % _pct(v3))
			"out": out.append(tr("%s output %s") % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"feed": out.append(tr("%s eat %s") % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"time": out.append(tr("%s time %s") % [G.nodes.get(a, {}).get("name", a), _pct(v3)])
			"in": out.append(tr("%s needed %s") % [G.iname(parts[2]) if parts.size() > 2 else a, _pct(v3)])
			_: out.append("%s %s" % [k, _pct(v3)])
	for k in e.get("produces", {}): out.append(tr("+1 %s every %d questions") % [G.iname(k), int(round(1.0 / maxf(0.01, float(e["produces"][k]))))])
	return ", ".join(out)

func cost_bb(c: Dictionary) -> String:
	var parts := []
	for k in c:
		var need := float(c[k])
		var have: float = G.inventory.have(k)
		var col := "#3b6a26" if have + 0.0001 >= need else "#b9472f"
		var t := G.money_up(need) if k == "coins" else "%s%d" % [G.iemoji(k), G.up(need)]
		if have + 0.0001 < need and k != "energy": t += tr(" (have %s)") % (G.money(have) if k == "coins" else str(G.down(have)))
		parts.append("[color=%s]%s[/color]" % [col, t])
	return "  ".join(parts)

## Costs as cube bars: filled = you have it, hollow = still missing, faint grey = saved by upgrades, practice and meals.
func costs(c: Dictionary, base := {}) -> Control:
	return UI.cost_row(c, base, have_any, _emoji_any, G.items, G.money)

func have_any(k: String) -> float:
	if k == "fuel": return float(G.S["woodpile"])     # only what is on the woodpile burns: stoke it first
	return G.inventory.have(k)

func _emoji_any(k: String) -> String:
	if k == "fuel": return "🔥"
	return G.iemoji(k)

## How many questions until patch p is grown.
func grow_left(a: String, p: Dictionary) -> int:
	var left: float = G.fields.grow_target(p) - float(p["growth"])
	return maxi(1, int(ceil(left / maxf(0.05, G.fields.grow_speed(a, p)) - 0.001)))

func section(title: String, note := "") -> void:
	var l := UI.label(title, 20, UI.INK)
	M.content.add_child(l)
	if note != "": M.content.add_child(UI.label(note, 15, UI.MUTED, true))

## A goal as a card. tile = true: for a grid (the button goes to the bottom, as wide as the card).
func node_row(id: String, show_button := true, show_place := false, tile := false) -> PanelContainer:
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
		var pb := UI.soft_button("📍 " + tr(Spots.name_of(sid)), go_spot.bind(sid), true, 15)
		h.add_child(pb)
	var ck: Dictionary = G.progression.can_unlock(id)
	var steps: Array = G.progression.steps_of(id)
	if show_button:
		var verb: String = VERB.get(n["type"], "✔")
		if steps.size() > 0: verb = str(steps[mini(G.progression.step_index(id), steps.size() - 1)].get("emoji", verb))
		if n.get("perPatch", false): verb += " %d/%d" % [G.progression.patch_progress(id), G.progression.plots()]
		var b: Button
		if str(ck.get("why", "")) == "wait":
			b = UI.wait_button(int(ck["wait"]), M.timequiz.show_time_quiz)      # the mortar is drying: wait for the next step
		else:
			b = UI.action_button("", do_unlock.bind(id), ck["ok"], UI.GREEN, verb, _node_word(id))
		if tile: bottom = b
		else: h.add_child(b)
	if steps.size() > 0:
		# done in steps: how far it is (cubes) and what the next step is
		var sr := UI.hbox(6)
		sr.add_child(UI.explain(UI.stock_bar(float(G.progression.step_index(id)), float(steps.size()), Color("7cc04a"), 160), tr("🔨 Steps done so far.")))
		var nx: Dictionary = steps[mini(G.progression.step_index(id), steps.size() - 1)]
		sr.add_child(UI.label("%s %s" % [nx.get("emoji", ""), nx.get("name", "")], 16, UI.INK, true))
		var gv := ""
		for k in nx.get("gives", {}): gv += G.iemoji(k).repeat(clampi(int(round(float(nx["gives"][k]))), 1, 5))
		if gv != "": sr.add_child(UI.label("→ " + gv, 16))
		if int(nx.get("wait", 0)) > 0 and G.progression.step_index(id) < steps.size() - 1: sr.add_child(UI.label(tr("then ⏳%d") % int(nx["wait"]), 15, UI.MUTED))
		v.add_child(sr)
	var c: Dictionary = G.pace.node_cost(id)
	if not c.is_empty():
		if n.get("perPatch", false): v.add_child(UI.label(tr("each patch:"), 13, UI.MUTED))
		v.add_child(costs(c, G.pace.node_cost_base(id)))
	var d := str(n.get("desc", ""))
	if d != "": v.add_child(UI.label(d, 15, UI.MUTED, true))
	if G.pace.flex_on() and not c.is_empty():
		var tip: String = G.pace.flex_tip(id)       # dynamic difficulty: the improvement that makes this quicker
		if tip != "": v.add_child(UI.label(tr("💡 Quicker with: %s %s") % [G.nodes[tip].get("emoji", ""), G.nodes[tip]["name"]], 15, UI.BLUE, true))
	if n.has("effects"):
		var et := effect_text(n["effects"])
		if et != "": v.add_child(UI.label("✨ " + et, 15, UI.GREEN_DARK, true))
	if bottom: tile_button(v, bottom)
	return pc

## Goals as a grid of cards (two per row: they carry more words than a recipe).
func node_grid(ids: Array) -> GridContainer:
	var g := grid(2)
	for id in ids: g.add_child(node_row(id, true, false, true))
	return g

## One word for a goal's button: the step's own word ("Lay", "Raise", "Pull" …), the node's "verb", or by its kind.
func _node_word(id: String) -> String:
	var n: Dictionary = G.nodes[id]
	if n.has("verb"): return str(n["verb"])
	var st: Array = G.progression.steps_of(id)
	if st.size() > 0: return str(st[mini(G.progression.step_index(id), st.size() - 1)].get("name", tr("Go"))).split(" ")[0]
	var first := str(n["name"]).split(" ")[0]
	if first in ["Fill", "Dig", "Clear", "Clean", "Lay", "Plant", "Edge", "Mend", "Fix", "Feed", "Pull", "Root", "Oil", "Sharpen"]: return first
	match str(n["type"]):
		"building", "station", "helper", "patch": return tr("Build")
		"tool": return {"smith": tr("Forge"), "wood": tr("Carve")}.get(G.progression.node_cat(id), tr("Craft"))
		"gear": return tr("Sew") if G.progression.node_cat(id) == "textile" else tr("Craft")
		"land": return tr("Clear")
		"delivery": return tr("Give") if id.begins_with("present_") else tr("Deliver")
		"pet": return tr("Welcome")
		"sidequest": return tr("Help")
		"book": return tr("Buy")
		"knowledge": return tr("Learn")
		"animal": return tr("Buy")
	return tr("Go")

func go_spot(sid: String) -> void:
	M.sheets.open_sheet_for(sid)
	M.mapview.pulse(sid)

func do_unlock(id: String) -> void:
	if G.progression.unlock(id):
		var land: bool = str(G.nodes[id].get("type", "")) == "land"
		M.feedback.play_act("dig" if land else "build", M.map.stand_point(M.mapview.map_sid(Spots.spot_of(G, id))))

# ------------------------------------------------------------------ what a place shows

## A grid for long lists (the store, the market): 3 tiles in a row (4 on wide screens).
func grid(cols := 3) -> GridContainer:
	var g := GridContainer.new()
	g.columns = cols + 1 if M.size.x >= 900 else cols
	g.add_theme_constant_override("h_separation", 8)
	g.add_theme_constant_override("v_separation", 8)
	return g

## One tile of a grid: a picture (or emoji), a name, and room below for amounts and buttons.
func tile(pic: Texture2D, emoji: String, title: String, bg := UI.PAPER) -> VBoxContainer:
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
func tile_button(t: VBoxContainer, btn: Button) -> void:
	var sp := Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	t.add_child(sp)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.custom_minimum_size = Vector2(0, maxf(btn.custom_minimum_size.y, 52))
	t.add_child(btn)
