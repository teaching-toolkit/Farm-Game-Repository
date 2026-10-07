## LearnKit · mental maths: a curriculum of categories → sections ("By heart", "Working it out") → levels
## (learnkit/curriculum/math.json), spaced repetition for every single task, medals per level.
##
##   var M = preload("res://learnkit/math_engine.gd").new()
##   M.load_curriculum()                       # or M.load_curriculum("res://my/math.json")
##   var q = M.question(L, rng)                # L = the learner's record (a Dictionary, see learner.gd)
##   # … the child types an answer; q["limit"] = seconds for a quick answer …
##   var fb = M.result(L, q, M.is_right(q, typed), seconds <= q["limit"], rng)
##
## The record (L["math"]): n (answers), active (category ids practised), items {task: {lvl, box, due, right, wrong, slow,
## known, last_ok}}, levels {level id: {n, bad, bronze, silver, gold}} (medals = unix time won), recent, streak, best_streak,
## quick_total, since_boost, said, turn. Plain JSON: it can be read and edited by hand or with learnkit/tools/learning-editor.html.
extends RefCounted

const Srs = preload("srs.gd")
const DEFAULT_PATH := "res://learnkit/curriculum/math.json"

var C: Dictionary = {}          # the curriculum
var levels: Dictionary = {}     # level id -> level (with "cat", "sec", "fluency", "pos" added)
var sections: Array = []        # [{"cat", "sec", "ids": [level ids]}]
var _pools: Dictionary = {}     # level id -> {"keys": [task keys], "by": {key: [answer, text, hint]}}

func load_curriculum(path := DEFAULT_PATH) -> void:
	var txt := FileAccess.get_file_as_string(path)
	var d = JSON.parse_string(txt) if txt != "" else null
	C = d if typeof(d) == TYPE_DICTIONARY else {"categories": []}
	levels.clear()
	sections.clear()
	_pools.clear()
	for cat in C.get("categories", []):
		for sec in cat.get("sections", []):
			var ids := []
			var pos := 0
			for lv in sec.get("levels", []):
				lv["cat"] = cat["id"]
				lv["sec"] = sec["id"]
				lv["fluency"] = sec.get("fluency", true)
				lv["pos"] = pos
				pos += 1
				levels[lv["id"]] = lv
				ids.append(lv["id"])
			sections.append({"cat": cat["id"], "sec": sec["id"], "ids": ids, "name": sec.get("name", ""), "emoji": sec.get("emoji", "")})

func cfg(k: String, def = null):
	return C.get("srs", {}).get(k, def)

func category(id: String) -> Dictionary:
	for c in C.get("categories", []):
		if c["id"] == id: return c
	return {}

## The learner's maths record (made the first time). active: the categories practised (a parent turns more on).
func rec(L: Dictionary, active: Array = ["addsub"]) -> Dictionary:
	if not L.has("math") or typeof(L["math"]) != TYPE_DICTIONARY:
		L["math"] = {"n": 0, "active": active.duplicate(), "items": {}, "levels": {}, "recent": [], "streak": 0, "best_streak": 0,
			"quick_total": 0, "since_boost": 0, "said": 0, "turn": 0}
	var r: Dictionary = L["math"]
	for k in ["items", "levels"]:
		if not r.has(k): r[k] = {}
	if not r.has("recent"): r["recent"] = []
	if not r.has("active"): r["active"] = active.duplicate()
	return r

func lrec(r: Dictionary, id: String) -> Dictionary:
	if not r["levels"].has(id): r["levels"][id] = {"n": 0, "bad": 0, "bronze": 0, "silver": 0, "gold": 0}
	return r["levels"][id]

func medal(r: Dictionary, id: String, kind: String) -> bool:
	return float(r["levels"].get(id, {}).get(kind, 0)) > 0.0

# ------------------------------------------------------------------ the tasks of a level
func pool(id: String) -> Dictionary:
	if _pools.has(id): return _pools[id]
	var out := []
	if levels.has(id): out = _gen(levels[id])
	if out.is_empty(): out = [["1 + 1", "2", "1 + 1 = ?", ""]]
	var keys := []
	var by := {}
	for e in out:
		if by.has(e[0]): continue
		keys.append(e[0])
		by[e[0]] = [str(e[1]), str(e[2]), str(e[3]) if e.size() > 3 else ""]
	_pools[id] = {"keys": keys, "by": by}
	return _pools[id]

## A task's answer, text and hint, wherever it is defined.
func task(key: String, id: String) -> Array:
	var p := pool(id)
	if p["by"].has(key): return p["by"][key]
	return ["?", key + " = ?", ""]

## Answers as typed are compared after tidying: spaces gone, "," → ".", 2.50 → 2.5, r → R, − → -.
static func norm(s: String) -> String:
	var t := s.strip_edges().replace(" ", "").replace(",", ".").replace("−", "-").to_upper()
	if t.contains(".") and not t.contains("R"):
		while t.ends_with("0"): t = t.substr(0, t.length() - 1)
		if t.ends_with("."): t = t.substr(0, t.length() - 1)
		if t.begins_with("."): t = "0" + t
		if t.begins_with("-."): t = "-0" + t.substr(1)
	return t

func is_right(q: Dictionary, typed: String) -> bool:
	return norm(typed) == norm(str(q.get("answer", "")))

## Seconds for a quick answer: the level's time + timing.digitAllowance per character after the first, × scale.
func limit_for(lv: Dictionary, answer: String, scale := 1.0) -> float:
	var allow := float(C.get("timing", {}).get("digitAllowance", 0.5))
	return (float(lv.get("quick", 3.0)) + allow * maxf(0.0, answer.length() - 1)) * scale

# ------------------------------------------------------------------ where the learner is
## The level a section is on: the first one without bronze whose "after" level has bronze ("" = all passed or locked).
func current(r: Dictionary, sec: Dictionary) -> String:
	for id in sec["ids"]:
		if medal(r, id, "bronze"): continue
		var after := str(levels[id].get("after", ""))
		if after != "" and not medal(r, after, "bronze"): return ""
		return id
	return ""

## Levels new tasks come from, in turn: the current level of every section of the active categories.
func _sources(r: Dictionary) -> Array:
	var out := []
	for s in sections:
		if not r["active"].has(s["cat"]): continue
		var id := current(r, s)
		if id != "": out.append(id)
	return out

## Levels passed but not yet silver whose tasks have not all been met (by-heart levels: every task counts for silver).
func _unfinished(r: Dictionary) -> Array:
	var out := []
	for s in sections:
		if not r["active"].has(s["cat"]): continue
		for id in s["ids"]:
			if medal(r, id, "bronze") and not medal(r, id, "silver"): out.append(id)
	return out

func _recent_keys(r: Dictionary, k: int) -> Array:
	var out := []
	var rc: Array = r["recent"]
	for i in range(maxi(0, rc.size() - k), rc.size()):
		out.append(str(rc[i].get("k", "")))
	return out

## Hard going: in the last answers (not counting easy boosters) many were wrong, or almost all were slow.
func struggling(r: Dictionary) -> bool:
	var rc: Array = r["recent"]
	var win := int(cfg("struggleWindow", 8))
	var wrong := 0
	var slow := 0
	var seen := 0
	for i in range(rc.size() - 1, -1, -1):
		if seen >= win: break
		var e: Dictionary = rc[i]
		if e.get("b", false): continue
		seen += 1
		if not e.get("r", true): wrong += 1
		elif not e.get("q", true): slow += 1
	if seen < 5: return false
	return wrong >= int(cfg("struggleWrong", 3)) or slow + wrong >= int(cfg("struggleSlow", 5))

func _learning(r: Dictionary, id: String) -> int:
	var c := 0
	var by: Dictionary = pool(id)["by"]
	for k in r["items"]:
		if by.has(k) and int(r["items"][k].get("box", 0)) < 2: c += 1
	return c

func _new_key(r: Dictionary, id: String, rng: RandomNumberGenerator, avoid: Array) -> String:
	var keys: Array = pool(id)["keys"]
	for _try in range(40):
		var k: String = keys[rng.randi_range(0, keys.size() - 1)]
		if not r["items"].has(k) and not avoid.has(k): return k
	for k in keys:
		if not r["items"].has(k) and not avoid.has(k): return k
	return ""

func _booster(r: Dictionary, rng: RandomNumberGenerator, avoid: Array) -> Array:
	var known := []
	for k in r["items"]:
		var it: Dictionary = r["items"][k]
		if int(it.get("box", 0)) >= 2 and not avoid.has(k): known.append(k)
	if not known.is_empty():
		var k2: String = known[rng.randi_range(0, known.size() - 1)]
		return [k2, str(r["items"][k2].get("lvl", ""))]
	var first := str(sections[0]["ids"][0]) if not sections.is_empty() else ""
	if first == "": return []
	var keys: Array = pool(first)["keys"]
	return [keys[rng.randi_range(0, keys.size() - 1)], first]

## A level waiting for its gold check (silver at least gold.days ago) and one of its tasks not yet re-checked.
func _gold_review(r: Dictionary, rng: RandomNumberGenerator, avoid: Array) -> Array:
	var days := float(C.get("medals", {}).get("gold", {}).get("days", 7))
	var now := Time.get_unix_time_from_system()
	var waiting := []
	for id in r["levels"]:
		var lr: Dictionary = r["levels"][id]
		if float(lr.get("silver", 0)) > 0.0 and float(lr.get("gold", 0)) <= 0.0 and now - float(lr["silver"]) >= days * 86400.0 and levels.has(id):
			waiting.append(id)
	if waiting.is_empty(): return []
	var id: String = waiting[rng.randi_range(0, waiting.size() - 1)]
	var since := float(r["levels"][id]["silver"]) + days * 86400.0
	var cands := []
	for k in pool(id)["keys"]:
		if avoid.has(k): continue
		if r["items"].has(k) and float(r["items"][k].get("last_ok", 0)) >= since: continue
		cands.append(k)
		if cands.size() >= 40: break
	if cands.is_empty(): return []
	return [cands[rng.randi_range(0, cands.size() - 1)], id]

func _make(r: Dictionary, key: String, id: String, review: bool, booster: bool, scale: float) -> Dictionary:
	var lvl := id
	if lvl == "" or not levels.has(lvl): lvl = str(r["items"].get(key, {}).get("lvl", ""))
	if not levels.has(lvl) and not sections.is_empty(): lvl = str(sections[0]["ids"][0])
	var t := task(key, lvl)
	var lv: Dictionary = levels.get(lvl, {})
	return {"key": key, "answer": t[0], "q": t[1], "hint": t[2], "level": lvl, "review": review, "booster": booster,
		"limit": limit_for(lv, t[0], scale), "keys": lv.get("keys", [])}

## The next task. scale stretches the time for a quick answer (a parent setting).
func question(L: Dictionary, rng: RandomNumberGenerator, scale := 1.0) -> Dictionary:
	var r := rec(L)
	var n := int(r["n"])
	var avoid := _recent_keys(r, 2)
	var hard := struggling(r)
	# hard going: every few tasks an easy one the child knows
	if hard and int(r.get("since_boost", 0)) >= int(cfg("boosterEvery", 3)) - 1:
		var b := _booster(r, rng, avoid)
		if not b.is_empty(): return _make(r, b[0], b[1], false, true, scale)
	# a level waiting for gold: check now and then whether it has stuck
	if rng.randf() < float(cfg("goldReviewShare", 0.3)):
		var g := _gold_review(r, rng, avoid)
		if not g.is_empty(): return _make(r, g[0], g[1], true, false, scale)
	# something new now and then even when reviews are waiting (so the child keeps moving on), else the most overdue
	var limit := int(cfg("newInFlightStruggling" if hard else "newInFlight", 4))
	var srcs := _sources(r)
	# every 2nd new task fills the grid of a passed level instead (each task of a by-heart level counts for silver)
	if int(r.get("turn", 0)) % 2 == 1:
		var un := _unfinished(r)
		if not un.is_empty(): srcs = un + srcs
	var due := Srs.most_overdue(r["items"], n, avoid)
	var run := int(cfg("reviewRunStruggling" if hard else "reviewRun", 2))
	if due == "" or int(r.get("since_new", 0)) >= run:
		for i in range(srcs.size()):
			var id: String = srcs[(int(r.get("turn", 0)) + i) % srcs.size()]
			if _learning(r, id) >= limit: continue
			var nk := _new_key(r, id, rng, avoid)
			if nk != "":
				r["turn"] = int(r.get("turn", 0)) + 1
				r["since_new"] = 0
				return _make(r, nk, id, false, false, scale)
		# the current levels are busy: fill the grid of a passed level (every task of a by-heart level counts for silver)
		if due == "":
			for id2 in _unfinished(r):
				if _learning(r, id2) >= limit: continue
				var nk2 := _new_key(r, id2, rng, avoid)
				if nk2 != "": return _make(r, nk2, id2, false, false, scale)
	if due != "":
		r["since_new"] = int(r.get("since_new", 0)) + 1
		return _make(r, due, "", true, false, scale)
	# otherwise the one whose turn comes soonest
	var soon := Srs.soonest(r["items"], avoid)
	if soon != "": return _make(r, soon, "", true, false, scale)
	var first := str(srcs[0]) if not srcs.is_empty() else (str(sections[0]["ids"][0]) if not sections.is_empty() else "")
	return _make(r, _new_key(r, first, rng, []), first, false, false, scale)

# ------------------------------------------------------------------ after an answer
func _pick(rng: RandomNumberGenerator, arr: Array) -> String:
	return str(arr[rng.randi_range(0, arr.size() - 1)]) if not arr.is_empty() else ""

func _fill(t: String, lv: Dictionary) -> String:
	return t.replace("{emoji}", str(lv.get("emoji", ""))).replace("{name}", str(lv.get("name", "")))

## Remembers the answer. Returns what to show: {"comment", "hint", "level_up", "known", "streak", "struggling",
## "medals": [{"level", "medal"}], "trophies": [{"cat", "sec", "kind"}]}.
func result(L: Dictionary, q: Dictionary, right: bool, quick: bool, rng: RandomNumberGenerator) -> Dictionary:
	var r := rec(L)
	r["n"] = int(r["n"]) + 1
	var n := int(r["n"])
	var key: String = q.get("key", "")
	var lvl: String = q.get("level", "")
	var com: Dictionary = C.get("comments", {})
	var fb := {"comment": "", "hint": "", "level_up": false, "known": false, "streak": 0, "struggling": false, "medals": [], "trophies": []}
	if key == "": return fb
	var first_sight: bool = not r["items"].has(key)
	var it: Dictionary = r["items"].get(key, Srs.new_item())
	if not it.has("lvl"): it["lvl"] = lvl
	var outcome := "wrong" if not right else ("slow" if not quick else "right")
	var known := Srs.schedule(it, outcome, n, C.get("srs", {}))
	# quick and right the very first time: the child already knows it — it skips the first steps (like "easy" in Anki)
	if first_sight and outcome == "right":
		var gaps: Array = cfg("gaps", [3, 8, 20])
		it["box"] = maxi(int(it["box"]), mini(int(cfg("firstSightBox", 3)), gaps.size()))
		it["due"] = n + int(gaps[int(it["box"]) - 1])
	if outcome == "right":
		it["last_ok"] = int(Time.get_unix_time_from_system())
		r["streak"] = int(r.get("streak", 0)) + 1
		r["best_streak"] = maxi(int(r.get("best_streak", 0)), int(r["streak"]))
		r["quick_total"] = int(r.get("quick_total", 0)) + 1
	else:
		r["streak"] = 0
		if not right: fb["hint"] = str(q.get("hint", ""))
	r["items"][key] = it
	fb["known"] = known
	var booster: bool = q.get("booster", false)
	r["recent"].append({"k": key, "l": lvl, "r": right, "q": quick, "b": booster})
	while r["recent"].size() > 30: r["recent"].pop_front()
	r["since_boost"] = 0 if booster else int(r.get("since_boost", 0)) + 1
	if not booster and levels.has(lvl):
		var lr := lrec(r, lvl)
		lr["n"] = int(lr["n"]) + 1
		if outcome != "right":
			lr["bad"] = int(lr["bad"]) + 1
			lr["run"] = 0
		else: lr["run"] = int(lr.get("run", 0)) + 1
	fb["streak"] = int(r["streak"])
	fb["struggling"] = struggling(r)
	# what to say
	var sk := str(r["streak"])
	if outcome == "right" and com.get("streak", {}).has(sk): fb["comment"] = str(com["streak"][sk])
	elif known and levels.has(lvl) and int(levels[lvl].get("class", 1)) >= 2:
		fb["comment"] = _pick(rng, com.get("known", [])).replace("{task}", str(q.get("q", "")).replace(" = ?", ""))
	elif fb["struggling"] and outcome != "right":
		r["said"] = int(r.get("said", 0)) + 1
		if int(r["said"]) % 3 == 1: fb["comment"] = _pick(rng, com.get("struggling", []))
	# medals for the task's level (and the level it was first learned in)
	var check := [lvl]
	if str(it.get("lvl", "")) != lvl: check.append(str(it["lvl"]))
	for id in check:
		if not levels.has(id): continue
		for m in _new_medals(r, id):
			fb["medals"].append({"level": id, "medal": m})
			if m == "bronze": fb["level_up"] = true
	if fb["level_up"]:
		var sec := _section_of(lvl)
		var nxt := current(r, sec) if not sec.is_empty() else ""
		var passed_fast: bool = int(lrec(r, lvl).get("n", 0)) <= int(cfg("fastTrackWithin", 12))
		if nxt != "": fb["comment"] = _fill(str(com.get("levelUp", "⭐ New level: {emoji} {name}!")), levels[nxt])
		else: fb["comment"] = _fill(str(com.get("medal", "")).replace("{medal}", "🥉").replace("{medalName}", "Bronze"), levels[lvl])
		if passed_fast: fb["comment"] = str(com.get("fastTrack", "")) + "  " + fb["comment"]
	for m2 in fb["medals"]:
		if m2["medal"] != "bronze":
			var md: Dictionary = C.get("medals", {}).get(m2["medal"], {})
			fb["comment"] = _fill(str(com.get("medal", "{medal} {medalName} medal: {emoji} {name}!")).replace("{medal}", str(md.get("emoji", ""))).replace("{medalName}", str(md.get("name", ""))), levels[m2["level"]])
	for m3 in fb["medals"]:
		var t := _trophy(r, str(m3["level"]), str(m3["medal"]))
		if not t.is_empty(): fb["trophies"].append(t)
	return fb

func _section_of(id: String) -> Dictionary:
	if not levels.has(id): return {}
	for s in sections:
		if s["cat"] == levels[id]["cat"] and s["sec"] == levels[id]["sec"]: return s
	return {}

## Medals the level has just won (set in the record with the time they were won).
func _new_medals(r: Dictionary, id: String) -> Array:
	var out := []
	var lr := lrec(r, id)
	var lv: Dictionary = levels[id]
	var keys: Array = pool(id)["keys"]
	var now := int(Time.get_unix_time_from_system())
	var at2 := 0
	for k in keys:
		if r["items"].has(k) and int(r["items"][k].get("box", 0)) >= 2: at2 += 1
	var need := mini(int(lv.get("need", 10)), keys.size())
	if float(lr.get("bronze", 0)) <= 0.0:
		# fast track: on a level that is still new, fastTrack quick and right answers in a row
		var fast: bool = int(lr.get("run", 0)) >= int(cfg("fastTrack", 5)) and int(lr["n"]) <= int(cfg("fastTrackWithin", 12))
		if fast or (at2 >= need and _accuracy(r, id, 10) >= float(cfg("passAccuracy", 0.8))):
			lr["bronze"] = now
			out.append("bronze")
	if float(lr.get("bronze", 0)) > 0.0 and float(lr.get("silver", 0)) <= 0.0:
		var ok := false
		var sv: Dictionary = C.get("medals", {}).get("silver", {})
		if lv.get("fluency", true) and keys.size() <= 200:
			var want := keys.size() if keys.size() <= int(sv.get("allUpTo", 20)) else int(ceil(keys.size() * float(sv.get("share", 0.7))))
			ok = at2 >= want and _accuracy(r, id, 10, true) >= 0.9
		else:
			var cnt := mini(int(C.get("medals", {}).get("silver", {}).get("silverCount", 20)), keys.size())
			ok = at2 >= cnt and _accuracy(r, id, 10, true) >= 0.9
		if ok:
			lr["silver"] = now
			out.append("silver")
	if float(lr.get("silver", 0)) > 0.0 and float(lr.get("gold", 0)) <= 0.0:
		var since := float(lr["silver"]) + float(C.get("medals", {}).get("gold", {}).get("days", 7)) * 86400.0
		var again := 0
		for k in keys:
			if r["items"].has(k) and float(r["items"][k].get("last_ok", 0)) >= since: again += 1
		if now >= since and again >= need:
			lr["gold"] = now
			out.append("gold")
	return out

## Share of the last k answers on a level that were right (quick_too: right and quick).
func _accuracy(r: Dictionary, id: String, k: int, quick_too := false) -> float:
	var tot := 0
	var ok := 0
	var rc: Array = r["recent"]
	for i in range(rc.size() - 1, -1, -1):
		var e: Dictionary = rc[i]
		if str(e.get("l", "")) != id or e.get("b", false): continue
		tot += 1
		if e.get("r", false) and (not quick_too or e.get("q", false)): ok += 1
		if tot >= k: break
	return float(ok) / float(tot) if tot > 0 else 0.0

## A trophy (all levels of the section silver) or a crown (all gold), when this medal completed it.
func _trophy(r: Dictionary, id: String, m: String) -> Dictionary:
	if m == "bronze": return {}
	var s := _section_of(id)
	for lid in s.get("ids", []):
		if not medal(r, lid, m): return {}
	return {"cat": s["cat"], "sec": s["sec"], "kind": "trophy" if m == "silver" else "crown"}

# ------------------------------------------------------------------ what the game shows
## The level of a task, for the quiz window: names, how far along, medals, streak, the category's title.
func level_info(L: Dictionary, id: String = "") -> Dictionary:
	var r := rec(L)
	if id == "" or not levels.has(id):
		var srcs := _sources(r)
		id = str(srcs[0]) if not srcs.is_empty() else (str(sections[0]["ids"][0]) if not sections.is_empty() else "")
	if id == "": return {}
	var lv: Dictionary = levels[id]
	var keys: Array = pool(id)["keys"]
	var at2 := 0
	for k in keys:
		if r["items"].has(k) and int(r["items"][k].get("box", 0)) >= 2: at2 += 1
	var need := mini(int(lv.get("need", 10)), keys.size())
	var cat := category(str(lv["cat"]))
	var s := _section_of(id)
	return {"id": id, "name": str(lv.get("name", "")), "emoji": str(lv.get("emoji", "")), "pos": int(lv["pos"]) + 1,
		"count": s.get("ids", []).size(), "section": str(s.get("name", "")), "section_emoji": str(s.get("emoji", "")),
		"category": str(cat.get("name", "")), "category_emoji": str(cat.get("emoji", "")), "got": mini(at2, need), "need": need,
		"tasks": keys.size(), "bronze": medal(r, id, "bronze"), "silver": medal(r, id, "silver"), "gold": medal(r, id, "gold"),
		"streak": int(r.get("streak", 0)), "best": int(r.get("best_streak", 0)), "rank": rank(r, str(lv["cat"]))}

## A title for a category from its medal points (bronze 1, silver 2, gold 3) out of all its points (data "ranks").
func rank(r: Dictionary, cat: String) -> String:
	var pts := 0
	var tot := 0
	for s in sections:
		if s["cat"] != cat: continue
		for id in s["ids"]:
			tot += 3
			for m in ["bronze", "silver", "gold"]:
				if medal(r, id, m): pts += 1
	var share := float(pts) / float(maxi(1, tot))
	var title := ""
	for rk in C.get("ranks", []):
		if share >= float(rk.get("share", 0)): title = str(rk.get("title", ""))
	return title

## Everything for a medal shelf: [{"cat", "name", "emoji", "rank", "active", "sections": [{"name", "emoji", "trophy",
## "crown", "levels": [{"id", "name", "emoji", "class", "bronze", "silver", "gold", "current", "locked"}]}]}].
func overview(L: Dictionary) -> Array:
	var r := rec(L)
	var out := []
	for cat in C.get("categories", []):
		var cs := {"cat": cat["id"], "name": cat.get("name", ""), "emoji": cat.get("emoji", ""), "rank": rank(r, cat["id"]),
			"active": r["active"].has(cat["id"]), "classes": cat.get("classes", ""), "sections": []}
		for s in sections:
			if s["cat"] != cat["id"]: continue
			var cur := current(r, s)
			var ss := {"name": s["name"], "emoji": s["emoji"], "trophy": true, "crown": true, "levels": []}
			for id in s["ids"]:
				var lv: Dictionary = levels[id]
				var after := str(lv.get("after", ""))
				var e := {"id": id, "name": lv.get("name", ""), "emoji": lv.get("emoji", ""), "class": lv.get("class", 0),
					"example": lv.get("example", ""), "bronze": medal(r, id, "bronze"), "silver": medal(r, id, "silver"),
					"gold": medal(r, id, "gold"), "current": id == cur, "locked": after != "" and not medal(r, after, "bronze")}
				if not e["silver"]: ss["trophy"] = false
				if not e["gold"]: ss["crown"] = false
				ss["levels"].append(e)
			cs["sections"].append(ss)
		out.append(cs)
	return out

## Counts for achievements: medals won (all kinds), tasks known for good.
func medal_count(L: Dictionary, kind := "") -> int:
	var r := rec(L)
	var c := 0
	for id in r["levels"]:
		for m in ["bronze", "silver", "gold"]:
			if (kind == "" or kind == m) and medal(r, id, m): c += 1
	return c

func known_count(L: Dictionary) -> int:
	var r := rec(L)
	var c := 0
	for k in r["items"]:
		if r["items"][k].get("known", false): c += 1
	return c

# ------------------------------------------------------------------ task generators (level "kind")
## Every generator returns [[key, answer, text, hint], …]. key = how the task is remembered; answer = what to type.
func _gen(lv: Dictionary) -> Array:
	var out := []
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(str(lv.get("id", "")))      # big levels are a fixed sample, the same every time
	var carry: bool = lv.get("carry", false)
	match str(lv.get("kind", "")):
		"add_upto":
			var mx := int(lv.get("max", 10))
			for a in range(1, mx):
				for b in range(1, mx - a + 1): _pm(out, a, "+", b)
		"sub_within":
			var mx2 := int(lv.get("max", 10))
			for a in range(2, mx2 + 1):
				for b in range(1, a): _pm(out, a, "-", b)
		"doubles":
			for a in range(1, int(lv.get("max", 10)) + 1): _pm(out, a, "+", a)
		"bonds", "bonds_tens", "bonds_any":
			var tot := int(lv.get("total", 10))
			var step := 10 if lv["kind"] == "bonds_tens" else 1
			for a in range(step, tot, step):
				if lv["kind"] == "bonds_any" and a % 10 == 0: continue
				var up := a + (10 - a % 10) if a % 10 != 0 else a
				var h := "%d + %d = %d" % [a, tot - a, tot]
				if lv["kind"] == "bonds_any" and up < tot: h = "%d + %d = %d,   %d + %d = %d  →  %d" % [a, up - a, up, up, tot - up, tot, tot - a]
				out.append(["%d +? %d" % [a, tot], tot - a, "%d + ? = %d" % [a, tot], h])
		"teens":
			for u in range(1, 10):
				_pm(out, 10, "+", u)
				_pm(out, u, "+", 10)
				_pm(out, 10 + u, "-", u)
				_pm(out, 10 + u, "-", 10)
		"add20_nobridge":
			for a in range(11, 19):
				for b in range(1, 10 - a % 10): _pm(out, a, "+", b)
		"sub20_nobridge":
			for a in range(11, 20):
				for b in range(1, a % 10 + 1): _pm(out, a, "-", b)
		"add_bridge10":
			for a in range(2, 10):
				for b in range(2, 10):
					if a + b > 10: _pm(out, a, "+", b)
		"sub_bridge10":
			for a in range(11, 19):
				for b in range(a % 10 + 1, 10): _pm(out, a, "-", b)
		"tens":
			for a in range(1, 10):
				for b in range(1, 10):
					if a + b <= 10: _pm(out, a * 10, "+", b * 10)
					if b < a: _pm(out, a * 10, "-", b * 10)
		"add_2d1d":
			for a in range(21, 99):
				if a % 10 == 0: continue
				for b in range(1, 10):
					if (a % 10 + b >= 10) == carry and a + b <= 100: _pm(out, a, "+", b)
		"sub_2d1d":
			for a in range(21, 100):
				if a % 10 == 0 and not carry: continue
				for b in range(1, 10):
					if (b > a % 10) == carry: _pm(out, a, "-", b)
		"pm_2d_tens":
			for a in range(11, 90):
				if a % 10 == 0: continue
				for t in range(10, 90, 10):
					if a + t <= 99: _pm(out, a, "+", t)
					if t < a - 9: _pm(out, a, "-", t)
		"add_2d2d":
			for a in range(11, 90):
				for b in range(11, 90):
					if a % 10 == 0 or b % 10 == 0 or a + b > 100: continue
					if (a % 10 + b % 10 >= 10) == carry: _pm(out, a, "+", b)
		"sub_2d2d":
			for a in range(21, 100):
				for b in range(11, a):
					if b % 10 == 0 or (a % 10 == 0 and not carry): continue
					if (a % 10 < b % 10) == carry and a - b >= 1: _pm(out, a, "-", b)
		"hundreds":
			for a in range(1, 10):
				for b in range(1, 10):
					if a + b <= 10: _pm(out, a * 100, "+", b * 100)
					if b < a: _pm(out, a * 100, "-", b * 100)
		"pm_3d_small":
			for _i in range(500):
				var a := rng.randi_range(101, 989)
				var b: int = [rng.randi_range(2, 9), rng.randi_range(1, 9) * 10, rng.randi_range(11, 99)][rng.randi_range(0, 2)]
				if rng.randf() < 0.5 and a + b <= 999: _pm(out, a, "+", b)
				elif a - b >= 100: _pm(out, a, "-", b)
		"pm_3d3d":
			for _i in range(500):
				var a2 := rng.randi_range(110, 899)
				var b2 := rng.randi_range(101, 799)
				if rng.randf() < 0.5 and a2 + b2 <= 999: _pm(out, a2, "+", b2)
				elif a2 - b2 >= 10: _pm(out, a2, "-", b2)
		"mul_tables":
			var from := int(lv.get("from", 1))
			for t in lv.get("tables", [2]):
				for b in range(from, 11):
					_mul(out, int(t), b)
					_mul(out, b, int(t))
		"squares":
			for a in range(int(lv.get("from", 1)), int(lv.get("max", 10)) + 1): _mul(out, a, a)
		"div_tables":
			for t in lv.get("tables", [2]):
				for b in range(1, 11):
					var n := int(t) * b
					out.append(["%d ÷ %d" % [n, int(t)], b, "%d ÷ %d = ?" % [n, int(t)], "%d × %d = %d" % [int(t), b, n]])
		"mul_tens":
			for a in range(2, 10):
				for b in range(2, 10):
					out.append(["%d × %d" % [a * 10, b], a * b * 10, "%d × %d = ?" % [a * 10, b], "%d × %d = %d, so %d × %d = %d" % [a, b, a * b, a * 10, b, a * b * 10]])
					out.append(["%d × %d" % [a, b * 10], a * b * 10, "%d × %d = ?" % [a, b * 10], "%d × %d = %d, so %d × %d = %d" % [a, b, a * b, a, b * 10, a * b * 10]])
		"pow10":
			for _i in range(300):
				var x := rng.randi_range(2, 99)
				match rng.randi_range(0, 3):
					0: out.append(["%d × 10" % x, x * 10, "%d × 10 = ?" % x, "× 10: every digit moves one place up → %d" % (x * 10)])
					1: out.append(["%d × 100" % x, x * 100, "%d × 100 = ?" % x, "× 100: two places up → %d" % (x * 100)])
					2: out.append(["%d ÷ 10" % (x * 10), x, "%d ÷ 10 = ?" % (x * 10), "÷ 10: one place down → %d" % x])
					3: out.append(["%d ÷ 100" % (x * 100), x, "%d ÷ 100 = ?" % (x * 100), "÷ 100: two places down → %d" % x])
		"mul_2d1d":
			for a in range(11, 50):
				if a % 10 == 0: continue
				for b in range(2, 10):
					var t2 := a - a % 10
					out.append(["%d × %d" % [a, b], a * b, "%d × %d = ?" % [a, b], "%d × %d = %d × %d + %d × %d = %d + %d = %d" % [a, b, t2, b, a % 10, b, t2 * b, (a % 10) * b, a * b]])
		"div_2d1d":
			for d in range(2, 10):
				for q in range(11, 50):
					var n2 := d * q
					if n2 > 99: break
					var big := (q / 10) * 10
					out.append(["%d ÷ %d" % [n2, d], q, "%d ÷ %d = ?" % [n2, d], "%d × %d = %d,   %d - %d = %d,   %d ÷ %d = %d  →  %d" % [big, d, big * d, n2, big * d, n2 - big * d, n2 - big * d, d, q - big, q]])
		"div_rem":
			for d in range(2, 10):
				for q in range(1, 11):
					for rr in range(1, d):
						var n3 := d * q + rr
						if n3 > 99: continue
						out.append(["%d ÷ %d" % [n3, d], "%dR%d" % [q, rr], "%d ÷ %d = ? R ?" % [n3, d], "%d × %d = %d,   %d - %d = %d  →  %d R %d" % [d, q, d * q, n3, d * q, rr, q, rr]])
		"mul_2d2d":
			for a in range(11, 20):
				for b in range(11, 26):
					out.append(["%d × %d" % [a, b], a * b, "%d × %d = ?" % [a, b], "%d × %d = 10 × %d + %d × %d = %d + %d = %d" % [a, b, b, a - 10, b, 10 * b, (a - 10) * b, a * b]])
		"mul_3d1d":
			for _i in range(400):
				var a3 := rng.randi_range(101, 399)
				var b3 := rng.randi_range(2, 6)
				var h3 := a3 - a3 % 100
				out.append(["%d × %d" % [a3, b3], a3 * b3, "%d × %d = ?" % [a3, b3], "%d × %d = %d × %d + %d × %d = %d + %d = %d" % [a3, b3, h3, b3, a3 % 100, b3, h3 * b3, (a3 % 100) * b3, a3 * b3]])
		"div_3d1d":
			for _i in range(400):
				var d4 := rng.randi_range(2, 9)
				var q4 := rng.randi_range(21, 199)
				var n4 := d4 * q4
				if n4 < 100 or n4 > 999: continue
				var q1 := (q4 / 10) * 10
				out.append(["%d ÷ %d" % [n4, d4], q4, "%d ÷ %d = ?" % [n4, d4], "%d × %d = %d,   %d ÷ %d = %d  →  %d" % [d4, q1, d4 * q1, n4 - d4 * q1, d4, q4 - q1, q4]])
		"ten_more", "hundred_more":
			var st := 10 if lv["kind"] == "ten_more" else 100
			for _i in range(300):
				var a5 := rng.randi_range(11, 89) if st == 10 else rng.randi_range(101, 899)
				if rng.randf() < 0.5: out.append(["%d more than %d" % [st, a5], a5 + st, "%d more than %d = ?" % [st, a5], "%d + %d = %d" % [a5, st, a5 + st]])
				elif a5 > st + 1: out.append(["%d less than %d" % [st, a5], a5 - st, "%d less than %d = ?" % [st, a5], "%d - %d = %d" % [a5, st, a5 - st]])
		"double_half", "double_half_big":
			var bigh: bool = lv["kind"] == "double_half_big"
			for a6 in (range(11, 50) if not bigh else range(110, 500, 10)):
				if a6 % (10 if not bigh else 100) == 0: continue
				out.append(["double %d" % a6, a6 * 2, "double %d = ?" % a6, "%d + %d = %d" % [a6, a6, a6 * 2]])
			for n6 in (range(22, 99, 2) if not bigh else range(120, 1000, 20)):
				out.append(["half of %d" % n6, n6 / 2, "half of %d = ?" % n6, "%d + %d = %d" % [n6 / 2, n6 / 2, n6]])
		"round10":
			for a7 in range(11, 100):
				if a7 % 10 == 0: continue
				var lo := a7 - a7 % 10
				var res := lo + 10 if a7 % 10 >= 5 else lo
				out.append(["round %d to tens" % a7, res, "%d rounded to the nearest ten = ?" % a7, "%d is between %d and %d — %s" % [a7, lo, lo + 10, "a 5 or more rounds up" if a7 % 10 >= 5 else "closer to %d" % lo]])
		"round100":
			for _i in range(300):
				var a8 := rng.randi_range(101, 989)
				if a8 % 100 == 0: continue
				var lo8 := a8 - a8 % 100
				var res8 := lo8 + 100 if a8 % 100 >= 50 else lo8
				out.append(["round %d to hundreds" % a8, res8, "%d rounded to the nearest hundred = ?" % a8, "%d is between %d and %d → %d" % [a8, lo8, lo8 + 100, res8]])
		"thousands":
			for a9 in range(1, 10):
				for b9 in range(1, 10):
					if a9 + b9 <= 10: _pm(out, a9 * 1000, "+", b9 * 1000)
					if b9 < a9: _pm(out, a9 * 1000, "-", b9 * 1000)
			for k in range(1, 20): _pm(out, 10000, "-", k * 500)
		"frac_of":
			for d in lv.get("dens", [2]):
				for k2 in range(2, 11):
					out.append(["1/%d of %d" % [int(d), int(d) * k2], k2, "1/%d of %d = ?" % [int(d), int(d) * k2], "%d ÷ %d = %d" % [int(d) * k2, int(d), k2]])
		"frac_of_any":
			for d5 in [3, 4, 5, 6, 8, 10]:
				for num in range(2, d5):
					for k3 in range(2, 11):
						out.append(["%d/%d of %d" % [num, d5, d5 * k3], num * k3, "%d/%d of %d = ?" % [num, d5, d5 * k3], "%d ÷ %d = %d,   %d × %d = %d" % [d5 * k3, d5, k3, k3, num, num * k3]])
		"frac_whole":
			for d6 in range(2, 11):
				for a10 in range(1, d6):
					out.append(["%d/%d +? 1" % [a10, d6], d6 - a10, "%d/%d + ?/%d = 1" % [a10, d6, d6], "1 = %d/%d, and %d - %d = %d" % [d6, d6, d6, a10, d6 - a10]])
		"frac_equiv":
			for f in [[1, 2], [1, 3], [2, 3], [1, 4], [3, 4], [1, 5], [2, 5], [3, 5], [4, 5]]:
				for m2 in range(2, 6):
					out.append(["%d/%d = ?/%d" % [f[0], f[1], f[1] * m2], f[0] * m2, "%d/%d = ?/%d" % [f[0], f[1], f[1] * m2], "%d × %d = %d, so %d × %d = %d" % [f[1], m2, f[1] * m2, f[0], m2, f[0] * m2]])
		"frac_dec":
			for f2 in [[1, 2, "0.5"], [1, 4, "0.25"], [3, 4, "0.75"], [1, 5, "0.2"], [2, 5, "0.4"], [3, 5, "0.6"], [4, 5, "0.8"], [1, 10, "0.1"], [3, 10, "0.3"], [7, 10, "0.7"], [9, 10, "0.9"], [1, 8, "0.125"]]:
				out.append(["%d/%d as a decimal" % [f2[0], f2[1]], f2[2], "%d/%d = ? (as a decimal)" % [f2[0], f2[1]], "%d ÷ %d = %s" % [f2[0], f2[1], f2[2]]])
		"frac_add_same":
			for d7 in range(3, 13):
				for a11 in range(1, d7):
					for b11 in range(1, d7 - a11 + 1):
						out.append(["%d/%d + %d/%d" % [a11, d7, b11, d7], a11 + b11, "%d/%d + %d/%d = ?/%d" % [a11, d7, b11, d7, d7], "same pieces: %d + %d = %d" % [a11, b11, a11 + b11]])
						if a11 > b11: out.append(["%d/%d - %d/%d" % [a11, d7, b11, d7], a11 - b11, "%d/%d - %d/%d = ?/%d" % [a11, d7, b11, d7, d7], "same pieces: %d - %d = %d" % [a11, b11, a11 - b11]])
		"frac_simplify":
			for f3 in [[1, 2], [1, 3], [2, 3], [1, 4], [3, 4], [1, 5], [2, 5], [3, 5], [4, 5], [1, 6], [5, 6]]:
				for m3 in range(2, 5):
					out.append(["%d/%d = ?/%d" % [f3[0] * m3, f3[1] * m3, f3[1]], f3[0], "%d/%d = ?/%d" % [f3[0] * m3, f3[1] * m3, f3[1]], "%d ÷ %d = %d" % [f3[0] * m3, m3, f3[0]]])
		"dec_bonds":
			for t3 in range(1, 10): out.append(["0.%d +? 1" % t3, _dec(1.0 - t3 / 10.0), "0.%d + ? = 1" % t3, "%d tenths + %d tenths = 10 tenths" % [t3, 10 - t3]])
			for q5 in [25, 75, 50]: out.append(["0.%d +? 1" % q5, _dec(1.0 - q5 / 100.0), "0.%d + ? = 1" % q5, "%d hundredths + %d hundredths = 100 hundredths" % [q5, 100 - q5]])
		"dec_pow10":
			for _i in range(300):
				var k4 := rng.randi_range(11, 99)
				if k4 % 10 == 0: continue
				match rng.randi_range(0, 3):
					0: out.append(["%s × 10" % _dec(k4 / 10.0), k4, "%s × 10 = ?" % _dec(k4 / 10.0), "× 10: one place up"])
					1: out.append(["%s × 100" % _dec(k4 / 100.0), k4, "%s × 100 = ?" % _dec(k4 / 100.0), "× 100: two places up"])
					2: out.append(["%d ÷ 10" % k4, _dec(k4 / 10.0), "%d ÷ 10 = ?" % k4, "÷ 10: one place down"])
					3: out.append(["%d ÷ 100" % k4, _dec(k4 / 100.0), "%d ÷ 100 = ?" % k4, "÷ 100: two places down"])
		"pct_easy", "pct_any":
			var ps: Array = [50, 25, 10, 20, 75] if lv["kind"] == "pct_easy" else [5, 15, 30, 35, 40, 45, 60, 70, 80, 90]
			for p in ps:
				for n7 in range(20, 410, 20):
					if (int(p) * n7) % 100 != 0: continue
					out.append(["%d%% of %d" % [int(p), n7], int(p) * n7 / 100, "%d%% of %d = ?" % [int(p), n7], "1%% of %d = %s,  so %d%% = %d" % [n7, _dec(n7 / 100.0), int(p), int(p) * n7 / 100]])
		"dec_pm":
			for _i in range(400):
				var x1 := rng.randi_range(1, 99) / 4.0 if rng.randf() < 0.4 else rng.randi_range(5, 95) / 10.0
				var x2 := rng.randi_range(1, 40) / 4.0 if rng.randf() < 0.4 else rng.randi_range(1, 50) / 10.0
				if rng.randf() < 0.5: out.append(["%s + %s" % [_dec(x1), _dec(x2)], _dec(x1 + x2), "%s + %s = ?" % [_dec(x1), _dec(x2)], "whole numbers first, then the decimals"])
				elif x1 > x2: out.append(["%s - %s" % [_dec(x1), _dec(x2)], _dec(x1 - x2), "%s - %s = ?" % [_dec(x1), _dec(x2)], "whole numbers first, then the decimals"])
		"units_time":
			for k5 in range(1, 6):
				out.append(["minutes in %d h" % k5, 60 * k5, "%d h = ? min" % k5, "1 h = 60 min"])
				out.append(["seconds in %d min" % k5, 60 * k5, "%d min = ? s" % k5, "1 min = 60 s"])
				out.append(["%d min in h" % (60 * k5), k5, "%d min = ? h" % (60 * k5), "60 min = 1 h"])
			for k6 in range(1, 4):
				out.append(["hours in %d days" % k6, 24 * k6, "%d days = ? h" % k6, "1 day = 24 h"])
				out.append(["days in %d weeks" % k6, 7 * k6, "%d weeks = ? days" % k6, "1 week = 7 days"])
				out.append(["months in %d years" % k6, 12 * k6, "%d years = ? months" % k6, "1 year = 12 months"])
		"units_length", "units_mass":
			var pairs: Array = [["m", "cm", 100], ["cm", "mm", 10], ["km", "m", 1000]] if lv["kind"] == "units_length" else [["kg", "g", 1000], ["t", "kg", 1000], ["l", "ml", 1000], ["l", "dl", 10]]
			for pr in pairs:
				for k7 in range(1, 10):
					out.append(["%d %s in %s" % [k7, pr[0], pr[1]], k7 * int(pr[2]), "%d %s = ? %s" % [k7, pr[0], pr[1]], "1 %s = %d %s" % [pr[0], int(pr[2]), pr[1]]])
					out.append(["%d %s in %s" % [k7 * int(pr[2]), pr[1], pr[0]], k7, "%d %s = ? %s" % [k7 * int(pr[2]), pr[1], pr[0]], "%d %s = 1 %s" % [int(pr[2]), pr[1], pr[0]]])
		"units_mixed":
			for _i in range(200):
				match rng.randi_range(0, 3):
					0:
						var h7 := rng.randi_range(1, 4)
						var m7 := rng.randi_range(1, 11) * 5
						out.append(["%d h %d min" % [h7, m7], h7 * 60 + m7, "%d h %d min = ? min" % [h7, m7], "%d × 60 = %d,  + %d" % [h7, h7 * 60, m7]])
					1:
						var a12 := rng.randi_range(1, 9)
						var b12 := rng.randi_range(1, 99)
						out.append(["%d m %d cm" % [a12, b12], a12 * 100 + b12, "%d m %d cm = ? cm" % [a12, b12], "%d m = %d cm,  + %d" % [a12, a12 * 100, b12]])
					2:
						var a13 := rng.randi_range(1, 9)
						var b13 := rng.randi_range(1, 9) * 100
						out.append(["%d kg %d g" % [a13, b13], a13 * 1000 + b13, "%d kg %d g = ? g" % [a13, b13], "%d kg = %d g,  + %d" % [a13, a13 * 1000, b13]])
					3:
						var a14 := rng.randi_range(1, 5)
						var b14 := rng.randi_range(1, 19) * 50
						out.append(["%d km %d m" % [a14, b14], a14 * 1000 + b14, "%d km %d m = ? m" % [a14, b14], "%d km = %d m,  + %d" % [a14, a14 * 1000, b14]])
		"money":
			for c in range(105, 1000, 5):
				if c % 20 == 0 or c % 15 == 0:
					out.append(["%s Fr. in Rp." % _money(c), c, "%s Fr. = ? Rp." % _money(c), "1 Fr. = 100 Rp."])
					out.append(["%d Rp. in Fr." % c, _dec(c / 100.0), "%d Rp. = ? Fr." % c, "100 Rp. = 1 Fr."])
		"pow2":
			var v := 1
			for e2 in range(1, 11):
				v *= 2
				out.append(["2^%d" % e2, v, "2^%d = ?  (2 × 2 × … %d times)" % [e2, e2], "2^%d = 2 × 2^%d = %d" % [e2, e2 - 1, v]])
		"neg_pm", "neg_pm_big":
			var big2: bool = lv["kind"] == "neg_pm_big"
			for _i in range(300):
				var a15 := rng.randi_range(-9, 9) if not big2 else rng.randi_range(-60, 60)
				var b15 := rng.randi_range(1, 9) if not big2 else rng.randi_range(10, 60)
				var plus := rng.randf() < 0.5
				var res15 := a15 + b15 if plus else a15 - b15
				if a15 >= 0 and res15 >= 0: continue
				var t15 := "%d %s %d" % [a15, "+" if plus else "-", b15]
				out.append([t15, res15, t15 + " = ?", "on the number line: start at %d, go %d %s" % [a15, b15, "right" if plus else "left"]])
		"roots":
			for a16 in range(1, 21): out.append(["√%d" % (a16 * a16), a16, "√%d = ?" % (a16 * a16), "%d × %d = %d" % [a16, a16, a16 * a16]])
	return out

## A plus or minus task, with a hint how to work it out (over the ten, tens first).
func _pm(out: Array, a: int, op: String, b: int) -> void:
	var key := "%d %s %d" % [a, op, b]
	out.append([key, a + b if op == "+" else a - b, key + " = ?", pm_hint(a, op, b)])

## 8 + 5 → "8 + 2 = 10,  10 + 3 = 13";  32 - 17 → "32 - 10 = 22,  22 - 7 = 15";  246 + 138 → hundreds, tens, ones.
static func pm_hint(a: int, op: String, b: int) -> String:
	if op == "+":
		var s := a + b
		if b >= 100 and b % 100 != 0:
			var h := b - b % 100
			return "%d + %d = %d,   %d + %d = %d" % [a, h, a + h, a + h, b - h, s]
		if b >= 10 and b % 10 != 0:
			var t := b - b % 10
			return "%d + %d = %d,   %d + %d = %d" % [a, t, a + t, a + t, b % 10, s]
		if b < 10 and a % 10 + b > 10:
			var up := 10 - a % 10
			return "%d + %d = %d,   %d + %d = %d" % [a, up, a + up, a + up, b - up, s]
		return "%d + %d = %d" % [a, b, s]
	var d := a - b
	if b >= 100 and b % 100 != 0:
		var h2 := b - b % 100
		return "%d - %d = %d,   %d - %d = %d" % [a, h2, a - h2, a - h2, b - h2, d]
	if b >= 10 and b % 10 != 0:
		var t2 := b - b % 10
		return "%d - %d = %d,   %d - %d = %d" % [a, t2, a - t2, a - t2, b % 10, d]
	if b < 10 and a > 10 and a % 10 != 0 and b > a % 10:
		var dn := a % 10
		return "%d - %d = %d,   %d - %d = %d" % [a, dn, a - dn, a - dn, b - dn, d]
	return "%d - %d = %d" % [a, b, d]

## A times task with a hint from the easy ones (× 2, × 5, × 10): 7 × 8 → "5 × 7 = 35,  3 × 7 = 21,  35 + 21 = 56".
func _mul(out: Array, a: int, b: int) -> void:
	var key := "%d × %d" % [a, b]
	var p := a * b
	var h := "%d × %d = %d" % [a, b, p]
	var big := maxi(a, b)
	var other := mini(a, b)
	if big == 9 and other > 1: h = "10 × %d = %d,   %d - %d = %d" % [other, 10 * other, 10 * other, other, p]
	elif big >= 6 and big <= 8 and other > 2 and other != 5: h = "5 × %d = %d,   %d × %d = %d,   %d + %d = %d" % [other, 5 * other, big - 5, other, (big - 5) * other, 5 * other, (big - 5) * other, p]
	elif big == 4 or other == 4: h = "2 × %d = %d, doubled: %d" % [p / 4, p / 2, p]
	elif big == 3 or other == 3: h = "2 × %d = %d,   + %d = %d" % [p / 3, 2 * (p / 3), p / 3, p]
	out.append([key, p, key + " = ?", h])

static func _dec(x: float) -> String:
	var s := "%.3f" % x
	while s.ends_with("0"): s = s.substr(0, s.length() - 1)
	if s.ends_with("."): s = s.substr(0, s.length() - 1)
	return s

static func _money(rappen: int) -> String:
	return "%d.%02d" % [rappen / 100, rappen % 100]
