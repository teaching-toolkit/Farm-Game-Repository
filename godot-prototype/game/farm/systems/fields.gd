extends RefCounted
class_name FarmFields
## Fields, orchard and greenhouse: patches, planting, growth, harvest, weeds, stones, pests, the scarecrow, and the bucket of water.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"seeds": {}, "patches": [], "orchard": [], "gh": [], "pests": 0.0}

# ------------------------------------------------------------------ fields, orchard, greenhouse

func _blank_patch() -> Dictionary:
	return {"crop": "", "plants": 0.0, "growth": 0.0, "ready": false, "weeds": 0.0, "stones": 0.0, "last": "", "soil": 1.0, "cycles": 0, "quality": 1.0}

func ensure_areas() -> void:
	var fields := maxi(1, int(ceilf(float(G.progression.plots()) / 9.0)))
	while G.S["patches"].size() < fields * 9: G.S["patches"].append(_blank_patch())
	while G.S["orchard"].size() < int(round(G.g("orchardSpots", 0.0))): G.S["orchard"].append(_blank_patch())
	while G.S["gh"].size() < int(round(G.g("greenhouseBeds", 0.0))): G.S["gh"].append(_blank_patch())

func area(a: String) -> Array:
	return G.S["patches"] if a == "field" else G.S[a]

func patch_usable(a: String, i: int) -> bool:
	if a == "field": return i < G.progression.plots()
	return i < area(a).size()

const CLEARING := [["clear_thistles", "weeds"], ["clear_weeds", "weeds"], ["clear_rocks", "rocks"], ["clear_stumps", "stumps"]]

const FIELD_WILD := ["", "scrub", "marsh"]     # fields 2 and 3 before they are opened

## What is in the way on locked patch i of field f, and how much of its clearing is done (0..1): the clearing jobs still
## to do, two patches each, in order. Returns [kind, done, job id] (kind: weeds, rocks, stumps, scrub, marsh).
func patch_wild(f: int, i: int) -> Array:
	if f > 0: return [FIELD_WILD[mini(f, FIELD_WILD.size() - 1)], 0.0, ""]
	var left := []
	for c in CLEARING:
		if G.nodes.has(c[0]) and not G.satisfied(c[0]) and not G.S.get("open_early", {}).has(c[0]): left.append(c)
	var n: int = i - int(G.progression.plots())
	if n >= 0 and n / 2 < left.size():
		var id: String = left[n / 2][0]
		var steps: int = G.progression.steps_of(id).size()
		return [left[n / 2][1], float(G.progression.step_index(id)) / float(maxi(1, steps)), id]
	return ["weeds", 0.0, ""]

func field_names() -> Array:
	var names := [tr("Home Field"), tr("North Field"), tr("River Meadow")]
	var out := []
	for f in range(int(G.S["patches"].size() / 9)): out.append(names[f] if f < names.size() else tr("Field %d") % (f + 1))
	return out

func crop_slot(cid: String) -> String:
	var s: String = G.nodes[cid].get("slot", "field")
	return "gh" if s == "greenhouse" else s

func crops_for(a: String) -> Array:
	var out := []
	for id in G.nodes:
		var n = G.nodes[id]
		if n["type"] != "crop" or not G.done(id): continue
		if crop_slot(id) == a: out.append(id)
	return out

func plants_per_patch(a: String) -> int:
	if a == "orchard": return 1
	return maxi(1, int(round(G.g("patchCap", 1.0))))

func free_density() -> float:
	return float(G.meta.get("weeds", {}).get("freeDensity", 2)) + G.g("freeDensity", 0.0)

func fert_points_have() -> float:
	var t := 0.0
	for k in G.items:
		if G.items[k].has("fertilizer"): t += G.inventory.count(k) * float(G.items[k]["fertilizer"])
	return t

func _take_fert(points: float) -> void:
	var fs := []
	for k in G.items:
		if G.items[k].has("fertilizer"): fs.append(k)
	fs.sort_custom(func(a, b): return float(G.items[a]["fertilizer"]) < float(G.items[b]["fertilizer"]))
	var left := points
	for k in fs:
		var p := float(G.items[k]["fertilizer"])
		while left > 0.0001 and G.inventory.count(k) >= 1.0:
			G.inventory.take(k, 1.0); left -= p
		if left <= 0.0001: return

func seed_have(cid: String) -> float:
	var n = G.nodes[cid]
	if n.has("seedItem"): return G.inventory.count(n["seedItem"])
	return float(G.S["seeds"].get(cid, 0.0))

func field_water_mult() -> float:
	if G.S.get("rain", false): return 0.0
	return float(G.g("waterMult", 1.0)) * G.m("water:field") * float(G.seasons.smod("waterField", 1.0))

## How many plants of this crop could go into one patch right now, and why not more.
func plant_plan(a: String, cid: String) -> Dictionary:
	var n = G.nodes[cid]
	var want := plants_per_patch(a)
	var reasons := []
	var k := want
	var seeds := seed_have(cid)
	var seed_cost := float(n.get("seedCost", 0))
	if seeds < k:   # only seeds you have can be planted (they are bought at the market)
		k = int(floorf(seeds + 0.0001)); reasons.append("seeds")
	if a == "field":
		var fd := free_density()
		while k > fd and fert_points_have() + 0.001 < (k - fd):
			k -= 1
			if not reasons.has("fertilizer"): reasons.append("fertilizer")
	for nk in n.get("needs", {}):
		var per := float(n["needs"][nk])
		while k > 0 and G.inventory.count(nk) + 0.001 < per * k:
			k -= 1
			if not reasons.has(nk): reasons.append(nk)
	var wm := field_water_mult() if a != "gh" else float(G.g("waterMult", 1.0)) * 0.5
	var wper := float(n.get("water", 0)) * wm
	while k > 0 and G.S["water"] + 0.001 < wper * k:
		k -= 1
		if not reasons.has("water"): reasons.append("water")
	var e := G.needs.ecost("plant", 1.0) * G.m("energy:field") if a != "orchard" or not n.has("regrow") else G.needs.ecost("plant", 1.0)
	var buy := 0
	return {"plants": k, "max": want, "reasons": reasons, "water": wper * k, "energy": e, "buy_seeds": buy, "coins": buy * seed_cost,
		"water_base": float(n.get("water", 0)) * k, "energy_base": 1.0,
		"water_full": wper * want, "water_full_base": float(n.get("water", 0)) * want}   # for a full patch: shows what is missing

func plant(a: String, i: int, cid: String) -> bool:
	if not patch_usable(a, i): return false
	var p = area(a)[i]
	if p["crop"] != "": G.say(tr("Something is already growing there.")); return false
	var plan := plant_plan(a, cid)
	var k := int(plan["plants"])
	if k < 1:
		G.say(tr("🌱 Can't plant %s: not enough %s.") % [G.nodes[cid]["name"], ", ".join(plan["reasons"])])
		return false
	if G.S["energy"] + 0.001 < float(plan["energy"]):
		G.say(tr("⚡ Too tired to plant. Rest a little (tap ⚡).")); return false
	var n = G.nodes[cid]
	if int(plan["buy_seeds"]) > 0:
		G.S["coins"] -= float(plan["coins"])
		G.S["seeds"][cid] = float(G.S["seeds"].get(cid, 0.0)) + int(plan["buy_seeds"])
		if G.rewards.roll(G.rewards.luck_event("seed_bargain")): G.S["seeds"][cid] = float(G.S["seeds"][cid]) + 1.0; G.say(tr("🎁 The seed merchant adds one for free."))
	if n.has("seedItem"): G.inventory.take(n["seedItem"], k)
	else: G.S["seeds"][cid] = float(G.S["seeds"].get(cid, 0.0)) - k
	if a == "field":
		var extra := maxf(0.0, k - free_density())
		if extra > 0.0: _take_fert(extra)
	for nk in n.get("needs", {}): G.inventory.take(nk, float(n["needs"][nk]) * k)
	G.S["water"] -= float(plan["water"])
	G.S["energy"] -= float(plan["energy"])
	var rot = G.meta.get("rotation", {})
	var soil := 1.0
	if a == "field" and p["last"] != "":
		if p["last"] == cid: soil = float(rot.get("sameCropGrow", 0.85))
		elif (rot.get("legumes", []) as Array).has(p["last"]): soil = float(rot.get("afterLegumeGrow", 1.1)) + G.g("restedSoil", 0.0)
	p["crop"] = cid; p["plants"] = float(k); p["growth"] = 0.0; p["ready"] = false; p["soil"] = soil; p["cycles"] = 0
	if not p.has("quality"): p["quality"] = 1.0
	G.crafting.wear_polish("use:plant")
	G.skills.practice("field")
	G.save_game(); G.changed.emit()
	return true

func grow_target(p: Dictionary) -> float:
	var n = G.nodes[p["crop"]]
	if n.has("regrow") and int(p.get("cycles", 0)) > 0: return float(n["regrow"])
	return float(n.get("grow", 3))

func slow_factor(p: Dictionary) -> float:
	var sl := float(G.meta.get("stones", {}).get("slowPerStone", 0.04))
	return maxf(0.5, 1.0 - 0.04 * float(p["weeds"]) - sl * float(p["stones"]))

func grow_speed(a: String, p: Dictionary) -> float:
	var base := 1.0 / maxf(0.2, G.m("grow"))
	if a == "gh": return base
	var sg := float(G.seasons.smod("grow", 1.0))
	if G.seasons.season() == "winter": sg += G.g("winterGrow", 0.0)
	return base * sg * float(p.get("soil", 1.0)) * slow_factor(p)

func harvest(a: String, i: int) -> bool:
	var p = area(a)[i]
	if p["crop"] == "" or not p["ready"]: return false
	var n = G.nodes[p["crop"]]
	var e := G.needs.ecost("harvest", 1.0) * G.m("energy:field")
	if G.S["energy"] + 0.001 < e: G.say(tr("⚡ Too tired to harvest. Rest a little (tap ⚡).")); return false
	G.S["energy"] -= e
	var mult := 1.0
	if G.rewards.roll(G.rewards.luck_event("double_harvest")): mult = 2.0; G.say(tr("🎉 Bumper crop: double harvest!"))
	if a == "orchard":
		mult *= G.m("yield:orchard") * float(G.seasons.smod("yieldOrchard", 1.0))
	var got := []
	var arrived := {}
	var amounts := harvest_amounts(n, maxi(1, shown_plants(float(p["plants"]))), float(p.get("quality", 1.0)), mult)
	var grade := G.quality.roll(G.quality.crop_expect(p))      # the whole harvest of a patch has one grade (soil, weeds, stones, upgrades)
	for k in amounts:
		var q := float(amounts[k]) + G.g("yield_" + k, 0.0)
		q = G.inventory.add_item(k, q, false, grade)
		got.append("%s%d" % [G.iemoji(k), G.down(q)])
		arrived[k] = q
		G.rewards.job_progress("harvest", k, q)
	if n.has("seedItem") and G.g("heirloomSeedSaving", 0.0) > 0.0: G.inventory.add_item(n["seedItem"], 1.0)
	G.S["stats"]["harvests"] = int(G.S["stats"]["harvests"]) + 1
	G.rewards.check_perks()
	G.say(tr("🧺 Harvested %s: %s") % [n["name"], " ".join(got)] + "  " + G.quality.stars(grade))
	G.inventory.emit_gained("patch:%s:%d" % [a, i], arrived)
	if n.has("regrow"):
		p["growth"] = 0.0; p["ready"] = false; p["cycles"] = int(p.get("cycles", 0)) + 1
	else:
		p["last"] = p["crop"]; p["crop"] = ""; p["plants"] = 0.0; p["growth"] = 0.0; p["ready"] = false
	G.crafting.wear_polish("use:harvest")
	G.skills.practice("field")
	G.save_game(); G.changed.emit()
	return true

## Cuts down a tree in the orchard so another kind can be planted there (three apple trees must not block the walnut tree
## the pony's cake needs). Costs energy, gives the wood back.
func cut_tree(a: String, i: int) -> bool:
	var p = area(a)[i]
	if p["crop"] == "" or not G.nodes[p["crop"]].has("regrow"): return false
	var e := G.needs.ecost("wood", float(G.meta.get("orchard", {}).get("cutEnergy", 3)))
	if G.S["energy"] + 0.001 < e: G.say(tr("⚡ Too tired to cut a tree. Rest a little (tap ⚡).")); return false
	G.S["energy"] -= e
	var tree_name: String = G.nodes[p["crop"]]["name"]
	p["last"] = p["crop"]; p["crop"] = ""; p["plants"] = 0.0; p["growth"] = 0.0; p["ready"] = false; p["cycles"] = 0
	var got := {}
	for k in G.meta.get("orchard", {}).get("cutGives", {"log": 1, "stick": 2}):
		got[k] = G.inventory.add_item(k, float(G.meta.get("orchard", {}).get("cutGives", {"log": 1, "stick": 2})[k]), true)
	G.inventory.emit_gained("patch:%s:%d" % [a, i], got)
	G.say(tr("🪓 Cut down the %s: the spot is free for another tree.") % tree_name)
	G.save_game(); G.changed.emit()
	return true

## What one harvest gives: for every plant the crop's average (data: yields) × luck × the patch's quality, with a random
## spread, rounded up or down at random so the average holds; whole numbers only. The first item is at least minMain per plant.
func harvest_amounts(n: Dictionary, plants: int, quality: float, mult: float) -> Dictionary:
	var ym = G.meta.get("yield", {})
	var spread := float(ym.get("spread", 0.22))
	var lshift := float(ym.get("luckShift", 0.1))
	var min_main := float(ym.get("minMain", 1))
	var out := {}
	var first := true
	for k in n.get("yields", {}):
		var avg := float(n["yields"][k]) * (1.0 + G.rewards.luck() * lshift) * quality * mult
		var tot := 0.0
		for _p in range(plants):
			var x := maxf(0.0, avg + G.rng.randfn(0.0, spread * avg))
			if first: x = maxf(min_main * mult, x)
			var whole := floorf(x)
			if G.rng.randf() < x - whole: whole += 1.0
			tot += whole
		out[k] = tot
		first = false
	return out

func weed(i: int) -> bool:
	var p = G.S["patches"][i]
	var w := float(p["weeds"])
	if w < 0.5:
		G.say(tr("🌿 No weeds to pull here. (Try 'Root out the weeds' in Polish — it keeps them away longer.)"))
		return false
	var n := minf(w, float(G.meta.get("weeds", {}).get("weedsPerPull", 3)))
	var e := G.needs.ecost("weed", n) * G.m("energy:field")
	if G.S["energy"] + 0.001 < e: G.say(tr("⚡ Too tired to weed. Rest a little (tap ⚡).")); return false
	G.S["energy"] -= e
	p["weeds"] = w - n
	var fib := n * (1.5 if G.seasons.season() == "spring" else 1.0)
	var fib_got := G.inventory.add_item("fiber", fib, true)
	G.inventory.emit_gained("patch:field:%d" % i, {"fiber": fib_got})
	G.S["stats"]["weeds"] = float(G.S["stats"]["weeds"]) + n
	G.rewards.job_progress("weed", "", n)
	G.rewards.weed_luck()
	G.crafting.wear_polish("use:weed")
	G.rewards.check_acorns()
	G.save_game(); G.changed.emit()
	return true

func weed_field(f: int) -> void:
	var any := false
	for i in range(f * 9, f * 9 + 9):
		if patch_usable("field", i) and float(G.S["patches"][i]["weeds"]) >= 0.5:
			if not weed(i): break
			any = true
	if not any: G.say(tr("🌿 This field is already tidy."))

func pick_stones(i: int) -> bool:
	var p = G.S["patches"][i]
	var s := float(p["stones"])
	if s < 0.5: return false
	var n := minf(s, float(G.meta.get("stones", {}).get("stonesPerPick", 2)))
	var e := G.needs.ecost("field", n * float(G.meta.get("stones", {}).get("energyPerStone", 1)))
	if G.S["energy"] + 0.001 < e: G.say(tr("⚡ Too tired. Rest a little (tap ⚡).")); return false
	G.S["energy"] -= e
	p["stones"] = s - n
	G.inventory.emit_gained("patch:field:%d" % i, {"stone": G.inventory.add_item("stone", n)})
	G.S["stats"]["stones"] = float(G.S["stats"]["stones"]) + n
	G.rewards.job_progress("stones", "", n)
	if G.rewards.roll(G.rewards.luck_event("stone_quartz")): G.inventory.add_item("quartz", 1.0); G.say(tr("💎 A sparkling quartz crystal inside a stone!"))
	G.save_game(); G.changed.emit()
	return true

# ------------------------------------------------------------------ water

## How much one trip to the pond brings (the old bucket: 3; a carrying yoke adds more).
func fetch_amount() -> float:
	return G.g("fetchWater", float(G.meta.get("water", {}).get("fetchBase", 3.0)))

func fetch_cost() -> float:
	return G.needs.ecost("gather", float(G.meta.get("water", {}).get("fetchEnergy", 1.0)))

func fetch_water() -> bool:
	var room := G.needs.water_cap() - float(G.S["water"])
	if room < 0.5: G.say(tr("💧 Your water is full.")); return false
	var e := fetch_cost()
	if G.S["energy"] + 0.001 < e: G.say(tr("⚡ Too tired to carry water. Rest a little (tap ⚡).")); return false
	G.S["energy"] -= e
	var q := minf(room, fetch_amount())
	G.S["water"] = float(G.S["water"]) + q
	G.S["stats"]["fetch"] = int(G.S["stats"].get("fetch", 0)) + 1
	G.inventory.emit_gained("water", {"water": q})
	G.save_game(); G.changed.emit()
	return true

# ------------------------------------------------------------------ one Time Quiz answer

func step_crops(_info: Dictionary) -> void:
	for a in ["field", "orchard", "gh"]:
		var arr: Array = area(a)
		for i in range(arr.size()):
			var p = arr[i]
			if p["crop"] == "" or p["ready"]: continue
			p["growth"] = float(p["growth"]) + grow_speed(a, p)
			if float(p["growth"]) + 0.0001 >= grow_target(p): p["ready"] = true

func step_pests(info: Dictionary) -> void:
	var pr := _tick_pests()
	info["removed"] = pr["removed"]; info["arrived"] = pr["arrived"]; info["eaten"] = pr["eaten"]; info["eat_share"] = pr["eat_share"]

func weed_rate() -> float:
	var w = G.meta.get("weeds", {})
	var tiers: Array = w.get("tierByChapter", [1, 1.2, 1.5, 2, 2.5])
	var tier := float(tiers[mini(tiers.size(), G.chapter()) - 1])
	var fp := maxf(0.0, float(plants_per_patch("field")) - free_density())
	return float(w.get("ratePerQuestion", 0.15)) * tier * float(G.seasons.smod("weeds", 1.0)) * (1.0 + float(w.get("fertilizerFactor", 0.4)) * fp) * G.m("weeds")

func tick_weeds_stones(_info := {}) -> void:
	var wr := weed_rate()
	var st = G.meta.get("stones", {})
	var winter := G.seasons.season() == "winter"
	var depth := float(st.get("deepBedFactor", {}).get(str(plants_per_patch("field")), 1.0))
	for i in range(G.S["patches"].size()):
		if not patch_usable("field", i): continue
		var p = G.S["patches"][i]
		p["weeds"] = minf(12.0, float(p["weeds"]) + wr)
		if winter:
			var h := float(st.get("heavePerPatch", 0.07)) * depth * (float(st.get("barePatchFactor", 1.5)) if p["crop"] == "" else 1.0) * G.m("stones")
			p["stones"] = minf(float(st.get("capPerPatch", 6)), float(p["stones"]) + h)

func plants_growing() -> float:
	var t := 0.0
	for i in range(G.S["patches"].size()):
		var p = G.S["patches"][i]
		if p["crop"] != "" and not p["ready"]: t += float(p["plants"])
	for p in G.S["orchard"]:
		if p["crop"] != "": t += 0.5
	return t

func pest_block() -> float:
	return minf(0.9, G.g("pestBlock", 0.0))

func pest_scare() -> float:
	return G.g("scare", 0.0)

func pest_arrivals() -> float:
	var pe = G.meta.get("pests", {})
	if pe.is_empty(): return 0.0
	var tiers: Array = pe.get("tierByChapter", [1])
	var tier := float(tiers[mini(tiers.size(), G.chapter()) - 1])
	return float(pe.get("ratePerPlant", 0.05)) * plants_growing() * tier * float(G.seasons.smod("pests", 1.0)) * G.m("pests") * (1.0 - pest_block())

func _tick_pests() -> Dictionary:
	var pe = G.meta.get("pests", {})
	if pe.is_empty(): return {"removed": 0, "arrived": 0.0, "eaten": {}, "eat_share": 0.0}
	var plants := plants_growing()
	var arrive := pest_arrivals()
	var r := float(G.S["pests"]) + arrive
	var removed := minf(r, pest_scare())
	r -= removed
	r -= r * float(pe.get("leaveRate", 0.2))
	var cap := float(pe.get("capBase", 4)) + float(pe.get("capPerPlant", 0.2)) * plants
	r = clampf(r, 0.0, cap)
	G.S["pests"] = r
	# the pests that stay eat a share of every growing patch (worked out exactly; the map shows it rounded)
	var share := pest_eat_share()
	var eaten := {}
	if plants > 0.0 and share > 0.0:
		for i in range(G.S["patches"].size()):
			var p = G.S["patches"][i]
			if p["crop"] == "" or p["ready"]: continue
			var before := float(p["plants"])
			var after := maxf(1.0, before * (1.0 - share))
			p["plants"] = after
			var lost := shown_plants(before) - shown_plants(after)
			if lost > 0: eaten[i] = lost
	return {"removed": int(round(removed)), "arrived": arrive, "eaten": eaten, "eat_share": share}

## Share of the growing plants the pests eat in one question (exact; shown rounded to whole percent).
func pest_eat_share() -> float:
	var pe = G.meta.get("pests", {})
	return clampf(float(G.S["pests"]) * float(pe.get("eatPerPest", 0.02)), 0.0, float(pe.get("maxEat", 0.35)))

## How many plants a patch shows for a (fractional) number of plants.
func shown_plants(x: float) -> int:
	return clampi(int(round(x)), 0, 9)
