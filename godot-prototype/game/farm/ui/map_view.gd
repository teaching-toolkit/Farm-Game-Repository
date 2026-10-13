extends RefCounted
## The map on the main screen: which picture each place shows, mysteries and ruins, things flying to the store, critters, the next-goal bar, scrolling.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")

var M
var G

## The newest thing built at a place (its picture and name stand for the place).
func _headline(sid: String) -> String:
	var best := ""
	if M.map.slots.has(sid):
		for id in Spots.ART_CHAINS.get(sid, []):
			if G.nodes.has(id) and G.done(id): best = id
	if best != "": return best
	# buildings and land stand for a place before its animals, and animals before its machines
	var rank := {"building": 3, "land": 3, "merchant": 3, "pet": 3, "animal": 2, "station": 1}
	var best_k := -1
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not rank.has(n["type"]): continue
		if not G.done(id) or G.superseded(id): continue
		var k: int = rank[n["type"]] * 100 + int(n.get("chapter", 1))
		if k >= best_k:
			best_k = k; best = id
	return best

func _spot_title(sid: String) -> String:
	if sid == "field":
		var names: Array = G.field_names()
		return names[clampi(M.field_idx, 0, names.size() - 1)] if names.size() > 0 else M.tr("Field")
	var info: Array = Spots.SPOTS.get(sid, [sid.capitalize(), "❔"]).duplicate()
	info[0] = M.tr(str(info[0]))
	var parent := Spots.parent_of(sid)
	if parent != "" and _built(parent): return info[0]      # a corner inside a building: "Bed & home", "Kitchen" …
	var head := _headline(sid)
	if head != "":
		var nm := str(G.nodes[head]["name"])
		if nm.length() <= 14: return nm
	return info[0]

func _spot_emoji(sid: String) -> String:
	var parent := Spots.parent_of(sid)
	if parent != "" and _built(parent): return Spots.SPOTS.get(sid, ["", "❔"])[1]
	var head := _headline(sid)
	if head != "": return str(G.nodes[head].get("emoji", Spots.SPOTS.get(sid, ["", "❔"])[1]))
	return Spots.SPOTS.get(sid, ["", "❔"])[1]

func _is_open(sid: String) -> bool:
	return _headline(sid) != "" or Spots.ALWAYS_OPEN.has(sid)

## Does a building with an inside stand yet (house, barn, workshop)?
func _built(parent: String) -> bool:
	if not Spots.INTERIORS.has(parent): return false
	var b: String = Spots.INTERIORS[parent]["built"]
	return G.nodes.has(b) and G.satisfied(b)

## The place on the map that stands for sid: a corner inside a building shows as the building once it stands.
func _map_sid(sid: String) -> String:
	var parent := Spots.parent_of(sid)
	if parent != "" and (_built(parent) or not M.map.slots.has(sid)): return parent
	return sid

## First picture name of keys that exists in folder ("" if none).
func _first_key(folder: String, keys: Array) -> String:
	for k in keys:
		if str(k) != "" and Art.tex(folder, str(k)) != null: return str(k)
	return ""

## Picture names to try for a place: the newest thing built, then the earlier upgrades (so an upgrade without
## its own picture keeps the last one), then the place itself.
func _art_keys(sid: String) -> Array:
	var head := _headline(sid)
	var keys := [head]
	if M.map.slots.has(sid):
		var chain: Array = Spots.ART_CHAINS.get(sid, [])
		var at := chain.find(head)
		for i in range(at - 1, -1, -1): keys.append(chain[i])
	keys.append(sid)
	return keys

func _update_slot(sid: String) -> void:
	var slot = M.map.slots[sid]
	# the house: the yard with tent, book box and campfire until the house stands, then the house alone
	if sid == "home":
		slot.visible = _built("home")
	elif Spots.parent_of(sid) == "home":
		slot.visible = not _built("home")
	elif sid == "field":
		slot.visible = false      # no field sign (J2): the whole field's jobs are at the bottom of every patch's sheet
	if not slot.visible: return
	slot.show_name = bool(G.settings.get("showPlaceNames", false))
	var open := _is_open(sid) or (Spots.INTERIORS.has(sid) and _built(sid))
	var key := ""
	var tex: Texture2D = null
	var st := ""
	var lk := {}
	if sid == "forest":
		st = "ghost"                                   # the trees are the place
	elif sid == "pond":
		var dug: bool = G.done("pond")
		key = "pond" if dug else "pond_wild"
		tex = Art.tex("plots", key)
		st = "pond"
		lk = {"wild": not dug}
	elif Spots.PENS.has(sid):
		st = "pen"                                     # a generic fence and ground; what is built stands inside
		lk = Spots.PENS[sid]
		slot.inside = _pen_inside(sid) if open else []
	elif open and _headline(sid).begins_with("ruins_"):
		st = "ruin"                                    # the old walls are cleared away: bare earth, ready to build on
		lk = {"material": Spots.RUINS.get(sid, "stone"), "cleared": true}
	elif open and _site_stage(sid) > 0 and _first_key("map", _art_keys(sid).filter(func(k): return G.nodes.has(k) and G.done(k))) == "":
		var stage := _site_stage(sid)                  # a building site: foundation, frame, walls … as the steps are done
		key = "site_%d" % stage
		tex = Art.first("construction", ["stage_%d" % stage, "stage_1"])
		if tex == null:
			st = "ruin"
			lk = {"material": "stone", "cleared": true}
	elif open:
		key = _first_key("map", _art_keys(sid))
		tex = Art.tex("map", key) if key != "" else null
		if key == "workbench" and Art.tex("map", "workbench_empty"):
			tex = Art.tex("map", "workbench_empty")        # the bench is empty; what has been made lies on it
	elif sid == "kitchen":
		st = "fireplace"                               # before the campfire: a few blackened rocks and a burnt log, no ruin
	elif Spots.RUINS.has(sid):
		st = "ruin"                                    # what is left of it: broken walls, rubble — less as it is cleared
		lk = {"material": Spots.RUINS[sid]}
		var rid := "ruins_" + sid
		if G.nodes.has(rid):
			lk["progress"] = float(G.step_index(rid)) / float(maxi(1, G.steps_of(rid).size()))
			lk["cleared"] = G.done(rid)
	else:
		st = "ghost"                                   # nothing there yet (the book cart has not come)
	slot.overlays = _bench_things() if key == "workbench" else []
	slot.set_state(_spot_title(sid), _spot_emoji(sid), tex, not open, _badge(sid), key, st, lk)

## How far a building at this place has come (1 … 5), or 0 when nothing is being built there.
func _site_stage(sid: String) -> int:
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not (n["type"] in ["building", "station"]) or G.done(id): continue
		var st: Array = G.steps_of(id)
		var i: int = G.step_index(id)
		if st.size() > 0 and i > 0: return clampi(1 + int(float(i) / float(st.size()) * 5.0), 1, 5)
	return 0

## What has been made so far, lying on the workbench (tools; rope once there is some).
func _bench_things() -> Array:
	var out := []
	for b in Spots.BENCH:
		var have: bool = G.count(str(b["id"])) >= 1.0 if b.get("item", false) else (G.nodes.has(b["id"]) and G.satisfied(b["id"]))
		var t: Texture2D = Art.tex("tools", str(b["pic"]))
		if have and t: out.append({"tex": t, "x": b["x"], "y": b["y"], "w": b["w"]})
	return out

## What stands inside a pen or garden besides its add-ons: the orchard's trees.
func _pen_inside(sid: String) -> Array:
	var out := []
	if sid == "orchard":
		var tree: Texture2D = Art.tex("deco", "tree_oak")
		for p in G.area("orchard"):
			if p["crop"] == "": out.append({"hole": true, "w": 30.0})
			else: out.append({"tex": Art.tex("crops", str(p["crop"])) if Art.tex("crops", str(p["crop"])) else tree, "w": 46.0 if p["ready"] else 38.0})
	return out

## A locked place with nothing to do yet: it only shows a mysterious sign and a promise.
func _mystery(sid: String) -> bool:
	if _is_open(sid) or (Spots.INTERIORS.has(sid) and _built(sid)): return false
	var lists = M.ui_place._goal_lists(sid)
	if not lists[0].is_empty() or not lists[1].is_empty(): return false
	for aid in Spots.nodes_at(G, sid):
		if G.nodes[aid]["type"] == "animal" and (G.done(aid) or G.missing_reqs(aid).is_empty()): return false
	return true

## Is a node part of the story so far (its chapter is now or earlier)? Sheets never show what lies beyond.
func _in_chapter(id: String) -> bool:
	return int(G.nodes.get(id, {}).get("chapter", 1)) <= G.chapter()

func _on_gained(source: String, got: Dictionary, lost: Dictionary = {}) -> void:
	if not got.is_empty():
		var kind = M.ui_sounds._gain_sound(source, got)
		M.ui_sounds._sfx(kind)
		M.ui_acts._act_for_gain(source, kind)
	var pieces := []
	var bounce := []
	for k in got:
		var q := float(got[k])
		if q < 0.01: continue
		for _i in range(clampi(int(round(q)), 1, 12)): pieces.append([G.iemoji(k), Art.first("items", [k])])
	for k in lost:
		var q2 := float(lost[k])
		if q2 < 0.01: continue
		for _i in range(clampi(int(round(q2)), 1, 8)): bounce.append([G.iemoji(k), Art.first("items", [k])])
	if pieces.is_empty() and bounce.is_empty(): return
	var job := [_source_point(source), "well" if got.has("water") else "storage", pieces, bounce]
	if M.modal.visible: M._fx_queue.append(job)
	else: M.map.fly(job[0], job[1], job[2], job[3])

func _source_point(source: String) -> Vector2:
	var parts := source.split(":")
	match parts[0]:
		"patch":
			if parts[1] == "field": return M.map.patch_point(int(parts[2]) / 9, int(parts[2]) % 9)
			return M.map.spot_point("orchard" if parts[1] == "orchard" else "greenhouse")
		"animal": return M.map.spot_point(_map_sid(Spots.spot_of(G, parts[1])))
		"recipe":
			var st: String = G.recipes[parts[1]]["station"]
			return M.map.spot_point(_map_sid(Spots.spot_of(G, st)))
		"water": return M.map.spot_point("pond")
		"node":
			var nid: String = parts[1]
			if G.nodes.has(nid) and G.nodes[nid].get("effects", {}).get("add", {}).has("plots"):
				var nxt: int = G.plots()                     # the patches being cleared
				return M.map.patch_point(nxt / 9, nxt % 9 + 1 if nxt % 9 < 8 else nxt % 9)
			return M.map.spot_point(_map_sid(Spots.spot_of(G, nid)))
	return M.map.spot_point("storage")

## What happened behind a pop-up plays when the farm is visible again.
func _play_fx() -> void:
	M.map.play_pending()
	for job in M._fx_queue: M.map.fly(job[0], job[1], job[2], job[3])
	M._fx_queue.clear()

## Small sign on a place: something to build (🔨), animals ready (🧺), a card quiz (❓), food going stale (🍂) …
func _badge(sid: String) -> String:
	if Spots.INTERIORS.has(sid) and _built(sid):
		for m in Spots.INTERIORS[sid]["members"]:
			var bm := _badge(m)
			if bm != "": return bm
		return ""
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not (n["type"] in M.GOAL_TYPES) or n.get("optional", false): continue
		if G.done(id) or G.satisfied(id): continue
		if G.can_unlock(id)["ok"]:
			match n["type"]:
				"delivery": return "📦"
				"sidequest": return "🤝"
				"pet": return "🐾"
				_: return "🔨"
	match sid:
		"library":
			for cid in G.card_ids:
				if G.card_status(cid) == "quiz": return "❓"
			if G.S["reading"] == "":
				for cid in G.card_ids:
					if G.card_status(cid) == "readable": return "📖"
		"storage":
			for k in G.S["inv"]:
				if G.stale_soon(k) >= 1.0: return "🍂"
		"living":
			if float(G.S["energy"]) < G.energy_max() * 0.25: return "😴"
	for aid in Spots.nodes_at(G, sid):
		if G.nodes[aid]["type"] == "animal" and G.S["animals"].has(aid):
			var a: Dictionary = G.S["animals"][aid]
			if int(a["count"]) > 0 and G.S["step"] >= int(a["ready"]): return "🧺"
	var busy := 0
	for root in G.S["running"]:
		if Spots.in_spot(G, root, sid): busy += G.S["running"][root].size()
	if busy > 0: return "⏳"
	return ""

func _critter_spec() -> Dictionary:
	var spec := {}
	for aid in G.animal_ids():
		if not G.nodes.has(aid) or not G.S["animals"].has(aid): continue
		var c := int(G.S["animals"][aid]["count"])
		if c <= 0: continue
		var arr := []
		for _i in range(mini(4, c)): arr.append([G.nodes[aid].get("emoji", "🐾"), Art.tex("animals", aid), aid])
		spec[Spots.spot_of(G, aid)] = arr
	var pets := []
	for pid in G.pet_ids():
		if G.done(pid): pets.append([G.nodes[pid].get("emoji", "🐾"), Art.tex("animals", pid), pid])
	if pets.size() > 0: spec["pets"] = pets
	return spec

func _next_goal() -> String:
	var best := ""
	var bk := 1 << 30
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		var t: String = n["type"]
		if t in ["knowledge", "book", "polish", "animal", "crop", "merchant", "sidequest"]: continue
		if n.get("optional", false) or G.done(id) or G.satisfied(id): continue
		if not G.missing_reqs(id).is_empty(): continue
		var k := int(n.get("chapter", 1)) * 10 + (0 if G.can_unlock(id)["ok"] else 1)
		if k < bk:
			bk = k; best = id
	return best

func _readable_card() -> String:
	for cid in G.card_ids:
		if G.card_status(cid) in ["quiz", "readable"]: return cid
	return ""

func _update_goal_bar() -> void:
	if M.goal_id != "":
		var n: Dictionary = G.nodes[M.goal_id]
		var ok: bool = G.can_unlock(M.goal_id)["ok"]
		var c: Dictionary = G.node_cost(M.goal_id)
		M.goal_btn.text = "%s %s %s   %s" % ["✅" if ok else "🎯", n.get("emoji", ""), n["name"], G.cost_text(c) if not c.is_empty() else ""]
	elif _readable_card() != "":
		M.goal_btn.text = M.tr("🎯 📚 Learn a new card in the library")
	else:
		M.goal_btn.text = M.tr("🎯 Answer Time Quiz questions — things grow while you learn")

func _goal_pressed() -> void:
	if M.goal_id != "":
		var sid := Spots.spot_of(G, M.goal_id)
		M.ui_sheets._open_sheet_for(sid)
		_pulse(sid)
	elif _readable_card() != "":
		M.ui_sheets._open_sheet_for("library")
		_pulse("library")
	else:
		M.ui_quiz._show_time_quiz()

func _pulse(sid: String) -> void:
	var ms := _map_sid(sid)
	if M.map.slots.has(ms) and M.map.slots[ms].visible: M.map.slots[ms].pulse()

func _scroll_to(y: float, smooth := true) -> void:
	var maxv := maxf(0.0, M.map.size.y - M.scroll.size.y)
	var t := clampf(y, 0.0, maxv)
	if M._scroll_tw: M._scroll_tw.kill()
	if not smooth:
		M.scroll.scroll_vertical = int(t)
		return
	M._scroll_tw = M.create_tween()
	M._scroll_tw.tween_property(M.scroll, "scroll_vertical", int(t), 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

## Scrolls so that a rectangle of the map is visible above the sheet.
func _reveal(r: Rect2) -> void:
	if r.size.y <= 0.0: return
	var visible_h = M.scroll.size.y - (M.sheet_h if M.sheet.visible else 0.0)
	var top := float(M.scroll.scroll_vertical)
	if r.position.y >= top + 6.0 and r.end.y <= top + visible_h - 6.0: return
	_scroll_to(r.position.y - maxf(12.0, (visible_h - r.size.y) * 0.25))
