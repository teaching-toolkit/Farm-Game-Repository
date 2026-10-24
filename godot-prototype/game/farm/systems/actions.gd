extends RefCounted
class_name FarmActions
## Every chore in one place: check says what it costs now and what is missing (and changes nothing); perform spends the cost,
## runs the chore's effect and the follow-ups, and returns a report. The base cost of a chore is data (rules/46-chores.json);
## the effect stays in the system that owns it and is registered here. Who does the chore is an input (a Doer): in this build
## it is always the farmer (G.actions.farmer), and the module reads nothing of the farmer except through the Doer.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems
var farmer: Doer
var _chores := {}   # chore -> {"effect": Callable, "requires": Callable, "amount": Callable, "extra": Callable, "no_mult": Callable, "profile": Callable, "before": Callable}

## Who does a chore. The farmer's energy lives in the farm's state; a pet doing a chore for the farmer would pay from it too.
class Doer extends RefCounted:
	var G: FarmGame
	var id := "farmer"
	func _init(game: FarmGame, who := "farmer") -> void:
		G = game
		id = who
	func energy() -> float:
		return float(G.S["energy"])
	func take_energy(e: float) -> void:
		G.S["energy"] -= e
	func take_water(w: float) -> void:
		G.S["water"] -= w
	func take_item(k: String, q: float) -> void:
		G.inventory.take(k, q)

func _init(game: FarmGame) -> void:
	G = game
	farmer = Doer.new(game)

## A chore's effect and, if it has any of its own, its requirements.
##   effect:   func(who: Doer, args: Dictionary, cost: Dictionary) -> Dictionary   (returns {"gained": {...}, "result": {...} (optional: what the caller needs to know, e.g. whether a pick was right)}; does its own statistics and floating text)
##   requires: func(who: Doer, args: Dictionary) -> Array of {"key": reason key, "text": a sentence for the child}   (read-only)
##   amount:   func(who: Doer, args: Dictionary) -> float   (optional; how many units of work this call is: the base energy is per unit; read-only)
##   extra:    func(who: Doer, args: Dictionary) -> {"cost": {...}, "base": {...}}   (optional; costs of other kinds that depend on the call, e.g. the water of a planting or the feed of animals; spent as written; read-only)
##   no_mult:  func(who: Doer, args: Dictionary) -> bool   (optional; true = the data's second energy modifier (mult) does not apply to this call; read-only)
##   profile:  func(who: Doer, args: Dictionary) -> Dictionary   (optional; the chore's data for this call, for a chore whose numbers are written elsewhere (a recipe): base, cat, station … replace the written ones; read-only)
##   before:   func(who: Doer, args: Dictionary, cost: Dictionary) -> Dictionary   (optional; runs once perform has found nothing in the way, before anything is spent. It may fix details of the call in args (how many loads) and take what the chore uses besides the cost (the woodpile's fuel). Returns {} to go on, or {"key", "message"} to stop with nothing spent)
func register(chore: String, effect: Callable, requires := Callable(), amount := Callable(), extra := Callable(), no_mult := Callable(), profile := Callable(), before := Callable()) -> void:
	_chores[chore] = {"effect": effect, "requires": requires, "amount": amount, "extra": extra, "no_mult": no_mult, "profile": profile, "before": before}

## The chore's data: the written entry of rules/46-chores.json, with what its profile says for this call (when asked with a doer and args).
func data(chore: String, who: Doer = null, args := {}) -> Dictionary:
	var d: Dictionary = G.meta.get("chores", {}).get(chore, {})
	var c: Dictionary = _chores.get(chore, {})
	if who != null and c.has("profile") and c["profile"].is_valid():
		d = d.duplicate()
		d.merge(c["profile"].call(who, args), true)
	return d

## A number written in the data: a number, or the path of a number written elsewhere ("water.fetchEnergy").
func _number(v: Variant) -> float:
	if typeof(v) == TYPE_STRING:
		var node: Variant = G.meta
		for key in String(v).split("."): node = node.get(key, {}) if typeof(node) == TYPE_DICTIONARY else {}
		v = node if typeof(node) in [TYPE_INT, TYPE_FLOAT] else 0.0
	return float(v)

## The base cost of a chore, kind by kind. A number may be the path of a number written elsewhere ("water.fetchEnergy").
func base_cost(chore: String, who: Doer = null, args := {}) -> Dictionary:
	var out := {}
	var base: Dictionary = data(chore, who, args).get("base", {})
	for kind in base: out[kind] = _number(base[kind])
	return out

## The base cost for this call: the written base, times the units of work if the chore counts them (weeds pulled, stones picked).
func call_base(chore: String, who: Doer, args := {}) -> Dictionary:
	var cost := base_cost(chore, who, args)
	var c: Dictionary = _chores.get(chore, {})
	if cost.has("energy") and c.has("amount") and c["amount"].is_valid(): cost["energy"] = float(cost["energy"]) * float(c["amount"].call(who, args))
	if c.has("extra") and c["extra"].is_valid(): cost.merge(c["extra"].call(who, args)["base"], true)
	return cost

## What the chore costs now, after skills, tools, the season and buffs. Only energy changes on the way; the other kinds are read as written.
func effective_cost(chore: String, who: Doer, args := {}) -> Dictionary:
	var cost := call_base(chore, who, args)
	var d := data(chore, who, args)
	if cost.has("energy"):
		if not bool(d.get("raw", false)):       # raw: no skill, tool, season or buff changes the energy (a party)
			cost["energy"] = G.needs.ecost(str(d.get("cat", "")), float(cost["energy"]), str(d.get("station", "")))
		var c: Dictionary = _chores.get(chore, {})
		var skip: bool = c.has("no_mult") and c["no_mult"].is_valid() and bool(c["no_mult"].call(who, args))
		if str(d.get("mult", "")) != "" and not skip: cost["energy"] = float(cost["energy"]) * G.m(str(d["mult"]))
		if str(d.get("round", "")) == "up": cost["energy"] = ceilf(float(cost["energy"]) - 0.0001)
		if d.has("min"): cost["energy"] = maxf(float(cost["energy"]), _number(d["min"]))
	if _chores.has(chore) and _chores[chore]["extra"].is_valid(): cost.merge(_chores[chore]["extra"].call(who, args)["cost"], true)
	return cost

## What would it cost now, and can it be done? {"ok", "cost" (the effective cost), "base" (before skills and the rest), "unmet" ([{"key","text"}])}. Changes nothing.
func check(chore: String, who: Doer, args := {}) -> Dictionary:
	var cost := effective_cost(chore, who, args)
	var unmet := []
	var c: Dictionary = _chores.get(chore, {})
	if c.is_empty():
		unmet.append({"key": "unknown", "text": ""})
	else:
		if c["requires"].is_valid(): unmet.append_array(c["requires"].call(who, args))
		if cost.has("energy") and who.energy() + float(data(chore, who, args).get("slack", 0.001)) < float(cost["energy"]):
			unmet.append({"key": "energy", "text": tr("⚡ Too tired. Rest a little (tap ⚡).")})
	return {"ok": unmet.is_empty(), "cost": cost, "base": call_base(chore, who, args), "unmet": unmet}

## Does the chore: refuses (and says why, once) if a requirement is unmet; otherwise spends the cost, runs the effect and the follow-ups.
## Returns {"done", "failed" (the key of the first unmet requirement), "spent", "gained", "result", "message"}.
func perform(chore: String, who: Doer, args := {}) -> Dictionary:
	var rep := _run(chore, who, args)
	if not rep["done"]:
		if rep["message"] != "": G.say(rep["message"])
	else:
		G.save_game(); G.changed.emit()
	return rep

## A stretch of the same chore (a whole field): one call per entry of args_list, in order. Stops at the first that cannot be done,
## saves once, redraws once and says one message (why it stopped, or nothing when all went well).
## Returns {"count" (how many were done), "failed" (key of the stop, "" if none), "message"}.
func perform_batch(chore: String, who: Doer, args_list: Array) -> Dictionary:
	var count := 0
	var stop := {"failed": "", "message": ""}
	for args in args_list:
		var rep := _run(chore, who, args)
		if not rep["done"]: stop = rep; break
		count += 1
	if count > 0: G.save_game(); G.changed.emit()
	if stop["message"] != "": G.say(stop["message"])
	return {"count": count, "failed": stop["failed"], "message": stop["message"]}

## One chore without the save and the redraw (perform and perform_batch add those). Says nothing: the message is in the report.
func _run(chore: String, who: Doer, args: Dictionary) -> Dictionary:
	var q := check(chore, who, args)
	if not q["ok"]:
		var first: Dictionary = q["unmet"][0]
		return {"done": false, "failed": first["key"], "spent": {}, "gained": {}, "result": {}, "message": str(first["text"])}
	var cost: Dictionary = q["cost"]
	if _chores[chore]["before"].is_valid():
		var stop: Dictionary = _chores[chore]["before"].call(who, args, cost)
		if not stop.is_empty(): return {"done": false, "failed": str(stop["key"]), "spent": {}, "gained": {}, "result": {}, "message": str(stop.get("message", ""))}
	if cost.has("energy"): who.take_energy(float(cost["energy"]))
	if cost.has("water"): who.take_water(float(cost["water"]))
	for k in cost:       # any other kind is an item (or a kind of item: "tag:fodder"); coins are not a chore's cost yet
		if k != "energy" and k != "water" and k != "coins": who.take_item(k, float(cost[k]))
	var result: Dictionary = _chores[chore]["effect"].call(who, args, cost)
	var d := data(chore, who, args)
	if str(d.get("wear", "")) != "": G.crafting.wear_polish(str(d["wear"]))
	if str(d.get("practice", "")) != "": G.skills.practice(str(d["practice"]))
	return {"done": true, "failed": "", "spent": cost, "gained": result.get("gained", {}), "result": result.get("result", {}), "message": ""}
