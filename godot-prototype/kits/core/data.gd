extends RefCounted
## A game's data files: read JSON, read a whole folder of them in name order and merge their top-level keys.
## Knows nothing about any game. (The language files are laid over the merged data by kits/i18n/i18n.gd.)
##   Data.read("res://data/farm/items.json")           -> the parsed file (Dictionary or Array), null if missing or broken
##   Data.read_dir("res://data/farm/nodes")            -> one Dictionary: all files merged in NAME order; entries keep the order
##                                                        they have in the files (lists in the game follow it); a key in two files is an error

static func read(path: String):
	if not FileAccess.file_exists(path):
		push_error("data file missing: " + path)
		return null
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	if parsed == null: push_error("data file is not valid JSON: " + path)
	return parsed

## The .json files of a folder, sorted by name (the order the game relies on).
static func files(dir_path: String) -> Array:
	var out := []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		push_error("data folder missing: " + dir_path)
		return out
	for f in dir.get_files():
		if f.ends_with(".json"): out.append(f)
	out.sort()
	return out

static func read_dir(dir_path: String) -> Dictionary:
	var merged := {}
	for f in files(dir_path):
		var d = read(dir_path.path_join(f))
		if typeof(d) != TYPE_DICTIONARY: continue
		for k in d:
			if merged.has(k): push_error("data: key %s is in two files of %s (second: %s)" % [k, dir_path, f])
			merged[k] = d[k]
	return merged
