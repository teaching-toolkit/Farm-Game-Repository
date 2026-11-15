extends Node
## The people who are not the farmer (people/04): the rules (who stands in a scene, what a tap says) and the figures part
## (put, stroll, tap, take). Run:  godot --headless --path . res://tests/figures_test.tscn -- --seed=1
var G
var fails := 0
var _waited := 0.0     # how long the last `_wait_at` took (real seconds)
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	# the rules
	var sq: Array = G.people.who("square")
	_check(sq.size() == 5, "five people stand on the square (%s)" % str(sq))
	_check(G.people.who("nowhere").is_empty(), "nobody belongs to a scene that is not in the data")
	var saved: String = str(G.meta["people"]["who"]["old_woman"]["when"])
	G.meta["people"]["who"]["old_woman"]["when"] = "goals>=9999"
	_check(not ("old_woman" in G.people.who("square")) and G.people.who("square").size() == 4, "a person whose condition is false is left out")
	G.meta["people"]["who"]["old_woman"]["when"] = saved
	var lines: Array = G.people.person("seed_seller")["messages"]
	_check(lines.size() == 3 and G.people.spot("seed_seller", "square").get("stall", "") == "seeds", "the seed seller has three lines and stands at the seeds stall")
	# the figures part, in an empty scene
	var scene := Control.new()
	scene.size = Vector2(800, 500)
	add_child(scene)
	var F := FarmUiFigures.new()
	var got := []
	F.tapped.connect(func(id): got.append(id))
	var pts := [Vector2(200, 300), Vector2(500, 320), Vector2(400, 380)]
	F.put("old_woman", scene, pts[0], 100.0)
	F.put("old_woman", scene, pts[0], 100.0)
	_check(F.ids(scene) == ["old_woman"], "putting the same person again keeps one figure (%s)" % str(F.ids(scene)))
	F.stroll("old_woman", pts)
	var lo := Vector2(1e9, 1e9)
	var hi := Vector2(-1e9, -1e9)
	for p in pts:
		lo = Vector2(minf(lo.x, p.x), minf(lo.y, p.y))
		hi = Vector2(maxf(hi.x, p.x), maxf(hi.y, p.y))
	var inside := true
	var moved := 0.0
	for i in 1200:
		await get_tree().process_frame
		F.step(0.1)                                          # fast time: 120 seconds of strolling
		var q: Vector2 = F.feet("old_woman")
		moved = maxf(moved, q.distance_to(pts[0]))
		if q.x < lo.x - 2.0 or q.y < lo.y - 2.0 or q.x > hi.x + 2.0 or q.y > hi.y + 2.0: inside = false
	_check(inside, "the figure stays inside its strolling points")
	_check(moved > 100.0, "the figure walks about (%.0f px from its start at most)" % moved)
	var seen := []
	for i in 3:
		F._tapped("old_woman")                               # what a real tap on the figure calls
		seen.append(F.saying("old_woman"))
	_check(seen[0] in G.people.person("old_woman")["messages"] and seen[0] != seen[1] and seen[1] != seen[2] and seen[0] != seen[2], "three taps give three different lines of the person (%s)" % str(seen))
	_check(got == ["old_woman", "old_woman", "old_woman"], "the tapped signal fired for each tap")
	var bubble: Control = scene.find_child("bubble", true, false)
	_check(bubble != null and Rect2(Vector2.ZERO, scene.size).encloses(bubble.get_rect()), "the bubble stands inside the scene's edges")
	for i in 40: F.step(0.1)
	_check(F.saying("old_woman") == "", "the bubble goes away after a few seconds")
	var before: Vector2 = F.feet("old_woman")
	F.move_all(scene, Vector2(800, 500), Vector2(400, 250))
	_check(F.feet("old_woman").distance_to(before / 2.0) < 2.0, "a scene laid out for another size keeps the figure's relative place")
	F.take("old_woman")
	_check(F.ids(scene).is_empty() and F.saying("old_woman") == "", "take removes the figure")
	# walk_to: a figure goes straight to a point in about the time asked; a tap on the way stops it for its line, then it goes on; with `leave` it is taken out when it gets there
	F.put("village_boy", scene, Vector2(50, 300), 80.0)
	F.walk_to("village_boy", Vector2(650, 300), 1.5)
	await get_tree().create_timer(0.5).timeout
	var half: Vector2 = F.feet("village_boy")
	_check(half.x > 100.0 and half.x < 600.0, "walk_to: on its way after half a second (%.0f)" % half.x)
	F._tapped("village_boy")
	await get_tree().create_timer(0.3).timeout
	_check(F.saying("village_boy") != "" and absf(F.feet("village_boy").x - half.x) < 40.0, "walk_to: a tap stops it and it says its line")
	F.step(3.1)                                              # the bubble's time is up: it goes on
	_check(await _wait_at(F, "village_boy", Vector2(650, 300), 5.0), "walk_to: after its line it goes on to where it was sent (%s)" % str(F.feet("village_boy")))
	F.walk_to("village_boy", Vector2(-80, 300), 1.0, true)
	await get_tree().create_timer(0.4).timeout
	_check(F.ids(scene) == ["village_boy"], "walk_to leave: still there on its way out")
	await get_tree().create_timer(1.6).timeout
	for i in 5: F.step(0.1)
	_check(F.ids(scene).is_empty(), "walk_to leave: taken out of the scene when it got there")
	await _merchant_checks()
	await _visitor_checks()
	print("FIGURES %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)

## Waits (real seconds, at most `max_s`) until the person's feet are within 3 pixels of `p`.
func _wait_at(F: FarmUiFigures, id: String, p: Vector2, max_s: float) -> bool:
	var t0 := Time.get_ticks_msec()
	while float(Time.get_ticks_msec() - t0) / 1000.0 < max_s:
		F.step(0.05)
		if F.ids(F._figs[id]["scene"]).has(id) and F.feet(id).distance_to(p) < 3.0:
			_waited = float(Time.get_ticks_msec() - t0) / 1000.0
			return true
		await get_tree().create_timer(0.05).timeout
	return false

## The travelling merchant on the farm map (game/farm/map/merchant.gd): a figure with his cart exactly while he is here, the cart's picture by thirds of
## its fill, he walks in from the left edge when he arrives and off to the left when he leaves, a tap on him gives a line.
func _merchant_checks() -> void:
	G.reset_game()
	var map: FarmMap = load("res://game/farm/map/farm_map.tscn").instantiate()
	add_child(map)
	map.fit(Vector2(834, 1000))
	await get_tree().process_frame
	var F := FarmUiFigures.new()
	map.merchant.figures = F
	var layer := func() -> Control: return map.board.find_child("merchant_layer", true, false)
	var here := func() -> Array: return F.ids(layer.call()) if layer.call() != null else []
	_check(here.call().is_empty() and map.merchant.cart == null and map.merchant.level() == 0, "merchant: not here, no figure and no cart")
	map.set_gate(true, 0.1)                                  # the game starts with him there: he just stands
	var stand: Vector2 = map.merchant._stand()
	_check(here.call() == ["merchant"] and F.feet("merchant").distance_to(stand) < 2.0, "merchant: a game that starts with him there has him standing beside his cart (%s)" % str(F.feet("merchant")))
	_check(map.merchant.cart != null and F.feet("merchant").x < map.merchant.cart.position.x, "merchant: he stands beside the cart, on its left, not on it")
	var seen := []
	for fill in [0.0, 0.2, 0.34, 0.5, 0.67, 0.9, 1.0]:
		map.set_gate(true, fill)
		seen.append(map.merchant.level())
		var path := str(map.merchant.cart.texture.resource_path)
		_check(path.ends_with("merchant_cart_%d.png" % map.merchant.level()), "merchant: fill %.2f shows %s" % [fill, path])
	_check(seen == [1, 1, 2, 2, 3, 3, 3], "merchant: the cart is one of three pictures by thirds of its fill (%s)" % str(seen))
	map.set_gate(true, 0.1)
	map.set_gate(false, 0.0)                                 # he leaves: he walks off to the left, the cart fades
	await get_tree().create_timer(0.8).timeout
	_check(here.call() == ["merchant"] and F.feet("merchant").x < stand.x - 40.0, "merchant: on his way out (%.0f of %.0f)" % [F.feet("merchant").x, stand.x])
	await get_tree().create_timer(1.8).timeout
	for i in 5: F.step(0.1)
	_check(here.call().is_empty() and map.merchant.cart == null, "merchant: gone when he is not here")
	map.set_gate(true, 0.5)                                  # he arrives: from the left edge to his cart
	var start: Vector2 = F.feet("merchant")
	_check(start.x < 1.0 and absf(start.y - stand.y) < 2.0, "merchant: he comes in from the left edge of the map (%s)" % str(start))
	_check(await _wait_at(F, "merchant", stand, 5.0) and _waited > 1.5 and _waited < 2.6, "merchant: he walks to his cart in about two seconds (%.1f s, %s of %s)" % [_waited, str(F.feet("merchant")), str(stand)])
	F._tapped("merchant")
	_check(F.saying("merchant") in G.people.person("merchant")["messages"], "merchant: a tap on him gives one of his lines (%s)" % F.saying("merchant"))
	map.set_gate(false, 0.0)
	map.set_gate(true, 1.0)                                  # still here after another look: nothing doubles
	_check(here.call() == ["merchant"] and map.merchant.level() == 3, "merchant: one figure and one cart")
	map.queue_free()

## A story visitor (people/01, game/farm/map/visitor.gd, systems/people.gd): the rules (who visits, for how many questions, a second visit replaces
## the first), and on the farm map a figure exactly while somebody visits: it walks in from the left edge to the farmhouse door, stands, walks off
## to the left, a tap on it gives one of the person's lines.
func _visitor_checks() -> void:
	G.reset_game()
	G.S["step"] = 10
	var P = G.people
	var seven := ["maud", "greenstem", "miller", "wren", "quill", "lark", "mei"]
	var steps: int = int(P.data()["visitSteps"])
	_check(P.visitor() == "", "visitor: nobody is visiting at the start")
	P.visit("maud")
	_check(P.visitor() == "maud", "visitor: Granny Maud visits (%s)" % P.visitor())
	G.S["step"] = 10 + steps - 1
	_check(P.visitor() == "maud", "visitor: she is still there one question before the visit is over")
	G.S["step"] = 10 + steps
	_check(P.visitor() == "", "visitor: after visitSteps (%d) questions she is gone" % steps)
	G.S["step"] = 10
	P.visit("maud")
	P.visit("wren")
	_check(P.visitor() == "wren", "visitor: a second visit replaces the first")
	P.visit("merchant")
	P.visit("nobody")
	_check(P.visitor() == "wren", "visitor: somebody who has no door scene (or is unknown) does not visit")
	G.S["step"] = 3
	_check(P.visitor() == "", "visitor: a farm that is loaded earlier has nobody visiting")
	var ok_seven := true
	for id in seven:
		var d: Dictionary = P.person(id)
		ok_seven = ok_seven and d.has("look") and (d.get("messages", []) as Array).size() == 3 and d.get("scenes", {}).has("door")
	_check(ok_seven, "visitor: the seven have a look, three lines and a door scene")
	# on the farm map
	G.S["step"] = 10
	var map: FarmMap = load("res://game/farm/map/farm_map.tscn").instantiate()
	add_child(map)
	map.fit(Vector2(834, 1000))
	await get_tree().process_frame
	var F := FarmUiFigures.new()
	map.visitor.figures = F
	var layer := func() -> Control: return map.board.find_child("visitor_layer", true, false)
	var here := func() -> Array: return F.ids(layer.call()) if layer.call() != null else []
	_check(here.call().is_empty() and map.visitor.here() == "", "visitor: nobody is shown while nobody visits")
	var stand: Vector2 = map.visitor.stand("maud")
	var house: Vector2 = map.slots["home"].anchor
	_check(stand.x < house.x and stand.distance_to(house) < 0.15 * map.design.x, "visitor: she stands at the farmhouse's front, left of its middle (%s of %s)" % [str(stand), str(house)])
	_check(stand.distance_to(map.spot_point("road")) > 0.2 * map.design.x, "visitor: not on the merchant's place at the road")
	map.visitor.sync("maud")
	var start: Vector2 = F.feet("maud")
	_check(here.call() == ["maud"] and start.x < 1.0 and absf(start.y - stand.y) < 2.0, "visitor: she comes in from the left edge of the map (%s)" % str(start))
	_check(await _wait_at(F, "maud", stand, 5.0) and _waited > 1.5 and _waited < 2.6, "visitor: she walks to the door in about two seconds (%.1f s, %s of %s)" % [_waited, str(F.feet("maud")), str(stand)])
	map.visitor.sync("maud")                                 # the same visitor again: nothing doubles
	_check(here.call() == ["maud"] and F.feet("maud").distance_to(stand) < 3.0, "visitor: the same visitor again changes nothing")
	F._tapped("maud")
	_check(F.saying("maud") in P.person("maud")["messages"], "visitor: a tap on her gives one of her three lines (%s)" % F.saying("maud"))
	map.visitor.sync("greenstem")                            # a second visit: the first is gone at once
	_check(here.call() == ["greenstem"] and map.visitor.here() == "greenstem", "visitor: Greenstem replaces her at once (%s)" % str(here.call()))
	_check(await _wait_at(F, "greenstem", map.visitor.stand("greenstem"), 5.0), "visitor: Greenstem walks to the door")
	map.visitor.sync("")                                     # the visit is over: he walks off to the left
	await get_tree().create_timer(0.8).timeout
	_check(here.call() == ["greenstem"] and map.visitor.here() == "" and F.feet("greenstem").x < stand.x - 40.0, "visitor: on his way out (%.0f of %.0f)" % [F.feet("greenstem").x, stand.x])
	await get_tree().create_timer(1.8).timeout
	for i in 5: F.step(0.1)
	_check(here.call().is_empty(), "visitor: gone when the visit is over")
	var each := true
	for id in seven:                                         # every one of the seven can come: one figure, their own
		map.visitor.sync(id)
		each = each and here.call() == [id]
	_check(each, "visitor: each of the seven comes as one figure")
	map.visitor.sync("")
	map.queue_free()
