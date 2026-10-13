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
	print("CROPS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
