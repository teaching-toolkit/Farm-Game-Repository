extends RefCounted
## Knowledge cards: the card page, its quiz.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")

var M
var G

## A knowledge card. Starting to read it (or reading it again) shows its page, with 🔊 to hear it; its quiz shows only
## the questions, not the page.
func _show_card(cid: String) -> void:
	var st: String = G.card_status(cid)
	if st == "quiz" and G.S.get("read_seen", {}).has(cid):
		_card_quiz_only(cid)
		return
	_card_page(cid)

## The card's page (to read now, or to read again). A card whose quiz is waiting gets a button to start it.
func _card_page(cid: String) -> void:
	M.ui_sounds._sfx("book")
	var n: Dictionary = G.nodes[cid]
	if not G.S.has("read_seen"): G.S["read_seen"] = {}
	G.S["read_seen"][cid] = true
	var box = M.ui_modal._open_modal("%s %s" % [n.get("emoji", "📖"), n["name"]])
	box.add_child(UI.header(Art.first("cards", [cid]), str(n.get("emoji", "📖")), 84))
	var page := str(n.get("page", n.get("desc", "")))
	box.add_child(UI.label(page, 20, UI.INK, true))
	box.add_child(M.ui_quiz._speak_button(page, M.tr("🔊 Read aloud"), 17))
	var unl := []
	for u in n.get("unlocks", []):
		if G.nodes.has(u): unl.append(G.nodes[u].get("emoji", "") + " " + G.nodes[u]["name"])
		elif G.recipes.has(u): unl.append("🍳 " + str(G.recipes[u].get("name", G.iname(G.recipes[u]["outputs"].keys()[0]))))
	if unl.size() > 0: box.add_child(UI.label(M.tr("Knowing this lets you: ") + ", ".join(unl), 16, UI.MUTED, true))
	match G.card_status(cid):
		"learned":
			box.add_child(UI.label(M.tr("✅ You already know this card."), 19, UI.GREEN_DARK))
		"reading":
			var left := maxi(1, G.up(G.read_needed(cid) - float(G.S["read_progress"])))
			var rr := UI.hbox(8)
			rr.add_child(UI.label("📖", 22))
			rr.add_child(UI.explain(UI.stock_bar(float(G.S["read_progress"]), ceilf(G.read_needed(cid)), UI.BLUE, 160), M.tr("📖 Pages read: each Time Quiz question turns one.")))
			rr.add_child(UI.wait_button(left, _quiz_from_card))
			box.add_child(rr)
		"quiz":
			var sb := UI.button(M.tr("❓ Take the quiz ▶"), _card_quiz_only.bind(cid), true, UI.GREEN, 20)
			sb.custom_minimum_size = Vector2(0, 56)
			box.add_child(sb)

func _quiz_from_card() -> void:
	M.ui_modal._close_modal()
	M.ui_quiz._show_time_quiz()

## The card's quiz: only the questions (the page was read before).
func _card_quiz_only(cid: String) -> void:
	var n: Dictionary = G.nodes[cid]
	var box = M.ui_modal._open_modal("❓ %s %s" % [n.get("emoji", "📖"), n["name"]])
	var qs: Array = G.card_quiz(cid)
	var qbox := UI.vbox(8)
	box.add_child(qbox)
	_card_q(cid, qs, 0, qbox, {"all_first": true})

func _card_q(cid: String, qs: Array, idx: int, qbox: VBoxContainer, acc: Dictionary) -> void:
	var last = M.modal_box.get_child(M.modal_box.get_child_count() - 1)
	if last is Button: M.modal_box.remove_child(last); last.queue_free()
	M._clear(qbox)
	if idx >= qs.size():
		G.finish_card(cid, acc["all_first"])
		qbox.add_child(UI.label(M.tr("🎓 You learned \"%s\"!") % G.nodes[cid]["name"], 24, UI.GREEN_DARK, true))
		qbox.add_child(UI.soft_button(M.tr("⬅️ Back to the farm"), M.ui_modal._close_modal, true, 18))
		M.ui_modal.call_deferred("_fit_modal")
		return
	var q: Dictionary = qs[idx]
	qbox.add_child(UI.label((M.tr("📚 Review: ") + G.nodes[q["card"]]["name"]) if q["review"] else M.tr("Question %d") % (idx + 1), 15, UI.MUTED))
	var inner := UI.vbox(8)
	qbox.add_child(inner)
	M.ui_quiz._question(inner, q, _card_answered.bind(cid, qs, idx, qbox, acc))

func _card_answered(first_try: bool, cid: String, qs: Array, idx: int, qbox: VBoxContainer, acc: Dictionary) -> void:
	G.record_card_answer(qs[idx], first_try)
	if not first_try and not qs[idx]["review"]: acc["all_first"] = false
	var nb := UI.button(M.tr("Next ▶") if idx + 1 < qs.size() else M.tr("Finish ▶"), _card_q.bind(cid, qs, idx + 1, qbox, acc), true, UI.GREEN, 19)
	nb.custom_minimum_size = Vector2(0, 52)
	qbox.add_child(nb)
	M.ui_modal.call_deferred("_fit_modal")
