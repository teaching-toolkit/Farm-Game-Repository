extends RefCounted
class_name FarmPets
## The pets' jobs (TODO S2). Level 1 is a pet's bonus from its node (always on). Level 2 opens when the next pet has come home: the child
## chooses one of the pet's jobs on the job board, and the pet does it once every question. A job that cannot run just waits.
## What happened goes into the step's report (info["pet_acts"]) for the farm to show. Data: data/farm/rules/54-pets.json.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"pets": {"job": {}, "acc": {}, "last": {}, "when": {}, "second": {}}}

func data() -> Dictionary:
	return G.meta.get("pets", {})

## The jobs a pet can do (level 2).
func jobs_of(pid: String) -> Array:
	return data().get("jobs", {}).get(pid, [])

func job(pid: String, jid: String) -> Dictionary:
	for j in jobs_of(pid):
		if j["id"] == jid: return j
	return {}

## 0 = not home, 1 = its bonus, 2 = it also does a job of the child's choice, 3 = with a WHEN card, 4 = with a second rule.
## A pet's level is 1 + the pets that came home after it; when the last one is home (free play) every pet is level 4.
func level(pid: String) -> int:
	if not G.done(pid): return 0
	if jobs_of(pid).is_empty(): return 1
	if free_play(): return 4
	var i := G.pet_ids.find(pid)
	var after := 0
	for j in range(i + 1, G.pet_ids.size()):
		if G.done(G.pet_ids[j]): after += 1
	return clampi(1 + after, 1, 4)

## The story is over (the last pet is home): the pets' job boards are fully open.
func free_play() -> bool:
	return not G.pet_ids.is_empty() and G.done(G.pet_ids[G.pet_ids.size() - 1])

# ------------------------------------------------------------------ WHEN cards and the second rule (levels 3 and 4)

func whens() -> Dictionary:
	return data().get("whens", {})

func allowed_whens(pid: String) -> Array:
	return data().get("allowedWhens", {}).get(pid, [])

## The WHEN of rule 0 (the first) or rule 1 (the second): {"card", "n"}, or {} for always.
func when_of(pid: String, rule: int) -> Dictionary:
	if rule == 0: return G.S["pets"]["when"].get(pid, {})
	return (G.S["pets"]["second"].get(pid, {}) as Dictionary).get("when", {})

func second_job(pid: String) -> String:
	var j := str((G.S["pets"]["second"].get(pid, {}) as Dictionary).get("job", ""))
	return j if not job(pid, j).is_empty() else (str(jobs_of(pid)[1]["id"]) if jobs_of(pid).size() > 1 else "")

## Sets a rule's WHEN: card "" = always; n is kept inside the card's range.
func set_when(pid: String, rule: int, card: String, n := -1.0) -> bool:
	if level(pid) < (3 if rule == 0 else 4): return false
	var w := {}
	if card != "":
		if not allowed_whens(pid).has(card): return false
		var c: Dictionary = whens()[card]
		var cur := float(when_of(pid, rule).get("n", c.get("default", 1))) if when_of(pid, rule).get("card", "") == card else float(c.get("default", 1))
		w = {"card": card, "n": clampf(cur if n < 0.0 else n, float(c.get("min", 0)), float(c.get("max", 99)))}
	if rule == 0: G.S["pets"]["when"][pid] = w
	else:
		var sec: Dictionary = G.S["pets"]["second"].get(pid, {})
		sec["when"] = w
		if not sec.has("job"): sec["job"] = second_job(pid)
		G.S["pets"]["second"][pid] = sec
	G.save_game(); G.changed.emit()
	return true

func set_second_job(pid: String, jid: String) -> bool:
	if level(pid) < 4 or job(pid, jid).is_empty(): return false
	var sec: Dictionary = G.S["pets"]["second"].get(pid, {})
	sec["job"] = jid
	G.S["pets"]["second"][pid] = sec
	G.save_game(); G.changed.emit()
	return true

## Does a WHEN hold now? No card means always.
func holds(w: Dictionary) -> bool:
	if w.is_empty(): return true
	var c: Dictionary = whens().get(str(w.get("card", "")), {})
	if c.is_empty(): return true
	var v := 0.0
	if c.has("item"): v = G.inventory.count(str(c["item"]))
	else:
		match str(c.get("stat", "")):
			"weeds_max":
				for i in range(mini(G.progression.plots(), G.S["patches"].size())): v = maxf(v, float(G.S["patches"][i]["weeds"]))
			"empty_patches":
				for i in range(mini(G.progression.plots(), G.S["patches"].size())):
					if G.S["patches"][i]["crop"] == "": v += 1.0
			"water": v = float(G.S["water"])
			"pests": v = float(G.S["pests"])
	return v >= float(w["n"]) - 0.0001 if str(c.get("op", ">=")) == ">=" else v < float(w["n"]) - 0.0001

## The job it does now: the child's choice, or the first one.
func job_id(pid: String) -> String:
	var jobs := jobs_of(pid)
	if jobs.is_empty(): return ""
	var c := str(G.S["pets"]["job"].get(pid, ""))
	return c if not job(pid, c).is_empty() else str(jobs[0]["id"])

func choose(pid: String, jid: String) -> bool:
	if level(pid) < 2 or job(pid, jid).is_empty(): return false
	G.S["pets"]["job"][pid] = jid
	G.save_game(); G.changed.emit()
	return true

## What it did in the last question: {"job", "ok", "why"} or {}.
func last(pid: String) -> Dictionary:
	return G.S["pets"]["last"].get(pid, {})

# ------------------------------------------------------------------ one question

func step(info: Dictionary) -> void:
	var acts := []
	for pid in G.pet_ids:
		var lv := level(pid)
		if lv >= 2:
			var a := {}
			if holds(when_of(pid, 0) if lv >= 3 else {}): a = _work(pid, job(pid, job_id(pid)))
			elif lv >= 4 and second_job(pid) != "" and holds(when_of(pid, 1)): a = _work(pid, job(pid, second_job(pid)))
			else: G.S["pets"]["last"][pid] = {"job": job_id(pid), "ok": false, "why": "wait"}
			if not a.is_empty(): acts.append(a)
		elif lv >= 1:
			var f: Dictionary = data().get("first", {}).get(pid, {})
			if not f.is_empty() and int(G.S["step"]) % int(f.get("every", 1)) == 0:
				acts.append({"pet": pid, "emoji": f["emoji"], "ok": true, "place": f["place"], "first": true})
	if not acts.is_empty(): info["pet_acts"] = acts

func _work(pid: String, j: Dictionary) -> Dictionary:
	var act := {"pet": pid, "emoji": j.get("emoji", "🐾"), "ok": false, "why": "idle", "job": j["id"]}
	match str(j.get("kind", "")):
		"weeds", "stones":
			var key := "weeds" if j["kind"] == "weeds" else "stones"
			var best := -1
			var most := 0.5
			for i in range(mini(G.progression.plots(), G.S["patches"].size())):
				if float(G.S["patches"][i][key]) >= most: most = float(G.S["patches"][i][key]); best = i
			if best >= 0:
				var p: Dictionary = G.S["patches"][best]
				var n := minf(float(p[key]), float(j.get("amount", 1)))
				if key == "stones":
					var got := G.inventory.add_item("stone", n, true)
					if got < n - 0.001 and got <= 0.0: act["why"] = "full"; return _note(pid, act)
				p[key] = float(p[key]) - n
				act["ok"] = true; act["area"] = "field"; act["idx"] = best
		"pests":
			if float(G.S["pests"]) >= 0.5:
				G.S["pests"] = maxf(0.0, float(G.S["pests"]) - float(j.get("amount", 1)))
				act["ok"] = true; act["place"] = "field"
		"water":
			var cap := G.needs.water_cap()
			if float(G.S["water"]) < cap - 0.01:
				G.S["water"] = minf(cap, float(G.S["water"]) + float(j.get("amount", 1)))
				act["ok"] = true; act["place"] = "water"
		"makes":
			var acc: Dictionary = G.S["pets"]["acc"]
			var key2 := pid + ":" + str(j["id"])
			acc[key2] = float(acc.get(key2, 0.0)) + float(j.get("rate", 1))
			act["place"] = "spot:pets"
			if float(acc[key2]) >= 1.0:
				var whole := floorf(float(acc[key2]))
				var got2 := G.inventory.add_item(str(j["item"]), whole, true)
				if got2 > 0.0: acc[key2] = float(acc[key2]) - got2; act["ok"] = true
				else: act["why"] = "full"
			else:
				return {}      # still collecting: nothing to show this question
	return _note(pid, act)

func _note(pid: String, act: Dictionary) -> Dictionary:
	G.S["pets"]["last"][pid] = {"job": act.get("job", ""), "ok": act["ok"], "why": act.get("why", "")}
	if not act["ok"]: act["emoji"] = "📦" if act.get("why", "") == "full" else "💤"
	return act
