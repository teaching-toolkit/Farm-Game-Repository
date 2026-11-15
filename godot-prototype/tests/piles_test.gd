extends Node
## The piles beside the store and the loose sticks and stones (visible-work/02 and /03): the size rule, a map with piles and loose
## things, the rules of the loose things (start, pick, full store, new ones, old saves).
## Run:  godot --headless --path . res://tests/piles_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	var steps := [1, 8, 20, 40]
	for pair in [[0, 0], [0.5, 0], [1, 1], [7, 1], [8, 2], [19, 2], [20, 3], [40, 4], [500, 4]]:
		_check(FarmMapPiles.size_for(float(pair[0]), steps) == pair[1], "size_for(%s) is %d" % [pair[0], pair[1]])
	_map()
	_rules()
	print("PILES %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _map() -> void:
	G.reset_game()
	var m := FarmMap.new()
	m.size = Vector2(834, 1000)
	add_child(m)
	var st: Dictionary = G.meta["piles"]["things"]
	_check(st.has("stick") and st.has("stone") and st.has("boulder"), "the data has a pile for sticks, stones and boulders")
	for item in st:
		_check(m.pile_size(item) == 0, "no %s pile at first" % item)
		var steps: Array = st[item]["steps"]
		for k in range(steps.size()):
			m.set_piles({item: float(steps[k])})
			_check(m.pile_size(item) == k + 1, "%s: %d stored shows size %d" % [item, int(steps[k]), k + 1])
		m.set_piles({item: float(steps[steps.size() - 1]) + 300.0})
		_check(m.pile_size(item) == steps.size(), "%s: more than the last step still shows the biggest" % item)
		m.set_piles({item: 0.0})
		_check(m.pile_size(item) == 0 and m.pile_point(item) == m.spot_point("storage"), "%s: emptied, the pile is gone and things fly to the store" % item)
	m.set_piles({"stick": 9.0})
	_check(m.pile_point("stick") != m.spot_point("storage"), "a pile is where things fly to")
	_check(m.piles._nodes["stick"].mouse_filter == Control.MOUSE_FILTER_IGNORE, "a pile does not catch taps")
	# the loose things: every one lies on a free spot
	G.reset_game()
	m.set_loose(G.loose.things())
	_check(m.loose.shown() == 14, "14 loose things are drawn (%d)" % m.loose.shown())
	var bad := 0
	for id in m.loose._cell:
		if not m.loose._free(m.loose._cell[id], id): bad += 1
	_check(bad == 0, "none lies on a building, a patch, a pen, the forest or the road (%d do)" % bad)
	var got := []
	m.loose_tapped.connect(func(id): got.append(id))
	m.loose.loose_tapped.emit(3)
	_check(got == [3], "a tap on a loose thing tells the rules' side its id")
	G.S["loose"]["things"].remove_at(0)
	m.set_loose(G.loose.things())
	_check(m.loose.shown() == 13, "a picked thing disappears from the map")
	m.queue_free()

func _rules() -> void:
	G.reset_game()
	var L = G.loose
	_check(L.count() == 14, "a new game has 14 loose things (%d)" % L.count())
	var ok := true
	for t in L.things():
		ok = ok and t["u"] >= 0.0 and t["u"] <= 1.0 and t["v"] >= 0.0 and t["v"] <= 1.0 and t["k"] in ["stick", "stone"]
	_check(ok, "every loose thing has u, v in 0..1 and is a stick or a stone")
	var ids := {}
	for t in L.things(): ids[t["id"]] = true
	_check(ids.size() == 14, "every id is its own")
	# pick one through the chore
	var t0: Dictionary = L.things()[0]
	var kind: String = t0["k"]
	var q: Dictionary = G.actions.check("pick_loose", G.actions.farmer, {"id": t0["id"]})
	G.S["energy"] = G.needs.energy_max()
	var e0: float = G.S["energy"]
	var n0: float = G.inventory.count(kind)
	_check(L.pick(int(t0["id"])), "a loose thing is picked up through the chore")
	_check(L.count() == 13 and G.inventory.count(kind) == n0 + 1.0, "it is gone from the farm and in the store")
	_check(is_equal_approx(e0 - float(G.S["energy"]), float(q["cost"]["energy"])), "and it cost the chore's energy")
	# a full store takes nothing and the thing stays
	var t1: Dictionary = L.things()[0]
	var k1: String = t1["k"]
	G.S["inv"][k1] = [[G.seasons.season_no(), G.needs.storage_cap(k1)]]
	G.S["energy"] = G.needs.energy_max()
	var full0: float = G.inventory.count(k1)
	var n1: int = L.count()
	L.pick(int(t1["id"]))
	_check(L.count() == n1 and G.inventory.count(k1) == full0, "with a full store the thing stays lying and nothing is added")
	# new ones come, never more than max
	G.reset_game()
	G.S["loose"]["things"] = []
	var every := int(G.meta["loose"]["every"])
	var mx := int(G.meta["loose"]["max"])
	for _i in range(every * 3): G.step_time()
	_check(L.count() == 3, "one new thing every %d steps (%d after %d steps)" % [every, L.count(), every * 3])
	for _i in range(every * 40): G.step_time()
	_check(L.count() == mx, "never more than %d at once (%d)" % [mx, L.count()])
	var kinds := {}
	for t in L.things(): kinds[t["k"]] = true
	_check(kinds.size() == 2, "sticks and stones come in turn")
	# an old save without the key
	var old: Dictionary = G.S.duplicate(true)
	old.erase("loose")
	preload("res://kits/core/saves.gd").fill(old, G.all_save_defaults())
	_check(old.has("loose") and old["loose"]["things"].is_empty() and old["loose"]["next"] == 1, "an old save without the key gets the defaults")

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
