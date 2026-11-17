extends Node
## Saves: a new game has exactly the keys and values recorded in tests/golden/newgame.json (recorded before the save
## format got a version, 13 Oct 2026), saves from before the version number are upgraded, a save from a newer game is
## kept as it is, every upgrade step can run twice.
## Run:  godot --headless --path . res://tests/saves_test.tscn -- --seed=1        (add --record to record the new-game state anew)
const GOLDEN := "res://tests/golden/newgame.json"
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var now: Dictionary = JSON.parse_string(JSON.stringify(G.S))
	now.erase("version")
	if "--record" in OS.get_cmdline_user_args():
		var f := FileAccess.open(GOLDEN, FileAccess.WRITE)
		f.store_string(JSON.stringify(now, "\t", true) + "\n")
		f.close()
		print("SAVES recorded in ", GOLDEN)
		get_tree().quit()
		return
	var golden = JSON.parse_string(FileAccess.get_file_as_string(GOLDEN))
	_check(JSON.stringify(now, "", true) == JSON.stringify(golden, "", true), "a new game has the recorded keys and values")
	if JSON.stringify(now, "", true) != JSON.stringify(golden, "", true):
		for k in golden: if not now.has(k) or JSON.stringify(now[k], "", true) != JSON.stringify(golden[k], "", true): print("   differs at ", k)
		for k in now: if not golden.has(k): print("   new key ", k)
	_check(int(G.S["version"]) == G.SAVE_VERSION, "a new game has the current version (%d)" % G.SAVE_VERSION)
	# every system's defaults are in a new game, and no two systems own the same key
	var seen := {}
	for sys in [G, G.seasons, G.inventory, G.needs, G.progression, G.fields, G.animals, G.crafting, G.knowledge, G.timeq, G.rewards, G.trade, G.reveal, G.story, G.trip, G.gate]:
		for k in sys.save_defaults():
			_check(not seen.has(k), "save key %s has one owner" % k)
			seen[k] = true
	# the fixtures from before the version number are version 0 and get upgraded
	var dir := DirAccess.open("res://tests/fixtures")
	var n_fix := 0
	for f in dir.get_files():
		if not f.ends_with(".json"): continue
		var raw: Dictionary = G.Saves.read("res://tests/fixtures/" + f)
		var v0: bool = G.Saves.version_of(raw) == 0
		_check(G.load_game("res://tests/fixtures/" + f), f + " loads")
		_check(int(G.S["version"]) == G.SAVE_VERSION, "%s is version %d after loading (was %d)" % [f, G.SAVE_VERSION, G.Saves.version_of(raw)])
		_check(G.rewards.celebrations_waiting().is_empty(), "%s: an old save has no celebration waiting" % f)
		n_fix += 1
	_check(n_fix >= 2, "at least two fixtures (%d)" % n_fix)
	# an old save: gift offers as arrays, no gift_active, keys missing that systems have added since
	G.reset_game()
	var old: Dictionary = G.S.duplicate(true)
	old.erase("version"); old.erase("gift_active"); old.erase("market"); old.erase("recent_q"); old.erase("postcards")
	old["gift_pending"] = [["gc_strong_arms", "gc_handy", "gc_horseshoe"]]
	old["gift_owned"] = ["gc_strong_arms", "gc_handy", "gc_horseshoe"]
	old["gift_shop"] = ["gc_handy"]
	G.Saves.write("user://saves_test.json", old)
	_check(G.load_game("user://saves_test.json"), "an old save loads")
	_check(int(G.S["version"]) == G.SAVE_VERSION, "…and is stamped with the current version")
	_check(typeof(G.S["gift_pending"][0]) == TYPE_DICTIONARY and G.S["gift_pending"][0]["offer"].size() == 3, "…its gift offer became a postcard that keeps the three cards")
	_check(G.S["gift_shop"].is_empty(), "…the gift shop is gone")
	_check(G.S["gift_active"].size() == int(G.meta.get("giftCards", {}).get("maxActive", 2)), "…the first cards owned are the active ones (%d)" % G.S["gift_active"].size())
	_check(G.S.has("market") and G.S.has("recent_q") and G.S.has("postcards"), "…keys a system added since are filled in")
	# the upgrade step can run twice
	var before := JSON.stringify(G.S, "", true)
	G.upgrade_save_v0(G.S)
	_check(JSON.stringify(G.S, "", true) == before, "the version 0 step is harmless when run again")
	# version 1 -> 2: what is in the store and has a grade now says so (Proper); raw materials stay as they are
	var v1: Dictionary = G.S.duplicate(true)
	v1["version"] = 1
	v1["inv"] = {"bread": [[0, 2.0]], "stick": [[0, 3.0]], "carrot": [[1, 1.0, 2]]}
	G.Saves.write("user://saves_test.json", v1)
	_check(G.load_game("user://saves_test.json"), "a version 1 save loads")
	_check(G.S["inv"]["bread"][0].size() == 3 and int(G.S["inv"]["bread"][0][2]) == 1, "…a batch of bread is now Proper")
	_check(G.S["inv"]["stick"][0].size() == 2, "…a batch of sticks has no grade")
	_check(int(G.S["inv"]["carrot"][0][2]) == 2, "…a grade that was already there stays")
	var before2 := JSON.stringify(G.S["inv"], "", true)
	G.upgrade_save_v1(G.S)
	_check(JSON.stringify(G.S["inv"], "", true) == before2, "the version 1 step is harmless when run again")
	# version 4 -> 5: the Time Quiz's recent questions and retry were positions in the list of pack questions; now permanent ids
	var v4: Dictionary = G.S.duplicate(true)
	v4["version"] = 4
	v4["recent_q"] = [0.0, 2.0]
	v4["retry_q"] = {"review": false, "card": "", "qi": 1.0, "wait": 1.0}
	G.Saves.write("user://saves_test.json", v4)
	_check(G.load_game("user://saves_test.json"), "a version 4 save loads")
	var id0 := str(G.pack_questions[0]["id"]); var id1 := str(G.pack_questions[1]["id"]); var id2 := str(G.pack_questions[2]["id"])
	_check(G.S["recent_q"] == [id0, id2], "…its recent questions are ids now: %s" % str(G.S["recent_q"]))
	_check(G.S["retry_q"] == {"id": id1, "wait": 1}, "…its retry is an id now: %s" % str(G.S["retry_q"]))
	var b4 := JSON.stringify([G.S["recent_q"], G.S["retry_q"]])
	G.timeq.upgrade_save_v4(G.S)
	_check(JSON.stringify([G.S["recent_q"], G.S["retry_q"]]) == b4, "the version 4 step is harmless when run again")
	G.timeq.next()                     # the retry waits one question…
	_check(G.timeq.next().get("id", "") == id1, "…and the old save's retry comes back after the next question")
	var v4r: Dictionary = G.S.duplicate(true)
	v4r["version"] = 4
	var cid0: String = G.card_ids[0]
	v4r["retry_q"] = {"review": true, "card": cid0, "qi": 0.0, "wait": 0.0}
	G.Saves.write("user://saves_test.json", v4r)
	_check(G.load_game("user://saves_test.json") and G.S["retry_q"] == {"card": cid0, "qi": 0, "wait": 0}, "…a review retry keeps its card and question: %s" % str(G.S["retry_q"]))
	# nature/04: the stone of a version 5 save is a big rock (what was carried for building stays usable)
	var v5: Dictionary = G.S.duplicate(true)
	v5["version"] = 5
	v5["inv"] = {"stone": [[0, 12.0]], "boulder": [[0, 1.0]], "stick": [[0, 3.0]]}
	v5["bag"] = {"stone": 2.0}
	v5["seen"] = {"stone": true}
	G.Saves.write("user://saves_test.json", v5)
	_check(G.load_game("user://saves_test.json") and not G.S["inv"].has("stone") and G.inventory.count("boulder") == 13.0 and G.inventory.count("stick") == 3.0, "a version 5 save: its stones are big rocks now (13 of them, sticks stay)")
	_check(not G.S["bag"].has("stone") and float(G.S["bag"].get("boulder", 0.0)) == 2.0 and G.S["seen"].has("boulder"), "…also in the bag, and the big rock counts as seen")
	_check(G.inventory.weight_class("stone") == "light" and G.inventory.weight_class("boulder") == "heavy", "a small stone is light, a big rock heavy")
	# interruption-queue/05: a celebration still waiting when the game closes is a sparse key (not in a new game, so the new-game record
	# and old saves stay as they are): a save keeps it, a save without it has nothing waiting
	G.reset_game()
	_check(not G.S.has("celebrations_waiting") and G.rewards.celebrations_waiting().is_empty(), "a new game has no celebration waiting (the key is sparse)")
	var iq5: Dictionary = G.S.duplicate(true)
	iq5["celebrations_waiting"] = ["stone_axe", "perk:fireflies"]
	G.Saves.write("user://saves_test.json", iq5)
	_check(G.load_game("user://saves_test.json") and G.rewards.celebrations_waiting() == ["stone_axe", "perk:fireflies"], "a save with celebrations waiting keeps them")
	G.rewards.keep_celebrations(["barn"])
	_check(G.S["celebrations_waiting"] == ["barn"], "…the list is replaced as the queue changes")
	G.rewards.keep_celebrations([])
	_check(not G.S.has("celebrations_waiting"), "…and the key is gone when none waits")
	iq5.erase("celebrations_waiting")
	G.Saves.write("user://saves_test.json", iq5)
	_check(G.load_game("user://saves_test.json") and G.rewards.celebrations_waiting().is_empty() and not G.S.has("celebrations_waiting"), "a save without the key loads as nothing waiting (and no key is added)")
	# people/02: the farmer's look is a sparse key too (the "make your farmer" screen at the start): a new game and every old save have none and
	# draw the default look; a save keeps the look made; an old save that has moved on is never asked
	G.reset_game()
	_check(not G.S.has("look") and G.people.farmer_look().is_empty() and G.people.farmer_to_make(), "a new game has no look (the key is sparse) and the farmer is still to be made")
	var lk5: Dictionary = G.S.duplicate(true)
	lk5["look"] = {"skin": "#5e3b26", "hair": {"style": "bun", "color": "#2b1d14"}}
	G.Saves.write("user://saves_test.json", lk5)
	_check(G.load_game("user://saves_test.json") and G.people.farmer_look()["skin"] == "#5e3b26" and G.people.farmer_look()["hair"]["style"] == "bun" and not G.people.farmer_to_make(), "a save with a look keeps it and does not ask again")
	lk5.erase("look")
	lk5["step"] = 30
	G.Saves.write("user://saves_test.json", lk5)
	_check(G.load_game("user://saves_test.json") and not G.S.has("look") and G.people.farmer_look().is_empty() and not G.people.farmer_to_make(), "an old save with no look keeps the default look (no key is added) and is not asked")
	G.reset_game()
	G.people.set_farmer_look({"skin": "#f6d7bd"})
	_check(G.S["look"] == {"skin": "#f6d7bd"} and not G.people.farmer_to_make(), "making the farmer writes the look to the save")
	# a save from a newer game is kept as it is
	var future: Dictionary = G.S.duplicate(true)
	future["version"] = G.SAVE_VERSION + 5
	future["from_the_future"] = {"x": 1}
	G.Saves.write("user://saves_test.json", future)
	_check(G.load_game("user://saves_test.json"), "a save from a newer game loads")
	_check(int(G.S["version"]) == G.SAVE_VERSION + 5 and G.S.has("from_the_future"), "…and keeps its version and what it holds")
	# the runner itself
	var st := {"version": 1}
	var ran: Array = G.Saves.upgrade(st, [{"to": 3, "name": "c", "fn": func(x): x["c"] = true}, {"to": 2, "name": "b", "fn": func(x): x["b"] = true}, {"to": 1, "name": "a", "fn": func(x): x["a"] = true}], 3)
	_check(ran == ["b", "c"] and not st.has("a") and st["version"] == 3, "the runner skips steps the save already had and runs the rest in order: %s" % str(ran))
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://saves_test.json"))
	print("SAVES %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
