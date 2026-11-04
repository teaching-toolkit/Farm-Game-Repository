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
		if M.mapview.card_shown(cid) and G.knowledge.card_status(cid) in ["quiz", "readable"]: return cid
	return ""

func update_goal_bar() -> void:
	if M.goal_id != "":
		var n: Dictionary = G.nodes[M.goal_id]
		var ok: bool = G.progression.can_unlock(M.goal_id)["ok"]
		M.goal_btn.text = "%s %s %s" % ["✅" if ok else "🎯", n.get("emoji", ""), n["name"]]      # symbol and name only; what it needs is on its place's sheet (interface-feel/06)
	elif _readable_card() != "":
		M.goal_btn.text = tr("🎯 📚 Learn a new card in the library")
	else:
		M.goal_btn.text = tr("🎯 Answer Time Quiz questions — things grow while you learn")
	fit_text()

const FIT_SIZES := [22, 20, 18, 17, 16, 15, 14, 13, 12, 11]

## The goal's text takes the biggest font size at which it fits the button (wrapped onto as many lines as the height allows).
func fit_text() -> void:
	var b: Button = M.goal_btn
	if b == null or b.size.x < 10.0: return
	var font: Font = b.get_theme_font("font")
	var sb: StyleBox = b.get_theme_stylebox("normal")
	var w := b.size.x - (sb.get_margin(SIDE_LEFT) + sb.get_margin(SIDE_RIGHT) if sb else 16.0) - 4.0
	var h := b.size.y - (sb.get_margin(SIDE_TOP) + sb.get_margin(SIDE_BOTTOM) if sb else 12.0) - 2.0
	var pick: int = FIT_SIZES[-1]
	for fs in FIT_SIZES:
		var need: Vector2 = font.get_multiline_string_size(b.text, HORIZONTAL_ALIGNMENT_LEFT, w, fs, -1, TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE)
		if need.y <= h and need.x <= w + 0.5:
			pick = fs
			break
	if b.get_theme_font_size("font_size") != pick: b.add_theme_font_size_override("font_size", pick)

## The font size the goal's text has now (tests).
func text_size() -> int:
	return M.goal_btn.get_theme_font_size("font_size")

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
