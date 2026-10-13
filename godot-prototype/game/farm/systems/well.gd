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
	return {"well": {"v": {}, "eaten": [], "boost_until": 0, "last_delta": 0.0}}

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

# ------------------------------------------------------------------ one question

func step(info: Dictionary) -> void:
	if not active(): return
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
