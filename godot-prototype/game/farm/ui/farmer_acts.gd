extends RefCounted
## The farmer acting out what the player did (where on the map, which act).
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const Spots = preload("res://game/farm/spots.gd")

var M
var G

## For screenshots and tests: an act at a patch ("weed@patch3") or a place ("cook@kitchen").
func _test_act(arg: String) -> void:
	M.ui_modal._close_modal()
	var parts := arg.split("@")
	var where: Vector2 = M.map.patch_point(0, 0)
	if parts.size() > 1:
		if parts[1].begins_with("patch"): where = M.map.patch_point(0, int(parts[1].substr(5)))
		else: where = M.map.stand_point(M.ui_map._map_sid(parts[1]))
	_act(parts[0], where)

## The farmer acts it out (kits/avatar/actor.gd). The numbers have changed already; the farmer only catches up.
func _act(name: String, where: Vector2) -> void:
	if M.map and M.map.actor: M.map.actor.perform(name, where)

## Where the farmer works on a patch: the patch itself on a field, the orchard or the greenhouse otherwise.
func _patch_place(a: String, i: int) -> Vector2:
	if a == "field": return M.map.patch_point(i / 9, i % 9)
	return M.map.stand_point(M.ui_map._map_sid("orchard" if a == "orchard" else "greenhouse"))

## A place name in an act ("water", "spot:<id>") as a point on the farm.
func _act_place(name: String):
	if name == "water": return M.map.stand_point(M.ui_map._map_sid("well" if G.done("well_2") else "pond"))
	if name.begins_with("spot:"): return M.map.stand_point(M.ui_map._map_sid(name.substr(5)))
	return null

## What arrived tells what was done, and where: act it out there.
func _act_for_gain(source: String, kind: String) -> void:
	var act: String = {"harvest": "harvest", "weed": "weed", "dig": "dig", "chop": "chop", "cook": "cook", "craft": "craft",
		"smith": "build", "build": "build", "collect": "collect", "water": "water"}.get(kind, "")
	if act == "": return
	var parts := source.split(":")
	match parts[0]:
		"patch": _act(act, _patch_place(parts[1], int(parts[2])))
		"recipe": _act(act, M.map.stand_point(M.ui_map._map_sid(Spots.spot_of(G, str(G.recipes[parts[1]]["station"])))))
		"animal", "node": _act(act, M.map.stand_point(M.ui_map._map_sid(Spots.spot_of(G, parts[1]))))
		"water": _act(act, _act_place("water"))
