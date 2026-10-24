extends Node
## The actions system (farm-actions): check changes nothing, perform takes exactly what check says, a chore works with exactly
## its cost in energy, and the cost on the buttons is the cost check returns. Price-match test over season, tools, skills, buffs.
## Run:  godot --headless --path . res://tests/actions_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0
var costs_seen := {}
const FREE_CHORES := ["forest_look", "forest_enter", "forest_leave"]   # these cost no energy: the question each way is asked by the interface

func _ready() -> void:
	G = get_node("/root/Game")
	var A = G.actions
	var who = A.farmer
	# every chore in the data has an effect, and every registered chore has data
	for chore in G.meta["chores"]:
		if chore == "note": continue
		_check(A._chores.has(chore), "%s has a registered effect" % chore)
	for chore in A._chores:
		_check(G.meta["chores"].has(chore) and (not A.base_cost(chore).is_empty() or chore in FREE_CHORES), "%s has a base cost in the data" % chore)
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
					_price_match_crops(label)
					_price_match_animals(label)
					_price_match_well(label)
					_price_match_trip(label)
					_price_match_forest(label)      # last: it unlocks the still-room and the shovel
	print("price-match situations: ", situations, ", distinct costs: ", costs_seen.keys())
	_check(costs_seen.size() >= 3, "the situations really change the cost")
	_requirements()
	_batches()
	_crop_requirements()
	_animal_requirements()
	_well_requirements()
	_forest_requirements()
	_trip_requirements()
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

## Plant, harvest and cut a tree: the cost check returns is what perform takes (energy and, for planting, water); exactly the cost works.
func _price_match_crops(label: String) -> void:
	var A = G.actions
	var who = A.farmer
	var wheat := "crop_wheat" if G.fields.sow_ok("field", "crop_wheat") else "crop_winter_wheat"
	G.S["orchard"] = [G.fields._blank_patch(), G.fields._blank_patch()]
	for c in G.fields.CLEARING: G.S["unlocked"][c[0]] = true      # the first field's patches are open
	G.invalidate_caps()
	for spot in [["field", wheat], ["orchard", "crop_walnut"]]:
		var a: String = spot[0]
		var args := {"a": a, "i": 0, "cid": spot[1]}
		var ctx := "plant %s (%s)" % [a, label]
		G.fields.area(a)[0] = G.fields._blank_patch()
		_stock(spot[1])
		G.S["energy"] = G.needs.energy_max()
		var snap := JSON.stringify(G.S)
		var q: Dictionary = A.check("plant", who, args)
		_check(JSON.stringify(G.S) == snap, "check changes nothing (%s)" % ctx)
		_check(q["ok"] and q["cost"]["energy"] > 0.0 and q["cost"]["water"] > 0.0, "%s can be done" % ctx)
		var cost: float = q["cost"]["energy"]
		var water: float = q["cost"]["water"]
		costs_seen[snappedf(cost, 0.001)] = true
		var shown: Dictionary = G.fields.plant_plan(a, spot[1])
		_check(is_equal_approx(water, float(shown["water"])), "the water on the button is the water check returns (%s)" % ctx)
		var rep: Dictionary = A.perform("plant", who, args)
		_check(rep["done"] and is_equal_approx(G.needs.energy_max() - float(G.S["energy"]), cost) and is_equal_approx(50.0 - float(G.S["water"]), water), "perform takes exactly the energy and water check says (%s)" % ctx)
		_check(G.fields.area(a)[0]["crop"] == spot[1] and float(G.fields.area(a)[0]["plants"]) >= 1.0, "…and the crop is in the ground (%s)" % ctx)
		G.fields.area(a)[0] = G.fields._blank_patch()
		_stock(spot[1])
		G.S["energy"] = cost
		_check(A.perform("plant", who, args)["done"] and G.S["energy"] < 0.001, "planting works with exactly its cost in energy (%s)" % ctx)
		G.fields.area(a)[0] = G.fields._blank_patch()
		_stock(spot[1])
		G.S["energy"] = cost - 0.01
		_check(not A.perform("plant", who, args)["done"] and G.fields.area(a)[0]["crop"] == "" and G.S["energy"] == cost - 0.01, "a hair too little energy plants nothing (%s)" % ctx)
		# harvest
		var hargs := {"a": a, "i": 0}
		for hair in [false, true]:
			var pt: Dictionary = G.fields.area(a)[0]
			pt["crop"] = spot[1]; pt["plants"] = 1.0; pt["growth"] = 99.0; pt["ready"] = true
			var hq: Dictionary = A.check("harvest", who, hargs)
			var hc: float = hq["cost"]["energy"]
			costs_seen[snappedf(hc, 0.001)] = true
			G.S["energy"] = hc - 0.01 if hair else hc
			var hrep: Dictionary = A.perform("harvest", who, hargs)
			if hair: _check(not hrep["done"] and hrep["failed"] == "energy" and pt["ready"], "a hair too little energy harvests nothing (harvest %s, %s)" % [a, label])
			else: _check(hrep["done"] and G.S["energy"] < 0.001 and is_equal_approx(float(hrep["spent"]["energy"]), hc), "harvest takes exactly the cost (%s, %s)" % [a, label])
	# cut a tree
	G.S["orchard"][0] = G.fields._blank_patch()
	for hair in [false, true]:
		var pt2: Dictionary = G.S["orchard"][0]
		pt2["crop"] = "crop_walnut"; pt2["plants"] = 1.0
		var cargs := {"a": "orchard", "i": 0}
		var cq: Dictionary = A.check("cut_tree", who, cargs)
		var cc: float = cq["cost"]["energy"]
		costs_seen[snappedf(cc, 0.001)] = true
		G.S["energy"] = cc - 0.01 if hair else cc
		var crep: Dictionary = A.perform("cut_tree", who, cargs)
		if hair: _check(not crep["done"] and pt2["crop"] == "crop_walnut", "a hair too little energy cuts nothing (%s)" % label)
		else: _check(crep["done"] and pt2["crop"] == "" and G.S["energy"] < 0.001 and is_equal_approx(float(crep["spent"]["energy"]), cc), "cutting a tree takes exactly the cost (%s)" % label)

## Seeds (or the grain that is the seed) and water for a planting.
func _stock(cid: String) -> void:
	G.S["seeds"][cid] = 20.0
	if G.nodes[cid].has("seedItem"): G.inventory.add_item(G.nodes[cid]["seedItem"], 20.0)
	G.S["water"] = 50.0

func _crop_requirements() -> void:
	var A = G.actions
	G.reset_game()
	G.S["energy"] = 10.0
	G.S["water"] = 10.0
	G.S["seeds"]["crop_wheat"] = 5.0
	for c in G.fields.CLEARING: G.S["unlocked"][c[0]] = true
	G.invalidate_caps()
	var args := {"a": "field", "i": 0, "cid": "crop_wheat"}
	G.S["patches"][0]["snow"] = true
	_check(A.check("plant", A.farmer, args)["unmet"][0]["key"] == "snow", "snow on the patch is an unmet requirement for planting")
	G.S["patches"][0]["snow"] = false
	G.S["patches"][0]["crop"] = "crop_wheat"
	_check(A.check("plant", A.farmer, args)["unmet"][0]["key"] == "occupied", "a planted patch is an unmet requirement")
	G.S["patches"][0]["crop"] = ""
	G.S["seeds"]["crop_wheat"] = 0.0
	G.S["inv"].erase("wheat")      # the grain is the seed
	var rep: Dictionary = A.perform("plant", A.farmer, args)
	_check(not rep["done"] and rep["failed"] == "supplies" and rep["message"] != "" and G.S["energy"] == 10.0, "no seeds: refused with a sentence, nothing taken")
	var hrep: Dictionary = A.perform("harvest", A.farmer, {"a": "field", "i": 0})
	_check(not hrep["done"] and hrep["failed"] == "nothing_to_do" and G.S["energy"] == 10.0, "harvesting an empty patch is refused, nothing taken")
	_check(not A.perform("cut_tree", A.farmer, {"a": "field", "i": 0})["done"], "nothing to cut on an empty patch")

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

## Collect from the animals and muck out: the cost check returns (energy, water, feed) is what perform takes; exactly the cost works.
func _price_match_animals(label: String) -> void:
	var A = G.actions
	var who = A.farmer
	for aid in ["animal_chicken", "animal_cow", "animal_sheep"]:
		var args := {"aid": aid}
		var ctx := "%s (%s)" % [aid, label]
		for hair in [false, true]:
			_animal_state(aid, 5.0)
			var snap := JSON.stringify(G.S)
			var q: Dictionary = A.check("collect_animal", who, args)
			_check(JSON.stringify(G.S) == snap, "check changes nothing (collect %s)" % ctx)
			_check(q["ok"] and q["cost"]["energy"] > 0.0 and q["cost"]["water"] > 0.0 and q["cost"].size() >= 3, "collecting can be done (%s)" % ctx)
			var cost: float = q["cost"]["energy"]
			costs_seen[snappedf(cost, 0.001)] = true
			var have0 := {}
			for k in q["cost"]: have0[k] = G.inventory.have(k)
			G.S["energy"] = cost - 0.01 if hair else cost
			var snap2 := JSON.stringify([G.S["energy"], G.S["water"], G.S["inv"], G.S["animals"]])
			var rep: Dictionary = A.perform("collect_animal", who, args)
			if hair:
				_check(not rep["done"] and rep["failed"] == "energy" and JSON.stringify([G.S["energy"], G.S["water"], G.S["inv"], G.S["animals"]]) == snap2, "a hair too little energy collects nothing and takes nothing (%s)" % ctx)
				continue
			var same := true
			for k in q["cost"]:
				if k != "energy" and not is_equal_approx(float(have0[k]) - G.inventory.have(k), float(q["cost"][k])): same = false
			_check(rep["done"] and G.S["energy"] < 0.001 and is_equal_approx(float(rep["spent"]["energy"]), cost), "collecting takes exactly the energy check says, with exactly that in energy (%s)" % ctx)
			_check(same, "…and exactly the water and the feed check says (%s)" % ctx)
			_check(int(G.S["animals"][aid]["ready"]) > G.S["step"] and float(G.S["animals"][aid]["muck"]) > 5.0 and not rep["gained"].is_empty(), "…and the animals gave something and left muck (%s)" % ctx)
		# muck out: the amount of muck scales the cost
		for mk in [1.0, 5.0, 12.0]:
			_animal_state(aid, mk)
			var mq: Dictionary = A.check("muck_out", who, args)
			var mc: float = mq["cost"]["energy"]
			costs_seen[snappedf(mc, 0.001)] = true
			_check(mq["ok"] and mc > 0.0 and mq["cost"].size() == 1, "mucking out can be done (%s, muck %s)" % [ctx, mk])
			G.S["energy"] = mc
			var m0: float = G.inventory.have("manure")
			var mrep: Dictionary = A.perform("muck_out", who, args)
			_check(mrep["done"] and G.S["energy"] < 0.001 and is_equal_approx(float(mrep["spent"]["energy"]), mc), "mucking out takes exactly the cost (%s, muck %s)" % [ctx, mk])
			_check(float(G.S["animals"][aid]["muck"]) == 0.0 and G.inventory.have("manure") > m0, "…the pen is clean and there is manure (%s, muck %s)" % [ctx, mk])
			_animal_state(aid, mk)
			G.S["energy"] = mc - 0.01
			var mrep2: Dictionary = A.perform("muck_out", who, args)
			_check(not mrep2["done"] and mrep2["failed"] == "energy" and float(G.S["animals"][aid]["muck"]) == mk, "a hair too little energy mucks out nothing (%s, muck %s)" % [ctx, mk])

## Two animals of this kind, ready, with muck, and everything to feed them.
func _animal_state(aid: String, muck: float) -> void:
	G.S["animals"][aid] = {"count": 2, "ready": 0, "muck": muck}
	G.S["energy"] = G.needs.energy_max()
	G.S["water"] = 50.0
	G.S["inv"].erase("manure")
	for k in ["clover", "wheat", "straw"]: G.inventory.add_item(k, 50.0, true)

func _animal_requirements() -> void:
	var A = G.actions
	G.reset_game()
	var aid := "animal_chicken"
	var args := {"aid": aid}
	G.S["animals"][aid] = {"count": 0, "ready": 0, "muck": 0.0}
	G.S["energy"] = 10.0
	_check(A.check("collect_animal", A.farmer, args)["unmet"][0]["key"] == "no_animals", "no animals is an unmet requirement")
	_animal_state(aid, 0.0)
	G.S["energy"] = 10.0
	G.S["animals"][aid]["ready"] = G.S["step"] + 3
	var rep: Dictionary = A.perform("collect_animal", A.farmer, args)
	_check(not rep["done"] and rep["failed"] == "not_ready" and rep["message"] != "" and G.S["energy"] == 10.0, "animals that are not ready are refused with a sentence, nothing taken")
	G.S["animals"][aid]["ready"] = 0
	G.S["inv"].erase("straw")
	var rep2: Dictionary = A.perform("collect_animal", A.farmer, args)
	_check(not rep2["done"] and rep2["failed"] == "feed" and rep2["message"] != "" and G.S["energy"] == 10.0 and G.S["water"] == 50.0, "no feed is refused with a sentence, nothing taken")
	_animal_state("animal_bees", 0.0)
	G.S["energy"] = 10.0
	var rep3: Dictionary = A.perform("collect_animal", A.farmer, {"aid": "animal_bees"})
	_check(not rep3["done"] and rep3["failed"] == "flowers" and G.S["energy"] == 10.0, "bees without flowers are refused")
	G.S["animals"][aid]["muck"] = 0.2
	G.S["energy"] = 10.0
	var rep4: Dictionary = A.perform("muck_out", A.farmer, args)
	_check(not rep4["done"] and rep4["failed"] == "clean" and rep4["message"] != "" and G.S["energy"] == 10.0, "a clean pen is refused with a sentence")

## A party and a visit cost a fixed energy (no skill, tool or season changes it, as before); the party also takes dishes.
func _price_match_well(label: String) -> void:
	var A = G.actions
	var who = A.farmer
	var d: Dictionary = G.meta["well"]
	for hair in [false, true]:
		_well_state()
		var q: Dictionary = A.check("throw_party", who)
		_check(q["ok"] and is_equal_approx(float(q["cost"]["energy"]), float(d["party"]["energy"])) and q["cost"].size() == 3, "a party costs the written energy and the dishes, whatever the skills and buffs (%s)" % label)
		var dishes := 0.0
		for k in q["cost"]:
			if k != "energy": dishes += float(q["cost"][k])
		_check(dishes == float(d["party"]["dishes"]), "…and exactly the written number of dishes (%s)" % label)
		var have0: float = G.inventory.count("porridge") + G.inventory.count("bread") + G.inventory.count("flatbread")
		G.S["energy"] = float(q["cost"]["energy"]) - 0.01 if hair else float(q["cost"]["energy"])
		var rep: Dictionary = A.perform("throw_party", who)
		var have1: float = G.inventory.count("porridge") + G.inventory.count("bread") + G.inventory.count("flatbread")
		if hair: _check(not rep["done"] and rep["failed"] == "energy" and have1 == have0 and int(G.S["well"]["party_step"]) == -999, "a hair too little energy throws no party and takes no dishes (%s)" % label)
		else: _check(rep["done"] and G.S["energy"] < 0.001 and have0 - have1 == dishes and int(G.S["well"]["party_step"]) == G.S["step"], "a party takes exactly the energy and dishes check says (%s)" % label)
	for hair in [false, true]:
		_well_state()
		G.S["well"]["invite"] = "Ada"
		var vq: Dictionary = A.check("visit_friend", who)
		_check(vq["ok"] and is_equal_approx(float(vq["cost"]["energy"]), float(d["visit"]["energy"])) and vq["cost"].size() == 1, "a visit costs the written energy (%s)" % label)
		G.S["energy"] = float(vq["cost"]["energy"]) - 0.01 if hair else float(vq["cost"]["energy"])
		var vrep: Dictionary = A.perform("visit_friend", who)
		if hair: _check(not vrep["done"] and vrep["failed"] == "energy", "a hair too little energy makes no visit (%s)" % label)
		else: _check(vrep["done"] and G.S["energy"] < 0.001 and G.S["well"]["invite"] == "Ada", "a visit takes exactly the energy, and the invitation waits for the question (%s)" % label)

func _well_state() -> void:
	G.S["energy"] = G.needs.energy_max()
	G.S["well"]["party_step"] = -999
	G.S["well"]["invite"] = ""
	G.S["inv"].clear()
	for k in ["porridge", "bread", "flatbread"]: G.inventory.add_item(k, 2.0, true)

func _well_requirements() -> void:
	var A = G.actions
	G.reset_game()
	_well_state()
	G.S["inv"].clear()
	G.S["energy"] = 10.0
	var rep: Dictionary = A.perform("throw_party", A.farmer)
	_check(not rep["done"] and rep["failed"] == "dishes" and rep["message"] != "" and G.S["energy"] == 10.0, "a party without dishes is refused with a sentence, nothing taken")
	_well_state()
	G.S["step"] = 5
	G.S["well"]["party_step"] = 3
	var rep2: Dictionary = A.perform("throw_party", A.farmer)
	_check(not rep2["done"] and rep2["failed"] == "cooldown" and rep2["message"] != "", "a party too soon after the last one is refused with a sentence")
	_check(A.check("visit_friend", A.farmer)["unmet"][0]["key"] == "no_invite", "a visit without an invitation is an unmet requirement")

## The forest: every task of a spot costs the gathering energy (a look costs none), going in and out costs no energy. What perform takes is what check says.
func _price_match_forest(label: String) -> void:
	var A = G.actions
	var who = A.farmer
	var tasks := {"forest_find": ["glade", "chamomile", {"option": "chamomile"}], "forest_pick": ["clearing", "marigold", {"part": "flower"}],
		"forest_dig": ["stream", "clay", {}], "forest_look": ["moonstone", "hum", {}]}
	for hair in [false, true]:
		for chore in tasks:
			_forest_state()
			var args: Dictionary = (tasks[chore][2] as Dictionary).duplicate()
			args["spot"] = tasks[chore][0]
			args["tid"] = tasks[chore][1]
			var q: Dictionary = A.check(chore, who, args)
			var free: bool = chore == "forest_look"
			var want: float = 0.0 if free else G.needs.ecost("gather", float(G.meta["forest"]["pickEnergy"]))
			_check(q["ok"] and is_equal_approx(float(q["cost"].get("energy", 0.0)), want), "%s costs what the gathering energy says (%s)" % [chore, label])
			if not free: costs_seen[snappedf(want, 0.001)] = true
			G.S["energy"] = want - 0.01 if hair and not free else want
			var e0: float = G.S["energy"]
			var rep: Dictionary = A.perform(chore, who, args)
			if hair and not free:
				_check(not rep["done"] and rep["failed"] == "energy" and G.S["energy"] == e0 and G.forest.basket().is_empty() and G.S["forest"]["rest"].is_empty(), "a hair too little energy does nothing (%s, %s)" % [chore, label])
			else:
				_check(rep["done"] and is_equal_approx(e0 - float(G.S["energy"]), want) and G.S["energy"] < 0.001, "%s takes exactly the energy check says (%s)" % [chore, label])
				_check(G.forest.rest_left(args["spot"], args["tid"]) > 0, "…and the spot rests (%s, %s)" % [chore, label])
				if chore == "forest_find" or chore == "forest_pick": _check(G.forest.basket().size() == 1 and rep["result"]["good"], "…and the right plant is in the basket (%s)" % label)
	_forest_state()
	var wrong: Dictionary = A.perform("forest_pick", who, {"spot": "clearing", "tid": "marigold", "part": "leaf"})
	_check(wrong["done"] and not wrong["result"]["good"] and G.forest.basket().is_empty() and G.S["energy"] < G.needs.energy_max(), "a wrong part costs the energy and brings nothing (%s)" % label)
	var wrong2: Dictionary = A.perform("forest_find", who, {"spot": "meadow", "tid": "yarrow", "option": "hemlock"})
	_check(wrong2["done"] and not wrong2["result"]["good"] and G.forest.has_bad(), "a look-alike brings the bad plant home (%s)" % label)

func _forest_state() -> void:
	G.S["step"] = 40       # summer
	G.S["unlocked"]["ruins_stillroom"] = true
	G.S["unlocked"]["wooden_shovel"] = true
	G.invalidate_caps()
	G.S["forest"] = G.forest.save_defaults()["forest"]
	G.S["forest"]["in"] = true
	G.S["inv"].clear()
	G.S["energy"] = G.needs.energy_max()

func _forest_requirements() -> void:
	var A = G.actions
	G.reset_game()
	var task := {"spot": "clearing", "tid": "marigold", "part": "flower"}
	_check(A.check("forest_enter", A.farmer)["unmet"][0]["key"] == "closed", "the forest is closed until the still-room is cleared")
	G.S["unlocked"]["ruins_stillroom"] = true
	G.invalidate_caps()
	G.S["step"] = 40
	G.S["energy"] = 30.0
	_check(A.check("forest_leave", A.farmer)["unmet"][0]["key"] == "outside" and A.check("forest_pick", A.farmer, task)["unmet"][0]["key"] == "outside", "nothing can be done out of the forest")
	var steps0: int = G.S["step"]
	_check(A.perform("forest_enter", A.farmer)["done"] and G.forest.inside() and int(G.S["forest"]["trips"]) == 1 and G.S["step"] == steps0 and G.S["energy"] == 30.0, "going in takes no energy of its own and counts a trip")
	_check(A.check("forest_enter", A.farmer)["unmet"][0]["key"] == "inside", "you cannot walk in twice")
	G.S["step"] = 0       # spring: marigold is a summer plant
	var q: Dictionary = A.check("forest_pick", A.farmer, task)
	_check(q["unmet"][0]["key"] == "season" and q["unmet"][0]["text"] != "", "a plant out of season is an unmet requirement with a sentence")
	G.S["step"] = 40
	_check(A.perform("forest_pick", A.farmer, task)["done"], "…in season it works")
	var rep: Dictionary = A.perform("forest_pick", A.farmer, task)
	_check(not rep["done"] and rep["failed"] == "rest" and rep["message"] != "" and G.forest.basket().size() == 1, "the spot rests for a few questions: refused with a sentence")
	var dig := {"spot": "stream", "tid": "clay"}
	_check(A.check("forest_dig", A.farmer, dig)["unmet"][0]["key"] == "tool", "digging needs the shovel")
	G.S["unlocked"]["wooden_shovel"] = true
	G.invalidate_caps()
	_check(A.check("forest_dig", A.farmer, dig)["ok"], "…and with the shovel it works")
	# the basket's room is a requirement with its own key; energy comes after it
	G.S["forest"]["basket"] = []
	for i in range(G.forest.capacity()): G.S["forest"]["basket"].append({"claim": "thyme", "real": "thyme"})
	G.S["energy"] = 0.0
	var full: Dictionary = A.perform("forest_find", A.farmer, {"spot": "glade", "tid": "chamomile", "option": "chamomile"})
	_check(not full["done"] and full["failed"] == "basket_full" and full["message"] != "", "a full basket is refused with its own reason, before the energy")
	_check(A.check("forest_dig", A.farmer, dig)["unmet"][0]["key"] == "energy", "digging does not need room in the basket, only energy")
	G.S["energy"] = 0.0
	var look: Dictionary = A.perform("forest_look", A.farmer, {"spot": "moonstone", "tid": "hum"})
	_check(look["done"] and G.inventory.count("quartz") == 1.0 and look["gained"].get("quartz", 0.0) == 1.0, "a look costs no energy and what it gives goes into the store")
	_check(A.perform("forest_leave", A.farmer)["done"] and not G.forest.inside(), "going out works")

## The village trip: the written base energy times the errand multiplier times what the road saves, rounded up, at least the minimum; no skill, tool-of-the-trade or buff changes it.
func _price_match_trip(label: String) -> void:
	var A = G.actions
	var who = A.farmer
	var d: Dictionary = G.meta["trip"]["energy"]
	for road in [false, true]:
		G.S["unlocked"]["road_5"] = road
		G.invalidate_caps()
		G.S["trip"] = {"phase": "", "bought": 0.0}
		var lvl := int(round(G.g("roadLevel", 1.0)))
		var f := maxf(float(d["roadFloor"]), 1.0 - float(d["roadSaving"]) * float(lvl - 1))
		var want := maxi(int(d["min"]), int(ceilf(float(d["base"]) * G.m("energy:errand") * f - 0.0001)))
		G.S["energy"] = G.needs.energy_max()
		var q: Dictionary = A.check("village_trip", who)
		_check(q["ok"] and is_equal_approx(float(q["cost"]["energy"]), float(want)) and q["cost"].size() == 1, "the trip costs the errand energy: %d (%s, road %s)" % [want, label, road])
		costs_seen[snappedf(float(want), 0.001)] = true
		for hair in [false, true]:
			G.S["trip"] = {"phase": "", "bought": 0.0}
			G.S["energy"] = float(want) - 0.01 if hair else float(want)
			var rep: Dictionary = A.perform("village_trip", who)
			if hair: _check(not rep["done"] and rep["failed"] == "energy" and G.trip.phase() == "" and is_equal_approx(float(G.S["energy"]), float(want) - 0.01), "a hair too little energy starts no walk (%s)" % label)
			else: _check(rep["done"] and G.S["energy"] < 0.001 and G.trip.walking() and is_equal_approx(float(rep["spent"]["energy"]), float(want)), "the trip takes exactly the energy check says and the walk begins (%s)" % label)

func _trip_requirements() -> void:
	var A = G.actions
	G.reset_game()
	G.S["energy"] = 20.0
	_check(A.perform("village_trip", A.farmer)["done"] and G.trip.walking(), "a trip can start at home")
	var e1: float = G.S["energy"]
	var rep: Dictionary = A.perform("village_trip", A.farmer)
	_check(not rep["done"] and rep["failed"] == "on_the_way" and rep["message"] != "" and G.S["energy"] == e1, "you cannot start a second trip: refused with a sentence, nothing taken")
	G.trip.arrive()
	_check(A.check("village_trip", A.farmer)["unmet"][0]["key"] == "on_the_way", "…not on the square either")

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
