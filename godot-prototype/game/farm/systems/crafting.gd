extends RefCounted
## Crafting: stations and their chains, recipes, batches, the woodpile and fuel. (Kit to be: crafting & skills.)
## Split out of game.gd in R4 (12 Oct 2026). Everything else of the game is reached through G, the front door
## (the Game autoload), which still answers to every function name, so callers did not change.

var G

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
	for mmb in G.chain_members(root):
		if G.done(mmb): act = mmb
	return act

func stations() -> Array:
	var out := []
	var seen := {}
	for id in G.nodes:
		if G.nodes[id]["type"] != "station" and not G.station_recipes.has(id): continue
		var r = G.chain_root(id)
		if seen.has(r): continue
		seen[r] = true
		if G.active_of(r) != "": out.append(r)
	return out

func station_slots(root: String) -> int:
	var act = G.active_of(root)
	if act == "": return 0
	var s = int(G.nodes[act].get("slots", 1))
	for mmb in G.chain_members(root): s += int(round(G.g("slots:" + mmb, 0.0)))
	if act.begins_with("windmill"): s = maxi(s, int(round(G.g("autoMill", 1.0))) * 2)
	return s

func station_recipes_for(root: String) -> Array:
	var out := []
	for mmb in G.chain_members(root):
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
	if not (G.recipe_cat(rid) in G.CARRY_CATS): return 1
	return 1 + maxi(0, int(round(G.g("carry", 0.0))))

## A recipe's cost for n loads at once (n < 0: the batch one tap makes, recipe_batch).
func recipe_cost(rid: String, n := -1) -> Dictionary:
	var r = G.recipes[rid]
	var b = float(G.recipe_batch(rid) if n < 0 else n)
	var c := {}
	for k in r.get("inputs", {}):
		c[k] = float(r["inputs"][k]) * G.m("in:" + r["station"] + ":" + k) * b
	var e = G.ecost(G.recipe_cat(rid), float(r.get("energy", 0)), G.chain_root(r["station"])) * b
	if e > 0.0: c["energy"] = e
	if float(r.get("water", 0)) > 0.0: c["water"] = float(r["water"]) * b
	return c

## A recipe's cost before upgrades (see node_cost_base), for the same batch.
func recipe_cost_base(rid: String) -> Dictionary:
	var r = G.recipes[rid]
	var b = float(G.recipe_batch(rid))
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
	return float(r.get("time", 0)) * G.m("time:" + r["station"])

func woodpile_cap() -> float:
	return G.g("woodpileCap", 20.0)

func fuel_value(k: String) -> float:
	return float(G.meta.get("fuel", {}).get("values", {}).get(k, 0.0))

func stack_wood(k: String, q: float) -> float:
	var v = G.fuel_value(k)
	if v <= 0.0: return 0.0
	var room = G.woodpile_cap() - float(G.S["woodpile"])
	var n = minf(q, minf(G.count(k), floorf(room / v)))
	if n <= 0.0: return 0.0
	G.take(k, n)
	G.S["woodpile"] = float(G.S["woodpile"]) + n * v
	return n

func auto_stack(need: float) -> void:
	for k in G.meta.get("fuel", {}).get("stackOrder", ["stick", "straw", "log"]):
		if float(G.S["woodpile"]) + 0.0001 >= need: return
		var v = G.fuel_value(k)
		if v <= 0.0: continue
		var missing = need - float(G.S["woodpile"])
		G.stack_wood(k, ceilf(missing / v))

## Fuel that could still go on the woodpile from what is in store (sticks, straw, logs …), up to its room.
func fuel_in_store() -> float:
	var f := 0.0
	for k in G.meta.get("fuel", {}).get("stackOrder", ["stick", "straw", "log"]): f += G.count(k) * G.fuel_value(k)
	return minf(f, G.woodpile_cap() - float(G.S["woodpile"]))

## Stoking: puts enough wood on the woodpile for need fuel (sticks first, then straw, then logs). Stoves, ovens, kilns
## and the forge only burn what is on the woodpile, so the woodpile is stoked first. Returns the fuel added.
func stoke(need: float) -> float:
	var before = float(G.S["woodpile"])
	var had := {}
	for k in G.meta.get("fuel", {}).get("stackOrder", ["stick", "straw", "log"]): had[k] = G.count(k)
	G.auto_stack(need)
	var parts := []
	for k in had:
		var used = float(had[k]) - G.count(k)
		if used > 0.0: parts.append("%d %s" % [int(round(used)), G.iname(k)])
	var added = float(G.S["woodpile"]) - before
	if added > 0.0:
		G.say(tr("🪵 Stoked the woodpile: %s.") % ", ".join(parts))
		G.save_game(); G.changed.emit()
	elif float(G.S["woodpile"]) + 0.0001 < need:
		G.say(tr("🪵 No wood to stoke with: gather sticks at the Field Edge, or bring straw or logs."))
	return added

func start_recipe(rid: String) -> bool:
	var r = G.recipes[rid]
	if not G.recipe_open(rid): G.say(tr("🔒 Not yet.")); return false
	var root = G.chain_root(r["station"])
	var running: Array = G.S["running"].get(root, [])
	var now = G.output_now(root)
	if now and G.recipe_left(rid) > 0.0: G.say(tr("⏳ That spot needs a question to refill.")); return false
	if running.size() >= G.station_slots(root):
		if now: G.say(tr("⏳ You have gathered all you can for now. Answer a Time Quiz question."))
		else: G.say(tr("⏳ %s is busy. Answer Time Quiz questions to finish the batch.") % G.nodes[G.active_of(root)]["name"])
		return false
	for k in r.get("keeps", []):
		if G.count(k) < 1.0: G.say(tr("Needs %s %s (kept, not used up).") % [G.iemoji(k), G.iname(k)]); return false
	# a bigger load (carrying gear) when there is enough for it, else as much as there is
	var n = G.recipe_batch(rid)
	while n > 1 and not G.missing_cost(G.recipe_cost(rid, n)).is_empty(): n -= 1
	var c = G.recipe_cost(rid, n)
	var miss = G.missing_cost(c)
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %d more" % [G.iemoji(x["key"]), G.up(float(x["need"]) - float(x["have"]))])
		G.say(tr("Missing: ") + ", ".join(parts)); return false
	var fuel = G.recipe_fuel(rid)
	if fuel > 0.0:
		if float(G.S["woodpile"]) + 0.0001 < fuel:
			G.say(tr("🪵 Stoke the woodpile first: this needs %d fuel, the woodpile has %d.") % [G.up(fuel), G.down(G.S["woodpile"])]); return false
		G.S["woodpile"] = float(G.S["woodpile"]) - fuel
	G.pay(c)
	G.S["practice"][root] = int(G.S["practice"].get(root, 0)) + 1
	G._wear("use:" + G.recipe_cat(rid))
	var t = G.recipe_time(rid)
	if t <= 0.0:
		G._recipe_out(rid, n)
	elif now:
		G._recipe_out(rid, n)                 # gathered right away; the spot refills over the next question(s)
		running.append({"recipe": rid, "left": t, "cool": true})
		G.S["running"][root] = running
	else:
		running.append({"recipe": rid, "left": t, "n": n})
		G.S["running"][root] = running
		G.say((tr("⏳ %s: ready in %d question.") if G.up(t) == 1 else tr("⏳ %s: ready in %d questions.")) % [r.get("name", G.iname(r["outputs"].keys()[0])), G.up(t)])
	G._job("make", rid, 1.0)
	var hit := false
	for th in G.meta.get("practice", {}).get("thresholds", []):
		if int(th) == int(G.S["practice"][root]): hit = true
	if hit:
		G.say(tr("⭐ Practice star at %s: its recipes now cost less energy.") % G.nodes[G.active_of(root)]["name"])
	G.save_game(); G.changed.emit()
	return true

func _recipe_out(rid: String, n := 1) -> void:
	var r = G.recipes[rid]
	var got := []
	var arrived := {}
	for k in r["outputs"]:
		var q = float(r["outputs"][k]) * G.m("out:" + r["station"]) * float(n)
		var gm = G.smod("gather", {})
		if typeof(gm) == TYPE_DICTIONARY and gm.has(rid): q *= float(gm[rid])
		q = G.add_item(k, q)
		arrived[k] = q
		got.append("%s%d" % [G.iemoji(k), G.down(q)])
	G.say(tr("✨ %s ready: %s") % [str(r.get("name", G.iname(r["outputs"].keys()[0]))), " ".join(got)])
	G._gained("recipe:" + rid, arrived)

## Stations whose output comes at once (gathering at the field edge): each recipe then rests for its time.
func output_now(root: String) -> bool:
	return bool(G.nodes.get(root, {}).get("outputNow", false))

## Questions until a recipe is ready (cooking) or its spot has refilled (gathering); 0 = not running.
func recipe_left(rid: String) -> float:
	var root = G.chain_root(G.recipes[rid]["station"])
	var left := 0.0
	for job in G.S["running"].get(root, []):
		if job["recipe"] == rid: left = maxf(left, float(job["left"]))
	return left

func _tick_stations() -> void:
	for root in G.S["running"].keys():
		var arr: Array = G.S["running"][root]
		var keep := []
		for job in arr:
			job["left"] = float(job["left"]) - 1.0
			if float(job["left"]) <= 0.0001:
				if not job.get("cool", false): G._recipe_out(job["recipe"], int(job.get("n", 1)))
			else: keep.append(job)
		G.S["running"][root] = keep
