extends RefCounted
## The fields, orchard and greenhouse: the field sheet, patches, planting, harvesting, weeding, stones.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const PatchGrid = preload("res://game/farm/ui/patch_grid.gd")

var M
var G

const WILD_WORDS := {"weeds": "overgrown with weeds", "rocks": "full of rocks", "stumps": "full of old tree stumps",   # i18n
	"scrub": "overgrown with scrub", "marsh": "a wet marsh"}   # i18n

func _on_patch(a: String, i: int) -> void:
	if not G.patch_usable(a, i):
		# an overgrown patch: show what clears the land — a field for later chapters only shows the mysterious sign
		if a == "field":
			if i / 9 > 0 and not _field_within_reach(i / 9):
				M.ui_sheets._open_sheet("mystery")
				return
			M.field_idx = mini(i / 9, maxi(0, G.field_names().size() - 1))
			M.ui_sheets._open_spot("field")
			if M.sheet.visible and M.sheet_kind != "":     # say which patch and why (kept while this sheet stays open)
				M._patch_note = i
				M.ui_sheets._rebuild_sheet()
				M.ui_sheets._fit_sheet()
		return
	M.ui_sheets._open_sheet("patch:%s:%d" % [a, i])
	if a == "field":
		M.field_idx = i / 9
		M.get_tree().create_timer(0.1).timeout.connect(M.ui_map._reveal.bind(M.map.patch_rect(i / 9, i % 9)))

## Can anything be done for field f (North Field, River Meadow) in this chapter?
func _field_within_reach(f: int) -> bool:
	var slot := "field%d" % (f + 1)
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		if str(n.get("slot", "")) == slot and not G.satisfied(id) and M.ui_map._in_chapter(id) and G.missing_reqs(id).is_empty(): return true
	return G.S["patches"].size() > f * 9

func _sheet_patch(a: String, i: int) -> void:
	var p: Dictionary = G.area(a)[i]
	M.sheet_title.text = (M.tr("🟫 Patch %d") % (i % 9 + 1)) if a == "field" else ((M.tr("🌳 Tree spot %d") % (i + 1)) if a == "orchard" else (M.tr("🪴 Bed %d") % (i + 1)))
	if p["crop"] == "":
		M.content.add_child(UI.header(Art.tex("deco", "soil_heap"), "🟫", 80))
		if float(p.get("quality", 1.0)) < 0.99:
			M.content.add_child(UI.label(M.tr("🚧 Not fully cleared yet: it gives %d%% of a full harvest. Finish clearing it below, under “The whole field”.") % int(round(float(p["quality"]) * 100)), 16, UI.MUTED, true))
		var cap: int = G.plants_per_patch(a)
		M.content.add_child(UI.label("🌱".repeat(cap) + M.tr("  fits here"), 17, UI.MUTED, true))
		var cs: Array = G.crops_for(a)
		if cs.is_empty(): M.content.add_child(UI.label(M.tr("No seeds you can plant here yet. Learn crop cards in the 📦 library."), 17, UI.MUTED, true))
		# every crop that can go here is a tile: picture, plants and growing time, water and energy, seeds, Plant at the bottom
		var grid = M.ui_place._grid()
		for cid in cs:
			var n: Dictionary = G.nodes[cid]
			var plan: Dictionary = G.plant_plan(a, cid)
			var plants := int(plan["plants"])
			var t = M.ui_place._tile(Art.tex("crops", cid), str(n.get("emoji", "🌱")), str(n["name"]))
			t.add_child(UI.label("%s   ⏳%d" % ["🌱".repeat(maxi(plants, 0)) if plants > 0 else "—", int(n.get("grow", 0))], 16, UI.INK, true))
			# short of water: show the water a full patch needs, so the missing cubes show up hollow
			var short: bool = plan["reasons"].has("water")
			var c := {"water": float(plan["water_full" if short else "water"]), "energy": float(plan["energy"])}
			var base := {"water": float(plan["water_full_base" if short else "water_base"]), "energy": float(plan["energy_base"])}
			t.add_child(M.ui_widgets._costs(c, base))
			t.add_child(UI.label("🌰 %d" % G.down(G.seed_have(cid)), 16, UI.INK if G.seed_have(cid) >= 1.0 else UI.RED))
			if plants < int(plan["max"]) and plan["reasons"].size() > 0:
				var why := []
				for rk in plan["reasons"]: why.append(G.iemoji(rk) if rk != "seeds" else "🌰")
				t.add_child(UI.label("fewer: " + " ".join(why), 14, UI.MUTED))
			if G.seed_have(cid) < 1.0 and not n.has("seedItem"):
				t.add_child(UI.soft_button(M.tr("🛒 Buy seeds"), M.ui_widgets._go_spot.bind("market"), true, 15))
			M.ui_place._tile_button(t, UI.action_button("plant", _do_plant.bind(a, i, cid), plants >= 1))
			grid.add_child(t.get_meta("panel"))
		if grid.get_child_count() > 0: M.content.add_child(grid)
	else:
		var n2: Dictionary = G.nodes[p["crop"]]
		var ct2: Texture2D = Art.tex("crops", str(p["crop"]))
		var young: bool = float(p["growth"]) < G.grow_target(p) * 0.5 and not p["ready"]
		M.content.add_child(UI.header(ct2 if not young else Art.tex("deco", "sprout"), "🌱" if young else str(n2.get("emoji", "")), 96,
			Color(1.1, 0.95, 0.55) if p["ready"] else Color.WHITE, p["ready"]))
		var shown := clampi(G.shown_plants(float(p["plants"])), 1, 9)
		var row2 := UI.hbox(8)
		row2.add_child(UI.label(("🌱" if young else str(n2.get("emoji", ""))).repeat(shown), 24))
		if not p["ready"]:
			row2.add_child(UI.explain(UI.stock_bar(float(p["growth"]), ceilf(G.grow_target(p)), Color("8cc63f"), 160), M.tr("🌱 Growing: a bit more with every Time Quiz question. Full = ready to harvest.")))
			row2.add_child(UI.wait_button(M.ui_widgets._grow_left(a, p), M.ui_quiz._show_time_quiz))
		M.content.add_child(row2)
		if n2.has("regrow") and G.crops_for(a).size() > 1:
			# a tree stays for good, so one can be cut down to plant another kind
			var cr2 := UI.hbox(8)
			cr2.add_child(UI.label(M.tr("Want another tree here?"), 15, UI.MUTED, true))
			cr2.add_child(M.ui_widgets._costs({"energy": G.ecost("wood", 3.0)}, {"energy": 3.0}))
			cr2.add_child(UI.action_button("wood", M.ui_stations._do_cut_tree.bind(a, i), float(G.S["energy"]) + 0.001 >= G.ecost("wood", 3.0), UI.SOIL, "🪓", M.tr("Cut down")))
			M.content.add_child(cr2)
		if float(p.get("soil", 1.0)) < 0.99: M.content.add_child(UI.label(M.tr("😴 Tired soil: the same crop as last time grows slower. Swap crops next time (beans and clover rest the soil)."), 15, UI.MUTED, true))
		elif float(p.get("soil", 1.0)) > 1.01: M.content.add_child(UI.label(M.tr("💚 Rested soil after beans or clover: grows faster."), 15, UI.GREEN_DARK, true))
		if p["ready"]:
			var ys := ""
			for k in n2.get("yields", {}): ys += G.iemoji(k).repeat(clampi(G.down(float(n2["yields"][k]) * float(p["plants"])), 1, 12))
			var hr := UI.hbox(8)
			var hb := UI.button(M.tr("🧺 Harvest   ") + ys, _do_harvest.bind(a, i), true, UI.GREEN, 20)
			hb.custom_minimum_size = Vector2(0, 56)
			hb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hr.add_child(hb)
			var e1: float = G.ecost("harvest", 1.0) * G.m("energy:field")
			hr.add_child(M.ui_widgets._costs({"energy": e1}, {"energy": 1.0}))
			M.content.add_child(hr)
	if a == "field":
		# weeds and stones on the patch: a tile each, with how many there are and the button to clear them
		var wg = M.ui_place._grid()
		if float(p["weeds"]) >= 0.5:
			var wt = M.ui_place._tile(Art.tex("deco", "weeds"), "🌿", M.tr("Weeds"))
			wt.add_child(UI.explain(UI.stock_bar(float(p["weeds"]), maxf(6.0, ceilf(float(p["weeds"]))), UI.item_color("fiber"), 150), M.tr("🌿 Weeds here: they make the harvest smaller. Pull them!")))
			var pull := minf(3.0, float(p["weeds"]))
			wt.add_child(M.ui_widgets._costs({"energy": G.ecost("weed", pull) * G.m("energy:field")}, {"energy": pull}))
			M.ui_place._tile_button(wt, UI.action_button("weed", _do_weed.bind(i), true, UI.GREEN_DARK, "💪", M.tr("Pull")))
			wg.add_child(wt.get_meta("panel"))
		if float(p["stones"]) >= 0.5:
			var st = M.ui_place._tile(Art.tex("deco", "stone"), "🪨", M.tr("Stones"))
			st.add_child(UI.explain(UI.stock_bar(float(p["stones"]), maxf(6.0, ceilf(float(p["stones"]))), UI.item_color("stone"), 150), M.tr("🪨 Stones in the soil: they make the harvest smaller. Pick them out.")))
			M.ui_place._tile_button(st, UI.action_button("field", _do_stones.bind(i), true, UI.SOIL, "🤏", M.tr("Pick")))
			wg.add_child(st.get_meta("panel"))
		if wg.get_child_count() > 0: M.content.add_child(wg)
		M.field_idx = i / 9
		_part_whole_field()

## "The whole field" (J2): at the bottom of every patch's sheet (and of the field's own sheet): harvest, weed and pick stones
## on the whole field at once, then what can be built or improved for the field, then the pests.
func _part_whole_field() -> void:
	var hd := UI.label(M.tr("🟫 The whole field"), 20, UI.INK, true)
	M.content.add_child(hd)
	var qa := HFlowContainer.new()
	qa.add_theme_constant_override("h_separation", 8)
	qa.add_theme_constant_override("v_separation", 8)
	var nr := _ready_count("field")
	qa.add_child(UI.button(M.tr("🧺 Harvest all") + ("  ×%d" % nr if nr > 0 else ""), _harvest_whole_field, nr > 0, UI.GREEN, 17))
	qa.add_child(UI.soft_button(M.tr("🌿 Pick all weeds"), _weed_whole_field, _field_has("weeds"), 17))
	qa.add_child(UI.soft_button(M.tr("🪨 Pick all stones"), _stones_whole_field, _field_has("stones"), 17))
	M.content.add_child(qa)
	var lists: Array = M.ui_place._goal_lists("field")
	M.ui_place._part_main_goals("field", lists[0])
	M.ui_place._part_more_goals("field", lists[0], lists[1], lists[2])
	M.ui_place._part_polish_here("field")
	_part_field()

## Is there anything of this kind ("weeds" or "stones") to clear on the field the player is on?
func _field_has(k: String) -> bool:
	for i in range(M.field_idx * 9, M.field_idx * 9 + 9):
		if i < G.S["patches"].size() and G.patch_usable("field", i) and float(G.S["patches"][i][k]) >= 0.5: return true
	return false

func _harvest_whole_field() -> void:
	M.ui_acts._act("harvest", M.map.patch_point(M.field_idx, 4))
	_harvest_all("field")

func _weed_whole_field() -> void:
	M.ui_acts._act("weed", M.map.patch_point(M.field_idx, 4))
	G.weed_field(M.field_idx)

func _stones_whole_field() -> void:
	M.ui_acts._act("dig", M.map.patch_point(M.field_idx, 4))
	_pick_all()

func _do_plant(a: String, i: int, cid: String) -> void:
	var plan: Dictionary = G.plant_plan(a, cid)
	if int(plan["plants"]) < 1 and plan["reasons"].has("water"):
		_show_no_water()
		return
	if G.plant(a, i, cid):
		M.ui_sounds._sfx("plant")
		M.ui_acts._act("plant", M.ui_acts._patch_place(a, i))
		M.ui_sheets._close_sheet()

## No water left: a drop with a red line through it, and the bucket to fetch more from the pond.
func _show_no_water() -> void:
	if M.modal.visible: return
	var box = M.ui_modal._open_modal("💧")
	box.add_child(UI.NoWater.new())
	var l := UI.label(M.tr("No water left!"), 24, UI.RED, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(l)
	var fr := UI.hbox(8)
	var fb := UI.button("🪣  %s" % "💧".repeat(clampi(int(round(G.fetch_amount())), 1, 8)), _fetch_and_close, true, UI.BLUE, 24)
	fb.custom_minimum_size = Vector2(0, 60)
	fb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fr.add_child(fb)
	fr.add_child(M.ui_widgets._costs({"energy": G.fetch_cost()}, {"energy": float(G.meta.get("water", {}).get("fetchEnergy", 1.0))}))
	box.add_child(fr)
	box.add_child(UI.soft_button(M.tr("⬅️ Back to the farm"), M.ui_modal._close_modal, true, 17))

func _fetch_and_close() -> void:
	if G.fetch_water() and float(G.S["water"]) + 0.5 >= G.water_cap(): M.ui_modal._close_modal()

func _do_harvest(a: String, i: int) -> void:
	if G.harvest(a, i): M.ui_sheets._close_sheet()

func _do_weed(i: int) -> void:
	G.weed(i)

func _do_stones(i: int) -> void:
	G.pick_stones(i)

func _pick_all() -> void:
	for i in range(M.field_idx * 9, M.field_idx * 9 + 9):
		if i < G.S["patches"].size() and G.patch_usable("field", i) and float(G.S["patches"][i]["stones"]) >= 0.5:
			if not G.pick_stones(i): break

## Harvest everything that is ready in an area (all fields, the orchard or the greenhouse).
func _harvest_all(a := "field") -> void:
	var arr: Array = G.area(a)
	for i in range(arr.size()):
		if arr[i]["ready"]:
			if not G.harvest(a, i): break

func _ready_count(a: String) -> int:
	var n := 0
	for p in G.area(a):
		if p["crop"] != "" and p["ready"]: n += 1
	return n

## Which overgrown patch was tapped, why it can't be used yet and what clears it.
func _part_patch_note(i: int) -> void:
	if G.patch_usable("field", i): return
	var w: Array = G.patch_wild(i / 9, i)
	var pc := UI.card(Color("fbf1e0"))
	var v := UI.vbox(2)
	pc.add_child(v)
	v.add_child(UI.label(M.tr("🟫 Patch %d is not ready yet: it is still %s.") % [i % 9 + 1, M.tr(str(WILD_WORDS.get(w[0], "overgrown")))], 18, UI.INK, true))
	var job: String = w[2]
	if job != "":
		var miss: Array = G.missing_reqs(job)
		if miss.is_empty(): v.add_child(UI.label(M.tr("%s %s below clears it.") % [G.nodes[job]["emoji"], G.nodes[job]["name"]], 16, UI.MUTED, true))
		else: v.add_child(UI.label(M.tr("To clear it you need first: %s.") % ", ".join(miss), 16, UI.MUTED, true))
	M.content.add_child(pc)

func _part_field() -> void:
	var pc := UI.card(Color("f3f7ea"))
	var pv := UI.vbox(4)
	pc.add_child(pv)
	var r1 := UI.hbox(8)
	var n_p: int = G.down(float(G.S["pests"]) + 0.5)
	r1.add_child(UI.label("🐦" if n_p > 0 else "🐦 0", 22))
	if n_p > 0: r1.add_child(UI.explain(UI.stock_bar(float(G.S["pests"]), maxf(4.0, ceilf(float(G.S["pests"]))), Color("8a6f5f"), 200), M.tr("🐦 Pests on the farm: they nibble what grows.")))
	r1.add_child(UI.label(M.tr("eat %d%% 🌾 each question") % int(round(G.pest_eat_share() * 100.0)), 17, UI.RED if G.pest_eat_share() >= 0.05 else UI.MUTED))
	pv.add_child(r1)
	var r2 := UI.hbox(8)
	r2.add_child(UI.label("🧍", 22))
	if G.pest_scare() > 0.0: r2.add_child(UI.explain(UI.stock_bar(G.pest_scare(), G.pest_scare(), Color("c98a12"), 160), M.tr("🧍 Pests chased away every question.")))
	else: r2.add_child(UI.label("—", 18, UI.MUTED))
	if G.pest_block() > 0.0:
		r2.add_child(UI.label("🚧 %d%%" % int(round(G.pest_block() * 100)), 17))
	pv.add_child(r2)
	M.content.add_child(pc)

func _part_area(a: String) -> void:
	var arr: Array = G.area(a)
	if arr.is_empty(): return
	var fv = PatchGrid.new()
	fv.area_name = a
	fv.custom_minimum_size = Vector2(0, 110 * int(ceil(arr.size() / 3.0)))
	M.content.add_child(fv)
	fv.patch_pressed.connect(_on_patch)
	M.content.add_child(UI.button(M.tr("🧺 Harvest all"), _harvest_all.bind(a), _ready_count(a) > 0, UI.GREEN, 18))
