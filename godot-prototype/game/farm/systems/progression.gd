extends RefCounted
## Progression: costs, energy costs by kind of work, steps with waits, requirements, unlocking, polish (endless upgrades with diminishing returns). (Kit to be: progression.)
## Split out of game.gd in R4 (12 Oct 2026). Everything else of the game is reached through G, the front door
## (the Game autoload), which still answers to every function name, so callers did not change.

var G

func buff_mult() -> float:
	var b: Dictionary = G.S["buff"]
	if b.is_empty(): return 1.0
	if int(b.get("until", 0)) <= G.S["step"]: return 1.0
	return float(b.get("mult", 1.0))

func stars(station_root: String) -> int:
	var uses = int(G.S["practice"].get(station_root, 0))
	var n := 0
	for th in G.meta.get("practice", {}).get("thresholds", [10, 40, 120]):
		if uses >= int(th): n += 1
	return n

func ecost(cat: String, base: float, station_root := "") -> float:
	if base <= 0.0: return 0.0
	var c = base * G.m("energy:" + cat)
	if G.season() == "winter" and cat in ["craft", "textile", "smith", "wood"]:
		c *= float(G.smod("indoorEnergy", 1.0))
	if station_root != "":
		c *= pow(float(G.meta.get("practice", {}).get("energyPerStar", 0.95)), G.stars(station_root))
	return c * G.buff_mult()

func node_cat(id: String) -> String:
	var n = G.nodes[id]
	return str(n.get("cat", G.DEFAULT_CAT.get(n["type"], "build")))

func plots() -> int:
	var n = int(round(G.g("plots", 0.0)))
	# clearing jobs past their openAfter step: their patches can be planted already
	for id in G.S.get("open_early", {}):
		if G.nodes.has(id) and not G.satisfied(id): n += int(G.nodes[id].get("effects", {}).get("add", {}).get("plots", 0))
	return n

## A clearing job reached its openAfter step: its patches can be planted, but still have weeds and stones on them
## and give less (quality); the remaining steps make them better.
func _open_early(id: String) -> void:
	var before = G.plots()
	G.S["open_early"][id] = true
	G._ensure_areas()
	var idx := []
	for i in range(before, mini(G.plots(), G.S["patches"].size())):
		var p = G.S["patches"][i]
		p["weeds"] = 3.0; p["stones"] = 2.0; p["quality"] = float(G.meta.get("yield", {}).get("earlyQuality", 0.85))
		idx.append(i)
	G.S["early_patches"][id] = idx
	G.say(tr("🌱 %d new patches can be planted now! Clearing them more makes them better.") % idx.size())

func _improve_early(id: String, done_steps: int, total: int) -> void:
	var oa = int(G.nodes[id].get("openAfter", 0))
	var r := clampf(float(total - done_steps) / maxf(1.0, float(total - oa)), 0.0, 1.0)   # how much is still to do
	var q0 = float(G.meta.get("yield", {}).get("earlyQuality", 0.85))
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

func _raw_cost(id: String) -> Dictionary:
	var n = G.nodes[id]
	var st: Array = n.get("steps", [])
	if st.size() > 0: return G._flexed(id, st[mini(G.step_index(id), st.size() - 1)].get("cost", {}))
	if n["type"] == "animal": return n.get("price", {})
	return G._flexed(id, n.get("cost", {}))

## The cost of a node as {key: amount}, scaled for per-patch upgrades and energy upgrades.
## A node done in steps costs what its next step costs.
func node_cost(id: String) -> Dictionary:
	var raw: Dictionary = G._raw_cost(id)
	var mul := 1.0   # per-patch upgrades are paid one patch at a time (see unlock)
	var out := {}
	for k in raw:
		if k == "read": continue
		var v := float(raw[k]) * mul
		if k == "energy": v = G.ecost(G.node_cat(id), v)
		out[k] = v
	return out

## The cost before any upgrade, practice star, meal or season makes it cheaper (the cube bars show what is saved).
func node_cost_base(id: String) -> Dictionary:
	var raw: Dictionary = G._raw_cost(id)
	var out := {}
	for k in raw:
		if k != "read": out[k] = float(raw[k])
	return out

func missing_cost(c: Dictionary) -> Array:
	var miss := []
	for k in c:
		var need := float(c[k])
		var h = G.have(k)
		if h + 0.0001 < need:
			miss.append({"key": k, "need": need, "have": h})
	return miss

func pay(c: Dictionary) -> bool:
	if not G.missing_cost(c).is_empty(): return false
	for k in c:
		var v := float(c[k])
		if k == "energy": G.S["energy"] -= v
		elif k == "water": G.S["water"] -= v
		elif k == "coins": G.S["coins"] -= v
		else: G.take(k, v)
	return true

func cost_text(c: Dictionary) -> String:
	var parts := []
	for k in c:
		parts.append("%s%d" % [G.iemoji(k), G.up(float(c[k]))])
	return " ".join(parts)

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
	if n.has("requiresCards") and G.cards_learned() < int(n["requiresCards"]):
		miss.append(tr("📚 %d cards learned (%d so far)") % [int(n["requiresCards"]), G.cards_learned()])
	for k in n.get("discover", []):
		if not G.S["seen"].has(k): miss.append(tr("🔍 find %s %s first") % [G.iemoji(k), G.iname(k)])
	if n["type"] == "book" and G.books_owned() >= int(round(G.g("bookSlots", 1.0))):
		miss.append(tr("📦 room in the library (holds %d books)") % int(round(G.g("bookSlots", 1.0))))
	if n.has("attach") and n["type"] == "helper":
		pass
	return miss

func is_open(id: String) -> bool:
	return not G.done(id) and not G.satisfied(id) and G.missing_reqs(id).is_empty()

func is_auto(id: String) -> bool:
	var n = G.nodes[id]
	if n["type"] in G.NOT_AUTO: return false
	return not n.has("cost") or (n["cost"] as Dictionary).is_empty()

func _auto_unlocks() -> void:
	var guard := 0
	var again := true
	while again and guard < 20:
		again = false; guard += 1
		for id in G.nodes:
			if G.done(id) or G.satisfied(id) or not G.is_auto(id): continue
			if not G.missing_reqs(id).is_empty(): continue
			G._finish_unlock(id, true)
			again = true

## Build, buy, deliver, learn — anything with a cost.
func can_unlock(id: String) -> Dictionary:
	if G.done(id): return {"ok": false, "why": tr("already done")}
	var mr = G.missing_reqs(id)
	if not mr.is_empty(): return {"ok": false, "why": "needs " + ", ".join(mr)}
	if G.step_wait_left(id) > 0: return {"ok": false, "why": "wait", "wait": G.step_wait_left(id)}
	var mc = G.missing_cost(G.node_cost(id))
	if not mc.is_empty():
		var parts := []
		for x in mc: parts.append("%s %d more" % [G.iemoji(x["key"]), G.up(float(x["need"]) - float(x["have"]))])
		return {"ok": false, "why": "missing " + ", ".join(parts)}
	return {"ok": true, "why": ""}

func patch_progress(id: String) -> int:
	return int(G.S.get("patch_progress", {}).get(id, 0))

func unlock(id: String) -> bool:
	var ck = G.can_unlock(id)
	if not ck["ok"]:
		G.say("🔒 " + G.nodes[id]["name"] + ": " + ck["why"])
		return false
	if G.nodes[id].get("perPatch", false):
		# upgrade patch by patch: pay for as many patches as you can afford now
		if not G.S.has("patch_progress"): G.S["patch_progress"] = {}
		var done_n = G.patch_progress(id)
		var paid := 0
		while done_n < G.plots() and G.missing_cost(G.node_cost(id)).is_empty():
			G.pay(G.node_cost(id)); done_n += 1; paid += 1
		G.S["patch_progress"][id] = done_n
		if done_n < G.plots():
			G.say(tr("🟫 %s: %d of %d patches done.") % [G.nodes[id]["name"], done_n, G.plots()])
			G._wear("use:field"); G.save_game(); G.changed.emit()
			return true
		G._finish_unlock(id, false)
		return true
	var st: Array = G.steps_of(id)
	if st.size() > 0:
		# one step at a time: pay it, get what it gives, and the node is done after the last one
		var i = G.step_index(id)
		if G.step_wait_left(id) > 0:
			G.say((tr("⏳ %s: the next step can start in %d question.") if G.step_wait_left(id) == 1 else tr("⏳ %s: the next step can start in %d questions.")) % [G.nodes[id]["name"], G.step_wait_left(id)])
			return false
		G.pay(G.node_cost(id))
		var got := {}
		for k in st[i].get("gives", {}): got[k] = G.add_item(k, float(st[i]["gives"][k]), true)
		if not G.S.has("step_progress"): G.S["step_progress"] = {}
		G.S["step_progress"][id] = i + 1
		G._gained("node:" + id, got)
		G._wear("use:" + G.node_cat(id))
		var oa = int(G.nodes[id].get("openAfter", 0))
		if oa > 0 and i + 1 == oa and i + 1 < st.size(): G._open_early(id)
		elif oa > 0 and i + 1 > oa: G._improve_early(id, i + 1, st.size())
		if int(st[i].get("wait", 0)) > 0 and i + 1 < st.size():
			if not G.S.has("step_ready"): G.S["step_ready"] = {}
			G.S["step_ready"][id] = int(G.S["step"]) + int(st[i]["wait"])
		if i + 1 < st.size():
			G.say("%s %s (%d/%d)" % [st[i].get("emoji", "✔"), st[i].get("name", G.nodes[id]["name"]), i + 1, st.size()])
			G.save_game(); G.changed.emit()
			return true
	else:
		G.pay(G.node_cost(id))
	G._finish_unlock(id, false)
	return true

func _finish_unlock(id: String, auto: bool) -> void:
	var n = G.nodes[id]
	G.S["unlocked"][id] = true
	G.S.get("open_early", {}).erase(id)
	for i in G.S.get("early_patches", {}).get(id, []):
		var p = G.S["patches"][int(i)]
		p["quality"] = maxf(float(p.get("quality", 1.0)), 1.0)
	G.S.get("early_patches", {}).erase(id)
	if not n.has("steps"):
		for k in n.get("gives", {}): G.add_item(k, float(n["gives"][k]))
	var big: bool = n["type"] in ["building", "station", "tool", "gear"] and not auto
	var helper: bool = n["type"] == "helper" and (not auto or n.get("gift", false) or id == "barn_cat")
	if big or helper: G.celebrate.emit(id)
	if n.has("attach"): G.S["attach"][n["attach"]] = id
	G._dirty()
	if not auto:
		var t: String = n["type"]
		G.say("%s %s %s" % ["✅", n.get("emoji", ""), n["name"]])
		if t == "pet":
			G.ask_name.emit(id, str(n.get("defaultName", tr("Buddy"))))
			G._offer_gift(G._news("pet", id.substr(4)))
		elif t == "sidequest":
			G.S["album"].append({"id": id, "text": n.get("reward", {}).get("picture", n["name"]), "emoji": n.get("emoji", "🖼️")})
			G.S["stats"]["sidequests"] = int(G.S["stats"]["sidequests"]) + 1
			var ls = G.meta.get("luck", {}).get("sources", {}).get("sidequest", [0.5, 30])
			G.add_luck(float(ls[0]), int(ls[1]) + int(G.g("luckDuration", 0.0)))
			G.say(tr("🖼️ New picture in your album! You feel lucky for a while. ☘️"))
			var fr: Dictionary = n.get("friend", {})
			if not fr.is_empty():
				G.say(tr("💌 %s %s is your friend now. Friends send postcards with a gift when they hear of your successes!") % [fr.get("emoji", ""), fr.get("name", "")])
			if n.has("perk"): G.give_perk(str(n["perk"]))
		elif id.begins_with("library_"):
			G._offer_gift(G._news("library"))
		if t in G.MAIN_TYPES:
			G.S["goals"] = int(G.S["goals"]) + 1
			if int(G.S["goals"]) % 12 == 0: G._offer_gift(G._news("goals"))
		if n.has("effects") and n["effects"].has("add") and n["effects"]["add"].has("plots"):
			G._ensure_areas()
		G._check_acorns()
	G._ensure_areas()
	if not auto:
		G._auto_unlocks()
		G.save_game()
		G.changed.emit()

func set_pet_name(pet_id: String, name: String) -> void:
	G.S["pet_names"][pet_id] = name if name.strip_edges() != "" else str(G.nodes[pet_id].get("defaultName", tr("Buddy")))
	G.save_game(); G.changed.emit()

func set_attach(station: String, helper_id: String) -> void:
	if not G.done(helper_id): return
	G.S["attach"][station] = helper_id
	G._dirty(); G.save_game(); G.changed.emit()

func polish_level(pid: String) -> float:
	return float(G.S["polish"].get(pid, 0.0))

func polish_open(pid: String) -> bool:
	return G.satisfied(G.nodes[pid]["target"])

func polish_cost(pid: String) -> Dictionary:
	var f = 1.0 + floorf(G.polish_level(pid))
	var out := {}
	var raw: Dictionary = G.nodes[pid].get("cost", {})
	for k in raw:
		var v = float(raw[k]) * f
		if k == "energy": v = G.ecost("craft", v)
		out[k] = v
	return out

func polish_gain(pid: String, p: float) -> float:
	return 1.0 - pow(0.5, p)

func do_polish(pid: String) -> bool:
	if not G.polish_open(pid): return false
	var c = G.polish_cost(pid)
	var miss = G.missing_cost(c)
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %d more" % [G.iemoji(x["key"]), G.up(float(x["need"]) - float(x["have"]))])
		G.say(tr("Missing: ") + ", ".join(parts)); return false
	G.pay(c)
	# some polish also brings something in ("gives", growing like the cost): rooting out weeds gives plant fibre
	var f = 1.0 + floorf(G.polish_level(pid))
	var gv: Dictionary = G.nodes[pid].get("gives", {})
	var got := {}
	for k in gv: got[k] = G.add_item(k, float(gv[k]) * f, true)
	if not got.is_empty(): G._gained("node:" + pid, got)
	G.S["polish"][pid] = G.polish_level(pid) + 1.0
	G._dirty()
	var gtxt := []
	for k in got: gtxt.append("%s%d" % [G.iemoji(k), G.down(got[k])])
	G.say(tr("✨ %s (%d%% of the full effect now)%s") % [G.nodes[pid]["name"], int(round(G.polish_gain(pid, G.polish_level(pid)) * 100.0)), ("  +" + " ".join(gtxt)) if not gtxt.is_empty() else ""])
	G.S["unlocked"][pid] = true
	G.save_game(); G.changed.emit()
	return true

func _wear(kind: String) -> void:
	for pid in G.S["polish"].keys():
		var w = G.nodes[pid].get("wear", {})
		if w.get("per", "") != kind: continue
		G.S["polish"][pid] = maxf(0.0, G.polish_level(pid) - float(w.get("amount", 0.0)) * G.m("wear"))
	G._dirty()
