extends Node
## Hay and winter wheat (TODO U1, U5): a crop that is sown only in some seasons, the grain or hay you keep is the seed. Rules only.
## Run:  godot --headless --path . res://tests/crops_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var n: Dictionary = G.nodes["crop_winter_wheat"]
	_check(G.fields.seed_have("crop_hay") == 0.0 and G.fields.seed_have("crop_winter_wheat") == 0.0, "no hay and no winter wheat at the start")
	G.inventory.add_item("winter_wheat", 3.0, true)
	G.inventory.add_item("hay", 3.0, true)
	G.S["water"] = 50.0
	G.S["energy"] = 50.0
	G.S["step"] = 0      # spring
	var plan: Dictionary = G.fields.plant_plan("field", "crop_winter_wheat")
	_check(G.seasons.season() == "spring" and int(plan["plants"]) == 0 and plan["reasons"].has("season"), "winter wheat is not sown in spring")
	_check(not G.fields.sow_season_ok(n) and G.fields.sow_season_ok(G.nodes["crop_hay"]), "…but hay has no season")
	G.S["step"] = G.seasons.season_len() * 2      # autumn
	plan = G.fields.plant_plan("field", "crop_winter_wheat")
	_check(G.seasons.season() == "autumn" and int(plan["plants"]) >= 1 and not plan["reasons"].has("season"), "in autumn it can be sown")
	G.S["step"] = G.seasons.season_len() * 3      # winter
	plan = G.fields.plant_plan("field", "crop_winter_wheat")
	_check(G.seasons.season() == "winter" and int(plan["plants"]) >= 1, "…and in winter")
	var yields: Dictionary = G.nodes["crop_hay"]["yields"]
	_check(float(yields["hay"]) > float(G.nodes["crop_hay"].get("seedCost", 0)) and G.nodes["crop_hay"]["seedItem"] == "hay", "hay gives more hay than is sown (the hay you keep is the seed)")
	_check(float(n["yields"]["winter_wheat"]) > float(G.nodes["crop_wheat"]["yields"]["wheat"]), "winter wheat gives more grain than summer wheat")
	_check(G.items["hay"]["tags"].has("fodder") and G.recipes.has("straw_hutch_hay"), "hay is fodder and can make the straw hutch")
	# winter (TODO N6): only hardy crops outdoors, snow on the empty patches until cleared, a quarter of the growing speed
	G.reset_game()
	G.S["unlocked"]["clear_thistles"] = true
	G.S["unlocked"]["crop_potato"] = true
	G.invalidate_caps()
	G.S["step"] = G.seasons.season_len() * 3
	_check(G.seasons.season() == "winter", "it is winter")
	_check(G.seasons.smod("grow", 1.0) == 0.25, "crops in the ground grow at a quarter of their speed")
	_check(not G.fields.sow_ok("field", "crop_potato") and G.fields.sow_ok("field", "crop_onion") and G.fields.sow_ok("field", "crop_winter_wheat") and G.fields.sow_ok("field", "crop_kale"), "outdoors only hardy crops can be sown")
	_check(G.fields.sow_ok("gh", "crop_potato") and G.fields.sow_ok("orchard", "crop_potato"), "the greenhouse and the orchard do not mind")
	var pl: Dictionary = G.fields.plant_plan("field", "crop_potato")
	_check(int(pl["plants"]) == 0 and pl["reasons"].has("cold"), "the plan says too cold")
	G.S["inv"]["onion"] = []
	G.inventory.add_item("onion", 5.0, true)
	G.S["seeds"]["crop_onion"] = 5.0
	G.S["water"] = 30.0
	G.S["energy"] = 30.0
	G.fields.snowfall()
	_check(G.fields.snow_count() >= 1 and G.fields.patch_snow(0), "snow covers the empty patches")
	_check(not G.actions.perform("plant", G.actions.farmer, {"a": "field", "i": 0, "cid": "crop_onion"})["done"], "nothing is sown under snow")
	var e0: float = G.S["energy"]
	_check(G.actions.perform("clear_snow", G.actions.farmer, {"i": 0})["done"] and not G.fields.patch_snow(0) and G.S["energy"] < e0, "clearing the snow costs energy")
	G.S["step"] = G.seasons.season_len() * 4
	G.fields.snowfall()
	G.seasons.step_season({})
	_check(G.fields.snow_count() == 0, "in spring the snow melts")
	for sn in ["spring", "summer", "autumn", "winter"]:
		_check(str(G.meta["seasons"]["mods"][sn].get("intro", "")) != "", "%s has a text for the start of the season (N8)" % sn)
	_seed_saving()
	_wet_soil()
	_stubble()
	print("CROPS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

## Seed from your own plants (crops-and-items/01, U2): a carrot left to flower stays through one winter, the patch is taken meanwhile,
## in spring it gives seed (the number is data) and the patch is free. Grain is unchanged; old saves load.
func _seed_saving() -> void:
	var A = G.actions
	G.reset_game()
	var card: String = G.meta["seedSaving"]["card"]
	_check(G.nodes[card]["name"] == "Saving seed" and not G.done(card), "the card Saving seed is the one that teaches it (not read yet)")
	for cid in ["crop_carrot", "crop_onion", "crop_beet"]:
		_check(bool(G.nodes[cid].get("seedYear", false)) and int(G.nodes[cid].get("seedYield", 0)) > 1 and G.nodes[cid].has("seedCost"), "%s is a two-year crop with a seed yield, and its seed can still be bought" % cid)
	_check(not G.nodes["crop_wheat"].has("seedYear") and not G.nodes["crop_potato"].has("seedYear"), "grain and the other crops are no two-year crops")
	G.S["energy"] = 80.0
	G.S["water"] = 60.0
	G.S["step"] = 0      # spring
	G.S["seeds"]["crop_carrot"] = 5.0
	var carrot_seed: float = G.S["seeds"]["crop_carrot"]
	_check(A.perform("plant", A.farmer, {"a": "field", "i": 0, "cid": "crop_carrot"})["done"], "a carrot is planted")
	var p: Dictionary = G.S["patches"][0]
	var plants := int(p["plants"])
	var fargs := {"a": "field", "i": 0}
	_check(not A.check("let_flower", A.farmer, fargs)["ok"] and A.check("let_flower", A.farmer, fargs)["unmet"][0]["key"] == "nothing_to_do", "a carrot that is still growing cannot be left to flower")
	p["ready"] = true; p["growth"] = 99.0
	var q: Dictionary = A.check("let_flower", A.farmer, fargs)
	_check(not q["ok"] and q["unmet"][0]["key"] == "card" and q["unmet"][0]["text"] != "", "before the card Saving seed is read: refused, with a sentence")
	_check(not A.perform("let_flower", A.farmer, fargs)["done"] and not G.fields.flowering(p) and p["ready"], "…and nothing changed on the patch")
	G.S["unlocked"][card] = true
	_check(A.check("let_flower", A.farmer, fargs)["ok"] and A.check("let_flower", A.farmer, fargs)["cost"]["energy"] > 0.0, "after the card: the choice is there and costs energy")
	# the first spring: the seed is ripe in the spring after the next whole winter
	_check(G.fields.seed_step_now() == 4 * 30, "left to flower in spring: the seed is ripe one year later, in the next spring")
	G.S["step"] = 65      # autumn
	_check(G.seasons.season() == "autumn" and G.fields.seed_step_now() == 4 * 30, "…in autumn: in the spring after the winter that comes")
	G.S["step"] = 95      # winter, half over
	_check(G.seasons.season() == "winter" and G.fields.seed_step_now() == 8 * 30, "…in winter: that winter is half over, the next one counts")
	G.S["step"] = 10
	var e0: float = G.S["energy"]
	var rep: Dictionary = A.perform("let_flower", A.farmer, fargs)
	_check(rep["done"] and G.S["energy"] < e0 and G.fields.flowering(p) and int(p["seed_at"]) == 4 * 30, "let it flower: energy paid, the patch is flowering until spring")
	_check(p["crop"] == "crop_carrot" and not p["ready"] and not G.fields.growing(p) and int(p["plants"]) == plants, "…the carrot stays, it is not ready and not 'growing'")
	_check(G.fields.plants_growing() == 0.0, "…so it draws no pests")
	_check(not A.check("let_flower", A.farmer, fargs)["ok"], "…and cannot be left to flower twice")
	# the patch is taken: nothing can be sown, nothing harvested
	G.S["seeds"]["crop_onion"] = 5.0
	G.inventory.add_item("wheat", 5.0, true)
	for cid in ["crop_carrot", "crop_onion", "crop_wheat"]:
		var pq: Dictionary = A.check("plant", A.farmer, {"a": "field", "i": 0, "cid": cid})
		_check(not pq["ok"] and pq["unmet"][0]["key"] == "occupied", "while it flowers, %s cannot be sown on the patch" % cid)
	_check(not A.perform("harvest", A.farmer, fargs)["done"] and p["crop"] == "crop_carrot", "…and there is nothing to harvest yet")
	# through the winter, one question at a time: not ripe until the spring comes
	G.S["step"] = 10
	while int(G.S["step"]) < int(p["seed_at"]) - 1: G.step_time()
	_check(G.seasons.season() == "winter" and p["crop"] == "crop_carrot" and not p["ready"] and int(p["plants"]) == plants and G.fields.plants_growing() == 0.0, "on the last question of the winter: still waiting, no plant lost")
	G.step_time()
	_check(G.seasons.season() == "spring" and p["ready"] and G.fields.flowering(p), "in spring the seed is ripe")
	var want: int = plants * int(G.nodes["crop_carrot"]["seedYield"])
	var carrots: float = G.inventory.count("carrot")
	G.S["energy"] = 80.0
	G.S["moments"] = 0
	var seeds0: float = G.S["seeds"]["crop_carrot"]
	rep = A.perform("harvest", A.farmer, fargs)
	_check(rep["done"] and is_equal_approx(float(G.S["seeds"]["crop_carrot"]) - seeds0, float(want)) and want > plants, "harvesting gives the seed from data (%d plants x %d), more than was sown" % [plants, int(G.nodes["crop_carrot"]["seedYield"])])
	_check(G.inventory.count("carrot") == carrots, "…and no carrots: it was left to flower")
	_check(p["crop"] == "" and not p["ready"] and not p.has("seed_at") and p["last"] == "crop_carrot" and not G.fields.flowering(p), "the patch is free again")
	G.S["moments"] = 0
	_check(A.check("plant", A.farmer, {"a": "field", "i": 0, "cid": "crop_wheat"})["ok"], "…and can be sown")
	_check(carrot_seed - plants + float(want) == float(G.S["seeds"]["crop_carrot"]), "the seed count is what was left plus what the flowers gave")
	# grain is unchanged: the harvest is the seed, no choice to flower
	G.S["moments"] = 0
	G.S["step"] = 0
	_check(A.perform("plant", A.farmer, {"a": "field", "i": 0, "cid": "crop_wheat"})["done"], "wheat is planted")
	p["ready"] = true; p["growth"] = 99.0
	_check(not A.check("let_flower", A.farmer, fargs)["ok"] and not G.fields.seed_known("crop_wheat"), "wheat cannot be left to flower")
	var wheat: float = G.inventory.count("wheat")
	var wseeds: float = G.fields.seed_have("crop_wheat")
	G.S["moments"] = 0
	_check(A.perform("harvest", A.farmer, fargs)["done"] and G.inventory.count("wheat") > wheat and G.fields.seed_have("crop_wheat") >= wseeds and p["crop"] == "" and not p.has("seed_at"), "a grain patch is harvested as before: the grain is the seed")
	# saved and loaded: a flowering patch keeps flowering (JSON turns whole numbers into floats); an old patch has no key and is a normal patch
	G.S["moments"] = 0
	G.S["seeds"]["crop_carrot"] = 5.0
	G.S["step"] = 10
	A.perform("plant", A.farmer, {"a": "field", "i": 0, "cid": "crop_carrot"})
	p["ready"] = true
	G.S["moments"] = 0
	_check(A.perform("let_flower", A.farmer, fargs)["done"], "a carrot flowers again")
	G.save_to("user://crops_test.json")
	_check(G.load_game("user://crops_test.json"), "the game loads")
	p = G.S["patches"][0]
	_check(G.fields.flowering(p) and int(p["seed_at"]) == 4 * 30 and not p["ready"] and not G.fields.growing(p), "…the patch is still flowering, for the same spring")
	G.S["step"] = 4 * 30 - 1
	G.step_time()
	_check(p["ready"] and G.fields.flowering(p), "…and its seed is ripe in that spring")
	var old: Dictionary = G.S.duplicate(true)
	for pt in old["patches"]: pt.erase("seed_at")      # a save from before: no patch has the key
	old["patches"][0]["crop"] = "crop_wheat"; old["patches"][0]["ready"] = true; old["patches"][0]["plants"] = 1.0
	G.Saves.write("user://crops_test.json", old)
	_check(G.load_game("user://crops_test.json"), "an old save loads")
	p = G.S["patches"][0]
	_check(not G.fields.flowering(p) and p["ready"] and A.check("harvest", A.farmer, fargs)["ok"] and not A.check("let_flower", A.farmer, fargs)["ok"], "…its patches are normal ones: nothing flowers, a ripe one is harvested")
	_check(not G.fields.flowering(G.fields._blank_patch()) and G.fields.save_defaults().has("seeds"), "a new patch has no 'flowering' key (the key only exists on a flowering patch)")

## Watered soil is dark and dries pale (visible-work/04): a patch is watered when it is planted, so its soil is darkest then and rises, never
## falling, to the dry value within the steps of the curve in data (rules/10-farming.json wetShade). A bare, a ripe and a regrowing patch are
## dry; rain wets every worked patch of the field and the orchard (not the greenhouse, not in winter). Nothing is saved: the patch has no new key.
func _wet_soil() -> void:
	var A = G.actions
	G.reset_game()
	var curve: Array = G.meta["wetShade"]["curve"]
	var n_steps := int(curve[curve.size() - 1][0])      # the steps in which the soil is dry again
	var rising := true
	for j in range(1, curve.size()):
		if float(curve[j][0]) <= float(curve[j - 1][0]) or float(curve[j][1]) < float(curve[j - 1][1]): rising = false
	_check(rising and n_steps >= 2 and float(curve[0][1]) < 0.8 and is_equal_approx(float(curve[curve.size() - 1][1]), 1.0), "the curve in data: steps rising, the soil darker when just watered, dry at the end")
	G.S["energy"] = 80.0
	G.S["water"] = 60.0
	G.S["step"] = 0      # spring
	G.S["seeds"]["crop_potato"] = 5.0      # grows 4 steps: longer than the soil takes to dry
	var p: Dictionary = G.S["patches"][0]
	_check(G.fields.soil_shade("field", p) == 1.0, "a bare patch is dry")
	_check(A.perform("plant", A.farmer, {"a": "field", "i": 0, "cid": "crop_potato"})["done"], "potatoes are planted")
	var dark: float = G.fields.soil_shade("field", p)
	_check(is_equal_approx(dark, float(curve[0][1])) and dark < 0.8, "right after watering the soil is dark (%.2f)" % dark)
	var IsoField = load("res://game/farm/map/iso_field.gd")
	_check(is_equal_approx(float(IsoField.patch_spec(G, "field", 0, 1)["shade"]), dark), "…and the map is told the same (the field's patch spec)")
	_check(float(IsoField.patch_spec(G, "field", 1, 1, ["scrub", 0.0])["shade"]) == 1.0, "…a patch that is not worked yet stays as it is")
	var last := dark
	var steps_to_dry := -1
	for s in range(n_steps + 2):
		if s > 0:
			G.step_time()
			G.S["rain"] = false      # the weather is rolled in every step: here only the planting's water counts
		var now: float = G.fields.soil_shade("field", p)
		_check(now >= last - 0.00001, "step %d: the soil never gets darker again (%.2f -> %.2f)" % [s, last, now])
		if steps_to_dry < 0 and is_equal_approx(now, 1.0): steps_to_dry = s
		if s == n_steps - 1: _check(now < 1.0 and not p["ready"], "one step before the end of the curve it is still damp")
		if s == n_steps: _check(is_equal_approx(now, 1.0) and not p["ready"], "after %d steps it is dry while the potatoes are still growing" % n_steps)
		last = now
	_check(steps_to_dry == n_steps, "the soil is dry after %d steps, as the data says (it took %d)" % [n_steps, steps_to_dry])
	var keys: Array = p.keys()
	keys.sort()
	var blank: Array = G.fields._blank_patch().keys()
	blank.sort()
	_check(keys == blank, "no new key on the patch: nothing is saved")
	# a ripe patch, one regrowing and one waiting for its seed are dry; bare soil too
	p["ready"] = false; p["growth"] = 0.0
	_check(G.fields.soil_shade("field", p) < 0.8, "(the growth set back: dark again)")
	p["ready"] = true
	_check(G.fields.soil_shade("field", p) == 1.0, "a ripe patch is dry")
	p["ready"] = false; p["cycles"] = 1
	_check(G.fields.soil_shade("field", p) == 1.0, "a regrowing patch (no new water) is dry")
	p["cycles"] = 0; p["seed_at"] = 999
	_check(G.fields.soil_shade("field", p) == 1.0, "a patch left to flower is dry")
	p.erase("seed_at")
	# rain waters every worked patch: the bare ones too, the orchard, not the greenhouse, and in winter it snows instead
	var bare: Dictionary = G.fields._blank_patch()
	G.S["rain"] = true
	_check(is_equal_approx(G.fields.soil_shade("field", bare), dark) and is_equal_approx(G.fields.soil_shade("orchard", bare), dark), "while it rains a bare patch of the field and of the orchard is dark")
	_check(G.fields.soil_shade("gh", bare) == 1.0, "…the greenhouse stands under glass")
	p["ready"] = true
	_check(is_equal_approx(G.fields.soil_shade("field", p), dark), "…and a ripe patch is wet too")
	G.S["step"] = G.seasons.season_len() * 3
	_check(G.seasons.season() == "winter" and G.fields.soil_shade("field", bare) == 1.0, "in winter the rain is snow: the soil is not wet")
	G.S["rain"] = false
	_check(G.fields.soil_shade("field", bare) == 1.0, "when the rain has stopped the bare patch is dry again")

## Stubble stays on a patch after the grain is cut (visible-work/05): the crop node's "stubble" flag says which crops leave it; the patch
## already saves the rest ("last" = the crop harvested there, "crop" empty until the next sowing), so nothing new is saved and an old save shows it.
## It goes when the patch is sown again, or when snow covers it. Draw only: the field map is told through the patch spec.
func _stubble() -> void:
	var A = G.actions
	var IsoField = load("res://game/farm/map/iso_field.gd")
	G.reset_game()
	for cid in ["crop_wheat", "crop_winter_wheat", "crop_oats"]:
		_check(bool(G.nodes[cid].get("stubble", false)), "%s leaves stubble (a flag in its data)" % cid)
	var flagged := 0
	for id in G.nodes:
		if G.nodes[id].has("stubble"): flagged += 1
	_check(flagged == 3, "…and only the three grains do (the straw crops), not %d" % flagged)
	G.S["energy"] = 80.0
	G.S["water"] = 60.0
	G.S["step"] = 0      # spring
	G.S["seeds"]["crop_carrot"] = 5.0
	G.inventory.add_item("wheat", 5.0, true)
	var p: Dictionary = G.S["patches"][0]
	_check(not G.fields.has_stubble(p) and not bool(IsoField.patch_spec(G, "field", 0, 1)["stubble"]), "a patch never planted has no stubble")
	# wheat: sown, ripe, cut: stubble
	_check(A.perform("plant", A.farmer, {"a": "field", "i": 0, "cid": "crop_wheat"})["done"], "wheat is sown")
	_check(not G.fields.has_stubble(p), "…the wheat in the ground is not stubble")
	p["ready"] = true; p["growth"] = 99.0
	G.S["moments"] = 0
	_check(A.perform("harvest", A.farmer, {"a": "field", "i": 0})["done"] and p["crop"] == "", "the wheat is harvested")
	_check(G.fields.has_stubble(p) and bool(IsoField.patch_spec(G, "field", 0, 1)["stubble"]), "…the patch stands in stubble, and the field map is told")
	# no new save key: the patch has the keys a blank one has
	var keys: Array = p.keys()
	keys.sort()
	var blank: Array = G.fields._blank_patch().keys()
	blank.sort()
	_check(keys == blank, "nothing new is saved: the patch has no new key")
	# the weeds that grow on it do not take it away
	p["weeds"] = 3.0
	_check(G.fields.has_stubble(p), "weeds on it do not take it away")
	p["weeds"] = 0.0
	# snow covers it, clearing the snow shows it again
	p["snow"] = true
	_check(not G.fields.has_stubble(p), "snow on the patch covers the stubble")
	p["snow"] = false
	_check(G.fields.has_stubble(p), "…and it shows again when the snow is cleared")
	# an old save (no snow key, no other new key) loads and shows the stubble on its harvested grain patch
	var old: Dictionary = G.S.duplicate(true)
	for pt in old["patches"]: pt.erase("snow"); pt.erase("seed_at")
	G.Saves.write("user://crops_test.json", old)
	_check(G.load_game("user://crops_test.json"), "an old save loads")
	p = G.S["patches"][0]
	_check(p["last"] == "crop_wheat" and G.fields.has_stubble(p) and not G.fields.has_stubble(G.S["patches"][1]), "…its harvested wheat patch has stubble, the others none")
	# sown again: gone
	G.S["energy"] = 80.0
	G.S["water"] = 60.0
	G.S["moments"] = 0
	_check(A.perform("plant", A.farmer, {"a": "field", "i": 0, "cid": "crop_carrot"})["done"], "the patch is sown again")
	_check(not G.fields.has_stubble(p) and not bool(IsoField.patch_spec(G, "field", 0, 1)["stubble"]), "…the stubble is gone")
	# carrots: harvested, no stubble
	p["ready"] = true; p["growth"] = 99.0
	G.S["moments"] = 0
	_check(A.perform("harvest", A.farmer, {"a": "field", "i": 0})["done"] and p["last"] == "crop_carrot", "the carrots are harvested")
	_check(not G.fields.has_stubble(p) and not bool(IsoField.patch_spec(G, "field", 0, 1)["stubble"]), "…a harvested carrot patch is plain soil: no stubble")
	# a patch that is not worked yet is wild, whatever was on it
	_check(not bool(IsoField.patch_spec(G, "field", 1, 1, ["scrub", 0.0])["stubble"]), "a patch that is not worked yet has none")
	# the orchard's and the greenhouse's blank patches and their crops (trees, heirlooms) leave none
	var tree: Dictionary = G.fields._blank_patch()
	tree["last"] = "crop_apple"
	_check(not G.fields.has_stubble(tree), "a cut apple tree leaves no stubble")

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
