extends Node
## The actions system (farm-actions): check changes nothing, perform takes exactly what check says, a chore works with exactly
## its cost in energy, and the cost on the buttons is the cost check returns. Price-match test over season, tools, skills, buffs.
## Run:  godot --headless --path . res://tests/actions_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0
var costs_seen := {}

func _ready() -> void:
	G = get_node("/root/Game")
	var A = G.actions
	var who = A.farmer
	# every chore in the data has an effect, and every registered chore has data
	for chore in G.meta["chores"]:
		if chore == "note": continue
		_check(A._chores.has(chore), "%s has a registered effect" % chore)
	for chore in A._chores:
		_check(G.meta["chores"].has(chore) and not A.base_cost(chore).is_empty(), "%s has a base cost in the data" % chore)
	for chore in ["clear_snow", "weed", "pick_stones"]:
		_check(A._chores.has(chore) and not A.base_cost(chore).is_empty(), "%s is a chore with a base cost" % chore)
	_check(A.base_cost("fetch_water")["energy"] == float(G.meta["water"]["fetchEnergy"]), "fetch water's base cost is the one number in the data")
	# tools that change the energy of gathering
	var tools := []
	for id in G.nodes:
		if "energy:gather" in JSON.stringify(G.nodes[id]): tools.append(id)
	var situations := 0
	for step in [0, 30, 60, 90]:
		for tool_set in [[], tools.slice(0, 1), tools]:
			for skills in [0, 40, 400]:
				for buff in [1.0, 2.0, 0.5]:
					G.reset_game()
					G.S["step"] = step
					G.S["unlocked"] = {}
					for t in tool_set: G.S["unlocked"][t] = true
					G.invalidate_caps()
					for f in G.skills.families(): G.S["skills"][f] = skills
					G.S["buff"] = {} if buff == 1.0 else {"until": step + 100, "mult": buff}
					situations += 1
					var label := "step %d, %d tools, skills %d, buff %s" % [step, tool_set.size(), skills, buff]
					_price_match(label)
					for chore in ["clear_snow", "weed", "pick_stones"]: _price_match_patch(chore, label)
	print("price-match situations: ", situations, ", distinct costs: ", costs_seen.keys())
	_check(costs_seen.size() >= 3, "the situations really change the cost")
	_requirements()
	_batches()
	print("ACTIONS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _price_match(label: String) -> void:
	var A = G.actions
	var who = A.farmer
	G.S["water"] = 0.0
	G.S["energy"] = G.needs.energy_max()
	var snap := JSON.stringify(G.S)
	var q: Dictionary = A.check("fetch_water", who)
	_check(JSON.stringify(G.S) == snap, "check changes nothing (%s)" % label)
	_check(q["ok"] and q["cost"]["energy"] > 0.0, "fetch water can be done (%s)" % label)
	var cost: float = q["cost"]["energy"]
	costs_seen[snappedf(cost, 0.001)] = true
	var e0: float = G.S["energy"]
	var w0: float = G.S["water"]
	var rep: Dictionary = A.perform("fetch_water", who)
	_check(rep["done"] and is_equal_approx(e0 - float(G.S["energy"]), cost), "perform takes exactly the cost from energy (%s)" % label)
	_check(is_equal_approx(float(rep["spent"]["energy"]), cost), "the report says what was spent (%s)" % label)
	_check(is_equal_approx(float(G.S["water"]) - w0, float(rep["gained"]["water"])) and float(rep["gained"]["water"]) > 0.0, "the report says what was gained (%s)" % label)
	# exactly the cost in energy works; a hair less does not
	G.S["water"] = 0.0
	G.S["energy"] = cost
	_check(A.perform("fetch_water", who)["done"] and G.S["energy"] < 0.001, "a chore works with exactly its cost in energy (%s)" % label)
	G.S["water"] = 0.0
	G.S["energy"] = cost - 0.01
	var snap2 := JSON.stringify(G.S)
	var rep2: Dictionary = A.perform("fetch_water", who)
	_check(not rep2["done"] and rep2["failed"] == "energy" and G.S["water"] == 0.0 and G.S["energy"] == cost - 0.01, "a hair too little energy is refused and nothing moves (%s)" % label)

## A field chore on patch 0 (after the same checks as fetch water): the amount of work (weeds, stones) scales the cost.
func _price_match_patch(chore: String, label: String) -> void:
	var A = G.actions
	var who = A.farmer
	for amount in ([1.0, 3.0, 9.0] if chore != "clear_snow" else [1.0]):
		_patch_state(chore, amount)
		G.S["energy"] = G.needs.energy_max()
		var snap := JSON.stringify(G.S)
		var q: Dictionary = A.check(chore, who, {"i": 0})
		_check(JSON.stringify(G.S) == snap, "check changes nothing (%s, %s)" % [chore, label])
		_check(q["ok"] and q["cost"]["energy"] > 0.0, "%s can be done (%s)" % [chore, label])
		var cost: float = q["cost"]["energy"]
		costs_seen[snappedf(cost, 0.001)] = true
		var e0: float = G.S["energy"]
		var rep: Dictionary = A.perform(chore, who, {"i": 0})
		_check(rep["done"] and is_equal_approx(e0 - float(G.S["energy"]), cost) and is_equal_approx(float(rep["spent"]["energy"]), cost), "perform takes exactly the cost (%s, %s, amount %s)" % [chore, label, amount])
		_check(_left(chore) < amount, "the work is done on the patch (%s, %s)" % [chore, label])
		_patch_state(chore, amount)
		G.S["energy"] = cost
		_check(A.perform(chore, who, {"i": 0})["done"] and G.S["energy"] < 0.001, "exactly the cost in energy works (%s, %s)" % [chore, label])
		_patch_state(chore, amount)
		G.S["energy"] = cost - 0.01
		var rep2: Dictionary = A.perform(chore, who, {"i": 0})
		_check(not rep2["done"] and rep2["failed"] == "energy" and G.S["energy"] == cost - 0.01 and _left(chore) > 0.0, "a hair too little energy is refused and nothing moves (%s, %s)" % [chore, label])

func _patch_state(chore: String, amount: float) -> void:
	var p: Dictionary = G.S["patches"][0]
	p["weeds"] = amount if chore == "weed" else 0.0
	p["stones"] = amount if chore == "pick_stones" else 0.0
	p["snow"] = chore == "clear_snow"

func _left(chore: String) -> float:
	var p: Dictionary = G.S["patches"][0]
	return float(p["weeds"]) if chore == "weed" else (float(p["stones"]) if chore == "pick_stones" else (1.0 if p.get("snow", false) else 0.0))

func _batches() -> void:
	var A = G.actions
	G.reset_game()
	for c in G.fields.CLEARING: G.S["unlocked"][c[0]] = true      # open the first field's patches
	G.invalidate_caps()
	var n := 0
	for i in range(G.S["patches"].size()):
		if G.fields.patch_usable("field", i) and i < 9:
			G.S["patches"][i]["weeds"] = 3.0
			n += 1
	var jobs: Array = G.fields.field_jobs(0, "weed")
	_check(jobs.size() == n and n >= 2, "the field's weedy patches are the batch (%d)" % n)
	var one: float = A.check("weed", A.farmer, jobs[0])["cost"]["energy"]
	G.S["energy"] = one * 1.5     # pays for one patch, not for the second
	var saves := [0]
	var redraws := [0]
	G.changed.connect(func(): redraws[0] += 1)
	var rep: Dictionary = A.perform_batch("weed", A.farmer, jobs)
	_check(rep["count"] == 1 and rep["failed"] == "energy" and rep["message"] != "", "the batch stops at the first patch it cannot pay for and says why")
	_check(redraws[0] == 1, "…and redraws once")
	_check(float(G.S["patches"][jobs[0]["i"]]["weeds"]) < 3.0 and float(G.S["patches"][jobs[1]["i"]]["weeds"]) == 3.0, "…the first patch is weeded, the second is not")
	G.S["energy"] = 1000.0
	redraws[0] = 0
	rep = A.perform_batch("weed", A.farmer, G.fields.field_jobs(0, "weed"))
	_check(rep["count"] == n - 1 and rep["failed"] == "" and rep["message"] == "" and redraws[0] == 1, "a batch that goes through redraws once and says nothing")
	_check(G.fields.field_jobs(0, "weed").size() == 0, "no weedy patch is left")
	_check(A.perform_batch("weed", A.farmer, [])["count"] == 0 and redraws[0] == 1, "an empty batch does nothing")

func _requirements() -> void:
	var A = G.actions
	G.reset_game()
	G.S["energy"] = 10.0
	G.S["water"] = G.needs.water_cap()
	var q: Dictionary = A.check("fetch_water", A.farmer)
	_check(not q["ok"] and q["unmet"][0]["key"] == "water_full" and q["unmet"][0]["text"] != "", "a full store is an unmet requirement with a key and a sentence")
	var rep: Dictionary = A.perform("fetch_water", A.farmer)
	_check(not rep["done"] and rep["failed"] == "water_full" and G.S["energy"] == 10.0, "…and perform refuses without taking energy")
	G.S["water"] = 0.0
	G.S["energy"] = 0.0
	q = A.check("fetch_water", A.farmer)
	_check(not q["ok"] and q["unmet"][0]["key"] == "energy", "no energy is an unmet requirement")
	_check(not A.check("no_such_chore", A.farmer)["ok"], "an unknown chore cannot be done")
	_patch_state("weed", 0.0)
	G.S["energy"] = 10.0
	var rw: Dictionary = A.perform("weed", A.farmer, {"i": 0})
	_check(not rw["done"] and rw["failed"] == "nothing_to_do" and rw["message"] != "" and G.S["energy"] == 10.0, "no weeds is an unmet requirement with a sentence")
	_check(A.check("pick_stones", A.farmer, {"i": 0})["unmet"][0]["key"] == "nothing_to_do" and A.check("clear_snow", A.farmer, {"i": 0})["unmet"][0]["key"] == "nothing_to_do", "no stones and no snow are unmet requirements too")

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
