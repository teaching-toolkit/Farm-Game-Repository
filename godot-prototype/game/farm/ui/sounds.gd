extends RefCounted
## Sounds of the screen: what plays for gains, animal voices, coins landing.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const Fx = preload("res://game/farm/fx.gd")

var M
var G

## Which sound fits what just arrived: from a patch (harvest, weeds, stones, wood), a recipe (by its kind of work),
## animals, water, a building step.
func _gain_sound(source: String, got: Dictionary) -> String:
	if source.begins_with("patch:"):
		if got.has("fiber"): return "weed"
		if got.has("stone"): return "dig"
		if got.has("log") or got.has("stick"): return "chop"
		return "harvest"
	if source.begins_with("recipe:"):
		var cat: String = G.recipe_cat(source.substr(7))
		if got.has("stone") or got.has("clay"): return "dig"
		if got.has("fiber"): return "weed"
		return {"cook": "cook", "prep": "cook", "wood": "chop", "gather": "chop", "smith": "smith", "kiln": "smith",
			"craft": "craft", "textile": "craft", "process": "craft", "mill": "craft", "animal": "collect"}.get(cat, "build")
	if source.begins_with("animal:"): return "collect"
	if source == "water": return "water"
	return "build"

## Tapping a pen: its animals call (perk "Farm sounds"; Sound checks the perk).
func _animal_voice(sid: String) -> void:
	var v: Array = _voices_at(sid)
	if not v.is_empty(): Sound.play(v[randi() % v.size()])

func _voices_at(sid: String) -> Array:
	if sid == "pets":
		var out := []
		var pv: Dictionary = G.farm_animals.get("petVoices", {})
		for pid in pv:
			if G.done(pid): out.append(pv[pid])
		return out
	var out2 := []
	var voices: Dictionary = G.farm_animals.get("voices", {}).get(sid, {})
	for v in voices:
		var aid: String = voices[v]
		if G.nodes.has(aid) and int(G.animal(aid)["count"]) > 0: out2.append(v)
	return out2

## Now and then, while the farm is on screen, an animal (or a bird, or the cat) makes itself heard.
func _animal_ambience(t: Timer) -> void:
	t.wait_time = randf_range(20.0, 45.0)
	if M.modal.visible or not G.perk_on("perk_sounds"): return
	var v := ["birds"]
	for sid in ["coop", "cows", "sheep", "bees", "pets"]: v.append_array(_voices_at(sid))
	if G.done("barn_cat"): v.append("cat")
	Sound.play(v[randi() % v.size()])

## A sound effect by its name in data/sounds.json (kits/audio/sound.gd: files, or a stand-in the game makes itself).
func _sfx(name: String) -> void:
	Sound.play(name)

## Something was sold: a jingle, and coins fly into the purse (perk "Coin shower").
func _on_sold(_k: String, n: float, _coins: float) -> void:
	_sfx("coin")
	M.ui_acts._act("sell", M.map.stand_point(M.ui_map._map_sid("market")))
	if not G.perk_on("perk_coins"): return
	_sfx("coin_shower")
	var cs = Fx.CoinShower.new()
	M.add_child(cs)
	cs.position = Vector2.ZERO
	cs.size = M.size
	var from := Vector2(M.size.x / 2.0, M.size.y * 0.62)
	if M.sheet.visible: from = M.sheet.get_global_rect().get_center()
	cs.start(from, M.lbl_coins.get_global_rect().get_center(), clampi(int(n), 3, 12), _coin_landed)

func _coin_landed() -> void:
	M.lbl_coins.pivot_offset = M.lbl_coins.size / 2.0
	var tw = M.create_tween()
	tw.tween_property(M.lbl_coins, "scale", Vector2(1.15, 1.15), 0.06)
	tw.tween_property(M.lbl_coins, "scale", Vector2.ONE, 0.1)
