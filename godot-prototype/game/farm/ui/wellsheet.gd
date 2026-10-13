extends RefCounted
class_name FarmUiWell
## The wellbeing dashboard (TODO L3, L4): the farmer's face, and one row per parameter once the card of the book “Body and mind” about it has been learned.
## Each row: a bar, whether it is rising or sinking, and what lifts it. Before the cards: the face and a hint to read.

const UI = preload("res://kits/ui/ui.gd")

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

## The card that opens a parameter's row (its node says `wellRow`).
func card_of(p: String) -> String:
	for cid in G.card_ids:
		if str(G.nodes[cid].get("wellRow", "")) == p: return cid
	return ""

func row_open(p: String) -> bool:
	var cid := card_of(p)
	return cid == "" or G.done(cid)

func sheet_well() -> void:
	var head := UI.hbox(14)
	head.add_child(UI.label(G.well.face(), 64))
	var hv := UI.vbox(4)
	hv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hv.add_child(UI.label(tr("How you feel"), 20, UI.INK, true))
	hv.add_child(UI.bar(G.well.overall(), 240, 14, UI.GREEN if G.well.overall() >= 0.4 else UI.RED))
	head.add_child(hv)
	M.content.add_child(head)
	var net: float = G.well.boost() - G.well.drain()
	if absf(net) >= 0.5:
		M.content.add_child(UI.label(tr("⚡ %+d each question") % int(round(net)), 17, UI.GREEN_DARK if net > 0.0 else UI.RED, true))
	var shut := 0
	for p in G.well.params():
		if not row_open(p): shut += 1; continue
		var sp: Dictionary = G.well.data()["params"][p]
		var row := UI.card(Color("f6efe0"))
		var rv := UI.vbox(3)
		row.add_child(rv)
		var line := UI.hbox(8)
		line.add_child(UI.label("%s %s" % [sp["emoji"], tr(str(sp["name"]))], 19, UI.INK, true))
		var v: float = G.well.value(p)
		var t: float = G.well.target(p)
		line.add_child(UI.label("↑" if t > v + 0.005 else ("↓" if t < v - 0.005 else "="), 20, UI.GREEN_DARK if t > v + 0.005 else (UI.RED if t < v - 0.005 else UI.MUTED)))
		rv.add_child(line)
		rv.add_child(UI.bar(v, 240, 12, UI.GREEN if v >= 0.4 else UI.RED))
		rv.add_child(UI.label(tr(str(sp["hint"])), 15, UI.MUTED, true))
		M.content.add_child(row)
	if shut > 0:
		M.content.add_child(UI.label(tr("📖 The book “Body and mind” (from the book cart) tells you more: each card shows one more thing here."), 16, UI.MUTED, true))
