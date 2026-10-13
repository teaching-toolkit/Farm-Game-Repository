extends Node
## Tests of kits/core (no farm needed): modifiers fold right, conditions parse, the random source repeats with a seed,
## the clock calls its systems in order. And for the farm: every condition in the data is known, the clock's order.
## Run:  godot --headless --path . res://tests/core_test.tscn -- --seed=1
const Modifiers = preload("res://kits/core/modifiers.gd")
const Conditions = preload("res://kits/core/conditions.gd")
const Rng = preload("res://kits/core/rng.gd")
const Clock = preload("res://kits/core/clock.gd")
const Saves = preload("res://kits/core/saves.gd")
var fails := 0
var checks := 0

func _ready() -> void:
	# modifiers
	var t := Modifiers.fold([[{"add": {"luck": 0.1}, "mult": {"weedRate": 0.5}, "set": {"bookSlots": 2}}, 1.0],
		[{"add": {"luck": 0.2}, "mult": {"weedRate": 0.8}, "produces": {"stick": 1}}, 0.5],
		[{"set": {"bookSlots": 4}}, 1.0]])
	_check(is_equal_approx(Modifiers.value(t, "luck"), 0.2), "add: 0.1 + 0.2 × 0.5")
	_check(is_equal_approx(Modifiers.mult(t, "weedRate"), 0.5 * 0.9), "mult: 0.5 × (1 - 0.2 × 0.5)")
	_check(Modifiers.value(t, "bookSlots") == 4.0, "set: the last one wins")
	_check(Modifiers.mult(t, "nothing") == 1.0 and Modifiers.value(t, "nothing", 7.0) == 7.0, "defaults")
	_check(is_equal_approx(float(t["produces"]["stick"]), 0.5), "produces × weight")
	# conditions
	var C = Conditions.new()
	var have := {"harvests": 40.0}
	C.counter("harvests", func(): return have["harvests"])
	C.kind("unlocked", func(a): return a == "barn")
	_check(C.check("harvests>=40"), ">= true")
	_check(not C.check("harvests>40"), "> false")
	_check(C.check("harvests<=40") and C.check("harvests==40") and not C.check("harvests<40"), "<= == <")
	_check(C.check("harvests>=10 & unlocked:barn") and not C.check("harvests>=10 & unlocked:mill"), "and")
	C.named("rainbow", func(): return true)
	_check(C.check("rainbow") and C.unknown("rainbow").is_empty(), "named")
	_check(not C.check("cows>=1") and not C.check("weather:sun") and not C.check(""), "unknown is false")
	_check(C.unknown("harvests>=1 & cows>=2 & unlocked:x & moon:full") == ["cows>=2", "moon:full"], "unknown() lists the unknown parts")
	# random numbers
	var a = Rng.new(); var b = Rng.new()
	a.seed_with(5); b.seed_with(5)
	var xa := [1, 2, 3, 4, 5, 6, 7, 8]; var xb := xa.duplicate()
	a.shuffle(xa); b.shuffle(xb)
	_check(xa == xb and a.pick([1, 2, 3]) == b.pick([1, 2, 3]) and a.chance(0.5) == b.chance(0.5), "a seed repeats")
	# clock
	var clock = Clock.new()
	var seen := []
	clock.add("one", func(r): seen.append("one"); r["n"] = 1)
	clock.add("two", func(r): seen.append("two"); r["n"] = int(r["n"]) + 1)
	var rep: Dictionary = clock.step({})
	_check(seen == ["one", "two"] and rep["n"] == 2 and clock.order() == ["one", "two"], "clock order and report")
	# saves
	var d0 := {"a": 1}
	var steps := [func(d): d["b"] = 2, func(d): d["a"] = int(d["a"]) + 10]
	var up := Saves.upgrade(d0, steps, 2)
	_check(up["b"] == 2 and up["a"] == 11 and Saves.version_of(up) == 2, "saves: upgrade steps from version 0 to 2")
	var d1 := Saves.unpack(Saves.pack({"a": 1, "list": [1]}, 1))
	Saves.fill(d1, {"list": [9], "new": {"x": 1}})
	_check(d1["list"] == [1.0] and d1["new"] == {"x": 1} and Saves.version_of(d1) == 1, "saves: pack, unpack, fill")
	_check(Saves.unpack("not json").is_empty(), "saves: no save")
	# the farm: every condition in the data is known; the clock runs in today's order
	var G = get_node("/root/Game")
	var bad := []
	for a2 in G.meta.get("acorns", {}).get("list", []): bad.append_array(G.conditions.unknown(str(a2["when"])))
	for p in G.meta.get("perks", {}).get("list", []):
		if p.has("when") and str(p["when"]).find(">=") >= 0 or str(p.get("when", "")).begins_with("unlocked:"):
			bad.append_array(G.conditions.unknown(str(p["when"])))
	_check(bad.is_empty(), "farm: conditions in the data are known %s" % [bad])
	_check(G.clock.order() == ["pace", "season", "rain", "water", "producers", "crops", "weeds_stones", "pests", "stations",
		"reading", "home_fuel", "market", "wear", "neighbour_gift", "luck_boosts", "acorns", "auto_unlocks", "perks"], "farm: clock order")
	print("CORE %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL: ", what)
