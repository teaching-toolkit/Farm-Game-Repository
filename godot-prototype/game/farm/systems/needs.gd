extends RefCounted
## Needs and energy: Rest sums and the energy they give, food and buffs, the cold house without firewood. (Kit to be: needs & energy.)
## Split out of game.gd in R4 (12 Oct 2026). Everything else of the game is reached through G, the front door
## (the Game autoload), which still answers to every function name, so callers did not change.

var G

func eat(k: String) -> bool:
	var b = G.items[k].get("buff", null)
	if b == null or G.count(k) < 1.0: return false
	G.take(k, 1.0)
	G.S["buff"] = {"mult": float(b["energy"]), "until": G.S["step"] + int(b["questions"]), "item": k}
	G.say((tr("😋 Yum! Work costs %d%% less energy for %d question.") if int(b["questions"]) == 1 else tr("😋 Yum! Work costs %d%% less energy for %d questions.")) % [int(round((1.0 - float(b["energy"])) * 100)), int(b["questions"])])
	G.save_game(); G.changed.emit()
	return true

## The player's maths record, with the categories practised (settings.json mathCategories; a parent can add more).
func math_record() -> Dictionary:
	var r: Dictionary = G.math.rec(G._learn(), G.settings.get("mathCategories", ["addsub"]))
	for c in G.settings.get("mathCategories", ["addsub"]):
		if not r["active"].has(c): r["active"].append(c)
	return r

## The next Rest sum (kits/learn/math_engine.gd: levels from 1 + 1 on, spaced repetition for every task, medals).
func rest_question() -> Dictionary:
	G.math_record()
	return G.math.question(G._learn(), G.rng, float(G.settings.get("restTimerScale", 1.0)))

## Remembers how a Rest sum went and says what to show (see math_engine.result).
func rest_result(q: Dictionary, right: bool, fast: bool) -> Dictionary:
	var fb: Dictionary = G.math.result(G._learn(), q, right, fast, G.rng)
	G.after_rest_answer(right, fast)
	return fb

## After every Rest answer (the number pad asks and remembers by itself): save, count quick ones for the perks.
func after_rest_answer(right: bool, fast: bool) -> void:
	G.save_learning()
	if right and fast: G.S["stats"]["rest_quick"] = int(G.S["stats"].get("rest_quick", 0)) + 1
	G._check_perks()

## The level of a Rest task for the window (see math_engine.level_info).
func arith_info(level_id := "") -> Dictionary:
	return G.math.level_info(G._learn(), level_id)

## fast = answered before the Rest timer ran out (settings.json restTimerSeconds); slow answers give restSlowShare of it.
func rest_correct(fast := true) -> float:
	var before = float(G.S["energy"])
	var gain = G.rest_per_answer() * (1.0 if fast else float(G.settings.get("restSlowShare", 0.5)))
	G.S["energy"] = minf(G.energy_max(), before + gain)
	G.S["stats"]["rest"] = int(G.S["stats"]["rest"]) + 1
	G._job("rest", "", 1.0)
	G.changed.emit()
	return float(G.S["energy"]) - before

func _tick_home_fuel() -> void:
	if G.season() != "winter":
		G.S["cold"] = false
		return
	var need = G.g("homeFuel", 0.2) * G.m("homeFuel") * G.m("fuel")
	G.auto_stack(need)
	if float(G.S["woodpile"]) + 0.0001 >= need:
		G.S["woodpile"] = float(G.S["woodpile"]) - need
		if G.S["cold"]: G.say(tr("🔥 The house is warm again."))
		G.S["cold"] = false
	else:
		if not G.S["cold"]: G.say(tr("❄️🏠 The house is cold: no firewood! Rest gives less energy. Stack sticks or logs on the woodpile."))
		G.S["cold"] = true
