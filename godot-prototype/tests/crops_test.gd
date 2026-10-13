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
	_check(not G.fields.plant("field", 0, "crop_onion"), "nothing is sown under snow")
	var e0: float = G.S["energy"]
	_check(G.fields.clear_snow(0) and not G.fields.patch_snow(0) and G.S["energy"] < e0, "clearing the snow costs energy")
	G.S["step"] = G.seasons.season_len() * 4
	G.fields.snowfall()
	G.seasons.step_season({})
	_check(G.fields.snow_count() == 0, "in spring the snow melts")
	for sn in ["spring", "summer", "autumn", "winter"]:
		_check(str(G.meta["seasons"]["mods"][sn].get("intro", "")) != "", "%s has a text for the start of the season (N8)" % sn)
	print("CROPS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
