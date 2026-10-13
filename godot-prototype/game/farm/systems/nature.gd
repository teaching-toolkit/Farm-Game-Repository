extends RefCounted
class_name FarmNature
## What the forest edge gives (TODO N1–N5, design document 5.9): sticks, loose stones and clay are pools that fall when gathered and grow
## back slowly; trees go round a cycle (tree → stump → sapling → tree). A tap yields less when its pool is low, never less than 1.
## Data: data/farm/rules/56-nature.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"nature": {"pool": {}, "t": -1.0, "s": 0.0, "p": 0.0, "advice": {}}}

func data() -> Dictionary:
	return G.meta.get("nature", {})

func pools() -> Dictionary:
	return data().get("pools", {})

func pool_of(rid: String) -> String:
	for p in pools():
		if (pools()[p].get("recipes", {}) as Dictionary).has(rid): return p
	return ""

func pool_max(p: String) -> float:
	return float(pools()[p]["max"])

## How much is there now.
func level(p: String) -> float:
	if p == "trees": return trees()
	return float(G.S["nature"]["pool"].get(p, pool_max(p)))

func trees() -> float:
	var t := float(G.S["nature"]["t"])
	return pool_max("trees") if t < 0.0 else t

func stumps() -> float:
	return float(G.S["nature"]["s"])

func saplings() -> float:
	return float(G.S["nature"]["p"])

## 0 … 1: how full the pool is.
func fill(p: String) -> float:
	return clampf(level(p) / pool_max(p), 0.0, 1.0)

## The share of its full yield a tap gives now (never below the pool's floor).
func factor(p: String) -> float:
	return maxf(float(pools()[p].get("floor", 0.5)), fill(p))

## What a tap of this recipe really gives: whole units, at least 1 (the amount q is the full yield).
func scaled(rid: String, q: float) -> float:
	var p := pool_of(rid)
	if p == "" or q <= 0.0: return q
	return maxf(1.0, roundf(q * factor(p)))

## Has the card been learned that shows the numbers (D4: until then they work but are not shown)?
func known() -> bool:
	return G.done("k_regrow")

## Something was gathered by this recipe (n taps): the pool falls, and there may be advice.
func took(rid: String, n := 1.0) -> void:
	var p := pool_of(rid)
	if p == "": return
	var amount := float(pools()[p]["recipes"][rid]) * n
	var s: Dictionary = G.S["nature"]
	if p == "trees":
		var t := trees()
		var felled := minf(t, amount)
		s["t"] = t - felled
		s["s"] = float(s["s"]) + felled
	else:
		s["pool"][p] = maxf(0.0, level(p) - amount)
	_advise(p)

func _advise(p: String) -> void:
	if fill(p) >= float(data().get("adviceBelow", 0.35)): return
	var a: Dictionary = G.S["nature"]["advice"]
	if int(G.S["step"]) - int(a.get(p, -9999)) < int(data().get("adviceEvery", 40)): return
	a[p] = int(G.S["step"])
	G.say("%s %s" % [pools()[p]["emoji"], tr(str(pools()[p]["advice"]))])

## Every question: the pools grow back, stumps become saplings and saplings trees.
func step(_info := {}) -> void:
	var s: Dictionary = G.S["nature"]
	for p in pools():
		if p == "trees": continue
		var cur := level(p)
		if cur < pool_max(p): s["pool"][p] = minf(pool_max(p), cur + float(pools()[p].get("regrow", 0.0)))
	var tr_: Dictionary = pools().get("trees", {})
	if not tr_.is_empty():
		var t := trees()
		var st := float(s["s"])
		var sa := float(s["p"])
		var to_sapling := st / maxf(1.0, float(tr_.get("stumpToSapling", 14)))
		var to_tree := sa / maxf(1.0, float(tr_.get("saplingToTree", 22)))
		s["s"] = st - to_sapling
		s["p"] = sa + to_sapling - to_tree
		s["t"] = minf(pool_max("trees"), t + to_tree)
