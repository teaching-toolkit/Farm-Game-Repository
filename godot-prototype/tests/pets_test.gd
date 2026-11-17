extends Node
## The pets' blessings and chores (TODO S2): level 1 is the bonus, level 2 (when the next pet is home) is a blessing the child chooses and the pet
## does every question; one that cannot run waits. Rules only.
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
	_check(P.level("pet_bunny") == 1 and P.chosen("pet_bunny") == "weeds", "at home it is level 1; its first blessing is the default")
	_check(not P.choose("pet_bunny", "stones"), "…and it cannot be given a blessing yet")
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
	_check(P.choose("pet_bunny", "stones") and P.chosen("pet_bunny") == "stones", "the child chooses another blessing")
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
	# the tortoise brings water; the badger-like 'makes' blessings collect until a whole unit
	_check(P.chosen("pet_tortoise") == "water", "the tortoise brings water")
	G.S["unlocked"]["pet_goat"] = true
	G.invalidate_caps()
	G.S["water"] = 1.0
	info = {}
	P.step(info)
	_check(P.level("pet_tortoise") == 2 and float(G.S["water"]) >= 2.0 - 0.001, "its blessing adds water (%s)" % G.S["water"])
	_check(P.choose("pet_tortoise", "stones") and P.choose("pet_tortoise", "water"), "a choice can be changed")
	_check(P.chosen("pet_goat") == "weeds" and P.level("pet_goat") == 1, "the goat has no level 2 until the pony is home")
	G.S["unlocked"]["pet_pony"] = true
	G.invalidate_caps()
	_check(P.choose("pet_goat", "compost"), "…then it can make compost")
	var c0: float = G.inventory.count("compost")
	var got := 0
	for _i in range(8):
		info = {}
		P.step(info)
	_check(G.inventory.count("compost") - c0 >= 3.0, "compost arrives every other question (%d in 8)" % int(G.inventory.count("compost") - c0))
	# the last pet has no blessing yet
	for pid in ["pet_badger", "pet_alpaca"]: G.S["unlocked"][pid] = true
	G.invalidate_caps()
	_check(P.level("pet_alpaca") == 4 and P.free_play(), "when the last pet is home (free play) every pet is level 4, the alpaca too")
	_check(P.level("pet_bunny") == 4 and P.level("pet_goat") == 4, "…also the ones that would only be level 2 or 3 by the story")
	# levels 3 and 4 in the story: 1 + the pets that came home after it
	G.S["unlocked"].erase("pet_alpaca")
	G.S["unlocked"].erase("pet_badger")
	G.invalidate_caps()
	_check(P.level("pet_bunny") == 4 and P.level("pet_tortoise") == 3 and P.level("pet_goat") == 2 and P.level("pet_pony") == 1, "a pet's level is 1 + the pets that came home after it")
	# WHEN: the blessing runs only when the condition holds
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
	_check(P.set_when("pet_bunny", 0, "weeds", 5.0) and P.choose_second("pet_bunny", "stones") and P.set_when("pet_bunny", 1, ""), "level 4 rules can be set")
	P.choose("pet_bunny", "weeds")
	G.S["inv"]["stone"] = []
	for i in range(G.S["patches"].size()): G.S["patches"][i]["stones"] = 0.0
	G.S["patches"][0]["stones"] = 3.0
	P.set_when("pet_bunny", 0, "weeds", 5.0)
	P.choose_second("pet_bunny", "stones")
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
	_pickers()
	_pet_chores()
	_chore_rules()
	print("PETS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

# ---------------------------------------------------------------- how a pet picks its target, the chores per pet (pets-automation/03)

## The picker answers args that the chore accepts (for a pet, with energy and water to spare) when there is work, and {} when there is none.
func _accepts(chore: String, args: Dictionary) -> bool:
	return not args.is_empty() and G.actions.check(chore, G.actions.pet_doer("pet_bunny"), args)["ok"]

func _pickers() -> void:
	G.reset_game()
	var A = G.actions
	var CHORES := ["weed", "pick_stones", "pick_loose", "fetch_water", "clear_snow", "muck_out", "collect_animal"]
	var reg: Array = A.auto_chores()
	var all := true
	for c in CHORES: all = all and reg.has(c)
	_check(all, "every chore of the spec's list has a picker (%s)" % str(reg))
	var in_data := true
	var two := true
	for pid in G.pets.data().get("entries", {}):
		var mine: Array = G.pets.data()["entries"][pid].filter(func(j): return j.get("kind", "") == "chore")
		two = two and mine.size() == 2
		for j in mine: in_data = in_data and reg.has(j["chore"]) and CHORES.has(j["chore"])
	_check(in_data and two, "every chore in the data names a chore with a picker, and every pet has two")
	G.S["unlocked"]["clear_thistles"] = true
	G.invalidate_caps()
	G.S["energy"] = 999.0
	G.S["water"] = 10.0
	_check(G.progression.plots() >= 2 and G.S["patches"].size() >= 2, "the farm has two patches")
	for i in range(G.S["patches"].size()):
		G.S["patches"][i]["weeds"] = 0.0
		G.S["patches"][i]["stones"] = 0.0
		G.S["patches"][i]["snow"] = false
	# weed: the patch with most weeds, from 0.5 up
	_check(A.auto_args("weed") == {}, "weed: no weeds, no target")
	G.S["patches"][0]["weeds"] = 0.4
	_check(A.auto_args("weed") == {}, "…under half a weed is none")
	G.S["patches"][0]["weeds"] = 2.0
	G.S["patches"][1]["weeds"] = 5.0
	_check(A.auto_args("weed") == {"i": 1} and _accepts("weed", A.auto_args("weed")), "weed: the weediest patch, and the chore accepts it")
	# pick_stones: the stoniest patch, only while the store has room
	G.S["inv"]["stone"] = []
	_check(A.auto_args("pick_stones") == {}, "pick_stones: no stones, no target")
	G.S["patches"][0]["stones"] = 3.0
	G.S["patches"][1]["stones"] = 1.0
	_check(A.auto_args("pick_stones") == {"i": 0} and _accepts("pick_stones", A.auto_args("pick_stones")), "pick_stones: the stoniest patch, and the chore accepts it")
	G.inventory.add_item("stone", 9999.0, true)
	_check(A.auto_args("pick_stones") == {}, "…with no room for stones in the store it waits (they would be lost)")
	G.S["inv"]["stone"] = []
	# clear_snow: the first snowy patch
	_check(A.auto_args("clear_snow") == {}, "clear_snow: no snow, no target")
	G.S["patches"][1]["snow"] = true
	_check(A.auto_args("clear_snow") == {"i": 1}, "clear_snow: the snowy patch")
	G.S["patches"][0]["snow"] = true
	_check(A.auto_args("clear_snow") == {"i": 0} and _accepts("clear_snow", A.auto_args("clear_snow")), "…the first of two, and the chore accepts it")
	# fetch_water: while the bucket has room (a patch has no wetness here: the water is spent at planting)
	G.S["water"] = 0.0
	_check(A.auto_args("fetch_water") == {"place": "water"} and _accepts("fetch_water", A.auto_args("fetch_water")), "fetch_water: with room in the bucket the pet goes to the water, and the chore accepts it")
	G.S["water"] = G.needs.water_cap()
	_check(A.auto_args("fetch_water") == {}, "…a full bucket needs no water")
	G.S["water"] = 10.0
	# pick_loose: the oldest thing the store has room for
	G.S["loose"]["things"] = []
	_check(A.auto_args("pick_loose") == {}, "pick_loose: nothing lies about, no target")
	G.S["loose"]["things"] = [{"id": 5, "k": "stick", "u": 0.5, "v": 0.5}, {"id": 6, "k": "stone", "u": 0.2, "v": 0.2}]
	_check(A.auto_args("pick_loose") == {"id": 5} and _accepts("pick_loose", A.auto_args("pick_loose")), "pick_loose: the first thing, and the chore accepts it")
	G.inventory.add_item("stick", 9999.0, true)
	_check(A.auto_args("pick_loose") == {"id": 6}, "…a thing the store has no room for is skipped")
	G.inventory.add_item("stone", 9999.0, true)
	_check(A.auto_args("pick_loose") == {}, "…and with room for none there is no target")
	G.S["inv"]["stick"] = []
	G.S["inv"]["stone"] = []
	# muck_out and collect_animal: only pens that have animals; the pen with most muck / the biggest haul that is ready and can be fed
	G.S["animals"] = {}
	_check(A.auto_args("muck_out") == {} and A.auto_args("collect_animal") == {}, "pens: no animals, no target")
	G.S["step"] = 5
	G.S["animals"]["animal_chicken"] = {"count": 2, "ready": 0, "muck": 3.0}
	G.S["animals"]["animal_cow"] = {"count": 0, "ready": 0, "muck": 5.0}
	_check(A.auto_args("muck_out") == {"aid": "animal_chicken"} and _accepts("muck_out", A.auto_args("muck_out")), "muck_out: a pen with no animals does not count, the chickens' pen does")
	G.S["animals"]["animal_cow"]["count"] = 1
	_check(A.auto_args("muck_out") == {"aid": "animal_cow"}, "…the pen with most muck")
	G.S["animals"]["animal_cow"]["muck"] = 0.4
	G.S["animals"]["animal_chicken"]["muck"] = 0.4
	_check(A.auto_args("muck_out") == {}, "…a clean pen (under half a muck) needs nothing")
	_check(A.auto_args("collect_animal") == {}, "collect_animal: the feed is not in the store, so there is nothing a pet could do")
	G.inventory.add_item("wheat", 20.0, true)
	G.inventory.add_item("straw", 20.0, true)
	_check(A.auto_args("collect_animal") == {"aid": "animal_chicken"} and _accepts("collect_animal", A.auto_args("collect_animal")), "collect_animal: the pen that is ready and fed, and the chore accepts it")
	G.S["animals"]["animal_chicken"]["ready"] = 9
	_check(A.auto_args("collect_animal") == {}, "…a pen that is not ready yet is none")
	G.S["animals"] = {}
	G.S["inv"]["wheat"] = []
	G.S["inv"]["straw"] = []

	# the chores of a pet: one whose place is not built is not offered; blessings_of lists no chore
	var P = G.pets
	var ids := []
	for j in P.chores_of("pet_goat"): ids.append(j["id"])
	_check(not G.done("coop_1") and ids == ["helps_weed"], "chores_of: the goat's muck chore is not offered before the pen is built (%s)" % str(ids))
	G.S["unlocked"]["coop_1"] = true
	ids = []
	for j in P.chores_of("pet_goat"): ids.append(j["id"])
	_check(ids == ["helps_weed", "helps_muck_out"], "…after the pen is built it is (%s)" % str(ids))
	var none_listed := true
	for pid in G.pet_ids:
		for j in P.blessings_of(pid): none_listed = none_listed and j.get("kind", "") != "chore"
	_check(none_listed and P.entry("pet_goat", "helps_muck_out")["chore"] == "muck_out", "blessings_of still lists no chore; entry() finds them")

# ---------------------------------------------------------------- a pet's entry of kind "chore" (pets-automation/02)

var _pick := {"i": 0}      # what the test's picker answers (the owners of the chores register the real ones in pets-automation/03)

func _pick_target() -> Dictionary:
	return _pick

func _act_of(info: Dictionary, pid: String) -> Dictionary:
	for a in info.get("pet_acts", []):
		if a["pet"] == pid and not a.get("first", false): return a
	return {}

func _pet_chores() -> void:
	G.reset_game()
	var P = G.pets
	var A = G.actions
	G.S["unlocked"]["pet_bunny"] = true
	G.S["unlocked"]["pet_tortoise"] = true
	G.invalidate_caps()
	# a hidden entry is not offered, but it is there
	var ids := []
	for j in P.blessings_of("pet_bunny"): ids.append(j["id"])
	_check(not ids.has("helps_weed") and ids.has("weeds") and ids.has("stones"), "a hidden entry is not in the list the child sees (%s)" % str(ids))
	_check(not P.entry("pet_bunny", "helps_weed").is_empty() and P.entry("pet_bunny", "helps_weed")["kind"] == "chore", "…but entry() finds it")
	_check(P.level("pet_bunny") == 2 and P.choose("pet_bunny", "helps_weed") and P.chosen("pet_bunny") == "helps_weed", "…and it can be set through choose")
	# the chore is done at the pets' step: the farmer pays, no moment is used, no practice, no wear
	var pd = A.pet_doer("pet_bunny")
	_check(pd == A.pet_doer("pet_bunny") and pd.id == "pet_bunny" and pd.id != A.farmer.id, "a pet's Doer is made once and is not the farmer")
	A.register_auto("weed", _pick_target)
	_pick = {"i": 0}
	_check(A.auto_args("weed") == {"i": 0} and A.auto_args("no_such_chore") == {}, "auto_args is the picker's answer, or {} with no picker")
	G.meta["chores"]["test_chore"] = {"moments": 1, "base": {"energy": 1}, "cat": "weed", "wear": "use:weed", "practice": "field"}   # a chore with a practice and a wear of its own
	A.register("test_chore", func(_w, _a, _c): return {})
	G.S["polish"]["polish_hoe"] = 3.0      # a hoe that wears on every weeding
	var per_pull := minf(5.0, float(G.meta.get("weeds", {}).get("weedsPerPull", 3)))
	for i in range(G.S["patches"].size()): G.S["patches"][i]["weeds"] = 0.0
	G.S["patches"][0]["weeds"] = 5.0
	G.S["energy"] = 10.0
	var cost: float = A.effective_cost("weed", pd, {"i": 0})["energy"]
	var m0: int = A.moments_used()
	var hoe0: float = G.crafting.polish_level("polish_hoe")
	var info := {}
	P.step(info)
	var act: Dictionary = _act_of(info, "pet_bunny")
	_check(act.get("ok", false) and act.get("chore", "") == "weed" and act.get("area", "") == "field" and act.get("idx", -1) == 0, "the bunny does the weed chore on the patch the picker chose (%s)" % str(act))
	_check(is_equal_approx(G.S["patches"][0]["weeds"], 5.0 - per_pull), "…the patch's weeds fall by one pull (%s)" % G.S["patches"][0]["weeds"])
	_check(cost > 0.0 and is_equal_approx(G.S["energy"], 10.0 - cost), "…the farmer pays exactly the chore's effective cost (%s of 10, now %s)" % [cost, G.S["energy"]])
	_check(A.moments_used() == m0 and P.last("pet_bunny")["ok"], "…no moment is used")
	_check(is_equal_approx(G.crafting.polish_level("polish_hoe"), hoe0), "…and the hoe does not wear (%s -> %s)" % [hoe0, G.crafting.polish_level("polish_hoe")])
	# the same chore, same state, by the farmer: it takes a moment; a chore with a practice and a wear trains and wears for the farmer only
	G.S["patches"][0]["weeds"] = 5.0
	var rep: Dictionary = A.run("weed", A.farmer, {"i": 0})
	_check(rep["done"] and A.moments_used() == m0 + 1, "the farmer's own weeding takes a moment")
	var fam0: int = G.skills.batches("field")
	var m1: int = A.moments_used()
	var e1: float = G.S["energy"]
	var hoe1: float = G.crafting.polish_level("polish_hoe")
	rep = A.run("test_chore", pd, {})
	_check(rep["done"] and A.moments_used() == m1 and G.skills.batches("field") == fam0 and is_equal_approx(G.crafting.polish_level("polish_hoe"), hoe1) and G.S["energy"] < e1, "a pet's chore trains no skill and wears no tool, takes no moment, costs the farmer's energy")
	rep = A.run("test_chore", A.farmer, {})
	_check(rep["done"] and A.moments_used() == m1 + 1 and G.skills.batches("field") == fam0 + 1 and G.crafting.polish_level("polish_hoe") < hoe1, "…the same chore by the farmer takes a moment, trains the skill and wears the hoe")
	# too tired: it waits, says so, spends nothing
	G.S["patches"][0]["weeds"] = 5.0
	G.S["energy"] = 0.0
	m0 = A.moments_used()
	info = {}
	P.step(info)
	act = _act_of(info, "pet_bunny")
	_check(not act["ok"] and act["why"] == "tired" and act["emoji"] == "💤" and P.last("pet_bunny")["why"] == "tired", "with no energy the rule waits and says tired (%s)" % str(act))
	_check(is_equal_approx(G.S["energy"], 0.0) and is_equal_approx(G.S["patches"][0]["weeds"], 5.0) and A.moments_used() == m0, "…nothing is spent and no weed is pulled")
	# nothing to do (the picker says {}) and no picker: it waits idle, nothing is spent
	G.S["energy"] = 10.0
	_pick = {}
	info = {}
	P.step(info)
	act = _act_of(info, "pet_bunny")
	_check(not act["ok"] and act["why"] == "idle" and is_equal_approx(G.S["energy"], 10.0), "with nothing to do it waits idle and spends nothing")
	_pick = {"i": 0}
	A.register_auto("weed", Callable())
	info = {}
	P.step(info)
	act = _act_of(info, "pet_bunny")
	_check(not act["ok"] and act["why"] == "idle" and is_equal_approx(G.S["energy"], 10.0) and is_equal_approx(G.S["patches"][0]["weeds"], 5.0), "with no picker registered it waits idle too")
	G.meta["chores"].erase("test_chore")

# ---------------------------------------------------------------- a rule is a blessing or a chore: the energy WHEN card (pets-automation/04, the rules)

## A new game with these pets home (so their levels follow), the test's weed picker on patch 0 with 5 weeds, the farmer's energy full.
func _fresh(home: Array) -> void:
	G.reset_game()
	for pid in home: G.S["unlocked"][pid] = true
	G.invalidate_caps()
	G.actions.register_auto("weed", _pick_target)
	_pick = {"i": 0}
	for i in range(G.S["patches"].size()): G.S["patches"][i]["weeds"] = 0.0
	G.S["patches"][0]["weeds"] = 5.0
	G.S["energy"] = G.needs.energy_max()

func _chore_rules() -> void:
	var P = G.pets
	var A = G.actions
	_fresh(["pet_bunny", "pet_tortoise", "pet_goat", "pet_pony", "pet_badger", "pet_alpaca"])
	var CHORES := ["weed", "pick_stones", "pick_loose", "fetch_water", "clear_snow", "muck_out", "collect_animal"]
	# the chores are no blessings: blessings_of lists none, chores_of lists them (a pen chore only with the coop built), entry() finds them
	var none_listed := true
	var offered := {}
	for pid in G.pet_ids:
		for j in P.blessings_of(pid): none_listed = none_listed and j.get("kind", "") != "chore" and not j["id"].begins_with("helps_")
		offered[pid] = P.chores_of(pid).size()
		for j in P.data()["entries"][pid]: if j.get("kind", "") == "chore": none_listed = none_listed and not j.has("hidden") and CHORES.has(j["chore"]) and not P.entry(pid, j["id"]).is_empty()
	_check(none_listed and P.blessings_of("pet_bunny").size() == 2, "blessings_of lists no chore for any pet (and no chore is hidden any more), entry() finds them")
	_check(not G.done("coop_1") and offered == {"pet_bunny": 2, "pet_tortoise": 2, "pet_goat": 1, "pet_pony": 2, "pet_badger": 1, "pet_alpaca": 0}, "chores_of: the pen chores are not offered before the coop is built (%s)" % str(offered))
	G.S["unlocked"]["coop_1"] = true
	var all12 := 0
	for pid in G.pet_ids: all12 += P.chores_of(pid).size()
	_check(all12 == 12, "…all 12 chores are offered once it is (%d)" % all12)
	# the energy card: one segment of the bar is one energy; the default leaves about a third of the chapter 3 bar (40); the card says "≥"
	var c: Dictionary = P.whens().get("energy", {})
	var all_allow := true
	for pid in G.pet_ids: all_allow = all_allow and P.allowed_whens(pid).has("energy")
	_check(not c.is_empty() and all_allow and c["emoji"] == "⚡" and c["name"] == "My energy" and FarmPets.card_sign(c) == "≥" and G.conditions.holds(FarmPets.card_condition(c, 0.0)) == (float(G.S["energy"]) >= 0.0), "the energy card exists, every pet allows it, it says ≥ (%s)" % str(c))
	var dflt := float(c["default"])
	_check(float(c["min"]) == 0.0 and float(c["step"]) == 1.0 and float(c["max"]) >= 65.0 and is_equal_approx(fmod(dflt - float(c["min"]), float(c["step"])), 0.0) and absf(dflt - 40.0 / 3.0) <= 0.5, "…range 0 to the bar's largest in steps of one cube; the default is a third of the 40-cube bar, a whole step (%s)" % str(c))
	# level 3 (the bunny, the tortoise and the goat are home): choosing a chore sets the energy WHEN at its default
	_fresh(["pet_bunny", "pet_tortoise", "pet_goat"])
	_check(P.level("pet_bunny") == 3 and P.when_of("pet_bunny", 0).is_empty(), "level 3 bunny: its WHEN is always")
	_check(P.choose("pet_bunny", "helps_weed") and P.chosen("pet_bunny") == "helps_weed" and P.entry("pet_bunny", P.chosen("pet_bunny"))["kind"] == "chore", "level 3: choose takes a chore, chosen keeps it")
	var w0: Dictionary = P.when_of("pet_bunny", 0)
	_check(w0.get("card", "") == "energy" and is_equal_approx(float(w0.get("n", -1)), dflt), "…and its WHEN is the energy card at its default (%s)" % str(w0))
	var pd = A.pet_doer("pet_bunny")
	var cost: float = A.effective_cost("weed", pd, {"i": 0})["energy"]
	var per_pull := minf(5.0, float(G.meta.get("weeds", {}).get("weedsPerPull", 3)))
	var m0: int = A.moments_used()
	G.S["energy"] = dflt + 5.0
	var info := {}
	P.step(info)
	var act: Dictionary = _act_of(info, "pet_bunny")
	_check(act.get("ok", false) and act.get("chore", "") == "weed" and act.get("area", "") == "field" and act.get("idx", -1) == 0 and act.get("emoji", "") == "🌿" and act.get("emoji", "") == P.entry("pet_bunny", "helps_weed")["emoji"], "with energy above the number the chore runs, and the act carries the entry's emoji (%s)" % str(act))
	_check(is_equal_approx(G.S["patches"][0]["weeds"], 5.0 - per_pull) and cost > 0.0 and is_equal_approx(G.S["energy"], dflt + 5.0 - cost) and A.moments_used() == m0, "…weeds fall, the farmer's energy falls by the cost, the moments are unchanged")
	G.S["energy"] = dflt - 1.0
	G.S["patches"][0]["weeds"] = 5.0
	info = {}
	P.step(info)
	act = _act_of(info, "pet_bunny")
	_check(not act.get("ok", false) and P.last("pet_bunny")["why"] == "wait" and is_equal_approx(G.S["energy"], dflt - 1.0) and is_equal_approx(G.S["patches"][0]["weeds"], 5.0) and A.moments_used() == m0, "with energy below the number the pet waits (the WHEN's wait), nothing is spent")
	G.S["energy"] = dflt
	info = {}
	P.step(info)
	_check(_act_of(info, "pet_bunny").get("ok", false) and is_equal_approx(G.S["energy"], dflt - cost), "…at exactly the number it works (the card says ≥)")
	# a WHEN the child set stays when a chore is chosen; a blessing frees only the default energy WHEN
	_check(P.choose("pet_bunny", "stones") and P.when_of("pet_bunny", 0).is_empty(), "choosing a blessing sets the default energy WHEN back to always")
	_check(P.set_when("pet_bunny", 0, "weeds", 4.0) and P.choose("pet_bunny", "helps_weed") and P.when_of("pet_bunny", 0) == {"card": "weeds", "n": 4.0}, "a WHEN the child set before stays after choosing a chore")
	_check(P.choose("pet_bunny", "stones") and P.when_of("pet_bunny", 0) == {"card": "weeds", "n": 4.0}, "…and after choosing a blessing")
	_check(P.set_when("pet_bunny", 0, "energy", 9.0) and P.choose("pet_bunny", "weeds") and P.when_of("pet_bunny", 0) == {"card": "energy", "n": 9.0}, "an energy WHEN the child set to another number stays when a blessing is chosen")
	_check(P.set_when("pet_bunny", 0, "") and P.choose("pet_bunny", "helps_pick_loose") and P.when_of("pet_bunny", 0).get("card", "") == "energy" and P.choose("pet_bunny", "weeds") and P.when_of("pet_bunny", 0).is_empty(), "always -> a chore gets the energy WHEN -> a blessing frees it again")
	# a chore whose building is missing cannot be chosen (the goat's pen chore, no coop); with it, it can
	_check(not G.done("coop_1") and P.level("pet_goat") == 1 and not P.choose("pet_goat", "helps_muck_out"), "choose of a chore whose pen is not built is false (and the goat is level 1 here)")
	G.S["unlocked"]["pet_pony"] = true
	G.S["unlocked"]["pet_badger"] = true
	G.invalidate_caps()
	_check(P.level("pet_goat") == 3 and not P.choose("pet_goat", "helps_muck_out") and P.chosen("pet_goat") == "weeds" and P.when_of("pet_goat", 0).is_empty(), "…at level 3 too: it is false, the goat's rule and WHEN stay")
	G.S["unlocked"]["coop_1"] = true
	_check(P.choose("pet_goat", "helps_muck_out") and P.chosen("pet_goat") == "helps_muck_out" and P.when_of("pet_goat", 0).get("card", "") == "energy", "…and true once the pen is built")
	# the act of a pen chore: the place is the pen, with the animal
	G.S["animals"]["animal_chicken"] = {"count": 2, "ready": 0, "muck": 3.0}
	G.S["energy"] = dflt + 5.0
	info = {}
	P.step(info)
	act = _act_of(info, "pet_goat")
	_check(act.get("ok", false) and act.get("chore", "") == "muck_out" and act.get("place", "") == "pen" and act.get("aid", "") == "animal_chicken" and act.get("emoji", "") == "🧹", "a pen chore's act: place pen, the animal's id, the chore's emoji (%s)" % str(act))
	# level 2 (no WHEN card): choosing a chore sets no WHEN and the pet works whenever it has the energy
	_fresh(["pet_bunny", "pet_tortoise"])
	_check(P.level("pet_bunny") == 2 and P.choose("pet_bunny", "helps_weed") and P.when_of("pet_bunny", 0).is_empty(), "level 2: choosing a chore sets no WHEN")
	cost = A.effective_cost("weed", A.pet_doer("pet_bunny"), {"i": 0})["energy"]
	G.S["energy"] = cost + 1.0
	_check(G.S["energy"] < dflt, "(the energy is below the energy card's default: %s < %s)" % [G.S["energy"], dflt])
	info = {}
	P.step(info)
	_check(_act_of(info, "pet_bunny").get("ok", false) and is_equal_approx(G.S["energy"], 1.0), "…and the pet works whenever it has the energy for the chore")
	# level 4: the second rule gets the same
	_fresh(["pet_bunny", "pet_tortoise", "pet_goat", "pet_pony"])
	_check(P.level("pet_bunny") == 4 and P.choose("pet_bunny", "weeds") and P.set_when("pet_bunny", 0, "weeds", 5.0), "level 4: the first rule is a blessing with its own WHEN")
	_check(P.choose_second("pet_bunny", "helps_weed") and P.second_chosen("pet_bunny") == "helps_weed" and P.when_of("pet_bunny", 1) == {"card": "energy", "n": dflt} and P.when_of("pet_bunny", 0) == {"card": "weeds", "n": 5.0}, "…choose_second takes a chore, keeps it, and its WHEN is the energy card at its default; rule 1 is untouched")
	G.S["patches"][0]["weeds"] = 3.0      # under 5: the first rule does not hold, the second runs
	G.S["energy"] = dflt + 5.0
	info = {}
	P.step(info)
	act = _act_of(info, "pet_bunny")
	_check(act.get("ok", false) and act.get("entry", "") == "helps_weed" and G.S["patches"][0]["weeds"] < 3.0, "OTHERWISE the second rule, a chore, runs when the first WHEN does not hold")
	G.S["energy"] = dflt - 1.0
	G.S["patches"][0]["weeds"] = 3.0
	info = {}
	P.step(info)
	_check(not _act_of(info, "pet_bunny").get("ok", false) and P.last("pet_bunny")["why"] == "wait" and is_equal_approx(G.S["energy"], dflt - 1.0), "…and the pet waits when the energy is below the second rule's number")
	_check(P.set_when("pet_bunny", 1, "weeds", 2.0) and P.choose_second("pet_bunny", "helps_pick_loose") and P.when_of("pet_bunny", 1) == {"card": "weeds", "n": 2.0}, "a second rule's WHEN the child set stays when another chore is chosen")
	_check(P.set_when("pet_bunny", 1, "") and P.choose_second("pet_bunny", "helps_weed") and P.choose_second("pet_bunny", "stones") and P.when_of("pet_bunny", 1).is_empty() and P.second_chosen("pet_bunny") == "stones", "a blessing as the second rule frees the default energy WHEN")
	# level 4 and a pen chore with no coop: choose_second is false
	_fresh(["pet_bunny", "pet_tortoise", "pet_goat", "pet_pony", "pet_badger", "pet_alpaca"])
	_check(P.level("pet_badger") == 4 and not P.choose_second("pet_badger", "helps_muck_out") and P.second_chosen("pet_badger") == "compost" and P.choose_second("pet_badger", "helps_pick_stones") and P.second_chosen("pet_badger") == "helps_pick_stones", "choose_second of a pen chore with no pen is false, of another chore true")

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
