## LearnKit · question packs with spaced repetition: picks the next multiple-choice question, lays it out (3–4 options,
## pictures, translations) and remembers how it went.
##
## A question (in a pack file or anywhere else) is a Dictionary:
##   "id"       unique and never changed (e.g. "CON-003"): the key in the learning record and in translation files
##   "q"        the question text;  "img" / "emoji": an optional picture shown above it
##   "answers"  the options: text ("Europe") or {"text", "img", "emoji"} for a picture answer; "correct" = index of the right one
##   "right" / "wrong" / "why"   optional feedback lines
## A pack may have a "pool" of extra wrong answers of the same kind (all continents …); a question with fewer wrong answers
## than needed is filled up from it (unless it says "pool": false).
##
##   var Q = preload("res://learnkit/quiz_engine.gd").new()
##   var i = Q.pick(L, candidates, rng)                 # candidates: the questions that may come now
##   var shown = Q.present(candidates[i], rng, 4, Q.load_texts("res://data/i18n/quiz-de.json"))
##   ... show shown["q"], shown["answers"] (each {"text", "img", "emoji"}), shown["correct"] …
##   Q.record(L, Q.key(candidates[i]), first_try)
##
## A question answered wrong comes back after 3 others; right at the first try it waits 12, 32, 80, 200, 480 questions.
## New questions come before known ones most of the time (unseenShare).
extends RefCounted

const Srs = preload("srs.gd")

var cfg := {"gaps": [12, 32, 80, 200, 480], "wrongAfter": 3, "slowAfter": 3, "knownBox": 3, "unseenShare": 0.7}

func rec(L: Dictionary) -> Dictionary:
	if not L.has("quiz") or typeof(L["quiz"]) != TYPE_DICTIONARY: L["quiz"] = {"n": 0, "items": {}}
	if not L["quiz"].has("items"): L["quiz"]["items"] = {}
	return L["quiz"]

## The key of a question in the learning record: its id (older questions without one: the text).
static func key(q: Dictionary) -> String:
	var id := str(q.get("id", ""))
	return id if id != "" else str(q.get("q", ""))

## Index into candidates: a question whose turn is due, else (mostly) a new one, else any.
func pick(L: Dictionary, candidates: Array, rng: RandomNumberGenerator) -> int:
	if candidates.is_empty(): return -1
	var r := rec(L)
	var n := int(r.get("n", 0))
	var due := -1
	var due_at := 1 << 30
	var unseen := []
	for i in range(candidates.size()):
		var k := key(candidates[i])
		if r["items"].has(k):
			var d := int(r["items"][k].get("due", 1 << 30))
			if d <= n and d < due_at:
				due = i
				due_at = d
		else:
			unseen.append(i)
	if due >= 0: return due
	if not unseen.is_empty() and rng.randf() < float(cfg.get("unseenShare", 0.7)): return unseen[rng.randi_range(0, unseen.size() - 1)]
	return rng.randi_range(0, candidates.size() - 1)

func record(L: Dictionary, k: String, first_try: bool) -> void:
	if k == "": return
	var r := rec(L)
	r["n"] = int(r.get("n", 0)) + 1
	var it: Dictionary = r["items"].get(k, Srs.new_item())
	Srs.schedule(it, "right" if first_try else "wrong", int(r["n"]), cfg)
	r["items"][k] = it

## Moves records kept under old keys (the question text) to the new ones (the id). map: {old key: new key}.
func rekey(L: Dictionary, map: Dictionary) -> int:
	var items: Dictionary = rec(L)["items"]
	var moved := 0
	for old in items.keys():
		if map.has(old) and str(map[old]) != str(old) and not items.has(map[old]):
			items[map[old]] = items[old]
			items.erase(old)
			moved += 1
	return moved

## {"seen", "known"} for a report.
func stats(L: Dictionary) -> Dictionary:
	var r := rec(L)
	var known := 0
	for k in r["items"]:
		if int(r["items"][k].get("box", 0)) >= int(cfg["knownBox"]): known += 1
	return {"seen": r["items"].size(), "known": known}

## How well one question is known: "new", "learning" (box 0–1), "good" (box 2) or "known" (box 3 or more).
func mastery(L: Dictionary, k: String) -> String:
	var it = rec(L)["items"].get(k, null)
	if it == null: return "new"
	var b := int(it.get("box", 0))
	return "known" if b >= int(cfg["knownBox"]) else ("good" if b >= 2 else "learning")

# ------------------------------------------------------------------ laying a question out

## A translation file: {"<id>": {"q", "answers": [...], "right", "wrong", "why"}}; empty strings = not translated yet.
static func load_texts(path: String) -> Dictionary:
	if path == "" or not FileAccess.file_exists(path): return {}
	var d = JSON.parse_string(FileAccess.get_file_as_string(path))
	return d if typeof(d) == TYPE_DICTIONARY else {}

static func _answer(a) -> Dictionary:
	if typeof(a) == TYPE_DICTIONARY:
		return {"text": str(a.get("text", "")), "img": str(a.get("img", "")), "emoji": str(a.get("emoji", ""))}
	return {"text": str(a), "img": "", "emoji": ""}

static func _tr(t: Dictionary, field: String, fallback: String) -> String:
	var s := str(t.get(field, ""))
	return s if s != "" else fallback

## The question ready to show: the right answer and up to (options − 1) wrong ones in a random order, the texts in the
## chosen language (tr from load_texts; missing texts stay in the original). pool: extra wrong answers (the pack's).
## Returns {"id", "q", "img", "emoji", "answers": [{"text", "img", "emoji"}], "correct", "right", "wrong", "why", "pictures"}
## ("pictures" = every answer has a picture, so they can be shown as picture buttons).
static func present(src: Dictionary, rng: RandomNumberGenerator, options: int = 4, tr: Dictionary = {}, pool: Array = []) -> Dictionary:
	var t: Dictionary = tr.get(str(src.get("id", "")), {}) if typeof(tr.get(str(src.get("id", "")), {})) == TYPE_DICTIONARY else {}
	var tans: Array = t.get("answers", []) if typeof(t.get("answers", [])) == TYPE_ARRAY else []
	var raw: Array = src.get("answers", [])
	var corr := int(src.get("correct", 0))
	var all := []
	for i in range(raw.size()):
		var a := _answer(raw[i])
		if i < tans.size() and str(tans[i]) != "": a["text"] = str(tans[i])
		all.append(a)
	var right: Dictionary = all[corr] if corr < all.size() else {"text": "?", "img": "", "emoji": ""}
	var wrong := []
	for i in range(all.size()):
		if i != corr: wrong.append(all[i])
	# fill up from the pack's pool (same kind of answer), never with the right answer or a double
	if wrong.size() < options - 1 and src.get("pool", true) != false:
		var have := {right["text"]: true}
		for w in wrong: have[w["text"]] = true
		var extra := []
		for p in pool:
			var a := _answer(p)
			if not have.has(a["text"]): extra.append(a); have[a["text"]] = true
		_shuffle(extra, rng)
		while wrong.size() < options - 1 and not extra.is_empty(): wrong.append(extra.pop_back())
	_shuffle(wrong, rng)
	var shown := [right]
	for j in range(mini(maxi(1, options - 1), wrong.size())): shown.append(wrong[j])
	_shuffle(shown, rng)
	var pics := true
	var ci := 0
	for i in range(shown.size()):
		if is_same(shown[i], right): ci = i
		if shown[i]["img"] == "" and shown[i]["emoji"] == "": pics = false
	return {"id": str(src.get("id", "")), "q": _tr(t, "q", str(src.get("q", ""))), "img": str(src.get("img", "")),
		"emoji": str(src.get("emoji", "")), "answers": shown, "correct": ci,
		"right": _tr(t, "right", str(src.get("right", ""))), "wrong": _tr(t, "wrong", str(src.get("wrong", ""))),
		"why": _tr(t, "why", str(src.get("why", ""))), "pictures": pics}

static func _shuffle(a: Array, rng: RandomNumberGenerator) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var x = a[i]
		a[i] = a[j]
		a[j] = x
