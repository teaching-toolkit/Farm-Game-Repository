extends Node
## The forest, Wren's check and the poisoning (TODO S3, S4): tasks by season, the unchecked basket, the check, the risk of using it unchecked. Rules only.
## Run:  godot --headless --path . res://tests/forest_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var F = G.forest
	_check(not F.open() and not F.enter(), "the forest is closed until the still-room is cleared")
	G.S["unlocked"]["ruins_stillroom"] = true
	G.invalidate_caps()
	_check(F.open() and F.enter() and F.inside() and F.leave() and not F.inside(), "…and then it can be entered and left")
	F.enter()
	G.S["energy"] = 30.0
	G.S["step"] = 40       # summer
	_check(G.seasons.season() == "summer", "it is summer")
	_check(F.can_do("glade", "chamomile")["ok"] and F.can_do("clearing", "marigold")["ok"], "summer plants can be picked")
	_check(not F.can_do("willow", "willow_bark")["ok"], "willow bark is a spring job")
	_check(not F.can_do("stream", "clay")["ok"], "digging clay needs the shovel")
	G.S["unlocked"]["wooden_shovel"] = true
	_check(F.can_do("stream", "clay")["ok"], "…and with the shovel it is possible")
	# pick: the right part, and a wrong one
	var e0: float = G.S["energy"]
	var r: Dictionary = F.do_pick("clearing", "marigold", "flower")
	_check(r["good"] and F.basket().size() == 1 and G.S["energy"] < e0, "the right part goes into the basket and costs energy")
	_check(F.rest_left("clearing", "marigold") > 0 and not F.can_do("clearing", "marigold")["ok"], "the spot rests for a few questions")
	r = F.do_pick("clearing", "lavender", "leaf")
	_check(not r["good"] and F.basket().size() == 1, "a wrong part brings nothing home")
	# find: the wrong look-alike is in the basket but looks like the plant
	r = F.do_find("meadow", "yarrow", "hemlock")
	_check(r["ok"] and not r["good"] and F.claimed().get("yarrow", 0) == 1 and F.has_bad(), "the wrong choice brings a look-alike that looks like yarrow in the basket")
	r = F.do_find("glade", "chamomile", "chamomile")
	_check(r["good"] and F.claimed().get("chamomile", 0) == 1, "the right choice brings chamomile")
	# the basket has a size
	G.S["step"] += 10
	for _i in range(6): F.do_pick("clearing", "thyme", "leaf"); G.S["step"] += 5
	_check(F.basket().size() == F.capacity() and not F.can_do("clearing", "sage")["ok"], "the basket holds %d" % F.capacity())
	# Wren's check: the right plants go into the store, the wrong ones are thrown out, a small favour is asked
	G.inventory.add_item("porridge", 1.0, true)
	G.inventory.add_item("bread", 1.0, true)
	var rep: Dictionary = F.check()
	_check(rep["bad"] == ["hemlock"] and F.basket().is_empty() and G.inventory.count("yarrow") == 0.0 and G.inventory.count("chamomile") == 1.0, "Wren finds the hemlock, and the rest is in the store")
	_check(G.inventory.count("porridge") + G.inventory.count("bread") == 1.0, "…for a small favour (one dish)")
	# without a dish or coins she checks anyway
	G.S["inv"].clear(); G.S["coins"] = 0.0
	G.S["energy"] = 30.0; G.S["step"] = 45; G.S["forest"]["rest"] = {}
	F.do_find("glade", "chamomile", "mayweed")
	_check(F.favour().is_empty() and F.check()["bad"] == ["mayweed"], "with nothing to give she still checks")
	# unchecked: a bad unit is remembered; using it poisons (sooner or later)
	G.S["step"] = 50; G.S["forest"]["rest"] = {}
	G.S["energy"] = 30.0
	F.do_find("meadow", "yarrow", "hemlock")
	F.use_unchecked()
	_check(G.inventory.count("yarrow") == 1.0 and int(G.S["forest"]["tainted"].get("yarrow", 0)) == 1, "unchecked, it goes into the store and the bad unit is remembered")
	G.S["energy"] = 20.0; G.S["coins"] = 500.0
	var hit: bool = F.poisons({"yarrow": 1.0})
	_check(hit and G.S["energy"] == 0.0 and G.S["coins"] == 0.0, "using the only unit, which is the bad one, poisons: no energy, no coins")
	_check(G.needs.buff_mult() == 2.0 and int(G.S["forest"]["poisoned"]) == 1, "every job costs double for a while")
	_check(G.inventory.count("yarrow") == 0.0 and G.S["forest"]["tainted"].is_empty(), "Wren throws out what was bad")
	G.S["step"] += 7
	_check(G.needs.buff_mult() == 1.0, "…and it passes after a few questions")
	_check(not F.poisons({"yarrow": 1.0}), "nothing bad left, nothing happens")
	# a harmless look-alike does not poison
	G.S["step"] = 55; G.S["forest"]["rest"] = {}
	G.S["energy"] = 30.0
	F.do_find("glade", "chamomile", "mayweed")
	F.use_unchecked()
	G.S["energy"] = 10.0
	_check(not F.poisons({"chamomile": 1.0}) and G.S["energy"] == 10.0, "scentless mayweed is harmless")
	# through the real recipe: a mixed batch poisons, a clean one does not
	G.reset_game()
	G.S["unlocked"]["ruins_stillroom"] = true
	for id in ["mortar", "k_plant_parts"]: G.S["unlocked"][id] = true
	G.invalidate_caps()
	G.S["energy"] = 30.0
	G.S["inv"]["yarrow"] = []
	G.inventory.add_item("yarrow", 3.0, true)
	G.S["forest"]["tainted"] = {"yarrow": 3}
	var made: bool = G.crafting.start_recipe("yarrow_paste")
	_check(not made and int(G.S["forest"]["poisoned"]) == 1 and G.inventory.count("yarrow_paste") == 0.0, "a recipe with a bad plant does not happen: the farmer collapses")
	G.S["inv"]["yarrow"] = []
	G.inventory.add_item("yarrow", 3.0, true)
	G.S["energy"] = 30.0
	_check(G.crafting.start_recipe("yarrow_paste") and G.inventory.count("yarrow_paste") >= 2.0, "a clean batch is made as usual")
	# the remedies need the stations and the cards
	_check(G.recipes["healers_chest"]["inputs"].size() == 6, "the Healer's Chest holds six different remedies")
	_check(G.nodes["pet_badger"]["cost"].has("healers_chest") and G.nodes["pet_badger"]["cost"].has("tea_set"), "the badger comes for the chest and the tea set")
	print("FOREST %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
