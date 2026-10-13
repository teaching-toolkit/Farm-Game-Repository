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

## A recipe's cost for n loads at once (n < 0: the batch one tap makes, recipe_batch).
func recipe_cost(rid: String, n := -1) -> Dictionary:
	var r = G.recipes[rid]
	var b := float(recipe_batch(rid) if n < 0 else n)
	var c := {}
	var fam: String = G.skills.family_of_station(r["station"])
	for k in r.get("inputs", {}):
		c[k] = float(r["inputs"][k]) * G.m("in:" + r["station"] + ":" + k) * G.skills.input_mult(fam) * b
	var e := G.needs.ecost(recipe_cat(rid), float(r.get("energy", 0)), chain_root(r["station"])) * b
	if e > 0.0: c["energy"] = e
	if float(r.get("water", 0)) > 0.0: c["water"] = float(r["water"]) * b
	return c

## A recipe's cost before upgrades (see node_cost_base), for the same batch.
func recipe_cost_base(rid: String) -> Dictionary:
	var r = G.recipes[rid]
	var b := float(recipe_batch(rid))
	var c := {}
	for k in r.get("inputs", {}): c[k] = float(r["inputs"][k]) * b
	if float(r.get("energy", 0)) > 0.0: c["energy"] = float(r["energy"]) * b
	if float(r.get("water", 0)) > 0.0: c["water"] = float(r["water"]) * b
	return c

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

func start_recipe(rid: String) -> bool:
	var r = G.recipes[rid]
	if not recipe_open(rid): G.say(tr("🔒 Not yet.")); return false
	var root := chain_root(r["station"])
	var running: Array = G.S["running"].get(root, [])
	var now := output_now(root)
	if now and recipe_left(rid) > 0.0: G.say(tr("⏳ That spot needs a question to refill.")); return false
	if running.size() >= station_slots(root):
		if now: G.say(tr("⏳ You have gathered all you can for now. Answer a Time Quiz question."))
		else: G.say(tr("⏳ %s is busy. Answer Time Quiz questions to finish the batch.") % G.nodes[active_of(root)]["name"])
		return false
	for k in r.get("keeps", []):
		if G.inventory.count(k) < 1.0: G.say(tr("Needs %s %s (kept, not used up).") % [G.iemoji(k), G.iname(k)]); return false
	# a bigger load (carrying gear) when there is enough for it, else as much as there is
	var n := recipe_batch(rid)
	while n > 1 and not G.pace.missing_cost(recipe_cost(rid, n)).is_empty(): n -= 1
	var c := recipe_cost(rid, n)
	var miss := G.pace.missing_cost(c)
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %d more" % [G.iemoji(x["key"]), G.up(float(x["need"]) - float(x["have"]))])
		G.say(tr("Missing: ") + ", ".join(parts)); return false
	var fuel := recipe_fuel(rid)
	if fuel > 0.0:
		if float(G.S["woodpile"]) + 0.0001 < fuel:
			G.say(tr("🪵 Stoke the woodpile first: this needs %d fuel, the woodpile has %d.") % [G.up(fuel), G.down(G.S["woodpile"])]); return false
		G.S["woodpile"] = float(G.S["woodpile"]) - fuel
	G.inventory.start_track()
	G.pace.pay(c)
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
	G.save_game(); G.changed.emit()
	return true

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
