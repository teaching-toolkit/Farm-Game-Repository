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
	_check(float(G.trip.data().get("base", 0)) > 0.0 and _cost() >= 1, "the real trip data has a base and a cost (%d ⚡)" % _cost())
	_check(T.is_empty() and T.load_now() == 0.0 and T.room() == 10.0, "a new bag is empty")
	G.S["inv"].clear()
	G.inventory.add_item("boulder", 5.0, true)      # heavy: 4 load each (a big rock; a small stone is light, 0.5)
	G.inventory.add_item("fiber", 6.0, true)      # light: 0.5 each
	_check(T.can_pack("boulder") == 2, "10 room fit two big rocks (%d)" % T.can_pack("boulder"))
	_check(T.pack("boulder", 5) == 2 and T.packed("boulder") == 2.0 and T.load_now() == 8.0, "packing 5 big rocks puts 2 in: load 8")
	_check(G.inventory.count("boulder") == 5.0, "packing does not take anything out of the store")
	_check(T.can_pack("fiber") == 4 and T.pack("fiber", 9) == 4 and is_equal_approx(T.room(), 0.0), "four light fibres (0.5 each) fill the bag")
	_check(T.pack("fiber", 1) == 0, "a full bag takes nothing more")
	_check(T.unpack("boulder", 1) == 1 and T.packed("boulder") == 1.0 and T.room() == 4.0, "unpacking one big rock frees 4")
	# what is eaten or used leaves the bag by itself
	G.inventory.take("boulder", 5.0)
	_check(T.packed("boulder") == 0.0 and not T.contents().has("boulder"), "used up things are not packed any more")
	_check(T.load_now() == 2.0, "the load follows what is really there (%s)" % T.load_now())
	# a carrying thing
	G.S["unlocked"]["fiber_bag"] = true
	G.invalidate_caps()
	_check(T.capacity() == 18.0 and T.device() == "fiber_bag", "a woven bag carries 18")
	G.S["unlocked"]["wheelbarrow"] = true
	_check(T.capacity() == 70.0 and T.device() == "wheelbarrow", "the best thing counts (wheelbarrow 70)")
	T.unpack_all()
	_check(T.is_empty() and T.fill() == 0.0, "unpacking everything")
	# strength (money-market/02): above `strength.from` every point of strength adds `perPoint` of the capacity; never less than the plain capacity; whole units
	G.meta["trip"]["strength"] = {"from": 0.5, "perPoint": 0.6}      # the test's own numbers
	G.S["well"]["v"]["strength"] = 1.0
	_check(T.capacity() == 70.0 and T.strength_room() == 0.0, "before chapter 2 the wellbeing is frozen: strength adds nothing (%s)" % T.capacity())
	G.S["unlocked"]["pet_bunny"] = true
	G.invalidate_caps()
	_check(G.well.active() and T.capacity() == floorf(70.0 * 1.3) and T.strength_room() == 21.0, "full strength carries 30%% more: 70 → %s (+%s)" % [T.capacity(), T.strength_room()])
	G.S["well"]["v"]["strength"] = 0.75
	_check(T.capacity() == floorf(70.0 * (1.0 + 0.6 * 0.25)), "a quarter above the middle carries 15%% more (%s)" % T.capacity())
	G.S["well"]["v"]["strength"] = 0.5
	_check(T.capacity() == 70.0 and T.strength_room() == 0.0, "at the middle (where every farm starts) nothing changes")
	G.S["well"]["v"]["strength"] = 0.0
	_check(T.capacity() == 70.0, "a weak farmer is not made to carry less")
	G.S["well"]["v"]["strength"] = 1.0
	G.S["unlocked"].erase("wheelbarrow")
	G.invalidate_caps()
	_check(T.capacity() == floorf(18.0 * 1.3) and T.capacity() == floorf(T.capacity()), "it works on the carrying thing that is owned, in whole units (woven bag 18 → %s)" % T.capacity())
	_check(T.device() == "fiber_bag", "the carrying thing shown is still the woven bag")
	G.S["well"]["v"]["strength"] = 0.5
	G.S["unlocked"].erase("pet_bunny")
	G.S["unlocked"].erase("fiber_bag")
	G.invalidate_caps()
	G.meta["trip"]["devices"] = {}
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
	_check(_cost() >= 1 and G.actions.check("village_trip", G.actions.farmer)["ok"], "a trip costs energy and can be started")
	T.pack("egg", 2)
	var e0: float = G.S["energy"]
	var cost0: int = _cost()
	_check(_go() and T.walking() and is_equal_approx(G.S["energy"], e0 - cost0), "going takes the energy and starts the walk")
	_check(not _go(), "not twice")
	_check(not G.trade.sell("egg", 1.0), "on the way nothing is sold either")
	T.arrive()
	_check(T.at_square() and int(G.S["trips"]) == 1, "then the village square")
	var fill_sell0: float = T.fill()
	_check(fill_sell0 > 0.0 and T.home_fill() == 0.0, "on arrival the bag holds what is to sell and nothing is carried home yet (money-market/06)")
	_check(G.trade.sell("egg", 5.0) and G.inventory.count("egg") == 1.0 and T.packed("egg") == 0.0, "only the packed eggs are sold (2 of 3), the third stays")
	_check(T.fill() < fill_sell0 and T.fill() == 0.0, "a sale empties the bag's bar (money-market/06)")
	_check(is_equal_approx(T.buy_room(), 10.0), "the way home has the whole room")
	var seeds0: float = G.S["seeds"].get("crop_wheat", 0.0)
	_check(G.trade.buy_seeds("crop_wheat", 3) and float(G.S["seeds"]["crop_wheat"]) == seeds0 + 3.0, "seeds are bought on the square")
	_check(is_equal_approx(T.buy_room(), 10.0 - 3.0 * G.inventory.seed_weight()), "…and take room on the way home (feathers)")
	_check(is_equal_approx(T.home_fill(), 3.0 * G.inventory.seed_weight() / 10.0) and T.home_fill() > 0.0, "…and fill the way-home bar by the same share (money-market/06)")
	_check(is_equal_approx(T.home_fill() * T.capacity() + T.buy_room(), T.capacity()), "the way-home bar and the room left always add up to the capacity")
	_check(is_equal_approx(T.carry_fill(), T.fill() + T.home_fill()) and T.carry_fill() > T.fill(), "the thin bar under the 🎒 icon on the square counts what is still to sell plus what is bought")
	G.S["trip"]["bought"] = 9.9
	_check(not G.trade.buy_seeds("crop_wheat", 20) or T.buy_room() < 0.5, "a full way home takes no more")
	G.S["trip"]["bought"] = 25.0
	_check(T.home_fill() == 1.0, "the way-home bar never goes past full")
	# an order is handed over from the bag
	G.inventory.add_item("porridge", 3.0, true)
	G.S["unlocked"]["campfire"] = true
	G.S["energy"] = 20.0
	_check(not G.progression.can_unlock("d_porridge")["ok"], "an order cannot be handed over before it is in the bag")
	_check(T.can_pack_cost(G.pace.node_cost("d_porridge")), "its cost can be packed")
	T.pack_cost(G.pace.node_cost("d_porridge"))
	_check(T.packed("porridge") == 2.0 and G.progression.can_unlock("d_porridge")["ok"], "packed: it can be handed over")
	var fill_order0: float = T.fill()
	_check(G.progression.unlock("d_porridge") and G.done("d_porridge") and T.packed("porridge") == 0.0 and G.inventory.count("porridge") == 1.0, "handed over: the porridge leaves the store and the bag")
	_check(fill_order0 > 0.0 and T.fill() < fill_order0, "a delivery empties the bag's bar too (money-market/06)")
	T.leave()
	_check(T.phase() == "" and T.is_empty() and T.home_fill() == 0.0 and T.carry_fill() == 0.0, "back home the bag is empty again and nothing is carried home")
	G.S["trip"] = {"phase": "", "bought": 5.0}
	T.pack("egg", 1)
	_check(is_equal_approx(T.carry_fill(), T.fill()), "at home the thin bar is just the bag's load (a stray 'bought' counts only on the square)")
	T.unpack_all()
	G.S["trip"] = {"phase": "", "bought": 0.0}
	_check(not G.progression.can_unlock("d_veg_soup")["ok"], "at home no order can be handed over")
	# the energy of a trip: a better road makes it cheaper, never below the minimum
	var c1: int = _cost()
	G.S["unlocked"]["road_5"] = true
	G.invalidate_caps()
	_check(_cost() <= c1 and _cost() >= int(T.data()["energy"]["min"]), "a better road does not make the trip dearer (%d → %d ⚡)" % [c1, _cost()])
	# boots (the errand multiplier of the feet's gear) and a borrowed donkey (energy:trip) make it cheaper (money-market/02)
	G.S["unlocked"].erase("road_5")
	G.S["unlocked"]["road_3"] = true
	G.invalidate_caps()
	var c_road3: int = _cost()
	for boots in ["wooden_clogs", "hobnail_boots", "waxed_boots"]:
		G.S["unlocked"][boots] = true
		G.invalidate_caps()
		_check(_cost() <= c_road3, "%s do not make the trip dearer (%d ⚡)" % [boots, _cost()])
	_check(_cost() < c_road3, "boots make the trip cheaper on a better road (%d → %d ⚡)" % [c_road3, _cost()])
	for boots in ["wooden_clogs", "hobnail_boots", "waxed_boots"]: G.S["unlocked"].erase(boots)
	G.S["unlocked"].erase("road_3")
	G.invalidate_caps()
	var c_plain: int = _cost()
	_check(G.nodes.has("jans_donkey") and G.nodes["sq_sick_neighbour"]["reward"]["helper"] == "jans_donkey", "a donkey is lent by someone helped: the reward of the favour for Old Jan")
	G.S["unlocked"]["jans_donkey"] = true
	G.invalidate_caps()
	_check(G.m("energy:trip") < 1.0 and _cost() < c_plain, "a borrowed donkey makes the trip cheaper (%d → %d ⚡)" % [c_plain, _cost()])
	_check(is_equal_approx(G.m("energy:errand"), 1.0), "…and only the trip: the errand multiplier of deliveries is the same")
	G.S["unlocked"].erase("jans_donkey")
	G.invalidate_caps()
	T.unpack_all()
	# counters for the reveal
	T.pack("egg", 1)
	_check(G.conditions.value("packed") == 1.0 and G.conditions.value("trips") == 1.0, "the counters the reveal asks for")
	# every graded item is packable and weighs something
	var bad := []
	for k in G.items:
		if G.inventory.weight_of(k) <= 0.0: bad.append(k)
	_check(bad.is_empty(), "every item weighs something %s" % str(bad))
	print("TRIP %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

## The trip's energy and start go through the actions system (chore "village_trip").
func _cost() -> int:
	return int(G.actions.check("village_trip", G.actions.farmer)["cost"]["energy"])

func _go() -> bool:
	return G.actions.perform("village_trip", G.actions.farmer)["done"]

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
