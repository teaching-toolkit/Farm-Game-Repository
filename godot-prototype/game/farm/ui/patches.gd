extends RefCounted
class_name FarmUiPatches
## Patches (field, orchard, greenhouse): tapping a patch, its sheet, planting, harvesting, weeding, picking stones, and the whole-field section.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")
const FieldView = preload("res://game/farm/ui/field_view.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

const WILD_WORDS := {"weeds": "overgrown with weeds", "rocks": "full of rocks", "stumps": "full of old tree stumps",   # i18n
	"scrub": "overgrown with scrub", "marsh": "a wet marsh"}   # i18n

# ------------------------------------------------------------------ patches (field, orchard, greenhouse)

func on_patch(a: String, i: int) -> void:
	G.story.tapped("patch:%s" % (a if G.fields.patch_usable(a, i) else str(G.fields.patch_wild(i / 9, i % 9)[0]) if a == "field" else a))   # the story: a patch to be cleared, by what is in the way
	if not G.fields.patch_usable(a, i):
		# an overgrown patch: show what clears the land — a field for later chapters only shows the mysterious sign
		if a == "field":
			if i / 9 > 0 and not _field_within_reach(i / 9):
				M.sheets.open_sheet("mystery")
				return
			M.field_idx = mini(i / 9, maxi(0, G.fields.field_names().size() - 1))
			M.sheets.open_spot("field")
			if M.sheet.visible and M.sheet_kind != "":     # say which patch and why (kept while this sheet stays open)
				M.patch_note = i
				M.sheets.rebuild_sheet()
				M.sheets.fit_sheet()
		return
	M.sheets.open_sheet("patch:%s:%d" % [a, i])
	if a == "field":
		M.field_idx = i / 9
		M.get_tree().create_timer(0.1).timeout.connect(M.mapview.reveal.bind(M.map.patch_rect(i / 9, i % 9)))

## Can anything be done for field f (North Field, River Meadow) in this chapter?
func _field_within_reach(f: int) -> bool:
	var slot := "field%d" % (f + 1)
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		if str(n.get("slot", "")) == slot and not G.satisfied(id) and M.mapview.in_chapter(id) and G.progression.missing_reqs(id).is_empty(): return true
	return G.S["patches"].size() > f * 9

func sheet_patch(a: String, i: int) -> void:
	var p: Dictionary = G.fields.area(a)[i]
	M.sheet_title.text = (tr("🟫 Patch %d") % (i % 9 + 1)) if a == "field" else ((tr("🌳 Tree spot %d") % (i + 1)) if a == "orchard" else (tr("🪴 Bed %d") % (i + 1)))
	if p["crop"] == "":
		M.content.add_child(UI.header(Art.tex("deco", "soil_heap"), "🟫", 80))
		if float(p.get("quality", 1.0)) < 0.99:
			M.content.add_child(UI.label(tr("🚧 Not fully cleared yet: it gives %d%% of a full harvest. Finish clearing it further down.") % int(round(float(p["quality"]) * 100)), 16, UI.MUTED, true))
		var cap: int = G.fields.plants_per_patch(a)
		if a == "field" and G.fields.patch_snow(i):          # winter: the snow has to go before anything is sown (TODO N6)
			M.content.add_child(UI.label(tr("❄️ Snow covers this patch. Clear it before you sow."), 18, UI.INK, true))
			M.content.add_child(UI.action_button("field", _do_snow.bind(i), G.actions.check("clear_snow", G.actions.farmer, {"i": i})["ok"], UI.SOIL, "🧹", tr("Clear the snow")))
			return
		M.content.add_child(UI.label("🌱".repeat(cap) + tr("  fits here"), 17, UI.MUTED, true))
		var cs: Array = G.fields.crops_for(a)
		if cs.is_empty(): M.content.add_child(UI.label(tr("No seeds you can plant here yet. Learn crop cards in the 📦 library."), 17, UI.MUTED, true))
		# every crop that can go here is a tile: picture, plants and growing time, water and energy, seeds, Plant at the bottom
		var grid := M.widgets.grid()
		for cid in cs:
			var n: Dictionary = G.nodes[cid]
			var plan: Dictionary = G.fields.plant_plan(a, cid)
			var plants := int(plan["plants"])
			var t := M.widgets.tile(Art.tex("crops", cid), str(n.get("emoji", "🌱")), str(n["name"]))
			t.add_child(UI.label("%s   ⏳%d" % ["🌱".repeat(maxi(plants, 0)) if plants > 0 else "—", int(n.get("grow", 0))], 16, UI.INK, true))
			# short of water: show the water a full patch needs, so the missing cubes show up hollow
			var short: bool = plan["reasons"].has("water")
			var q: Dictionary = G.actions.check("plant", G.actions.farmer, {"a": a, "i": i, "cid": cid})
			var c := {"water": float(plan["water_full" if short else "water"]), "energy": float(q["cost"]["energy"])}
			var base := {"water": float(plan["water_full_base" if short else "water_base"]), "energy": float(q["base"]["energy"])}
			t.add_child(M.widgets.costs(c, base))
			t.add_child(UI.label("🌰 %d" % G.down(G.fields.seed_have(cid)), 16, UI.INK if G.fields.seed_have(cid) >= 1.0 else UI.RED))
			if plan["reasons"].has("cold"): t.add_child(UI.label(tr("❄️ Too cold to sow. Try the greenhouse.") if G.done("greenhouse") else tr("❄️ Too cold to sow"), 14, UI.MUTED, true))
			elif plan["reasons"].has("season"): t.add_child(UI.label(tr("🍂 Sow in autumn or winter"), 14, UI.MUTED, true))
			elif plants < int(plan["max"]) and plan["reasons"].size() > 0:
				var why := []
				for rk in plan["reasons"]: why.append("🌰" if rk == "seeds" else ("🍂" if rk == "season" else G.iemoji(rk)))
				t.add_child(UI.label("fewer: " + " ".join(why), 14, UI.MUTED))
			if G.fields.seed_have(cid) < 1.0 and not n.has("seedItem"):
				t.add_child(UI.soft_button(tr("🛒 Buy seeds"), M.widgets.go_spot.bind("market"), true, 15))
			M.widgets.tile_button(t, UI.action_button("plant", _do_plant.bind(a, i, cid), plants >= 1))
			grid.add_child(t.get_meta("panel"))
		if grid.get_child_count() > 0: M.content.add_child(grid)
	else:
		var n2: Dictionary = G.nodes[p["crop"]]
		var ct2: Texture2D = Art.tex("crops", str(p["crop"]))
		var young: bool = float(p["growth"]) < G.fields.grow_target(p) * 0.5 and not p["ready"]
		M.content.add_child(UI.header(ct2 if not young else Art.tex("deco", "sprout"), "🌱" if young else str(n2.get("emoji", "")), 96,
			Color(1.1, 0.95, 0.55) if p["ready"] else Color.WHITE, p["ready"]))
		var shown := clampi(G.fields.shown_plants(float(p["plants"])), 1, 9)
		var row2 := UI.hbox(8)
		row2.add_child(UI.label(("🌱" if young else str(n2.get("emoji", ""))).repeat(shown), 24))
		if not p["ready"]:
			row2.add_child(UI.explain(UI.stock_bar(float(p["growth"]), ceilf(G.fields.grow_target(p)), Color("8cc63f"), 160), tr("🌱 Growing: a bit more with every Time Quiz question. Full = ready to harvest.")))
			row2.add_child(UI.wait_button(M.widgets.grow_left(a, p), M.timequiz.show_time_quiz))
		M.content.add_child(row2)
		if n2.has("regrow") and G.fields.crops_for(a).size() > 1:
			# a tree stays for good, so one can be cut down to plant another kind
			var cr2 := UI.hbox(8)
			cr2.add_child(UI.label(tr("Want another tree here?"), 15, UI.MUTED, true))
			var ct: Dictionary = G.actions.check("cut_tree", G.actions.farmer, {"a": a, "i": i})
			cr2.add_child(M.widgets.costs(ct["cost"], ct["base"]))
			cr2.add_child(UI.action_button("wood", M.stations.do_cut_tree.bind(a, i), ct["ok"], UI.SOIL, "🪓", tr("Cut down")))
			M.content.add_child(cr2)
		if float(p.get("soil", 1.0)) < 0.99: M.content.add_child(UI.label(tr("😴 Tired soil: the same crop as last time grows slower. Swap crops next time (beans and clover rest the soil)."), 15, UI.MUTED, true))
		elif float(p.get("soil", 1.0)) > 1.01: M.content.add_child(UI.label(tr("💚 Rested soil after beans or clover: grows faster."), 15, UI.GREEN_DARK, true))
		if p["ready"]:
			var ys := ""
			for k in n2.get("yields", {}): ys += G.iemoji(k).repeat(clampi(G.down(float(n2["yields"][k]) * float(p["plants"])), 1, 12))
			M.content.add_child(UI.label(tr("Expect: %s") % G.quality.expect_text(G.quality.crop_expect(p)), 15, UI.MUTED, true))
			var hr := UI.hbox(8)
			var hb := UI.button(tr("🧺 Harvest   ") + ys, _do_harvest.bind(a, i), true, UI.GREEN, 20)
			hb.custom_minimum_size = Vector2(0, 56)
			hb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hr.add_child(hb)
			var hq: Dictionary = G.actions.check("harvest", G.actions.farmer, {"a": a, "i": i})
			hr.add_child(M.widgets.costs(hq["cost"], hq["base"]))
			M.content.add_child(hr)
	if a == "field":
		# weeds and stones on the patch: a tile each, with how many there are and the button to clear them
		var wg := M.widgets.grid()
		if float(p["weeds"]) >= 0.5:
			var wt := M.widgets.tile(Art.tex("deco", "weeds"), "🌿", tr("Weeds"))
			wt.add_child(UI.explain(UI.stock_bar(float(p["weeds"]), maxf(6.0, ceilf(float(p["weeds"]))), UI.item_color("fiber"), 150), tr("🌿 Weeds here: they make the harvest smaller. Pull them!")))
			var wq: Dictionary = G.actions.check("weed", G.actions.farmer, {"i": i})
			wt.add_child(M.widgets.costs(wq["cost"], wq["base"]))
			M.widgets.tile_button(wt, UI.action_button("weed", _do_weed.bind(i), true, UI.GREEN_DARK, "💪", tr("Pull")))
			wg.add_child(wt.get_meta("panel"))
		if float(p["stones"]) >= 0.5:
			var st := M.widgets.tile(Art.tex("deco", "stone"), "🪨", tr("Stones"))
			st.add_child(UI.explain(UI.stock_bar(float(p["stones"]), maxf(6.0, ceilf(float(p["stones"]))), UI.item_color("stone"), 150), tr("🪨 Stones in the soil: they make the harvest smaller. Pick them out.")))
			M.widgets.tile_button(st, UI.action_button("field", _do_stones.bind(i), true, UI.SOIL, "🤏", tr("Pick")))
			wg.add_child(st.get_meta("panel"))
		if wg.get_child_count() > 0: M.content.add_child(wg)
		M.placesheet.part_field_below()

func _do_plant(a: String, i: int, cid: String) -> void:
	var plan: Dictionary = G.fields.plant_plan(a, cid)
	if int(plan["plants"]) < 1 and plan["reasons"].has("water"):
		show_no_water()
		return
	if G.actions.perform("plant", G.actions.farmer, {"a": a, "i": i, "cid": cid})["done"]:
		M.feedback.sfx("plant")
		M.feedback.play_act("plant", M.feedback.patch_place(a, i))
		M.sheets.close_sheet()

## No water left: a drop with a red line through it, and the bucket to fetch more from the pond.
func show_no_water() -> void:
	if M.modal.visible: return
	var box := M.modals.open_modal("💧")
	box.add_child(UI.NoWater.new())
	var l := UI.label(tr("No water left!"), 24, UI.RED, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(l)
	var fr := UI.hbox(8)
	var wq: Dictionary = G.actions.check("fetch_water", G.actions.farmer)
	var fb := UI.button("🪣  %s" % "💧".repeat(clampi(int(round(G.fields.fetch_amount())), 1, 8)), _fetch_and_close, true, UI.BLUE, 24)
	fb.custom_minimum_size = Vector2(0, 60)
	fb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fr.add_child(fb)
	fr.add_child(M.widgets.costs(wq["cost"], wq["base"]))
	box.add_child(fr)
	box.add_child(UI.soft_button(tr("⬅️ Back to the farm"), M.modals.close_modal, true, 17))

func _fetch_and_close() -> void:
	if G.actions.perform("fetch_water", G.actions.farmer)["done"] and float(G.S["water"]) + 0.5 >= G.needs.water_cap(): M.modals.close_modal()

func _do_harvest(a: String, i: int) -> void:
	if G.actions.perform("harvest", G.actions.farmer, {"a": a, "i": i})["done"]: M.sheets.close_sheet()

func _do_weed(i: int) -> void:
	G.actions.perform("weed", G.actions.farmer, {"i": i})

func _do_stones(i: int) -> void:
	G.actions.perform("pick_stones", G.actions.farmer, {"i": i})

func _do_snow(i: int) -> void:
	G.actions.perform("clear_snow", G.actions.farmer, {"i": i})

## What there is to do on the patches of field f: how many are ready, weedy and stony (overgrown patches do not count).
func _field_jobs(f: int) -> Dictionary:
	var jobs := {"ready": 0, "weeds": 0, "stones": 0, "snow": 0}
	for i in range(f * 9, mini(f * 9 + 9, G.S["patches"].size())):
		if not G.fields.patch_usable("field", i): continue
		var p: Dictionary = G.S["patches"][i]
		if p["crop"] != "" and p["ready"]: jobs["ready"] += 1
		if float(p["weeds"]) >= 0.5: jobs["weeds"] += 1
		if float(p["stones"]) >= 0.5: jobs["stones"] += 1
		if p.get("snow", false): jobs["snow"] += 1
	return jobs

## Harvest, weed or pick the stones of every patch of field f. The farmer walks from patch to patch (each patch plays its own act).
func harvest_field(f: int) -> void:
	var jobs := []
	for i in range(f * 9, mini(f * 9 + 9, G.S["patches"].size())):
		if G.fields.patch_usable("field", i) and G.S["patches"][i]["ready"] and G.S["patches"][i]["crop"] != "": jobs.append({"a": "field", "i": i})
	G.actions.perform_batch("harvest", G.actions.farmer, jobs)

func weed_field(f: int) -> void:
	var jobs: Array = G.fields.field_jobs(f, "weed")
	if jobs.is_empty(): G.say(tr("🌿 This field is already tidy.")); return
	G.actions.perform_batch("weed", G.actions.farmer, jobs)

func snow_field(f: int) -> void:
	G.actions.perform_batch("clear_snow", G.actions.farmer, G.fields.field_jobs(f, "clear_snow"))

func stones_field(f: int) -> void:
	G.actions.perform_batch("pick_stones", G.actions.farmer, G.fields.field_jobs(f, "pick_stones"))

## Harvest everything that is ready in an area (all fields, the orchard or the greenhouse).
func harvest_all(a := "field") -> void:
	var arr: Array = G.fields.area(a)
	var jobs := []
	for i in range(arr.size()):
		if arr[i]["ready"] and arr[i]["crop"] != "": jobs.append({"a": a, "i": i})
	G.actions.perform_batch("harvest", G.actions.farmer, jobs)

func ready_count(a: String) -> int:
	var n := 0
	for p in G.fields.area(a):
		if p["crop"] != "" and p["ready"]: n += 1
	return n

# ------------------------------------------------------------------ what a place shows

## Which overgrown patch was tapped, why it can't be used yet and what clears it.
func part_patch_note(i: int) -> void:
	if G.fields.patch_usable("field", i): return
	var w: Array = G.fields.patch_wild(i / 9, i)
	var pc := UI.card(Color("fbf1e0"))
	var v := UI.vbox(2)
	pc.add_child(v)
	v.add_child(UI.label(tr("🟫 Patch %d is not ready yet: it is still %s.") % [i % 9 + 1, tr(str(WILD_WORDS.get(w[0], "overgrown")))], 18, UI.INK, true))
	var job: String = w[2]
	if job != "":
		var miss: Array = G.progression.missing_reqs(job)
		if miss.is_empty(): v.add_child(UI.label(tr("%s %s below clears it.") % [G.nodes[job]["emoji"], G.nodes[job]["name"]], 16, UI.MUTED, true))
		else: v.add_child(UI.label(tr("To clear it you need first: %s.") % ", ".join(miss), 16, UI.MUTED, true))
	M.content.add_child(pc)

## "The whole field": one button per job, each for every patch of the open field, with how many patches it is for.
func part_whole_field() -> void:
	var f: int = M.field_idx
	var jobs := _field_jobs(f)
	M.widgets.section(tr("🌾 The whole field"), tr("One tap does the job on every patch of this field."))
	var qa := HFlowContainer.new()
	qa.add_theme_constant_override("h_separation", 8)
	qa.add_theme_constant_override("v_separation", 8)
	qa.add_child(UI.button("%s  %d" % [tr("🧺 Harvest all"), jobs["ready"]], harvest_field.bind(f), jobs["ready"] > 0, UI.GREEN, 17))
	qa.add_child(UI.button("%s  %d" % [tr("🌿 Pick all weeds"), jobs["weeds"]], weed_field.bind(f), jobs["weeds"] > 0, UI.GREEN_DARK, 17))
	qa.add_child(UI.button("%s  %d" % [tr("🪨 Pick all stones"), jobs["stones"]], stones_field.bind(f), jobs["stones"] > 0, UI.SOIL, 17))
	if jobs["snow"] > 0: qa.add_child(UI.button("%s  %d" % [tr("❄️ Clear all snow"), jobs["snow"]], snow_field.bind(f), true, UI.SOIL, 17))
	M.content.add_child(qa)

## The pests line: how many there are, what they eat, what chases them off.
func part_pests() -> void:
	var pc := UI.card(Color("f3f7ea"))
	var pv := UI.vbox(4)
	pc.add_child(pv)
	var r1 := UI.hbox(8)
	var n_p: int = G.down(float(G.S["pests"]) + 0.5)
	r1.add_child(UI.label("🐦" if n_p > 0 else "🐦 0", 22))
	if n_p > 0: r1.add_child(UI.explain(UI.stock_bar(float(G.S["pests"]), maxf(4.0, ceilf(float(G.S["pests"]))), Color("8a6f5f"), 200), tr("🐦 Pests on the farm: they nibble what grows.")))
	r1.add_child(UI.label(tr("eat %d%% 🌾 each question") % int(round(G.fields.pest_eat_share() * 100.0)), 17, UI.RED if G.fields.pest_eat_share() >= 0.05 else UI.MUTED))
	pv.add_child(r1)
	var r2 := UI.hbox(8)
	r2.add_child(UI.label("🧍", 22))
	if G.fields.pest_scare() > 0.0: r2.add_child(UI.explain(UI.stock_bar(G.fields.pest_scare(), G.fields.pest_scare(), Color("c98a12"), 160), tr("🧍 Pests chased away every question.")))
	else: r2.add_child(UI.label("—", 18, UI.MUTED))
	if G.fields.pest_block() > 0.0:
		r2.add_child(UI.label("🚧 %d%%" % int(round(G.fields.pest_block() * 100)), 17))
	pv.add_child(r2)
	M.content.add_child(pc)

func part_area(a: String) -> void:
	var arr: Array = G.fields.area(a)
	if arr.is_empty(): return
	var fv = FieldView.new()
	fv.area_name = a
	fv.custom_minimum_size = Vector2(0, 110 * int(ceil(arr.size() / 3.0)))
	M.content.add_child(fv)
	fv.patch_pressed.connect(on_patch)
	M.content.add_child(UI.button(tr("🧺 Harvest all"), harvest_all.bind(a), ready_count(a) > 0, UI.GREEN, 18))
