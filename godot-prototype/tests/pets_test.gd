extends Node
## The pets' jobs (TODO S2): level 1 is the bonus, level 2 (when the next pet is home) is a job the child chooses and the pet does every
## question; a job that cannot run waits. Rules only.
## Run:  godot --headless --path . res://tests/pets_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var P = G.pets
	_check(P.level("pet_bunny") == 0, "a pet that is not home has no level")
	G.S["unlocked"]["pet_bunny"] = true
	G.invalidate_caps()
	_check(P.level("pet_bunny") == 1 and P.job_id("pet_bunny") == "weeds", "at home it is level 1; its first job is the default")
	_check(not P.choose("pet_bunny", "stones"), "…and it cannot be given a job yet")
	var info := {}
	P.step(info)
	_check(not info.has("pet_acts"), "a level 1 bunny does nothing on the farm")
	G.S["unlocked"]["pet_tortoise"] = true
	G.invalidate_caps()
	_check(P.level("pet_bunny") == 2 and P.level("pet_tortoise") == 1, "when the next pet is home the first one reaches level 2")
	# weeds: it takes from the weediest patch
	G.S["unlocked"]["clear_thistles"] = true
	G.invalidate_caps()
	var plots: int = G.progression.plots()
	_check(plots >= 2, "the farm has patches (%d)" % plots)
	G.S["patches"][0]["weeds"] = 2.0
	G.S["patches"][1]["weeds"] = 5.0
	info = {}
	P.step(info)
	_check(info.has("pet_acts") and info["pet_acts"][0]["ok"] and info["pet_acts"][0]["idx"] == 1 and is_equal_approx(G.S["patches"][1]["weeds"], 4.0), "the bunny pulls a weed on the weediest patch")
	_check(P.last("pet_bunny")["ok"], "and the board remembers it")
	# nothing to do: it waits and says so
	for i in range(G.S["patches"].size()): G.S["patches"][i]["weeds"] = 0.0
	info = {}
	P.step(info)
	_check(not info["pet_acts"][0]["ok"] and info["pet_acts"][0]["emoji"] == "💤" and not P.last("pet_bunny")["ok"], "with no weeds it waits (💤)")
	# stones: they go into the store
	_check(P.choose("pet_bunny", "stones") and P.job_id("pet_bunny") == "stones", "the child chooses another job")
	G.S["patches"][0]["stones"] = 3.0
	var s0: float = G.inventory.count("stone")
	info = {}
	P.step(info)
	_check(is_equal_approx(G.inventory.count("stone"), s0 + 1.0) and is_equal_approx(G.S["patches"][0]["stones"], 2.0), "the stone leaves the patch and arrives in the store")
	# a full store: it waits (📦) and the stone stays
	G.S["inv"]["stone"] = []
	G.inventory.add_item("stone", 999.0, true)
	info = {}
	P.step(info)
	_check(info["pet_acts"][0]["emoji"] == "📦" and is_equal_approx(G.S["patches"][0]["stones"], 2.0), "with a full store it waits (📦) and nothing is lost")
	# the tortoise brings water; the badger-like 'makes' jobs collect until a whole unit
	_check(P.job_id("pet_tortoise") == "water", "the tortoise brings water")
	G.S["unlocked"]["pet_goat"] = true
	G.invalidate_caps()
	G.S["water"] = 1.0
	info = {}
	P.step(info)
	_check(P.level("pet_tortoise") == 2 and float(G.S["water"]) >= 2.0 - 0.001, "its job adds water (%s)" % G.S["water"])
	_check(P.choose("pet_tortoise", "stones") and P.choose("pet_tortoise", "water"), "a choice can be changed")
	_check(P.job_id("pet_goat") == "weeds" and P.level("pet_goat") == 1, "the goat has no level 2 until the pony is home")
	G.S["unlocked"]["pet_pony"] = true
	G.invalidate_caps()
	_check(P.choose("pet_goat", "compost"), "…then it can make compost")
	var c0: float = G.inventory.count("compost")
	var got := 0
	for _i in range(8):
		info = {}
		P.step(info)
	_check(G.inventory.count("compost") - c0 >= 3.0, "compost arrives every other question (%d in 8)" % int(G.inventory.count("compost") - c0))
	# the last pet has no job yet
	for pid in ["pet_badger", "pet_alpaca"]: G.S["unlocked"][pid] = true
	G.invalidate_caps()
	_check(P.level("pet_alpaca") == 4 and P.free_play(), "when the last pet is home (free play) every pet is level 4, the alpaca too")
	_check(P.level("pet_bunny") == 4 and P.level("pet_goat") == 4, "…also the ones that would only be level 2 or 3 by the story")
	# levels 3 and 4 in the story: 1 + the pets that came home after it
	G.S["unlocked"].erase("pet_alpaca")
	G.S["unlocked"].erase("pet_badger")
	G.invalidate_caps()
	_check(P.level("pet_bunny") == 4 and P.level("pet_tortoise") == 3 and P.level("pet_goat") == 2 and P.level("pet_pony") == 1, "a pet's level is 1 + the pets that came home after it")
	# WHEN: the job runs only when the condition holds
	_check(not P.set_when("pet_goat", 0, "weeds"), "a level 2 pet cannot have a WHEN yet")
	_check(P.set_when("pet_tortoise", 0, "water") and P.when_of("pet_tortoise", 0)["card"] == "water" and P.when_of("pet_tortoise", 0)["n"] == 8.0, "a level 3 pet gets a WHEN card with its default number")
	_check(not P.set_when("pet_tortoise", 0, "pests"), "…but only the cards that fit the pet")
	P.set_when("pet_tortoise", 0, "water", 5.0)
	G.S["water"] = 20.0
	info = {}
	P.step(info)
	var tortoise_acted := false
	for a in info.get("pet_acts", []):
		if a["pet"] == "pet_tortoise" and not a.get("first", false): tortoise_acted = true
	_check(not tortoise_acted and float(G.S["water"]) == 20.0 and not P.last("pet_tortoise")["ok"], "with plenty of water the tortoise waits (water < 5 does not hold)")
	G.S["water"] = 3.0
	info = {}
	P.step(info)
	_check(float(G.S["water"]) > 3.0, "…and brings water when it is low")
	# the second rule (level 4): when the first WHEN does not hold, the second rule runs
	_check(P.set_when("pet_bunny", 0, "weeds", 5.0) and P.set_second_job("pet_bunny", "stones") and P.set_when("pet_bunny", 1, ""), "level 4 rules can be set")
	P.choose("pet_bunny", "weeds")
	G.S["inv"]["stone"] = []
	for i in range(G.S["patches"].size()): G.S["patches"][i]["stones"] = 0.0
	G.S["patches"][0]["stones"] = 3.0
	P.set_when("pet_bunny", 0, "weeds", 5.0)
	P.set_second_job("pet_bunny", "stones")
	P.set_when("pet_bunny", 1, "")
	var st0: float = G.S["patches"][0]["stones"]
	for i in range(mini(G.progression.plots(), G.S["patches"].size())): G.S["patches"][i]["weeds"] = 0.0
	info = {}
	P.step(info)
	_check(float(G.S["patches"][0]["stones"]) < st0, "OTHERWISE: with few weeds the bunny picks stones instead")
	G.S["patches"][1]["weeds"] = 6.0
	info = {}
	P.step(info)
	_check(float(G.S["patches"][1]["weeds"]) < 6.0, "…and pulls weeds once a patch has 5 or more")
	G.S["unlocked"]["pet_badger"] = true
	G.S["unlocked"]["pet_alpaca"] = true
	G.invalidate_caps()
	G.S["pests"] = 3.0
	G.S["step"] = 4
	info = {}
	P.step(info)
	_check(float(G.S["pests"]) < 3.0, "in free play the alpaca guards the fields")
	_check(G.pets.save_defaults().has("pets"), "the save key has defaults")
	print("PETS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
