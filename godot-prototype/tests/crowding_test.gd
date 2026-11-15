extends Node
## Weeds and stones crowd a patch (crops-and-items/02): they no longer slow growth; every whole weed and stone takes 4 % of the harvest,
## together at most 75 %, and the grade stays affected. What is lost is told to the map (G.crowded_out). Rules only, no screen.
## Run:  godot --headless --path . res://tests/crowding_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0
var heard := []        # every G.crowded_out of the harvests below: [source, lost]

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	G.crowded_out.connect(func(source: String, lost: Dictionary): heard.append([source, lost]))
	var F = G.fields
	var cr: Dictionary = G.meta.get("crowding", {})
	_check(is_equal_approx(float(cr.get("perThing", 0)), 0.04) and is_equal_approx(float(cr.get("max", 0)), 0.75), "the numbers are in data: 4 % each, at most 75 %")
	_check(not G.meta.get("stones", {}).has("slowPerStone"), "the old slowing number is gone from the data")
	# the share lost
	var p := {"weeds": 0.0, "stones": 0.0}
	_check(F.crowd_things(p) == 0 and F.crowd_loss(p) == 0.0, "a clean patch loses nothing")
	p["weeds"] = 3.9; p["stones"] = 1.4
	_check(F.crowd_things(p) == 4 and is_equal_approx(F.crowd_loss(p), 0.16), "whole weeds and stones count (3 and 1): 16 %")
	p["weeds"] = 0.6; p["stones"] = 0.4
	_check(F.crowd_things(p) == 0, "less than one is nothing (it is not drawn, and cannot be pulled either)")
	p["weeds"] = 12.0; p["stones"] = 6.0
	_check(is_equal_approx(F.crowd_loss(p), 0.72), "twelve weeds and six stones: 72 %")
	p["weeds"] = 30.0; p["stones"] = 30.0
	_check(is_equal_approx(F.crowd_loss(p), 0.75), "never more than 75 %")
	# the plants shown wilted
	p = {"weeds": 5.0, "stones": 0.0, "plants": 6.0}
	_check(F.crowd_plants(p) == 1, "20 %% of six plants: one is crowded out (%d)" % F.crowd_plants(p))
	p["weeds"] = 12.0; p["stones"] = 6.0
	_check(F.crowd_plants(p) == 4, "72 %% of six plants: four (%d)" % F.crowd_plants(p))
	p["plants"] = 1.0; p["weeds"] = 1.0; p["stones"] = 0.0
	_check(F.crowd_plants(p) == 0, "a single plant shows nothing for one weed")
	# growth: weeds and stones do not slow it any more
	G.S["step"] = 0
	var clean := {"crop": "crop_wheat", "plants": 1.0, "growth": 0.0, "ready": false, "weeds": 0.0, "stones": 0.0, "soil": 1.0}
	var messy: Dictionary = clean.duplicate()
	messy["weeds"] = 12.0; messy["stones"] = 6.0
	_check(is_equal_approx(F.grow_speed("field", clean), F.grow_speed("field", messy)), "growth is as quick with twelve weeds and six stones as without")
	# the harvest: with a lost share, the main crop's mean falls by that share; the lost crops are told; nothing is lost when it is clean
	var clean_mean := _harvest_mean(0.0, 0.0, 2.0, 400)
	var half_mean := _harvest_mean(5.0, 5.0, 2.0, 400)       # ten things: 40 %
	var heavy_mean := _harvest_mean(12.0, 6.0, 2.0, 400)      # 72 %
	_check(clean_mean > 2.0, "a clean patch of two wheat plants gives a harvest (%.2f)" % clean_mean)
	_check(absf(half_mean / clean_mean - 0.6) < 0.06, "40 %% crowded: about 60 %% of the clean harvest (%.2f of %.2f)" % [half_mean, clean_mean])
	_check(absf(heavy_mean / clean_mean - 0.28) < 0.06, "72 %% crowded: about 28 %% (%.2f of %.2f)" % [heavy_mean, clean_mean])
	heard.clear()
	_harvest_mean(0.0, 0.0, 6.0, 5)
	_check(heard.is_empty(), "a clean harvest tells nothing about losses")
	heard.clear()
	_harvest_mean(8.0, 4.0, 6.0, 5)
	_check(heard.size() > 0 and str(heard[0][0]) == "patch:field:0" and float(heard[0][1].get("wheat", 0.0)) >= 1.0, "a crowded harvest tells which crops were lost, at which patch")
	# what is lost + what is kept = what the plants gave: the lost crops are the ones that did not arrive
	G.S["inv"].clear()
	_set_patch(10.0, 5.0, 4.0)
	heard.clear()
	G.rng.seed = 7
	var before: float = G.inventory.count("wheat")
	var done: bool = G.actions.perform("harvest", G.actions.farmer, {"a": "field", "i": 0})["done"]
	var got: float = G.inventory.count("wheat") - before
	var lost_w := 0.0
	for h in heard: lost_w += float(h[1].get("wheat", 0.0))
	_check(done and got >= 1.0 and lost_w >= 0.0 and got + lost_w >= 4.0, "kept (%d) and lost (%d) wheat together are what four plants gave" % [int(got), int(lost_w)])
	# the main crop never drops to nothing
	var worst := 99.0
	for _i in range(60):
		G.S["inv"].clear()
		_set_patch(30.0, 30.0, 1.0)
		G.actions.perform("harvest", G.actions.farmer, {"a": "field", "i": 0})
		worst = minf(worst, G.inventory.count("wheat"))
	_check(worst >= 1.0, "one plant under 75 %% weeds and stones still gives at least one wheat (%d)" % int(worst))
	# the grade is still hit by weeds and stones
	var cp := {"soil": 1.0, "weeds": 8.0, "stones": 4.0, "quality": 1.0}
	_check(G.quality.crop_expect(cp) < 0.7, "weeds and stones still lower the grade (%.2f)" % G.quality.crop_expect(cp))
	# pulling the weeds and picking the stones first gives the harvest back
	_set_patch(6.0, 3.0, 4.0)
	G.S["energy"] = 99.0
	G.actions.perform("weed", G.actions.farmer, {"i": 0})
	G.actions.perform("weed", G.actions.farmer, {"i": 0})
	G.actions.perform("pick_stones", G.actions.farmer, {"i": 0})
	G.actions.perform("pick_stones", G.actions.farmer, {"i": 0})
	_check(F.crowd_things(G.S["patches"][0]) == 0 and F.crowd_loss(G.S["patches"][0]) == 0.0, "after pulling and picking, nothing crowds the patch")
	# old saves: a patch has no new key, so nothing to migrate
	_check(not F.save_defaults().has("crowding"), "no new save key")
	print("CROWDING %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

## Patch 0 of the field: four plants (or n) of wheat, ripe, with this many weeds and stones.
func _set_patch(weeds: float, stones: float, plants: float) -> void:
	var p: Dictionary = G.S["patches"][0]
	p["crop"] = "crop_wheat"; p["plants"] = plants; p["growth"] = 99.0; p["ready"] = true
	p["weeds"] = weeds; p["stones"] = stones; p["soil"] = 1.0; p["quality"] = 1.0
	G.S["energy"] = 99.0; G.S["moments"] = 0      # a fresh step for every harvest

## The mean wheat a harvest of this patch gives (in the store), over n harvests.
func _harvest_mean(weeds: float, stones: float, plants: float, n: int) -> float:
	var tot := 0.0
	for _i in range(n):
		G.S["inv"].clear()
		_set_patch(weeds, stones, plants)
		G.actions.perform("harvest", G.actions.farmer, {"a": "field", "i": 0})
		tot += G.inventory.count("wheat")
	return tot / float(n)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
