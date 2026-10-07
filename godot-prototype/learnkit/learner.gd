## LearnKit · one learner's record: a plain, pretty-printed JSON file that people can read and edit by hand
## (or with learnkit/tools/learning-editor.html). Every game that uses the kit can share it.
##
##   var Learner = preload("res://learnkit/learner.gd")
##   var me = Learner.new()
##   me.open(Learner.file_for("user://players", "Mia"), "Mia")
##   me.data["math"] …  me.data["quiz"] …
##   me.save()
##
## File: {"format": "learnkit-1", "name": "Mia", "updated": "2026-10-06 14:03",
##        "math": {...math_engine.gd...}, "quiz": {"n": 0, "items": {"question text": {"box", "due", "right", "wrong"}}}}
## Where it lives: Godot's user folder — on a Mac ~/Library/Application Support/Godot/app_userdata/<game>/players/<name>/
## (open it from the game's settings); in a web build inside the browser (use export / import in the settings).
extends RefCounted

const FORMAT := "learnkit-1"

var path := ""
var data: Dictionary = {}

## <root>/<name as a file name>/learning.json
static func file_for(root: String, name: String) -> String:
	return "%s/%s/learning.json" % [root, slug(name)]

static func slug(n: String) -> String:
	var out := ""
	for ch in n.strip_edges().to_lower():
		out += ch if (ch >= "a" and ch <= "z") or (ch >= "0" and ch <= "9") else "_"
	return out if out.strip_edges() != "" else "player"

## Loads the record (or starts a new one) and brings older layouts up to date.
func open(file_path: String, name: String) -> void:
	path = file_path
	data = {}
	if path != "" and FileAccess.file_exists(path):
		var d = JSON.parse_string(FileAccess.get_file_as_string(path))
		if typeof(d) == TYPE_DICTIONARY: data = d
	if not data.has("name"): data["name"] = name
	upgrade(data)

## Older records (before the kit): Time Quiz answers "tq"/"tq_n" move to "quiz"; the first Rest sums ("rest_srs") are dropped.
static func upgrade(d: Dictionary) -> void:
	d["format"] = FORMAT
	if not d.has("quiz"): d["quiz"] = {"n": int(d.get("tq_n", 0)), "items": d.get("tq", {})}
	d.erase("tq")
	d.erase("tq_n")
	d.erase("rest_srs")
	d.erase("rest_n")
	d.erase("arith")

func save() -> void:
	if path == "": return
	data["updated"] = Time.get_datetime_string_from_system(false, true)
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f: f.store_string(JSON.stringify(data, "  ", false))

## The whole record as text (to copy out of a web build) …
func export_text() -> String:
	return JSON.stringify(data, "  ", false)

## … and back in. Returns false if the text is not a record.
func import_text(t: String) -> bool:
	var d = JSON.parse_string(t)
	if typeof(d) != TYPE_DICTIONARY: return false
	upgrade(d)
	if not d.has("name"): d["name"] = data.get("name", "")
	data.clear()
	for k in d: data[k] = d[k]
	save()
	return true

## The folder of the file on this computer (to open it in Finder / Explorer), or "" in a web build.
func folder() -> String:
	if path == "" or OS.has_feature("web"): return ""
	return ProjectSettings.globalize_path(path.get_base_dir())
