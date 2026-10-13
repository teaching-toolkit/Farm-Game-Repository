extends SceneTree
## The core kit (kits/core/): effects fold correctly, the condition language reads, the clock runs its steps in order,
## the random source is seedable. No game needed.
## Run:  godot --headless --path . -s res://tests/core_test.gd
const Modifiers = preload("res://kits/core/modifiers.gd")
const Conditions = preload("res://kits/core/conditions.gd")
const Clock = preload("res://kits/core/clock.gd")
const Rng = preload("res://kits/core/rng.gd")
var fails := 0
var checks := 0

class FakeGame:
	func done(id: String) -> bool: return id == "tent"
	func seen(id: String) -> bool: return id == "album"
	func term(name: String, arg: String) -> bool: return name == "start" or (name == "has" and arg == "carrot:3")
	func counter(name: String) -> float:
		return {"weeds": 12.0, "seasons": 2.0}.get(name, NAN)

func _init() -> void:
	# modifiers
	var t: Dictionary = Modifiers.empty()
	Modifiers.apply(t, {"set": {"waterCap": 20}, "add": {"yield_wheat": 1}, "mult": {"energyCost": 0.8}, "produces": {"stick": 2}})
	Modifiers.apply(t, {"set": {"waterCap": 30}, "add": {"yield_wheat": 2}, "mult": {"energyCost": 0.5}})
	_check(Modifiers.value(t, "waterCap") == 30.0, "the last set wins")
	_check(Modifiers.value(t, "yield_wheat") == 3.0, "adds add up")
	_check(is_equal_approx(Modifiers.mult(t, "energyCost"), 0.4), "factors multiply (0.8 × 0.5)")
	_check(Modifiers.mult(t, "nothing") == 1.0, "no factor is 1")
	_check(Modifiers.value(t, "nothing", 7.0) == 7.0, "a missing key gives the default")
	Modifiers.apply(t, {"mult": {"energyCost": 0.5}, "add": {"yield_wheat": 4}, "produces": {"stick": 2}}, 0.5)
	_check(is_equal_approx(Modifiers.mult(t, "energyCost"), 0.4 * 0.75), "a weight of 0.5 pulls a factor halfway to 1")
	_check(Modifiers.value(t, "yield_wheat") == 5.0, "a weight scales an add")
	_check(t["produces"]["stick"] == 3.0, "produces add up with the weight")
	var t0: Dictionary = Modifiers.empty()
	Modifiers.apply(t0, {"mult": {"x": 0.1}, "add": {"y": 5}}, 0.0)
	_check(Modifiers.mult(t0, "x") == 1.0 and Modifiers.value(t0, "y") == 0.0, "weight 0 has no effect")
	# conditions
	var fg := FakeGame.new()
	_check(Conditions.check("unlocked:tent", fg), "unlocked: a node that is done")
	_check(Conditions.check("done:tent", fg), "done: the same")
	_check(not Conditions.check("unlocked:barn", fg), "unlocked: a node that is not")
	_check(Conditions.check("weeds>=10", fg), "a counter that reaches the number")
	_check(Conditions.check("weeds>=12", fg), "…exactly")
	_check(not Conditions.check("weeds>=13", fg), "…not yet")
	_check(not Conditions.check("unknown>=0", fg), "a counter nobody knows is false")
	_check(not Conditions.check("weeds", fg) and not Conditions.check("", fg), "nonsense is false")
	_check(Conditions.check("seen:album", fg) and not Conditions.check("seen:bag", fg), "seen: asks the provider")
	_check(not Conditions.check("seen:album", Modifiers), "seen: is false for a provider that cannot tell")
	_check(Conditions.check_all([], fg), "no conditions: holds")
	_check(Conditions.check_all(["done:tent", "weeds>=10", "seen:album"], fg), "all of a list")
	_check(not Conditions.check_all(["done:tent", "weeds>=13"], fg), "…one failing makes the list fail")
	_check(Conditions.check("start", fg) and Conditions.check("has:carrot:3", fg) and not Conditions.check("has:carrot:4", fg), "the game's own terms: name or name:argument go to the provider")
	_check(not Conditions.check("start", Modifiers), "…false for a provider without terms")
	# clock
	var c = Clock.new()
	var seen := []
	c.register("a", func(r): seen.append("a"); r["n"] = int(r.get("n", 0)) + 1)
	c.register("c", func(_r): seen.append("c"))
	c.register("b", func(_r): seen.append("b"), "a")
	c.register("z", func(_r): seen.append("z"), "", "a")
	_check(c.names() == ["z", "a", "b", "c"], "steps run in the order registered, or after / before another: %s" % str(c.names()))
	var rep := {}
	c.run(rep)
	_check(seen == ["z", "a", "b", "c"] and rep["n"] == 1, "run calls them in that order and hands each the report")
	# random source
	var r1 = Rng.new(); r1.seed = 5
	var r2 = Rng.new(); r2.seed = 5
	var a1 := [1, 2, 3, 4, 5, 6, 7, 8]; var a2 := [1, 2, 3, 4, 5, 6, 7, 8]
	r1.shuffle(a1); r2.shuffle(a2)
	_check(a1 == a2 and a1 != [1, 2, 3, 4, 5, 6, 7, 8], "the same seed shuffles the same way (%s)" % str(a1))
	var hits := 0
	for _i in range(1000):
		if r1.chance(0.25): hits += 1
	_check(hits > 150 and hits < 350, "chance(0.25) is about a quarter (%d of 1000)" % hits)
	_check(r1.pick([9]) == 9, "pick from one element")
	print("CORE %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
