extends RefCounted
class_name FarmPets
## The pets' blessings and chores (TODO S2). Level 1 is a pet's bonus from its node (always on). Level 2 opens when the next pet has come home:
## the child chooses one of the pet's blessings or chores for its rule, and the pet does it once every question. What cannot run just waits.
## A pet's rule is a blessing (free, by its own effect) or a chore (one of the farmer's, at the farmer's cost): see GLOSSARY.md.
## The data lists both under `entries` (a chore has "kind": "chore"). Save keys keep their old name `job` (pets.job, pets.second.job,
## pets.last.job) so that old saves load.
## What happened goes into the step's report (info["pet_acts"]) for the farm to show. Data: data/farm/rules/54-pets.json.

const Spots = preload("res://game/farm/spots.gd")   # which place a node belongs to (for chores_of)

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"pets": {"job": {}, "acc": {}, "last": {}, "when": {}, "second": {}}}

func data() -> Dictionary:
	return G.meta.get("pets", {})

## The blessings a pet can do (level 2) that the child is offered. A rule is a blessing or a chore: the chores are not in this list
## (chores_of is the window's "Helps with" group). An entry with "hidden": true is built but not offered (see entry).
func blessings_of(pid: String) -> Array:
	var out := []
	for j in data().get("entries", {}).get(pid, []):
		if str(j.get("kind", "")) != "chore" and not bool(j.get("hidden", false)): out.append(j)
	return out

## The chores of a pet (kind "chore") whose place is built: the ones the pet's window offers as "Helps with".
## A chore with `needs` (a place id of data/farm/places.json) waits until that place is built; one without it is always there.
func chores_of(pid: String) -> Array:
	var out := []
	for j in data().get("entries", {}).get(pid, []):
		if str(j.get("kind", "")) == "chore" and (not j.has("needs") or _built(str(j["needs"]))): out.append(j)
	return out

## Is a place built: a building or an animal that belongs to it (the map's own rule, game/farm/spots.gd) is done.
func _built(place: String) -> bool:
	for id in Spots.nodes_at(G, place):
		if G.done(id) and str(G.nodes[id].get("type", "")) in ["building", "animal"]: return true
	return false

## A blessing or a chore of a pet by its id, hidden ones too (a rule can hold any of them; only the lists the child sees leave some out).
func entry(pid: String, eid: String) -> Dictionary:
	for j in data().get("entries", {}).get(pid, []):
		if j["id"] == eid: return j
	return {}

## 0 = not home, 1 = its bonus, 2 = it also does a blessing or chore of the child's choice, 3 = with a WHEN card, 4 = with a second rule.
## A pet's level is 1 + the pets that came home after it; when the last one is home (free play) every pet is level 4.
func level(pid: String) -> int:
	if not G.done(pid): return 0
	if blessings_of(pid).is_empty(): return 1
	if free_play(): return 4
	var i := G.pet_ids.find(pid)
	var after := 0
	for j in range(i + 1, G.pet_ids.size()):
		if G.done(G.pet_ids[j]): after += 1
	return clampi(1 + after, 1, 4)

## The story is over (the last pet is home): the pets' rules are fully open.
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

## The id of the blessing or chore in its second rule (level 4): the child's choice, or its second blessing.
func second_chosen(pid: String) -> String:
	var j := str((G.S["pets"]["second"].get(pid, {}) as Dictionary).get("job", ""))
	return j if not entry(pid, j).is_empty() else (str(blessings_of(pid)[1]["id"]) if blessings_of(pid).size() > 1 else "")

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
		if not sec.has("job"): sec["job"] = second_chosen(pid)
		G.S["pets"]["second"][pid] = sec
	G.save_game(); G.changed.emit()
	return true

## Puts a blessing or a chore into the pet's second rule (level 4), like choose does for the first.
func choose_second(pid: String, eid: String) -> bool:
	if level(pid) < 4 or not _can_set(pid, eid): return false
	var sec: Dictionary = G.S["pets"]["second"].get(pid, {})
	sec["job"] = eid
	G.S["pets"]["second"][pid] = sec
	if not _follow_when(pid, 1, eid): G.save_game(); G.changed.emit()
	return true

## Can this blessing or chore be set as a rule: it exists, and a chore's place is built (chores_of lists it).
func _can_set(pid: String, eid: String) -> bool:
	var j := entry(pid, eid)
	if j.is_empty(): return false
	if str(j.get("kind", "")) != "chore": return true
	for c in chores_of(pid):
		if c["id"] == eid: return true
	return false

## The WHEN of a rule follows the blessing or chore the child has just put in it (only where the rule has a WHEN card: rule 0 from level 3, rule 1 at
## level 4). A chore with no WHEN gets the `energy` card at its default, so it never drains the farmer (a WHEN the child set stays). A
## blessing frees the rule from that default energy WHEN (one the child set to another number stays). True when it saved (set_when does).
func _follow_when(pid: String, rule: int, eid: String) -> bool:
	if level(pid) < (3 if rule == 0 else 4) or not allowed_whens(pid).has("energy"): return false
	var w := when_of(pid, rule)
	var c: Dictionary = whens().get("energy", {})
	if c.is_empty(): return false
	if str(entry(pid, eid).get("kind", "")) == "chore": return w.is_empty() and set_when(pid, rule, "energy")
	return w.get("card", "") == "energy" and is_equal_approx(float(w.get("n", -1)), clampf(float(c.get("default", 1)), float(c.get("min", 0)), float(c.get("max", 99)))) and set_when(pid, rule, "")

## Does a WHEN hold now? No card means always. The card's condition (rules/54-pets.json, `when` with `{n}`) gets the child's number,
## less a hair (0.0001), so a store amount or water a hair under a whole number counts as that number, as it always has.
func holds(w: Dictionary) -> bool:
	if w.is_empty(): return true
	var c: Dictionary = whens().get(str(w.get("card", "")), {})
	if c.is_empty(): return true
	return G.conditions.holds(card_condition(c, float(w["n"]) - 0.0001))

## A WHEN card's condition with its number filled in.
static func card_condition(c: Dictionary, n: float) -> String:
	return str(c.get("when", "")).replace("{n}", str(n))

## "≥" or "<": how the card compares (for its label).
static func card_sign(c: Dictionary) -> String:
	return "<" if str(c.get("when", "")).contains("<") else "≥"

## The id of the blessing or chore in its first rule now: the child's choice, or its first blessing.
func chosen(pid: String) -> String:
	var blessings := blessings_of(pid)
	if blessings.is_empty(): return ""
	var c := str(G.S["pets"]["job"].get(pid, ""))      # the save key keeps its old name `job`
	return c if not entry(pid, c).is_empty() else str(blessings[0]["id"])

## Puts a blessing or a chore into the pet's first rule. False below level 2, for one it does not have, and for a chore whose place is not built.
func choose(pid: String, eid: String) -> bool:
	if level(pid) < 2 or not _can_set(pid, eid): return false
	G.S["pets"]["job"][pid] = eid
	if not _follow_when(pid, 0, eid): G.save_game(); G.changed.emit()
	return true

## What it did in the last question: {"job", "ok", "why"} or {} ("job" is the saved key of the entry's id, kept so old saves load).
func last(pid: String) -> Dictionary:
	return G.S["pets"]["last"].get(pid, {})

# ------------------------------------------------------------------ one question

func step(info: Dictionary) -> void:
	var acts := []
	for pid in G.pet_ids:
		var lv := level(pid)
		if lv >= 2:
			var a := {}
			if holds(when_of(pid, 0) if lv >= 3 else {}): a = _work(pid, entry(pid, chosen(pid)))
			elif lv >= 4 and second_chosen(pid) != "" and holds(when_of(pid, 1)): a = _work(pid, entry(pid, second_chosen(pid)))
			else: G.S["pets"]["last"][pid] = {"job": chosen(pid), "ok": false, "why": "wait"}
			if not a.is_empty(): acts.append(a)
		elif lv >= 1:
			var f: Dictionary = data().get("first", {}).get(pid, {})
			if not f.is_empty() and int(G.S["step"]) % int(f.get("every", 1)) == 0:
				acts.append({"pet": pid, "emoji": f["emoji"], "ok": true, "place": f["place"], "first": true})
	if not acts.is_empty(): info["pet_acts"] = acts

## Does one blessing or chore (entry j) of a pet now, and returns what happened for the farm to show (see step).
func _work(pid: String, j: Dictionary) -> Dictionary:
	var act := {"pet": pid, "emoji": j.get("emoji", "🐾"), "ok": false, "why": "idle", "entry": j["id"]}
	var rest: Dictionary = G.nature.pause_of(pid, str(j["id"]))      # N5: over-used woods: this job rests until they are back
	var was_resting: bool = str(last(pid).get("why", "")) == "rest" and str(last(pid).get("job", "")) == str(j["id"])
	if not rest.is_empty(): return _rest(pid, act, rest, was_resting)
	if was_resting:
		G.say(tr("%s %s is helping again. The forest has grown back.") % [G.nodes[pid].get("emoji", "🐾"), pet_name(pid)])
		G.S["pets"]["last"][pid] = {"job": j["id"], "ok": true, "why": ""}      # said once; a job that is still collecting (makes) writes no note
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
		"chore":
			return _note(pid, _work_chore(pid, j, act))
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

## An entry of kind "chore": the pet does one of the farmer's chores (the one place that knows how). The target is the owner's picker
## (G.actions.register_auto); the farmer pays the chore's effective cost, no moment is used and nothing is practised or worn.
## Nothing to do or no picker: waits idle. A requirement unmet (too tired, ...): waits and says which, nothing is spent.
func _work_chore(pid: String, j: Dictionary, act: Dictionary) -> Dictionary:
	var chore := str(j["chore"])
	var args: Dictionary = G.actions.auto_args(chore)
	if args.is_empty(): return act
	var who: FarmActions.Doer = G.actions.pet_doer(pid)
	var q: Dictionary = G.actions.check(chore, who, args)
	if not q["ok"]:
		var key := str(q["unmet"][0]["key"])
		act["why"] = "tired" if key == "energy" else key
		return act
	var rep: Dictionary = G.actions.run(chore, who, args)
	if not rep["done"]:
		act["why"] = "tired" if str(rep["failed"]) == "energy" else str(rep["failed"])
		return act
	act["ok"] = true; act["chore"] = chore
	if args.has("i"): act["area"] = "field"; act["idx"] = int(args["i"])
	elif args.has("aid"): act["place"] = "pen"; act["aid"] = str(args["aid"])      # a pen chore: the animal whose pen it is
	else: act["place"] = str(args.get("place", "field"))     # a chore with no patch (fetching water) says where the pet goes
	return act

## The over-used woods are resting (G.nature.pause_of): the Helper does not do this job, spends nothing, shows a 🌱 at its place, and says so
## once, when the rest begins. It stays and its other jobs go on (the rule is the child's: it is only waiting).
func _rest(pid: String, act: Dictionary, rest: Dictionary, was_resting: bool) -> Dictionary:
	act["why"] = "rest"
	if str(rest["place"]) != "": act["place"] = rest["place"]
	if not was_resting: G.say(tr("%s %s is taking a rest. The forest needs time to grow back.") % [G.nodes[pid].get("emoji", "🐾"), pet_name(pid)])
	return _note(pid, act)

## What the child calls the pet (the name chosen when it came home, else its own).
func pet_name(pid: String) -> String:
	return str(G.S["pet_names"].get(pid, G.nodes[pid].get("defaultName", "")))

func _note(pid: String, act: Dictionary) -> Dictionary:
	G.S["pets"]["last"][pid] = {"job": act.get("entry", ""), "ok": act["ok"], "why": act.get("why", "")}
	if not act["ok"]: act["emoji"] = {"full": "📦", "rest": "🌱"}.get(str(act.get("why", "")), "💤")
	return act
