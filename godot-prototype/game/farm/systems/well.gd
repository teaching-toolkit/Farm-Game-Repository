extends RefCounted
class_name FarmWell
## Wellbeing (TODO L1–L8, design document 5.1b): six parameters (sleep, food, strength, friends, calm, play), each 0–1, that move slowly
## towards what the farm gives them. They are a dial on the energy maximum and on the energy per Rest answer, and they set the energy
## change per question (a drain that grows with the load of the farm, a boost after helping someone). Frozen until chapter 2.
## Data: data/farm/rules/55-well.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"well": {"v": {}, "eaten": [], "boost_until": 0, "last_delta": 0.0, "party_step": -999, "invite": ""}}

func data() -> Dictionary:
	return G.meta.get("well", {})

func params() -> Array:
	return (data().get("params", {}) as Dictionary).keys()

func active() -> bool:
	return G.chapter() >= int(data().get("fromChapter", 2))

## The parameter's value now (0.5 until it has moved).
func value(p: String) -> float:
	return float(G.S["well"]["v"].get(p, float(data().get("start", 0.5))))

## What the parameter is heading for.
func target(p: String) -> float:
	var sp: Dictionary = data().get("params", {}).get(p, {})
	var t := float(sp.get("floor", 0.5))
	if sp.has("stat"): t += G.g(str(sp["stat"]), 0.0)
	if sp.has("dishes"): t += float(sp["dishes"]) * float(distinct_dishes())
	if sp.has("ranks"): t += float(sp["ranks"]) * float(G.skills.total_ranks())
	if sp.has("friend"): t += float(sp["friend"]) * float(G.rewards.friends().size())
	if sp.has("reputation"): t += float(sp["reputation"]) * float(G.trust.reputation())
	if sp.has("load"): t += float(sp["load"]) * farm_load()
	return clampf(t, 0.0, 1.0)

func distinct_dishes() -> int:
	var seen := {}
	for k in G.S["well"]["eaten"]: seen[k] = true
	return seen.size()

## How much runs on the farm, 0 … 1: patches, animals and producing buildings.
func farm_load() -> float:
	var x := float(G.progression.plots())
	for a in ["orchard", "gh"]: x += float(G.fields.area(a).size())
	for aid in G.animal_ids: x += 2.0 * float(G.animals.animal(aid)["count"])
	for id in G.S["unlocked"]:
		if G.nodes.has(id) and not G.superseded(id): x += 2.0 * float(G.lord.building_level(id))
	return x / (x + float(data().get("loadHalf", 30)))

## Eating a dish (the variety of what was eaten lately feeds the food parameter).
func ate(k: String) -> void:
	var e: Array = G.S["well"]["eaten"]
	e.append(k)
	while e.size() > int(data().get("dishWindow", 6)): e.pop_front()

## Helping someone (a favour, a delivery): the next few questions give a little energy.
func helped() -> void:
	if not active(): return
	G.S["well"]["boost_until"] = int(G.S["step"]) + int(data().get("boost", {}).get("questions", 6))

# ------------------------------------------------------------------ the outputs

func mood() -> float:
	return (value("friends") + value("calm") + value("play")) / 3.0

func overall() -> float:
	var t := 0.0
	for p in params(): t += value(p)
	return t / float(maxi(1, params().size()))

func face() -> String:
	var o := overall()
	for f in data().get("faces", []):
		if o >= float(f[0]): return str(f[1])
	return "😐"

func _dial(x: float) -> float:
	return float(data().get("dialLow", 0.7)) + float(data().get("dialSpan", 0.6)) * x

func max_mult() -> float:
	if not active(): return 1.0
	return _dial((value("food") + value("strength")) / 2.0)

func rest_mult() -> float:
	if not active(): return 1.0
	return _dial(value("sleep"))

## The energy lost to the weight of the farm in one question (before the boost).
func drain() -> float:
	if not active(): return 0.0
	var m := mood()
	return farm_load() * (1.0 - m) * (1.0 - m) * float(data().get("maxDrainSums", 1.5)) * G.needs.rest_per_answer()

func boost() -> float:
	if not active() or int(G.S["well"]["boost_until"]) <= int(G.S["step"]): return 0.0
	return float(data().get("boost", {}).get("sums", 0.2)) * G.needs.rest_per_answer()

# ------------------------------------------------------------------ a party and a visit

## Moves some parameters up at once (they sink back at the usual pace).
func _bump(b: Dictionary) -> void:
	for p in b: G.S["well"]["v"][p] = clampf(value(p) + float(b[p]), 0.0, 1.0)

## The dishes in the store that could be shared at a party (the cheapest first).
func _party_dishes() -> Array:
	var ds := []
	for k in G.S["inv"]:
		if G.items.has(k) and G.items[k].get("category", "") == "dish" and G.inventory.count(k) >= 1.0: ds.append(k)
	ds.sort_custom(func(a, b): return float(G.items[a].get("value", 0)) < float(G.items[b].get("value", 0)))
	return ds

func party_cooldown_left() -> int:
	return maxi(0, int(G.S["well"]["party_step"]) + int(data().get("party", {}).get("cooldown", 20)) - int(G.S["step"]))

## The chores of a party and a visit in the actions system (rules/46-chores.json): their cost and the check are there, the effects are here.
func register_chores() -> void:
	G.actions.register("throw_party", _party_effect, _party_requires, Callable(), _party_extra)
	G.actions.register("visit_friend", _visit_effect, _visit_requires)

## The dishes a party shares: the cheapest in the store, as many as the party needs.
func _party_extra(_who, _args: Dictionary) -> Dictionary:
	var need := int(data().get("party", {}).get("dishes", 3))
	var cost := {}
	for k in _party_dishes():
		var c := G.inventory.count(k)
		while need > 0 and c >= 1.0:
			cost[k] = float(cost.get(k, 0.0)) + 1.0
			c -= 1.0
			need -= 1
	return {"cost": cost, "base": cost}

func _party_requires(_who, _args: Dictionary) -> Array:
	var d: Dictionary = data().get("party", {})
	if party_cooldown_left() > 0: return [{"key": "cooldown", "text": tr("The last party was not long ago.")}]
	var have := 0
	for k in _party_dishes(): have += int(G.inventory.count(k))
	if have < int(d.get("dishes", 3)): return [{"key": "dishes", "text": tr("A party needs %d dishes to share.") % int(d.get("dishes", 3))}]
	return []

func _party_effect(_who, _args: Dictionary, _cost: Dictionary) -> Dictionary:
	G.S["well"]["party_step"] = int(G.S["step"])
	_bump(data().get("party", {}).get("bump", {}))
	helped()
	G.say(tr("🎉 A party at the farm! Everybody laughs, eats and dances. You feel lighter."))
	return {"gained": {}}

## The friend who has invited you ("" if nobody has).
func invite() -> String:
	return str(G.S["well"].get("invite", ""))

func _visit_requires(_who, _args: Dictionary) -> Array:
	if invite() == "": return [{"key": "no_invite", "text": tr("Nobody has invited you.")}]
	return []

## The walk to the neighbour costs the energy (and nothing else); the one question on the way is asked by the interface (like the market trip).
func _visit_effect(_who, _args: Dictionary, _cost: Dictionary) -> Dictionary:
	return {"gained": {}}

## The question was answered: the visit happens. Returns the little scene to show.
func visited() -> String:
	var v: Dictionary = data().get("visit", {})
	var nm := invite()
	G.S["well"]["invite"] = ""
	_bump(v.get("bump", {}))
	helped()
	var scenes: Array = v.get("messages", [""])
	G.save_game(); G.changed.emit()
	return tr(str(scenes[G.rng.randi() % scenes.size()])).replace("{name}", nm)

# ------------------------------------------------------------------ one question

func step(info: Dictionary) -> void:
	if not active(): return
	if invite() == "" and G.rng.randf() < float(data().get("visit", {}).get("chance", 0.04)):      # a friend asks you to visit
		var fr: Array = G.rewards.friends()
		if not fr.is_empty():
			G.S["well"]["invite"] = str(fr[G.rng.randi() % fr.size()]["name"])
			G.say(tr("💌 %s has invited you for a visit! (Tap your face to see.)") % G.S["well"]["invite"])
	var v: Dictionary = G.S["well"]["v"]
	for p in params():
		var cur := value(p)
		var t := target(p)
		if t > cur: cur = minf(t, cur + float(data().get("up", 0.015)))
		else: cur = maxf(t, cur - float(data().get("down", 0.01)))
		v[p] = cur
	var e := float(G.S["energy"])
	var d := boost() - (drain() if e > 0.0 else 0.0)
	G.S["energy"] = clampf(e + d, 0.0, G.needs.energy_max())
	G.S["well"]["last_delta"] = float(G.S["energy"]) - e
	if absf(d) > 0.0001: info["well_delta"] = float(G.S["energy"]) - e
