extends RefCounted
class_name FarmNature
## What the forest edge and the clay pit at the pond give (TODO N1–N5, design document 5.9): sticks, loose stones and clay are pools that fall when gathered and grow
## back slowly; trees go round a cycle (tree → stump → sapling → tree). A tap yields less when its pool is low, never less than 1.
## When the advice is ignored and a pool falls far below it, the Helper whose chore draws on that pool rests from it until the pool is back (N5):
## `pause_of` is the one question the pets ask. Helpers never leave; the farmer is never stopped.
## Data: data/farm/rules/56-nature.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"nature": {"pool": {}, "t": -1.0, "s": 0.0, "p": 0.0, "advice": {}, "rest": {}}}

func data() -> Dictionary:
	return G.meta.get("nature", {})

func pools() -> Dictionary:
	return data().get("pools", {})

## The pools that the recipes of this station (root of its chain) take from: where each pool shows (nature/05: clay at the pond).
func pools_at(root: String) -> Array:
	var members: Array = G.crafting.chain_members(root)
	var out := []
	for p in pools():
		for rid in (pools()[p].get("recipes", {}) as Dictionary):
			if G.recipes.has(rid) and members.has(str(G.recipes[rid]["station"])) and not out.has(p): out.append(p)
	return out

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
	_rest_check()

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
	_rest_check()

# ------------------------------------------------------------------ N5: a Helper rests

## Is this pool over-used: it fell below `pauseBelow` (well past the advice) and has not yet come back to `pauseUntil`?
func resting(p: String) -> bool:
	return bool((G.S["nature"].get("rest", {}) as Dictionary).get(p, false))

## Does a pool's rest pause this chore or blessing (entry id) of this pet? {"pool", "place"} (place: where the Helper sits, as in the pets' data) or {}.
## The pool's data names the one job that draws on it (`pauses`: pet and entry); a pool with none never pauses anybody.
func pause_of(pid: String, eid: String) -> Dictionary:
	for p in pools():
		var w: Dictionary = pools()[p].get("pauses", {})
		if resting(p) and str(w.get("pet", "")) == pid and str(w.get("entry", "")) == eid: return {"pool": p, "place": str(w.get("place", ""))}
	return {}

## A pool begins its rest when it falls below `pauseBelow`, and ends it when it is back at `pauseUntil` (the old saves have no "rest" yet).
func _rest_check() -> void:
	var s: Dictionary = G.S["nature"]
	if not s.has("rest"): s["rest"] = {}
	for p in pools():
		if not (pools()[p] as Dictionary).has("pauses"): continue
		var f := fill(p)
		if not resting(p) and f < float(data().get("pauseBelow", 0.2)): s["rest"][p] = true
		elif resting(p) and f >= float(data().get("pauseUntil", 0.5)): s["rest"].erase(p)
