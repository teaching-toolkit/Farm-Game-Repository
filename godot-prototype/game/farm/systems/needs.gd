extends RefCounted
class_name FarmNeeds
## Energy and Rest: the energy maximum, the cost of work (ecost), food buffs, and the Rest sums that give energy back.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

# ------------------------------------------------------------------ effects

func energy_max() -> float:
	return G.g("energyMax", 20.0) + 3.0 * G.S["acorns"].size()

func water_cap() -> float:
	return G.g("waterCap", 20.0)

func storage_cap() -> float:
	return G.g("storageCap", 10.0)

func rest_per_answer() -> float:
	var v := G.g("energyPerRest", 5.0)
	if G.S.get("cold", false): v *= float(G.meta.get("rest", {}).get("coldHouseMult", 0.75))
	return v

# ------------------------------------------------------------------ energy & costs

func buff_mult() -> float:
	var b: Dictionary = G.S["buff"]
	if b.is_empty(): return 1.0
	if int(b.get("until", 0)) <= G.S["step"]: return 1.0
	return float(b.get("mult", 1.0))

func stars(station_root: String) -> int:
	var uses := int(G.S["practice"].get(station_root, 0))
	var n := 0
	for th in G.meta.get("practice", {}).get("thresholds", [10, 40, 120]):
		if uses >= int(th): n += 1
	return n

func ecost(cat: String, base: float, station_root := "") -> float:
	if base <= 0.0: return 0.0
	var c := base * G.m("energy:" + cat)
	if G.seasons.season() == "winter" and cat in ["craft", "textile", "smith", "wood"]:
		c *= float(G.seasons.smod("indoorEnergy", 1.0))
	if station_root != "":
		c *= pow(float(G.meta.get("practice", {}).get("energyPerStar", 0.95)), stars(station_root))
	return c * buff_mult()

# ------------------------------------------------------------------ Rest

## The player's maths record, with the categories practised (settings.json mathCategories; a parent can add more).
func math_record() -> Dictionary:
	var r: Dictionary = G.math.rec(G.learn_record(), G.settings.get("mathCategories", ["addsub"]))
	for c in G.settings.get("mathCategories", ["addsub"]):
		if not r["active"].has(c): r["active"].append(c)
	return r

## The next Rest sum (kits/learn/math_engine.gd: levels from 1 + 1 on, spaced repetition for every task, medals).
func rest_question() -> Dictionary:
	math_record()
	return G.math.question(G.learn_record(), G.rng, float(G.settings.get("restTimerScale", 1.0)))

## Remembers how a Rest sum went and says what to show (see math_engine.result).
func rest_result(q: Dictionary, right: bool, fast: bool) -> Dictionary:
	var fb: Dictionary = G.math.result(G.learn_record(), q, right, fast, G.rng)
	after_rest_answer(right, fast)
	return fb

## After every Rest answer (the number pad asks and remembers by itself): save, count quick ones for the perks.
func after_rest_answer(right: bool, fast: bool) -> void:
	G.save_learning()
	if right and fast: G.S["stats"]["rest_quick"] = int(G.S["stats"].get("rest_quick", 0)) + 1
	G.rewards.check_perks()

## The level of a Rest task for the window (see math_engine.level_info).
func arith_info(level_id := "") -> Dictionary:
	return G.math.level_info(G.learn_record(), level_id)

## fast = answered before the Rest timer ran out (settings.json restTimerSeconds); slow answers give restSlowShare of it.
func rest_correct(fast := true) -> float:
	var before := float(G.S["energy"])
	var gain := rest_per_answer() * (1.0 if fast else float(G.settings.get("restSlowShare", 0.5)))
	G.S["energy"] = minf(energy_max(), before + gain)
	G.S["stats"]["rest"] = int(G.S["stats"]["rest"]) + 1
	G.rewards.job_progress("rest", "", 1.0)
	G.changed.emit()
	return float(G.S["energy"]) - before
