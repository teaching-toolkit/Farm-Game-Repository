extends Node
class_name FarmGame
## Hazelwood Harvest (the farm quiz game) — the rules engine's front door (autoload "Game").
## It holds the farm's state (S) and data (D, items, nodes, recipes, meta, settings), starts, loads and saves the farm, folds the
## effects of everything done into one table (caps, g, m), and runs one step of time (one right Time Quiz answer, via the clock).
## The rules themselves live in the systems under game/farm/systems/ and are reached as G.<system>.<function>:
## seasons, inventory, needs (energy, Rest), pace (dynamic difficulty), progression (costs, requirements, unlocking), fields,
## animals, crafting (stations, recipes, polish), trade, knowledge (cards, Time Quiz) and rewards (luck, gifts, jobs, acorns, perks).
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
signal paid(coins: float)     # coins fly from the purse to the trader (M3)
signal sold(item: String, n: float, coins: float)   # coins fly to the purse (perk), a jingle
signal celebrate(id: String)     # a new building, tool or helper: the big pop-up with confetti
signal revealed(id: String)      # a part of the interface comes into view for the first time (G.reveal)
signal rank_up(family: String, rank: int)   # a skill reaches a new rank (G.skills)

const SEASON_WORDS := ["spring", "summer", "autumn", "winter"]   # i18n (shown with tr(): "It's spring!")
const SAVE_PATH := "user://farm_save.json"          # the farm from before players had names
const PLAYERS_DIR := "user://players"               # players/<name>/farm_save.json and learning.json
const LAST_PLAYER := "user://last_player.txt"
const DATA_DIR := "res://data/farm"       # items, recipes, chapters, start; nodes/ and rules/ are folders of themed files (kits/core/data.gd)
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
var animal_ids: Array = []          # the animals (nodes of type "animal"), in the data's order
var pet_ids: Array = []             # the pets in the order they come home: one at the end of each chapter (chapters[].pet)
const Modifiers = preload("res://kits/core/modifiers.gd")
const Conditions = preload("res://kits/core/conditions.gd")
const Saves = preload("res://kits/core/saves.gd")
const Data = preload("res://kits/core/data.gd")
var prefs = preload("res://kits/core/prefs.gd").new()   # this device's small choices (cheat buttons, read aloud): user://device.json
var rng = preload("res://kits/core/rng.gd").new()    # the one random source of the rules (seedable)
var clock = preload("res://kits/core/clock.gd").new()  # one step of time: the systems that run in it, in order

const Learner = preload("res://kits/learn/learner.gd")
var math = preload("res://kits/learn/math_engine.gd").new()   # Rest sums: curriculum, spaced repetition, medals (learnkit)
var quiz = preload("res://kits/learn/quiz_engine.gd").new()   # Time Quiz questions: spaced repetition (learnkit)
var learner = Learner.new()                                 # the player's learning record (a JSON file anyone can open)

var S: Dictionary = {}
var player := ""                 # who is playing: their own farm and their own learning record
var L: Dictionary = {}           # the learning record (Rest sums, Time Quiz questions): kept when a new game starts
var _caps = null
var overflow := {}       # what did not fit into the store since the last gained signal
var produced := 0.0      # worth of what came in since the last Time Quiz question (for the pace, dynamic difficulty)
var buying := false      # bought things are not "produced"
## --seed=N (tests, bot, screenshots): the same seed gives the same game. All random numbers come from rng,
## the clock moves with the steps instead of the wall clock, and nothing is read from or written to the device
## (no players, no save, a fresh learning record). Save files can still be written on purpose with save_to().
var test_seed := -1
## The version of the save layout (kits/core/saves.gd). A save without a "version" is version 0. Every change to the layout of a save
## adds an upgrade step in save_steps() and raises this number; tests/fixtures/ keeps old saves that must still load.
const SAVE_VERSION := 4
const TEST_CLOCK_START := 1800000000.0   # a fixed moment in 2027; one step of time counts as 10 minutes

## The systems: each owns one part of the rules and works on the farm's state G.S (see game/farm/systems/).
var seasons: FarmSeasons
var inventory: FarmInventory
var needs: FarmNeeds
var pace: FarmPace
var progression: FarmProgression
var fields: FarmFields
var animals: FarmAnimals
var crafting: FarmCrafting
var trade: FarmTrade
var knowledge: FarmKnowledge
var rewards: FarmRewards
var reveal: FarmReveal
var quality: FarmQuality
var skills: FarmSkills
var story: FarmStory
var trip: FarmTrip
var gate: FarmGate
var lord: FarmLord
var trust: FarmTrust

func _init() -> void:
	seasons = FarmSeasons.new(self)
	inventory = FarmInventory.new(self)
	needs = FarmNeeds.new(self)
	pace = FarmPace.new(self)
	progression = FarmProgression.new(self)
	fields = FarmFields.new(self)
	animals = FarmAnimals.new(self)
	crafting = FarmCrafting.new(self)
	trade = FarmTrade.new(self)
	knowledge = FarmKnowledge.new(self)
	rewards = FarmRewards.new(self)
	reveal = FarmReveal.new(self)
	quality = FarmQuality.new(self)
	skills = FarmSkills.new(self)
	story = FarmStory.new(self)
	trip = FarmTrip.new(self)
	gate = FarmGate.new(self)
	lord = FarmLord.new(self)
	trust = FarmTrust.new(self)

# ------------------------------------------------------------------ start, seed and clock

func _test_args() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--seed="): test_seed = int(a.substr(7))

## The time now in seconds (the wall clock, or the test clock with --seed).
func now() -> float:
	if test_seed >= 0: return TEST_CLOCK_START + float(S.get("step", 0)) * 600.0
	return Time.get_unix_time_from_system()

## Shuffles an array with the game's own random numbers (so a seed gives the same order).
func shuffle(a: Array) -> void:
	rng.shuffle(a)

func _ready() -> void:
	setup_clock()
	_test_args()
	prefs.open("" if test_seed >= 0 else "user://device.json")
	if test_seed >= 0:
		rng.seed = test_seed
		seed(test_seed)
		math.now_func = now
	else:
		rng.randomize()
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

func save_learning() -> void:
	if player == "" or test_seed >= 0: return
	learner.data = L
	learner.save()

func learn_record() -> Dictionary:
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

func load_data() -> void:
	D = {"meta": Data.read_dir(DATA_DIR + "/rules"), "chapters": Data.read(DATA_DIR + "/chapters.json"), "start": Data.read(DATA_DIR + "/start.json"),
		"items": Data.read(DATA_DIR + "/items.json"), "nodes": Data.read_dir(DATA_DIR + "/nodes"), "recipes": Data.read(DATA_DIR + "/recipes.json"),
		"story": Data.read_dir(DATA_DIR + "/story")}
	items = D["items"]; nodes = D["nodes"]; recipes = D["recipes"]; meta = D["meta"]
	tags.clear(); replaced_by.clear(); station_recipes.clear(); polish_ids.clear(); card_ids.clear(); animal_ids.clear(); pet_ids.clear()
	for iid in items:
		for t in items[iid].get("tags", []):
			if not tags.has(t): tags[t] = []
			tags[t].append(iid)
	for nid in nodes:
		var n = nodes[nid]
		if n.has("replaces"): replaced_by[n["replaces"]] = nid
		if n["type"] == "polish": polish_ids.append(nid)
		if n["type"] == "knowledge": card_ids.append(nid)
		if n["type"] == "animal": animal_ids.append(nid)
	for c in D["chapters"]:
		if nodes.has(str(c.get("pet", ""))): pet_ids.append(str(c["pet"]))
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

## Do the testing buttons show on the farm? (data/settings.json "showCheatButton" is the starting value; ⚙️ Settings → grown-up part changes it.)
func cheats_visible() -> bool:
	return bool(prefs.get_value("cheatButtons", settings.get("showCheatButton", true)))

## How questions and card pages are read aloud: "off" (no 🔊 buttons), "button" (a 🔊 button to press), "auto" (read as they open; 🔊 repeats).
func read_aloud_mode() -> String:
	return str(prefs.get_value("readAloud", "button"))

## The keys of the save that the Game itself owns (the systems own the rest, see their save_defaults()).
func save_defaults() -> Dictionary:
	var st: Dictionary = D["start"]
	return {"step": 0, "coins": float(st.get("coins", 0)), "water": float(st.get("water", 10)), "energy": float(st.get("energy", 10)),
		"goals": 0, "stats": {"weeds": 0.0, "stones": 0.0, "sidequests": 0, "harvests": 0, "rest": 0}, "log": []}

## Everything a save holds in a new game: the Game's keys and every system's.
func all_save_defaults() -> Dictionary:
	var d := save_defaults()
	for sys in [seasons, inventory, needs, progression, fields, animals, crafting, knowledge, rewards, trade, reveal, skills, story, trip, gate, lord]:
		d.merge(sys.save_defaults())
	return d

func new_game() -> void:
	var st: Dictionary = D["start"]
	S = all_save_defaults()
	S["version"] = SAVE_VERSION
	for nid in st.get("unlocked", []): S["unlocked"][nid] = true
	for k in st.get("inventory", {}): inventory.add_item(k, float(st["inventory"][k]), true)
	for k in st.get("seeds", {}): S["seeds"][k] = float(st["seeds"][k])
	invalidate_caps()
	progression.auto_unlocks()
	fields.ensure_areas()
	# the patches that are already cleared at the start still have a few weeds and a stone on them
	for i in range(mini(progression.plots(), S["patches"].size())):
		S["patches"][i]["weeds"] = float(st.get("patchWeeds", 0)) + float(i % 2)
		S["patches"][i]["stones"] = float(st.get("patchStones", 0))
	rewards.refill_jobs()
	reveal.settle()
	skills.settle()
	save_game()

## How often the farm was saved (or would be: test runs count too). Every player action ends with a save, so saves minus steps of time is
## the number of actions (taps) a player made: the bot reports it for the pacing numbers.
var saves_requested := 0

func save_game() -> void:
	saves_requested += 1
	if test_seed >= 0: return      # test runs leave the device alone
	save_to(save_path())
	save_learning()

## Writes the farm to a file (the normal save, or a test fixture).
func save_to(path: String) -> void:
	Saves.write(path, S)

## The upgrade steps from older save layouts, in order (kits/core/saves.gd). A step takes the save from the version before its "to".
func save_steps() -> Array:
	return [{"to": 1, "name": "saves from before the version number: gift offers become postcards, the gift shop is gone, the first cards owned are the active ones", "fn": upgrade_save_v0},
		{"to": 2, "name": "quality: every batch of a thing that has a grade now says which (what was in the store is Proper)", "fn": upgrade_save_v1},
		{"to": 3, "name": "skills: the uses counted per station become batches per skill family", "fn": upgrade_save_v2},
		{"to": 4, "name": "money: coins are counted in bronze (one old coin = 15 bronze)", "fn": upgrade_save_v3}]

func upgrade_save_v3(save: Dictionary) -> void:
	save["coins"] = float(save.get("coins", 0.0)) * float(meta.get("currency", {}).get("factor", 15))

func upgrade_save_v2(save: Dictionary) -> void:
	var sk: Dictionary = save.get("skills", {})
	for root in save.get("practice", {}):
		var f := skills.family_of_station(str(root))
		if f != "": sk[f] = int(sk.get(f, 0)) + int(save["practice"][root])
	save["skills"] = sk
	save.erase("practice")

func upgrade_save_v1(save: Dictionary) -> void:
	var inv: Dictionary = save.get("inv", {})
	for k in inv:
		if not items.has(k) or not quality.graded(k): continue
		for b in inv[k]:
			if b.size() == 2: b.append(quality.default_grade())

func upgrade_save_v0(save: Dictionary) -> void:
	# gift cards from before: offers waiting become postcards from "a friend"; the gift shop is gone
	var gp := []
	for x in save.get("gift_pending", []):
		if typeof(x) == TYPE_ARRAY: gp.append({"from": tr("A friend"), "emoji": "💌", "text": tr("A little something for your farm!"), "offer": x, "step": int(save.get("step", 0))})
		elif typeof(x) == TYPE_DICTIONARY: gp.append(x)
	save["gift_pending"] = gp
	save["gift_shop"] = []
	if not save.has("gift_active"):   # saves from before: the first cards owned are the ones that work
		var mx := int(meta.get("giftCards", {}).get("maxActive", 2))
		save["gift_active"] = (save.get("gift_owned", []) as Array).slice(0, mx)

func load_game(path := "") -> bool:
	if path == "": path = save_path()
	var d := Saves.read(path)
	if not d.has("unlocked"): return false
	S = d
	S["step"] = int(S.get("step", 0))        # (JSON gives whole numbers back as floats)
	Saves.upgrade(S, save_steps(), SAVE_VERSION)
	Saves.fill(S, all_save_defaults())       # keys that a newer game added
	S["last_season"] = int(S["last_season"])
	# things everyone starts with (the muddy road …) that the data has gained since: added to every farm
	for nid in D["start"].get("unlocked", []):
		if nodes.has(nid) and not satisfied(nid): S["unlocked"][nid] = true
	invalidate_caps()
	fields.ensure_areas()
	reveal.settle()          # what a loaded farm already has counts as shown: no "New: …" for it
	skills.settle()          # …and the ranks it already has are not announced again
	return true

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

## An amount of money (in bronze) as text: "35 🟤" under a gold, from a gold up "2 🟡 35 🟤" ("2 🟡" when nothing is left over).
## With both = true always gold and bronze ("0 🟡 35 🟤": the purse once the child has had a gold). Whole bronze, rounded down; money_up rounds up (costs).
func money(bronze: float, both := false) -> String:
	var cur: Dictionary = meta.get("currency", {})
	var sy: Dictionary = cur.get("symbols", {"bronze": "🟤", "gold": "🟡"})
	var per := int(cur.get("bronzePerGold", 100))
	var t := int(floor(bronze + 0.0001))
	if t < int(cur.get("goldFrom", 100)) and not both: return "%d %s" % [t, sy["bronze"]]
	var g := t / per
	var r := t % per
	if r == 0 and not both: return "%d %s" % [g, sy["gold"]]
	return "%d %s %d %s" % [g, sy["gold"], r, sy["bronze"]]

func money_up(bronze: float) -> String:
	return money(ceil(bronze - 0.0001))

## What the purse in the top bar says: bronze only until the child has had a gold, then both.
func purse_text() -> String:
	if float(S["coins"]) >= float(meta.get("currency", {}).get("goldFrom", 100)): S["stats"]["gold_seen"] = true
	return money(float(S["coins"]), bool(S["stats"].get("gold_seen", false)))

func iname(k: String) -> String:
	if k.begins_with("tag:"): return "any " + k.substr(4).replace("-", " ")
	return items[k]["name"] if items.has(k) else (nodes[k]["name"] if nodes.has(k) else k)

func iemoji(k: String) -> String:
	if k.begins_with("tag:"):
		var opts: Array = inventory.tag_choices(k.substr(4))
		for o in opts:
			if inventory.count(o) >= 1.0: return items[o].get("emoji", "✳️")
		return items[opts[0]].get("emoji", "✳️") if opts.size() > 0 else "✳️"
	if k == "coins": return "🪙"
	if k == "lord": return "🏮"
	if k == "energy": return "⚡"
	if k == "water": return "💧"
	if k == "read": return "📖"
	return items[k].get("emoji", "•") if items.has(k) else (nodes[k].get("emoji", "•") if nodes.has(k) else "•")

func down(x: float) -> int:
	return int(floorf(x + 0.000001))

func up(x: float) -> int:
	return int(ceilf(x - 0.000001))

# ------------------------------------------------------------------ effects

func invalidate_caps() -> void:
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

## Everything that changes the farm's numbers, folded into one table (kits/core/modifiers.gd): every node done (except what a
## helper replaced or what is not attached), polish at a diminishing weight, and the gift cards in use. Kept until something changes (invalidate_caps).
func caps() -> Dictionary:
	if _caps != null: return _caps
	var t: Dictionary = Modifiers.empty()
	for id in S["unlocked"]:
		if not nodes.has(id) or superseded(id): continue
		var n = nodes[id]
		if n["type"] == "polish": continue
		if n.has("attach") and S["attach"].get(n["attach"], id) != id: continue
		if n.has("effects"): Modifiers.apply(t, n["effects"])
	for pid in S["polish"]:
		var p := float(S["polish"][pid])
		if p <= 0.0 or not nodes.has(pid): continue
		Modifiers.apply(t, nodes[pid].get("effects", {}), 1.0 - pow(0.5, p))
	for gid in S.get("gift_active", S["gift_owned"]):
		var gc := rewards.gift_card(gid)
		if not gc.is_empty(): Modifiers.apply(t, gc.get("effects", {}))
	_caps = t
	return _caps

func m(k: String) -> float:
	return Modifiers.mult(caps(), k)

func g(k: String, d: float = 0.0) -> float:
	return Modifiers.value(caps(), k, d)

## The chapter the farm is in: each chapter ends when its pet comes home (chapters[].pet in the data); the last chapter's pet ends the game.
func chapter() -> int:
	var chapters: Array = D["chapters"]
	var c := 1
	for i in range(chapters.size() - 1):
		if done(str(chapters[i].get("pet", ""))): c += 1
	return mini(c, chapters.size())

# ------------------------------------------------------------------ one Time Quiz answer = one step of farm time

## One step of time (one right Time Quiz answer). The step counter moves, then the systems run in the order registered in
## setup_clock() (kits/core/clock.gd), each adding to the report `info`; then the farm is saved and the interface told.
func step_time() -> Dictionary:
	S["step"] = int(S["step"]) + 1
	var info := {"removed": 0, "arrived": 0.0, "rain": false, "season": false}
	clock.run(info)
	invalidate_caps()
	save_game()
	step_done.emit(info)
	changed.emit()
	return info

## The systems of one step of time and their ORDER (it is part of the rules: rain before crops, crops before pests …).
## A new system registers here, after the one it must follow.
func setup_clock() -> void:
	clock.register("pace", pace.tick_pace)
	clock.register("season", seasons.step_season)
	clock.register("rain", seasons.step_rain)
	clock.register("producers", inventory.step_producers)
	clock.register("crops", fields.step_crops)
	clock.register("weeds", fields.tick_weeds_stones)
	clock.register("pests", fields.step_pests)
	clock.register("stations", crafting.tick_stations)
	clock.register("reading", knowledge.tick_reading)
	clock.register("home_fuel", crafting.tick_home_fuel)
	clock.register("market", trade.tick_market)
	clock.register("gate", gate.step)
	clock.register("wear", func(_i): crafting.wear_polish("question"))     # polish that wears with time
	clock.register("neighbour_gift", rewards.step_neighbour_gift)
	clock.register("luck", rewards.expire_luck_boosts)
	clock.register("acorns", rewards.check_acorns)
	clock.register("unlocks", progression.auto_unlocks)
	clock.register("perks", rewards.check_perks)
	clock.register("skills", skills.step)
	clock.register("reveal", reveal.step)

# ------------------------------------------------------------------ conditions ("when" in the data)

## A condition from the data (kits/core/conditions.gd): "unlocked:id" or "<counter>>=N". This game's counters are below.
func cond(w: String) -> bool:
	return Conditions.check(w, self)

## The value of a named counter for conditions: sidequests, seasons, weeds, cards, harvests, rest_quick, medals (Rest sum medals
## won), arith_level, sold_kinds, friends. NAN for a name that is not one (the condition is then false).
func counter(name: String) -> float:
	var st: Dictionary = S["stats"]
	match name:
		"sidequests": return float(st.get("sidequests", 0))
		"seasons": return float(seasons.season_no())
		"weeds": return float(st.get("weeds", 0))
		"cards": return float(progression.cards_learned())
		"harvests": return float(st.get("harvests", 0))
		"rest_quick": return float(st.get("rest_quick", 0))
		"medals": return float(math.medal_count(learn_record()))
		"arith_level": return float(math.medal_count(learn_record(), "bronze") + 1)
		"sold_kinds": return float(S.get("sold_kinds", {}).size())
		"friends": return float(rewards.friends().size())
		"coins": return float(S["coins"])
		"album": return float(S["album"].size())
		"chapter": return float(chapter())
		"step": return float(S["step"])
		"items_seen": return float(S["seen"].size())
		"story_seen": return float(S["story_seen"].size())
		"goals": return float(S["goals"])
		"trips": return float(S["trips"])
		"packed": return float(trip.contents().size())
		"skill_ranks": return float(skills.total_ranks())
		"lord_owed": return lord.owed()
		"lord_paid": return float(S["lord"]["paid"])
		"lord_shares": return float(S["lord"]["shares"])
	return NAN

## Has this part of the interface, or this story piece, been shown (condition term `seen:<id>`)?
func seen(id: String) -> bool:
	return S["revealed"].has(id) or S["story_seen"].has(id)

## The game's own condition terms (kits/core/conditions.gd): the start of a new game, what is in the store, the season, the chapter, what was tapped,
## a card page that was read, a chance.
func term(name: String, arg: String) -> bool:
	match name:
		"start": return int(S["step"]) == 0
		"has":
			var p := arg.split(":")
			return p.size() == 2 and inventory.count(p[0]) >= float(p[1])
		"season": return seasons.season() == arg
		"chapter": return chapter() == int(arg)
		"tap": return S["story_taps"].has(arg)
		"page": return knowledge.page_seen(arg)
		"after":                                                  # after:<piece>:<n> — n Time Quiz questions have passed since the piece was seen
			var q := arg.split(":")
			return q.size() == 2 and S["story_seen"].has(q[0]) and S["step"] - int(S["story_seen"][q[0]]) >= int(q[1])
		"chance": return float(hash("%d/%s" % [int(S["step"]), arg]) % 1000) / 1000.0 < float(arg)   # the same answer all through one question: asking does not use up luck
	return false

## All of a list of conditions ("when" in the data).
func cond_all(list: Array) -> bool:
	return Conditions.check_all(list, self)

# ------------------------------------------------------------------ cheat (for testing)

func something_pending() -> bool:
	for a in ["field", "orchard", "gh"]:
		for p in fields.area(a):
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
	S["energy"] = needs.energy_max()
	S["water"] = needs.water_cap()
	say(tr("⏩ Cheat: %d questions of time passed, energy and water full.") % n)
	save_game(); changed.emit()

func cheat_coins(q: float) -> void:
	S["coins"] += q
	say(tr("🪙 Cheat: +%s") % money(q))
	save_game(); changed.emit()
