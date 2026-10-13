extends RefCounted
class_name FarmSeasons
## The farm's seasons and weather: the length of a season, which season it is, what it changes (rain, growth, prices),
## what happens when a new one begins. Part of the step of time (registered in Game.setup_clock()).

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"last_season": 0, "rain": false}

# ------------------------------------------------------------------ seasons

func season_len() -> int:
	return int(G.meta.get("seasons", {}).get("lengthQuestions", 30))

func season_no() -> int:
	return int(G.S["step"] / season_len())

func season() -> String:
	return G.SEASON_NAMES[season_no() % 4]

func smod(k: String, d = 1.0):
	return G.meta.get("seasons", {}).get("mods", {}).get(season(), {}).get(k, d)

func season_emoji() -> String:
	return str(smod("emoji", "🌱"))

func questions_left_in_season() -> int:
	return season_len() - (G.S["step"] % season_len())

# ------------------------------------------------------------------ one Time Quiz answer

func step_season(info: Dictionary) -> void:
	var sn := season_no()
	if sn != int(G.S["last_season"]):
		_season_change(sn)
		G.S["last_season"] = sn
		info["season"] = true

## Rain waters the fields (planting costs no water this question); water never comes by itself, it is carried.
func step_rain(info: Dictionary) -> void:
	var rain_ch := float(smod("rain", 0.0)) * (1.0 + 0.3 * G.rewards.luck())
	var was_rain: bool = G.S.get("rain", false)
	G.S["rain"] = G.rng.randf() < rain_ch
	info["rain"] = G.S["rain"]
	info["rain_stopped"] = was_rain and not G.S["rain"]
	if G.g("waterPerStep", 0.0) > 0.0: G.S["water"] = minf(G.needs.water_cap(), float(G.S["water"]) + G.g("waterPerStep", 0.0))

func _season_change(sn: int) -> void:
	var nm: String = G.SEASON_NAMES[sn % 4]
	var spoiled := {}
	var fr = G.meta.get("freshness", {})
	var animal_items: Array = fr.get("animalItems", [])
	for k in G.S["inv"].keys():
		var life := G.inventory.shelf_life(k)
		if life < 0: continue
		var arr: Array = G.S["inv"][k]
		var keep := []
		var lost := 0.0
		for b in arr:
			if sn - int(b[0]) > life: lost += float(b[1])
			else: keep.append(b)
		if lost > 0.0:
			if keep.is_empty(): G.S["inv"].erase(k)
			else: G.S["inv"][k] = keep
			var to: String = fr.get("spoilsTo", {}).get("animal" if animal_items.has(k) else "plant", "compost")
			G.inventory.add_item(to, lost, true)
			spoiled[k] = lost
	var msg := tr("%s It's %s! %s") % [str(G.meta["seasons"]["mods"][nm].get("emoji", "")), tr(nm), str(G.meta["seasons"]["mods"][nm].get("abundance", ""))]
	G.say(msg)
	if not spoiled.is_empty():
		var parts := []
		for k in spoiled: parts.append("%s%d" % [G.iemoji(k), G.up(spoiled[k])])
		G.say(tr("🍂 Went stale at the change of season (now feed mash or compost): ") + " ".join(parts))
	G.rewards.check_acorns()
