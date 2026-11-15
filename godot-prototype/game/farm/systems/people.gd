extends RefCounted
class_name FarmPeople
## The people who are not the farmer (people/04): who stands in which scene, how they look, and what a tapped person says. Everything
## that is not derived is data (data/farm/rules/58-people.json); nothing is saved (the lines' counter and the visit live in memory only).
## `line(id)` is the ONE place that decides what a tapped person says: today it cycles through their three lines; moods and story
## lines are added there later, never in a scene.
## `visit(id)` / `visitor()`: a story visitor (one of the seven, scene "door") comes to the farm when a story piece of kind visit about them is
## shown (story.gd) and stays `visitSteps` Time Quiz questions (farm steps, G.S["step"]); `visitor()` is the ONE place that says who is there.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems
var _said := {}   # id -> how many times they have spoken (in memory only)
var _visitor := ""      # who came to visit the farm ("" = nobody); in memory only: a farm that is loaded has no visitor
var _visit_step := 0    # the farm step (G.S["step"]) at which the visit began

func _init(game: FarmGame) -> void:
	G = game

func data() -> Dictionary:
	return G.meta.get("people", {})

## The people who belong to a scene (e.g. "square") and whose `when` holds now, in the data's order.
func who(scene: String) -> Array:
	var out := []
	for id in data().get("who", {}):
		var p: Dictionary = data()["who"][id]
		if not p.get("scenes", {}).has(scene): continue
		var w := str(p.get("when", ""))
		if w != "" and not G.conditions.holds(w): continue
		out.append(str(id))
	return out

## One person's data ({} when unknown): name, look, messages, when, scenes.
func person(id: String) -> Dictionary:
	return data().get("who", {}).get(id, {})

## What a person does in a scene: {"stall": id} for a seller, {"stroll": [point names]} for a villager ({} when not there).
func spot(id: String, scene: String) -> Dictionary:
	return person(id).get("scenes", {}).get(scene, {})

## What a tapped person says now (already in the player's language: the data is translated when the game starts).
## For now: their lines in turn.
func line(id: String) -> String:
	var m: Array = person(id).get("messages", [])
	if m.is_empty(): return ""
	var n: int = int(_said.get(id, 0))
	_said[id] = n + 1
	return str(m[n % m.size()])

## A story visitor comes to the farm now (a second one replaces the first). Something that is not a person with a door scene is ignored.
func visit(id: String) -> void:
	if not person(id).get("scenes", {}).has("door"): return
	_visitor = id
	_visit_step = int(G.S["step"])

## Who is visiting the farm now: the person's id, or "" when nobody is, or when `visitSteps` steps have passed since they came.
func visitor() -> String:
	var passed := int(G.S["step"]) - _visit_step
	if _visitor == "" or passed < 0 or passed >= int(data().get("visitSteps", 2)): return ""
	return _visitor
