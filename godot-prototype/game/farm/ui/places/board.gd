extends RefCounted
## The notice board: little jobs.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")

var M
var G

func _part_jobs() -> void:
	M.ui_widgets._section(M.tr("📋 Little jobs"), M.tr("A few coins and a bit of luck for each."))
	for j in G.S["jobs"]:
		var h := UI.hbox(6)
		h.add_child(UI.label("• " + str(j["text"]), 17, UI.INK, true))
		h.add_child(UI.label("%d/%d" % [G.down(float(j["got"])), int(j["n"])], 17, UI.MUTED))
		M.content.add_child(h)
