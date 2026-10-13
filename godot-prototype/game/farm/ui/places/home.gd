extends RefCounted
class_name FarmUiHome
## The house sheet (bed, what you wear and sleep on), the pet corner and the little jobs.

const UI = preload("res://kits/ui/ui.gd")
const Spots = preload("res://game/farm/spots.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

const GEAR_SLOTS := [["feet", "👣"], ["hands", "🧤"], ["back", "🎒"], ["bottle", "🫗"], ["head", "👒"], ["apron", "🥼"], ["pillow", "🛌"], ["bed", "🛏️"]]

# ------------------------------------------------------------------ what a place shows

func part_home() -> void:
	var rc := UI.card(Color("e8f0f7"))
	var rv := UI.vbox(4)
	rc.add_child(rv)
	var eh := UI.hbox(6)
	eh.add_child(UI.label("⚡", 22))
	eh.add_child(UI.explain(UI.stock_bar(float(G.S["energy"]), G.needs.energy_max(), UI.item_color("energy")), tr("⚡ Your energy: work uses it, rest fills it.")))
	rv.add_child(eh)
	var rb := UI.button(tr("😴 Rest"), M.rest.go_rest, true, UI.BLUE, 19)
	rb.custom_minimum_size = Vector2(0, 50)
	rv.add_child(rb)
	M.content.add_child(rc)
	var foods := []
	for k in G.S["inv"]:
		if G.items.has(k) and G.items[k].has("buff") and G.inventory.count(k) >= 1.0: foods.append(k)
	if foods.size() > 0:
		M.widgets.section(tr("😋 Eat something"), tr("A good meal makes work cheaper for the next few questions."))
		for k in foods:
			var it: Dictionary = G.items[k]
			var row := UI.hbox(6)
			row.add_child(UI.label("%s %s × %d" % [it.get("emoji", ""), it["name"], G.down(G.inventory.count(k))], 17, UI.INK, true))
			row.add_child(UI.soft_button(tr("😋 Eat (−%d%% ⚡ for %d)") % [int(round((1.0 - float(it["buff"]["energy"])) * 100)), int(it["buff"]["questions"])], G.trade.eat.bind(k), true, 16))
			M.content.add_child(row)
	var worn := []
	for s in GEAR_SLOTS:
		var cur := ""
		for id in Spots.nodes_at(G, "living"):
			if str(G.nodes[id].get("slot", "")) == "gear:" + s[0] and G.nodes[id]["type"] in ["gear", "helper"] and G.done(id): cur = id
		worn.append("%s %s" % [s[1], G.nodes[cur]["name"] if cur != "" else "—"])
	M.widgets.section(tr("👕 What you wear and sleep on"))
	M.content.add_child(UI.label("   ".join(worn), 15, UI.INK, true))

func part_pets() -> void:
	var any := false
	for pid in G.pet_ids:
		if not G.done(pid): continue
		any = true
		var n: Dictionary = G.nodes[pid]
		var row := UI.hbox(6)
		row.add_child(UI.label("%s %s — %s" % [n.get("emoji", ""), G.S["pet_names"].get(pid, n.get("defaultName", "")), M.widgets.effect_text(n.get("effects", {}))], 17, UI.INK, true))
		row.add_child(UI.soft_button(tr("✏️ Name"), M.welcome.show_name.bind(pid, str(G.S["pet_names"].get(pid, n.get("defaultName", "")))), true, 15))
		M.content.add_child(row)
		_job_board(pid)
	if not any: M.content.add_child(UI.label(tr("Your first pet, a bunny, comes home at the end of chapter 1."), 16, UI.MUTED, true))

## A pet's job board (TODO S2): level 2 lets the child choose what the pet does every question; what it did last time, or why it could not.
func _job_board(pid: String) -> void:
	var jobs: Array = G.pets.jobs_of(pid)
	if jobs.is_empty(): return
	if G.pets.level(pid) < 2:
		M.content.add_child(UI.label(tr("   Level 2: a job of its own comes when the next pet comes home."), 14, UI.MUTED, true))
		return
	var cur := G.pets.job_id(pid)
	var bx := HFlowContainer.new()
	bx.add_theme_constant_override("h_separation", 6)
	for j in jobs:
		var on: bool = j["id"] == cur
		bx.add_child(UI.button("%s%s %s" % ["✔ " if on else "", j["emoji"], tr(str(j["name"]))], G.pets.choose.bind(pid, j["id"]), not on, UI.GREEN if on else UI.AMBER, 16))
	M.content.add_child(bx)
	if G.pets.level(pid) >= 3: _when_row(pid, 0, tr("WHEN"))
	if G.pets.level(pid) >= 4:
		var cur2: String = G.pets.second_job(pid)
		var bx2 := HFlowContainer.new()
		bx2.add_theme_constant_override("h_separation", 6)
		bx2.add_child(UI.label(tr("OTHERWISE"), 15, UI.MUTED))
		for j in jobs:
			var on2: bool = j["id"] == cur2
			bx2.add_child(UI.button("%s%s %s" % ["✔ " if on2 else "", j["emoji"], tr(str(j["name"]))], G.pets.set_second_job.bind(pid, j["id"]), not on2, UI.GREEN if on2 else UI.AMBER, 15))
		M.content.add_child(bx2)
		_when_row(pid, 1, tr("WHEN"))
	var last := G.pets.last(pid)
	if not last.is_empty():
		var jb: Dictionary = G.pets.job(pid, str(last.get("job", "")))
		var txt := tr("   Last question: %s") % tr(str(jb.get("name", "")))
		if not last["ok"]:
			match str(last.get("why", "")):
				"full": txt = tr("   Last question: 📦 the store is full")
				"wait": txt = tr("   Last question: ⏸️ waiting for its WHEN")
				_: txt = tr("   Last question: 💤 nothing to do")
		M.content.add_child(UI.label(txt, 14, UI.MUTED, true))

## A WHEN card (level 3 and 4): tap the card to change it (the last choice is always), − and + set the number.
func _when_row(pid: String, rule: int, label: String) -> void:
	var w: Dictionary = G.pets.when_of(pid, rule)
	var cards: Array = [""] + G.pets.allowed_whens(pid)
	var cur := str(w.get("card", ""))
	var nxt: String = cards[(cards.find(cur) + 1) % cards.size()]
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 6)
	row.add_child(UI.label(label, 15, UI.MUTED))
	var c: Dictionary = G.pets.whens().get(cur, {})
	var txt := tr("always") if cur == "" else "%s %s %s %d" % [c["emoji"], tr(str(c["name"])), "≥" if c["op"] == ">=" else "<", int(w["n"])]
	row.add_child(UI.button(txt, G.pets.set_when.bind(pid, rule, nxt), true, UI.GREEN, 15))
	if cur != "":
		var step := float(c.get("step", 1))
		row.add_child(UI.soft_button("−", G.pets.set_when.bind(pid, rule, cur, float(w["n"]) - step), float(w["n"]) - step >= float(c["min"]) - 0.001, 18))
		row.add_child(UI.soft_button("+", G.pets.set_when.bind(pid, rule, cur, float(w["n"]) + step), float(w["n"]) + step <= float(c["max"]) + 0.001, 18))
	M.content.add_child(row)

func part_jobs() -> void:
	M.widgets.section(tr("📋 Little jobs"), tr("A few coins and a bit of luck for each."))
	for j in G.S["jobs"]:
		var h := UI.hbox(6)
		h.add_child(UI.label("• " + str(j["text"]), 17, UI.INK, true))
		h.add_child(UI.label("%d/%d" % [G.down(float(j["got"])), int(j["n"])], 17, UI.MUTED))
		M.content.add_child(h)
