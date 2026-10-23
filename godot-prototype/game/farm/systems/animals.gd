extends RefCounted
class_name FarmAnimals
## Animals: buying, feeding, collecting (eggs, milk, wool, honey) and muck. Collecting and mucking out are chores of the actions system.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"animals": {}}

# ------------------------------------------------------------------ animals & muck

func animal_key(aid: String) -> String:
	return aid.replace("animal_", "")

func animal_cap(aid: String) -> int:
	return int(round(G.g("cap_" + animal_key(aid), 0.0)))

func animal(aid: String) -> Dictionary:
	if not G.S["animals"].has(aid): G.S["animals"][aid] = {"count": 0, "ready": 0, "muck": 0.0}
	return G.S["animals"][aid]

func animal_price(aid: String) -> Dictionary:
	var out := {}
	var pr: Dictionary = G.nodes[aid].get("price", {})
	for k in pr: out[k] = float(pr[k])
	return out

func buy_animal(aid: String) -> bool:
	var n = G.nodes[aid]
	if not G.progression.missing_reqs(aid).is_empty(): G.say("🔒 " + ", ".join(G.progression.missing_reqs(aid))); return false
	var a := animal(aid)
	if int(a["count"]) >= animal_cap(aid): G.say(tr("🏠 No room for more %s. Build a bigger home for them.") % n["name"]); return false
	if not G.pace.pay(animal_price(aid)): G.say(tr("🪙 Not enough to buy ") + n["name"]); return false
	a["count"] = int(a["count"]) + 1
	if int(a["count"]) == 1: a["ready"] = G.S["step"]
	if not G.done(aid): G.progression.finish_unlock(aid, false)
	else:
		G.say(tr("%s One more %s!") % [n.get("emoji", ""), n["name"]])
		G.save_game(); G.changed.emit()
	return true

func has_flowers() -> bool:
	for a in ["field", "orchard"]:
		for p in G.fields.area(a):
			if p["crop"] != "" and G.nodes[p["crop"]].get("flower", false): return true
	return false

func muck_factor(aid: String) -> float:
	var a := animal(aid)
	var mu = G.meta.get("muck", {})
	var th := float(mu.get("thresholdPerAnimal", 4)) * maxf(1.0, float(a["count"]))
	var mk := float(a["muck"])
	if mk > 2.0 * th: return float(mu.get("slowAboveDouble", 0.5))
	if mk > th: return float(mu.get("slowAbove", 0.75))
	return 1.0

## What the animals eat and drink for one collection, as written in the data (before the tools and upgrades that make it less) and after.
func feed_cost(aid: String) -> Dictionary:
	var n = G.nodes[aid]
	var cnt := int(animal(aid)["count"])
	var cost := {}
	var base := {}
	for k in n.get("feed", {}):
		base[k] = float(n["feed"][k]) * cnt
		cost[k] = float(n["feed"][k]) * cnt * G.m("feed:" + aid)
	var w := float(n.get("feedWater", 0)) * cnt
	if w > 0.0:
		base["water"] = w
		cost["water"] = w * G.m("water:animal")
	return {"cost": cost, "base": base}

## The chores of the animals in the actions system (rules/46-chores.json): their cost and the check are there, the effects are here.
## Both take the animal's id as args {"aid"}.
func register_chores() -> void:
	G.actions.register("collect_animal", _collect_effect, _collect_requires, _collect_amount, _collect_extra)
	G.actions.register("muck_out", _muck_out_effect, _muck_out_requires, _muck_amount)

func _collect_amount(_who, args: Dictionary) -> float:
	return float(G.nodes[args["aid"]].get("collectEnergy", 1)) * int(animal(args["aid"])["count"])

func _collect_extra(_who, args: Dictionary) -> Dictionary:
	return feed_cost(args["aid"])

func _collect_requires(_who, args: Dictionary) -> Array:
	var aid: String = args["aid"]
	var n = G.nodes[aid]
	var a := animal(aid)
	if int(a["count"]) < 1: return [{"key": "no_animals", "text": ""}]
	if G.S["step"] < int(a["ready"]): return [{"key": "not_ready", "text": tr("%s needs a little time. Answer a Time Quiz question.") % n["name"]}]
	if n.get("needsFlowers", false) and not has_flowers():
		return [{"key": "flowers", "text": tr("🐝 The bees need flowers: grow clover, sunflowers, flax, berries, herbs or fruit trees.")}]
	var miss := G.pace.missing_cost(feed_cost(aid)["cost"])
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %s" % [G.iemoji(x["key"]), G.iname(x["key"]) if x["key"] != "water" else x["key"]])
		return [{"key": "feed", "text": tr("%s need %s.") % [n["name"], ", ".join(parts)]}]
	return []

func _collect_effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var aid: String = args["aid"]
	var n = G.nodes[aid]
	var a := animal(aid)
	var mf := muck_factor(aid)
	var got := []
	var arrived := {}
	for k in n.get("produces", {}):
		var q := float(n["produces"][k]) * int(a["count"]) * G.m("out:" + aid) * float(G.seasons.smod("out", {}).get(aid, 1.0)) * mf
		if k == "egg" and G.rewards.roll(G.rewards.luck_event("double_yolk")): q += 1.0; G.say(tr("🥚 A double-yolk egg!"))
		if k == "honeycomb" and G.rewards.roll(G.rewards.luck_event("honey_flow")): q += 1.0; G.say(tr("🍯 A honey flow: extra comb!"))
		if k == "wool" and G.rewards.roll(G.rewards.luck_event("thick_fleece")): q += 1.0; G.say(tr("🧶 An extra-thick fleece!"))
		q = G.inventory.add_item(k, q, true)
		arrived[k] = q
		if q >= 0.5: got.append("%s%d" % [G.iemoji(k), G.down(q)])
	a["muck"] = float(a["muck"]) + float(n.get("muck", 0.0)) * int(a["count"]) * G.m("muck") * G.m("muck:" + aid)
	a["ready"] = G.S["step"] + int(n.get("cooldown", 1))
	var msg := tr("%s Collected: %s") % [n.get("emoji", ""), " ".join(got) if got.size() > 0 else tr("a little")]
	if mf < 1.0: msg += tr("  (the pen is mucky — muck it out!)")
	G.say(msg)
	G.inventory.emit_gained("animal:" + aid, arrived)
	G.rewards.job_progress("collect", aid, 1.0)
	return {"gained": arrived}

func _muck_amount(_who, args: Dictionary) -> float:
	return float(animal(args["aid"])["muck"])

func _muck_out_requires(_who, args: Dictionary) -> Array:
	if float(animal(args["aid"])["muck"]) < 0.5: return [{"key": "clean", "text": tr("Already clean.")}]
	return []

func _muck_out_effect(_who, args: Dictionary, _cost: Dictionary) -> Dictionary:
	var a := animal(args["aid"])
	var mk := float(a["muck"])
	var mu = G.meta.get("muck", {})
	a["muck"] = 0.0
	var got := G.inventory.add_item("manure", mk * float(mu.get("manurePerMuck", 1)))
	G.say(tr("💩 Mucked out: +%d manure for the compost.") % G.down(got))
	return {"gained": {"manure": got}}
