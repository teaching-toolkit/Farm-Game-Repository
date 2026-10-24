extends RefCounted
class_name FarmCrafting
## Stations and recipes: batches and what they make, fuel and the woodpile, the house's firewood, and polish (endless upgrades with
## diminishing returns) that wears with use.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"polish": {}, "running": {}, "woodpile": 0.0, "cold": false}

# ------------------------------------------------------------------ stations, recipes & the woodpile

func chain_root(id: String) -> String:
	var cur := id
	var guard := 0
	while G.nodes[cur].has("replaces") and guard < 10:
		cur = G.nodes[cur]["replaces"]; guard += 1
	return cur

func chain_members(root: String) -> Array:
	var out := [root]
	var cur := root
	while G.replaced_by.has(cur):
		cur = G.replaced_by[cur]; out.append(cur)
	return out

func active_of(root: String) -> String:
	var act := ""
	for mmb in chain_members(root):
		if G.done(mmb): act = mmb
	return act

func stations() -> Array:
	var out := []
	var seen := {}
	for id in G.nodes:
		if G.nodes[id]["type"] != "station" and not G.station_recipes.has(id): continue
		var r := chain_root(id)
		if seen.has(r): continue
		seen[r] = true
		if active_of(r) != "": out.append(r)
	return out

func station_slots(root: String) -> int:
	var act := active_of(root)
	if act == "": return 0
	var s := int(G.nodes[act].get("slots", 1))
	for mmb in chain_members(root): s += int(round(G.g("slots:" + mmb, 0.0)))
	if act.begins_with("windmill"): s = maxi(s, int(round(G.g("autoMill", 1.0))) * 2)
	return s

func station_recipes_for(root: String) -> Array:
	var out := []
	for mmb in chain_members(root):
		if not G.satisfied(mmb): continue
		for rid in G.station_recipes.get(mmb, []): out.append(rid)
	return out

func recipe_open(rid: String) -> bool:
	var r = G.recipes[rid]
	if not G.satisfied(r["station"]): return false
	for q in r.get("requires", []):
		if not G.satisfied(q): return false
	return true

func recipe_cat(rid: String) -> String:
	var r = G.recipes[rid]
	if r.has("cat"): return r["cat"]
	return str(G.nodes[r["station"]].get("cat", "craft"))

## What one tap makes at once: gathering takes more per trip with carrying gear (the "carry" upgrades: basket, packs);
## everything else 1. The cost and the energy grow with it, so a bigger load costs the same per piece.
func recipe_batch(rid: String) -> int:
	if not (recipe_cat(rid) in G.CARRY_CATS): return 1
	return 1 + maxi(0, int(round(G.g("carry", 0.0))))

func recipe_fuel(rid: String) -> float:
	var r = G.recipes[rid]
	return float(r.get("fuel", 0)) * G.m("fuel") * G.m("fuel:" + r["station"])

func recipe_time(rid: String) -> float:
	var r = G.recipes[rid]
	return float(r.get("time", 0)) * G.m("time:" + r["station"]) * G.skills.time_mult(G.skills.family_of_station(r["station"]))

func woodpile_cap() -> float:
	return G.g("woodpileCap", 20.0)

func fuel_value(k: String) -> float:
	return float(G.meta.get("fuel", {}).get("values", {}).get(k, 0.0))

func stack_wood(k: String, q: float) -> float:
	var v := fuel_value(k)
	if v <= 0.0: return 0.0
	var room := woodpile_cap() - float(G.S["woodpile"])
	var n := minf(q, minf(G.inventory.count(k), floorf(room / v)))
	if n <= 0.0: return 0.0
	G.inventory.take(k, n)
	G.S["woodpile"] = float(G.S["woodpile"]) + n * v
	return n

func auto_stack(need: float) -> void:
	for k in G.meta.get("fuel", {}).get("stackOrder", ["stick", "straw", "log"]):
		if float(G.S["woodpile"]) + 0.0001 >= need: return
		var v := fuel_value(k)
		if v <= 0.0: continue
		var missing := need - float(G.S["woodpile"])
		stack_wood(k, ceilf(missing / v))

## Fuel that could still go on the woodpile from what is in store (sticks, straw, logs …), up to its room.
func fuel_in_store() -> float:
	var f := 0.0
	for k in G.meta.get("fuel", {}).get("stackOrder", ["stick", "straw", "log"]): f += G.inventory.count(k) * fuel_value(k)
	return minf(f, woodpile_cap() - float(G.S["woodpile"]))

## Stoking: puts enough wood on the woodpile for need fuel (sticks first, then straw, then logs). Stoves, ovens, kilns
## and the forge only burn what is on the woodpile, so the woodpile is stoked first. Returns the fuel added.
func stoke(need: float) -> float:
	var before := float(G.S["woodpile"])
	var had := {}
	for k in G.meta.get("fuel", {}).get("stackOrder", ["stick", "straw", "log"]): had[k] = G.inventory.count(k)
	auto_stack(need)
	var parts := []
	for k in had:
		var used := float(had[k]) - G.inventory.count(k)
		if used > 0.0: parts.append("%d %s" % [int(round(used)), G.iname(k)])
	var added := float(G.S["woodpile"]) - before
	if added > 0.0:
		G.say(tr("🪵 Stoked the woodpile: %s.") % ", ".join(parts))
		G.save_game(); G.changed.emit()
	elif float(G.S["woodpile"]) + 0.0001 < need:
		G.say(tr("🪵 No wood to stoke with: gather sticks at the Field Edge, or bring straw or logs."))
	return added

# ------------------------------------------------------------------ the recipe as a chore

## Making a recipe at its station is the chore "recipe" of the actions system, with args {"rid"} (and {"n"}: how many loads, when the caller fixes it;
## without it a tap makes the biggest load the farmer can pay for, at most recipe_batch). What it costs is read from the recipe (recipes.json) here
## and nowhere else: the energy through the chore's profile (the recipe's own category and station), the inputs and the water as extra costs.
## The fuel is the woodpile's, not an item: it is checked here and taken in `before`.
func register_chores() -> void:
	G.actions.register("recipe", _recipe_effect, _recipe_requires, _recipe_amount, _recipe_extra, Callable(), _recipe_profile, _recipe_before)

func _recipe_profile(_who, args: Dictionary) -> Dictionary:
	var r = G.recipes[args["rid"]]
	return {"base": {"energy": float(r["energy"])} if float(r.get("energy", 0)) > 0.0 else {}, "cat": recipe_cat(args["rid"]), "station": chain_root(r["station"]),
		"slack": 0.0001}       # the old recipe check let a hair less energy through than the other chores did (0.0001, not 0.001); kept so the golden runs stay identical

## How many loads this call makes (carrying gear: a bigger load when there is enough for it, else as much as there is).
func _recipe_amount(who, args: Dictionary) -> float:
	if args.has("n"): return float(args["n"])
	var n := recipe_batch(args["rid"])
	while n > 1 and not G.pace.missing_cost(G.actions.effective_cost("recipe", who, _with_n(args, n))).is_empty(): n -= 1
	return float(n)

func _with_n(args: Dictionary, n: int) -> Dictionary:
	var a := args.duplicate()
	a["n"] = n
	return a

## The inputs (the skill family saves some) and the water, for the loads of this call; the base is what they cost before skills and upgrades.
func _recipe_extra(who, args: Dictionary) -> Dictionary:
	var r = G.recipes[args["rid"]]
	var b := _recipe_amount(who, args)
	var cost := {}
	var base := {}
	var fam: String = G.skills.family_of_station(r["station"])
	for k in r.get("inputs", {}):
		cost[k] = float(r["inputs"][k]) * G.m("in:" + r["station"] + ":" + k) * G.skills.input_mult(fam) * b
		base[k] = float(r["inputs"][k]) * b
	if float(r.get("water", 0)) > 0.0:
		cost["water"] = float(r["water"]) * b
		base["water"] = float(r["water"]) * b
	return {"cost": cost, "base": base}

## In the order the old code asked: not open, the spot still refilling, the station busy, what is kept, what is missing, the fuel. (The energy comes last, from the module.)
func _recipe_requires(who, args: Dictionary) -> Array:
	var rid: String = args["rid"]
	var r = G.recipes[rid]
	if not recipe_open(rid): return [{"key": "locked", "text": tr("🔒 Not yet.")}]
	var root := chain_root(r["station"])
	var now := output_now(root)
	if now and recipe_left(rid) > 0.0: return [{"key": "refill", "text": tr("⏳ That spot needs a question to refill.")}]
	if (G.S["running"].get(root, []) as Array).size() >= station_slots(root):
		if now: return [{"key": "busy", "text": tr("⏳ You have gathered all you can for now. Answer a Time Quiz question.")}]
		return [{"key": "busy", "text": tr("⏳ %s is busy. Answer Time Quiz questions to finish the batch.") % G.nodes[active_of(root)]["name"]}]
	var out := []
	for k in r.get("keeps", []):
		if G.inventory.count(k) < 1.0:
			out.append({"key": "keeps", "text": tr("Needs %s %s (kept, not used up).") % [G.iemoji(k), G.iname(k)]})
			break
	var cost := G.actions.effective_cost("recipe", who, args)
	cost.erase("energy")        # being too tired is the module's to say
	var miss := G.pace.missing_cost(cost)
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %d more" % [G.iemoji(x["key"]), G.up(float(x["need"]) - float(x["have"]))])
		out.append({"key": "missing", "text": tr("Missing: ") + ", ".join(parts)})
	var fuel := recipe_fuel(rid)
	if fuel > 0.0 and float(G.S["woodpile"]) + 0.0001 < fuel:
		out.append({"key": "fuel", "text": tr("🪵 Stoke the woodpile first: this needs %d fuel, the woodpile has %d.") % [G.up(fuel), G.down(G.S["woodpile"])]})
	return out

## Everything is there. Fix the loads now (what is taken changes what could be paid), take the fuel, let a bad plant from the forest strike
## (the farmer collapses and nothing else is spent: TODO S3), and start counting the grades of the inputs that are used up.
func _recipe_before(who, args: Dictionary, cost: Dictionary) -> Dictionary:
	if not args.has("n"): args["n"] = int(_recipe_amount(who, args))
	var fuel := recipe_fuel(args["rid"])
	if fuel > 0.0: G.S["woodpile"] = float(G.S["woodpile"]) - fuel
	if G.forest.poisons(cost): return {"key": "poisoned", "message": ""}
	G.inventory.start_track()
	return {}

## The grade is rolled from the inputs used up; the skill practises and the polish wears before the batch's time is worked out (a rank gained
## now makes this batch quicker, as before), so those two are done here and not by the module's follow-ups.
func _recipe_effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var rid: String = args["rid"]
	var r = G.recipes[rid]
	var n := int(args["n"])
	var root := chain_root(r["station"])
	var running: Array = G.S["running"].get(root, [])
	var now := output_now(root)
	var input_avg := G.inventory.stop_track()          # the grades of the inputs that were used up (-1: none had a grade)
	var grade := G.quality.roll_recipe(rid, input_avg) if makes_graded(rid) else -1
	G.skills.practice(G.skills.family_of_station(r["station"]))
	wear_polish("use:" + recipe_cat(rid))
	var t := recipe_time(rid)
	if t <= 0.0:
		_recipe_out(rid, n, grade)
	elif now:
		_recipe_out(rid, n, grade)                 # gathered right away; the spot refills over the next question(s)
		running.append({"recipe": rid, "left": t, "cool": true})
		G.S["running"][root] = running
	else:
		running.append({"recipe": rid, "left": t, "n": n, "grade": grade})
		G.S["running"][root] = running
		G.say((tr("⏳ %s: ready in %d question.") if G.up(t) == 1 else tr("⏳ %s: ready in %d questions.")) % [r.get("name", G.iname(r["outputs"].keys()[0])), G.up(t)])
	G.rewards.job_progress("make", rid, 1.0)
	return {"gained": {}}

## Does a recipe make something that has a grade (a dish, an ingredient, a craft, cloth)?
func makes_graded(rid: String) -> bool:
	for k in G.recipes[rid]["outputs"]:
		if G.quality.graded(k): return true
	return false

func _recipe_out(rid: String, n := 1, grade := -1) -> void:
	var r = G.recipes[rid]
	var got := []
	var arrived := {}
	for k in r["outputs"]:
		var q := float(r["outputs"][k]) * G.m("out:" + r["station"]) * float(n)
		var gm = G.seasons.smod("gather", {})
		if typeof(gm) == TYPE_DICTIONARY and gm.has(rid): q *= float(gm[rid])
		q = G.nature.scaled(rid, q)         # a thin forest edge gives less (never less than 1)
		q = G.inventory.add_item(k, q, false, grade)
		arrived[k] = q
		got.append("%s%d" % [G.iemoji(k), G.down(q)])
	G.nature.took(rid, float(n))
	var shown_grade := "  " + G.quality.stars(grade if grade >= 0 else G.quality.default_grade()) if makes_graded(rid) else ""
	G.say(tr("✨ %s ready: %s") % [str(r.get("name", G.iname(r["outputs"].keys()[0]))), " ".join(got)] + shown_grade)
	G.inventory.emit_gained("recipe:" + rid, arrived)

## Stations whose output comes at once (gathering at the field edge): each recipe then rests for its time.
func output_now(root: String) -> bool:
	return bool(G.nodes.get(root, {}).get("outputNow", false))

## Questions until a recipe is ready (cooking) or its spot has refilled (gathering); 0 = not running.
func recipe_left(rid: String) -> float:
	var root := chain_root(G.recipes[rid]["station"])
	var left := 0.0
	for job in G.S["running"].get(root, []):
		if job["recipe"] == rid: left = maxf(left, float(job["left"]))
	return left

func tick_stations(_info := {}) -> void:
	for root in G.S["running"].keys():
		var arr: Array = G.S["running"][root]
		var keep := []
		for job in arr:
			job["left"] = float(job["left"]) - 1.0
			if float(job["left"]) <= 0.0001:
				if not job.get("cool", false): _recipe_out(job["recipe"], int(job.get("n", 1)), int(job.get("grade", -1)))
			else: keep.append(job)
		G.S["running"][root] = keep

# ------------------------------------------------------------------ polish

func polish_level(pid: String) -> float:
	return float(G.S["polish"].get(pid, 0.0))

func polish_open(pid: String) -> bool:
	return G.satisfied(G.nodes[pid]["target"])

func polish_cost(pid: String) -> Dictionary:
	var f := 1.0 + floorf(polish_level(pid))
	var out := {}
	var raw: Dictionary = G.nodes[pid].get("cost", {})
	for k in raw:
		var v := float(raw[k]) * f
		if k == "energy": v = G.needs.ecost("craft", v)
		out[k] = v
	return out

func polish_gain(pid: String, p: float) -> float:
	return 1.0 - pow(0.5, p)

func do_polish(pid: String) -> bool:
	if not polish_open(pid): return false
	var c := polish_cost(pid)
	var miss := G.pace.missing_cost(c)
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %d more" % [G.iemoji(x["key"]), G.up(float(x["need"]) - float(x["have"]))])
		G.say(tr("Missing: ") + ", ".join(parts)); return false
	G.pace.pay(c)
	# some polish also brings something in ("gives", growing like the cost): rooting out weeds gives plant fibre
	var f := 1.0 + floorf(polish_level(pid))
	var gv: Dictionary = G.nodes[pid].get("gives", {})
	var got := {}
	for k in gv: got[k] = G.inventory.add_item(k, float(gv[k]) * f, true)
	if not got.is_empty(): G.inventory.emit_gained("node:" + pid, got)
	G.S["polish"][pid] = polish_level(pid) + 1.0
	G.invalidate_caps()
	var gtxt := []
	for k in got: gtxt.append("%s%d" % [G.iemoji(k), G.down(got[k])])
	G.say(tr("✨ %s (%d%% of the full effect now)%s") % [G.nodes[pid]["name"], int(round(polish_gain(pid, polish_level(pid)) * 100.0)), ("  +" + " ".join(gtxt)) if not gtxt.is_empty() else ""])
	G.S["unlocked"][pid] = true
	G.save_game(); G.changed.emit()
	return true

func wear_polish(kind: String) -> void:
	for pid in G.S["polish"].keys():
		var w = G.nodes[pid].get("wear", {})
		if w.get("per", "") != kind: continue
		G.S["polish"][pid] = maxf(0.0, polish_level(pid) - float(w.get("amount", 0.0)) * G.m("wear"))
	G.invalidate_caps()

# ------------------------------------------------------------------ one Time Quiz answer

func tick_home_fuel(_info := {}) -> void:
	if G.seasons.season() != "winter":
		G.S["cold"] = false
		return
	var need := G.g("homeFuel", 0.2) * G.m("homeFuel") * G.m("fuel")
	auto_stack(need)
	if float(G.S["woodpile"]) + 0.0001 >= need:
		G.S["woodpile"] = float(G.S["woodpile"]) - need
		if G.S["cold"]: G.say(tr("🔥 The house is warm again."))
		G.S["cold"] = false
	else:
		if not G.S["cold"]: G.say(tr("❄️🏠 The house is cold: no firewood! Rest gives less energy. Stack sticks or logs on the woodpile."))
		G.S["cold"] = true
