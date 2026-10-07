## Sound and music for the whole game (autoload "Sound"). What plays is data: data/sounds.json names every sound effect
## (files in assets/sounds/sfx/, a few picked at random; or a sound the game makes itself while a file is missing) and every
## music track (assets/sounds/music/) with the situation it belongs to (the farm in each season, the Time Quiz, Rest).
## Some effects belong to a perk ("perk": id) and only play while that perk is on. Music and effects can be switched
## off separately in ⚙️ Settings (saved on this device). The credits of every file are in data/sounds.json too.
extends Node

const Fx = preload("res://scripts/fx.gd")
const CATALOG := "res://data/sounds.json"
const SETTINGS := "user://sound.json"
const FADE := 1.2

var C := {}                       # the catalog
var music_on := true
var sfx_on := true
var perk_on: Callable = func(_id): return true     # set by the game: is a perk switched on?
var synth                         # the sounds the game makes itself (fx.gd), for effects without a file
var _players: Array = []
var _next := 0
var _cache := {}
var _music: Array = []            # two players for cross-fading
var _cur := 0
var _track := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for b in ["Music", "SFX"]:
		if AudioServer.get_bus_index(b) < 0:
			AudioServer.add_bus()
			var i := AudioServer.bus_count - 1
			AudioServer.set_bus_name(i, b)
			AudioServer.set_bus_send(i, "Master")
	var d = JSON.parse_string(FileAccess.get_file_as_string(CATALOG)) if FileAccess.file_exists(CATALOG) else null
	C = d if typeof(d) == TYPE_DICTIONARY else {}
	var s = JSON.parse_string(FileAccess.get_file_as_string(SETTINGS)) if FileAccess.file_exists(SETTINGS) else null
	if typeof(s) == TYPE_DICTIONARY:
		music_on = bool(s.get("music", true))
		sfx_on = bool(s.get("sfx", true))
	for i in range(6):
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_players.append(p)
	for i in range(2):
		var m := AudioStreamPlayer.new()
		m.bus = "Music"
		m.volume_db = -80.0
		add_child(m)
		_music.append(m)
	synth = Fx.Sfx.new()
	synth.bus = "SFX"
	add_child(synth)

# ------------------------------------------------------------------ effects
## Plays a sound effect by its name in the catalog (nothing if effects are off, the name is unknown, or its perk is off).
func play(name: String) -> void:
	if not sfx_on: return
	var e: Dictionary = C.get("sfx", {}).get(name, {})
	if e.is_empty(): return
	if str(e.get("perk", "")) != "" and not perk_on.call(str(e["perk"])): return
	var files: Array = e.get("files", []).filter(func(f): return ResourceLoader.exists(_path("sfx", f)))
	if files.is_empty():
		if str(e.get("synth", "")) != "": synth.play(str(e["synth"]))
		return
	var p: AudioStreamPlayer = _players[_next]
	_next = (_next + 1) % _players.size()
	p.stream = _load(_path("sfx", str(files[randi() % files.size()])))
	p.volume_db = float(e.get("volume", -6.0))
	p.pitch_scale = randf_range(0.95, 1.05) if bool(e.get("vary", true)) else 1.0
	p.play()

## Is there a sound for this name (so callers can choose another)?
func has(name: String) -> bool:
	return C.get("sfx", {}).has(name)

# ------------------------------------------------------------------ music
## The music for a situation: "farm" (by season: pass the season), "quiz", "rest" … (data: music.play). A track that
## has no file yet means silence. The same track keeps playing; a new one fades in over the old one.
func music(situation: String, season := "") -> void:
	var play: Dictionary = C.get("music", {}).get("play", {})
	var want = play.get(situation, "")
	if typeof(want) == TYPE_DICTIONARY: want = want.get(season, want.get("any", ""))
	_switch(str(want))

func _switch(track: String) -> void:
	var t: Dictionary = C.get("music", {}).get("tracks", {}).get(track, {})
	var path := _path("music", str(t.get("file", ""))) if not t.is_empty() else ""
	if not music_on or path == "" or not ResourceLoader.exists(path): track = ""
	if track == _track: return
	_track = track
	var old: AudioStreamPlayer = _music[_cur]
	var tw := create_tween().set_parallel(true)
	tw.tween_property(old, "volume_db", -80.0, FADE)
	tw.chain().tween_callback(old.stop)
	if track == "": return
	_cur = 1 - _cur
	var m: AudioStreamPlayer = _music[_cur]
	var st = _load(path)
	if st is AudioStreamOggVorbis: st.loop = true
	elif st is AudioStreamMP3: st.loop = true
	m.stream = st
	m.volume_db = -60.0
	m.play()
	var tw2 := create_tween()
	tw2.tween_property(m, "volume_db", float(t.get("volume", -12.0)), FADE)

# ------------------------------------------------------------------ settings and credits
func set_music(on: bool) -> void:
	music_on = on
	if not on: _switch("")
	_save()

func set_sfx(on: bool) -> void:
	sfx_on = on
	_save()

func _save() -> void:
	var f := FileAccess.open(SETTINGS, FileAccess.WRITE)
	if f: f.store_string(JSON.stringify({"music": music_on, "sfx": sfx_on}))

## Who made the sounds and music that are in the game: [{"what", "author", "licence", "source"}] (files present only).
func credits() -> Array:
	var out := []
	for c in C.get("credits", []):
		var used := false
		for f in c.get("files", []):
			if ResourceLoader.exists("res://assets/sounds/" + str(f)): used = true
		if used: out.append(c)
	return out

func _path(kind: String, f: String) -> String:
	return "" if f == "" else "res://assets/sounds/%s/%s" % [kind, f]

func _load(path: String):
	if not _cache.has(path): _cache[path] = load(path)
	return _cache[path]
