extends Node
## The travelling merchant at the gate (TODO M7): when he comes, his cart, his price, when he leaves. Rules only.
## Run:  godot --headless --path . res://tests/gate_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var T = G.gate
	_check(not T.here() and T.arrival_chance() == 0.0, "at first no cart comes: the road is a muddy track")
	G.S["unlocked"]["road_2"] = true
	G.invalidate_caps()
	var c2: float = T.arrival_chance()
	_check(c2 > 0.0 and T.cart_size() > 0.0, "with a road for carts he may come (%.2f), his cart holds %d" % [c2, T.cart_size()])
	G.S["unlocked"]["road_3"] = true
	G.invalidate_caps()
	_check(T.arrival_chance() > c2 and T.cart_size() > 30.0, "a better road: more often, a bigger cart")
	# he comes by chance, stays his questions, leaves
	var came := 0
	for _i in range(400):
		G.S["gate"]["here"] = false
		T.step()
		if T.here(): came += 1
	_check(came > 5 and came < 120, "he comes now and then (%d of 400 questions)" % came)
	G.S["gate"] = {"here": true, "until": G.S["step"] + 3, "cart": 0.0, "visits": 1}
	T.step()
	_check(T.here(), "he stays while his time is not over")
	G.S["step"] += 3
	T.step()
	_check(not T.here(), "and moves on when it is")
	# selling to him: the village price less his cut, as much as the cart takes, no trip
	G.S["gate"] = {"here": true, "until": 999, "cart": 0.0, "visits": 1}
	G.S["inv"].clear()
	G.inventory.add_item("carrot", 8.0, true)
	G.inventory.add_item("stone", 3.0, true)
	_check(T.wants("carrot") and not T.wants("stone"), "he buys crops, not stones")
	var coins0: float = G.S["coins"]
	var village: float = G.trade.sell_total("carrot", 2)
	_check(G.trade.sell_gate("carrot", 2.0), "selling two carrots to him")
	var got: float = G.S["coins"] - coins0
	_check(is_equal_approx(got, village * float(T.data()["cut"])), "he pays the village price less his cut (%.1f of %.1f)" % [got, village])
	_check(G.inventory.count("carrot") == 6.0 and T.cart_room() < T.cart_size(), "the carrots are gone from the store and sit in his cart")
	_check(not G.trade.sell_gate("stone", 1.0), "…and he will not take stones")
	G.S["gate"]["cart"] = T.cart_size() - 1.5
	_check(T.can_take("carrot") == 1, "a nearly full cart takes only what fits (%d)" % T.can_take("carrot"))
	G.S["gate"]["here"] = false
	_check(not G.trade.sell_gate("carrot", 1.0), "when he is not here nothing is sold to him")
	# barter: the axle for coins and two baskets (the first cart, D2)
	G.S["gate"]["here"] = true
	G.S["inv"].clear()
	G.S["coins"] = 1000.0
	_check(not G.trade.barter_gate("axle") and G.inventory.count("axle") == 0.0, "without the baskets there is no axle")
	G.inventory.add_item("wicker_basket", 2.0, true)
	_check(G.trade.barter_gate("axle") and G.inventory.count("axle") == 1.0 and G.S["coins"] == 100.0 and G.inventory.count("wicker_basket") == 0.0, "900 bronze and two baskets buy an axle")
	G.S["unlocked"]["workbench"] = true
	G.S["unlocked"]["road_2"] = true
	G.S["unlocked"]["stone_axe"] = true
	G.inventory.add_item("log", 2.0, true); G.inventory.add_item("rope", 2.0, true); G.inventory.add_item("stick", 6.0, true)
	G.S["energy"] = 20.0
	_check(G.progression.can_unlock("hand_cart")["ok"], "with the axle the first cart can be built")
	G.progression.unlock("hand_cart")
	G.invalidate_caps()
	_check(G.trip.capacity() == 60.0 and G.trip.device() == "hand_cart", "the hand cart makes the bag hold 60 (%s)" % G.trip.capacity())
	# the village still works as before
	_check(is_equal_approx(T.price("carrot", 1), G.trade.sell_total("carrot", 1) * float(T.data()["cut"])), "his price is derived from the village price")
	print("GATE %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
