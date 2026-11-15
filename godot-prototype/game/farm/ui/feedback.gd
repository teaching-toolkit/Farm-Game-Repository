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

## Where a pet works at an animal's pen (a pen chore says `aid`, the animal): the spot the animal's pen stands at (the chickens' run, the barn, the
## bees); the coop's spot when the animal belongs to no spot of the map.
func pen_place(aid: String) -> Vector2:
	var sid := Spots.spot_of(G, aid) if G.nodes.has(aid) else "field"
	return M.map.stand_point(M.mapview.map_sid("coop" if sid == "field" else sid))

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
		if got.has("stone") or got.has("boulder"): return "dig"
		if got.has("log") or got.has("stick"): return "chop"
		return "harvest"
	if source.begins_with("recipe:"):
		var cat: String = G.crafting.recipe_cat(source.substr(7))
		if got.has("stone") or got.has("boulder") or got.has("clay"): return "dig"
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

## Something was sold: a jingle, the farmer acts it out, and coins fly into the purse (the perk "Coin shower" makes it a shower).
func on_sold(_k: String, n: float, coins: float) -> void:
	sfx("coin")
	play_act("sell", M.map.stand_point(M.mapview.map_sid("market")))
	if not G.rewards.perk_on("perk_coins"):
		fly_coins(coins, true)
		return
	sfx("coin_shower")
	var cs = Fx.CoinShower.new()
	M.add_child(cs)
	cs.position = Vector2.ZERO
	cs.size = M.size
	var from := Vector2(M.size.x / 2.0, M.size.y * 0.62)
	if M.sheet.visible: from = M.sheet.get_global_rect().get_center()
	if M.square.active(): from = M.square.stall_point("sell")
	cs.start(from, M.lbl_coins.get_global_rect().get_center(), clampi(int(n), 3, 12), _coin_landed)

## Something was paid for: coins fly from the purse to the trader.
func on_paid(coins: float) -> void:
	sfx("coin")
	fly_coins(coins, false)

## Coins flying between the purse and the trader (M3): one coin for every 10 bronze, in tight bunches of 10 (27 coins: 10 + 10 + 7), at most 6 bunches.
func fly_coins(bronze: float, to_purse: bool) -> void:
	var pieces := clampi(ceili(bronze / 10.0), 1, 60)
	var mid := M.sheet.get_global_rect().get_center() if M.sheet.visible else Vector2(M.size.x / 2.0, M.size.y * 0.62)
	if M.square.active(): mid = M.square.stall_point(M.square.stall)      # in the village: the stall that pays or is paid
	var purse := M.lbl_coins.get_global_rect().get_center()
	var from := mid if to_purse else purse
	var to := purse if to_purse else mid
	var delay := 0.0
	while pieces > 0:
		var n := mini(10, pieces)
		pieces -= n
		M.get_tree().create_timer(delay).timeout.connect(_launch_coins.bind(from, to, n, to_purse))
		delay += 0.3

func _launch_coins(from: Vector2, to: Vector2, n: int, to_purse: bool) -> void:
	var cs = Fx.CoinShower.new()
	M.add_child(cs)
	cs.position = Vector2.ZERO
	cs.size = M.size
	cs.start(from, to, n, _coin_landed if to_purse else Callable())

## A spark from a tapped, greyed-out chore button to the clock (no time left, action-budget/03): a bright dot with a short tail, 0.35 s;
## when it arrives the clock gives one small knock. `sparks_sent` is for the tests.
var sparks_sent := 0

func spark(from: Vector2, to: Control) -> void:
	sparks_sent += 1
	var sp := Spark.new()
	M.add_child(sp)
	sp.position = Vector2.ZERO
	sp.size = M.size
	sp.start(from, to, M.size.x)

## The spark itself: it flies along a small arch to wherever the target is, and frees itself on arrival. Sizes are shares of the screen's width.
class Spark extends Control:
	const FLIGHT := 0.35
	var a := Vector2.ZERO
	var target: Control
	var width := 800.0
	var t := 0.0
	var trail: Array = []

	func start(from: Vector2, to: Control, w: float) -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		a = from
		target = to
		width = w
		set_process(true)

	func _end() -> Vector2:
		return target.get_global_rect().get_center() if is_instance_valid(target) else a

	func _process(d: float) -> void:
		t += d
		var f := clampf(t / FLIGHT, 0.0, 1.0)
		var e := f * f * (3.0 - 2.0 * f)
		var b := _end()
		var c := (a + b) / 2.0 + Vector2(0.0, -width * 0.08)
		trail.append((a.lerp(c, e)).lerp(c.lerp(b, e), e))
		if trail.size() > 9: trail.pop_front()
		queue_redraw()
		if f >= 1.0:
			if is_instance_valid(target) and target.has_method("knock"): target.knock()
			queue_free()

	func _draw() -> void:
		var r := maxf(4.0, width * 0.012)
		var n := trail.size()
		for i in range(n):
			var k := float(i + 1) / float(n)
			draw_circle(trail[i], r * k * 0.85, Color(1.0, 0.78, 0.2, 0.5 * k))
		if n > 0:
			draw_circle(trail[n - 1], r * 1.6, Color(1.0, 0.85, 0.35, 0.35))
			draw_circle(trail[n - 1], r, Color(1.0, 0.97, 0.8))

func _coin_landed() -> void:
	M.lbl_coins.pivot_offset = M.lbl_coins.size / 2.0
	var tw := M.create_tween()
	tw.tween_property(M.lbl_coins, "scale", Vector2(1.15, 1.15), 0.06)
	tw.tween_property(M.lbl_coins, "scale", Vector2.ONE, 0.1)
