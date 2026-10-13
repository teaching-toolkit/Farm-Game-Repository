extends Node
## Hazelwood Harvest (the farm quiz game) — the rules' front door (autoload "Game").
## It holds the data (res://data/farm/: the progression split into files, places, animals, chapters), the farm's state S, players and saves, the
## signals everyone listens to (changed, toast, gained, sold, celebrate …: the game's event hub), the core parts
## (kits/core: modifiers, conditions, random numbers, the clock) and the systems the rules are split into
## (game/farm/systems/: seasons, items, progression, pacing, fields, resources, animals, crafting, trade,
## knowledge, needs, rewards). Every old function name still works here and passes the call on to its system.
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

const SEASON_WORDS := ["spring", "summer", "autumn", "winter"]   # i18n (shown with tr(): "It's spring!")
const SAVE_PATH := "user://farm_save.json"          # the farm from before players had names
const PLAYERS_DIR := "user://players"               # players/<name>/farm_save.json and learning.json
const LAST_PLAYER := "user://last_player.txt"
const DEVICE_PATH := "user://device.json"         # settings of this device (cheat buttons, read aloud …), not of a farm
const FARM_DIR := "res://data/farm"   # the progression data, split into files (tools/farm_data.py explains the layout)
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
var lang_override := ""                # a language for this run only (--lang=de for screenshots and tests)
var quiz_tr: Dictionary = {}         # translations of the quiz texts by question id (data/i18n/quiz-<language>.json)
var quiz_keys: Dictionary = {}       # old learning-record key (question text) -> question id
var tags: Dictionary = {}
var replaced_by: Dictionary = {}
var station_recipes: Dictionary = {}
var polish_ids: Array = []
var card_ids: Array = []
var farm_animals: Dictionary = {}    # data/farm/animals.json: farm animals, pets, their voices
var chapters_cfg: Dictionary = {}    # data/farm/chapters.json: how the chapter number is worked out
const Modifiers = preload("res://kits/core/modifiers.gd")
const Saves = preload("res://kits/core/saves.gd")
## The save's layout version (kits/core/saves.gd). Raise it by one whenever the shape of something in S changes in a way
## that missing keys with their defaults cannot cover, and add the step that turns the old shape into the new one to
## _save_upgrades(). New keys alone need no new version: state_defaults() fills them in.
const SAVE_VERSION := 1
const Rng = preload("res://kits/core/rng.gd")
var R = Rng.new()                                # the one random source of the rules (kits/core/rng.gd)
var rng: RandomNumberGenerator = R.gen           # the same generator, for code and kits that take one
var conditions = preload("res://kits/core/conditions.gd").new()   # "when" texts in the data (kits/core/conditions.gd)
var clock = preload("res://kits/core/clock.gd").new()             # what happens on one step of time, in order
## The systems the rules are split into (game/farm/systems/, R4). The functions below that only pass a call on keep
## every old name working; new code can call the system directly (G.sys_fields.harvest …).
var sys_animals = preload("res://game/farm/systems/animals.gd").new()
var sys_crafting = preload("res://game/farm/systems/crafting.gd").new()
var sys_fields = preload("res://game/farm/systems/fields.gd").new()
var sys_items = preload("res://game/farm/systems/items.gd").new()
var sys_knowledge = preload("res://game/farm/systems/knowledge.gd").new()
var sys_needs = preload("res://game/farm/systems/needs.gd").new()
var sys_pacing = preload("res://game/farm/systems/pacing.gd").new()
var sys_progression = preload("res://game/farm/systems/progression.gd").new()
var sys_resources = preload("res://game/farm/systems/resources.gd").new()
var sys_rewards = preload("res://game/farm/systems/rewards.gd").new()
var sys_seasons = preload("res://game/farm/systems/seasons.gd").new()
var sys_trade = preload("res://game/farm/systems/trade.gd").new()
const Learner = preload("res://kits/learn/learner.gd")
var math = preload("res://kits/learn/math_engine.gd").new()   # Rest sums: curriculum, spaced repetition, medals (learnkit)
var quiz = preload("res://kits/learn/quiz_engine.gd").new()   # Time Quiz questions: spaced repetition (learnkit)
var learner = Learner.new()                                 # the player's learning record (a JSON file anyone can open)

var S: Dictionary = {}
var player := ""                 # who is playing: their own farm and their own learning record
var L: Dictionary = {}           # the learning record (Rest sums, Time Quiz questions): kept when a new game starts
var _caps = null
var _overflow := {}       # what did not fit into the store since the last gained signal
var _produced := 0.0      # worth of what came in since the last Time Quiz question (for the pace, dynamic difficulty)
var _buying := false      # bought things are not "produced"
## --seed=N (tests, bot, screenshots): the same seed gives the same game. All random numbers come from rng,
## the clock moves with the steps instead of the wall clock, and nothing is read from or written to the device
## (no players, no save, a fresh learning record). Save files can still be written on purpose with save_to().
var test_seed := -1
const TEST_CLOCK_START := 1800000000.0   # a fixed moment in 2027; one step of time counts as 10 minutes

func _test_args() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--seed="): test_seed = int(a.substr(7))

## The time now in seconds (the wall clock, or the test clock with --seed).
func now() -> float:
	if test_seed >= 0: return TEST_CLOCK_START + float(S.get("step", 0)) * 600.0
	return Time.get_unix_time_from_system()

## Shuffles an array with the game's own random numbers (so a seed gives the same order).
func shuffle(a: Array) -> void:
	R.shuffle(a)

func _init() -> void:
	for s in [sys_animals, sys_crafting, sys_fields, sys_items, sys_knowledge, sys_needs, sys_pacing, sys_progression, sys_resources, sys_rewards, sys_seasons, sys_trade]: s.G = self

func _ready() -> void:
	_test_args()
	_setup_conditions()
	_setup_clock()
	if test_seed >= 0:
		R.seed_with(test_seed)
		seed(test_seed)
		math.now_func = now
	else:
		R.randomize()
	load_data()
	if test_seed >= 0:
		new_game()
		return
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

## Settings of this device that a grown-up chooses (not part of a farm or a player): cheat buttons, read aloud …
var _device = null
func device_get(k: String, d = null):
	if _device == null:
		_device = _read_json(DEVICE_PATH) if test_seed < 0 and FileAccess.file_exists(DEVICE_PATH) else {}
	return _device.get(k, d)

func device_set(k: String, v) -> void:
	device_get(k)
	_device[k] = v
	if test_seed >= 0: return
	var f := FileAccess.open(DEVICE_PATH, FileAccess.WRITE)
	if f: f.store_string(JSON.stringify(_device))

func save_learning() -> void:
	if player == "" or test_seed >= 0: return
	learner.data = L
	learner.save()

func _learn() -> Dictionary:
	if L.is_empty():
		learner.open(learn_path() if player != "" else "", player)
		L = learner.data
		quiz.rekey(L, quiz_keys)
	return L

# ------------------------------------------------------------------ data
## Switches the language of this device and reloads the texts (the farm and the learning record stay as they are).
func set_language(l: String, save := true) -> void:
	if save: I18n.save_device_language(l)
	lang_override = "" if save else l
	load_data()
	changed.emit()

func _read_json(path: String) -> Dictionary:
	var d = JSON.parse_string(FileAccess.get_file_as_string(path)) if FileAccess.file_exists(path) else null
	if typeof(d) != TYPE_DICTIONARY:
		push_error("%s missing or broken" % path)
		return {}
	return d

## The pets in the order they come, and the farm animals (data/farm/animals.json).
func pet_ids() -> Array:
	return farm_animals.get("pets", [])

func animal_ids() -> Array:
	return farm_animals.get("animals", [])

## The progression data put back together from data/farm/ (the same layout tools/farm_data.py reads and writes):
## {"meta": rules/*.json, "chapters": chapters.json "list", "start", "items", "nodes": nodes/ch*.json in the order of
## nodes/order.json (a node not listed comes last), "recipes"}.
func _load_farm_data() -> Dictionary:
	var meta := {}
	for f in DirAccess.get_files_at(FARM_DIR + "/rules"):
		if f.ends_with(".json"): meta.merge(_read_json(FARM_DIR + "/rules/" + f), true)
	var by_id := {}
	var chs := []
	for f in DirAccess.get_files_at(FARM_DIR + "/nodes"):
		if f.begins_with("ch") and f.ends_with(".json"): chs.append(int(f.substr(2, f.length() - 7)))
	chs.sort()
	for c in chs: by_id.merge(_read_json("%s/nodes/ch%d.json" % [FARM_DIR, c]).get("nodes", {}), true)
	var nds := {}
	for id in _read_json(FARM_DIR + "/nodes/order.json").get("order", []):
		if by_id.has(id): nds[id] = by_id[id]
	for id in by_id:
		if not nds.has(id): nds[id] = by_id[id]
	return {"meta": meta, "chapters": _read_json(FARM_DIR + "/chapters.json").get("list", []),
		"start": _read_json(FARM_DIR + "/start.json").get("start", {}), "items": _read_json(FARM_DIR + "/items.json").get("items", {}),
		"nodes": nds, "recipes": _read_json(FARM_DIR + "/recipes.json").get("recipes", {})}

func load_data() -> void:
	D = _load_farm_data()
	items = D["items"]; nodes = D["nodes"]; recipes = D["recipes"]; meta = D["meta"]
	farm_animals = _read_json("res://data/farm/animals.json")
	chapters_cfg = _read_json("res://data/farm/chapters.json")
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
	# the language of this device: interface texts, then the data's texts on top of the English ones (kits/i18n/i18n.gd)
	var lang := lang_override if lang_override != "" else I18n.device_language(str(settings.get("language", "en")))
	settings["language"] = lang
	I18n.apply(lang)
	I18n.overlay(D, I18n.texts("data"))
	math.load_curriculum(str(settings.get("mathCurriculum", "res://kits/learn/curriculum/math.json")), I18n.texts("learn"))
	packs.clear(); pack_questions.clear(); pack_pools.clear(); quiz_keys.clear()
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

## What a new farm starts with, by the part of the game that owns it (missing keys of an older save get these too).
func state_defaults() -> Dictionary:
	var st: Dictionary = D["start"]
	return {
		# the farmer and time
		"step": 0, "coins": float(st.get("coins", 0)), "water": float(st.get("water", 10)), "energy": float(st.get("energy", 10)),
		# items (store, seen, seeds)
		"inv": {}, "seen": {}, "seeds": {},
		# progression (what is built, polish, helpers attached, steps)
		"unlocked": {}, "polish": {}, "attach": {},
		# fields, orchard, greenhouse; animals; crafting
		"patches": [], "orchard": [], "gh": [], "animals": {}, "running": {}, "woodpile": 0.0, "pests": 0.0,
		# knowledge
		"reading": "", "read_progress": 0.0, "read_done": {}, "cards": {}, "card_qseen": {},
		# needs, rewards
		"buff": {}, "luck_boosts": [], "gift_owned": [], "gift_shop": [], "gift_seen": [], "gift_pending": [], "goals": 0,
		"jobs": [], "practice": {}, "acorns": {}, "album": [], "pet_names": {},
		"stats": {"weeds": 0.0, "stones": 0.0, "sidequests": 0, "harvests": 0, "rest": 0}, "last_season": 0,
		"cold": false, "rain": false, "recent_q": [], "log": [], "gift_active": [], "step_ready": {}, "open_early": {}, "early_patches": {},
		"postcards": [], "perks": {}, "sold_kinds": {}, "market": {},
	}

func new_game() -> void:
	var st: Dictionary = D["start"]
	S = state_defaults()
	S["version"] = SAVE_VERSION
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
	if test_seed >= 0: return      # test runs leave the device alone
	save_to(save_path())
	save_learning()

## Writes the farm to a file (the normal save, or a test fixture).
func save_to(path: String) -> void:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f:
		f.store_string(Saves.pack(S, SAVE_VERSION))

func load_game(path := "") -> bool:
	if path == "": path = save_path()
	if not FileAccess.file_exists(path): return false
	var d := Saves.unpack(FileAccess.get_file_as_string(path))
	if not d.has("unlocked"): return false
	d = Saves.upgrade(d, _save_upgrades(), SAVE_VERSION)
	Saves.fill(d, state_defaults())
	S = d
	S["step"] = int(S["step"])          # JSON brings whole numbers back as decimals
	S["last_season"] = int(S["last_season"])
	# saves from an older version: things everyone starts with (the muddy road …) are added
	for nid in D["start"].get("unlocked", []):
		if nodes.has(nid) and not satisfied(nid): S["unlocked"][nid] = true
	_dirty()
	_ensure_areas()
	return true

## The upgrade steps of the save, one per version: [0] turns a save without a version into version 1, and so on.
func _save_upgrades() -> Array:
	return [_save_v0_to_v1]

## Version 0 → 1 (12 Oct 2026): gift cards from before become postcards from "a friend" (the gift shop is gone); saves
## from before "active" gift cards: the first cards owned are the ones that work.
func _save_v0_to_v1(d: Dictionary) -> void:
	var gp := []
	for x in d.get("gift_pending", []):
		if typeof(x) == TYPE_ARRAY: gp.append({"from": tr("A friend"), "emoji": "💌", "text": tr("A little something for your farm!"), "offer": x, "step": int(d.get("step", 0))})
		elif typeof(x) == TYPE_DICTIONARY: gp.append(x)
	d["gift_pending"] = gp
	d["gift_shop"] = []
	if not d.has("gift_active"):
		var mx := int(meta.get("giftCards", {}).get("maxActive", 2))
		d["gift_active"] = (d.get("gift_owned", []) as Array).slice(0, mx)

func reset_game() -> void:
	if test_seed < 0 and FileAccess.file_exists(save_path()):
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

## Every effect that counts now, as one table (kits/core/modifiers.gd): what is built (not replaced by an upgrade,
## the helper attached to a station), polish with diminishing returns, the active gift cards.
func modifier_sources() -> Array:
	var src := []
	for id in S["unlocked"]:
		if not nodes.has(id) or superseded(id): continue
		var n = nodes[id]
		if n["type"] == "polish": continue
		if n.has("attach") and S["attach"].get(n["attach"], id) != id: continue
		if n.has("effects"): src.append([n["effects"], 1.0])
	for pid in S["polish"]:
		var p := float(S["polish"][pid])
		if p <= 0.0 or not nodes.has(pid): continue
		src.append([nodes[pid].get("effects", {}), 1.0 - pow(0.5, p)])
	for gid in S.get("gift_active", S["gift_owned"]):
		var gc := gift_card(gid)
		if not gc.is_empty(): src.append([gc.get("effects", {}), 1.0])
	return src

func caps() -> Dictionary:
	if _caps != null: return _caps
	_caps = Modifiers.fold(modifier_sources())
	return _caps

func m(k: String) -> float:
	return Modifiers.mult(caps(), k)

func g(k: String, d: float = 0.0) -> float:
	return Modifiers.value(caps(), k, d)

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
	var c := int(chapters_cfg.get("first", 1))
	for id in chapters_cfg.get("advanceWhenDone", []):
		if done(id): c += 1
	return mini(c, int(chapters_cfg.get("last", 5)))

# ------------------------------------------------------------------ seasons   (→ systems/seasons.gd)
func season_len() -> int:
	return sys_seasons.season_len()

func season_no() -> int:
	return sys_seasons.season_no()

func season() -> String:
	return sys_seasons.season()

func smod(k: String, d = 1.0):
	return sys_seasons.smod(k, d)

func season_emoji() -> String:
	return sys_seasons.season_emoji()

func questions_left_in_season() -> int:
	return sys_seasons.questions_left_in_season()

# ------------------------------------------------------------------ inventory (batches remember the season they arrived in)   (→ systems/items.gd)
func count(k: String) -> float:
	return sys_items.count(k)

func count_tag(t: String) -> float:
	return sys_items.count_tag(t)

func have(k: String) -> float:
	return sys_items.have(k)

func add_item(k: String, q: float, quiet := false) -> float:
	return sys_items.add_item(k, q, quiet)

func _gained(source: String, got: Dictionary) -> void:
	sys_items._gained(source, got)

func take(k: String, q: float) -> bool:
	return sys_items.take(k, q)

func tag_choices(t: String) -> Array:
	return sys_items.tag_choices(t)

func take_tag(t: String, q: float) -> bool:
	return sys_items.take_tag(t, q)

func sellable(k: String) -> bool:
	return sys_items.sellable(k)

func value_of(k: String) -> float:
	return sys_items.value_of(k)

func shelf_life(k: String) -> int:
	return sys_items.shelf_life(k)

func stale_soon(k: String) -> float:
	return sys_items.stale_soon(k)

# ------------------------------------------------------------------ energy & costs   (→ systems/progression.gd)
func buff_mult() -> float:
	return sys_progression.buff_mult()

func stars(station_root: String) -> int:
	return sys_progression.stars(station_root)

func ecost(cat: String, base: float, station_root := "") -> float:
	return sys_progression.ecost(cat, base, station_root)

func node_cat(id: String) -> String:
	return sys_progression.node_cat(id)

func plots() -> int:
	return sys_progression.plots()

func _open_early(id: String) -> void:
	sys_progression._open_early(id)

func _improve_early(id: String, done_steps: int, total: int) -> void:
	sys_progression._improve_early(id, done_steps, total)

func step_wait_left(id: String) -> int:
	return sys_progression.step_wait_left(id)

func steps_of(id: String) -> Array:
	return sys_progression.steps_of(id)

func step_index(id: String) -> int:
	return sys_progression.step_index(id)

func _raw_cost(id: String) -> Dictionary:
	return sys_progression._raw_cost(id)

# ------------------------------------------------------------------ dynamic difficulty (a first version; settings dynamicDifficulty)   (→ systems/pacing.gd, systems/progression.gd)
func flex_on() -> bool:
	return sys_pacing.flex_on()

func review_share() -> float:
	return sys_pacing.review_share()

func set_review_share(v: float) -> void:
	sys_pacing.set_review_share(v)

func toggle_flex() -> void:
	sys_pacing.toggle_flex()

func flex_cfg() -> Dictionary:
	return sys_pacing.flex_cfg()

func flex_worth(k: String) -> float:
	return sys_pacing.flex_worth(k)

func _tick_pace() -> void:
	sys_pacing._tick_pace()

func base_pace() -> float:
	return sys_pacing.base_pace()

func pace_ratio() -> float:
	return sys_pacing.pace_ratio()

func flex_factor(id: String) -> float:
	return sys_pacing.flex_factor(id)

func _flexed(id: String, c: Dictionary) -> Dictionary:
	return sys_pacing._flexed(id, c)

func flex_tip(id: String) -> String:
	return sys_pacing.flex_tip(id)

func node_cost(id: String) -> Dictionary:
	return sys_progression.node_cost(id)

func node_cost_base(id: String) -> Dictionary:
	return sys_progression.node_cost_base(id)

func missing_cost(c: Dictionary) -> Array:
	return sys_progression.missing_cost(c)

func pay(c: Dictionary) -> bool:
	return sys_progression.pay(c)

func cost_text(c: Dictionary) -> String:
	return sys_progression.cost_text(c)

# ------------------------------------------------------------------ requirements   (→ systems/progression.gd)
func cards_learned() -> int:
	return sys_progression.cards_learned()

func books_owned() -> int:
	return sys_progression.books_owned()

func missing_reqs(id: String) -> Array:
	return sys_progression.missing_reqs(id)

func is_open(id: String) -> bool:
	return sys_progression.is_open(id)

func is_auto(id: String) -> bool:
	return sys_progression.is_auto(id)

func _auto_unlocks() -> void:
	sys_progression._auto_unlocks()

func can_unlock(id: String) -> Dictionary:
	return sys_progression.can_unlock(id)

func patch_progress(id: String) -> int:
	return sys_progression.patch_progress(id)

func unlock(id: String) -> bool:
	return sys_progression.unlock(id)

func _finish_unlock(id: String, auto: bool) -> void:
	sys_progression._finish_unlock(id, auto)

func set_pet_name(pet_id: String, name: String) -> void:
	sys_progression.set_pet_name(pet_id, name)

func set_attach(station: String, helper_id: String) -> void:
	sys_progression.set_attach(station, helper_id)

# ------------------------------------------------------------------ fields, orchard, greenhouse   (→ systems/fields.gd)
func _blank_patch() -> Dictionary:
	return sys_fields._blank_patch()

func _ensure_areas() -> void:
	sys_fields._ensure_areas()

func area(a: String) -> Array:
	return sys_fields.area(a)

func patch_usable(a: String, i: int) -> bool:
	return sys_fields.patch_usable(a, i)

const CLEARING := [["clear_thistles", "weeds"], ["clear_weeds", "weeds"], ["clear_rocks", "rocks"], ["clear_stumps", "stumps"]]
const FIELD_WILD := ["", "scrub", "marsh"]     # fields 2 and 3 before they are opened

func patch_wild(f: int, i: int) -> Array:
	return sys_fields.patch_wild(f, i)

func field_names() -> Array:
	return sys_fields.field_names()

func crop_slot(cid: String) -> String:
	return sys_fields.crop_slot(cid)

func crops_for(a: String) -> Array:
	return sys_fields.crops_for(a)

func plants_per_patch(a: String) -> int:
	return sys_fields.plants_per_patch(a)

func free_density() -> float:
	return sys_fields.free_density()

func fert_points_have() -> float:
	return sys_fields.fert_points_have()

func _take_fert(points: float) -> void:
	sys_fields._take_fert(points)

func seed_have(cid: String) -> float:
	return sys_fields.seed_have(cid)

func field_water_mult() -> float:
	return sys_fields.field_water_mult()

func plant_plan(a: String, cid: String) -> Dictionary:
	return sys_fields.plant_plan(a, cid)

func plant(a: String, i: int, cid: String) -> bool:
	return sys_fields.plant(a, i, cid)

func grow_target(p: Dictionary) -> float:
	return sys_fields.grow_target(p)

func slow_factor(p: Dictionary) -> float:
	return sys_fields.slow_factor(p)

func grow_speed(a: String, p: Dictionary) -> float:
	return sys_fields.grow_speed(a, p)

func harvest(a: String, i: int) -> bool:
	return sys_fields.harvest(a, i)

func cut_tree(a: String, i: int) -> bool:
	return sys_fields.cut_tree(a, i)

func harvest_amounts(n: Dictionary, plants: int, quality: float, mult: float) -> Dictionary:
	return sys_fields.harvest_amounts(n, plants, quality, mult)

func weed(i: int) -> bool:
	return sys_fields.weed(i)

func weed_field(f: int) -> void:
	sys_fields.weed_field(f)

func pick_stones(i: int) -> bool:
	return sys_fields.pick_stones(i)

# ------------------------------------------------------------------ water: fetched from the pond with a bucket   (→ systems/resources.gd)
func fetch_amount() -> float:
	return sys_resources.fetch_amount()

func fetch_cost() -> float:
	return sys_resources.fetch_cost()

func fetch_water() -> bool:
	return sys_resources.fetch_water()

# ------------------------------------------------------------------ animals & muck   (→ systems/animals.gd)
func animal_key(aid: String) -> String:
	return sys_animals.animal_key(aid)

func animal_cap(aid: String) -> int:
	return sys_animals.animal_cap(aid)

func animal(aid: String) -> Dictionary:
	return sys_animals.animal(aid)

func animal_price(aid: String) -> Dictionary:
	return sys_animals.animal_price(aid)

func buy_animal(aid: String) -> bool:
	return sys_animals.buy_animal(aid)

func has_flowers() -> bool:
	return sys_animals.has_flowers()

func muck_factor(aid: String) -> float:
	return sys_animals.muck_factor(aid)

func feed_needs(aid: String) -> Dictionary:
	return sys_animals.feed_needs(aid)

func collect_animal(aid: String) -> bool:
	return sys_animals.collect_animal(aid)

func muck_out(aid: String) -> bool:
	return sys_animals.muck_out(aid)

# ------------------------------------------------------------------ stations, recipes & the woodpile   (→ systems/crafting.gd)
func chain_root(id: String) -> String:
	return sys_crafting.chain_root(id)

func chain_members(root: String) -> Array:
	return sys_crafting.chain_members(root)

func active_of(root: String) -> String:
	return sys_crafting.active_of(root)

func stations() -> Array:
	return sys_crafting.stations()

func station_slots(root: String) -> int:
	return sys_crafting.station_slots(root)

func station_recipes_for(root: String) -> Array:
	return sys_crafting.station_recipes_for(root)

func recipe_open(rid: String) -> bool:
	return sys_crafting.recipe_open(rid)

func recipe_cat(rid: String) -> String:
	return sys_crafting.recipe_cat(rid)

func recipe_batch(rid: String) -> int:
	return sys_crafting.recipe_batch(rid)

func recipe_cost(rid: String, n := -1) -> Dictionary:
	return sys_crafting.recipe_cost(rid, n)

func recipe_cost_base(rid: String) -> Dictionary:
	return sys_crafting.recipe_cost_base(rid)

func recipe_fuel(rid: String) -> float:
	return sys_crafting.recipe_fuel(rid)

func recipe_time(rid: String) -> float:
	return sys_crafting.recipe_time(rid)

func woodpile_cap() -> float:
	return sys_crafting.woodpile_cap()

func fuel_value(k: String) -> float:
	return sys_crafting.fuel_value(k)

func stack_wood(k: String, q: float) -> float:
	return sys_crafting.stack_wood(k, q)

func auto_stack(need: float) -> void:
	sys_crafting.auto_stack(need)

func fuel_in_store() -> float:
	return sys_crafting.fuel_in_store()

func stoke(need: float) -> float:
	return sys_crafting.stoke(need)

func start_recipe(rid: String) -> bool:
	return sys_crafting.start_recipe(rid)

func _recipe_out(rid: String, n := 1) -> void:
	sys_crafting._recipe_out(rid, n)

func output_now(root: String) -> bool:
	return sys_crafting.output_now(root)

func recipe_left(rid: String) -> float:
	return sys_crafting.recipe_left(rid)

func _tick_stations() -> void:
	sys_crafting._tick_stations()

# ------------------------------------------------------------------ polish (endless, diminishing returns)   (→ systems/progression.gd)
func polish_level(pid: String) -> float:
	return sys_progression.polish_level(pid)

func polish_open(pid: String) -> bool:
	return sys_progression.polish_open(pid)

func polish_cost(pid: String) -> Dictionary:
	return sys_progression.polish_cost(pid)

func polish_gain(pid: String, p: float) -> float:
	return sys_progression.polish_gain(pid, p)

func do_polish(pid: String) -> bool:
	return sys_progression.do_polish(pid)

func _wear(kind: String) -> void:
	sys_progression._wear(kind)

# ------------------------------------------------------------------ market, food   (→ systems/needs.gd, systems/trade.gd)
func market_sold() -> Dictionary:
	return sys_trade.market_sold()

func demand_factor(k: String, extra := 0.0) -> float:
	return sys_trade.demand_factor(k, extra)

func full_price(k: String) -> float:
	return sys_trade.full_price(k)

func sell_price(k: String) -> float:
	return sys_trade.sell_price(k)

func sell_total(k: String, n: int) -> float:
	return sys_trade.sell_total(k, n)

func sell(k: String, q: float) -> bool:
	return sys_trade.sell(k, q)

func _tick_market() -> void:
	sys_trade._tick_market()

func recipe_worth(rid: String) -> Vector2:
	return sys_trade.recipe_worth(rid)

func buy_seeds(cid: String, q: int) -> bool:
	return sys_trade.buy_seeds(cid, q)

func buy_item(merchant: String, k: String, q: int) -> bool:
	return sys_trade.buy_item(merchant, k, q)

func barter(merchant: String, k: String) -> bool:
	return sys_trade.barter(merchant, k)

func eat(k: String) -> bool:
	return sys_needs.eat(k)

# ------------------------------------------------------------------ knowledge cards & the library   (→ systems/knowledge.gd)
func card_status(cid: String) -> String:
	return sys_knowledge.card_status(cid)

func read_needed(cid: String) -> float:
	return sys_knowledge.read_needed(cid)

func start_reading(cid: String) -> bool:
	return sys_knowledge.start_reading(cid)

func _tick_reading() -> void:
	sys_knowledge._tick_reading()

func card_ancestors(cid: String) -> Array:
	return sys_knowledge.card_ancestors(cid)

func _shuffled_q(src: Dictionary, cid: String, qi: int, review: bool) -> Dictionary:
	return sys_knowledge._shuffled_q(src, cid, qi, review)

func card_quiz(cid: String) -> Array:
	return sys_knowledge.card_quiz(cid)

func _card_key(cid: String) -> int:
	return sys_knowledge._card_key(cid)

func record_card_answer(q: Dictionary, first_try: bool) -> void:
	sys_knowledge.record_card_answer(q, first_try)

func finish_card(cid: String, all_first_try: bool) -> void:
	sys_knowledge.finish_card(cid, all_first_try)

func due_cards() -> Array:
	return sys_knowledge.due_cards()

func next_time_question() -> Dictionary:
	return sys_knowledge.next_time_question()

func retry_after_next(q: Dictionary) -> void:
	sys_knowledge.retry_after_next(q)

func _retry_question(rq: Dictionary) -> Dictionary:
	return sys_knowledge._retry_question(rq)

func time_result(q: Dictionary, first_try: bool) -> void:
	sys_knowledge.time_result(q, first_try)

# ------------------------------------------------------------------ Rest (sleep, food, water)   (→ systems/needs.gd)
func math_record() -> Dictionary:
	return sys_needs.math_record()

func rest_question() -> Dictionary:
	return sys_needs.rest_question()

func rest_result(q: Dictionary, right: bool, fast: bool) -> Dictionary:
	return sys_needs.rest_result(q, right, fast)

func after_rest_answer(right: bool, fast: bool) -> void:
	sys_needs.after_rest_answer(right, fast)

func arith_info(level_id := "") -> Dictionary:
	return sys_needs.arith_info(level_id)

func rest_correct(fast := true) -> float:
	return sys_needs.rest_correct(fast)

# ------------------------------------------------------------------ luck   (→ systems/rewards.gd)
func luck() -> float:
	return sys_rewards.luck()

func add_luck(amount: float, questions: int) -> void:
	sys_rewards.add_luck(amount, questions)

func _event(id: String) -> Dictionary:
	return sys_rewards._event(id)

func roll(e: Dictionary) -> bool:
	return sys_rewards.roll(e)

func _weed_luck() -> void:
	sys_rewards._weed_luck()

# ------------------------------------------------------------------ one Time Quiz answer = one step of farm time   (→ systems/fields.gd, systems/items.gd, systems/needs.gd, systems/resources.gd, systems/rewards.gd, systems/seasons.gd)
func step_time() -> Dictionary:
	S["step"] = int(S["step"]) + 1
	var info: Dictionary = clock.step({"removed": 0, "arrived": 0.0, "rain": false, "season": false})
	_dirty()
	save_game()
	step_done.emit(info)
	changed.emit()
	return info

## What happens on one step of time, in this order (kits/core/clock.gd). Each part gets the step's report.
func _setup_clock() -> void:
	clock.add("pace", func(_r): _tick_pace())
	clock.add("season", _step_season)
	clock.add("rain", _step_rain)
	clock.add("water", _step_water)
	clock.add("producers", _step_producers)
	clock.add("crops", _step_crops)
	clock.add("weeds_stones", func(_r): _tick_weeds_stones())
	clock.add("pests", _step_pests)
	clock.add("stations", func(_r): _tick_stations())
	clock.add("reading", func(_r): _tick_reading())
	clock.add("home_fuel", func(_r): _tick_home_fuel())
	clock.add("market", func(_r): _tick_market())
	clock.add("wear", func(_r): _wear("question"))       # polish that wears with time
	clock.add("neighbour_gift", _step_neighbour_gift)
	clock.add("luck_boosts", _step_luck_boosts)
	clock.add("acorns", func(_r): _check_acorns())
	clock.add("auto_unlocks", func(_r): _auto_unlocks())
	clock.add("perks", func(_r): _check_perks())

func _step_season(info: Dictionary) -> void:
	sys_seasons._step_season(info)

func _step_rain(info: Dictionary) -> void:
	sys_seasons._step_rain(info)

func _step_water(_info: Dictionary) -> void:
	sys_resources._step_water(_info)

func _step_producers(_info: Dictionary) -> void:
	sys_items._step_producers(_info)

func _step_crops(_info: Dictionary) -> void:
	sys_fields._step_crops(_info)

func _step_pests(info: Dictionary) -> void:
	sys_fields._step_pests(info)

func _step_neighbour_gift(_info: Dictionary) -> void:
	sys_rewards._step_neighbour_gift(_info)

func _step_luck_boosts(_info: Dictionary) -> void:
	sys_rewards._step_luck_boosts(_info)

func weed_rate() -> float:
	return sys_fields.weed_rate()

func _tick_weeds_stones() -> void:
	sys_fields._tick_weeds_stones()

func plants_growing() -> float:
	return sys_fields.plants_growing()

func pest_block() -> float:
	return sys_fields.pest_block()

func pest_scare() -> float:
	return sys_fields.pest_scare()

func pest_arrivals() -> float:
	return sys_fields.pest_arrivals()

func _tick_pests() -> Dictionary:
	return sys_fields._tick_pests()

func pest_eat_share() -> float:
	return sys_fields.pest_eat_share()

func shown_plants(x: float) -> int:
	return sys_fields.shown_plants(x)

func _tick_home_fuel() -> void:
	sys_needs._tick_home_fuel()

func _season_change(sn: int) -> void:
	sys_seasons._season_change(sn)

# ------------------------------------------------------------------ gift cards (pick 1 of 3)   (→ systems/rewards.gd)
func gift_card(gid: String) -> Dictionary:
	return sys_rewards.gift_card(gid)

func friends() -> Array:
	return sys_rewards.friends()

func _news(kind: String, what := "") -> String:
	return sys_rewards._news(kind, what)

func _offer_gift(news := "") -> void:
	sys_rewards._offer_gift(news)

func postcard_pending() -> Dictionary:
	return sys_rewards.postcard_pending()

func pick_gift(gid: String) -> void:
	sys_rewards.pick_gift(gid)

func gift_max() -> int:
	return sys_rewards.gift_max()

func gift_is_active(gid: String) -> bool:
	return sys_rewards.gift_is_active(gid)

func _activate_new_gift(gid: String) -> void:
	sys_rewards._activate_new_gift(gid)

func toggle_gift(gid: String) -> bool:
	return sys_rewards.toggle_gift(gid)

# ------------------------------------------------------------------ little jobs   (→ systems/rewards.gd)
func _refill_jobs() -> void:
	sys_rewards._refill_jobs()

func _make_job() -> Dictionary:
	return sys_rewards._make_job()

func _job(type: String, item: String, q: float) -> void:
	sys_rewards._job(type, item, q)

# ------------------------------------------------------------------ golden acorns   (→ systems/rewards.gd)
func _check_acorns() -> void:
	sys_rewards._check_acorns()

## A condition from the data (kits/core/conditions.gd): "unlocked:id", "<counter>>=N", "a & b" …
func cond(w: String) -> bool:
	return conditions.check(w)

## What the conditions in this game's data can ask about.
##   kinds:    unlocked:<id> (also done:<id>), has:<item>:<n>, seen:<item>, season:<spring|summer|autumn|winter>
##   counters: sidequests, seasons, weeds, cards, harvests, rest_quick, medals (Rest sum medals won), arith_level,
##             sold_kinds, friends, chapter, step
func _setup_conditions() -> void:
	conditions.kind("unlocked", func(a): return done(a))
	conditions.kind("done", func(a): return done(a))
	conditions.kind("has", func(a):
		var p: PackedStringArray = a.split(":")
		return count(p[0]) >= (float(p[1]) if p.size() > 1 else 1.0))
	conditions.kind("seen", func(a): return S["seen"].has(a))
	conditions.kind("season", func(a): return season() == a)
	conditions.counter("sidequests", func(): return float(S["stats"].get("sidequests", 0)))
	conditions.counter("seasons", func(): return float(season_no()))
	conditions.counter("weeds", func(): return float(S["stats"].get("weeds", 0)))
	conditions.counter("cards", func(): return float(cards_learned()))
	conditions.counter("harvests", func(): return float(S["stats"].get("harvests", 0)))
	conditions.counter("rest_quick", func(): return float(S["stats"].get("rest_quick", 0)))
	conditions.counter("medals", func(): return float(math.medal_count(_learn())))
	conditions.counter("arith_level", func(): return float(math.medal_count(_learn(), "bronze") + 1))
	conditions.counter("sold_kinds", func(): return float(S.get("sold_kinds", {}).size()))
	conditions.counter("friends", func(): return float(friends().size()))
	conditions.counter("chapter", func(): return float(chapter()))
	conditions.counter("step", func(): return float(S["step"]))
	conditions.named("luck", func(): return false)     # the lucky acorn is found by a roll while weeding (_weed_luck)

# ------------------------------------------------------------------ perks: small extras for favours and achievements   (→ systems/rewards.gd)
func perk_def(id: String) -> Dictionary:
	return sys_rewards.perk_def(id)

func perks() -> Dictionary:
	return sys_rewards.perks()

func perk_owned(id: String) -> bool:
	return sys_rewards.perk_owned(id)

func perk_on(id: String) -> bool:
	return sys_rewards.perk_on(id)

func toggle_perk(id: String) -> void:
	sys_rewards.toggle_perk(id)

func give_perk(id: String) -> void:
	sys_rewards.give_perk(id)

func _check_perks() -> void:
	sys_rewards._check_perks()

func perk_event(kind: String, data := {}) -> void:
	sys_rewards.perk_event(kind, data)

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
	say(tr("⏩ Cheat: %d questions of time passed, energy and water full.") % n)
	save_game(); changed.emit()

func cheat_coins(q: float) -> void:
	S["coins"] += q
	say(tr("🪙 Cheat: +%d coins") % int(q))
	save_game(); changed.emit()
