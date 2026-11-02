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

# ------------------------------------------------------------------ the chores

## The forest's chores in the actions system (rules/46-chores.json): the cost and the check are there, the effects and the requirements are here.
## Going in and out: no args. A task of a spot is "forest_<kind>" (find, pick, dig, look) with args {"spot", "tid"} and, for a find, {"option"} (the
## plant chosen), for a pick {"part"}. The Time Quiz question each way is asked by the interface (like the market trip).
func register_chores() -> void:
	G.actions.register("forest_enter", _enter_effect, _enter_requires)
	G.actions.register("forest_leave", _leave_effect, _leave_requires)
	for kind in ["find", "pick", "dig", "look"]:
		G.actions.register("forest_" + kind, _task_effect, _task_requires)
	G.actions.register("wren_water", _wren_water_effect, _wren_water_requires)

## Wren's chore: fetch her a bucket of water (no args). Its energy and water are written in rules/57-forest.json (forest.wren.chore).
func _wren_water_requires(who, _args: Dictionary) -> Array:
	var need := float(G.actions.call_base("wren_water", who).get("water", 0.0))
	if float(G.S["water"]) + 0.001 < need: return [{"key": "water", "text": tr("💧 Not enough water.")}]
	return []

func _wren_water_effect(_who, _args: Dictionary, _cost: Dictionary) -> Dictionary:
	return {"gained": {}}

func _enter_requires(_who, _args: Dictionary) -> Array:
	if not open(): return [{"key": "closed", "text": ""}]
	if inside(): return [{"key": "inside", "text": ""}]
	return []

func _enter_effect(_who, _args: Dictionary, _cost: Dictionary) -> Dictionary:
	_s()["in"] = true
	_s()["trips"] = int(_s()["trips"]) + 1
	return {"gained": {}}

func _leave_requires(_who, _args: Dictionary) -> Array:
	if not inside(): return [{"key": "outside", "text": ""}]
	return []

func _leave_effect(_who, _args: Dictionary, _cost: Dictionary) -> Dictionary:
	_s()["in"] = false
	return {"gained": {}}

# ------------------------------------------------------------------ the tasks

func task(spot: String, tid: String) -> Dictionary:
	for t in spots().get(spot, {}).get("tasks", []):
		if t["id"] == tid: return t
	return {}

func in_season(t: Dictionary) -> bool:
	return (t.get("seasons", []) as Array).has(G.seasons.season())

func rest_left(spot: String, tid: String) -> int:
	return maxi(0, int(_s()["rest"].get(spot + ":" + tid, 0)) - int(G.S["step"]))

## What stops this task now (read-only): the first unmet requirement. The energy is the module's.
func _task_requires(_who, args: Dictionary) -> Array:
	var spot: String = args["spot"]
	var tid: String = args["tid"]
	var t := task(spot, tid)
	if t.is_empty() or not inside(): return [{"key": "outside", "text": ""}]
	if not in_season(t): return [{"key": "season", "text": tr("Not in this season.")}]
	if rest_left(spot, tid) > 0: return [{"key": "rest", "text": tr("It needs a few questions to grow back.")}]
	if t["kind"] == "dig" and not G.done(str(t.get("tool", ""))): return [{"key": "tool", "text": tr("You need a shovel.")}]
	if (t["kind"] == "find" or t["kind"] == "pick") and basket().size() >= capacity(): return [{"key": "basket_full", "text": tr("Your basket is full.")}]
	return []

## The task is done: the spot rests; a find brings home the option chosen (the child thinks it is the plant of the task), a pick the right
## part of the plant (a wrong part is no use and nothing is picked), a dig or a look gives straight into the store (clay, sticks, a crystal).
## The result says whether the choice was right.
func _task_effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var spot: String = args["spot"]
	var tid: String = args["tid"]
	var t := task(spot, tid)
	_s()["rest"][spot + ":" + tid] = int(G.S["step"]) + int(data().get("refill", 4))
	match str(t["kind"]):
		"find":
			basket().append({"claim": str(t["plant"]), "real": str(args["option"])})
			return {"gained": {}, "result": {"good": str(args["option"]) == str(t["plant"])}}
		"pick":
			var good: bool = str(args["part"]) == str(t["part"])
			if good: basket().append({"claim": str(t["plant"]), "real": str(t["plant"])})
			return {"gained": {}, "result": {"good": good}}
	var got := {}
	for k in t.get("gives", {}): got[k] = G.inventory.add_item(k, float(t["gives"][k]), true)
	G.inventory.emit_gained("forest:" + spot, got)
	return {"gained": got}

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

## The small favour Wren asks for, worth about forest.wren.worth (bronze); never coins (farm-actions/14):
##   {"items": {item: units}}  dishes or remedies worth at most forest.wren.maxWorth from the store whose value comes closest to that worth (the closest one first, then more
##                             units only while the sum comes closer: several cheap ones may go together);
##   {"chore": "wren_water"}   else fetch her a bucket of water, a chore of about that worth, if it can be done now;
##   {}                        else she checks for nothing today (never stuck).
func favour() -> Dictionary:
	var w: Dictionary = data().get("wren", {})
	var worth := float(w.get("worth", 30))
	var most := float(w.get("maxWorth", INF))      # nothing dearer: no cheese board or fresh remedy for a tiny favour (farm-actions/17)
	var have := {}
	for k in G.S["inv"]:
		if not G.items.has(k) or G.inventory.count(k) < 1.0: continue
		if float(G.items[k].get("value", 0)) > most + 0.001: continue
		if (w.get("cats", []) as Array).has(str(G.items[k].get("category", ""))) and not (G.items[k].get("tags", []) as Array).has("pet-dish"):
			have[k] = int(floorf(G.inventory.count(k) + 0.0001))
	if not have.is_empty():
		var take := {}
		var sum := 0.0
		while true:
			var best := ""
			var best_gap := INF
			for k in have:
				if int(take.get(k, 0)) >= int(have[k]): continue
				var gap := absf(sum + float(G.items[k].get("value", 0)) - worth)
				if gap < best_gap - 0.001 or (absf(gap - best_gap) <= 0.001 and float(G.items[k].get("value", 0)) < float(G.items[best].get("value", 0))):
					best = k; best_gap = gap
			if best == "" or (not take.is_empty() and best_gap >= absf(sum - worth) - 0.001): break
			take[best] = int(take.get(best, 0)) + 1
			sum += float(G.items[best].get("value", 0))
		return {"items": take}
	if G.actions.check("wren_water", G.actions.farmer)["ok"]: return {"chore": "wren_water"}
	return {}

## Wren looks through the basket: the right plants go into the store, the wrong ones are thrown out. Returns what she found.
func check() -> Dictionary:
	if basket().is_empty(): return {"good": {}, "bad": []}
	var f := favour()
	if f.has("items"):
		for k in f["items"]: G.inventory.take(str(k), float(f["items"][k]))
	var good := {}
	var bad := []
	for e in basket():
		if e["claim"] == e["real"]:
			good[e["claim"]] = float(good.get(e["claim"], 0.0)) + 1.0
		else: bad.append(e["real"])
	for k in good: G.inventory.add_item(k, float(good[k]), true)
	_s()["basket"] = []
	_s()["checked"] = int(_s()["checked"]) + 1
	if f.has("chore"):      # the bucket last, with the basket already empty: perform saves and redraws
		if not G.actions.perform(str(f["chore"]), G.actions.farmer)["done"]: f = {}
		return {"good": good, "bad": bad, "favour": f}
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
