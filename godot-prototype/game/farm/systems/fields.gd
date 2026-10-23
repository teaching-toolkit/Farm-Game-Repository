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

## A crop with "sowSeasons" can only be sown in those seasons (it can stay in the ground through the others).
func sow_season_ok(n: Dictionary) -> bool:
	var ss: Array = n.get("sowSeasons", [])
	return ss.is_empty() or ss.has(G.seasons.season())

## Outdoors in winter only hardy crops ("winterHardy") can be sown; the greenhouse and the orchard's trees do not mind.
func sow_cold(a: String, n: Dictionary) -> bool:
	return a == "field" and G.seasons.season() == "winter" and not bool(n.get("winterHardy", false))

## Can this crop be sown in this kind of place now, as far as the season goes?
func sow_ok(a: String, cid: String) -> bool:
	var n: Dictionary = G.nodes[cid]
	return sow_season_ok(n) and not sow_cold(a, n)

# ------------------------------------------------------------------ snow (TODO N6)

func patch_snow(i: int) -> bool:
	return bool(G.S["patches"][i].get("snow", false))

## Snow falls (in winter, like rain): every empty patch of the field is covered until it is cleared or spring comes.
func snowfall() -> void:
	var any := false
	for i in range(G.S["patches"].size()):
		if not patch_usable("field", i): continue
		var p: Dictionary = G.S["patches"][i]
		if p["crop"] == "" and not p.get("snow", false): p["snow"] = true; any = true
	if any: G.say(tr("❄️ It snowed! The empty patches are under snow: clear it before you sow."))

## Spring: the snow melts everywhere.
func melt_snow() -> void:
	for p in G.S["patches"]: p["snow"] = false

## Clear the snow off one patch, a chore of the actions system (see register_chores).
func _clear_snow_requires(_who, args: Dictionary) -> Array:
	if not patch_snow(int(args["i"])): return [{"key": "nothing_to_do", "text": ""}]
	return []

func _clear_snow_effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var i := int(args["i"])
	G.S["patches"][i]["snow"] = false
	G.inventory.emit_gained("patch:field:%d" % i, {})
	return {"gained": {}}

func snow_count() -> int:
	var n := 0
	for i in range(G.S["patches"].size()):
		if patch_usable("field", i) and patch_snow(i): n += 1
	return n

## How many plants of this crop could go into one patch right now, and why not more.
func plant_plan(a: String, cid: String, water_have := -1.0) -> Dictionary:
	var n = G.nodes[cid]
	var want := plants_per_patch(a)
	var reasons := []
	var k := want
	var seeds := seed_have(cid)
	var seed_cost := float(n.get("seedCost", 0))
	if seeds < k:   # only seeds you have can be planted (they are bought at the market)
		k = int(floorf(seeds + 0.0001)); reasons.append("seeds")
	if not sow_season_ok(n):      # winter wheat is sown in autumn or winter only
		k = 0; reasons.append("season")
	if sow_cold(a, n):            # outdoors in winter only hardy crops
		k = 0; reasons.append("cold")
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
	var water := float(G.S["water"]) if water_have < 0.0 else water_have
	while k > 0 and water + 0.001 < wper * k:
		k -= 1
		if not reasons.has("water"): reasons.append("water")
	var buy := 0
	return {"plants": k, "max": want, "reasons": reasons, "water": wper * k, "buy_seeds": buy, "coins": buy * seed_cost,
		"water_base": float(n.get("water", 0)) * k,
		"water_full": wper * want, "water_full_base": float(n.get("water", 0)) * want}   # for a full patch: shows what is missing

## Sow one patch, a chore of the actions system (args: a, i, cid). The cost is the whole plan's: one energy, and the water of every plant.
func _plant_requires(_who, args: Dictionary) -> Array:
	var a: String = args["a"]
	var i: int = args["i"]
	var cid: String = args["cid"]
	if not patch_usable(a, i): return [{"key": "nothing_to_do", "text": ""}]
	if area(a)[i]["crop"] != "": return [{"key": "occupied", "text": tr("Something is already growing there.")}]
	if a == "field" and patch_snow(i): return [{"key": "snow", "text": tr("❄️ Snow covers this patch: clear it first.")}]
	var plan := plant_plan(a, cid)
	if int(plan["plants"]) < 1:
		if plan["reasons"].has("cold"): return [{"key": "cold", "text": tr("❄️ Too cold to sow %s outdoors now.") % G.nodes[cid]["name"]}]
		if plan["reasons"].has("season"): return [{"key": "season", "text": tr("🌱 %s is sown in %s.") % [G.nodes[cid]["name"], " / ".join((G.nodes[cid]["sowSeasons"] as Array).map(func(x): return tr(x)))]}]
		return [{"key": "supplies", "text": tr("🌱 Can't plant %s: not enough %s.") % [G.nodes[cid]["name"], ", ".join(plan["reasons"])]}]
	return []

func _plant_extra(_who, args: Dictionary) -> Dictionary:
	var plan := plant_plan(args["a"], args["cid"])
	return {"cost": {"water": float(plan["water"])}, "base": {"water": float(plan["water_base"])}}

## Trees in the orchard are planted at the plain energy price; everything else also pays the field modifier.
func _plant_no_mult(_who, args: Dictionary) -> bool:
	return args["a"] == "orchard" and G.nodes[args["cid"]].has("regrow")

func _plant_effect(who, args: Dictionary, cost: Dictionary) -> Dictionary:
	var a: String = args["a"]
	var cid: String = args["cid"]
	var p = area(a)[int(args["i"])]
	var plan := plant_plan(a, cid, float(G.S["water"]) + float(cost.get("water", 0.0)))   # the water is already paid
	var k := int(plan["plants"])
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
	var rot = G.meta.get("rotation", {})
	var soil := 1.0
	if a == "field" and p["last"] != "":
		if p["last"] == cid: soil = float(rot.get("sameCropGrow", 0.85))
		elif (rot.get("legumes", []) as Array).has(p["last"]): soil = float(rot.get("afterLegumeGrow", 1.1)) + G.g("restedSoil", 0.0)
	p["crop"] = cid; p["plants"] = float(k); p["growth"] = 0.0; p["ready"] = false; p["soil"] = soil; p["cycles"] = 0
	if not p.has("quality"): p["quality"] = 1.0
	return {"gained": {}}

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

## Harvest one patch, a chore of the actions system (args: a, i). The order of the rolls is luck, then the grade, then every item.
func _harvest_requires(_who, args: Dictionary) -> Array:
	var p = area(args["a"])[int(args["i"])]
	if p["crop"] == "" or not p["ready"]: return [{"key": "nothing_to_do", "text": ""}]
	return []

func _harvest_effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var a: String = args["a"]
	var i := int(args["i"])
	var p = area(a)[i]
	var n = G.nodes[p["crop"]]
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
	return {"gained": arrived}

## Cuts down a tree in the orchard so another kind can be planted there (three apple trees must not block the walnut tree
## the pony's cake needs). Costs energy, gives the wood back. A chore of the actions system (args: a, i).
func _cut_tree_requires(_who, args: Dictionary) -> Array:
	var p = area(args["a"])[int(args["i"])]
	if p["crop"] == "" or not G.nodes[p["crop"]].has("regrow"): return [{"key": "nothing_to_do", "text": ""}]
	return []

func _cut_tree_effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var a: String = args["a"]
	var i := int(args["i"])
	var p = area(a)[i]
	var tree_name: String = G.nodes[p["crop"]]["name"]
	p["last"] = p["crop"]; p["crop"] = ""; p["plants"] = 0.0; p["growth"] = 0.0; p["ready"] = false; p["cycles"] = 0
	var gives: Dictionary = G.meta.get("orchard", {}).get("cutGives", {"log": 1, "stick": 2})
	var got := {}
	for k in gives: got[k] = G.inventory.add_item(k, float(gives[k]), true)
	G.inventory.emit_gained("patch:%s:%d" % [a, i], got)
	G.say(tr("🪓 Cut down the %s: the spot is free for another tree.") % tree_name)
	return {"gained": got}

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

## Pull the weeds of one patch (up to weedsPerPull), a chore of the actions system.
func _weed_n(i: int) -> float:
	return minf(float(G.S["patches"][i]["weeds"]), float(G.meta.get("weeds", {}).get("weedsPerPull", 3)))

func _weed_requires(_who, args: Dictionary) -> Array:
	if float(G.S["patches"][int(args["i"])]["weeds"]) < 0.5:
		return [{"key": "nothing_to_do", "text": tr("🌿 No weeds to pull here. (Try 'Root out the weeds' in Polish — it keeps them away longer.)")}]
	return []

func _weed_amount(_who, args: Dictionary) -> float:
	return _weed_n(int(args["i"]))

func _weed_effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var i := int(args["i"])
	var p = G.S["patches"][i]
	var n := _weed_n(i)
	p["weeds"] = float(p["weeds"]) - n
	var fib := n * (1.5 if G.seasons.season() == "spring" else 1.0)
	var fib_got := G.inventory.add_item("fiber", fib, true)
	G.inventory.emit_gained("patch:field:%d" % i, {"fiber": fib_got})
	G.S["stats"]["weeds"] = float(G.S["stats"]["weeds"]) + n
	G.rewards.job_progress("weed", "", n)
	G.rewards.weed_luck()
	G.crafting.wear_polish("use:weed")
	G.rewards.check_acorns()
	return {"gained": {"fiber": fib_got}}

## Pick the stones of one patch (up to stonesPerPick), a chore of the actions system.
func _stones_n(i: int) -> float:
	return minf(float(G.S["patches"][i]["stones"]), float(G.meta.get("stones", {}).get("stonesPerPick", 2)))

func _stones_requires(_who, args: Dictionary) -> Array:
	if float(G.S["patches"][int(args["i"])]["stones"]) < 0.5: return [{"key": "nothing_to_do", "text": ""}]
	return []

func _stones_amount(_who, args: Dictionary) -> float:
	return _stones_n(int(args["i"]))

func _stones_effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var i := int(args["i"])
	var p = G.S["patches"][i]
	var n := _stones_n(i)
	p["stones"] = float(p["stones"]) - n
	var got := G.inventory.add_item("stone", n)
	G.inventory.emit_gained("patch:field:%d" % i, {"stone": got})
	G.S["stats"]["stones"] = float(G.S["stats"]["stones"]) + n
	G.rewards.job_progress("stones", "", n)
	if G.rewards.roll(G.rewards.luck_event("stone_quartz")): G.inventory.add_item("quartz", 1.0); G.say(tr("💎 A sparkling quartz crystal inside a stone!"))
	return {"gained": {"stone": got}}

## The patches of field f that a chore has something to do on (overgrown patches do not count), in order: the args of a batch.
func field_jobs(f: int, chore: String) -> Array:
	var out := []
	for i in range(f * 9, mini(f * 9 + 9, G.S["patches"].size())):
		if not patch_usable("field", i): continue
		var p: Dictionary = G.S["patches"][i]
		if (chore == "weed" and float(p["weeds"]) >= 0.5) or (chore == "pick_stones" and float(p["stones"]) >= 0.5) or (chore == "clear_snow" and p.get("snow", false)):
			out.append({"i": i})
	return out

# ------------------------------------------------------------------ water

## How much one trip to the pond brings (the old bucket: 3; a carrying yoke adds more).
func fetch_amount() -> float:
	return G.g("fetchWater", float(G.meta.get("water", {}).get("fetchBase", 3.0)))

## The field chores of the actions system (rules/46-chores.json): their cost and the check are there, the effect is here.
func register_chores() -> void:
	G.actions.register("fetch_water", _fetch_water_effect, _fetch_water_requires)
	G.actions.register("clear_snow", _clear_snow_effect, _clear_snow_requires)
	G.actions.register("weed", _weed_effect, _weed_requires, _weed_amount)
	G.actions.register("pick_stones", _stones_effect, _stones_requires, _stones_amount)
	G.actions.register("plant", _plant_effect, _plant_requires, Callable(), _plant_extra, _plant_no_mult)
	G.actions.register("harvest", _harvest_effect, _harvest_requires)
	G.actions.register("cut_tree", _cut_tree_effect, _cut_tree_requires)

func _fetch_water_requires(_who, _args: Dictionary) -> Array:
	if G.needs.water_cap() - float(G.S["water"]) < 0.5: return [{"key": "water_full", "text": tr("💧 Your water is full.")}]
	return []

func _fetch_water_effect(_who, _args: Dictionary, _cost: Dictionary) -> Dictionary:
	var q := minf(G.needs.water_cap() - float(G.S["water"]), fetch_amount())
	G.S["water"] = float(G.S["water"]) + q
	G.S["stats"]["fetch"] = int(G.S["stats"].get("fetch", 0)) + 1
	G.inventory.emit_gained("water", {"water": q})
	return {"gained": {"water": q}}

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
