extends RefCounted
class_name FarmUiGoalBar
## The next goal (what the player can work on next), shown in the top bar, and what happens when it is tapped.

const Spots = preload("res://game/farm/spots.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ things flying to the store

func next_goal() -> String:
	var best := ""
	var bk := 1 << 30
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		var t: String = n["type"]
		if t in ["knowledge", "book", "polish", "animal", "crop", "merchant", "sidequest"]: continue
		if n.get("optional", false) or G.done(id) or G.satisfied(id): continue
		if not G.progression.missing_reqs(id).is_empty(): continue
		var k := int(n.get("chapter", 1)) * 10 + (0 if G.progression.can_unlock(id)["ok"] else 1)
		if k < bk:
			bk = k; best = id
	return best

func _readable_card() -> String:
	for cid in G.card_ids:
		if G.knowledge.card_status(cid) in ["quiz", "readable"]: return cid
	return ""

func update_goal_bar() -> void:
	if M.goal_id != "":
		var n: Dictionary = G.nodes[M.goal_id]
		var ok: bool = G.progression.can_unlock(M.goal_id)["ok"]
		var c: Dictionary = G.pace.node_cost(M.goal_id)
		M.goal_btn.text = "%s %s %s   %s" % ["✅" if ok else "🎯", n.get("emoji", ""), n["name"], G.pace.cost_text(c) if not c.is_empty() else ""]
	elif _readable_card() != "":
		M.goal_btn.text = tr("🎯 📚 Learn a new card in the library")
	else:
		M.goal_btn.text = tr("🎯 Answer Time Quiz questions — things grow while you learn")

func goal_pressed() -> void:
	if M.goal_id != "":
		var sid := Spots.spot_of(G, M.goal_id)
		M.sheets.open_sheet_for(sid)
		M.mapview.pulse(sid)
	elif _readable_card() != "":
		M.sheets.open_sheet_for("library")
		M.mapview.pulse("library")
	else:
		M.timequiz.show_time_quiz()
