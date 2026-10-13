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
	return {"pets": {"job": {}, "acc": {}, "last": {}}}

func data() -> Dictionary:
	return G.meta.get("pets", {})

## The jobs a pet can do (level 2).
func jobs_of(pid: String) -> Array:
	return data().get("jobs", {}).get(pid, [])

func job(pid: String, jid: String) -> Dictionary:
	for j in jobs_of(pid):
		if j["id"] == jid: return j
	return {}

## 0 = not home, 1 = its bonus, 2 = it also does a job of the child's choice.
func level(pid: String) -> int:
	if not G.done(pid): return 0
	var i := G.pet_ids.find(pid)
	if i >= 0 and i + 1 < G.pet_ids.size() and G.done(G.pet_ids[i + 1]) and not jobs_of(pid).is_empty(): return 2
	return 1

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
		if lv == 2:
			var a := _work(pid, job(pid, job_id(pid)))
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
