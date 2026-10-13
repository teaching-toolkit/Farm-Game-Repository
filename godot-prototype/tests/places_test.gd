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
	# the pets: one per chapter, in order
	_check(G.pet_ids.size() == G.D["chapters"].size(), "one pet per chapter (%d pets)" % G.pet_ids.size())
	_check(G.animal_ids.size() == 4, "four animals (%d)" % G.animal_ids.size())
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
		G._caps = null
		ch[key] = G.chapter()
		lk[key] = snappedf(G.luck(), 0.000001)
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
