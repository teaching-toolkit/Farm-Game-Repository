extends RefCounted
## Seasons and weather: the season clock, season modifiers, rain, what changes when a season turns. (Kit to be: seasons & weather.)
## Split out of game.gd in R4 (12 Oct 2026). Everything else of the game is reached through G, the front door
## (the Game autoload), which still answers to every function name, so callers did not change.

var G

func season_len() -> int:
	return int(G.meta.get("seasons", {}).get("lengthQuestions", 30))

func season_no() -> int:
	return int(G.S["step"] / G.season_len())

func season() -> String:
	return G.SEASON_NAMES[G.season_no() % 4]

func smod(k: String, d = 1.0):
	return G.meta.get("seasons", {}).get("mods", {}).get(G.season(), {}).get(k, d)

func season_emoji() -> String:
	return str(G.smod("emoji", "🌱"))

func questions_left_in_season() -> int:
	return G.season_len() - (G.S["step"] % G.season_len())

func _step_season(info: Dictionary) -> void:
	var sn = G.season_no()
	if sn != int(G.S["last_season"]):
		G._season_change(sn)
		G.S["last_season"] = sn
		info["season"] = true

func _step_rain(info: Dictionary) -> void:
	var rain_ch = float(G.smod("rain", 0.0)) * (1.0 + 0.3 * G.luck())
	var was_rain: bool = G.S.get("rain", false)
	G.S["rain"] = G.rng.randf() < rain_ch
	info["rain"] = G.S["rain"]
	info["rain_stopped"] = was_rain and not G.S["rain"]

func _season_change(sn: int) -> void:
	var nm: String = G.SEASON_NAMES[sn % 4]
	var spoiled := {}
	var fr = G.meta.get("freshness", {})
	var animal_items: Array = fr.get("animalItems", [])
	for k in G.S["inv"].keys():
		var life = G.shelf_life(k)
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
			G.add_item(to, lost, true)
			spoiled[k] = lost
	var msg = tr("%s It's %s! %s") % [str(G.meta["seasons"]["mods"][nm].get("emoji", "")), tr(nm), str(G.meta["seasons"]["mods"][nm].get("abundance", ""))]
	G.say(msg)
	if not spoiled.is_empty():
		var parts := []
		for k in spoiled: parts.append("%s%d" % [G.iemoji(k), G.up(spoiled[k])])
		G.say(tr("🍂 Went stale at the change of season (now feed mash or compost): ") + " ".join(parts))
	G._check_acorns()
