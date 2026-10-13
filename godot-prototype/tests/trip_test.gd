extends Node
## The bag and the trip (TODO Phase 6): capacity, packing, the store keeps what is packed, the data. Rules only.
## Run:  godot --headless --path . res://tests/trip_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var T = G.trip
	G.meta["trip"]["base"] = 10.0                         # the test's own numbers, whatever the data says
	G.meta["trip"]["devices"] = {"fiber_bag": 18, "wicker_pack": 28, "wheelbarrow": 70}
	_check(T.capacity() == 10.0 and T.device() == "", "in the arms the farmer carries 10 (%s)" % T.capacity())
	_check(float(G.trip.data().get("base", 0)) > 0.0 and G.trip.energy_cost() >= 1, "the real trip data has a base and a cost (%d ⚡)" % G.trip.energy_cost())
	_check(T.is_empty() and T.load_now() == 0.0 and T.room() == 10.0, "a new bag is empty")
	G.S["inv"].clear()
	G.inventory.add_item("stone", 5.0, true)      # heavy: 4 load each
	G.inventory.add_item("fiber", 6.0, true)      # light: 0.5 each
	_check(T.can_pack("stone") == 2, "10 room fit two stones (%d)" % T.can_pack("stone"))
	_check(T.pack("stone", 5) == 2 and T.packed("stone") == 2.0 and T.load_now() == 8.0, "packing 5 stones puts 2 in: load 8")
	_check(G.inventory.count("stone") == 5.0, "packing does not take anything out of the store")
	_check(T.can_pack("fiber") == 4 and T.pack("fiber", 9) == 4 and is_equal_approx(T.room(), 0.0), "four light fibres (0.5 each) fill the bag")
	_check(T.pack("fiber", 1) == 0, "a full bag takes nothing more")
	_check(T.unpack("stone", 1) == 1 and T.packed("stone") == 1.0 and T.room() == 4.0, "unpacking one stone frees 4")
	# what is eaten or used leaves the bag by itself
	G.inventory.take("stone", 5.0)
	_check(T.packed("stone") == 0.0 and not T.contents().has("stone"), "used up things are not packed any more")
	_check(T.load_now() == 2.0, "the load follows what is really there (%s)" % T.load_now())
	# a carrying thing
	G.S["unlocked"]["fiber_bag"] = true
	G.invalidate_caps()
	_check(T.capacity() == 18.0 and T.device() == "fiber_bag", "a woven bag carries 18")
	G.S["unlocked"]["wheelbarrow"] = true
	_check(T.capacity() == 70.0 and T.device() == "wheelbarrow", "the best thing counts (wheelbarrow 70)")
	T.unpack_all()
	_check(T.is_empty() and T.fill() == 0.0, "unpacking everything")
	# seeds and unknown things are not packed
	_check(T.pack("no_such_item", 1) == 0, "a thing that does not exist is not packed")
	# the trip: home -> walk -> square -> home
	G.reset_game()
	G.meta["trip"]["base"] = 10.0
	G.meta["trip"]["devices"] = {}
	T = G.trip
	G.inventory.add_item("egg", 3.0, true)
	G.S["coins"] = 100.0
	_check(not T.at_square() and not G.trade.sell("egg", 1.0), "at home nothing is sold")
	_check(not G.trade.buy_seeds("crop_wheat", 1) and G.S["coins"] == 100.0, "…or bought")
	_check(T.energy_cost() >= 1 and T.can_go()["ok"], "a trip costs energy and can be started")
	T.pack("egg", 2)
	var e0: float = G.S["energy"]
	_check(T.go() and T.walking() and is_equal_approx(G.S["energy"], e0 - T.energy_cost()), "going takes the energy and starts the walk")
	_check(not T.go(), "not twice")
	_check(not G.trade.sell("egg", 1.0), "on the way nothing is sold either")
	T.arrive()
	_check(T.at_square() and int(G.S["trips"]) == 1, "then the village square")
	_check(G.trade.sell("egg", 5.0) and G.inventory.count("egg") == 1.0 and T.packed("egg") == 0.0, "only the packed eggs are sold (2 of 3), the third stays")
	_check(is_equal_approx(T.buy_room(), 10.0), "the way home has the whole room")
	var seeds0: float = G.S["seeds"].get("crop_wheat", 0.0)
	_check(G.trade.buy_seeds("crop_wheat", 3) and float(G.S["seeds"]["crop_wheat"]) == seeds0 + 3.0, "seeds are bought on the square")
	_check(is_equal_approx(T.buy_room(), 10.0 - 3.0 * G.inventory.seed_weight()), "…and take room on the way home (feathers)")
	G.S["trip"]["bought"] = 9.9
	_check(not G.trade.buy_seeds("crop_wheat", 20) or T.buy_room() < 0.5, "a full way home takes no more")
	# an order is handed over from the bag
	G.inventory.add_item("porridge", 3.0, true)
	G.S["unlocked"]["campfire"] = true
	G.S["energy"] = 20.0
	_check(not G.progression.can_unlock("d_porridge")["ok"], "an order cannot be handed over before it is in the bag")
	_check(T.can_pack_cost(G.pace.node_cost("d_porridge")), "its cost can be packed")
	T.pack_cost(G.pace.node_cost("d_porridge"))
	_check(T.packed("porridge") == 2.0 and G.progression.can_unlock("d_porridge")["ok"], "packed: it can be handed over")
	_check(G.progression.unlock("d_porridge") and G.done("d_porridge") and T.packed("porridge") == 0.0 and G.inventory.count("porridge") == 1.0, "handed over: the porridge leaves the store and the bag")
	T.leave()
	_check(T.phase() == "" and T.is_empty(), "back home the bag is empty again")
	G.S["trip"] = {"phase": "", "bought": 0.0}
	_check(not G.progression.can_unlock("d_veg_soup")["ok"], "at home no order can be handed over")
	# the energy of a trip: a better road makes it cheaper, never below the minimum
	var c1: int = T.energy_cost()
	G.S["unlocked"]["road_5"] = true
	G.invalidate_caps()
	_check(T.energy_cost() <= c1 and T.energy_cost() >= int(T.data()["energy"]["min"]), "a better road does not make the trip dearer (%d → %d ⚡)" % [c1, T.energy_cost()])
	T.unpack_all()
	# counters for the reveal
	T.pack("egg", 1)
	_check(G.counter("packed") == 1.0 and G.counter("trips") == 1.0, "the counters the reveal asks for")
	# every graded item is packable and weighs something
	var bad := []
	for k in G.items:
		if G.inventory.weight_of(k) <= 0.0: bad.append(k)
	_check(bad.is_empty(), "every item weighs something %s" % str(bad))
	print("TRIP %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
