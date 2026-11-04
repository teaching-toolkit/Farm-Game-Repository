extends Node
## What the forest edge gives (TODO N1–N5): pools that fall when gathered and grow back, trees that go round a cycle, a yield that falls
## with the pool but never below 1, a piece of advice when it gets thin. Rules only.
## Run:  godot --headless --path . res://tests/nature_test.tscn -- --seed=1
const Spots = preload("res://game/farm/spots.gd")
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var N = G.nature
	_check(N.fill("sticks") == 1.0 and N.fill("trees") == 1.0 and N.scaled("gather_sticks", 2.0) == 2.0, "at first everything is full and a tap gives its full yield")
	_check(not N.known(), "the numbers are not shown before the card is learned")
	var smax: float = N.pool_max("sticks")
	N.took("gather_sticks")
	_check(is_equal_approx(N.level("sticks"), smax - 2.0), "gathering sticks takes 2 from the pool")
	N.step()
	_check(is_equal_approx(N.level("sticks"), smax - 2.0 + float(N.pools()["sticks"]["regrow"])), "…and it grows back a little every question")
	for _i in range(100): N.step()
	_check(is_equal_approx(N.level("sticks"), N.pool_max("sticks")), "…but not beyond its maximum")
	# a thin pool gives less, never less than 1
	for _i in range(int(smax / 2.0) - 3): N.took("gather_sticks")
	_check(N.fill("sticks") < 0.35 and N.scaled("gather_sticks", 2.0) == 1.0, "a low pool gives 1 instead of 2 (%.2f)" % N.fill("sticks"))
	_check(N.scaled("pick_stones", 1.0) == 1.0, "one stone stays one stone")
	for _i in range(40): N.took("dig_stones")
	_check(N.level("stones") == 0.0 and N.scaled("dig_stones", 3.0) >= 1.0, "an empty pool still gives a little (the basics are always there)")
	# the advice comes once, then after a while again
	G.S["nature"]["advice"] = {}
	G.S["step"] = 100
	var log0: int = G.S["log"].size()
	N.took("gather_sticks")
	var log1: int = G.S["log"].size()
	N.took("gather_sticks")
	_check(log1 > log0 and G.S["log"].size() == log1, "the advice comes once")
	G.S["step"] += int(N.data()["adviceEvery"]) + 1
	N.took("gather_sticks")
	_check(G.S["log"].size() > log1, "…and again a long time after")
	# trees: tree → stump → sapling → tree, the total stays the same
	G.reset_game()
	N = G.nature
	var total: float = N.trees() + N.stumps() + N.saplings()
	for _i in range(6): N.took("chop_deadwood")
	_check(is_equal_approx(N.trees(), N.pool_max("trees") - 6.0) and is_equal_approx(N.stumps(), 6.0), "felled trees become stumps")
	_check(N.factor("trees") < 1.0 and N.scaled("chop_deadwood", 1.0) == 1.0, "fewer trees: the yield stays at least 1")
	for _i in range(15): N.step()
	_check(N.saplings() > 0.5, "after a while stumps give saplings (%.1f)" % N.saplings())
	for _i in range(200): N.step()
	_check(is_equal_approx(N.trees() + N.stumps() + N.saplings(), total) and N.trees() > N.pool_max("trees") - 0.5, "…and in the end the trees are back (%.1f)" % N.trees())
	# the numbers show once the card is learned
	G.S["unlocked"]["k_regrow"] = true
	_check(N.known(), "the card shows the numbers")
	_check(G.nodes["k_regrow"]["type"] == "knowledge" and (G.nodes["k_regrow"]["questions"] as Array).size() == 3, "the card has its quiz")
	# through the real recipe: a gather recipe at the forest edge gives the scaled yield and takes from the pool
	G.reset_game()
	G.S["unlocked"]["wild_edge"] = true
	G.invalidate_caps()
	G.S["energy"] = 50.0
	G.S["nature"]["pool"]["sticks"] = 4.0
	var s0: float = G.inventory.count("stick")
	_check(G.actions.perform("recipe", G.actions.farmer, {"rid": "gather_sticks"})["done"], "gathering sticks works")
	_check(is_equal_approx(G.inventory.count("stick") - s0, 1.0) and is_equal_approx(G.nature.level("sticks"), 2.0), "a thin pool: 1 stick instead of 2, and the pool falls by 2")
	_check(G.nature.save_defaults().has("nature"), "the save key has defaults")
	# nature/05: digging clay happens at the clay pit by the pond, not at the forest edge; the clay pool shows there
	G.reset_game()
	N = G.nature
	_check(G.done("clay_pit") and str(G.recipes["dig_clay"]["station"]) == "clay_pit", "a new farm has the clay pit, and dig clay is its chore")
	_check(Spots.spot_of(G, "clay_pit") == "pond" and Spots.spot_of(G, "wild_edge") == "forest", "the clay pit is at the pond, the forest edge stays at the forest")
	_check(not G.crafting.station_recipes_for("wild_edge").has("dig_clay"), "the forest edge offers no clay any more")
	_check(N.pools_at("clay_pit") == ["clay"] and not N.pools_at("wild_edge").has("clay") and N.pools_at("wild_edge").has("sticks") and N.pools_at("wild_edge").has("trees"), "the clay pool shows at the pond, sticks, stones and trees at the forest edge (%s / %s)" % [N.pools_at("clay_pit"), N.pools_at("wild_edge")])
	G.S["unlocked"]["wooden_shovel"] = true
	G.invalidate_caps()
	G.S["energy"] = 50.0
	var c0: float = G.inventory.count("clay")
	var e0: float = float(G.S["energy"])
	_check(G.actions.perform("recipe", G.actions.farmer, {"rid": "dig_clay"})["done"], "digging clay at the pond works with the shovel")
	_check(is_equal_approx(G.inventory.count("clay") - c0, 1.0) and is_equal_approx(N.level("clay"), N.pool_max("clay") - 1.0) and e0 - float(G.S["energy"]) > 0.0, "…gives 1 clay, takes 1 from the clay pool and costs energy")
	_check(G.crafting.recipe_left("dig_clay") > 0.0 and (G.S["running"].get("wild_edge", []) as Array).is_empty(), "…and it is the clay pit that refills, not a spot at the forest edge")
	# an old save (before nature/05): no clay pit yet, clay in the store and a thin clay pool: the count and the pool stay
	var old: Dictionary = G.S.duplicate(true)
	old["unlocked"].erase("clay_pit")
	old["running"] = {"wild_edge": [{"recipe": "dig_clay", "left": 1.0, "cool": true}]}
	old["nature"]["pool"]["clay"] = 7.0
	var clay_before: float = G.inventory.count("clay") + 4.0
	G.inventory.add_item("clay", 4.0, true)
	old["inv"] = G.S["inv"].duplicate(true)
	var path := "user://nature_test_old.json"
	G.S = old
	G.save_to(path)
	_check(G.load_game(path), "the old save loads")
	_check(G.done("clay_pit") and is_equal_approx(G.inventory.count("clay"), clay_before) and is_equal_approx(G.nature.level("clay"), 7.0), "…with the clay pit, the same clay in the store (%.0f) and the same clay pool (%.1f)" % [G.inventory.count("clay"), G.nature.level("clay")])
	G.crafting.tick_stations()
	_check((G.S["running"].get("wild_edge", []) as Array).is_empty(), "…and a clay dig still refilling at the forest edge is done after one question")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("NATURE %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
