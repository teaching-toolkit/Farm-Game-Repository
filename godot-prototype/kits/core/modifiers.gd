extends RefCounted
## Folds effects from many sources (upgrades, tools, gifts, training …) into one table.
## An effect block is {"set": {key: value}, "add": {key: n}, "mult": {key: factor}, "produces": {key: n}}.
## The table is {"set", "add", "mult", "produces"}, each a dictionary by key:
##   set       the last source to set a key wins
##   add       amounts add up (times the source's weight)
##   mult      factors multiply; a weight below 1 pulls the factor towards 1 (weight 0 = no effect)
##   produces  amounts per step of time that add up (times the weight)
## A key's value is its "set" plus its "add" (value()), its factor is mult().
## Knows nothing about any game: the caller decides which sources count and with what weight.

static func empty() -> Dictionary:
	return {"set": {}, "add": {}, "mult": {}, "produces": {}}

## Adds one source's effects to the table. weight 1.0 = in full.
static func apply(table: Dictionary, effects: Dictionary, weight := 1.0) -> void:
	var st: Dictionary = table["set"]
	var ad: Dictionary = table["add"]
	var mu: Dictionary = table["mult"]
	var pr: Dictionary = table["produces"]
	for k in effects.get("set", {}):
		st[k] = effects["set"][k]
	for k in effects.get("add", {}):
		ad[k] = ad.get(k, 0.0) + float(effects["add"][k]) * weight
	for k in effects.get("mult", {}):
		var v := 1.0 - (1.0 - float(effects["mult"][k])) * weight
		mu[k] = mu.get(k, 1.0) * v
	for k in effects.get("produces", {}):
		pr[k] = pr.get(k, 0.0) + float(effects["produces"][k]) * weight

## A key's value: what was set (or the default) plus what was added.
static func value(table: Dictionary, key: String, default := 0.0) -> float:
	return float(table["set"].get(key, default)) + float(table["add"].get(key, 0.0))

## A key's factor (1.0 when nothing multiplies it).
static func mult(table: Dictionary, key: String) -> float:
	return float(table["mult"].get(key, 1.0))
