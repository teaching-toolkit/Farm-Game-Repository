extends RefCounted
class_name FarmUiQuestLog
## The quest book (everything you can do next) and the log of what happened.

const UI = preload("res://kits/ui/ui.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ gift cards, names, menu, welcome

func open_log() -> void:
	M.modals.close_modal()
	M.sheets.open_sheet("log")

# ------------------------------------------------------------------ quest book, album, log

func sheet_goals() -> void:
	var main := []
	var opt := []
	var side := []
	var soon := []
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		var t: String = n["type"]
		if t in ["knowledge", "book", "polish", "animal", "crop", "merchant"]: continue
		if G.done(id) or G.satisfied(id) or not M.mapview.in_chapter(id): continue
		var mr: Array = G.progression.missing_reqs(id)
		if mr.is_empty():
			if t == "sidequest": side.append(id)
			elif n.get("optional", false): opt.append(id)
			else: main.append(id)
		elif mr.size() == 1 and not n.get("optional", false) and t != "sidequest":
			soon.append([id, mr[0]])
	var key := func(a): return int(G.nodes[a].get("chapter", 1)) * 10 + (0 if G.progression.can_unlock(a)["ok"] else 1)
	main.sort_custom(func(a, b): return key.call(a) < key.call(b))
	opt.sort_custom(func(a, b): return key.call(a) < key.call(b))
	var few: bool = G.rewards.friends().size() < 2
	if few and not side.is_empty():
		M.widgets.section(tr("⭐ Recommended: help a neighbour"), tr("People you help become your friends — and friends send postcards with a gift when they hear of your successes."))
		for id in side: M.content.add_child(M.widgets.node_row(id, true, true))
	M.widgets.section(tr("🎯 Next goals"), tr("Build, make and deliver these to move the story on. Green costs you have, red ones you still need. 📍 shows where."))
	if main.is_empty(): M.content.add_child(UI.label(tr("Nothing open right now — learn a new card in the 📦 library, or keep farming."), 16, UI.MUTED, true))
	for id in main: M.content.add_child(M.widgets.node_row(id, true, true))
	if not side.is_empty() and not few:
		M.widgets.section(tr("🤝 Favours for neighbours"), tr("Friends send postcards with gifts."))
		for id in side: M.content.add_child(M.widgets.node_row(id, true, true))
	if not opt.is_empty():
		M.widgets.section(tr("🧰 Upgrades (optional)"), tr("Never required — they make work cheaper for good."))
		for id in opt: M.content.add_child(M.widgets.node_row(id, true, true))
	if not soon.is_empty():
		M.widgets.section(tr("🔒 Coming up"), tr("One thing missing for each of these."))
		for pair in soon.slice(0, 8):
			var n2: Dictionary = G.nodes[pair[0]]
			M.content.add_child(UI.label(tr("%s %s — needs %s") % [n2.get("emoji", ""), n2["name"], pair[1]], 15, UI.MUTED, true))

func sheet_log() -> void:
	var lines: Array = G.S["log"].duplicate()
	lines.reverse()
	for t in lines: M.content.add_child(UI.label(str(t), 16, UI.INK, true))
