extends RefCounted
class_name FarmProgression
## What can be done when: costs and requirements of nodes, the steps of a node, unlocking, helpers attached to stations,
## clearing jobs that open patches early, which patches can be planted.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"unlocked": {}, "attach": {}, "step_ready": {}, "open_early": {}, "early_patches": {}, "pet_names": {}}

# ------------------------------------------------------------------ energy & costs

func node_cat(id: String) -> String:
	var n = G.nodes[id]
	return str(n.get("cat", G.DEFAULT_CAT.get(n["type"], "build")))

func plots() -> int:
	var n := int(round(G.g("plots", 0.0)))
	# clearing jobs past their openAfter step: their patches can be planted already
	for id in G.S.get("open_early", {}):
		if G.nodes.has(id) and not G.satisfied(id): n += int(G.nodes[id].get("effects", {}).get("add", {}).get("plots", 0))
	return n

## A clearing job reached its openAfter step: its patches can be planted, but still have weeds and stones on them
## and give less (quality); the remaining steps make them better.
func _open_early(id: String) -> void:
	var before := plots()
	G.S["open_early"][id] = true
	G.fields.ensure_areas()
	var idx := []
	for i in range(before, mini(plots(), G.S["patches"].size())):
		var p = G.S["patches"][i]
		p["weeds"] = 3.0; p["stones"] = 2.0; p["quality"] = float(G.meta.get("yield", {}).get("earlyQuality", 0.85))
		idx.append(i)
	G.S["early_patches"][id] = idx
	G.say(tr("🌱 %d new patches can be planted now! Clearing them more makes them better.") % idx.size())

func _improve_early(id: String, done_steps: int, total: int) -> void:
	var oa := int(G.nodes[id].get("openAfter", 0))
	var r := clampf(float(total - done_steps) / maxf(1.0, float(total - oa)), 0.0, 1.0)   # how much is still to do
	var q0 := float(G.meta.get("yield", {}).get("earlyQuality", 0.85))
	for i in G.S["early_patches"].get(id, []):
		var p = G.S["patches"][int(i)]
		p["quality"] = maxf(float(p.get("quality", 1.0)), lerpf(1.0, q0, r))
		p["weeds"] = minf(float(p["weeds"]), roundf(3.0 * r))
		p["stones"] = minf(float(p["stones"]), roundf(2.0 * r))

## Nodes done in steps ("steps": [{name, emoji, cost, gives}, …]): clearing land or ruins takes several taps.
## Questions still to wait before the next step of a building can start (the mortar dries, the wood settles).
func step_wait_left(id: String) -> int:
	return maxi(0, int(G.S.get("step_ready", {}).get(id, 0)) - int(G.S["step"]))

func steps_of(id: String) -> Array:
	return G.nodes[id].get("steps", [])

func step_index(id: String) -> int:
	return int(G.S.get("step_progress", {}).get(id, 0))

func raw_cost(id: String) -> Dictionary:
	var n = G.nodes[id]
	var st: Array = n.get("steps", [])
	if st.size() > 0: return G.pace.flexed(id, st[mini(step_index(id), st.size() - 1)].get("cost", {}))
	if n["type"] == "animal": return n.get("price", {})
	return G.pace.flexed(id, n.get("cost", {}))

# ------------------------------------------------------------------ requirements

func cards_learned() -> int:
	var n := 0
	for id in G.card_ids:
		if G.done(id): n += 1
	return n

func books_owned() -> int:
	var n := 0
	for id in G.S["unlocked"]:
		if G.nodes.has(id) and G.nodes[id]["type"] == "book": n += 1
	return n

func missing_reqs(id: String) -> Array:
	var n = G.nodes[id]
	var miss := []
	for r in n.get("requires", []):
		if not G.satisfied(r): miss.append(G.nodes[r]["emoji"] + " " + G.nodes[r]["name"] if G.nodes.has(r) else r)
	if n.has("requiresCards") and cards_learned() < int(n["requiresCards"]):
		miss.append(tr("📚 %d cards learned (%d so far)") % [int(n["requiresCards"]), cards_learned()])
	for k in n.get("discover", []):
		if not G.S["seen"].has(k): miss.append(tr("🔍 find %s %s first") % [G.iemoji(k), G.iname(k)])
	if n["type"] == "book" and books_owned() >= int(round(G.g("bookSlots", 1.0))):
		miss.append(tr("📦 room in the library (holds %d books)") % int(round(G.g("bookSlots", 1.0))))
	if n.has("attach") and n["type"] == "helper":
		pass
	return miss

func is_open(id: String) -> bool:
	return not G.done(id) and not G.satisfied(id) and missing_reqs(id).is_empty()

func is_auto(id: String) -> bool:
	var n = G.nodes[id]
	if n["type"] in G.NOT_AUTO: return false
	return not n.has("cost") or (n["cost"] as Dictionary).is_empty()

func auto_unlocks(_info := {}) -> void:
	var guard := 0
	var again := true
	while again and guard < 20:
		again = false; guard += 1
		for id in G.nodes:
			if G.done(id) or G.satisfied(id) or not is_auto(id): continue
			if not missing_reqs(id).is_empty(): continue
			finish_unlock(id, true)
			again = true

## Build, buy, deliver, learn — anything with a cost.
func can_unlock(id: String) -> Dictionary:
	if G.done(id): return {"ok": false, "why": tr("already done")}
	var mr := missing_reqs(id)
	if not mr.is_empty(): return {"ok": false, "why": "needs " + ", ".join(mr)}
	if G.nodes[id]["type"] == "delivery":      # handed over in the village, from the bag
		if not G.trip.at_square(): return {"ok": false, "why": tr("Deliveries are handed over in the village.")}
		if not G.trip.bag_covers(G.pace.node_cost(id)): return {"ok": false, "why": tr("It is not all in your bag.")}
	if step_wait_left(id) > 0: return {"ok": false, "why": "wait", "wait": step_wait_left(id)}
	var mc := G.pace.missing_cost(G.pace.node_cost(id))
	if not mc.is_empty():
		var parts := []
		for x in mc: parts.append(tr("🏮 the Lord's share first") if x["key"] == "lord" else "%s %d more" % [G.iemoji(x["key"]), G.up(float(x["need"]) - float(x["have"]))])
		return {"ok": false, "why": "missing " + ", ".join(parts)}
	return {"ok": true, "why": ""}

func patch_progress(id: String) -> int:
	return int(G.S.get("patch_progress", {}).get(id, 0))

func unlock(id: String) -> bool:
	var ck := can_unlock(id)
	if not ck["ok"]:
		G.say("🔒 " + G.nodes[id]["name"] + ": " + ck["why"])
		return false
	if G.nodes[id].get("perPatch", false):
		# upgrade patch by patch: pay for as many patches as you can afford now
		if not G.S.has("patch_progress"): G.S["patch_progress"] = {}
		var done_n := patch_progress(id)
		var paid := 0
		while done_n < plots() and G.pace.missing_cost(G.pace.node_cost(id)).is_empty():
			G.pace.pay(G.pace.node_cost(id)); done_n += 1; paid += 1
		G.S["patch_progress"][id] = done_n
		if done_n < plots():
			G.say(tr("🟫 %s: %d of %d patches done.") % [G.nodes[id]["name"], done_n, plots()])
			G.crafting.wear_polish("use:field"); G.save_game(); G.changed.emit()
			return true
		finish_unlock(id, false)
		return true
	var st: Array = steps_of(id)
	if st.size() > 0:
		# one step at a time: pay it, get what it gives, and the node is done after the last one
		var i := step_index(id)
		if step_wait_left(id) > 0:
			G.say((tr("⏳ %s: the next step can start in %d question.") if step_wait_left(id) == 1 else tr("⏳ %s: the next step can start in %d questions.")) % [G.nodes[id]["name"], step_wait_left(id)])
			return false
		G.pace.pay(G.pace.node_cost(id))
		var got := {}
		for k in st[i].get("gives", {}): got[k] = G.inventory.add_item(k, float(st[i]["gives"][k]), true)
		if not G.S.has("step_progress"): G.S["step_progress"] = {}
		G.S["step_progress"][id] = i + 1
		G.inventory.emit_gained("node:" + id, got)
		G.crafting.wear_polish("use:" + node_cat(id))
		var oa := int(G.nodes[id].get("openAfter", 0))
		if oa > 0 and i + 1 == oa and i + 1 < st.size(): _open_early(id)
		elif oa > 0 and i + 1 > oa: _improve_early(id, i + 1, st.size())
		if int(st[i].get("wait", 0)) > 0 and i + 1 < st.size():
			if not G.S.has("step_ready"): G.S["step_ready"] = {}
			G.S["step_ready"][id] = int(G.S["step"]) + int(st[i]["wait"])
		if i + 1 < st.size():
			G.say("%s %s (%d/%d)" % [st[i].get("emoji", "✔"), st[i].get("name", G.nodes[id]["name"]), i + 1, st.size()])
			G.save_game(); G.changed.emit()
			return true
	else:
		var dcost: Dictionary = G.pace.node_cost(id)
		G.pace.pay(dcost)
		if G.nodes[id]["type"] == "delivery": G.trip.spend_from_bag(dcost)
	finish_unlock(id, false)
	return true

func finish_unlock(id: String, auto: bool) -> void:
	var n = G.nodes[id]
	G.S["unlocked"][id] = true
	G.S.get("open_early", {}).erase(id)
	for i in G.S.get("early_patches", {}).get(id, []):
		var p = G.S["patches"][int(i)]
		p["quality"] = maxf(float(p.get("quality", 1.0)), 1.0)
	G.S.get("early_patches", {}).erase(id)
	if not n.has("steps"):
		for k in n.get("gives", {}): G.inventory.add_item(k, float(n["gives"][k]))
	var big: bool = n["type"] in ["building", "station", "tool", "gear"] and not auto
	var helper: bool = n["type"] == "helper" and (not auto or n.get("gift", false) or id == "barn_cat")
	if big or helper: G.celebrate.emit(id)
	if n.has("attach"): G.S["attach"][n["attach"]] = id
	G.invalidate_caps()
	if not auto:
		var t: String = n["type"]
		G.say("%s %s %s" % ["✅", n.get("emoji", ""), n["name"]])
		if t == "pet":
			G.ask_name.emit(id, str(n.get("defaultName", tr("Buddy"))))
			G.rewards.offer_gift(G.rewards.news_text("pet", id.substr(4)))
		elif t == "sidequest":
			G.S["album"].append({"id": id, "text": n.get("reward", {}).get("picture", n["name"]), "emoji": n.get("emoji", "🖼️")})
			G.S["stats"]["sidequests"] = int(G.S["stats"]["sidequests"]) + 1
			var ls = G.meta.get("luck", {}).get("sources", {}).get("sidequest", [0.5, 30])
			G.rewards.add_luck(float(ls[0]), int(ls[1]) + int(G.g("luckDuration", 0.0)))
			G.say(tr("🖼️ New picture in your album! You feel lucky for a while. ☘️"))
			var fr: Dictionary = n.get("friend", {})
			if not fr.is_empty():
				G.say(tr("💌 %s %s is your friend now. Friends send postcards with a gift when they hear of your successes!") % [fr.get("emoji", ""), fr.get("name", "")])
			if n.has("perk"): G.rewards.give_perk(str(n["perk"]))
		elif id.begins_with("library_"):
			G.rewards.offer_gift(G.rewards.news_text("library"))
		if t == "sidequest" or t == "delivery": G.well.helped()
		if t in G.MAIN_TYPES:
			G.S["goals"] = int(G.S["goals"]) + 1
			if int(G.S["goals"]) % 12 == 0: G.rewards.offer_gift(G.rewards.news_text("goals"))
		if n.has("effects") and n["effects"].has("add") and n["effects"]["add"].has("plots"):
			G.fields.ensure_areas()
		G.rewards.check_acorns()
	G.fields.ensure_areas()
	if not auto:
		auto_unlocks()
		G.save_game()
		G.changed.emit()

func set_pet_name(pet_id: String, name: String) -> void:
	G.S["pet_names"][pet_id] = name if name.strip_edges() != "" else str(G.nodes[pet_id].get("defaultName", tr("Buddy")))
	G.save_game(); G.changed.emit()

func set_attach(station: String, helper_id: String) -> void:
	if not G.done(helper_id): return
	G.S["attach"][station] = helper_id
	G.invalidate_caps(); G.save_game(); G.changed.emit()
