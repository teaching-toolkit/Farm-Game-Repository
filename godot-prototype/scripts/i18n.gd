## Languages. English is written in the code and the data; every other language is a set of files in data/i18n/:
##   languages.json      the languages to offer in ⚙️ Settings: {"en": {"name": "English", "flag": "🇬🇧"}, "de": …}
##   ui-<lang>.json      the interface: {"English text as in tr(\"…\")": "translation"} (empty = still English)
##   data-<lang>.json    the game data: {"nodes/crop_wheat/name": {"en": "Wheat", "de": "Weizen"}, …}
##   learn-<lang>.json   the Rest sums (learnkit/curriculum/math.json), the same way
##   quiz-<lang>.json    the question packs (see tools/quiz_ids.py)
## tools/i18n.py collects every text and adds new ones to each language's files. The language is chosen per device
## (user://language.txt); without one, data/settings.json "language" counts.
class_name I18n
extends RefCounted

const DIR := "res://data/i18n"
const DEVICE_FILE := "user://language.txt"

static var lang := "en"

## The languages that can be chosen: {code: {"name", "flag"}} (English always).
static func languages() -> Dictionary:
	var d = _json(DIR + "/languages.json")
	if typeof(d) != TYPE_DICTIONARY or d.is_empty(): return {"en": {"name": "English", "flag": "🇬🇧"}}
	return d

## The language of this device, or the default from the settings.
static func device_language(default_lang: String) -> String:
	if FileAccess.file_exists(DEVICE_FILE):
		var t := FileAccess.get_file_as_string(DEVICE_FILE).strip_edges()
		if languages().has(t): return t
	return default_lang if languages().has(default_lang) else "en"

static func save_device_language(l: String) -> void:
	var f := FileAccess.open(DEVICE_FILE, FileAccess.WRITE)
	if f: f.store_string(l)

## Makes l the language: the interface texts go into Godot's TranslationServer, so tr("…") in every script and the
## text of every label and button follow it.
static func apply(l: String) -> void:
	lang = l
	var ts := TranslationServer
	ts.clear()
	if l != "en":
		var trn := Translation.new()
		trn.locale = l
		var d = _json("%s/ui-%s.json" % [DIR, l])
		if typeof(d) == TYPE_DICTIONARY:
			for k in d:
				if typeof(d[k]) == TYPE_STRING and str(d[k]) != "" and not str(k).begins_with("_"): trn.add_message(str(k), str(d[k]))
		ts.add_translation(trn)
	ts.set_locale(l)

## The translated texts of one part ("data" or "learn") as {path: text}, ready for overlay().
static func texts(kind: String) -> Dictionary:
	var out := {}
	if lang == "en": return out
	var d = _json("%s/%s-%s.json" % [DIR, kind, lang])
	if typeof(d) != TYPE_DICTIONARY: return out
	for p in d:
		var e = d[p]
		var t := str(e.get(lang, "")) if typeof(e) == TYPE_DICTIONARY else str(e)
		if t != "": out[p] = t
	return out

## Puts the texts into a loaded JSON structure: "nodes/k_wheat/questions/0/answers/1" → that string.
static func overlay(root, t: Dictionary) -> void:
	for p in t:
		var parts: PackedStringArray = str(p).split("/")
		var o = root
		var ok := true
		for i in range(parts.size() - 1):
			o = _child(o, parts[i])
			if o == null:
				ok = false
				break
		if not ok: continue
		var last := parts[parts.size() - 1]
		if typeof(o) == TYPE_DICTIONARY and o.has(last): o[last] = t[p]
		elif typeof(o) == TYPE_ARRAY and last.is_valid_int() and int(last) < o.size(): o[int(last)] = t[p]

static func _child(o, k: String):
	if typeof(o) == TYPE_DICTIONARY: return o.get(k, null)
	if typeof(o) == TYPE_ARRAY and k.is_valid_int() and int(k) < o.size(): return o[int(k)]
	return null

static func _json(path: String):
	if not FileAccess.file_exists(path): return null
	return JSON.parse_string(FileAccess.get_file_as_string(path))
