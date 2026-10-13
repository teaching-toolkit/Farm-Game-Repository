extends RefCounted
class_name FarmAnimals
## Animals: buying, feeding, collecting (eggs, milk, wool, honey) and muck.

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

func feed_needs(aid: String) -> Dictionary:
	var n = G.nodes[aid]
	var a := animal(aid)
	var out := {}
	for k in n.get("feed", {}):
		out[k] = float(n["feed"][k]) * int(a["count"]) * G.m("feed:" + aid)
	var w := float(n.get("feedWater", 0)) * int(a["count"]) * G.m("water:animal")
	if w > 0.0: out["water"] = w
	out["energy"] = G.needs.ecost("animal", float(n.get("collectEnergy", 1)) * int(a["count"]))
	return out

func collect_animal(aid: String) -> bool:
	var n = G.nodes[aid]
	var a := animal(aid)
	if int(a["count"]) < 1: return false
	if G.S["step"] < int(a["ready"]): G.say(tr("%s needs a little time. Answer a Time Quiz question.") % n["name"]); return false
	if n.get("needsFlowers", false) and not has_flowers():
		G.say(tr("🐝 The bees need flowers: grow clover, sunflowers, flax, berries, herbs or fruit trees.")); return false
	var need := feed_needs(aid)
	var miss := G.pace.missing_cost(need)
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %s" % [G.iemoji(x["key"]), G.iname(x["key"]) if x["key"] != "energy" and x["key"] != "water" else x["key"]])
		G.say(tr("%s need %s.") % [n["name"], ", ".join(parts)]); return false
	G.pace.pay(need)
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
	G.crafting.wear_polish("use:animal")
	G.save_game(); G.changed.emit()
	return true

func muck_out(aid: String) -> bool:
	var a := animal(aid)
	var mk := float(a["muck"])
	if mk < 0.5: G.say(tr("Already clean.")); return false
	var mu = G.meta.get("muck", {})
	var e := G.needs.ecost("animal", mk * float(mu.get("energyPerMuck", 0.5)))
	if G.S["energy"] + 0.001 < e: G.say(tr("⚡ Too tired to muck out. Rest a little.")); return false
	G.S["energy"] -= e
	a["muck"] = 0.0
	var got := G.inventory.add_item("manure", mk * float(mu.get("manurePerMuck", 1)))
	G.say(tr("💩 Mucked out: +%d manure for the compost.") % G.down(got))
	G.save_game(); G.changed.emit()
	return true
