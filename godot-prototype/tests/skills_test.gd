extends Node
## Skills and ranks (TODO Y2): practice counts per family, ranks need batches and (from Skilled on) a card, a tool or a station,
## what a rank changes, the first rank-up shows the skills, old stations' practice becomes skill batches. Rules only.
## Run:  godot --headless --path . res://tests/skills_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var K = G.skills
	_check(K.families().size() == 8, "eight families")
	_check(K.ranks().size() == 5 and K.rank_name(0) == "Beginner" and K.rank_name(4) == "Master", "five ranks, Beginner to Master")
	_check(K.family_of_station("stove_2") == "cooking" and K.family_of_station("oven_3") == "cooking" and K.family_of_station("textile_loom") == "fibre" and K.family_of_station("forge_2") == "smithing", "a station's family comes from its chain's root (stove_2, oven_3, textile_loom, forge_2)")
	_check(K.family_of_station("wild_edge") == "", "gathering at the field edge trains no skill")
	_check(K.family_of_cat("plant") == "field" and K.family_of_cat("harvest") == "field" and K.family_of_cat("animal") == "animals" and K.family_of_cat("cook") == "", "plant, harvest and animal jobs belong to a family")
	# a new game: everyone is a Beginner and nothing is shown
	_check(K.rank("cooking") == 0 and K.input_mult("cooking") == 1.0 and K.energy_mult("cooking") == 1.0 and K.time_mult("cooking") == 1.0 and K.grade_bonus("cooking") == 0.0, "a Beginner changes nothing")
	_check(not G.reveal.shown("skills") and G.conditions.value("skill_ranks") == 0.0, "the skills are not shown yet")
	# practice: 10 batches make Handy
	var told := []
	G.rank_up.connect(func(f, r): told.append([f, r]))
	for i in range(9): K.practice("cooking")
	_check(K.batches("cooking") == 9 and K.rank("cooking") == 0 and told.is_empty(), "nine batches: still a Beginner")
	K.practice("cooking")
	_check(K.rank("cooking") == 1 and told == [["cooking", 1]], "ten batches: Handy, and the rank-up is told once")
	_check(G.reveal.shown("skills") and G.reveal.shown("album"), "the first rank-up shows the skills and the album button")
	_check(is_equal_approx(K.input_mult("cooking"), 0.98) and is_equal_approx(K.energy_mult("cooking"), 0.92) and K.time_mult("cooking") == 1.0, "Handy cook: 2 % fewer inputs, 8 % less energy, no faster")
	_check(is_equal_approx(K.input_mult("wood") - 1.0, 0.0) and K.input_mult("") == 1.0, "another family is not affected")
	K.practice("")
	_check(K.batches("") == 0, "no family, no practice")
	# Skilled needs 30 batches AND the card
	for i in range(30): K.practice("cooking")
	_check(K.batches("cooking") == 40 and K.rank("cooking") == 1, "40 batches but no card: still Handy")
	var nx: Dictionary = K.next_step("cooking")
	_check(nx["rank"] == 2 and nx["batches"] == 0 and nx["gate"] == "k_stove", "the next step says: the card 'k_stove' is missing (%s)" % str(nx))
	G.S["unlocked"]["k_stove"] = true
	K.step({})
	_check(K.rank("cooking") == 2 and told.size() == 2 and told[1] == [ "cooking", 2 ], "with the card: Skilled, told at the next step of time")
	_check(is_equal_approx(K.input_mult("cooking"), 0.96) and K.grade_bonus("cooking") > 0.05, "Skilled: fewer inputs, a better grade chance")
	# Expert 80 + a tool, Master 200 + a station: the batches alone do not make a master
	for i in range(170): K.practice("cooking")
	_check(K.batches("cooking") == 210 and K.rank("cooking") == 2, "210 batches but no tool and no oven: still Skilled")
	G.S["unlocked"]["iron_knife"] = true
	_check(K.rank("cooking") == 3, "the iron knife: Expert")
	G.S["unlocked"]["oven_3"] = true
	_check(K.rank("cooking") == 4 and is_equal_approx(K.time_mult("cooking"), 0.8), "the master oven: Master, and faster (80 % of the time)")
	_check(K.next_step("cooking").is_empty(), "nothing above Master")
	# crafts save more inputs than food
	G.S["skills"]["wood"] = 200
	for n in ["k_timber", "saw", "workshop_3"]: G.S["unlocked"][n] = true
	_check(K.rank("wood") == 4 and K.input_mult("wood") < K.input_mult("cooking"), "a master carpenter saves more than a master cook (%.2f < %.2f)" % [K.input_mult("wood"), K.input_mult("cooking")])
	_check(G.conditions.value("skill_ranks") == 8.0, "the counter adds the ranks")
	# a recipe really costs less for a Handy cook
	G.reset_game()
	var rid := "porridge"
	var base_cost: Dictionary = G.actions.check("recipe", G.actions.farmer, {"rid": rid})["cost"]
	var e0 := float(base_cost.get("energy", 0.0))
	G.S["skills"]["cooking"] = 10
	var cost2: Dictionary = G.actions.check("recipe", G.actions.farmer, {"rid": rid})["cost"]
	var first: String = G.recipes[rid]["inputs"].keys()[0]
	_check(float(cost2[first]) < float(base_cost[first]) and is_equal_approx(float(cost2["energy"]), e0 * 0.92), "a Handy cook pays less for porridge (%s %.2f -> %.2f, energy %.2f -> %.2f)" % [first, float(base_cost[first]), float(cost2[first]), e0, float(cost2["energy"])])
	var e_plain: float = G.quality.recipe_expect(rid)
	G.S["skills"]["cooking"] = 0
	_check(G.quality.recipe_expect(rid) < e_plain, "…and its grade is expected to be better (%.2f vs %.2f)" % [e_plain, G.quality.recipe_expect(rid)])
	# batches are counted by doing: a recipe, a planting, a harvest
	G.reset_game()
	G.S["energy"] = 50.0
	G.inventory.add_item("fiber", 9.0, true)
	G.S["unlocked"]["workbench"] = true
	G.S["unlocked"]["k_rope"] = true
	G.invalidate_caps()
	var before: int = K.batches("fibre")
	var ok: bool = G.actions.perform("recipe", G.actions.farmer, {"rid": "rope"})["done"]
	_check(ok and K.batches("fibre") == before + 1, "making rope counts a batch of fibre work")
	var pb: int = K.batches("field")
	G.S["seeds"]["crop_wheat"] = 5.0
	G.S["water"] = 20.0
	var planted: bool = G.actions.perform("plant", G.actions.farmer, {"a": "field", "i": 0, "cid": "crop_wheat"})["done"]
	_check(planted and K.batches("field") == pb + 1, "planting counts for planting and harvesting")
	G.S["patches"][0]["ready"] = true
	G.S["patches"][0]["growth"] = 99.0
	G.actions.perform("harvest", G.actions.farmer, {"a": "field", "i": 0})
	_check(K.batches("field") == pb + 2, "…and so does the harvest")
	# the still-room's stations train healing: every recipe's station is in a family (but the gathering spots), and a remedy adds a batch
	for st in ["cellar", "cellar_2", "fermenter", "drying_rack", "mortar", "tea_pot", "syrup_pan", "salve_pot"]:
		_check(K.family_of_station(st) == "healing", "%s trains healing and preserving" % st)
	var unmapped := []
	for rid2 in G.recipes:
		if K.family_of_station(str(G.recipes[rid2]["station"])) == "" and not str(G.recipes[rid2]["station"]) in unmapped: unmapped.append(str(G.recipes[rid2]["station"]))
	unmapped.sort()
	_check(unmapped == ["clay_pit", "wild_edge"], "only the gathering spots train nothing (%s)" % str(unmapped))
	G.reset_game()
	G.S["energy"] = 50.0
	G.inventory.add_item("plantain", 6.0, true)
	for n in ["mortar", "k_plant_parts"]: G.S["unlocked"][n] = true
	G.invalidate_caps()
	var hb: int = K.batches("healing")
	var made: bool = G.actions.perform("recipe", G.actions.farmer, {"rid": "plantain_paste"})["done"]
	_check(made and K.batches("healing") == hb + 1 and G.inventory.count("plantain_paste") > 0.0, "a remedy (crushed plantain at the mortar) counts a batch of healing and preserving")
	G.inventory.add_item("chamomile", 2.0, true)
	for n in ["drying_rack", "k_drying"]: G.S["unlocked"][n] = true
	G.invalidate_caps()
	made = G.actions.perform("recipe", G.actions.farmer, {"rid": "dry_chamomile"})["done"]
	_check(made and K.batches("healing") == hb + 2, "…and so does drying herbs on the rack")
	# building: woodwork and construction lower what a build uses up and its energy; one function (pace.node_cost) prices it, the price row reads it
	G.reset_game()
	var bid := "workshop_1"      # log 4, boulder 6, rope 2, coins 300, energy 8
	var base_b: Dictionary = G.pace.node_cost_base(bid)
	var full: Dictionary = G.pace.node_cost(bid)
	var same := true
	for k in base_b: same = same and is_equal_approx(float(full[k]), float(base_b[k]))
	_check(K.family_of_build(bid) == "wood" and K.family_of_build("campfire") == "wood" and K.family_of_build("scaffolding") == "wood" and K.family_of_build("ruins_barn") == "wood", "a building, a station, a helper and a clearing of ruins are builds of woodwork and construction")
	_check(K.family_of_build("stone_axe") == "" and K.family_of_build("patch_raised") == "" and K.family_of_build("k_timber") == "", "a tool, a patch and a card are not")
	_check(same and K.build_note(bid) == "", "construction rank 0 (Beginner): full cost, and no line about a saving")
	G.S["skills"]["wood"] = 10
	var handy: Dictionary = G.pace.node_cost(bid)
	_check(float(handy["log"]) < float(full["log"]) and is_equal_approx(float(handy["log"]), 4.0 * 0.96) and is_equal_approx(float(handy["boulder"]), 6.0 * 0.96), "a Handy builder uses up less for %s (log %.2f -> %.2f, boulder %.2f -> %.2f)" % [bid, float(full["log"]), float(handy["log"]), float(full["boulder"]), float(handy["boulder"])])
	_check(is_equal_approx(float(handy["energy"]), float(full["energy"]) * 0.92) and float(handy["coins"]) == float(full["coins"]), "…and spends 8 % less energy, but the coins stay as written")
	_check(G.pace.node_cost_base(bid)["log"] == base_b["log"] and K.build_note(bid) != "", "the price row's grey cubes keep the base; a line says why (%s)" % K.build_note(bid))
	_check(is_equal_approx(float(G.pace.node_cost("stone_axe")["stick"]), float(G.pace.node_cost_base("stone_axe")["stick"])), "what is not a build (a stone axe) costs what it is written")
	G.S["skills"]["wood"] = 30
	G.S["unlocked"]["k_timber"] = true
	var skilled: Dictionary = G.pace.node_cost(bid)
	_check(K.rank("wood") == 2 and float(skilled["log"]) < float(handy["log"]), "a higher rank, a lower cost (Skilled: log %.2f)" % float(skilled["log"]))
	# a cook does not build cheaper, and at the same rank saves less than a carpenter (food 4 % against crafts 8 % at Skilled)
	G.S["skills"]["wood"] = 0
	G.S["unlocked"].erase("k_timber")
	G.S["skills"]["cooking"] = 30
	G.S["unlocked"]["k_stove"] = true
	_check(K.rank("cooking") == 2 and K.rank("wood") == 0 and is_equal_approx(float(G.pace.node_cost(bid)["log"]), float(full["log"])), "a Skilled cook pays the full price of a building")
	G.S["skills"]["wood"] = 30
	G.S["unlocked"]["k_timber"] = true
	_check(K.rank("wood") == K.rank("cooking") and 1.0 - K.input_mult("cooking") > 0.0 and 1.0 - K.input_mult("cooking") < 1.0 - K.input_mult("wood"), "at the same rank cooking saves less than woodwork (%.2f < %.2f)" % [1.0 - K.input_mult("cooking"), 1.0 - K.input_mult("wood")])
	# paying for a build trains woodwork and construction (one batch for a build, one for each step of one) and pays the lower price
	G.reset_game()
	G.S["energy"] = 50.0
	G.S["coins"] = 5000.0
	for k in ["stick", "stone", "fiber", "rope", "log"]: G.inventory.add_item(k, 9.0, true)
	G.S["unlocked"]["k_fire"] = true
	var wb: int = K.batches("wood")
	var sticks: float = G.inventory.count("stick")
	_check(G.progression.unlock("campfire") and K.batches("wood") == wb + 1, "building the campfire counts a batch of woodwork and construction (%s)" % str(G.progression.can_unlock("campfire")["why"]))
	_check(is_equal_approx(sticks - G.inventory.count("stick"), 3.0), "…at the full price for a Beginner (3 sticks)")
	G.S["skills"]["wood"] = 10
	G.S["unlocked"].erase("campfire")
	sticks = G.inventory.count("stick")
	_check(G.progression.unlock("campfire") and is_equal_approx(sticks - G.inventory.count("stick"), 3.0 * 0.96), "a Handy builder is charged the lower price when paying (%.2f sticks)" % (sticks - G.inventory.count("stick")))
	# old saves: the practice per station becomes batches per family
	var old := {"practice": {"campfire": 12, "workbench": 5, "wild_edge": 3}, "skills": {}}
	G.upgrade_save_v2(old)
	_check(int(old["skills"].get("cooking", 0)) == 12 and int(old["skills"].get("fibre", 0)) == 5 and not old.has("practice") and not old["skills"].has(""), "old practice becomes batches (campfire 12 → cooking, workbench 5 → fibre, the field edge nothing)")
	G.upgrade_save_v2(old)
	_check(int(old["skills"].get("cooking", 0)) == 12, "the step is harmless when run again")
	# loading a farm does not announce the ranks it has
	G.reset_game()
	G.S["skills"]["cooking"] = 12
	G.save_to("user://skills_test.json")
	told.clear()
	G.load_game("user://skills_test.json")
	_check(told.is_empty() and G.skills.rank("cooking") == 1 and int(G.S["skill_rank"]["cooking"]) == 1, "a loaded farm keeps its ranks without a fuss")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://skills_test.json"))
	print("SKILLS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
