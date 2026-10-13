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
	_check(T.capacity() == 10.0 and T.device() == "", "in the arms the farmer carries 10 (%s)" % T.capacity())
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
	# counters for the reveal
	T.pack("fiber", 1)
	_check(G.counter("packed") == 1.0 and G.counter("trips") == 0.0, "the counters the reveal asks for")
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
