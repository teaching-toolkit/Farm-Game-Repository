extends Node
## Quality (TODO Y1): grades in the store, which one is used and sold first, the chances, what goes into a crop's or a dish's expected grade,
## selling by grade. Rules only, no screen.
## Run:  godot --headless --path . res://tests/quality_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var Q = G.quality
	# data
	_check(Q.levels().size() == 3 and Q.level_name(0) == "Lumpy" and Q.level_name(2) == "Fancy", "three grades: Lumpy, Proper, Fancy")
	_check(Q.graded("bread") and Q.graded("carrot") and not Q.graded("stone") and not Q.graded("egg"), "dishes and crops have a grade, raw materials and animal products do not")
	_check(Q.stars(0) == "⭐" and Q.stars(2) == "⭐⭐⭐", "stars")
	# chances
	var d: Array = Q.distribution(1.0)
	_check(is_equal_approx(float(d[0]) + float(d[1]) + float(d[2]), 1.0), "the chances add up to 1")
	_check(is_equal_approx(float(d[0]), 0.07) and is_equal_approx(float(d[2]), 0.07) and is_equal_approx(float(d[1]), 0.86), "Proper expected: 86 % Proper, 7 % each side")
	var d2: Array = Q.distribution(2.0)
	_check(float(d2[2]) > 0.9 and float(d2[0]) < 0.01, "Fancy expected: almost always Fancy")
	var d3: Array = Q.distribution(1.5)
	_check(float(d3[2]) > float(d[2]) and float(d3[1]) > 0.4, "between Proper and Fancy: both likely")
	var mean := 0.0
	var f := 0.0
	for i in range(4000):
		var g: int = Q.roll(1.0)
		mean += float(g)
		f += Q.price_factor(g)
	_check(absf(mean / 4000.0 - 1.0) < 0.05, "mean grade at E = 1.0 is about Proper (%.3f)" % (mean / 4000.0))
	_check(absf(f / 4000.0 - 1.0) < 0.05, "…and the mean price factor is about 1 (%.3f)" % (f / 4000.0))
	_check(Q.expect_text(1.0).begins_with("⭐⭐ ") and Q.expect_text(1.5).contains("maybe"), "the tile text: the likely grade, and a maybe when another is a real chance (%s | %s)" % [Q.expect_text(1.0), Q.expect_text(1.5)])
	# the store: grades, order of use, selling
	G.S["inv"].clear()
	G.inventory.add_item("carrot", 3.0, true, 2)
	G.inventory.add_item("carrot", 2.0, true, 0)
	G.inventory.add_item("carrot", 4.0, true)                   # no grade given: Proper
	G.inventory.add_item("carrot", 1.0, true, 2)               # merges with the Fancy ones
	var gs: Dictionary = G.inventory.grades("carrot")
	_check(float(gs[2]) == 4.0 and float(gs[1]) == 4.0 and float(gs[0]) == 2.0 and G.inventory.count("carrot") == 10.0, "batches of the same grade merge, count adds all grades: %s" % str(gs))
	_check(G.inventory.count_min("carrot", 1) == 8.0 and G.inventory.count_min("carrot", 2) == 4.0, "count of a grade or better")
	G.inventory.add_item("stone", 5.0, true, 2)
	_check(G.inventory.grades("stone").keys() == [1] and G.S["inv"]["stone"][0].size() == 2, "a raw material has no grade (the grade given is ignored)")
	var peek: Vector2 = G.inventory.peek_grades("carrot", 3.0)
	_check(peek == Vector2(3.0, 0.0 * 2 + 1.0 * 1), "using 3 takes the two Lumpy and one Proper first (peek: %s)" % str(peek))
	G.inventory.start_track()
	G.inventory.take("carrot", 3.0)
	var avg: float = G.inventory.stop_track()
	_check(is_equal_approx(avg, 1.0 / 3.0), "…and that is what take does (average grade %.2f)" % avg)
	_check(G.inventory.count("carrot") == 7.0 and not G.inventory.grades("carrot").has(0), "the Lumpy ones are gone")
	_check(G.inventory.best_first("carrot", 6) == [2, 2, 2, 2, 1, 1], "selling goes best first")
	# prices
	var base: float = G.inventory.value_of("carrot")
	_check(is_equal_approx(G.trade.full_price("carrot", 0), base * 0.6) and is_equal_approx(G.trade.full_price("carrot", 2), base * 1.5), "Lumpy pays 60 %, Fancy 150 %")
	var t1: float = G.trade.sell_total("carrot", 1)
	_check(is_equal_approx(t1, base * 1.5), "the next one to sell is Fancy (%.2f)" % t1)
	var coins0: float = G.S["coins"]
	G.trip.test_square()
	G.trade.sell("carrot", 5.0)
	var paid: float = G.S["coins"] - coins0
	_check(paid > base * 5.0 * 1.0 and G.inventory.grades("carrot").get(2, 0.0) == 0.0 and G.inventory.count("carrot") == 2.0, "five sold: the four Fancy and one Proper (paid %.1f), two Proper left" % paid)
	# a crop's expected grade
	var p := {"soil": 1.0, "weeds": 0.0, "stones": 0.0, "quality": 1.0}
	_check(is_equal_approx(Q.crop_expect(p), 1.0), "a clean, ordinary patch: Proper")
	p["soil"] = 1.1
	_check(Q.crop_expect(p) > 1.2, "rested soil adds")
	p["soil"] = 0.9
	_check(Q.crop_expect(p) < 0.8, "tired soil takes away")
	p["soil"] = 1.0; p["weeds"] = 6.0
	_check(is_equal_approx(Q.crop_expect(p), 0.6), "6 weeds: 4 over the free 2, -0.4 (the most)")
	p["weeds"] = 30.0; p["stones"] = 30.0
	_check(is_equal_approx(Q.crop_expect(p), 1.0 - 0.4 - 0.3), "weeds and stones have limits")
	p = {"soil": 1.0, "weeds": 0.0, "stones": 0.0, "quality": 0.85}
	_check(is_equal_approx(Q.crop_expect(p), 1.0 - 0.15 * 1.5), "a patch not cleared completely gives less")
	G.S["unlocked"]["patch_raised"] = true
	G.invalidate_caps()
	p["quality"] = 1.0
	_check(is_equal_approx(Q.crop_expect(p), 1.1), "an upgrade of the field adds (raised beds +0.1)")
	# a harvest gives the grade the patch earns
	G.S["unlocked"]["patch_dug"] = true
	var area: Array = G.fields.area("field")
	G.S["energy"] = 50.0
	var pt = area[0]
	pt["crop"] = "crop_wheat"; pt["plants"] = 2.0; pt["growth"] = 99.0; pt["ready"] = true; pt["weeds"] = 30.0; pt["stones"] = 30.0; pt["soil"] = 0.8; pt["quality"] = 0.5
	var low := 0
	for i in range(20):
		G.S["inv"].erase("wheat")
		pt["crop"] = "crop_wheat"; pt["plants"] = 2.0; pt["growth"] = 99.0; pt["ready"] = true
		G.actions.perform("harvest", G.actions.farmer, {"a": "field", "i": 0})
		for g in G.inventory.grades("wheat"): if int(g) == 0: low += 1
	_check(low >= 14, "a neglected patch mostly gives Lumpy (%d of 20 harvests)" % low)
	# a recipe: better inputs, better dish; a better station, better dish
	var rid := ""
	for r in G.recipes:
		if G.recipes[r]["station"] == "campfire" and G.crafting.makes_graded(r) and G.recipes[r].get("inputs", {}).size() == 1: rid = r; break
	_check(rid != "", "a one-input campfire recipe to test with (%s)" % rid)
	if rid != "":
		var r: Dictionary = G.recipes[rid]
		var inp: String = r["inputs"].keys()[0]
		G.S["inv"].clear()
		G.S["unlocked"]["campfire"] = true
		var e_plain: float = Q.recipe_expect(rid)
		if Q.graded(inp):
			G.inventory.add_item(inp, 20.0, true, 2)
			var e_fancy: float = Q.recipe_expect(rid)
			G.S["inv"].clear()
			G.inventory.add_item(inp, 20.0, true, 0)
			var e_lumpy: float = Q.recipe_expect(rid)
			_check(e_fancy > e_plain and e_lumpy < e_plain, "Fancy inputs raise the expected grade, Lumpy ones lower it (%.2f / %.2f / %.2f)" % [e_lumpy, e_plain, e_fancy])
		else:
			_check(true, "(the input of that recipe has no grade)")
	G.S["unlocked"]["stove_1"] = true
	G.S["unlocked"]["oven_2"] = true
	G.invalidate_caps()
	_check(float(Q.data()["stationBonus"]["oven_2"]) > float(Q.data()["stationBonus"]["campfire"]), "a better oven has a higher bonus than a campfire")
	print("QUALITY %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
