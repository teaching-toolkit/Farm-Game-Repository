extends Node
## Farm Quiz Game — rules engine (autoload "Game").
## Reads res://data/farm-progression.json and runs everything: time (one Time Quiz answer = one step),
## energy & Rest, fields, crops, weeds, frost stones, pests, animals & muck, stations & firewood,
## knowledge cards & the library, polish (endless upgrades), gear, seasons & freshness, luck,
## gift cards, little jobs, golden acorns and the album.
## Every amount is a float in the background; the UI rounds (stocks down, costs up).

signal changed
signal toast(text: String)
signal step_done(info: Dictionary)
signal offer_cards(cards: Array)
signal ask_name(pet_id: String, default_name: String)
## Something arrived: source = "patch:<area>:<i>", "animal:<id>", "recipe:<id>", "node:<id>" or "water";
## got = {item: amount} that went into the store, lost = {item: amount} that did not fit (the store is full).
## The map lets the things fly to the store (one picture per piece); what did not fit bounces off.
signal gained(source: String, got: Dictionary, lost: Dictionary)
signal sold(item: String, n: float, coins: float)   # coins fly to the purse (perk), a jingle
signal celebrate(id: String)     # a new building, tool or helper: the big pop-up with confetti

const SAVE_PATH := "user://farm_save.json"          # the farm from before players had names
const PLAYERS_DIR := "user://players"               # players/<name>/farm_save.json and learning.json
const LAST_PLAYER := "user://last_player.txt"
const DATA_PATH := "res://data/farm-progression.json"
const NOT_AUTO := ["pet", "delivery", "animal", "sidequest", "knowledge", "polish", "book"]
const DEFAULT_CAT := {"land": "field", "patch": "field", "building": "build", "station": "build", "helper": "build",
	"tool": "craft", "gear": "craft", "polish": "craft", "delivery": "errand", "pet": "errand", "sidequest": "errand",
	"animal": "errand", "crop": "errand", "merchant": "errand", "book": "errand", "knowledge": "errand"}
const MAIN_TYPES := ["building", "station", "tool", "land", "patch", "delivery", "pet", "knowledge", "book"]
const STEP_GAPS := [12, 40, 100, 250]     # Time Quiz answers between card reviews per Leitner box
const DAY_GAPS := [1, 3, 7, 21]           # …or real days, whichever comes first
const SEASON_NAMES := ["spring", "summer", "autumn", "winter"]
const CARRY_CATS := ["gather"]            # recipes whose loads grow with carrying gear (effect "carry")

var D: Dictionary = {}
var items: Dictionary = {}
var nodes: Dictionary = {}
var recipes: Dictionary = {}
var meta: Dictionary = {}
var settings: Dictionary = {}
var packs: Array = []
var pack_questions: Array = []
var pack_pools: Dictionary = {}      # pack code -> extra wrong answers of the same kind (fill questions up to quizOptions)
var quiz_tr: Dictionary = {}         # translations of the quiz texts by question id (data/i18n/quiz-<language>.json)
var quiz_keys: Dictionary = {}       # old learning-record key (question text) -> question id
var tags: Dictionary = {}
var replaced_by: Dictionary = {}
var station_recipes: Dictionary = {}
var polish_ids: Array = []
var card_ids: Array = []
var rng := RandomNumberGenerator.new()
const Learner = preload("res://learnkit/learner.gd")
var math = preload("res://learnkit/math_engine.gd").new()   # Rest sums: curriculum, spaced repetition, medals (learnkit)
var quiz = preload("res://learnkit/quiz_engine.gd").new()   # Time Quiz questions: spaced repetition (learnkit)
var learner = Learner.new()                                 # the player's learning record (a JSON file anyone can open)

var S: Dictionary = {}
var player := ""                 # who is playing: their own farm and their own learning record
var L: Dictionary = {}           # the learning record (Rest sums, Time Quiz questions): kept when a new game starts
var _caps = null
var _overflow := {}       # what did not fit into the store since the last gained signal
var _produced := 0.0      # worth of what came in since the last Time Quiz question (for the pace, dynamic difficulty)
var _buying := false      # bought things are not "produced"

func _ready() -> void:
	rng.randomize()
	load_data()
	var last := ""
	if FileAccess.file_exists(LAST_PLAYER): last = FileAccess.get_file_as_string(LAST_PLAYER).strip_edges()
	if last != "" and players().has(last):
		set_player(last)
	elif not load_game():
		new_game()

# ------------------------------------------------------------------ players
static func slug(n: String) -> String:
	var out := ""
	for ch in n.strip_edges().to_lower():
		out += ch if (ch >= "a" and ch <= "z") or (ch >= "0" and ch <= "9") else "_"
	return out if out.strip_edges() != "" else "player"

func save_path() -> String:
	return SAVE_PATH if player == "" else "%s/%s/farm_save.json" % [PLAYERS_DIR, slug(player)]

func learn_path() -> String:
	return "%s/%s/learning.json" % [PLAYERS_DIR, slug(player)]

## The names of everyone who has played on this device.
func players() -> Array:
	var out := []
	var dir := DirAccess.open(PLAYERS_DIR)
	if dir == null: return out
	for sub in dir.get_directories():
		var p := "%s/%s/learning.json" % [PLAYERS_DIR, sub]
		if not FileAccess.file_exists(p): continue
		var d = JSON.parse_string(FileAccess.get_file_as_string(p))
		if typeof(d) == TYPE_DICTIONARY and d.has("name"): out.append(str(d["name"]))
	return out

## Switch to a player (a new name starts a new farm; the very first name takes over the farm played before names existed).
func set_player(name: String) -> void:
	var first := players().is_empty()
	player = name.strip_edges()
	DirAccess.make_dir_recursive_absolute("%s/%s" % [PLAYERS_DIR, slug(player)])
	learner.open(learn_path(), player)
	L = learner.data
	quiz.rekey(L, quiz_keys)
	if first and not FileAccess.file_exists(save_path()) and FileAccess.file_exists(SAVE_PATH):
		var f := FileAccess.open(save_path(), FileAccess.WRITE)
		if f: f.store_string(FileAccess.get_file_as_string(SAVE_PATH))
	if not load_game(): new_game()
	S.erase("rest_srs"); S.erase("rest_n")
	save_learning()
	var lf := FileAccess.open(LAST_PLAYER, FileAccess.WRITE)
	if lf: lf.store_string(player)
	changed.emit()

func save_learning() -> void:
	if player == "": return
	learner.data = L
	learner.save()

func _learn() -> Dictionary:
	if L.is_empty():
		learner.open(learn_path() if player != "" else "", player)
		L = learner.data
		quiz.rekey(L, quiz_keys)
	return L

# ------------------------------------------------------------------ data
func load_data() -> void:
	var txt := FileAccess.get_file_as_string(DATA_PATH)
	D = JSON.parse_string(txt)
	items = D["items"]; nodes = D["nodes"]; recipes = D["recipes"]; meta = D["meta"]
	tags.clear(); replaced_by.clear(); station_recipes.clear(); polish_ids.clear(); card_ids.clear()
	for iid in items:
		for t in items[iid].get("tags", []):
			if not tags.has(t): tags[t] = []
			tags[t].append(iid)
	for nid in nodes:
		var n = nodes[nid]
		if n.has("replaces"): replaced_by[n["replaces"]] = nid
		if n["type"] == "polish": polish_ids.append(nid)
		if n["type"] == "knowledge": card_ids.append(nid)
	for rid in recipes:
		var st = recipes[rid]["station"]
		if not station_recipes.has(st): station_recipes[st] = []
		station_recipes[st].append(rid)
	settings = {"activePacks": [], "wrongAnswer": "retry", "avoidRepeatWithin": 3, "knowledgeReviewShare": 0.25, "restMaxNumber": 20, "restOps": ["+", "-"], "showCheatButton": true}
	if FileAccess.file_exists("res://data/settings.json"):
		var st2 = JSON.parse_string(FileAccess.get_file_as_string("res://data/settings.json"))
		if typeof(st2) == TYPE_DICTIONARY:
			for k in st2: settings[k] = st2[k]
	math.load_curriculum(str(settings.get("mathCurriculum", "res://learnkit/curriculum/math.json")))
	packs.clear(); pack_questions.clear(); pack_pools.clear(); quiz_keys.clear()
	var lang := str(settings.get("language", "en"))
	quiz_tr = {} if lang == "en" else quiz.load_texts("res://data/i18n/quiz-%s.json" % lang)
	var dir := DirAccess.open("res://data/quiz_packs")
	if dir:
		for f in dir.get_files():
			if not f.ends_with(".json"): continue
			var p = JSON.parse_string(FileAccess.get_file_as_string("res://data/quiz_packs/" + f))
			if typeof(p) != TYPE_DICTIONARY: continue
			packs.append(p)
			var code := str(p.get("code", p.get("id", "")))
			if p.has("pool"):
				var tp = quiz_tr.get(code + "-POOL", {})
				var tpool: Array = tp.get("answers", []) if typeof(tp) == TYPE_DICTIONARY else []
				var pool: Array = p["pool"].duplicate()
				for i in range(mini(pool.size(), tpool.size())):
					if str(tpool[i]) != "": pool[i] = tpool[i]
				pack_pools[code] = pool
			var active: Array = settings.get("activePacks", [])
			for q in p.get("questions", []):
				q["pack"] = code
				quiz_keys[str(q.get("q", ""))] = quiz.key(q)
				if active.is_empty() or active.has(p.get("id", "")):
					pack_questions.append(q)
	if pack_questions.is_empty():
		pack_questions.append({"id": "X-001", "q": "Which planet do we live on?", "answers": ["Earth", "Mars", "the Moon"], "correct": 0})
	for cid in card_ids:
		for q in nodes[cid].get("questions", []): quiz_keys[str(q.get("q", ""))] = quiz.key(q)

func new_game() -> void:
	var st: Dictionary = D["start"]
	S = {
		"step": 0, "coins": float(st.get("coins", 0)), "water": float(st.get("water", 10)), "energy": float(st.get("energy", 10)),
		"inv": {}, "seen": {}, "seeds": {}, "unlocked": {}, "polish": {}, "attach": {},
		"patches": [], "orchard": [], "gh": [], "animals": {}, "running": {}, "woodpile": 0.0, "pests": 0.0,
		"reading": "", "read_progress": 0.0, "read_done": {}, "cards": {}, "card_qseen": {},
		"buff": {}, "luck_boosts": [], "gift_owned": [], "gift_shop": [], "gift_seen": [], "gift_pending": [], "goals": 0,
		"jobs": [], "practice": {}, "acorns": {}, "album": [], "pet_names": {},
		"stats": {"weeds": 0.0, "stones": 0.0, "sidequests": 0, "harvests": 0, "rest": 0}, "last_season": 0,
		"cold": false, "rain": false, "recent_q": [], "log": [], "gift_active": [], "step_ready": {}, "open_early": {}, "early_patches": {},
		"postcards": [], "perks": {}, "sold_kinds": {}, "market": {},
	}
	for nid in st.get("unlocked", []): S["unlocked"][nid] = true
	for k in st.get("inventory", {}): add_item(k, float(st["inventory"][k]), true)
	for k in st.get("seeds", {}): S["seeds"][k] = float(st["seeds"][k])
	_dirty()
	_auto_unlocks()
	_ensure_areas()
	# the patches that are already cleared at the start still have a few weeds and a stone on them
	for i in range(mini(plots(), S["patches"].size())):
		S["patches"][i]["weeds"] = float(st.get("patchWeeds", 0)) + float(i % 2)
		S["patches"][i]["stones"] = float(st.get("patchStones", 0))
	_refill_jobs()
	save_game()

func save_game() -> void:
	var f := FileAccess.open(save_path(), FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(S))
	save_learning()

func load_game() -> bool:
	if not FileAccess.file_exists(save_path()): return false
	var d = JSON.parse_string(FileAccess.get_file_as_string(save_path()))
	if typeof(d) != TYPE_DICTIONARY or not d.has("unlocked"): return false
	S = d
	S["step"] = int(S["step"])
	S["last_season"] = int(S.get("last_season", 0))
	for k in ["step_ready", "open_early", "early_patches", "perks", "sold_kinds", "market"]:
		if not S.has(k): S[k] = {}
	if not S.has("postcards"): S["postcards"] = []
	# gift cards from before: offers waiting become postcards from "a friend"; the gift shop is gone
	var gp := []
	for x in S.get("gift_pending", []):
		if typeof(x) == TYPE_ARRAY: gp.append({"from": "A friend", "emoji": "💌", "text": "A little something for your farm!", "offer": x, "step": S["step"]})
		elif typeof(x) == TYPE_DICTIONARY: gp.append(x)
	S["gift_pending"] = gp
	S["gift_shop"] = []
	if not S.has("gift_active"):   # saves from before: the first cards owned are the ones that work
		var mx := int(meta.get("giftCards", {}).get("maxActive", 2))
		S["gift_active"] = (S["gift_owned"] as Array).slice(0, mx)
	# saves from an older version: things everyone starts with (the muddy road …) are added
	for nid in D["start"].get("unlocked", []):
		if nodes.has(nid) and not satisfied(nid): S["unlocked"][nid] = true
	_dirty()
	_ensure_areas()
	return true

func reset_game() -> void:
	if FileAccess.file_exists(save_path()):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path()))
	new_game()
	changed.emit()

func say(t: String) -> void:
	S["log"].append(t)
	if S["log"].size() > 40: S["log"].pop_front()
	toast.emit(t)

# ------------------------------------------------------------------ names & numbers
func iname(k: String) -> String:
	if k.begins_with("tag:"): return "any " + k.substr(4).replace("-", " ")
	return items[k]["name"] if items.has(k) else (nodes[k]["name"] if nodes.has(k) else k)

func iemoji(k: String) -> String:
	if k.begins_with("tag:"):
		var opts: Array = tag_choices(k.substr(4))
		for o in opts:
			if count(o) >= 1.0: return items[o].get("emoji", "✳️")
		return items[opts[0]].get("emoji", "✳️") if opts.size() > 0 else "✳️"
	if k == "coins": return "🪙"
	if k == "energy": return "⚡"
	if k == "water": return "💧"
	if k == "read": return "📖"
	return items[k].get("emoji", "•") if items.has(k) else (nodes[k].get("emoji", "•") if nodes.has(k) else "•")

func down(x: float) -> int:
	return int(floorf(x + 0.000001))

func up(x: float) -> int:
	return int(ceilf(x - 0.000001))

# ------------------------------------------------------------------ effects
func _dirty() -> void:
	_caps = null

func superseded(id: String) -> bool:
	var r = replaced_by.get(id, "")
	return r != "" and S["unlocked"].has(r)

func satisfied(id: String) -> bool:
	var cur := id
	var guard := 0
	while cur != "" and guard < 20:
		if S["unlocked"].has(cur): return true
		cur = replaced_by.get(cur, "")
		guard += 1
	return false

func done(id: String) -> bool:
	return S["unlocked"].has(id)

func _apply(e: Dictionary, g: float, st: Dictionary, ad: Dictionary, mu: Dictionary, pr: Dictionary) -> void:
	for k in e.get("set", {}):
		st[k] = e["set"][k]
	for k in e.get("add", {}):
		ad[k] = ad.get(k, 0.0) + float(e["add"][k]) * g
	for k in e.get("mult", {}):
		var v := 1.0 - (1.0 - float(e["mult"][k])) * g
		mu[k] = mu.get(k, 1.0) * v
	for k in e.get("produces", {}):
		pr[k] = pr.get(k, 0.0) + float(e["produces"][k]) * g

func caps() -> Dictionary:
	if _caps != null: return _caps
	var st := {}; var ad := {}; var mu := {}; var pr := {}
	for id in S["unlocked"]:
		if not nodes.has(id) or superseded(id): continue
		var n = nodes[id]
		if n["type"] == "polish": continue
		if n.has("attach") and S["attach"].get(n["attach"], id) != id: continue
		if n.has("effects"): _apply(n["effects"], 1.0, st, ad, mu, pr)
	for pid in S["polish"]:
		var p := float(S["polish"][pid])
		if p <= 0.0 or not nodes.has(pid): continue
		_apply(nodes[pid].get("effects", {}), 1.0 - pow(0.5, p), st, ad, mu, pr)
	for gid in S.get("gift_active", S["gift_owned"]):
		var gc := gift_card(gid)
		if not gc.is_empty(): _apply(gc.get("effects", {}), 1.0, st, ad, mu, pr)
	_caps = {"set": st, "add": ad, "mult": mu, "produces": pr}
	return _caps

func m(k: String) -> float:
	return float(caps()["mult"].get(k, 1.0))

func g(k: String, d: float = 0.0) -> float:
	var c := caps()
	return float(c["set"].get(k, d)) + float(c["add"].get(k, 0.0))

func energy_max() -> float:
	return g("energyMax", 20.0) + 3.0 * S["acorns"].size()

func water_cap() -> float:
	return g("waterCap", 20.0)

func storage_cap() -> float:
	return g("storageCap", 10.0)

func rest_per_answer() -> float:
	var v := g("energyPerRest", 5.0)
	if S.get("cold", false): v *= float(meta.get("rest", {}).get("coldHouseMult", 0.75))
	return v

func chapter() -> int:
	var c := 1
	for pid in ["pet_bunny", "pet_tortoise", "pet_goat", "pet_pony"]:
		if done(pid): c += 1
	return mini(c, 5)

# ------------------------------------------------------------------ seasons
func season_len() -> int:
	return int(meta.get("seasons", {}).get("lengthQuestions", 30))

func season_no() -> int:
	return int(S["step"] / season_len())

func season() -> String:
	return SEASON_NAMES[season_no() % 4]

func smod(k: String, d = 1.0):
	return meta.get("seasons", {}).get("mods", {}).get(season(), {}).get(k, d)

func season_emoji() -> String:
	return str(smod("emoji", "🌱"))

func questions_left_in_season() -> int:
	return season_len() - (S["step"] % season_len())

# ------------------------------------------------------------------ inventory (batches remember the season they arrived in)
func count(k: String) -> float:
	var t := 0.0
	for b in S["inv"].get(k, []): t += float(b[1])
	return t

func count_tag(t: String) -> float:
	var s := 0.0
	for k in tags.get(t, []): s += count(k)
	return s

func have(k: String) -> float:
	if k.begins_with("tag:"): return count_tag(k.substr(4))
	if k == "coins": return S["coins"]
	if k == "energy": return S["energy"]
	if k == "water": return S["water"]
	return count(k)

func add_item(k: String, q: float, quiet := false) -> float:
	if q <= 0.0 or not items.has(k): return 0.0
	var cap := storage_cap()
	var room := cap - count(k)
	var put := q if (items[k].get("category", "") in ["keeper"]) else minf(q, maxf(0.0, room))
	if put < q - 0.001:
		_overflow[k] = float(_overflow.get(k, 0.0)) + q - put
		if not quiet: say("🧺 Storage full: %d %s didn't fit. (Bigger store = more room.)" % [up(q - put), iname(k)])
	if put <= 0.0: return 0.0
	if not _buying: _produced += put * flex_worth(k)
	if not S["inv"].has(k): S["inv"][k] = []
	var arr: Array = S["inv"][k]
	var sn := season_no()
	if arr.size() > 0 and int(arr[arr.size() - 1][0]) == sn:
		arr[arr.size() - 1][1] = float(arr[arr.size() - 1][1]) + put
	else:
		arr.append([sn, put])
	S["seen"][k] = true
	return put

## Tells the map what arrived (and what bounced off a full store).
func _gained(source: String, got: Dictionary) -> void:
	var lost := _overflow
	_overflow = {}
	gained.emit(source, got, lost)

func take(k: String, q: float) -> bool:
	if q <= 0.0: return true
	if k.begins_with("tag:"): return take_tag(k.substr(4), q)
	if k == "coins":
		if S["coins"] + 0.0001 < q: return false
		S["coins"] -= q; return true
	if count(k) + 0.0001 < q: return false
	var arr: Array = S["inv"][k]
	var left := q
	while left > 0.00001 and arr.size() > 0:
		var b = arr[0]
		var use := minf(float(b[1]), left)
		b[1] = float(b[1]) - use
		left -= use
		if float(b[1]) <= 0.00001: arr.pop_front()
	if arr.is_empty(): S["inv"].erase(k)
	return true

func tag_choices(t: String) -> Array:
	var c: Array = tags.get(t, []).duplicate()
	c.sort_custom(func(a, b): return float(items[a].get("value", 0)) < float(items[b].get("value", 0)))
	return c

func take_tag(t: String, q: float) -> bool:
	if count_tag(t) + 0.0001 < q: return false
	var left := q
	for k in tag_choices(t):
		var h := count(k)
		if h <= 0.0: continue
		var use := minf(h, left)
		take(k, use); left -= use
		if left <= 0.00001: break
	return true

## Can it be sold at the market? (Items with "noSell" — straw — are not wanted by anyone.)
func sellable(k: String) -> bool:
	return value_of(k) > 0.0 and not items.get(k, {}).get("noSell", false)

func value_of(k: String) -> float:
	return float(items.get(k, {}).get("value", 0))

func shelf_life(k: String) -> int:
	var f = meta.get("freshness", {})
	if f.is_empty(): return -1
	var sl = f.get("shelfLife", {})
	var life := int(sl.get("default", -1))
	if sl.get("items", {}).has(k): life = int(sl["items"][k])
	elif items.get(k, {}).get("category", "") == "dish": life = int(sl.get("dishExceptions", {}).get(k, sl.get("dishes", 1)))
	if life < 0: return -1
	return life + int(round(g("shelfLife", 0.0)))

func stale_soon(k: String) -> float:
	var life := shelf_life(k)
	if life < 0: return 0.0
	var t := 0.0
	for b in S["inv"].get(k, []):
		if season_no() - int(b[0]) >= life: t += float(b[1])
	return t

# ------------------------------------------------------------------ energy & costs
func buff_mult() -> float:
	var b: Dictionary = S["buff"]
	if b.is_empty(): return 1.0
	if int(b.get("until", 0)) <= S["step"]: return 1.0
	return float(b.get("mult", 1.0))

func stars(station_root: String) -> int:
	var uses := int(S["practice"].get(station_root, 0))
	var n := 0
	for th in meta.get("practice", {}).get("thresholds", [10, 40, 120]):
		if uses >= int(th): n += 1
	return n

func ecost(cat: String, base: float, station_root := "") -> float:
	if base <= 0.0: return 0.0
	var c := base * m("energy:" + cat)
	if season() == "winter" and cat in ["craft", "textile", "smith", "wood"]:
		c *= float(smod("indoorEnergy", 1.0))
	if station_root != "":
		c *= pow(float(meta.get("practice", {}).get("energyPerStar", 0.95)), stars(station_root))
	return c * buff_mult()

func node_cat(id: String) -> String:
	var n = nodes[id]
	return str(n.get("cat", DEFAULT_CAT.get(n["type"], "build")))

func plots() -> int:
	var n := int(round(g("plots", 0.0)))
	# clearing jobs past their openAfter step: their patches can be planted already
	for id in S.get("open_early", {}):
		if nodes.has(id) and not satisfied(id): n += int(nodes[id].get("effects", {}).get("add", {}).get("plots", 0))
	return n

## A clearing job reached its openAfter step: its patches can be planted, but still have weeds and stones on them
## and give less (quality); the remaining steps make them better.
func _open_early(id: String) -> void:
	var before := plots()
	S["open_early"][id] = true
	_ensure_areas()
	var idx := []
	for i in range(before, mini(plots(), S["patches"].size())):
		var p = S["patches"][i]
		p["weeds"] = 3.0; p["stones"] = 2.0; p["quality"] = float(meta.get("yield", {}).get("earlyQuality", 0.85))
		idx.append(i)
	S["early_patches"][id] = idx
	say("🌱 %d new patches can be planted now! Clearing them more makes them better." % idx.size())

func _improve_early(id: String, done_steps: int, total: int) -> void:
	var oa := int(nodes[id].get("openAfter", 0))
	var r := clampf(float(total - done_steps) / maxf(1.0, float(total - oa)), 0.0, 1.0)   # how much is still to do
	var q0 := float(meta.get("yield", {}).get("earlyQuality", 0.85))
	for i in S["early_patches"].get(id, []):
		var p = S["patches"][int(i)]
		p["quality"] = maxf(float(p.get("quality", 1.0)), lerpf(1.0, q0, r))
		p["weeds"] = minf(float(p["weeds"]), roundf(3.0 * r))
		p["stones"] = minf(float(p["stones"]), roundf(2.0 * r))

## Nodes done in steps ("steps": [{name, emoji, cost, gives}, …]): clearing land or ruins takes several taps.
## Questions still to wait before the next step of a building can start (the mortar dries, the wood settles).
func step_wait_left(id: String) -> int:
	return maxi(0, int(S.get("step_ready", {}).get(id, 0)) - int(S["step"]))

func steps_of(id: String) -> Array:
	return nodes[id].get("steps", [])

func step_index(id: String) -> int:
	return int(S.get("step_progress", {}).get(id, 0))

func _raw_cost(id: String) -> Dictionary:
	var n = nodes[id]
	var st: Array = n.get("steps", [])
	if st.size() > 0: return _flexed(id, st[mini(step_index(id), st.size() - 1)].get("cost", {}))
	if n["type"] == "animal": return n.get("price", {})
	return _flexed(id, n.get("cost", {}))

# ------------------------------------------------------------------ dynamic difficulty (a first version; settings dynamicDifficulty)
## Goldilocks prices. The game keeps a "pace": the worth of what this player brings in per Time Quiz question (a running
## average). When a goal first shows up, its coins and bigger material amounts are fitted to that pace compared with the
## pace planned for this point of the game (meta.flex.basePace): a strong farm gets a bit more to do, a farm that
## is struggling a bit less. Only part of the difference is followed (strength 0.5), so every upgrade still makes the
## farm feel quicker; the factor stays within meta.flex.range and is fixed from then on, so a price never changes in front
## of the child. Energy and the kinds of things never change. A goal that an improvement not yet made would make quicker
## asks a little more (tipBonus), and shows that improvement as a tip (flex_tip): exploring it is the way through.
func flex_on() -> bool:
	return bool(S.get("dynamic", settings.get("dynamicDifficulty", false)))

## Switches dynamic difficulty on or off for this farm (Settings). Prices already fitted keep their factor while on.
func toggle_flex() -> void:
	S["dynamic"] = not flex_on()
	_dirty()
	save_game(); changed.emit()

func flex_cfg() -> Dictionary:
	return meta.get("flex", {})

## What one piece is worth for the pace (its value; things worth nothing to sell still count a little).
func flex_worth(k: String) -> float:
	return maxf(value_of(k), float(flex_cfg().get("minWorth", 0.25)))

func _tick_pace() -> void:
	var n := float(flex_cfg().get("paceQuestions", 20))
	S["pace_n"] = int(S.get("pace_n", 0)) + 1
	# a running average over about n questions (a plain average while there are fewer)
	S["pace"] = lerpf(float(S.get("pace", 0.0)), _produced, maxf(2.0 / (n + 1.0), 1.0 / float(S["pace_n"])))
	_produced = 0.0

## The pace planned at this point of the game: meta.flex.basePace = [[goals done, pace], …] (from the test bot), in between
## a straight line.
func base_pace() -> float:
	var tab: Array = flex_cfg().get("basePace", [])
	if tab.is_empty(): return 0.0
	var gd := float(S.get("goals", 0))
	if gd <= float(tab[0][0]): return float(tab[0][1])
	for i in range(1, tab.size()):
		if gd <= float(tab[i][0]):
			var t := (gd - float(tab[i - 1][0])) / maxf(1.0, float(tab[i][0]) - float(tab[i - 1][0]))
			return lerpf(float(tab[i - 1][1]), float(tab[i][1]), t)
	return float(tab[tab.size() - 1][1])

## How far this player's pace is ahead (> 1) or behind (< 1) the pace planned for this point of the game.
func pace_ratio() -> float:
	var b := base_pace()
	if b <= 0.0: return 1.0
	return float(S.get("pace", 0.0)) / b

## The price factor of a goal (1 = as planned). Fixed the first time it is asked for while the goal is open.
func flex_factor(id: String) -> float:
	if not flex_on(): return 1.0
	if not S.has("flex"): S["flex"] = {}
	if S["flex"].has(id): return float(S["flex"][id])
	var F := flex_cfg()
	var n = nodes[id]
	if not (n["type"] in F.get("types", [])) or int(S.get("pace_n", 0)) < int(F.get("warmup", 15)): return 1.0
	if done(id) or satisfied(id) or not missing_reqs(id).is_empty(): return 1.0
	var rg: Array = F.get("rangeSide", [0.75, 1.4]) if n["type"] == "sidequest" else F.get("range", [0.8, 1.3])
	var k := pow(maxf(0.05, pace_ratio()), float(F.get("strength", 0.5)))
	if flex_tip(id) != "": k *= 1.0 + float(F.get("tipBonus", 0.08))
	k = clampf(k, float(rg[0]), float(rg[1]))
	S["flex"][id] = snappedf(k, 0.01)
	return float(S["flex"][id])

func _flexed(id: String, c: Dictionary) -> Dictionary:
	var k := flex_factor(id)
	if absf(k - 1.0) < 0.01: return c
	var out := {}
	for key in c:
		var v := float(c[key])
		if key == "coins": out[key] = maxf(1.0, roundf(v * k))
		elif key in ["energy", "read", "water"] or v < 2.0: out[key] = v
		else:
			# never more than the store can hold (else the goal could not be reached at all)
			var cap := storage_cap() if items.has(key) and items[key].get("category", "") != "keeper" else 1.0e9
			out[key] = maxf(1.0, minf(roundf(v * k), maxf(v, cap)))
	return out

## An improvement not made yet that would make this goal quicker (its things cheaper to make, gather or grow), or "".
func flex_tip(id: String) -> String:
	var keys := {}
	for st in nodes[id].get("steps", []):
		for k in st.get("cost", {}): keys[k] = true
	for k in nodes[id].get("cost", {}): keys[k] = true
	var want := {}           # effect keys that would help: energy:<cat>, out:<station>, time:<station>, yield …
	for k in keys:
		if k in ["coins", "energy", "read", "water"] or not items.has(k): continue
		if items[k].get("category", "") == "crop":
			want["energy:harvest"] = true; want["yield:field"] = true; want["weeds"] = true
		for rid in recipes:
			if not recipes[rid]["outputs"].has(k): continue
			want["energy:" + recipe_cat(rid)] = true
			want["out:" + str(recipes[rid]["station"])] = true
			want["time:" + str(recipes[rid]["station"])] = true
	if keys.has("energy"): want["energy:" + node_cat(id)] = true
	for nid in nodes:
		var n = nodes[nid]
		if not (n["type"] in ["helper", "tool", "gear", "polish"]): continue
		if n["type"] == "polish":
			if not polish_open(nid) or polish_level(nid) >= 1.0: continue
		elif not is_open(nid): continue
		var e: Dictionary = n.get("effects", {})
		for part in ["mult", "add"]:
			for ek in e.get(part, {}):
				if want.has(ek): return nid
	return ""

## The cost of a node as {key: amount}, scaled for per-patch upgrades and energy upgrades.
## A node done in steps costs what its next step costs.
func node_cost(id: String) -> Dictionary:
	var raw: Dictionary = _raw_cost(id)
	var mul := 1.0   # per-patch upgrades are paid one patch at a time (see unlock)
	var out := {}
	for k in raw:
		if k == "read": continue
		var v := float(raw[k]) * mul
		if k == "energy": v = ecost(node_cat(id), v)
		out[k] = v
	return out

## The cost before any upgrade, practice star, meal or season makes it cheaper (the cube bars show what is saved).
func node_cost_base(id: String) -> Dictionary:
	var raw: Dictionary = _raw_cost(id)
	var out := {}
	for k in raw:
		if k != "read": out[k] = float(raw[k])
	return out

func missing_cost(c: Dictionary) -> Array:
	var miss := []
	for k in c:
		var need := float(c[k])
		var h := have(k)
		if h + 0.0001 < need:
			miss.append({"key": k, "need": need, "have": h})
	return miss

func pay(c: Dictionary) -> bool:
	if not missing_cost(c).is_empty(): return false
	for k in c:
		var v := float(c[k])
		if k == "energy": S["energy"] -= v
		elif k == "water": S["water"] -= v
		elif k == "coins": S["coins"] -= v
		else: take(k, v)
	return true

func cost_text(c: Dictionary) -> String:
	var parts := []
	for k in c:
		parts.append("%s%d" % [iemoji(k), up(float(c[k]))])
	return " ".join(parts)

# ------------------------------------------------------------------ requirements
func cards_learned() -> int:
	var n := 0
	for id in card_ids:
		if done(id): n += 1
	return n

func books_owned() -> int:
	var n := 0
	for id in S["unlocked"]:
		if nodes.has(id) and nodes[id]["type"] == "book": n += 1
	return n

func missing_reqs(id: String) -> Array:
	var n = nodes[id]
	var miss := []
	for r in n.get("requires", []):
		if not satisfied(r): miss.append(nodes[r]["emoji"] + " " + nodes[r]["name"] if nodes.has(r) else r)
	if n.has("requiresCards") and cards_learned() < int(n["requiresCards"]):
		miss.append("📚 %d cards learned (%d so far)" % [int(n["requiresCards"]), cards_learned()])
	for k in n.get("discover", []):
		if not S["seen"].has(k): miss.append("🔍 find %s %s first" % [iemoji(k), iname(k)])
	if n["type"] == "book" and books_owned() >= int(round(g("bookSlots", 1.0))):
		miss.append("📦 room in the library (holds %d books)" % int(round(g("bookSlots", 1.0))))
	if n.has("attach") and n["type"] == "helper":
		pass
	return miss

func is_open(id: String) -> bool:
	return not done(id) and not satisfied(id) and missing_reqs(id).is_empty()

func is_auto(id: String) -> bool:
	var n = nodes[id]
	if n["type"] in NOT_AUTO: return false
	return not n.has("cost") or (n["cost"] as Dictionary).is_empty()

func _auto_unlocks() -> void:
	var guard := 0
	var again := true
	while again and guard < 20:
		again = false; guard += 1
		for id in nodes:
			if done(id) or satisfied(id) or not is_auto(id): continue
			if not missing_reqs(id).is_empty(): continue
			_finish_unlock(id, true)
			again = true

## Build, buy, deliver, learn — anything with a cost.
func can_unlock(id: String) -> Dictionary:
	if done(id): return {"ok": false, "why": "already done"}
	var mr := missing_reqs(id)
	if not mr.is_empty(): return {"ok": false, "why": "needs " + ", ".join(mr)}
	if step_wait_left(id) > 0: return {"ok": false, "why": "wait", "wait": step_wait_left(id)}
	var mc := missing_cost(node_cost(id))
	if not mc.is_empty():
		var parts := []
		for x in mc: parts.append("%s %d more" % [iemoji(x["key"]), up(float(x["need"]) - float(x["have"]))])
		return {"ok": false, "why": "missing " + ", ".join(parts)}
	return {"ok": true, "why": ""}

func patch_progress(id: String) -> int:
	return int(S.get("patch_progress", {}).get(id, 0))

func unlock(id: String) -> bool:
	var ck := can_unlock(id)
	if not ck["ok"]:
		say("🔒 " + nodes[id]["name"] + ": " + ck["why"])
		return false
	if nodes[id].get("perPatch", false):
		# upgrade patch by patch: pay for as many patches as you can afford now
		if not S.has("patch_progress"): S["patch_progress"] = {}
		var done_n := patch_progress(id)
		var paid := 0
		while done_n < plots() and missing_cost(node_cost(id)).is_empty():
			pay(node_cost(id)); done_n += 1; paid += 1
		S["patch_progress"][id] = done_n
		if done_n < plots():
			say("🟫 %s: %d of %d patches done." % [nodes[id]["name"], done_n, plots()])
			_wear("use:field"); save_game(); changed.emit()
			return true
		_finish_unlock(id, false)
		return true
	var st: Array = steps_of(id)
	if st.size() > 0:
		# one step at a time: pay it, get what it gives, and the node is done after the last one
		var i := step_index(id)
		if step_wait_left(id) > 0:
			say("⏳ %s: the next step can start in %d question%s." % [nodes[id]["name"], step_wait_left(id), "" if step_wait_left(id) == 1 else "s"])
			return false
		pay(node_cost(id))
		var got := {}
		for k in st[i].get("gives", {}): got[k] = add_item(k, float(st[i]["gives"][k]), true)
		if not S.has("step_progress"): S["step_progress"] = {}
		S["step_progress"][id] = i + 1
		_gained("node:" + id, got)
		_wear("use:" + node_cat(id))
		var oa := int(nodes[id].get("openAfter", 0))
		if oa > 0 and i + 1 == oa and i + 1 < st.size(): _open_early(id)
		elif oa > 0 and i + 1 > oa: _improve_early(id, i + 1, st.size())
		if int(st[i].get("wait", 0)) > 0 and i + 1 < st.size():
			if not S.has("step_ready"): S["step_ready"] = {}
			S["step_ready"][id] = int(S["step"]) + int(st[i]["wait"])
		if i + 1 < st.size():
			say("%s %s (%d/%d)" % [st[i].get("emoji", "✔"), st[i].get("name", nodes[id]["name"]), i + 1, st.size()])
			save_game(); changed.emit()
			return true
	else:
		pay(node_cost(id))
	_finish_unlock(id, false)
	return true

func _finish_unlock(id: String, auto: bool) -> void:
	var n = nodes[id]
	S["unlocked"][id] = true
	S.get("open_early", {}).erase(id)
	for i in S.get("early_patches", {}).get(id, []):
		var p = S["patches"][int(i)]
		p["quality"] = maxf(float(p.get("quality", 1.0)), 1.0)
	S.get("early_patches", {}).erase(id)
	if not n.has("steps"):
		for k in n.get("gives", {}): add_item(k, float(n["gives"][k]))
	var big: bool = n["type"] in ["building", "station", "tool", "gear"] and not auto
	var helper: bool = n["type"] == "helper" and (not auto or n.get("gift", false) or id == "barn_cat")
	if big or helper: celebrate.emit(id)
	if n.has("attach"): S["attach"][n["attach"]] = id
	_dirty()
	if not auto:
		var t: String = n["type"]
		say("%s %s %s" % ["✅", n.get("emoji", ""), n["name"]])
		if t == "pet":
			ask_name.emit(id, str(n.get("defaultName", "Buddy")))
			_offer_gift(_news("pet", id.substr(4)))
		elif t == "sidequest":
			S["album"].append({"id": id, "text": n.get("reward", {}).get("picture", n["name"]), "emoji": n.get("emoji", "🖼️")})
			S["stats"]["sidequests"] = int(S["stats"]["sidequests"]) + 1
			var ls = meta.get("luck", {}).get("sources", {}).get("sidequest", [0.5, 30])
			add_luck(float(ls[0]), int(ls[1]) + int(g("luckDuration", 0.0)))
			say("🖼️ New picture in your album! You feel lucky for a while. ☘️")
			var fr: Dictionary = n.get("friend", {})
			if not fr.is_empty():
				say("💌 %s %s is your friend now. Friends send postcards with a gift when they hear of your successes!" % [fr.get("emoji", ""), fr.get("name", "")])
			if n.has("perk"): give_perk(str(n["perk"]))
		elif id.begins_with("library_"):
			_offer_gift(_news("library"))
		if t in MAIN_TYPES:
			S["goals"] = int(S["goals"]) + 1
			if int(S["goals"]) % 12 == 0: _offer_gift(_news("goals"))
		if n.has("effects") and n["effects"].has("add") and n["effects"]["add"].has("plots"):
			_ensure_areas()
		_check_acorns()
	_ensure_areas()
	if not auto:
		_auto_unlocks()
		save_game()
		changed.emit()

func set_pet_name(pet_id: String, name: String) -> void:
	S["pet_names"][pet_id] = name if name.strip_edges() != "" else str(nodes[pet_id].get("defaultName", "Buddy"))
	save_game(); changed.emit()

func set_attach(station: String, helper_id: String) -> void:
	if not done(helper_id): return
	S["attach"][station] = helper_id
	_dirty(); save_game(); changed.emit()

# ------------------------------------------------------------------ fields, orchard, greenhouse
func _blank_patch() -> Dictionary:
	return {"crop": "", "plants": 0.0, "growth": 0.0, "ready": false, "weeds": 0.0, "stones": 0.0, "last": "", "soil": 1.0, "cycles": 0, "quality": 1.0}

func _ensure_areas() -> void:
	var fields := maxi(1, int(ceilf(float(plots()) / 9.0)))
	while S["patches"].size() < fields * 9: S["patches"].append(_blank_patch())
	while S["orchard"].size() < int(round(g("orchardSpots", 0.0))): S["orchard"].append(_blank_patch())
	while S["gh"].size() < int(round(g("greenhouseBeds", 0.0))): S["gh"].append(_blank_patch())

func area(a: String) -> Array:
	return S["patches"] if a == "field" else S[a]

func patch_usable(a: String, i: int) -> bool:
	if a == "field": return i < plots()
	return i < area(a).size()

func field_names() -> Array:
	var names := ["Home Field", "North Field", "River Meadow"]
	var out := []
	for f in range(int(S["patches"].size() / 9)): out.append(names[f] if f < names.size() else "Field %d" % (f + 1))
	return out

func crop_slot(cid: String) -> String:
	var s: String = nodes[cid].get("slot", "field")
	return "gh" if s == "greenhouse" else s

func crops_for(a: String) -> Array:
	var out := []
	for id in nodes:
		var n = nodes[id]
		if n["type"] != "crop" or not done(id): continue
		if crop_slot(id) == a: out.append(id)
	return out

func plants_per_patch(a: String) -> int:
	if a == "orchard": return 1
	return maxi(1, int(round(g("patchCap", 1.0))))

func free_density() -> float:
	return float(meta.get("weeds", {}).get("freeDensity", 2)) + g("freeDensity", 0.0)

func fert_points_have() -> float:
	var t := 0.0
	for k in items:
		if items[k].has("fertilizer"): t += count(k) * float(items[k]["fertilizer"])
	return t

func _take_fert(points: float) -> void:
	var fs := []
	for k in items:
		if items[k].has("fertilizer"): fs.append(k)
	fs.sort_custom(func(a, b): return float(items[a]["fertilizer"]) < float(items[b]["fertilizer"]))
	var left := points
	for k in fs:
		var p := float(items[k]["fertilizer"])
		while left > 0.0001 and count(k) >= 1.0:
			take(k, 1.0); left -= p
		if left <= 0.0001: return

func seed_have(cid: String) -> float:
	var n = nodes[cid]
	if n.has("seedItem"): return count(n["seedItem"])
	return float(S["seeds"].get(cid, 0.0))

func field_water_mult() -> float:
	if S.get("rain", false): return 0.0
	return float(g("waterMult", 1.0)) * m("water:field") * float(smod("waterField", 1.0))

## How many plants of this crop could go into one patch right now, and why not more.
func plant_plan(a: String, cid: String) -> Dictionary:
	var n = nodes[cid]
	var want := plants_per_patch(a)
	var reasons := []
	var k := want
	var seeds := seed_have(cid)
	var seed_cost := float(n.get("seedCost", 0))
	if seeds < k:   # only seeds you have can be planted (they are bought at the market)
		k = int(floorf(seeds + 0.0001)); reasons.append("seeds")
	if a == "field":
		var fd := free_density()
		while k > fd and fert_points_have() + 0.001 < (k - fd):
			k -= 1
			if not reasons.has("fertilizer"): reasons.append("fertilizer")
	for nk in n.get("needs", {}):
		var per := float(n["needs"][nk])
		while k > 0 and count(nk) + 0.001 < per * k:
			k -= 1
			if not reasons.has(nk): reasons.append(nk)
	var wm := field_water_mult() if a != "gh" else float(g("waterMult", 1.0)) * 0.5
	var wper := float(n.get("water", 0)) * wm
	while k > 0 and S["water"] + 0.001 < wper * k:
		k -= 1
		if not reasons.has("water"): reasons.append("water")
	var e := ecost("plant", 1.0) * m("energy:field") if a != "orchard" or not n.has("regrow") else ecost("plant", 1.0)
	var buy := 0
	return {"plants": k, "max": want, "reasons": reasons, "water": wper * k, "energy": e, "buy_seeds": buy, "coins": buy * seed_cost,
		"water_base": float(n.get("water", 0)) * k, "energy_base": 1.0,
		"water_full": wper * want, "water_full_base": float(n.get("water", 0)) * want}   # for a full patch: shows what is missing

func plant(a: String, i: int, cid: String) -> bool:
	if not patch_usable(a, i): return false
	var p = area(a)[i]
	if p["crop"] != "": say("Something is already growing there."); return false
	var plan := plant_plan(a, cid)
	var k := int(plan["plants"])
	if k < 1:
		say("🌱 Can't plant %s: not enough %s." % [nodes[cid]["name"], ", ".join(plan["reasons"])])
		return false
	if S["energy"] + 0.001 < float(plan["energy"]):
		say("⚡ Too tired to plant. Rest a little (tap ⚡)."); return false
	var n = nodes[cid]
	if int(plan["buy_seeds"]) > 0:
		S["coins"] -= float(plan["coins"])
		S["seeds"][cid] = float(S["seeds"].get(cid, 0.0)) + int(plan["buy_seeds"])
		if roll(_event("seed_bargain")): S["seeds"][cid] = float(S["seeds"][cid]) + 1.0; say("🎁 The seed merchant adds one for free.")
	if n.has("seedItem"): take(n["seedItem"], k)
	else: S["seeds"][cid] = float(S["seeds"].get(cid, 0.0)) - k
	if a == "field":
		var extra := maxf(0.0, k - free_density())
		if extra > 0.0: _take_fert(extra)
	for nk in n.get("needs", {}): take(nk, float(n["needs"][nk]) * k)
	S["water"] -= float(plan["water"])
	S["energy"] -= float(plan["energy"])
	var rot = meta.get("rotation", {})
	var soil := 1.0
	if a == "field" and p["last"] != "":
		if p["last"] == cid: soil = float(rot.get("sameCropGrow", 0.85))
		elif (rot.get("legumes", []) as Array).has(p["last"]): soil = float(rot.get("afterLegumeGrow", 1.1)) + g("restedSoil", 0.0)
	p["crop"] = cid; p["plants"] = float(k); p["growth"] = 0.0; p["ready"] = false; p["soil"] = soil; p["cycles"] = 0
	if not p.has("quality"): p["quality"] = 1.0
	_wear("use:plant")
	save_game(); changed.emit()
	return true

func grow_target(p: Dictionary) -> float:
	var n = nodes[p["crop"]]
	if n.has("regrow") and int(p.get("cycles", 0)) > 0: return float(n["regrow"])
	return float(n.get("grow", 3))

func slow_factor(p: Dictionary) -> float:
	var sl := float(meta.get("stones", {}).get("slowPerStone", 0.04))
	return maxf(0.5, 1.0 - 0.04 * float(p["weeds"]) - sl * float(p["stones"]))

func grow_speed(a: String, p: Dictionary) -> float:
	var base := 1.0 / maxf(0.2, m("grow"))
	if a == "gh": return base
	var sg := float(smod("grow", 1.0))
	if season() == "winter": sg += g("winterGrow", 0.0)
	return base * sg * float(p.get("soil", 1.0)) * slow_factor(p)

func harvest(a: String, i: int) -> bool:
	var p = area(a)[i]
	if p["crop"] == "" or not p["ready"]: return false
	var n = nodes[p["crop"]]
	var e := ecost("harvest", 1.0) * m("energy:field")
	if S["energy"] + 0.001 < e: say("⚡ Too tired to harvest. Rest a little (tap ⚡)."); return false
	S["energy"] -= e
	var mult := 1.0
	if roll(_event("double_harvest")): mult = 2.0; say("🎉 Bumper crop: double harvest!")
	if a == "orchard":
		mult *= m("yield:orchard") * float(smod("yieldOrchard", 1.0))
	var got := []
	var arrived := {}
	var amounts := harvest_amounts(n, maxi(1, shown_plants(float(p["plants"]))), float(p.get("quality", 1.0)), mult)
	for k in amounts:
		var q := float(amounts[k]) + g("yield_" + k, 0.0)
		q = add_item(k, q)
		got.append("%s%d" % [iemoji(k), down(q)])
		arrived[k] = q
		_job("harvest", k, q)
	if n.has("seedItem") and g("heirloomSeedSaving", 0.0) > 0.0: add_item(n["seedItem"], 1.0)
	S["stats"]["harvests"] = int(S["stats"]["harvests"]) + 1
	_check_perks()
	say("🧺 Harvested %s: %s" % [n["name"], " ".join(got)])
	_gained("patch:%s:%d" % [a, i], arrived)
	if n.has("regrow"):
		p["growth"] = 0.0; p["ready"] = false; p["cycles"] = int(p.get("cycles", 0)) + 1
	else:
		p["last"] = p["crop"]; p["crop"] = ""; p["plants"] = 0.0; p["growth"] = 0.0; p["ready"] = false
	_wear("use:harvest")
	save_game(); changed.emit()
	return true

## Cuts down a tree in the orchard so another kind can be planted there (three apple trees must not block the walnut tree
## the pony's cake needs). Costs energy, gives the wood back.
func cut_tree(a: String, i: int) -> bool:
	var p = area(a)[i]
	if p["crop"] == "" or not nodes[p["crop"]].has("regrow"): return false
	var e := ecost("wood", float(meta.get("orchard", {}).get("cutEnergy", 3)))
	if S["energy"] + 0.001 < e: say("⚡ Too tired to cut a tree. Rest a little (tap ⚡)."); return false
	S["energy"] -= e
	var tree_name: String = nodes[p["crop"]]["name"]
	p["last"] = p["crop"]; p["crop"] = ""; p["plants"] = 0.0; p["growth"] = 0.0; p["ready"] = false; p["cycles"] = 0
	var got := {}
	for k in meta.get("orchard", {}).get("cutGives", {"log": 1, "stick": 2}):
		got[k] = add_item(k, float(meta.get("orchard", {}).get("cutGives", {"log": 1, "stick": 2})[k]), true)
	_gained("patch:%s:%d" % [a, i], got)
	say("🪓 Cut down the %s: the spot is free for another tree." % tree_name)
	save_game(); changed.emit()
	return true

## What one harvest gives: for every plant the crop's average (data: yields) × luck × the patch's quality, with a random
## spread, rounded up or down at random so the average holds; whole numbers only. The first item is at least minMain per plant.
func harvest_amounts(n: Dictionary, plants: int, quality: float, mult: float) -> Dictionary:
	var ym = meta.get("yield", {})
	var spread := float(ym.get("spread", 0.22))
	var lshift := float(ym.get("luckShift", 0.1))
	var min_main := float(ym.get("minMain", 1))
	var out := {}
	var first := true
	for k in n.get("yields", {}):
		var avg := float(n["yields"][k]) * (1.0 + luck() * lshift) * quality * mult
		var tot := 0.0
		for _p in range(plants):
			var x := maxf(0.0, avg + rng.randfn(0.0, spread * avg))
			if first: x = maxf(min_main * mult, x)
			var whole := floorf(x)
			if rng.randf() < x - whole: whole += 1.0
			tot += whole
		out[k] = tot
		first = false
	return out

func weed(i: int) -> bool:
	var p = S["patches"][i]
	var w := float(p["weeds"])
	if w < 0.5:
		say("🌿 No weeds to pull here. (Try 'Root out the weeds' in Polish — it keeps them away longer.)")
		return false
	var n := minf(w, float(meta.get("weeds", {}).get("weedsPerPull", 3)))
	var e := ecost("weed", n) * m("energy:field")
	if S["energy"] + 0.001 < e: say("⚡ Too tired to weed. Rest a little (tap ⚡)."); return false
	S["energy"] -= e
	p["weeds"] = w - n
	var fib := n * (1.5 if season() == "spring" else 1.0)
	var fib_got := add_item("fiber", fib, true)
	_gained("patch:field:%d" % i, {"fiber": fib_got})
	S["stats"]["weeds"] = float(S["stats"]["weeds"]) + n
	_job("weed", "", n)
	_weed_luck()
	_wear("use:weed")
	_check_acorns()
	save_game(); changed.emit()
	return true

func weed_field(f: int) -> void:
	var any := false
	for i in range(f * 9, f * 9 + 9):
		if patch_usable("field", i) and float(S["patches"][i]["weeds"]) >= 0.5:
			if not weed(i): break
			any = true
	if not any: say("🌿 This field is already tidy.")

func pick_stones(i: int) -> bool:
	var p = S["patches"][i]
	var s := float(p["stones"])
	if s < 0.5: return false
	var n := minf(s, float(meta.get("stones", {}).get("stonesPerPick", 2)))
	var e := ecost("field", n * float(meta.get("stones", {}).get("energyPerStone", 1)))
	if S["energy"] + 0.001 < e: say("⚡ Too tired. Rest a little (tap ⚡)."); return false
	S["energy"] -= e
	p["stones"] = s - n
	_gained("patch:field:%d" % i, {"stone": add_item("stone", n)})
	S["stats"]["stones"] = float(S["stats"]["stones"]) + n
	_job("stones", "", n)
	if roll(_event("stone_quartz")): add_item("quartz", 1.0); say("💎 A sparkling quartz crystal inside a stone!")
	save_game(); changed.emit()
	return true

# ------------------------------------------------------------------ water: fetched from the pond with a bucket
## How much one trip to the pond brings (the old bucket: 3; a carrying yoke adds more).
func fetch_amount() -> float:
	return g("fetchWater", float(meta.get("water", {}).get("fetchBase", 3.0)))

func fetch_cost() -> float:
	return ecost("gather", float(meta.get("water", {}).get("fetchEnergy", 1.0)))

func fetch_water() -> bool:
	var room := water_cap() - float(S["water"])
	if room < 0.5: say("💧 Your water is full."); return false
	var e := fetch_cost()
	if S["energy"] + 0.001 < e: say("⚡ Too tired to carry water. Rest a little (tap ⚡)."); return false
	S["energy"] -= e
	var q := minf(room, fetch_amount())
	S["water"] = float(S["water"]) + q
	S["stats"]["fetch"] = int(S["stats"].get("fetch", 0)) + 1
	_gained("water", {"water": q})
	save_game(); changed.emit()
	return true

# ------------------------------------------------------------------ animals & muck
func animal_key(aid: String) -> String:
	return aid.replace("animal_", "")

func animal_cap(aid: String) -> int:
	return int(round(g("cap_" + animal_key(aid), 0.0)))

func animal(aid: String) -> Dictionary:
	if not S["animals"].has(aid): S["animals"][aid] = {"count": 0, "ready": 0, "muck": 0.0}
	return S["animals"][aid]

func animal_price(aid: String) -> Dictionary:
	var out := {}
	var pr: Dictionary = nodes[aid].get("price", {})
	for k in pr: out[k] = float(pr[k])
	return out

func buy_animal(aid: String) -> bool:
	var n = nodes[aid]
	if not missing_reqs(aid).is_empty(): say("🔒 " + ", ".join(missing_reqs(aid))); return false
	var a := animal(aid)
	if int(a["count"]) >= animal_cap(aid): say("🏠 No room for more %s. Build a bigger home for them." % n["name"]); return false
	if not pay(animal_price(aid)): say("🪙 Not enough to buy " + n["name"]); return false
	a["count"] = int(a["count"]) + 1
	if int(a["count"]) == 1: a["ready"] = S["step"]
	if not done(aid): _finish_unlock(aid, false)
	else:
		say("%s One more %s!" % [n.get("emoji", ""), n["name"]])
		save_game(); changed.emit()
	return true

func has_flowers() -> bool:
	for a in ["field", "orchard"]:
		for p in area(a):
			if p["crop"] != "" and nodes[p["crop"]].get("flower", false): return true
	return false

func muck_factor(aid: String) -> float:
	var a := animal(aid)
	var mu = meta.get("muck", {})
	var th := float(mu.get("thresholdPerAnimal", 4)) * maxf(1.0, float(a["count"]))
	var mk := float(a["muck"])
	if mk > 2.0 * th: return float(mu.get("slowAboveDouble", 0.5))
	if mk > th: return float(mu.get("slowAbove", 0.75))
	return 1.0

func feed_needs(aid: String) -> Dictionary:
	var n = nodes[aid]
	var a := animal(aid)
	var out := {}
	for k in n.get("feed", {}):
		out[k] = float(n["feed"][k]) * int(a["count"]) * m("feed:" + aid)
	var w := float(n.get("feedWater", 0)) * int(a["count"]) * m("water:animal")
	if w > 0.0: out["water"] = w
	out["energy"] = ecost("animal", float(n.get("collectEnergy", 1)) * int(a["count"]))
	return out

func collect_animal(aid: String) -> bool:
	var n = nodes[aid]
	var a := animal(aid)
	if int(a["count"]) < 1: return false
	if S["step"] < int(a["ready"]): say("%s needs a little time. Answer a Time Quiz question." % n["name"]); return false
	if n.get("needsFlowers", false) and not has_flowers():
		say("🐝 The bees need flowers: grow clover, sunflowers, flax, berries, herbs or fruit trees."); return false
	var need := feed_needs(aid)
	var miss := missing_cost(need)
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %s" % [iemoji(x["key"]), iname(x["key"]) if x["key"] != "energy" and x["key"] != "water" else x["key"]])
		say("%s need %s." % [n["name"], ", ".join(parts)]); return false
	pay(need)
	var mf := muck_factor(aid)
	var got := []
	var arrived := {}
	for k in n.get("produces", {}):
		var q := float(n["produces"][k]) * int(a["count"]) * m("out:" + aid) * float(smod("out", {}).get(aid, 1.0)) * mf
		if k == "egg" and roll(_event("double_yolk")): q += 1.0; say("🥚 A double-yolk egg!")
		if k == "honeycomb" and roll(_event("honey_flow")): q += 1.0; say("🍯 A honey flow: extra comb!")
		if k == "wool" and roll(_event("thick_fleece")): q += 1.0; say("🧶 An extra-thick fleece!")
		q = add_item(k, q, true)
		arrived[k] = q
		if q >= 0.5: got.append("%s%d" % [iemoji(k), down(q)])
	a["muck"] = float(a["muck"]) + float(n.get("muck", 0.0)) * int(a["count"]) * m("muck") * m("muck:" + aid)
	a["ready"] = S["step"] + int(n.get("cooldown", 1))
	var msg := "%s Collected: %s" % [n.get("emoji", ""), " ".join(got) if got.size() > 0 else "a little"]
	if mf < 1.0: msg += "  (the pen is mucky — muck it out!)"
	say(msg)
	_gained("animal:" + aid, arrived)
	_job("collect", aid, 1.0)
	_wear("use:animal")
	save_game(); changed.emit()
	return true

func muck_out(aid: String) -> bool:
	var a := animal(aid)
	var mk := float(a["muck"])
	if mk < 0.5: say("Already clean."); return false
	var mu = meta.get("muck", {})
	var e := ecost("animal", mk * float(mu.get("energyPerMuck", 0.5)))
	if S["energy"] + 0.001 < e: say("⚡ Too tired to muck out. Rest a little."); return false
	S["energy"] -= e
	a["muck"] = 0.0
	var got := add_item("manure", mk * float(mu.get("manurePerMuck", 1)))
	say("💩 Mucked out: +%d manure for the compost." % down(got))
	save_game(); changed.emit()
	return true

# ------------------------------------------------------------------ stations, recipes & the woodpile
func chain_root(id: String) -> String:
	var cur := id
	var guard := 0
	while nodes[cur].has("replaces") and guard < 10:
		cur = nodes[cur]["replaces"]; guard += 1
	return cur

func chain_members(root: String) -> Array:
	var out := [root]
	var cur := root
	while replaced_by.has(cur):
		cur = replaced_by[cur]; out.append(cur)
	return out

func active_of(root: String) -> String:
	var act := ""
	for mmb in chain_members(root):
		if done(mmb): act = mmb
	return act

func stations() -> Array:
	var out := []
	var seen := {}
	for id in nodes:
		if nodes[id]["type"] != "station" and not station_recipes.has(id): continue
		var r := chain_root(id)
		if seen.has(r): continue
		seen[r] = true
		if active_of(r) != "": out.append(r)
	return out

func station_slots(root: String) -> int:
	var act := active_of(root)
	if act == "": return 0
	var s := int(nodes[act].get("slots", 1))
	for mmb in chain_members(root): s += int(round(g("slots:" + mmb, 0.0)))
	if act.begins_with("windmill"): s = maxi(s, int(round(g("autoMill", 1.0))) * 2)
	return s

func station_recipes_for(root: String) -> Array:
	var out := []
	for mmb in chain_members(root):
		if not satisfied(mmb): continue
		for rid in station_recipes.get(mmb, []): out.append(rid)
	return out

func recipe_open(rid: String) -> bool:
	var r = recipes[rid]
	if not satisfied(r["station"]): return false
	for q in r.get("requires", []):
		if not satisfied(q): return false
	return true

func recipe_cat(rid: String) -> String:
	var r = recipes[rid]
	if r.has("cat"): return r["cat"]
	return str(nodes[r["station"]].get("cat", "craft"))

## What one tap makes at once: gathering takes more per trip with carrying gear (the "carry" upgrades: basket, packs);
## everything else 1. The cost and the energy grow with it, so a bigger load costs the same per piece.
func recipe_batch(rid: String) -> int:
	if not (recipe_cat(rid) in CARRY_CATS): return 1
	return 1 + maxi(0, int(round(g("carry", 0.0))))

## A recipe's cost for n loads at once (n < 0: the batch one tap makes, recipe_batch).
func recipe_cost(rid: String, n := -1) -> Dictionary:
	var r = recipes[rid]
	var b := float(recipe_batch(rid) if n < 0 else n)
	var c := {}
	for k in r.get("inputs", {}):
		c[k] = float(r["inputs"][k]) * m("in:" + r["station"] + ":" + k) * b
	var e := ecost(recipe_cat(rid), float(r.get("energy", 0)), chain_root(r["station"])) * b
	if e > 0.0: c["energy"] = e
	if float(r.get("water", 0)) > 0.0: c["water"] = float(r["water"]) * b
	return c

## A recipe's cost before upgrades (see node_cost_base), for the same batch.
func recipe_cost_base(rid: String) -> Dictionary:
	var r = recipes[rid]
	var b := float(recipe_batch(rid))
	var c := {}
	for k in r.get("inputs", {}): c[k] = float(r["inputs"][k]) * b
	if float(r.get("energy", 0)) > 0.0: c["energy"] = float(r["energy"]) * b
	if float(r.get("water", 0)) > 0.0: c["water"] = float(r["water"]) * b
	return c

func recipe_fuel(rid: String) -> float:
	var r = recipes[rid]
	return float(r.get("fuel", 0)) * m("fuel") * m("fuel:" + r["station"])

func recipe_time(rid: String) -> float:
	var r = recipes[rid]
	return float(r.get("time", 0)) * m("time:" + r["station"])

func woodpile_cap() -> float:
	return g("woodpileCap", 20.0)

func fuel_value(k: String) -> float:
	return float(meta.get("fuel", {}).get("values", {}).get(k, 0.0))

func stack_wood(k: String, q: float) -> float:
	var v := fuel_value(k)
	if v <= 0.0: return 0.0
	var room := woodpile_cap() - float(S["woodpile"])
	var n := minf(q, minf(count(k), floorf(room / v)))
	if n <= 0.0: return 0.0
	take(k, n)
	S["woodpile"] = float(S["woodpile"]) + n * v
	return n

func auto_stack(need: float) -> void:
	for k in meta.get("fuel", {}).get("stackOrder", ["stick", "straw", "log"]):
		if float(S["woodpile"]) + 0.0001 >= need: return
		var v := fuel_value(k)
		if v <= 0.0: continue
		var missing := need - float(S["woodpile"])
		stack_wood(k, ceilf(missing / v))

## Fuel that could still go on the woodpile from what is in store (sticks, straw, logs …), up to its room.
func fuel_in_store() -> float:
	var f := 0.0
	for k in meta.get("fuel", {}).get("stackOrder", ["stick", "straw", "log"]): f += count(k) * fuel_value(k)
	return minf(f, woodpile_cap() - float(S["woodpile"]))

## Stoking: puts enough wood on the woodpile for need fuel (sticks first, then straw, then logs). Stoves, ovens, kilns
## and the forge only burn what is on the woodpile, so the woodpile is stoked first. Returns the fuel added.
func stoke(need: float) -> float:
	var before := float(S["woodpile"])
	var had := {}
	for k in meta.get("fuel", {}).get("stackOrder", ["stick", "straw", "log"]): had[k] = count(k)
	auto_stack(need)
	var parts := []
	for k in had:
		var used := float(had[k]) - count(k)
		if used > 0.0: parts.append("%d %s" % [int(round(used)), iname(k)])
	var added := float(S["woodpile"]) - before
	if added > 0.0:
		say("🪵 Stoked the woodpile: %s." % ", ".join(parts))
		save_game(); changed.emit()
	elif float(S["woodpile"]) + 0.0001 < need:
		say("🪵 No wood to stoke with: gather sticks at the Field Edge, or bring straw or logs.")
	return added

func start_recipe(rid: String) -> bool:
	var r = recipes[rid]
	if not recipe_open(rid): say("🔒 Not yet."); return false
	var root := chain_root(r["station"])
	var running: Array = S["running"].get(root, [])
	var now := output_now(root)
	if now and recipe_left(rid) > 0.0: say("⏳ That spot needs a question to refill."); return false
	if running.size() >= station_slots(root):
		if now: say("⏳ You have gathered all you can for now. Answer a Time Quiz question.")
		else: say("⏳ %s is busy. Answer Time Quiz questions to finish the batch." % nodes[active_of(root)]["name"])
		return false
	for k in r.get("keeps", []):
		if count(k) < 1.0: say("Needs %s %s (kept, not used up)." % [iemoji(k), iname(k)]); return false
	# a bigger load (carrying gear) when there is enough for it, else as much as there is
	var n := recipe_batch(rid)
	while n > 1 and not missing_cost(recipe_cost(rid, n)).is_empty(): n -= 1
	var c := recipe_cost(rid, n)
	var miss := missing_cost(c)
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %d more" % [iemoji(x["key"]), up(float(x["need"]) - float(x["have"]))])
		say("Missing: " + ", ".join(parts)); return false
	var fuel := recipe_fuel(rid)
	if fuel > 0.0:
		if float(S["woodpile"]) + 0.0001 < fuel:
			say("🪵 Stoke the woodpile first: this needs %d fuel, the woodpile has %d." % [up(fuel), down(S["woodpile"])]); return false
		S["woodpile"] = float(S["woodpile"]) - fuel
	pay(c)
	S["practice"][root] = int(S["practice"].get(root, 0)) + 1
	_wear("use:" + recipe_cat(rid))
	var t := recipe_time(rid)
	if t <= 0.0:
		_recipe_out(rid, n)
	elif now:
		_recipe_out(rid, n)                 # gathered right away; the spot refills over the next question(s)
		running.append({"recipe": rid, "left": t, "cool": true})
		S["running"][root] = running
	else:
		running.append({"recipe": rid, "left": t, "n": n})
		S["running"][root] = running
		say("⏳ %s: ready in %d question%s." % [r.get("name", iname(r["outputs"].keys()[0])), up(t), "" if up(t) == 1 else "s"])
	_job("make", rid, 1.0)
	var hit := false
	for th in meta.get("practice", {}).get("thresholds", []):
		if int(th) == int(S["practice"][root]): hit = true
	if hit:
		say("⭐ Practice star at %s: its recipes now cost less energy." % nodes[active_of(root)]["name"])
	save_game(); changed.emit()
	return true

func _recipe_out(rid: String, n := 1) -> void:
	var r = recipes[rid]
	var got := []
	var arrived := {}
	for k in r["outputs"]:
		var q := float(r["outputs"][k]) * m("out:" + r["station"]) * float(n)
		var gm = smod("gather", {})
		if typeof(gm) == TYPE_DICTIONARY and gm.has(rid): q *= float(gm[rid])
		q = add_item(k, q)
		arrived[k] = q
		got.append("%s%d" % [iemoji(k), down(q)])
	say("✨ %s ready: %s" % [str(r.get("name", iname(r["outputs"].keys()[0]))), " ".join(got)])
	_gained("recipe:" + rid, arrived)

## Stations whose output comes at once (gathering at the field edge): each recipe then rests for its time.
func output_now(root: String) -> bool:
	return bool(nodes.get(root, {}).get("outputNow", false))

## Questions until a recipe is ready (cooking) or its spot has refilled (gathering); 0 = not running.
func recipe_left(rid: String) -> float:
	var root := chain_root(recipes[rid]["station"])
	var left := 0.0
	for job in S["running"].get(root, []):
		if job["recipe"] == rid: left = maxf(left, float(job["left"]))
	return left

func _tick_stations() -> void:
	for root in S["running"].keys():
		var arr: Array = S["running"][root]
		var keep := []
		for job in arr:
			job["left"] = float(job["left"]) - 1.0
			if float(job["left"]) <= 0.0001:
				if not job.get("cool", false): _recipe_out(job["recipe"], int(job.get("n", 1)))
			else: keep.append(job)
		S["running"][root] = keep

# ------------------------------------------------------------------ polish (endless, diminishing returns)
func polish_level(pid: String) -> float:
	return float(S["polish"].get(pid, 0.0))

func polish_open(pid: String) -> bool:
	return satisfied(nodes[pid]["target"])

func polish_cost(pid: String) -> Dictionary:
	var f := 1.0 + floorf(polish_level(pid))
	var out := {}
	var raw: Dictionary = nodes[pid].get("cost", {})
	for k in raw:
		var v := float(raw[k]) * f
		if k == "energy": v = ecost("craft", v)
		out[k] = v
	return out

func polish_gain(pid: String, p: float) -> float:
	return 1.0 - pow(0.5, p)

func do_polish(pid: String) -> bool:
	if not polish_open(pid): return false
	var c := polish_cost(pid)
	var miss := missing_cost(c)
	if not miss.is_empty():
		var parts := []
		for x in miss: parts.append("%s %d more" % [iemoji(x["key"]), up(float(x["need"]) - float(x["have"]))])
		say("Missing: " + ", ".join(parts)); return false
	pay(c)
	# some polish also brings something in ("gives", growing like the cost): rooting out weeds gives plant fibre
	var f := 1.0 + floorf(polish_level(pid))
	var gv: Dictionary = nodes[pid].get("gives", {})
	var got := {}
	for k in gv: got[k] = add_item(k, float(gv[k]) * f, true)
	if not got.is_empty(): _gained("node:" + pid, got)
	S["polish"][pid] = polish_level(pid) + 1.0
	_dirty()
	var gtxt := []
	for k in got: gtxt.append("%s%d" % [iemoji(k), down(got[k])])
	say("✨ %s (%d%% of the full effect now)%s" % [nodes[pid]["name"], int(round(polish_gain(pid, polish_level(pid)) * 100.0)), ("  +" + " ".join(gtxt)) if not gtxt.is_empty() else ""])
	S["unlocked"][pid] = true
	save_game(); changed.emit()
	return true

func _wear(kind: String) -> void:
	for pid in S["polish"].keys():
		var w = nodes[pid].get("wear", {})
		if w.get("per", "") != kind: continue
		S["polish"][pid] = maxf(0.0, polish_level(pid) - float(w.get("amount", 0.0)) * m("wear"))
	_dirty()

# ------------------------------------------------------------------ market, food
## Recently sold units per item: the market pays less for lots of the same thing (meta.market) and forgets a little
## every question, so selling many different things pays best.
func market_sold() -> Dictionary:
	if not S.has("market"): S["market"] = {}
	return S["market"]

## Share of the full price the market pays for the next one (1.0 = full price).
func demand_factor(k: String, extra := 0.0) -> float:
	var mk: Dictionary = meta.get("market", {})
	if mk.is_empty(): return 1.0
	var over := float(market_sold().get(k, 0.0)) + extra - float(mk.get("fullPrice", 6)) + 1.0
	if over <= 0.0: return 1.0
	return maxf(float(mk.get("floor", 0.5)), 1.0 - float(mk.get("dropPerUnit", 0.1)) * over)

func full_price(k: String) -> float:
	return value_of(k) * (1.0 + g("sellBonusPct", 0.0) / 100.0)

## What the next one would sell for right now.
func sell_price(k: String) -> float:
	return full_price(k) * demand_factor(k)

## What n of them would bring together right now (the market pays less after the first few of the same thing).
func sell_total(k: String, n: int) -> float:
	var t := 0.0
	for i in range(n): t += full_price(k) * demand_factor(k, float(i))
	return t

func sell(k: String, q: float) -> bool:
	var n := minf(q, floorf(count(k) + 0.0001))
	if n < 1.0 or not sellable(k): return false
	take(k, n)
	var got := 0.0
	for i in range(int(n)):
		got += sell_price(k)
		market_sold()[k] = float(market_sold().get(k, 0.0)) + 1.0
	S["coins"] += got
	_job("sell", k, n)
	var msg := "🪙 Sold %d %s for 🪙%d" % [int(n), iname(k), int(floorf(got + 0.0001))]
	if demand_factor(k) < 0.999: msg += ". The market has plenty of %s now — it pays less for a while. Different things sell best!" % iname(k)
	say(msg)
	perk_event("sell", {"item": k, "n": n, "coins": got})
	sold.emit(k, n, got)
	save_game(); changed.emit()
	return true

func _tick_market() -> void:
	var mk: Dictionary = meta.get("market", {})
	for k in market_sold().keys():
		var sold := float(market_sold()[k])
		market_sold()[k] = sold - maxf(float(mk.get("recoverPerQuestion", 1.0)), sold * float(mk.get("recoverShare", 0.0)))
		if float(market_sold()[k]) <= 0.0: market_sold().erase(k)

## What the inputs of a recipe would fetch at the market, and what its outputs fetch (full prices; things nobody buys count 0).
func recipe_worth(rid: String) -> Vector2:
	var r: Dictionary = recipes[rid]
	var a := 0.0
	for k in r["inputs"]:
		var q := float(r["inputs"][k])
		if k.begins_with("tag:"):
			var opts := tag_choices(k.substr(4))
			if not opts.is_empty(): a += value_of(opts[0]) * q
		elif sellable(k): a += value_of(k) * q
	var b := 0.0
	for k in r["outputs"]:
		if sellable(k): b += value_of(k) * float(r["outputs"][k]) * m("out:" + r["station"])
	return Vector2(a, b)

func buy_seeds(cid: String, q: int) -> bool:
	var c := float(nodes[cid].get("seedCost", 0)) * q
	if S["coins"] + 0.0001 < c: say("🪙 Not enough coins."); return false
	S["coins"] -= c
	S["seeds"][cid] = float(S["seeds"].get(cid, 0.0)) + q
	if roll(_event("seed_bargain")): S["seeds"][cid] = float(S["seeds"][cid]) + 1.0; say("🎁 The seed merchant adds one for free.")
	save_game(); changed.emit()
	return true

func buy_item(merchant: String, k: String, q: int) -> bool:
	var price := float(nodes[merchant].get("sells", {}).get(k, 0)) * q
	if S["coins"] + 0.0001 < price: say("🪙 Not enough coins."); return false
	S["coins"] -= price
	_buying = true
	add_item(k, q)
	_buying = false
	save_game(); changed.emit()
	return true

func barter(merchant: String, k: String) -> bool:
	var b: Dictionary = nodes[merchant].get("barter", {}).get(k, {})
	var c := {}
	for x in b: c[x] = float(b[x])
	if not pay(c): say("Missing what the trader wants."); return false
	var q := float(nodes[merchant].get("barterGives", {}).get(k, 1))
	_buying = true
	add_item(k, q)
	_buying = false
	say("🤝 Traded for %s%s %s" % ["%d × " % int(q) if q > 1.0 else "", iemoji(k), iname(k)])
	save_game(); changed.emit()
	return true

func eat(k: String) -> bool:
	var b = items[k].get("buff", null)
	if b == null or count(k) < 1.0: return false
	take(k, 1.0)
	S["buff"] = {"mult": float(b["energy"]), "until": S["step"] + int(b["questions"]), "item": k}
	say("😋 Yum! Work costs %d%% less energy for %d question%s." % [int(round((1.0 - float(b["energy"])) * 100)), int(b["questions"]), "" if int(b["questions"]) == 1 else "s"])
	save_game(); changed.emit()
	return true

# ------------------------------------------------------------------ knowledge cards & the library
func card_status(cid: String) -> String:
	if done(cid): return "learned"
	var n = nodes[cid]
	var book: String = n["requires"][0]
	if not done(book): return "nobook"
	for r in n.get("requires", []):
		if r != book and not satisfied(r): return "prereq"
	for k in n.get("discover", []):
		if not S["seen"].has(k): return "discover"
	if S["reading"] == cid: return "reading"
	var rd := float(n.get("cost", {}).get("read", 0))
	if rd <= 0.0 or S["read_done"].has(cid): return "quiz"
	return "readable"

func read_needed(cid: String) -> float:
	return float(nodes[cid].get("cost", {}).get("read", 0))

func start_reading(cid: String) -> bool:
	if card_status(cid) != "readable": return false
	if S["reading"] != "" and S["reading"] != cid:
		say("📖 You're already reading \"%s\". One book page at a time!" % nodes[S["reading"]]["name"]); return false
	S["reading"] = cid; S["read_progress"] = 0.0
	say("📖 Reading \"%s\": it takes %d Time Quiz question%s." % [nodes[cid]["name"], up(read_needed(cid) * m("read")), "" if up(read_needed(cid) * m("read")) == 1 else "s"])
	save_game(); changed.emit()
	return true

func _tick_reading() -> void:
	var cid: String = S["reading"]
	if cid == "": return
	S["read_progress"] = float(S["read_progress"]) + 1.0 / maxf(0.1, m("read"))
	if float(S["read_progress"]) + 0.0001 >= read_needed(cid):
		S["read_done"][cid] = true
		S["reading"] = ""
		say("📖 Finished reading \"%s\" — take its quiz in the Library!" % nodes[cid]["name"])

func card_ancestors(cid: String) -> Array:
	var out := []
	var stack: Array = nodes[cid].get("requires", []).duplicate()
	var seen := {}
	while stack.size() > 0:
		var r = stack.pop_back()
		if seen.has(r) or not nodes.has(r): continue
		seen[r] = true
		if nodes[r]["type"] == "knowledge":
			out.append(r)
			for x in nodes[r].get("requires", []): stack.append(x)
	return out

## A question laid out for showing (learnkit/quiz_engine.gd present): settings quizOptions answers (3–4; the right one and
## wrong ones, filled up from the pack's pool), pictures, the texts in settings language. answers = [{"text", "img", "emoji"}].
func _shuffled_q(src: Dictionary, cid: String, qi: int, review: bool) -> Dictionary:
	var q: Dictionary = quiz.present(src, rng, clampi(int(settings.get("quizOptions", 4)), 2, 6), quiz_tr, pack_pools.get(str(src.get("pack", "")), []))
	q["card"] = cid; q["qi"] = qi; q["review"] = review
	if q["why"] == "": q["why"] = q["right"]
	return q

func card_quiz(cid: String) -> Array:
	var n = nodes[cid]
	var qs: Array = n.get("questions", [])
	var seen: Array = S["card_qseen"].get(cid, [])
	var idx := range(qs.size())
	idx.sort_custom(func(a, b): return (1 if seen.has(a) else 0) < (1 if seen.has(b) else 0))
	var out := []
	var newq := int(meta.get("knowledge", {}).get("newQuestions", 2))
	for j in range(mini(newq, idx.size())):
		out.append(_shuffled_q(qs[idx[j]], cid, idx[j], false))
	var anc := []
	for a in card_ancestors(cid):
		if done(a): anc.append(a)
	anc.sort_custom(func(a, b): return _card_key(a) < _card_key(b))
	for j in range(mini(int(meta.get("knowledge", {}).get("maxReviewQuestions", 3)), anc.size())):
		var rq: Array = nodes[anc[j]].get("questions", [])
		if rq.is_empty(): continue
		var qi := rng.randi_range(0, rq.size() - 1)
		out.append(_shuffled_q(rq[qi], anc[j], qi, true))
	return out

func _card_key(cid: String) -> int:
	var c = S["cards"].get(cid, {})
	return int(c.get("box", 1)) * 100000 + int(c.get("last", 0))

## Called once per question when it is finally answered right. first_try = right on the first pick.
func record_card_answer(q: Dictionary, first_try: bool) -> void:
	var cid: String = q["card"]
	# every question is also kept in the learning record by its id (how well the child knows it)
	if str(q.get("id", "")) != "":
		quiz.record(_learn(), str(q["id"]), first_try)
		save_learning()
	if not S["card_qseen"].has(cid): S["card_qseen"][cid] = []
	if not S["card_qseen"][cid].has(int(q["qi"])): S["card_qseen"][cid].append(int(q["qi"]))
	if q.get("review", false) and done(cid):
		var c = S["cards"].get(cid, {"box": 1})
		c["box"] = mini(4, int(c.get("box", 1)) + 1) if first_try else 1
		c["last"] = S["step"]; c["time"] = Time.get_unix_time_from_system()
		S["cards"][cid] = c

func finish_card(cid: String, all_first_try: bool) -> void:
	if done(cid): return
	S["cards"][cid] = {"box": 2 if all_first_try else 1, "last": S["step"], "time": Time.get_unix_time_from_system()}
	S["read_done"].erase(cid)
	S["unlocked"][cid] = true
	_dirty()
	var n = nodes[cid]
	var unl := []
	for u in n.get("unlocks", []):
		if nodes.has(u): unl.append(nodes[u].get("emoji", "") + " " + nodes[u]["name"])
		elif recipes.has(u): unl.append("🍳 " + str(recipes[u].get("name", iname(recipes[u]["outputs"].keys()[0]))))
	say("🎓 You know: %s!%s" % [n["name"], (" Now possible: " + ", ".join(unl)) if unl.size() > 0 else ""])
	S["goals"] = int(S["goals"]) + 1
	if int(S["goals"]) % 12 == 0: _offer_gift(_news("goals"))
	_check_acorns()
	_auto_unlocks()
	save_game(); changed.emit()

func due_cards() -> Array:
	var out := []
	var now := Time.get_unix_time_from_system()
	for cid in card_ids:
		if not done(cid): continue
		var c = S["cards"].get(cid, {"box": 1, "last": 0, "time": now})
		var b := clampi(int(c.get("box", 1)), 1, 4)
		if S["step"] - int(c.get("last", 0)) >= STEP_GAPS[b - 1] or now - float(c.get("time", now)) >= DAY_GAPS[b - 1] * 86400.0:
			out.append(cid)
	return out

## The next Time Quiz question: mostly the parent's packs, sometimes a due knowledge review.
func next_time_question() -> Dictionary:
	var share := float(settings.get("knowledgeReviewShare", 0.25))
	if share > 0.0 and rng.randf() < share:
		var due := due_cards()
		if due.size() > 0:
			var cid: String = due[rng.randi_range(0, due.size() - 1)]
			var qs: Array = nodes[cid].get("questions", [])
			if qs.size() > 0:
				var qi := rng.randi_range(0, qs.size() - 1)
				var q := _shuffled_q(qs[qi], cid, qi, true)
				q["source"] = "📚 Review: " + nodes[cid]["name"]
				return q
	var recent: Array = S["recent_q"]
	var pool := []
	for i in range(pack_questions.size()):
		if not recent.has(i): pool.append(i)
	if pool.is_empty(): pool = range(pack_questions.size())
	var pick: int = pool[rng.randi_range(0, pool.size() - 1)]
	# the player's own record (learnkit/quiz_engine.gd): a question answered wrong comes back after a few others;
	# new ones come before known ones
	var cands := []
	for i in pool: cands.append(pack_questions[i])
	var ci: int = quiz.pick(_learn(), cands, rng)
	if ci >= 0: pick = pool[ci]
	recent.append(pick)
	while recent.size() > int(settings.get("avoidRepeatWithin", 3)): recent.pop_front()
	var src: Dictionary = pack_questions[pick]
	var q2 := _shuffled_q(src, "", pick, false)
	q2["wrong_text"] = q2["wrong"]
	q2["source"] = "⏳ Time Quiz"
	return q2

## Remembers how a Time Quiz question went for this player, under its id (wrong: back after 3 others; right: 12, 32, 80 … later).
func time_result(q: Dictionary, first_try: bool) -> void:
	if q.get("review", false) or str(q.get("id", "")) == "": return
	quiz.record(_learn(), str(q["id"]), first_try)
	save_learning()

# ------------------------------------------------------------------ Rest (sleep, food, water)
## The player's maths record, with the categories practised (settings.json mathCategories; a parent can add more).
func math_record() -> Dictionary:
	var r: Dictionary = math.rec(_learn(), settings.get("mathCategories", ["addsub"]))
	for c in settings.get("mathCategories", ["addsub"]):
		if not r["active"].has(c): r["active"].append(c)
	return r

## The next Rest sum (learnkit/math_engine.gd: levels from 1 + 1 on, spaced repetition for every task, medals).
func rest_question() -> Dictionary:
	math_record()
	return math.question(_learn(), rng, float(settings.get("restTimerScale", 1.0)))

## Remembers how a Rest sum went and says what to show (see math_engine.result).
func rest_result(q: Dictionary, right: bool, fast: bool) -> Dictionary:
	var fb: Dictionary = math.result(_learn(), q, right, fast, rng)
	after_rest_answer(right, fast)
	return fb

## After every Rest answer (the number pad asks and remembers by itself): save, count quick ones for the perks.
func after_rest_answer(right: bool, fast: bool) -> void:
	save_learning()
	if right and fast: S["stats"]["rest_quick"] = int(S["stats"].get("rest_quick", 0)) + 1
	_check_perks()

## The level of a Rest task for the window (see math_engine.level_info).
func arith_info(level_id := "") -> Dictionary:
	return math.level_info(_learn(), level_id)

## fast = answered before the Rest timer ran out (settings.json restTimerSeconds); slow answers give restSlowShare of it.
func rest_correct(fast := true) -> float:
	var before := float(S["energy"])
	var gain := rest_per_answer() * (1.0 if fast else float(settings.get("restSlowShare", 0.5)))
	S["energy"] = minf(energy_max(), before + gain)
	S["stats"]["rest"] = int(S["stats"]["rest"]) + 1
	_job("rest", "", 1.0)
	changed.emit()
	return float(S["energy"]) - before

# ------------------------------------------------------------------ luck
func luck() -> float:
	var l := g("luck", 0.0)
	for pid in ["pet_bunny", "pet_tortoise", "pet_goat", "pet_pony", "pet_alpaca"]:
		if done(pid): l += 0.05
	for b in S["luck_boosts"]:
		if int(b[1]) > S["step"]: l += float(b[0])
	return l

func add_luck(amount: float, questions: int) -> void:
	S["luck_boosts"].append([amount, S["step"] + questions])

func _event(id: String) -> Dictionary:
	for e in meta.get("luck", {}).get("events", []):
		if e["id"] == id: return e
	return {}

func roll(e: Dictionary) -> bool:
	if e.is_empty(): return false
	var ch = e.get("chance", 0.0)
	if typeof(ch) == TYPE_STRING: return false
	return rng.randf() < float(ch) * (1.0 + luck())

func _weed_luck() -> void:
	if roll(_event("weed_coin")): S["coins"] += 2.0; say("🪙 A lost coin in the weeds!")
	if roll(_event("weed_seed")):
		var cs := crops_for("field")
		if cs.size() > 0:
			var c: String = cs[rng.randi_range(0, cs.size() - 1)]
			if not nodes[c].has("seedItem"): S["seeds"][c] = float(S["seeds"].get(c, 0.0)) + 1.0; say("🌱 An old seed packet: +1 %s seed!" % nodes[c]["name"])
	if roll(_event("weed_clover")): add_luck(0.3, 20); say("🍀 A four-leaf clover! You feel lucky.")
	if roll(_event("weed_relic")):
		add_item("relic", 1.0); S["album"].append({"id": "relic", "text": "An old relic you dug up while weeding", "emoji": "🏺"}); say("🏺 Something old in the soil: a relic for the album!")
	if not S["acorns"].has("acorn_lucky") and roll(_event("golden_acorn")):
		S["acorns"]["acorn_lucky"] = true; _dirty(); say("🌰✨ A golden acorn glints under a leaf! Energy max +3 for good.")

# ------------------------------------------------------------------ one Time Quiz answer = one step of farm time
func step_time() -> Dictionary:
	S["step"] = int(S["step"]) + 1
	_tick_pace()
	var info := {"removed": 0, "arrived": 0.0, "rain": false, "season": false}
	var sn := season_no()
	if sn != int(S["last_season"]):
		_season_change(sn)
		S["last_season"] = sn
		info["season"] = true
	# rain
	var rain_ch := float(smod("rain", 0.0)) * (1.0 + 0.3 * luck())
	var was_rain: bool = S.get("rain", false)
	S["rain"] = rng.randf() < rain_ch
	info["rain"] = S["rain"]
	info["rain_stopped"] = was_rain and not S["rain"]
	# water never comes by itself (it is carried); rain waters the fields: planting costs no water this question
	if g("waterPerStep", 0.0) > 0.0: S["water"] = minf(water_cap(), float(S["water"]) + g("waterPerStep", 0.0))
	# passive producers (woodlot, pets)
	for k in caps()["produces"]:
		add_item(k, float(caps()["produces"][k]), true)
	# crops
	for a in ["field", "orchard", "gh"]:
		var arr: Array = area(a)
		for i in range(arr.size()):
			var p = arr[i]
			if p["crop"] == "" or p["ready"]: continue
			p["growth"] = float(p["growth"]) + grow_speed(a, p)
			if float(p["growth"]) + 0.0001 >= grow_target(p): p["ready"] = true
	_tick_weeds_stones()
	var pr := _tick_pests()
	info["removed"] = pr["removed"]; info["arrived"] = pr["arrived"]; info["eaten"] = pr["eaten"]; info["eat_share"] = pr["eat_share"]
	_tick_stations()
	_tick_reading()
	_tick_home_fuel()
	_tick_market()
	# polish that wears with time
	_wear("question")
	# neighbour gifts
	if roll(_event("neighbour_gift")):
		var opts := []
		for k in S["seen"]:
			if items.has(k) and items[k].get("category", "") in ["crop", "animal", "ingredient"]: opts.append(k)
		if opts.size() > 0:
			var k2: String = opts[rng.randi_range(0, opts.size() - 1)]
			add_item(k2, 2.0, true); say("🧺 A neighbour drops off a little gift basket: %s×2" % iemoji(k2))
	# expire luck boosts
	var keep := []
	for b in S["luck_boosts"]:
		if int(b[1]) > S["step"]: keep.append(b)
	S["luck_boosts"] = keep
	_check_acorns()
	_auto_unlocks()
	_check_perks()
	_dirty()
	save_game()
	step_done.emit(info)
	changed.emit()
	return info

func weed_rate() -> float:
	var w = meta.get("weeds", {})
	var tiers: Array = w.get("tierByChapter", [1, 1.2, 1.5, 2, 2.5])
	var tier := float(tiers[mini(tiers.size(), chapter()) - 1])
	var fp := maxf(0.0, float(plants_per_patch("field")) - free_density())
	return float(w.get("ratePerQuestion", 0.15)) * tier * float(smod("weeds", 1.0)) * (1.0 + float(w.get("fertilizerFactor", 0.4)) * fp) * m("weeds")

func _tick_weeds_stones() -> void:
	var wr := weed_rate()
	var st = meta.get("stones", {})
	var winter := season() == "winter"
	var depth := float(st.get("deepBedFactor", {}).get(str(plants_per_patch("field")), 1.0))
	for i in range(S["patches"].size()):
		if not patch_usable("field", i): continue
		var p = S["patches"][i]
		p["weeds"] = minf(12.0, float(p["weeds"]) + wr)
		if winter:
			var h := float(st.get("heavePerPatch", 0.07)) * depth * (float(st.get("barePatchFactor", 1.5)) if p["crop"] == "" else 1.0) * m("stones")
			p["stones"] = minf(float(st.get("capPerPatch", 6)), float(p["stones"]) + h)

func plants_growing() -> float:
	var t := 0.0
	for i in range(S["patches"].size()):
		var p = S["patches"][i]
		if p["crop"] != "" and not p["ready"]: t += float(p["plants"])
	for p in S["orchard"]:
		if p["crop"] != "": t += 0.5
	return t

func pest_block() -> float:
	return minf(0.9, g("pestBlock", 0.0))

func pest_scare() -> float:
	return g("scare", 0.0)

func pest_arrivals() -> float:
	var pe = meta.get("pests", {})
	if pe.is_empty(): return 0.0
	var tiers: Array = pe.get("tierByChapter", [1])
	var tier := float(tiers[mini(tiers.size(), chapter()) - 1])
	return float(pe.get("ratePerPlant", 0.05)) * plants_growing() * tier * float(smod("pests", 1.0)) * m("pests") * (1.0 - pest_block())

func _tick_pests() -> Dictionary:
	var pe = meta.get("pests", {})
	if pe.is_empty(): return {"removed": 0, "arrived": 0.0, "eaten": {}, "eat_share": 0.0}
	var plants := plants_growing()
	var arrive := pest_arrivals()
	var r := float(S["pests"]) + arrive
	var removed := minf(r, pest_scare())
	r -= removed
	r -= r * float(pe.get("leaveRate", 0.2))
	var cap := float(pe.get("capBase", 4)) + float(pe.get("capPerPlant", 0.2)) * plants
	r = clampf(r, 0.0, cap)
	S["pests"] = r
	# the pests that stay eat a share of every growing patch (worked out exactly; the map shows it rounded)
	var share := pest_eat_share()
	var eaten := {}
	if plants > 0.0 and share > 0.0:
		for i in range(S["patches"].size()):
			var p = S["patches"][i]
			if p["crop"] == "" or p["ready"]: continue
			var before := float(p["plants"])
			var after := maxf(1.0, before * (1.0 - share))
			p["plants"] = after
			var lost := shown_plants(before) - shown_plants(after)
			if lost > 0: eaten[i] = lost
	return {"removed": int(round(removed)), "arrived": arrive, "eaten": eaten, "eat_share": share}

## Share of the growing plants the pests eat in one question (exact; shown rounded to whole percent).
func pest_eat_share() -> float:
	var pe = meta.get("pests", {})
	return clampf(float(S["pests"]) * float(pe.get("eatPerPest", 0.02)), 0.0, float(pe.get("maxEat", 0.35)))

## How many plants a patch shows for a (fractional) number of plants.
func shown_plants(x: float) -> int:
	return clampi(int(round(x)), 0, 9)

func _tick_home_fuel() -> void:
	if season() != "winter":
		S["cold"] = false
		return
	var need := g("homeFuel", 0.2) * m("homeFuel") * m("fuel")
	auto_stack(need)
	if float(S["woodpile"]) + 0.0001 >= need:
		S["woodpile"] = float(S["woodpile"]) - need
		if S["cold"]: say("🔥 The house is warm again.")
		S["cold"] = false
	else:
		if not S["cold"]: say("❄️🏠 The house is cold: no firewood! Rest gives less energy. Stack sticks or logs on the woodpile.")
		S["cold"] = true

func _season_change(sn: int) -> void:
	var nm: String = SEASON_NAMES[sn % 4]
	var spoiled := {}
	var fr = meta.get("freshness", {})
	var animal_items: Array = fr.get("animalItems", [])
	for k in S["inv"].keys():
		var life := shelf_life(k)
		if life < 0: continue
		var arr: Array = S["inv"][k]
		var keep := []
		var lost := 0.0
		for b in arr:
			if sn - int(b[0]) > life: lost += float(b[1])
			else: keep.append(b)
		if lost > 0.0:
			if keep.is_empty(): S["inv"].erase(k)
			else: S["inv"][k] = keep
			var to: String = fr.get("spoilsTo", {}).get("animal" if animal_items.has(k) else "plant", "compost")
			add_item(to, lost, true)
			spoiled[k] = lost
	var msg := "%s It's %s! %s" % [str(meta["seasons"]["mods"][nm].get("emoji", "")), nm, str(meta["seasons"]["mods"][nm].get("abundance", ""))]
	say(msg)
	if not spoiled.is_empty():
		var parts := []
		for k in spoiled: parts.append("%s%d" % [iemoji(k), up(spoiled[k])])
		say("🍂 Went stale at the change of season (now feed mash or compost): " + " ".join(parts))
	_check_acorns()

# ------------------------------------------------------------------ gift cards (pick 1 of 3)
func gift_card(gid: String) -> Dictionary:
	for c in meta.get("giftCards", {}).get("pool", []):
		if c["id"] == gid: return c
	return {}

## The people you helped (finished side quests), each person once: [{"name", "emoji", "quest"}].
func friends() -> Array:
	var out := []
	var seen := {}
	for id in nodes:
		var n = nodes[id]
		if n["type"] != "sidequest" or not done(id): continue
		var f: Dictionary = n.get("friend", {})
		var nm := str(f.get("name", n["name"]))
		if seen.has(nm): continue
		seen[nm] = true
		out.append({"name": nm, "emoji": str(f.get("emoji", "💌")), "quest": id})
	return out

## What a friend heard of: "your new bunny", "your library growing", "all your work on the farm (24 jobs done!)".
func _news(kind: String, what := "") -> String:
	var t := str(meta.get("postcards", {}).get("news", {}).get(kind, "all your work on the farm"))
	return t.replace("{pet}", what).replace("{n}", str(int(S["goals"])))

## Something big happened: a friend may hear of it and send a postcard with a gift. The more friends, the likelier,
## and the more gifts to choose from (as many as friends, 3 at most). The very first postcard always comes.
func _offer_gift(news := "") -> void:
	var fr := friends()
	if fr.is_empty(): return
	var cfg: Dictionary = meta.get("postcards", {})
	var first: bool = S.get("postcards", []).is_empty() and S["gift_pending"].is_empty()
	var chance := minf(1.0, float(cfg.get("chanceBase", 0.35)) + float(cfg.get("chancePerFriend", 0.2)) * fr.size())
	if not (first and cfg.get("firstSure", true)) and rng.randf() > chance: return
	var waiting := []
	for pc in S["gift_pending"]: waiting.append_array(pc.get("offer", []))
	var pool := []
	for c in meta.get("giftCards", {}).get("pool", []):
		if S["gift_owned"].has(c["id"]) or waiting.has(c["id"]): continue
		pool.append(c["id"])
	pool.shuffle()
	var offer := pool.slice(0, mini(int(cfg.get("choicesMax", 3)), fr.size()))
	if offer.is_empty(): return
	var f: Dictionary = fr[rng.randi_range(0, fr.size() - 1)]
	var msgs: Array = cfg.get("messages", ["Dear {player}, I heard about {news}! Here is a little something for your farm."])
	var text := str(msgs[rng.randi_range(0, msgs.size() - 1)])
	text = text.replace("{player}", player if player != "" else "friend").replace("{news}", news if news != "" else "all your work on the farm")
	text = text.substr(0, 1).to_upper() + text.substr(1)
	S["gift_pending"].append({"from": f["name"], "emoji": f["emoji"], "quest": f["quest"], "text": text, "offer": offer, "step": int(S["step"])})
	say("📬 A postcard from %s!" % f["name"])
	offer_cards.emit(offer)

## The postcard waiting to be opened (or {}).
func postcard_pending() -> Dictionary:
	return S["gift_pending"][0] if S["gift_pending"].size() > 0 else {}

## Takes the gift gid from the first waiting postcard; the postcard goes into the album.
func pick_gift(gid: String) -> void:
	if S["gift_pending"].is_empty(): return
	var pc: Dictionary = S["gift_pending"].pop_front()
	S["gift_owned"].append(gid)
	if not S.has("postcards"): S["postcards"] = []
	S["postcards"].append({"from": pc.get("from", ""), "emoji": pc.get("emoji", "💌"), "quest": pc.get("quest", ""), "text": pc.get("text", ""), "gift": gid,
		"step": int(pc.get("step", S["step"]))})
	var c = gift_card(gid)
	say("💌 %s %s: %s" % [c.get("emoji", ""), c["name"], c.get("desc", "")])
	_activate_new_gift(gid)
	_dirty(); save_game(); changed.emit()

func gift_max() -> int:
	return int(meta.get("giftCards", {}).get("maxActive", 2))

func gift_is_active(gid: String) -> bool:
	return S.get("gift_active", []).has(gid)

## A new card works at once if there is room; otherwise it waits in the album until it is swapped in.
func _activate_new_gift(gid: String) -> void:
	if not S.has("gift_active"): S["gift_active"] = []
	if S["gift_active"].size() < gift_max(): S["gift_active"].append(gid)
	else: say("🎴 Only %d cards work at a time — the new one waits in your album 🖼️ (swap it in there)." % gift_max())

## Put a card to work or let it rest (at most gift_max() work at the same time).
func toggle_gift(gid: String) -> bool:
	if not S["gift_owned"].has(gid): return false
	if gift_is_active(gid):
		S["gift_active"].erase(gid)
	elif S["gift_active"].size() >= gift_max():
		say("🎴 Only %d cards can work at a time: put one to rest first." % gift_max())
		return false
	else:
		S["gift_active"].append(gid)
	_dirty(); save_game(); changed.emit()
	return true

# ------------------------------------------------------------------ little jobs
func _refill_jobs() -> void:
	var jm = meta.get("jobs", {})
	var want := int(jm.get("slots", 3))
	var guard := 0
	while S["jobs"].size() < want and guard < 30:
		guard += 1
		var j := _make_job()
		if not j.is_empty(): S["jobs"].append(j)

func _make_job() -> Dictionary:
	var temps: Array = meta.get("jobs", {}).get("templates", [])
	if temps.is_empty(): return {}
	var t = temps[rng.randi_range(0, temps.size() - 1)]
	var n := rng.randi_range(int(t["n"][0]), int(t["n"][1]))
	var item := ""
	var label := ""
	match t["type"]:
		"harvest":
			var cs := crops_for("field")
			if cs.is_empty(): return {}
			var c: String = cs[rng.randi_range(0, cs.size() - 1)]
			item = nodes[c]["yields"].keys()[0]; label = iname(item)
		"make":
			var opts := []
			for root in stations():
				for rid in station_recipes_for(root):
					if recipe_open(rid) and float(recipes[rid].get("energy", 0)) > 0: opts.append(rid)
			if opts.is_empty(): return {}
			item = opts[rng.randi_range(0, opts.size() - 1)]
			label = str(recipes[item].get("name", iname(recipes[item]["outputs"].keys()[0])))
		"collect":
			var an := []
			for aid in S["animals"]:
				if int(S["animals"][aid]["count"]) > 0: an.append(aid)
			if an.is_empty(): return {}
			item = an[rng.randi_range(0, an.size() - 1)]; label = nodes[item]["name"]; n = 1
		"stones":
			var any := false
			for p in S["patches"]:
				if float(p["stones"]) >= 1.0: any = true
			if not any and season() != "winter": return {}
	for j in S["jobs"]:
		if j["type"] == t["type"] and j["item"] == item: return {}
	var text: String = str(t["text"]).replace("{n}", str(n)).replace("{item}", label)
	return {"type": t["type"], "item": item, "n": n, "got": 0.0, "text": text}

func _job(type: String, item: String, q: float) -> void:
	var finished := []
	for j in S["jobs"]:
		if j["type"] != type: continue
		if j["item"] != "" and j["item"] != item: continue
		j["got"] = float(j["got"]) + q
		if float(j["got"]) + 0.0001 >= float(j["n"]): finished.append(j)
	for j in finished:
		S["jobs"].erase(j)
		var jm = meta.get("jobs", {})
		var coins := float(jm.get("rewardCoinsPerChapter", 4)) * chapter()
		S["coins"] += coins
		var rl: Array = jm.get("rewardLuck", [0.1, 10])
		add_luck(float(rl[0]), int(rl[1]))
		say("📋 Little job done: %s → 🪙%d and a bit of luck ☘️" % [j["text"], int(coins)])
	if finished.size() > 0: _refill_jobs()

# ------------------------------------------------------------------ golden acorns
func _check_acorns() -> void:
	var ac = meta.get("acorns", {})
	for a in ac.get("list", []):
		var id: String = a["id"]
		if S["acorns"].has(id): continue
		var ok := cond(str(a["when"]))
		if ok:
			S["acorns"][id] = true
			_dirty()
			say("🌰✨ Golden Acorn: %s! Energy max +%d for good." % [a["name"], int(ac.get("energyMaxEach", 3))])
	_check_perks()

## A condition from the data: "unlocked:id" or "<counter>>=N" (sidequests, seasons, weeds, cards, harvests, rest_quick,
## medals (Rest sum medals won), arith_level, sold_kinds, friends).
func cond(w: String) -> bool:
	if w.begins_with("unlocked:"): return done(w.substr(9))
	var p := w.split(">=")
	if p.size() != 2: return false
	var n := float(p[1])
	var st: Dictionary = S["stats"]
	match p[0]:
		"sidequests": return float(st.get("sidequests", 0)) >= n
		"seasons": return float(season_no()) >= n
		"weeds": return float(st.get("weeds", 0)) >= n
		"cards": return float(cards_learned()) >= n
		"harvests": return float(st.get("harvests", 0)) >= n
		"rest_quick": return float(st.get("rest_quick", 0)) >= n
		"medals": return float(math.medal_count(_learn())) >= n
		"arith_level": return float(math.medal_count(_learn(), "bronze") + 1) >= n
		"sold_kinds": return float(S.get("sold_kinds", {}).size()) >= n
		"friends": return float(friends().size()) >= n
	return false

# ------------------------------------------------------------------ perks: small extras for favours and achievements
func perk_def(id: String) -> Dictionary:
	for p in meta.get("perks", {}).get("list", []):
		if p["id"] == id: return p
	return {}

func perks() -> Dictionary:
	if not S.has("perks"): S["perks"] = {}
	return S["perks"]

func perk_owned(id: String) -> bool:
	return perks().has(id)

## Owned and switched on (the album has a switch for each).
func perk_on(id: String) -> bool:
	return bool(perks().get(id, false))

func toggle_perk(id: String) -> void:
	if not perk_owned(id): return
	perks()[id] = not perk_on(id)
	save_game(); changed.emit()

func give_perk(id: String) -> void:
	if perk_owned(id) or perk_def(id).is_empty(): return
	perks()[id] = true
	var p := perk_def(id)
	say("✨ New perk: %s %s!" % [p.get("emoji", ""), p["name"]])
	celebrate.emit("perk:" + id)

func _check_perks() -> void:
	for p in meta.get("perks", {}).get("list", []):
		if perk_owned(p["id"]) or str(p.get("when", "")) == "": continue
		if cond(str(p["when"])): give_perk(p["id"])

## Something happened that perks count (things sold …).
func perk_event(kind: String, data := {}) -> void:
	if kind == "sell":
		if not S.has("sold_kinds"): S["sold_kinds"] = {}
		S["sold_kinds"][str(data.get("item", ""))] = true
	_check_perks()

# ------------------------------------------------------------------ cheat (for testing)
func something_pending() -> bool:
	for a in ["field", "orchard", "gh"]:
		for p in area(a):
			if p["crop"] != "" and not p["ready"]: return true
	for root in S["running"]:
		if (S["running"][root] as Array).size() > 0: return true
	for aid in S["animals"]:
		if int(S["animals"][aid]["count"]) > 0 and S["step"] < int(S["animals"][aid]["ready"]): return true
	if S["reading"] != "": return true
	return false

func cheat_max() -> void:
	var n := 0
	while something_pending() and n < 60:
		step_time(); n += 1
	S["energy"] = energy_max()
	S["water"] = water_cap()
	say("⏩ Cheat: %d questions of time passed, energy and water full." % n)
	save_game(); changed.emit()

func cheat_coins(q: float) -> void:
	S["coins"] += q
	say("🪙 Cheat: +%d coins" % int(q))
	save_game(); changed.emit()
