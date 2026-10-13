extends RefCounted
class_name FarmUiFeedback
## How the farm reacts: the farmer acting things out, animal voices and sounds, coins landing in the purse.

const Spots = preload("res://game/farm/spots.gd")
const Fx = preload("res://game/farm/fx.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ Rest

## For screenshots and tests: an act at a patch ("weed@patch3") or a place ("cook@kitchen").
func test_act(arg: String) -> void:
	M.modals.close_modal()
	var parts := arg.split("@")
	var where: Vector2 = M.map.patch_point(0, 0)
	if parts.size() > 1:
		if parts[1].begins_with("patch"): where = M.map.patch_point(0, int(parts[1].substr(5)))
		else: where = M.map.stand_point(M.mapview.map_sid(parts[1]))
	play_act(parts[0], where)

## The farmer acts it out (kits/avatar/actor.gd). The numbers have changed already; the farmer only catches up.
func play_act(name: String, where: Vector2) -> void:
	if M.map and M.map.actor: M.map.actor.perform(name, where)

## Where the farmer works on a patch: the patch itself on a field, the orchard or the greenhouse otherwise.
func patch_place(a: String, i: int) -> Vector2:
	if a == "field": return M.map.patch_point(i / 9, i % 9)
	return M.map.stand_point(M.mapview.map_sid("orchard" if a == "orchard" else "greenhouse"))

## A place name in an act ("water", "spot:<id>") as a point on the farm.
func act_place(name: String):
	if name == "water": return M.map.stand_point(M.mapview.map_sid("well" if G.done("well_2") else "pond"))
	if name.begins_with("spot:"): return M.map.stand_point(M.mapview.map_sid(name.substr(5)))
	return null

## What arrived tells what was done, and where: act it out there.
func act_for_gain(source: String, kind: String) -> void:
	var act: String = {"harvest": "harvest", "weed": "weed", "dig": "dig", "chop": "chop", "cook": "cook", "craft": "craft",
		"smith": "build", "build": "build", "collect": "collect", "water": "water"}.get(kind, "")
	if act == "": return
	var parts := source.split(":")
	match parts[0]:
		"patch": play_act(act, patch_place(parts[1], int(parts[2])))
		"recipe": play_act(act, M.map.stand_point(M.mapview.map_sid(Spots.spot_of(G, str(G.recipes[parts[1]]["station"])))))
		"animal", "node": play_act(act, M.map.stand_point(M.mapview.map_sid(Spots.spot_of(G, parts[1]))))
		"water": play_act(act, act_place("water"))

## Which sound fits what just arrived: from a patch (harvest, weeds, stones, wood), a recipe (by its kind of work),
## animals, water, a building step.
func gain_sound(source: String, got: Dictionary) -> String:
	if source.begins_with("patch:"):
		if got.has("fiber"): return "weed"
		if got.has("stone"): return "dig"
		if got.has("log") or got.has("stick"): return "chop"
		return "harvest"
	if source.begins_with("recipe:"):
		var cat: String = G.crafting.recipe_cat(source.substr(7))
		if got.has("stone") or got.has("clay"): return "dig"
		if got.has("fiber"): return "weed"
		return {"cook": "cook", "prep": "cook", "wood": "chop", "gather": "chop", "smith": "smith", "kiln": "smith",
			"craft": "craft", "textile": "craft", "process": "craft", "mill": "craft", "animal": "collect"}.get(cat, "build")
	if source.begins_with("animal:"): return "collect"
	if source == "water": return "water"
	return "build"

## Tapping a pen: its animals call (perk "Farm sounds"; Sound checks the perk).
func animal_voice(sid: String) -> void:
	var v: Array = _voices_at(sid)
	if not v.is_empty(): Sound.play(v[randi() % v.size()])

## The sound an animal or pet makes (its node's "voice" in the data), or "" if it has none or is not on the farm yet.
func _voice_of(id: String) -> String:
	var n: Dictionary = G.nodes[id]
	var v := str(n.get("voice", ""))
	if v == "": return ""
	var here: bool = G.done(id) if n["type"] == "pet" else int(G.animals.animal(id)["count"]) > 0
	return v if here else ""

func _voices_at(sid: String) -> Array:
	var out := []
	for id in Spots.nodes_at(G, sid):
		var v := _voice_of(id)
		if v != "": out.append(v)
	return out

## Now and then, while the farm is on screen, an animal (or a bird, or the cat) makes itself heard.
func animal_ambience(t: Timer) -> void:
	t.wait_time = randf_range(20.0, 45.0)
	if M.modal.visible or not G.rewards.perk_on("perk_sounds"): return
	var v := ["birds"]
	for id in G.animal_ids + G.pet_ids:
		var voice := _voice_of(id)
		if voice != "": v.append(voice)
	if G.done("barn_cat"): v.append("cat")
	Sound.play(v[randi() % v.size()])

## A sound effect by its name in data/sounds.json (kits/audio/sound.gd: files, or a stand-in the game makes itself).
func sfx(name: String) -> void:
	Sound.play(name)

## Something was sold: a jingle, and coins fly into the purse (perk "Coin shower").
func on_sold(_k: String, n: float, _coins: float) -> void:
	sfx("coin")
	play_act("sell", M.map.stand_point(M.mapview.map_sid("market")))
	if not G.rewards.perk_on("perk_coins"): return
	sfx("coin_shower")
	var cs = Fx.CoinShower.new()
	M.add_child(cs)
	cs.position = Vector2.ZERO
	cs.size = M.size
	var from := Vector2(M.size.x / 2.0, M.size.y * 0.62)
	if M.sheet.visible: from = M.sheet.get_global_rect().get_center()
	cs.start(from, M.lbl_coins.get_global_rect().get_center(), clampi(int(n), 3, 12), _coin_landed)

func _coin_landed() -> void:
	M.lbl_coins.pivot_offset = M.lbl_coins.size / 2.0
	var tw := M.create_tween()
	tw.tween_property(M.lbl_coins, "scale", Vector2(1.15, 1.15), 0.06)
	tw.tween_property(M.lbl_coins, "scale", Vector2.ONE, 0.1)
