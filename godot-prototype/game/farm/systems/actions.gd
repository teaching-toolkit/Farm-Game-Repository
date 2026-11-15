extends RefCounted
class_name FarmActions
## Every chore in one place: check says what it costs now and what is missing (and changes nothing); perform spends the cost,
## runs the chore's effect and the follow-ups, and returns a report. The base cost of a chore is data (rules/46-chores.json);
## the effect stays in the system that owns it and is registered here. Who does the chore is an input (a Doer): in this build
## it is the farmer (G.actions.farmer) or a pet working for the farmer (pet_doer: the farmer pays, no moments, no skill practice, no wear).

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems
var farmer: Doer
var _chores := {}   # chore -> {"effect": Callable, "requires": Callable, "amount": Callable, "extra": Callable, "profile": Callable, "before": Callable}
var _auto := {}     # chore -> Callable: how a pet picks the target of this chore (register_auto)
var _pet_doers := {}   # pet id -> Doer (pet_doer)

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

## The save key this system owns: the moments the farmer has used in this step of time (0 in a new game and in an old save).
func save_defaults() -> Dictionary:
	return {"moments": 0}

## ---- moments: how much of a step a chore takes (rules/46-chores.json "moments", skill ranks in rules/48-skills.json). Counted here and nowhere else.
func moments_per_step() -> int:
	var m: Dictionary = G.meta.get("moments", {})
	var extra: Array = m.get("chapterExtra", [])             # later chapters hold more per step: a bigger farm has more to do in one step
	var add := 0 if extra.is_empty() else int(extra[clampi(G.chapter(), 1, extra.size()) - 1])
	return int(m.get("perStep", 24)) + add

func moments_used() -> int:
	return int(G.S.get("moments", 0))

func moments_left() -> int:
	return maxi(0, moments_per_step() - moments_used())

## True when this step has no moment left (a chore that takes at least one cannot start).
func out_of_time() -> bool:
	return moments_left() <= 0

## The rule's answer for a button that is not one plain chore (a patch's Plant, Harvest all, a whole-field job): grey when the step has no
## moment left or when `ok` is false (`why` is then the reason). Shaped like `check`, so `UI.button` greys it and a tap tells why.
func time_gate(ok := true, why := "") -> Dictionary:
	var unmet := []
	if out_of_time(): unmet.append({"key": "time", "text": tr("🕰️ No time left for that now. Answer the clock's question.")})
	elif not ok: unmet.append({"key": "", "text": why})
	return {"ok": ok and unmet.is_empty(), "unmet": unmet, "cost": {}, "base": {}}

## A new step of time: a fresh set of moments (registered in the clock by the Game).
func new_step(_info := {}) -> void:
	G.S["moments"] = 0

## What this chore takes now: the written moments (a recipe: from its own energy by the bands), minus the skill ranks of its family
## on a chore of 2 or more (never below 1). Only the farmer's own chores count; anyone else's use none.
func moments_of(chore: String, who: Doer, args := {}) -> int:
	if who.id != farmer.id: return 0
	var d := data(chore, who, args)
	var n := 0
	var v: Variant = d.get("moments", 0)
	if typeof(v) == TYPE_STRING:
		var e := float(d.get("base", {}).get("energy", 0.0))
		n = 1
		for band in G.meta.get("moments", {}).get("bands", [[9999, 1]]):
			n = int(band[1])
			if e <= float(band[0]): break
	else:
		n = int(v)
	if n >= 2:
		var fam := str(d.get("practice", ""))
		if fam == "" and chore == "recipe": fam = G.skills.family_of_station(str(d.get("station", "")))
		if fam != "": n = maxi(1, n - G.skills.rank(fam) * int(G.meta.get("skills", {}).get("momentsPerRank", 0)))
	return n

## A chore's effect and, if it has any of its own, its requirements.
##   effect:   func(who: Doer, args: Dictionary, cost: Dictionary) -> Dictionary   (returns {"gained": {...}, "result": {...} (optional: what the caller needs to know, e.g. whether a pick was right)}; does its own statistics and floating text)
##   requires: func(who: Doer, args: Dictionary) -> Array of {"key": reason key, "text": a sentence for the child}   (read-only)
##   amount:   func(who: Doer, args: Dictionary) -> float   (optional; how many units of work this call is: the base energy is per unit; read-only)
##   extra:    func(who: Doer, args: Dictionary) -> {"cost": {...}, "base": {...}}   (optional; costs of other kinds that depend on the call, e.g. the water of a planting or the feed of animals; spent as written; read-only)
##   profile:  func(who: Doer, args: Dictionary) -> Dictionary   (optional; the chore's data for this call, for a chore whose numbers are written elsewhere (a recipe): base, cat, station … replace the written ones; read-only)
##   before:   func(who: Doer, args: Dictionary, cost: Dictionary) -> Dictionary   (optional; runs once perform has found nothing in the way, before anything is spent. It may fix details of the call in args (how many loads) and take what the chore uses besides the cost (the woodpile's fuel). Returns {} to go on, or {"key", "message"} to stop with nothing spent)
func register(chore: String, effect: Callable, requires := Callable(), amount := Callable(), extra := Callable(), profile := Callable(), before := Callable()) -> void:
	_chores[chore] = {"effect": effect, "requires": requires, "amount": amount, "extra": extra, "profile": profile, "before": before}

## How a pet picks the target of a chore it is set to do (an automated chore). The owner of the chore registers it.
##   picker:   func() -> Dictionary   (the chore's `args` for the target to work on now, or {} when there is nothing to do; read-only)
func register_auto(chore: String, picker: Callable) -> void:
	_auto[chore] = picker

## The args a pet would do this chore with now: the picker's answer, or {} when there is nothing to do or no picker is registered.
func auto_args(chore: String) -> Dictionary:
	var p: Callable = _auto.get(chore, Callable())
	if not p.is_valid(): return {}
	var args: Variant = p.call()
	return args if typeof(args) == TYPE_DICTIONARY else {}

## The chores that have a picker (the chores a pet can be set to do), in the order they were registered. Read-only.
func auto_chores() -> Array:
	return _auto.keys()

## The Doer of a pet (made once, kept): it pays from the farmer's energy and water like the farmer's own Doer; its id is the pet's.
func pet_doer(pid: String) -> Doer:
	if not _pet_doers.has(pid): _pet_doers[pid] = Doer.new(G, pid)
	return _pet_doers[pid]

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
		if str(d.get("mult", "")) != "": cost["energy"] = float(cost["energy"]) * G.m(str(d["mult"]))
		if str(d.get("round", "")) == "up": cost["energy"] = ceilf(float(cost["energy"]) - 0.0001)
		if d.has("min"): cost["energy"] = maxf(float(cost["energy"]), _number(d["min"]))
	if _chores.has(chore) and _chores[chore]["extra"].is_valid(): cost.merge(_chores[chore]["extra"].call(who, args)["cost"], true)
	return cost

## What would it cost now, and can it be done? {"ok", "cost" (the effective cost), "base" (before skills and the rest), "moments" (what it takes of the step), "unmet" ([{"key","text"}])}. Changes nothing.
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
		var n := moments_of(chore, who, args)
		if n >= 1 and moments_left() <= 0: unmet.append({"key": "time", "text": tr("🕰️ No time left for that now. Answer the clock's question.")})
	return {"ok": unmet.is_empty(), "cost": cost, "base": call_base(chore, who, args), "unmet": unmet, "moments": moments_of(chore, who, args) if not c.is_empty() else 0}

## Does the chore: refuses (and says why, once) if a requirement is unmet; otherwise spends the cost, runs the effect and the follow-ups.
## Returns {"done", "failed" (the key of the first unmet requirement), "spent", "gained", "result", "message"}.
func perform(chore: String, who: Doer, args := {}) -> Dictionary:
	var rep := _run(chore, who, args)
	if not rep["done"]:
		if rep["message"] != "": G.say(rep["message"])
	else:
		G.save_game(); G.changed.emit()
	return rep

## One chore for a caller that is itself inside a step (a pet's chore in the pets' step): the same as perform but with no save, no redraw
## and no message; the step saves later. The report is returned as it is ({"done", "failed", "spent", "gained", "result", "message"}).
func run(chore: String, who: Doer, args := {}) -> Dictionary:
	return _run(chore, who, args)

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
	G.S["moments"] = mini(moments_per_step(), moments_used() + int(q["moments"]))
	var result: Dictionary = _chores[chore]["effect"].call(who, args, cost)
	if who.id == farmer.id:      # the farmer's extras are the farmer's: a pet's chore wears no tool and trains no skill
		var d := data(chore, who, args)
		if str(d.get("wear", "")) != "": G.crafting.wear_polish(str(d["wear"]))
		if str(d.get("practice", "")) != "": G.skills.practice(str(d["practice"]))
	return {"done": true, "failed": "", "spent": cost, "gained": result.get("gained", {}), "result": result.get("result", {}), "message": ""}
