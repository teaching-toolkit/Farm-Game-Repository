extends RefCounted
class_name FarmUiForest
## The forest (TODO S4): the sheet with its spots and their tasks of the season, the basket, Wren's check and the way in and out
## (each costs a Time Quiz question). Choosing a plant (find) or the right part of it (pick) opens a small window.

const UI = preload("res://kits/ui/ui.gd")

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

func _reopen() -> void:
	if M.sheet.visible and M.sheet_kind == "forest": M.sheets.rebuild_sheet()
	else: M.sheets.open_sheet("forest")

func sheet_forest() -> void:
	if not G.forest.open():
		M.content.add_child(UI.label(tr("The path into the forest is overgrown. Clear Berit's still-room first."), 17, UI.MUTED, true))
		return
	if not G.forest.inside():
		M.content.add_child(UI.label(tr("🌲 The forest is quiet. Wren said: “Bring me your basket. Every time.”"), 18, UI.INK, true))
		M.content.add_child(UI.button(tr("🚶 Walk into the forest (one question)"), _go_in, true, UI.GREEN, 20))
		_part_basket()
		return
	M.widgets.section(tr("🌲 In the forest"), tr("Tap a spot's task. Look closely before you pick: some plants have poisonous twins."))
	for sid in G.forest.spots():
		_spot_card(sid)
	_part_basket()
	M.content.add_child(UI.button(tr("🚶 Back to the farm (one question)"), _go_out, true, UI.AMBER, 20))

func _spot_card(sid: String) -> void:
	var sp: Dictionary = G.forest.spots()[sid]
	var tasks: Array = (sp["tasks"] as Array).filter(func(t): return G.forest.in_season(t))
	if tasks.is_empty(): return
	var card := UI.card(Color("f3f7ea"))
	var v := UI.vbox(4)
	card.add_child(v)
	v.add_child(UI.label("%s %s" % [sp["emoji"], tr(str(sp["name"]))], 19, UI.INK, true))
	for t in tasks:
		var ck: Dictionary = G.actions.check("forest_" + str(t["kind"]), G.actions.farmer, {"spot": sid, "tid": str(t["id"])})
		var left: int = G.forest.rest_left(sid, str(t["id"]))
		var txt := tr(str(t["heading"]))
		var b := UI.button(txt + ("   ⏳%d" % left if left > 0 else ""), _task.bind(sid, str(t["id"])), ck["ok"], UI.GREEN if t["kind"] != "look" else UI.AMBER, 16)
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v.add_child(b)
		if not ck["ok"] and ck["unmet"][0]["text"] != "" and left == 0: v.add_child(UI.label(str(ck["unmet"][0]["text"]), 13, UI.MUTED, true))
	M.content.add_child(card)

func _task(sid: String, tid: String) -> void:
	var t: Dictionary = G.forest.task(sid, tid)
	match str(t["kind"]):
		"find": _choose_plant(sid, t)
		"pick": _choose_part(sid, t)
		_:
			var r: Dictionary = G.actions.perform("forest_" + str(t["kind"]), G.actions.farmer, {"spot": sid, "tid": tid})
			if r["done"] and t.has("text"): G.say("🌲 " + tr(str(t["text"])))
			_reopen()

## find: the options are described, never named.
func _choose_plant(sid: String, t: Dictionary) -> void:
	var box := M.modals.open_modal("🔍 " + tr(str(t["heading"])))
	box.add_child(UI.label(tr("Which one is it? Look closely. A wrong plant looks right until somebody checks."), 16, UI.MUTED, true))
	for o in t["options"]:
		var b := UI.button("%s  %s" % [o["emoji"], tr(str(o["label"]))], _picked_plant.bind(sid, str(t["id"]), str(o["id"])), true, UI.GREEN, 17)
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.custom_minimum_size = Vector2(0, 64)
		box.add_child(b)
	M.modals.fit_modal.call_deferred()

func _picked_plant(sid: String, tid: String, option: String) -> void:
	var r: Dictionary = G.actions.perform("forest_find", G.actions.farmer, {"spot": sid, "tid": tid, "option": option})
	M.modals.close_modal()
	if r["done"]: G.say(tr("🧺 In the basket. Have it checked before you use it."))
	_reopen()

## pick: which part of the plant?
func _choose_part(sid: String, t: Dictionary) -> void:
	var box := M.modals.open_modal("✂️ " + tr(str(t["heading"])))
	box.add_child(UI.label(tr("Which part do you pick? Think of what you learned in the book."), 16, UI.MUTED, true))
	for pt in G.forest.data().get("parts", []):
		var b := UI.button("%s  %s" % [pt["emoji"], tr(str(pt["name"]))], _picked_part.bind(sid, str(t["id"]), str(pt["id"])), true, UI.GREEN, 18)
		b.custom_minimum_size = Vector2(0, 56)
		box.add_child(b)
	M.modals.fit_modal.call_deferred()

func _picked_part(sid: String, tid: String, part: String) -> void:
	var r: Dictionary = G.actions.perform("forest_pick", G.actions.farmer, {"spot": sid, "tid": tid, "part": part})
	M.modals.close_modal()
	if r["done"]: G.say(tr("🧺 In the basket. Have it checked before you use it.") if r["result"]["good"] else tr("🍂 That is not the part you need. Nothing is useful in your hands."))
	_reopen()

# ------------------------------------------------------------------ the basket and Wren

func _part_basket() -> void:
	var cl: Dictionary = G.forest.claimed()
	if cl.is_empty(): return
	M.widgets.section(tr("🧺 Your basket (%d of %d)") % [G.forest.basket().size(), G.forest.capacity()], tr("Not checked yet."))
	var parts := []
	for k in cl: parts.append("%s %s × %d" % [G.iemoji(k), G.iname(k), int(cl[k])])
	M.content.add_child(UI.label("   ".join(parts), 17, UI.INK, true))
	var f: Dictionary = G.forest.favour()
	var cost := tr("a small favour")
	if f.has("item"): cost = "%s %s" % [G.iemoji(str(f["item"])), G.iname(str(f["item"]))]
	elif f.has("coins"): cost = G.money(float(f["coins"]))
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 6)
	row.add_child(UI.button(tr("🩺 Visit Wren: she checks it (%s)") % cost, _wren, true, UI.GREEN, 17))
	row.add_child(UI.soft_button(tr("⚠️ Use it without checking"), _unchecked, true, 15))
	M.content.add_child(row)

func _wren() -> void:
	var rep: Dictionary = G.forest.check()
	var box := M.modals.open_modal(tr("🩺 Wren looks through your basket"))
	box.add_child(UI.header(null, "🌿", 64))
	var good: Dictionary = rep["good"]
	var parts := []
	for k in good: parts.append("%s %s × %d" % [G.iemoji(k), G.iname(k), int(good[k])])
	box.add_child(UI.label(tr("Good: %s") % (", ".join(parts) if not parts.is_empty() else "—"), 18, UI.INK, true))
	var seen := {}
	for k in rep["bad"]:
		if seen.has(k): continue
		seen[k] = true
		box.add_child(UI.label("%s %s: %s" % [G.iemoji(k), G.iname(k), tr(str(G.items[k]["desc"]))], 17, UI.RED, true))
	if not (rep["bad"] as Array).is_empty(): box.add_child(UI.label(tr("“See? That is why we check.” Wren throws the wrong plants away."), 17, UI.MUTED, true))
	var ok := UI.button(tr("Thank you, Wren"), M.modals.close_modal, true, UI.GREEN, 20)
	ok.custom_minimum_size = Vector2(0, 52)
	box.add_child(ok)
	M.modals.fit_modal.call_deferred()
	if M.sheet.visible and M.sheet_kind == "forest": M.sheets.rebuild_sheet()

func _unchecked() -> void:
	G.forest.use_unchecked()
	G.say(tr("⚠️ Everything went into the store without a check. Be careful with it."))
	_reopen()

# ------------------------------------------------------------------ the way in and out

func _go_in() -> void:
	if not G.actions.check("forest_enter", G.actions.farmer)["ok"]: return
	M.sheets.close_sheet()
	M.timequiz.show_walk_question({"title": tr("🚶 Into the forest"), "emoji": "🌲", "button": tr("🌲 Look around"), "done": _entered})

func _entered() -> String:
	G.actions.perform("forest_enter", G.actions.farmer)
	return tr("🌲 You are in the forest.")

func _go_out() -> void:
	M.sheets.close_sheet()
	M.timequiz.show_walk_question({"title": tr("🚶 Back to the farm"), "emoji": "🏡", "button": tr("🧺 Look at the basket"), "done": _left})

func _left() -> String:
	G.actions.perform("forest_leave", G.actions.farmer)
	return tr("🏡 You are home again. Your basket is not checked yet.")
