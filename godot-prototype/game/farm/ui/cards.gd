extends RefCounted
class_name FarmUiCards
## Knowledge cards: the page to read, its quiz, and the quiz after reading.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ knowledge cards

## A knowledge card. Starting to read it (or reading it again) shows its page, with 🔊 to hear it; its quiz shows only
## the questions, not the page.
func show_card(cid: String) -> void:
	var st: String = G.knowledge.card_status(cid)
	if st == "quiz" and G.knowledge.page_seen(cid):
		_card_quiz_only(cid)
		return
	card_page(cid)

## The card's page (to read now, or to read again). A card whose quiz is waiting gets a button to start it.
func card_page(cid: String) -> void:
	M.feedback.sfx("book")
	var n: Dictionary = G.nodes[cid]
	G.knowledge.mark_page_seen(cid)
	var box := M.modals.open_modal("%s %s" % [n.get("emoji", "📖"), n["name"]])
	box.add_child(UI.header(Art.first("cards", [cid]), str(n.get("emoji", "📖")), 84))
	var page := str(n.get("page", n.get("desc", "")))
	box.add_child(UI.label(page, 20, UI.INK, true))
	box.add_child(UI.soft_button(tr("🔊 Read aloud"), M.timequiz.speak.bind(page), true, 17))
	var unl := []
	for u in n.get("unlocks", []):
		if G.nodes.has(u): unl.append(G.nodes[u].get("emoji", "") + " " + G.nodes[u]["name"])
		elif G.recipes.has(u): unl.append("🍳 " + str(G.recipes[u].get("name", G.iname(G.recipes[u]["outputs"].keys()[0]))))
	if unl.size() > 0: box.add_child(UI.label(tr("Knowing this lets you: ") + ", ".join(unl), 16, UI.MUTED, true))
	match G.knowledge.card_status(cid):
		"learned":
			box.add_child(UI.label(tr("✅ You already know this card."), 19, UI.GREEN_DARK))
		"reading":
			var left := maxi(1, G.up(G.knowledge.read_needed(cid) - float(G.S["read_progress"])))
			var rr := UI.hbox(8)
			rr.add_child(UI.label("📖", 22))
			rr.add_child(UI.explain(UI.stock_bar(float(G.S["read_progress"]), ceilf(G.knowledge.read_needed(cid)), UI.BLUE, 160), tr("📖 Pages read: each Time Quiz question turns one.")))
			rr.add_child(UI.wait_button(left, _quiz_from_card))
			box.add_child(rr)
		"quiz":
			var sb := UI.button(tr("❓ Take the quiz ▶"), _card_quiz_only.bind(cid), true, UI.GREEN, 20)
			sb.custom_minimum_size = Vector2(0, 56)
			box.add_child(sb)

func _quiz_from_card() -> void:
	M.modals.close_modal()
	M.timequiz.show_time_quiz()

## The card's quiz: only the questions (the page was read before).
func _card_quiz_only(cid: String) -> void:
	var n: Dictionary = G.nodes[cid]
	var box := M.modals.open_modal("❓ %s %s" % [n.get("emoji", "📖"), n["name"]])
	var qs: Array = G.knowledge.card_quiz(cid)
	var qbox := UI.vbox(8)
	box.add_child(qbox)
	_card_q(cid, qs, 0, qbox, {"all_first": true})

func _card_q(cid: String, qs: Array, idx: int, qbox: VBoxContainer, acc: Dictionary) -> void:
	var last := M.modal_box.get_child(M.modal_box.get_child_count() - 1)
	if last is Button: M.modal_box.remove_child(last); last.queue_free()
	M.widgets.clear(qbox)
	if idx >= qs.size():
		G.knowledge.finish_card(cid, acc["all_first"])
		qbox.add_child(UI.label(tr("🎓 You learned \"%s\"!") % G.nodes[cid]["name"], 24, UI.GREEN_DARK, true))
		qbox.add_child(UI.soft_button(tr("⬅️ Back to the farm"), M.modals.close_modal, true, 18))
		M.modals.fit_modal.call_deferred()
		return
	var q: Dictionary = qs[idx]
	qbox.add_child(UI.label((tr("📚 Review: ") + G.nodes[q["card"]]["name"]) if q["review"] else tr("Question %d") % (idx + 1), 15, UI.MUTED))
	var inner := UI.vbox(8)
	qbox.add_child(inner)
	M.timequiz.question(inner, q, _card_answered.bind(cid, qs, idx, qbox, acc))

func _card_answered(first_try: bool, cid: String, qs: Array, idx: int, qbox: VBoxContainer, acc: Dictionary) -> void:
	G.knowledge.record_card_answer(qs[idx], first_try)
	if not first_try and not qs[idx]["review"]: acc["all_first"] = false
	var nb := UI.button(tr("Next ▶") if idx + 1 < qs.size() else tr("Finish ▶"), _card_q.bind(cid, qs, idx + 1, qbox, acc), true, UI.GREEN, 19)
	nb.custom_minimum_size = Vector2(0, 52)
	qbox.add_child(nb)
	M.modals.fit_modal.call_deferred()
