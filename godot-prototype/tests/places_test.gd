extends Node
## The farm's places and pets: the place tables (data/farm/places.json, read by game/farm/spots.gd), which place every
## data node belongs to, and the chapter and luck rules (each chapter ends with its pet, chapters[].pet in the data)
## must give exactly what tests/golden/places.json recorded on 13 Oct 2026, before they moved out of the code (slice R2).
## Run:  godot --headless --path . res://tests/places_test.tscn -- --seed=1
## After a change to places, pets or chapters ON PURPOSE (a new place, the badger):  … -- --seed=1 --record
const Spots = preload("res://game/farm/spots.gd")
const GOLDEN := "res://tests/golden/places.json"
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	var now := _snapshot()
	if "--record" in OS.get_cmdline_user_args():
		var f := FileAccess.open(GOLDEN, FileAccess.WRITE)
		f.store_string(JSON.stringify(now, "\t", false) + "\n")
		f.close()
		print("PLACES recorded in ", GOLDEN)
		get_tree().quit()
		return
	var golden = JSON.parse_string(FileAccess.get_file_as_string(GOLDEN))
	_check(typeof(golden) == TYPE_DICTIONARY, "golden file readable")
	if typeof(golden) == TYPE_DICTIONARY:
		for key in golden: _same(key, now.get(key), golden[key])
		for key in now: _check(golden.has(key), "%s is recorded" % key)
	# every place a node can land on has a name and an emoji
	for id in G.nodes:
		var sid := Spots.spot_of(G, id)
		_check(Spots.name_of(sid) != sid.capitalize() or Spots._data()["spots"].has(sid), "%s: place %s has a name" % [id, sid])
	# the market place is the sign to the village (placeArt): its own picture is village_sign.png; other places use their own name
	_check(Spots.place_art("market") == "village_sign", "the market place uses the village sign (%s)" % Spots.place_art("market"))
	_check(Spots.place_art("forest") == "forest", "a place without placeArt uses its own name")
	_check(ResourceLoader.exists("res://assets/map/%s.png" % Spots.place_art("market")), "the market place's picture exists")
	# the pets: one per chapter, in order
	_check(G.pet_ids.size() == G.D["chapters"].size(), "one pet per chapter (%d pets)" % G.pet_ids.size())
	_check(G.animal_ids.size() == 4, "four animals (%d)" % G.animal_ids.size())
	_working_places()
	_trodden_paths()
	print("PLACES %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _snapshot() -> Dictionary:
	var d: Dictionary = Spots._data()
	var out := {}
	var spots := {}
	for sid in d["spots"]: spots[sid] = [Spots.name_of(sid), Spots.emoji_of(sid)]
	out["spots"] = spots
	out["interiors"] = Spots.interiors()
	var corner := {}
	for sid in d["cornerArt"]: corner[sid] = Spots.corner_art(sid)
	out["hotspot_art"] = corner
	var chains := {}
	for sid in d["artChains"]: chains[sid] = Spots.art_chain(sid)
	out["art_chains"] = chains
	out["always_open"] = d["alwaysOpen"].filter(func(sid): return Spots.is_always_open(sid))
	var ruins := {}
	for sid in d["ruins"]: ruins[sid] = Spots.ruin_material(sid)
	out["ruins"] = ruins
	out["bench"] = Spots.bench()
	var pens := {}
	for sid in d["pens"]: pens[sid] = Spots.pen(sid)
	out["pens"] = pens
	var of := {}
	for id in G.nodes: of[id] = Spots.spot_of(G, id)
	out["spot_of"] = of
	var at := {}
	for s in Spots._by_spot: at[s] = Spots.nodes_at(G, s)
	out["nodes_at"] = at
	# the chapter and the luck for every set of the five pets that could be home
	var ch := {}
	var lk := {}
	for mask in range(1 << G.pet_ids.size()):
		G.reset_game()
		var key := ""
		for i in range(G.pet_ids.size()):
			if mask & (1 << i):
				G.S["unlocked"][G.pet_ids[i]] = true; key += "1"
			else: key += "0"
		G.invalidate_caps()
		ch[key] = G.chapter()
		lk[key] = snappedf(G.rewards.luck(), 0.000001)
	out["chapter_by_pets"] = ch
	out["luck_by_pets"] = lk
	return out

func _same(what: String, a, b) -> void:
	a = JSON.parse_string(JSON.stringify(a))      # the recording went through JSON (whole numbers come back as 1.0)
	var sa := JSON.stringify(a, "", true)
	var sb := JSON.stringify(b, "", true)
	_check(sa == sb, what + (": same as recorded" if sa == sb else ": DIFFERENT from the recording"))
	if sa != sb and typeof(a) == TYPE_DICTIONARY and typeof(b) == TYPE_DICTIONARY:
		var shown := 0
		for k in b:
			if not a.has(k) or JSON.stringify(a[k], "", true) != JSON.stringify(b[k], "", true):
				print("   first difference at %s: now %s, recorded %s" % [k, JSON.stringify(a.get(k)).left(160), JSON.stringify(b[k]).left(160)])
				shown += 1
				if shown >= 3: break
		for k in a:
			if not b.has(k) and shown < 3:
				print("   not recorded: ", k)
				shown += 1

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)

## A working place (smoke and glow on the map, the ⏳ sign): FarmCrafting.place_state says "working" for the station's corner and its
## building while a batch cooks, and "idle" again once it is done; the picture entries in places.json "fires" point at real pictures.
func _working_places() -> void:
	G.reset_game()
	for sid in ["kitchen", "home", "workshop", "ws_fire"]:
		_check(G.crafting.place_state(sid) == "idle", "nothing is cooking in a new game: %s is idle" % sid)
	_check(_start("sourdough_starter"), "a batch of sourdough starter is started in the oven")
	_check(G.crafting.place_state("kitchen") == "working", "the kitchen is working while the loaf's starter bakes")
	_check(G.crafting.place_state("home") == "working", "…and so is the house it stands in")
	_check(G.crafting.place_state("workshop") == "idle" and G.crafting.place_state("ws_fire") == "idle", "…and the workshop is not")
	var n := 0
	while G.crafting.place_state("kitchen") == "working" and n < 30:
		G.step_time()
		n += 1
	_check(G.crafting.place_state("kitchen") == "idle" and G.crafting.place_state("home") == "idle" and n > 0, "the batch is done after %d questions: idle again" % n)
	_check(G.inventory.count("sourdough_starter") > 0, "…and it is in the store")
	_check(_start("bricks"), "a batch of bricks is fired in the kiln")
	_check(G.crafting.place_state("ws_fire") == "working" and G.crafting.place_state("workshop") == "working" and G.crafting.place_state("kitchen") == "idle", "the kiln's corner and the workshop are working, the kitchen is not")
	for key in Spots._data().get("fires", {}):
		var e: Dictionary = Spots.fire(key)
		var in_pic := true
		for k in e:
			in_pic = in_pic and k in ["smoke", "glow"] and (e[k] as Array).size() == 2 and float(e[k][0]) >= 0.0 and float(e[k][0]) <= 1.0 and float(e[k][1]) >= 0.0 and float(e[k][1]) <= 1.0
		_check(in_pic and not e.is_empty(), "fires %s: smoke and glow are points on the picture" % key)
		_check(ResourceLoader.exists("res://assets/%s.png" % key), "fires %s: the picture exists" % key)

## Paths wear in where the farmer walks (visible-work/08): G.trodden counts walks per cell of the walking grid; wear rises with every walk up to
## the cap of rules/69-trodden.json, a cell nobody walked stays 0, a new season fades the cells (dropped at zero), the sparse save key survives a
## save and a load, and a save without it loads with no wear.
func _trodden_paths() -> void:
	G.reset_game()
	var T = G.trodden
	var d: Dictionary = T.data()
	var cap := float(d["cap"])
	var a := Vector2i(10, 20)
	var b := Vector2i(11, 20)
	_check(T.save_defaults().is_empty() and not G.S.has("trodden"), "trodden: a new game has no wear key (sparse)")
	_check(T.wear_of(a) == 0.0 and T.worn().is_empty(), "trodden: nothing is worn before the first walk")
	var last := 0.0
	var monotonic := true
	var rose := 0
	var shown_at := -1
	for i in range(int(d["walksForTrack"]) * 2):
		T.wear(a)
		var w: float = T.wear_of(a)
		if w < last: monotonic = false
		if w > last: rose += 1
		last = w
		if shown_at < 0 and T.worn().has(a): shown_at = i + 1
	_check(monotonic and rose > 10, "trodden: every walk raises the wear, never lowers it (%d rises)" % rose)
	_check(absf(last - cap) < 0.01 and last <= cap and cap < 1.0, "trodden: the wear stops at the cap %.2f (%.3f after %d walks)" % [cap, last, int(d["walksForTrack"]) * 2])
	_check(int(G.S["trodden"]["10,20"]) == T.top(), "trodden: the count stays small (%d)" % int(G.S["trodden"]["10,20"]))
	_check(shown_at > 1 and shown_at < int(d["walksForTrack"]) / 2, "trodden: it shows from walk %d, not from the first" % shown_at)
	_check(T.wear_of(b) == 0.0 and not T.worn().has(b) and G.S["trodden"].size() == 1, "trodden: a cell nobody walked stays 0")
	T.wear(b)
	_check(T.wear_of(b) > 0.0 and T.wear_of(b) < T.wear_of(a), "trodden: one walk is a little, a long-walked cell is more")
	# a new season fades every cell by fadePerSeason walks; the same step without a new season changes nothing
	var before: int = G.S["trodden"]["10,20"]
	T.step({})
	_check(int(G.S["trodden"]["10,20"]) == before, "trodden: no change inside a season")
	T.step({"season": true})
	_check(int(G.S["trodden"]["10,20"]) == before - int(d["fadePerSeason"]) and not G.S["trodden"].has("11,20"), "trodden: a new season fades a cell and drops one that reaches zero")
	# a save and a load keep it; the same farm without the key loads with no wear
	var path := "user://trodden_test_save.json"
	var keep: int = G.S["trodden"]["10,20"]
	G.save_to(path)
	G.reset_game()
	_check(T.wear_of(a) == 0.0, "trodden: a new game after the test has no wear again")
	_check(G.load_game(path) and int(G.S["trodden"]["10,20"]) == keep and absf(T.wear_of(a) - float(keep) / float(d["walksForTrack"])) < 0.0001, "trodden: the wear survives a save and a load (%d)" % keep)
	var old: Dictionary = G.Saves.read(path)
	old.erase("trodden")
	G.Saves.write(path, old)
	G.reset_game()
	_check(G.load_game(path) and T.wear_of(a) == 0.0 and not G.S.has("trodden"), "trodden: an old save without the key loads with no wear")
	T.wear(a)
	_check(T.wear_of(a) > 0.0, "trodden: …and wears in from there")
	for _i in range(int(d["walksForTrack"])): T.step({"season": true})
	_check(not G.S.has("trodden"), "trodden: forgotten for long enough, the key is gone again")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	G.reset_game()

## Starts a recipe the way the game does (everything it needs is put in the store first); true when the batch is running.
func _start(rid: String) -> bool:
	var r: Dictionary = G.recipes[rid]
	G.S["unlocked"][r["station"]] = true
	for q in r.get("requires", []): G.S["unlocked"][q] = true
	G.invalidate_caps()
	G.S["energy"] = 1000.0
	G.S["water"] = 500.0
	G.S["woodpile"] = G.crafting.woodpile_cap()
	for k in r["inputs"]:
		var item: String = G.inventory.tag_choices(k.substr(4))[0] if k.begins_with("tag:") else k
		G.inventory.add_item(item, 60.0, true)
	for k in r.get("keeps", []): G.inventory.add_item(k, 1.0, true)
	return G.actions.perform("recipe", G.actions.farmer, {"rid": rid})["done"] and not (G.S["running"].get(G.crafting.chain_root(r["station"]), []) as Array).is_empty()
