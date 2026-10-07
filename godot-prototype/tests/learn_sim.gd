extends SceneTree
## A pretend child plays the Rest sums: how many answers until each level is passed?
## Run:  godot --headless --path . -s res://tests/learn_sim.gd
## The child already knows the facts of the first levels by heart (quick); newer tasks are right 75 % of the time and
## slow at first, and become quick after a few right answers.

func _init() -> void:
	var M = load("res://learnkit/math_engine.gd").new()
	M.load_curriculum()
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var L := {}
	M.rec(L, ["addsub"])
	var know_upto := 9          # as.f01 … as.f09 known by heart at the start of 2nd class
	var practice := {}          # task -> right answers so far
	var passed := {}
	var medals := {"bronze": 0, "silver": 0, "gold": 0}
	for n in range(1, 2501):
		var q: Dictionary = M.question(L, rng)
		var lv: Dictionary = M.levels.get(q["level"], {})
		var idx := int(lv.get("pos", 0)) + 1
		var fluent: bool = lv.get("fluency", true) and idx <= know_upto and lv.get("cat", "") == "addsub"
		var k: String = q["key"]
		var seen := int(practice.get(k, 0))
		var right := rng.randf() < (0.98 if fluent else minf(0.95, 0.72 + 0.06 * seen))
		var quick := right and (fluent or seen >= 2 or rng.randf() < 0.2)
		if right: practice[k] = seen + 1
		var fb: Dictionary = M.result(L, q, right, quick, rng)
		for m in fb["medals"]:
			medals[m["medal"]] += 1
			if m["medal"] == "bronze": passed[m["level"]] = n
	var line := []
	for s in M.sections:
		if s["cat"] != "addsub": continue
		for id in s["ids"]:
			line.append("%s@%s" % [id, str(passed.get(id, "-"))])
	print("passed (answer no.): ", " ".join(line))
	print("medals after 2500 answers: ", medals, "  known by heart: ", M.known_count(L), "  struggling now: ", M.struggling(L["math"]))
	quit()
