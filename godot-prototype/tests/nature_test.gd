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
	_helper_rests()
	_seasons_fade()
	print("NATURE %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

## N7: the season's look fades in over the first questions of a season instead of jumping (G.seasons.blend(): {from, to, t}, from the step alone)
func _seasons_fade() -> void:
	G.reset_game()
	var Se = G.seasons
	var slen: int = Se.season_len()
	var fade := int(G.feel("season.fadeQuestions"))
	_check(fade >= 2 and fade < slen, "the fade is a few questions, shorter than a season (%d of %d)" % [fade, slen])
	G.S["step"] = 0
	_check(Se.blend()["t"] == 1.0 and Se.blend()["to"] == "spring", "the first spring has no season before it: no fade")
	var seen := {}
	for no in range(1, 9):                                    # every change of season, two years
		var to: String = G.SEASON_NAMES[no % 4]
		G.S["step"] = no * slen
		var b: Dictionary = Se.blend()
		_check(b["to"] == to and b["from"] == G.SEASON_NAMES[(no + 3) % 4] and b["t"] == 0.0, "%s: at its first question the look is still the last season's (%s)" % [to, b])
		var t_before := 0.0
		var full_at := -1
		for q in range(0, slen):
			G.S["step"] = no * slen + q
			var t: float = Se.blend()["t"]
			if t < t_before - 0.000001: seen["down"] = "%s at %d" % [to, q]
			if t >= 1.0 and full_at < 0: full_at = q
			if full_at >= 0 and t < 1.0: seen["back"] = "%s at %d" % [to, q]
			t_before = t
		_check(full_at >= 0 and full_at <= fade, "%s: the look has fully arrived by question %d (%d)" % [to, fade, full_at])
		G.S["step"] = no * slen + 1
		var t1: float = Se.blend()["t"]
		_check(t1 > 0.0 and t1 < 1.0, "%s: after one question it has begun to change (%.2f)" % [to, t1])
		G.S["step"] = no * slen + slen / 2
		_check(Se.blend()["t"] == 1.0, "%s: in the middle of the season it is the new look" % to)
	_check(seen.is_empty(), "t only rises during a season and never falls back (%s)" % [seen])
	_check(not Se.save_defaults().has("blend"), "no save key: the fade comes from the step")
	# the shader's two strengths follow it: winter fades out into spring, autumn into winter
	G.S["step"] = 3 * slen + 1
	var bw: Dictionary = Se.blend()
	var w1 := FarmSeasonLook.share(bw, "winter")
	var a1 := FarmSeasonLook.share(bw, "autumn")
	_check(w1 > 0.0 and w1 < 0.5 and a1 > 0.5 and a1 < 1.0 and is_equal_approx(w1 + a1, 1.0), "autumn to winter: autumn fades out (%.2f), winter fades in (%.2f)" % [a1, w1])
	G.S["step"] = 4 * slen + 1
	var bs: Dictionary = Se.blend()
	_check(FarmSeasonLook.share(bs, "winter") > 0.5 and FarmSeasonLook.share(bs, "winter") < 1.0 and FarmSeasonLook.share(bs, "spring") > 0.0, "winter to spring: the snow caps are still there, but fading")
	_check(FarmSeasonLook.mix(bs, {"winter": Color.BLACK, "spring": Color.WHITE}).r > 0.0 and FarmSeasonLook.mix(bs, {"winter": Color.BLACK, "spring": Color.WHITE}).r < 0.5, "a colour of the map is a mix of the two seasons' colours")

## N5: the advice is ignored and the woods are over-used: the Helper whose job draws on them rests from that one job (a 🌱 at the forest, said once)
## until the balance is back, then goes on. It never leaves, its other jobs and the farmer are not touched.
func _helper_rests() -> void:
	G.reset_game()
	var N = G.nature
	var P = G.pets
	G.S["unlocked"]["pet_pony"] = true
	G.S["unlocked"]["pet_badger"] = true
	G.invalidate_caps()
	_check(P.level("pet_pony") == 2 and P.chosen("pet_pony") == "log", "the pony is a level 2 Helper that hauls logs")
	var logs0: float = G.inventory.count("log")
	for _i in range(4): P.step({})
	_check(G.inventory.count("log") - logs0 >= 1.0 and N.pause_of("pet_pony", "log").is_empty(), "while the trees are fine the pony hauls a log every few questions")
	for _i in range(11): N.took("chop_deadwood")      # 3 of 14 trees are left: the advice has come
	_check(N.fill("trees") < float(N.data()["adviceBelow"]) and not N.resting("trees"), "a little above the line the Helper still works (%.2f)" % N.fill("trees"))
	N.took("chop_deadwood")
	_check(N.resting("trees") and N.pause_of("pet_pony", "log").get("pool", "") == "trees", "…ignored on, the trees rest and the pony's log job pauses (%.2f)" % N.fill("trees"))
	_check(N.pause_of("pet_pony", "stick").is_empty() and N.pause_of("pet_bunny", "log").is_empty(), "…only that one job of that one Helper")
	var logs1: float = G.inventory.count("log")
	var say0: int = G.S["log"].size()
	var act := {}
	var rested := 0
	var held_between := false
	var back_says := 0
	while N.resting("trees") and rested < 600:
		var info := {}
		P.step(info)
		for a in info.get("pet_acts", []):
			if a["pet"] == "pet_pony": act = a
		if rested == 0:
			_check(act.get("ok", true) == false and act.get("why", "") == "rest" and act.get("emoji", "") == "🌱" and act.get("place", "") == "spot:forest", "the pony shows a 🌱 at the forest instead of hauling (%s)" % str(act))
			_check(P.last("pet_pony")["why"] == "rest" and not P.last("pet_pony")["ok"], "…and the board says it rests")
		N.step()
		rested += 1
		if N.resting("trees") and N.fill("trees") >= float(N.data()["pauseBelow"]): held_between = true
	_check(is_equal_approx(G.inventory.count("log"), logs1) and rested > 5, "all that time no log is hauled (%d questions)" % rested)
	_check(held_between and N.fill("trees") >= float(N.data()["pauseUntil"]), "the rest holds until the balance is back, not only until the trees rise a little (%.2f)" % N.fill("trees"))
	var said := 0
	for i in range(say0, G.S["log"].size()): if str(G.S["log"][i]).contains("taking a rest"): said += 1
	_check(said == 1, "the Helper says so once, when the rest begins (%d)" % said)
	_check(G.done("pet_pony") and P.level("pet_pony") == 2, "the Helper stays")
	for _i in range(6):
		var info2 := {}
		P.step(info2)
		N.step()
	for i in range(say0, G.S["log"].size()): if str(G.S["log"][i]).contains("is helping again"): back_says += 1
	_check(G.inventory.count("log") > logs1 and P.last("pet_pony")["why"] != "rest" and back_says == 1, "when the trees are back the pony hauls again, and says so once (%d)" % back_says)
	# the sticks have their own Helper job; stones and clay have none: only their floor
	G.reset_game()
	N = G.nature
	for _i in range(16): N.took("gather_sticks")
	_check(not N.resting("sticks") and N.pause_of("pet_pony", "stick").is_empty(), "sticks a little above the line: no rest yet (%.2f)" % N.fill("sticks"))
	N.took("gather_sticks")
	_check(N.resting("sticks") and N.pause_of("pet_pony", "stick").get("pool", "") == "sticks" and N.pause_of("pet_pony", "log").is_empty(), "sticks run out: the pony's stick job rests, not its log job")
	for _i in range(40): N.took("dig_stones")
	_check(not N.resting("stones") and N.scaled("dig_stones", 3.0) >= 1.0, "stones have no Helper job to pause: only the floor")
	# an old save has no "rest" key: it loads and works
	G.S["nature"].erase("rest")
	N.step()
	_check(N.resting("sticks") and N.save_defaults()["nature"].has("rest"), "an old save without rest works (the rest is found again at the next question)")

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
