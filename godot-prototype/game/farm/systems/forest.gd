extends RefCounted
class_name FarmForest
## The forest (TODO S4, S3: Wren's check and the poisoning; design document 5.10). Opened by the cleared still-room. In the forest every spot has tasks
## that depend on the season: find (the right plant among described ones: a wrong choice brings its look-alike home), pick (the right part), dig, look.
## What is brought home lies in the basket, unchecked: Wren checks it for a small favour, or it is used unchecked and a bad unit in a remedy poisons.
## Data: data/farm/rules/57-forest.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"forest": {"in": false, "basket": [], "rest": {}, "tainted": {}, "trips": 0, "poisoned": 0, "checked": 0}}

func data() -> Dictionary:
	return G.meta.get("forest", {})

func _s() -> Dictionary:
	return G.S["forest"]

func spots() -> Dictionary:
	return data().get("spots", {})

## The forest can be entered once the still-room is cleared.
func open() -> bool:
	return G.done("ruins_stillroom")

func inside() -> bool:
	return bool(_s()["in"])

func enter() -> bool:
	if not open() or inside(): return false
	_s()["in"] = true
	_s()["trips"] = int(_s()["trips"]) + 1
	G.save_game(); G.changed.emit()
	return true

func leave() -> bool:
	if not inside(): return false
	_s()["in"] = false
	G.save_game(); G.changed.emit()
	return true

# ------------------------------------------------------------------ the tasks

func task(spot: String, tid: String) -> Dictionary:
	for t in spots().get(spot, {}).get("tasks", []):
		if t["id"] == tid: return t
	return {}

func in_season(t: Dictionary) -> bool:
	return (t.get("seasons", []) as Array).has(G.seasons.season())

func rest_left(spot: String, tid: String) -> int:
	return maxi(0, int(_s()["rest"].get(spot + ":" + tid, 0)) - int(G.S["step"]))

func pick_energy() -> float:
	return G.needs.ecost("gather", float(data().get("pickEnergy", 2)))

## Can this task be done now? {"ok", "why"}
func can_do(spot: String, tid: String) -> Dictionary:
	var t := task(spot, tid)
	if t.is_empty() or not inside(): return {"ok": false, "why": ""}
	if not in_season(t): return {"ok": false, "why": tr("Not in this season.")}
	if rest_left(spot, tid) > 0: return {"ok": false, "why": tr("It needs a few questions to grow back.")}
	if t["kind"] == "dig" and not G.done(str(t.get("tool", ""))): return {"ok": false, "why": tr("You need a shovel.")}
	if (t["kind"] == "find" or t["kind"] == "pick") and basket().size() >= capacity(): return {"ok": false, "why": tr("Your basket is full.")}
	if float(G.S["energy"]) + 0.001 < pick_energy() and t["kind"] != "look": return {"ok": false, "why": tr("⚡ Too tired. Rest a little (tap ⚡).")}
	return {"ok": true, "why": ""}

func _spend(spot: String, tid: String) -> void:
	var t := task(spot, tid)
	if t["kind"] != "look": G.S["energy"] = float(G.S["energy"]) - pick_energy()
	_s()["rest"][spot + ":" + tid] = int(G.S["step"]) + int(data().get("refill", 4))
	G.skills.practice("healing")

## find: the option chosen is what lands in the basket; the child thinks it is the plant of the task.
func do_find(spot: String, tid: String, option_id: String) -> Dictionary:
	if not can_do(spot, tid)["ok"]: return {"ok": false}
	var t := task(spot, tid)
	_spend(spot, tid)
	basket().append({"claim": str(t["plant"]), "real": option_id})
	G.save_game(); G.changed.emit()
	return {"ok": true, "good": option_id == t["plant"]}

## pick: the right part of the plant lands in the basket; a wrong part is no use (and nothing is picked).
func do_pick(spot: String, tid: String, part: String) -> Dictionary:
	if not can_do(spot, tid)["ok"]: return {"ok": false}
	var t := task(spot, tid)
	_spend(spot, tid)
	var good: bool = part == str(t["part"])
	if good: basket().append({"claim": str(t["plant"]), "real": str(t["plant"])})
	G.save_game(); G.changed.emit()
	return {"ok": true, "good": good}

## dig and look: what they give goes straight into the store (clay, sticks, a crystal).
func do_gives(spot: String, tid: String) -> Dictionary:
	if not can_do(spot, tid)["ok"]: return {"ok": false}
	var t := task(spot, tid)
	_spend(spot, tid)
	var got := {}
	for k in t.get("gives", {}): got[k] = G.inventory.add_item(k, float(t["gives"][k]), true)
	G.inventory.emit_gained("forest:" + spot, got)
	G.save_game(); G.changed.emit()
	return {"ok": true, "got": got}

# ------------------------------------------------------------------ the basket

func basket() -> Array:
	return _s()["basket"]

func capacity() -> int:
	var c := int(data().get("basket", 6))
	for k in data().get("basketBonus", {}):
		if G.done(k): c += int(data()["basketBonus"][k])
	return c

## What the basket looks like to the child: how many of each plant it believes it has picked.
func claimed() -> Dictionary:
	var out := {}
	for e in basket(): out[e["claim"]] = int(out.get(e["claim"], 0)) + 1
	return out

func has_bad() -> bool:
	for e in basket():
		if e["claim"] != e["real"]: return true
	return false

## The small favour Wren asks for: the cheapest dish or remedy in the store, else a few coins, else nothing today (never stuck).
func favour() -> Dictionary:
	var w: Dictionary = data().get("wren", {})
	var best := ""
	for k in G.S["inv"]:
		if not G.items.has(k) or G.inventory.count(k) < 1.0: continue
		if (w.get("cats", []) as Array).has(str(G.items[k].get("category", ""))) and not (G.items[k].get("tags", []) as Array).has("pet-dish"):
			if best == "" or float(G.items[k].get("value", 0)) < float(G.items[best].get("value", 0)): best = k
	if best != "": return {"item": best}
	if float(G.S["coins"]) >= float(w.get("coins", 30)): return {"coins": float(w.get("coins", 30))}
	return {}

## Wren looks through the basket: the right plants go into the store, the wrong ones are thrown out. Returns what she found.
func check() -> Dictionary:
	if basket().is_empty(): return {"good": {}, "bad": []}
	var f := favour()
	if f.has("item"): G.inventory.take(str(f["item"]), 1.0)
	elif f.has("coins"): G.S["coins"] -= float(f["coins"])
	var good := {}
	var bad := []
	for e in basket():
		if e["claim"] == e["real"]:
			good[e["claim"]] = float(good.get(e["claim"], 0.0)) + 1.0
		else: bad.append(e["real"])
	for k in good: G.inventory.add_item(k, float(good[k]), true)
	_s()["basket"] = []
	_s()["checked"] = int(_s()["checked"]) + 1
	G.save_game(); G.changed.emit()
	return {"good": good, "bad": bad, "favour": f}

## No check: everything goes into the store as what it was believed to be; the bad units are remembered.
func use_unchecked() -> void:
	for e in basket():
		G.inventory.add_item(str(e["claim"]), 1.0, true)
		if e["claim"] != e["real"] and e["real"] == "hemlock":      # only the poisonous look-alikes can poison; the harmless ones just spoil a batch's worth
			_s()["tainted"][e["claim"]] = int(_s()["tainted"].get(e["claim"], 0)) + 1
	_s()["basket"] = []
	G.save_game(); G.changed.emit()

# ------------------------------------------------------------------ the poisoning

## A recipe is about to use these things up: if a bad unit is among them, the farmer collapses (returns true: the recipe does not happen).
func poisons(cost: Dictionary) -> bool:
	var tainted: Dictionary = _s()["tainted"]
	if tainted.is_empty(): return false
	for k in cost:
		var t := int(tainted.get(k, 0))
		if t <= 0: continue
		var have := int(G.inventory.count(k))
		var n := int(ceilf(float(cost[k])))
		var p_safe := 1.0
		for i in range(n):
			if have - i <= 0: break
			p_safe *= maxf(0.0, float(have - t - i)) / float(have - i)
		if G.rng.randf() >= p_safe:
			poison()
			return true
	return false

## You wake up in bed: all energy gone, all coins gone, and every job costs double for a few questions.
func poison() -> void:
	var tainted: Dictionary = _s()["tainted"]
	for k in tainted:      # Wren clears out what was bad
		G.inventory.take(k, minf(float(tainted[k]), G.inventory.count(k)))
	_s()["tainted"] = {}
	_s()["in"] = false
	_s()["poisoned"] = int(_s()["poisoned"]) + 1
	G.S["energy"] = 0.0
	G.S["coins"] = 0.0
	var p: Dictionary = data().get("poison", {})
	G.S["buff"] = {"mult": float(p.get("mult", 2.0)), "until": int(G.S["step"]) + int(p.get("questions", 6)), "item": "poison"}
	G.say(tr("🤢 You wake up in bed. Wren stands next to you, grumpy: “What were you thinking?” Your energy and your coins are gone. Everything costs double for a while."))
	G.poisoned.emit()
	G.save_game(); G.changed.emit()
