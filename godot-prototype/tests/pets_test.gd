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
	_check(P.level("pet_alpaca") == 1 and P.jobs_of("pet_alpaca").is_empty(), "the last pet stays at level 1")
	G.S["step"] = 4
	info = {}
	P.step(info)
	var seen_first := false
	for a in info.get("pet_acts", []):
		if a.get("first", false) and a["pet"] == "pet_alpaca": seen_first = true
	_check(seen_first, "a level 1 alpaca shows its wool now and then (every 4 questions)")
	_check(G.pets.save_defaults().has("pets"), "the save key has defaults")
	print("PETS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
