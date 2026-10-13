extends RefCounted
class_name FarmMapCat
## The farm cat: strolls, sits, washes, naps and runs at the pests.
const Art = preload("res://kits/ui/art.gd")
const UI = preload("res://kits/ui/ui.gd")


var map: FarmMap   # the map: its layers and the other parts

func _init(owner_map: FarmMap) -> void:
	map = owner_map

var cat: TextureRect          # the farm cat (from the side quest): walks about, chases pests, naps

var cat_emoji: Label

var _cat := {"state": "", "until": 0.0, "target": Vector2.ZERO, "frame": 0.0}

var _cat_sort := 0.0

# ------------------------------------------------------------------ the farm cat

## The cat (pictures assets/animals/cat_walk_1, cat_walk_2, cat_sit, cat_sleep, cat_leap, cat_run, cat_stretch,
## cat_lick, cat_lie — all looking to the right): she strolls about, sits, washes, stretches, naps, and runs at the pests.
func set_cat(on: bool) -> void:
	if on and cat == null:
		cat = TextureRect.new()
		cat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		cat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		cat.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cat.size = Vector2(48, 40)
		cat.position = Vector2(map.design.x * 0.55, map.design.y * 0.62)
		cat_emoji = UI.label("", 28)
		cat_emoji.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cat.add_child(cat_emoji)
		map.sort_in(cat, cat.position.y + cat.size.y)
		_cat_next()
	elif not on and cat != null:
		cat.queue_free()
		cat = null

func _cat_pic(name: String) -> void:
	var t: Texture2D = Art.first("animals", ["cat_" + name, "cat_sit", "cat_walk_1"])
	cat.texture = t
	cat_emoji.text = "" if t else ("💤" if name == "sleep" else "🐈")

func _cat_next() -> void:
	var now := Time.get_ticks_msec() / 1000.0
	# pests on a field? she goes for them (but not every time)
	var hunt := Vector2.INF
	var hunt_field = null
	for fv in map.fields:
		var at: Vector2 = fv.pest_spot()
		if at != Vector2.INF:
			hunt = at
			hunt_field = fv
			break
	var r := randf()
	if hunt != Vector2.INF and r < 0.55:
		_cat = {"state": "run", "until": now + 6.0, "target": hunt - Vector2(cat.size.x / 2.0, cat.size.y * 0.8), "field": hunt_field, "frame": 0.0}
		_cat_pic("run")
	elif r < 0.6:
		var tgt := Vector2(randf_range(0.08, 0.85) * map.design.x, randf_range(0.35, 0.92) * map.design.y)
		_cat = {"state": "walk", "until": now + 14.0, "target": tgt, "frame": 0.0}
		_cat_pic("walk_1")
	else:
		var pick: Array = [["sit", 4.0], ["lick", 4.0], ["stretch", 2.5], ["lie", 6.0], ["sleep", 12.0]][randi() % 5]
		_cat = {"state": pick[0], "until": now + pick[1] * randf_range(0.8, 1.4), "target": cat.position, "frame": 0.0}
		_cat_pic(pick[0])

func tick(delta: float) -> void:
	if cat == null: return
	var now := Time.get_ticks_msec() / 1000.0
	var st: String = _cat["state"]
	if st == "walk" or st == "run":
		var speed := 38.0 if st == "walk" else 120.0
		var to: Vector2 = _cat["target"] - cat.position
		if to.length() > 3.0:
			cat.flip_h = to.x < 0.0
			cat.position += to.normalized() * minf(speed * delta, to.length())
			_cat["frame"] = float(_cat["frame"]) + delta
			if st == "walk": _cat_pic("walk_1" if int(float(_cat["frame"]) / 0.28) % 2 == 0 else "walk_2")
		else:
			if st == "run" and _cat.get("field") != null:
				_cat_pic("leap")
				_cat["field"].shoo_one()
				_cat = {"state": "sit", "until": now + 2.5, "target": cat.position, "frame": 0.0}
				return
			_cat["until"] = 0.0
	_cat_sort += delta
	if _cat_sort > 0.4:
		_cat_sort = 0.0
		map.sort_in(cat, cat.position.y + cat.size.y)
	if now >= float(_cat["until"]): _cat_next()
