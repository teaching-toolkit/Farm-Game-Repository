extends RefCounted
class_name FarmUiMapView
## The farm map's places: which picture, name and badge each place shows, what is open or still a mystery, the animals and pets walking
## about, things flying to the store, scrolling the map to a place.

const Art = preload("res://kits/ui/art.gd")
const Spots = preload("res://game/farm/spots.gd")
const MapScript = preload("res://game/farm/map/farm_map.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

var _scroll_tw: Tween

var _fx_queue: Array = []      # things that arrived while a pop-up was open: they fly to the store when it closes

# ------------------------------------------------------------------ layout

func fence_level() -> int:
	var lv := 0
	for i in range(1, MapScript.FENCES.size()):
		if G.satisfied(MapScript.FENCES[i][0]): lv = i
	return lv

# ------------------------------------------------------------------ places on the map

## The newest thing built at a place (its picture and name stand for the place).
func headline(sid: String) -> String:
	var best := ""
	if M.map.slots.has(sid):
		for id in Spots.art_chain(sid):
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

func spot_title(sid: String) -> String:
	if sid == "field":
		var names: Array = G.fields.field_names()
		return names[clampi(M.field_idx, 0, names.size() - 1)] if names.size() > 0 else tr("Field")
	var title := tr(Spots.name_of(sid))
	var parent := Spots.parent_of(sid)
	if parent != "" and built(parent): return title      # a corner inside a building: "Bed & home", "Kitchen" …
	var head := headline(sid)
	if head != "":
		var nm := str(G.nodes[head]["name"])
		if nm.length() <= 14: return nm
	return title

func spot_emoji(sid: String) -> String:
	var parent := Spots.parent_of(sid)
	if parent != "" and built(parent): return Spots.emoji_of(sid)
	var head := headline(sid)
	if head != "": return str(G.nodes[head].get("emoji", Spots.emoji_of(sid)))
	return Spots.emoji_of(sid)

func is_open(sid: String) -> bool:
	return headline(sid) != "" or Spots.is_always_open(sid)

## Does a building with an inside stand yet (house, barn, workshop)?
func built(parent: String) -> bool:
	if not Spots.has_interior(parent): return false
	var b: String = Spots.interior(parent)["built"]
	return G.nodes.has(b) and G.satisfied(b)

## The place on the map that stands for sid: a corner inside a building shows as the building once it stands.
func map_sid(sid: String) -> String:
	var parent := Spots.parent_of(sid)
	if parent != "" and (built(parent) or not M.map.slots.has(sid)): return parent
	return sid

## First picture name of keys that exists in folder ("" if none).
func first_key(folder: String, keys: Array) -> String:
	for k in keys:
		if str(k) != "" and Art.tex(folder, str(k)) != null: return str(k)
	return ""

## Picture names to try for a place: the newest thing built, then the earlier upgrades (so an upgrade without
## its own picture keeps the last one), then the place itself.
func art_keys(sid: String) -> Array:
	var head := headline(sid)
	var keys := [head]
	if M.map.slots.has(sid):
		var chain: Array = Spots.art_chain(sid)
		var at := chain.find(head)
		for i in range(at - 1, -1, -1): keys.append(chain[i])
	keys.append(sid)
	return keys

func update_slot(sid: String) -> void:
	var slot = M.map.slots[sid]
	# the house: the yard with tent, book box and campfire until the house stands, then the house alone
	if sid == "home":
		slot.visible = built("home")
	elif Spots.parent_of(sid) == "home":
		slot.visible = not built("home")
	if not slot.visible: return
	slot.show_name = bool(G.settings.get("showPlaceNames", false))
	var open := is_open(sid) or (Spots.has_interior(sid) and built(sid))
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
	elif Spots.has_pen(sid):
		st = "pen"                                     # a generic fence and ground; what is built stands inside
		lk = Spots.pen(sid)
		slot.inside = _pen_inside(sid) if open else []
	elif open and headline(sid).begins_with("ruins_"):
		st = "ruin"                                    # the old walls are cleared away: bare earth, ready to build on
		lk = {"material": Spots.ruin_material(sid, "stone"), "cleared": true}
	elif open and _site_stage(sid) > 0 and first_key("map", art_keys(sid).filter(func(k): return G.nodes.has(k) and G.done(k))) == "":
		var stage := _site_stage(sid)                  # a building site: foundation, frame, walls … as the steps are done
		key = "site_%d" % stage
		tex = Art.first("construction", ["stage_%d" % stage, "stage_1"])
		if tex == null:
			st = "ruin"
			lk = {"material": "stone", "cleared": true}
	elif open:
		key = first_key("map", art_keys(sid))
		tex = Art.tex("map", key) if key != "" else null
		if key == "workbench" and Art.tex("map", "workbench_empty"):
			tex = Art.tex("map", "workbench_empty")        # the bench is empty; what has been made lies on it
	elif sid == "kitchen":
		st = "fireplace"                               # before the campfire: a few blackened rocks and a burnt log, no ruin
	elif Spots.ruin_material(sid) != "":
		st = "ruin"                                    # what is left of it: broken walls, rubble — less as it is cleared
		lk = {"material": Spots.ruin_material(sid)}
		var rid := "ruins_" + sid
		if G.nodes.has(rid):
			lk["progress"] = float(G.progression.step_index(rid)) / float(maxi(1, G.progression.steps_of(rid).size()))
			lk["cleared"] = G.done(rid)
	else:
		st = "ghost"                                   # nothing there yet (the book cart has not come)
	slot.overlays = _bench_things() if key == "workbench" else []
	slot.set_state(spot_title(sid), spot_emoji(sid), tex, not open, badge(sid), key, st, lk)

## How far a building at this place has come (1 … 5), or 0 when nothing is being built there.
func _site_stage(sid: String) -> int:
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not (n["type"] in ["building", "station"]) or G.done(id): continue
		var st: Array = G.progression.steps_of(id)
		var i: int = G.progression.step_index(id)
		if st.size() > 0 and i > 0: return clampi(1 + int(float(i) / float(st.size()) * 5.0), 1, 5)
	return 0

## What has been made so far, lying on the workbench (tools; rope once there is some).
func _bench_things() -> Array:
	var out := []
	for b in Spots.bench():
		var have: bool = G.inventory.count(str(b["id"])) >= 1.0 if b.get("item", false) else (G.nodes.has(b["id"]) and G.satisfied(b["id"]))
		var t: Texture2D = Art.tex("tools", str(b["pic"]))
		if have and t: out.append({"tex": t, "x": b["x"], "y": b["y"], "w": b["w"]})
	return out

## What stands inside a pen or garden besides its add-ons: the orchard's trees.
func _pen_inside(sid: String) -> Array:
	var out := []
	if sid == "orchard":
		var tree: Texture2D = Art.tex("deco", "tree_oak")
		for p in G.fields.area("orchard"):
			if p["crop"] == "": out.append({"hole": true, "w": 30.0})
			else: out.append({"tex": Art.tex("crops", str(p["crop"])) if Art.tex("crops", str(p["crop"])) else tree, "w": 46.0 if p["ready"] else 38.0})
	return out

## A locked place with nothing to do yet: it only shows a mysterious sign and a promise.
func mystery(sid: String) -> bool:
	if is_open(sid) or (Spots.has_interior(sid) and built(sid)): return false
	var lists := M.placesheet.goal_lists(sid)
	if not lists[0].is_empty() or not lists[1].is_empty(): return false
	for aid in Spots.nodes_at(G, sid):
		if G.nodes[aid]["type"] == "animal" and (G.done(aid) or G.progression.missing_reqs(aid).is_empty()): return false
	return true

## Is a node part of the story so far (its chapter is now or earlier)? Sheets never show what lies beyond.
func in_chapter(id: String) -> bool:
	return int(G.nodes.get(id, {}).get("chapter", 1)) <= G.chapter()

# ------------------------------------------------------------------ things flying to the store

func on_gained(source: String, got: Dictionary, lost: Dictionary = {}) -> void:
	if not got.is_empty():
		var kind := M.feedback.gain_sound(source, got)
		M.feedback.sfx(kind)
		M.feedback.act_for_gain(source, kind)
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
	if M.modal.visible: _fx_queue.append(job)
	else: M.map.fly(job[0], job[1], job[2], job[3])

func _source_point(source: String) -> Vector2:
	var parts := source.split(":")
	match parts[0]:
		"patch":
			if parts[1] == "field": return M.map.patch_point(int(parts[2]) / 9, int(parts[2]) % 9)
			return M.map.spot_point("orchard" if parts[1] == "orchard" else "greenhouse")
		"animal": return M.map.spot_point(map_sid(Spots.spot_of(G, parts[1])))
		"recipe":
			var st: String = G.recipes[parts[1]]["station"]
			return M.map.spot_point(map_sid(Spots.spot_of(G, st)))
		"water": return M.map.spot_point("pond")
		"node":
			var nid: String = parts[1]
			if G.nodes.has(nid) and G.nodes[nid].get("effects", {}).get("add", {}).has("plots"):
				var nxt: int = G.progression.plots()                     # the patches being cleared
				return M.map.patch_point(nxt / 9, nxt % 9 + 1 if nxt % 9 < 8 else nxt % 9)
			return M.map.spot_point(map_sid(Spots.spot_of(G, nid)))
	return M.map.spot_point("storage")

## What happened behind a pop-up plays when the farm is visible again.
func play_fx() -> void:
	M.map.play_pending()
	for job in _fx_queue: M.map.fly(job[0], job[1], job[2], job[3])
	_fx_queue.clear()

## Small sign on a place: something to build (🔨), animals ready (🧺), a card quiz (❓), food going stale (🍂) …
func badge(sid: String) -> String:
	if Spots.has_interior(sid) and built(sid):
		for m in Spots.interior(sid)["members"]:
			var bm := badge(m)
			if bm != "": return bm
		return ""
	for id in Spots.nodes_at(G, sid):
		var n: Dictionary = G.nodes[id]
		if not (n["type"] in G.goal_types) or n.get("optional", false): continue
		if G.done(id) or G.satisfied(id): continue
		if G.progression.can_unlock(id)["ok"]:
			match n["type"]:
				"delivery": return "📦"
				"sidequest": return "🤝"
				"pet": return "🐾"
				_: return "🔨"
	match sid:
		"library":
			for cid in G.card_ids:
				if G.knowledge.card_status(cid) == "quiz": return "❓"
			if G.S["reading"] == "":
				for cid in G.card_ids:
					if G.knowledge.card_status(cid) == "readable": return "📖"
		"storage":
			for k in G.S["inv"]:
				if G.inventory.stale_soon(k) >= 1.0: return "🍂"
		"living":
			if float(G.S["energy"]) < G.needs.energy_max() * 0.25: return "😴"
	for aid in Spots.nodes_at(G, sid):
		if G.nodes[aid]["type"] == "animal" and G.S["animals"].has(aid):
			var a: Dictionary = G.S["animals"][aid]
			if int(a["count"]) > 0 and G.S["step"] >= int(a["ready"]): return "🧺"
	var busy := 0
	for root in G.S["running"]:
		if Spots.in_spot(G, root, sid): busy += G.S["running"][root].size()
	if busy > 0: return "⏳"
	return ""

func critter_spec() -> Dictionary:
	var spec := {}
	for aid in G.animal_ids:
		if not G.S["animals"].has(aid): continue
		var c := int(G.S["animals"][aid]["count"])
		if c <= 0: continue
		var arr := []
		for _i in range(mini(4, c)): arr.append([G.nodes[aid].get("emoji", "🐾"), Art.tex("animals", aid), aid, G.nodes[aid].get("facesLeft", false)])
		spec[Spots.spot_of(G, aid)] = arr
	var pets := []
	for pid in G.pet_ids:
		if G.done(pid): pets.append([G.nodes[pid].get("emoji", "🐾"), Art.tex("animals", pid), pid, G.nodes[pid].get("facesLeft", false)])
	if pets.size() > 0: spec["pets"] = pets
	return spec

func pulse(sid: String) -> void:
	var ms := map_sid(sid)
	if M.map.slots.has(ms) and M.map.slots[ms].visible: M.map.slots[ms].pulse()

# ------------------------------------------------------------------ scrolling the map

func scroll_to(y: float, smooth := true) -> void:
	var maxv := maxf(0.0, M.map.size.y - M.scroll.size.y)
	var t := clampf(y, 0.0, maxv)
	if _scroll_tw: _scroll_tw.kill()
	if not smooth:
		M.scroll.scroll_vertical = int(t)
		return
	_scroll_tw = M.create_tween()
	_scroll_tw.tween_property(M.scroll, "scroll_vertical", int(t), 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

## Scrolls so that a rectangle of the map is visible above the sheet.
func reveal(r: Rect2) -> void:
	if r.size.y <= 0.0: return
	var visible_h := M.scroll.size.y - (M.sheet_h if M.sheet.visible else 0.0)
	var top := float(M.scroll.scroll_vertical)
	if r.position.y >= top + 6.0 and r.end.y <= top + visible_h - 6.0: return
	scroll_to(r.position.y - maxf(12.0, (visible_h - r.size.y) * 0.25))
