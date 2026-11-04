extends Node
## The condition language as the game uses it (kits/core/conditions.gd and the words the systems register): every word answers on a
## new game and on each save fixture, has a note and a working example; the grammar on real words. Rules only, no screen.
## Run:  godot --headless --path . res://tests/conditions_test.tscn -- --seed=1
const WORDS := "res://data/farm/condition-words.json"
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	var C = G.conditions
	var voc: Dictionary = C.vocabulary()
	# the word list the data checker reads (tools/check_data.py): written with --write-words, and it must match the code
	var text := JSON.stringify({"note": "The condition words of the game (kits/core/conditions.gd), written by: godot --headless --path . res://tests/conditions_test.tscn -- --seed=1 --write-words. The data checker reads it. Do not edit by hand.", "words": voc}, "\t", true) + "\n"
	if "--write-words" in OS.get_cmdline_user_args():
		var fw := FileAccess.open(WORDS, FileAccess.WRITE)
		fw.store_string(text)
		fw.close()
		print("words written to ", WORDS)
	var on_disk = JSON.parse_string(FileAccess.get_file_as_string(WORDS)) if FileAccess.file_exists(WORDS) else null
	_check(typeof(on_disk) == TYPE_DICTIONARY and JSON.stringify(on_disk.get("words", {}), "", true) == JSON.stringify(voc, "", true), "the word list %s matches the code (refresh it with --write-words)" % WORDS)
	_check(voc.size() >= 35, "the game registers its words (%d)" % voc.size())
	for w in voc:
		var d: Dictionary = voc[w]
		_check(str(d["note"]).length() >= 10 and str(d["example"]) != "", "%s has a note and an example" % w)
		_check(C.valid(str(d["example"])), "%s: its example %s is a valid condition" % [w, d["example"]])
	_check(not voc.has("has") and voc.has("item") and voc["chapter"]["kind"] == "number", "one way to say each thing: item:, chapter as a number")
	# every word answers on a new game and on each fixture, as a number or a yes-or-no, without an error
	var farms := ["new"]
	var dir := DirAccess.open("res://tests/fixtures")
	for f in dir.get_files(): if f.ends_with(".json"): farms.append("res://tests/fixtures/" + f)
	for f in farms:
		if f == "new": G.reset_game()
		else: G.load_game(f)
		var bad := []
		for w in voc:
			var ex := str(voc[w]["example"])
			if voc[w]["kind"] == "number":
				var p := ex.split(">=")[0].split("<")[0]
				if is_nan(C.value(p)): bad.append(w)
			elif not C.valid(ex): bad.append(w)
		_check(bad.is_empty(), "%s: every word answers %s" % [f.get_file(), str(bad)])
	# the grammar on real words, on a new game
	G.reset_game()
	_check(C.holds("start") and C.holds("step<1") and not C.holds("step>=1") and C.holds("chapter>=1") and C.holds("chapter<2"), "a new game: start, step, chapter")
	_check(C.holds("not:done:barn") and not C.holds("not:start"), "not:")
	G.inventory.add_item("carrot", 3.0, true)
	_check(C.holds("item:carrot>=3") and not C.holds("item:carrot>=4") and C.holds("item:carrot<4") and C.value("item:carrot") == 3.0, "item: with at least and fewer than")
	_check(not C.holds("has:carrot:3") and not C.holds("chapter:1") and not C.holds("not:has:carrot:3"), "the old has: and chapter: forms are no longer words")
	_check(not C.holds("nonsense>=0") and not C.holds("not:nonsense"), "an unknown word is false, also behind not:")
	_check(not C.holds("not:done") and not C.holds("not:done:") and not C.holds("item<5") and not C.holds("not:start:x") and not C.holds("coins:x>=0") and not C.holds("not:rain:x"), "a missing or extra argument is false, also behind not:")
	_check(is_nan(C.value("item")) and is_nan(C.value("coins:x")), "value: a missing or extra argument gives no number")
	# the words for the story (C6): each follows the farm's state
	G.reset_game()
	G.S["pests"] = 0.0
	_check(C.holds("pests<1") and not C.holds("pests>=1"), "pests: none on a new farm")
	G.S["pests"] = 3.0
	_check(C.holds("pests>=3") and not C.holds("pests>=4"), "pests: three on the field")
	G.S["rain"] = false
	_check(not C.holds("rain") and C.holds("not:rain"), "rain: dry")
	G.S["rain"] = true
	_check(C.holds("rain") and not C.holds("not:rain"), "rain: it rained in this question")
	G.S["energy"] = 2.0
	_check(C.holds("energy<3") and not C.holds("energy>=3"), "energy: the farmer is tired")
	G.S["water"] = 12.0
	_check(C.holds("water>=12") and C.holds("water<13"), "water")
	var st0 := float(G.S["stats"].get("stones", 0))
	G.S["stats"]["stones"] = st0 + 10.0
	_check(C.holds("stones>=%d" % int(st0 + 10.0)) and not C.holds("stones>=%d" % int(st0 + 11.0)), "stones: picked so far")
	var opened := ""
	var waiting := ""
	for id in G.nodes:
		if opened == "" and G.progression.is_open(id): opened = id
		if waiting == "" and not G.done(id) and not G.progression.is_open(id): waiting = id
	_check(opened != "" and C.holds("open:" + opened) and C.holds("not:done:" + opened), "open: a goal that can be started now (%s)" % opened)
	_check(waiting != "" and not C.holds("open:" + waiting), "open: not a goal that still waits for what it needs (%s)" % waiting)
	_check(not C.holds("open:tent") and G.done("tent"), "open: not a goal that is done")
	_check(not C.holds("open:no_such_goal"), "open: false for a node that does not exist")
	# the pets' WHEN cards: one condition with {n}, valid for every number of the slider
	for k in G.pets.whens():
		var c: Dictionary = G.pets.whens()[k]
		var all_ok := str(c.get("when", "")).contains("{n}") and not c.has("op") and not c.has("stat") and not c.has("item")
		var n := float(c["min"])
		while n <= float(c["max"]) + 0.001:
			if not C.valid(G.pets.card_condition(c, n)) or not C.valid(G.pets.card_condition(c, n - 0.0001)): all_ok = false
			n += float(c.get("step", 1))
		_check(all_ok, "WHEN card %s: %s is a valid condition for every number of its slider" % [k, c.get("when", "")])
	G.reset_game()
	G.S["water"] = 7.99995
	_check(G.pets.holds({"card": "water", "n": 8}) == false and G.pets.holds({"card": "water", "n": 10}), "a hair under a whole number counts as that number (water 7.99995 is not below 8)")
	print("CONDITIONS %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
