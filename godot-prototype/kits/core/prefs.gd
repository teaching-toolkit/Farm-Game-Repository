extends RefCounted
## Device preferences: a few small choices that belong to the device (and the grown-up who set it up), not to a farm: whether the
## testing buttons show, whether questions are read aloud. One small JSON file in the user folder. With an empty path (tests, --seed)
## nothing is read or written. Knows nothing about any game.
##   var prefs = Prefs.new(); prefs.open("user://device.json")
##   prefs.get_value("readAloud", "button");  prefs.set_value("readAloud", "auto")

var _data := {}
var _path := ""

func open(path: String) -> void:
	_path = path
	_data = {}
	if path == "" or not FileAccess.file_exists(path): return
	var d = JSON.parse_string(FileAccess.get_file_as_string(path))
	if typeof(d) == TYPE_DICTIONARY: _data = d

func get_value(key: String, default = null):
	return _data.get(key, default)

func set_value(key: String, value) -> void:
	_data[key] = value
	if _path == "": return
	var f := FileAccess.open(_path, FileAccess.WRITE)
	if f: f.store_string(JSON.stringify(_data))
