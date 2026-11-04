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
	# conditions: the grammar and the register (the words here are made up; the game registers its own)
	var cd = Conditions.new()
	cd.register("done", func(a): return a == "tent", "yes", "node", "n", "done:tent")
	cd.register("seen", func(a): return a == "album", "yes", "seen", "n", "seen:album")
	cd.register("start", func(_a): return true, "yes", "", "n", "start")
	cd.register("weeds", func(_a): return 12.0, "number", "", "n", "weeds>=10")
	cd.register("item", func(a): return 3.0 if a == "carrot" else 0.0, "number", "item", "n", "item:carrot>=3")
	cd.register("odd", func(_a): return NAN, "number", "", "n", "odd>=1")
	_check(cd.holds("done:tent") and not cd.holds("done:barn"), "a yes-or-no word with an argument")
	_check(cd.holds("weeds>=10") and cd.holds("weeds>=12") and not cd.holds("weeds>=13"), "at least: reaches, exactly, not yet")
	_check(cd.holds("weeds<13") and not cd.holds("weeds<12"), "fewer than")
	_check(cd.holds("item:carrot>=3") and not cd.holds("item:carrot>=4") and cd.holds("item:egg<1"), "a number word with an argument")
	_check(cd.holds("not:done:barn") and not cd.holds("not:done:tent") and cd.holds("not:weeds>=13") and cd.holds("not:not:start"), "not: turns it round")
	_check(not cd.holds("unknown>=0") and not cd.holds("not:unknown>=0") and not cd.holds("not:nothing:x"), "a word nobody registered is false, also behind not:")
	_check(not cd.holds("weeds") and not cd.holds("not:weeds") and not cd.holds("start>=1") and not cd.holds("weeds>=x") and not cd.holds("") and not cd.holds("odd>=1") and not cd.holds("not:odd>=1"), "a number word without a comparison, a yes word with one, a bad number, nothing, a reader with no number: false")
	_check(cd.valid("not:item:carrot<2") and not cd.valid("weeds") and not cd.valid("nothing"), "valid: well formed with known words")
	_check(cd.holds_all([]) and cd.holds_all(["done:tent", "weeds>=10", "seen:album"]) and not cd.holds_all(["done:tent", "weeds>=13"]), "a list: all of them; an empty list holds")
	_check(cd.value("weeds") == 12.0 and cd.value("item:carrot") == 3.0 and is_nan(cd.value("start")) and is_nan(cd.value("nothing")), "value of a number word")
	var voc: Dictionary = cd.vocabulary()
	_check(voc.size() == 6 and voc["item"]["arg"] == "item" and voc["weeds"]["kind"] == "number" and not voc["done"].has("read"), "the vocabulary lists every word without its reader")
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
