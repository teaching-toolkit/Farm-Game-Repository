extends Node
## Save fixtures: every save in tests/fixtures/ must still load, play on for a few steps of time and save again
## unchanged. Also checks that a save in an older layout (keys added since) is completed when loaded.
## Run:  godot --headless --path . res://tests/fixtures_test.tscn -- --seed=1
## New fixtures come from the bot:  … res://tests/bot.tscn -- --seed=1 --chapter=4 --save-at=3:<abs path>/tests/fixtures/ch3-seed1.json
var G
var fails := 0
var checks := 0
const TMP := "user://fixture_roundtrip.json"

func _ready() -> void:
	G = get_node("/root/Game")
	# 1. a new game saves and loads unchanged
	G.reset_game()
	_roundtrip("new game")
	# 2. a save in an older layout: the keys added since are filled in
	var old: Dictionary = G.S.duplicate(true)
	var added := ["step_ready", "open_early", "early_patches", "perks", "sold_kinds", "market", "postcards", "gift_active"]
	for k in added: old.erase(k)
	old.erase("version")
	old["step"] = float(old["step"])
	old["gift_pending"] = [["gc_deep_pockets"]]       # a gift offer from before postcards
	_write(TMP, old)
	_check(G.load_game(TMP), "older layout loads")
	for k in added: _check(G.S.has(k), "older layout gets %s" % k)
	_check(typeof(G.S["step"]) == TYPE_INT, "older layout: step is a whole number")
	_check(int(G.S.get("version", 0)) == G.SAVE_VERSION, "older layout is upgraded to version %d" % G.SAVE_VERSION)
	_check(typeof(G.S["gift_pending"][0]) == TYPE_DICTIONARY and G.S["gift_pending"][0]["offer"] == ["gc_deep_pockets"], "an old gift offer becomes a postcard")
	G.save_to(TMP)
	_check(int(JSON.parse_string(FileAccess.get_file_as_string(TMP)).get("version", 0)) == G.SAVE_VERSION, "a save carries its version")
	var future: Dictionary = G.S.duplicate(true)
	future["version"] = G.SAVE_VERSION + 5
	_write(TMP, future)
	_check(G.load_game(TMP), "a save from a newer game still loads (with a warning)")
	# 3. every fixture loads, plays on and saves unchanged
	var dir := DirAccess.open("res://tests/fixtures")
	for f in dir.get_files():
		if not f.ends_with(".json"): continue
		var path := "res://tests/fixtures/" + f
		_check(G.load_game(path), f + " loads")
		var ch: int = G.chapter()
		var st: int = G.S["step"]
		_check(ch >= 1 and st > 0, "%s: chapter %d step %d" % [f, ch, st])
		_roundtrip(f)
		for i in range(10):
			for j in range(G.S["patches"].size()):
				if G.patch_usable("field", j) and G.S["patches"][j]["ready"]: G.harvest("field", j)
			G.step_time()
		_check(int(G.S["step"]) == st + 10, "%s plays on 10 steps (now %d)" % [f, G.S["step"]])
		_check(G.chapter() >= ch, "%s keeps its chapter" % f)
		_roundtrip(f + " after playing")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(TMP))
	print("FIXTURES %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _roundtrip(what: String) -> void:
	# compared as JSON read back (whole numbers come back as decimals from any JSON file; that is not a change)
	var before := _norm(G.S)
	G.save_to(TMP)
	_check(G.load_game(TMP), what + ": saved file loads")
	var after := _norm(G.S)
	if after != before:
		for k in G.S:
			if JSON.stringify(JSON.parse_string(JSON.stringify(G.S[k]))) != JSON.stringify(JSON.parse_string(JSON.stringify(JSON.parse_string(before)[k]))):
				print("   differs: ", k)
	_check(after == before, what + ": unchanged after save and load")

func _norm(d) -> String:
	return JSON.stringify(JSON.parse_string(JSON.stringify(d)), "", true)

func _write(path: String, d: Dictionary) -> void:
	var fw := FileAccess.open(path, FileAccess.WRITE)
	fw.store_string(JSON.stringify(d))
	fw.close()

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL: ", what)
