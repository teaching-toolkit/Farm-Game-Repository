extends RefCounted
## Core · modifiers: folds effects from many sources (built things, upgrades, gift cards, later skills and needs) into
## one table that every rule reads. An effect is data:
##   {"set": {key: value}, "add": {key: n}, "mult": {key: factor}, "produces": {item: n per step}}
## Each source has a weight g (1 = full; polish uses 1 - 0.5^level for diminishing returns):
##   set       the last source wins
##   add       sums n × g
##   mult      multiplies (1 - (1 - factor) × g): a weight of 0.5 gives half the effect
##   produces  sums n × g
## Usage:
##   const Modifiers = preload("res://kits/core/modifiers.gd")
##   var table = Modifiers.fold([[effects_a, 1.0], [effects_b, 0.75]])
##   Modifiers.mult(table, "weedRate")       # 1.0 when nothing changes it
##   Modifiers.value(table, "luck", 0.0)     # set (or the default) + add

static func empty() -> Dictionary:
	return {"set": {}, "add": {}, "mult": {}, "produces": {}}

## sources: [[effects, weight], …] in the order they apply.
static func fold(sources: Array) -> Dictionary:
	var t := empty()
	for s in sources: apply(t, s[0], float(s[1]))
	return t

static func apply(t: Dictionary, e: Dictionary, g: float) -> void:
	var st: Dictionary = t["set"]; var ad: Dictionary = t["add"]; var mu: Dictionary = t["mult"]; var pr: Dictionary = t["produces"]
	for k in e.get("set", {}):
		st[k] = e["set"][k]
	for k in e.get("add", {}):
		ad[k] = ad.get(k, 0.0) + float(e["add"][k]) * g
	for k in e.get("mult", {}):
		var v := 1.0 - (1.0 - float(e["mult"][k])) * g
		mu[k] = mu.get(k, 1.0) * v
	for k in e.get("produces", {}):
		pr[k] = pr.get(k, 0.0) + float(e["produces"][k]) * g

static func mult(t: Dictionary, k: String) -> float:
	return float(t["mult"].get(k, 1.0))

static func value(t: Dictionary, k: String, d: float = 0.0) -> float:
	return float(t["set"].get(k, d)) + float(t["add"].get(k, 0.0))
