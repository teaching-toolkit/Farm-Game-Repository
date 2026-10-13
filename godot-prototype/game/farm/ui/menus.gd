extends RefCounted
## Quest book, album and log.
## Split out of main.gd in R5 (12 Oct 2026). M = the main screen (main.gd: builds the screen and holds its nodes and
## state), G = Game (the rules). Other parts of the screen are reached as M.ui_<part>.
const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")

var M
var G

func _sheet_goals() -> void:
	var main := []
	var opt := []
	var side := []
	var soon := []
	for id in G.nodes:
		var n: Dictionary = G.nodes[id]
		var t: String = n["type"]
		if t in ["knowledge", "book", "polish", "animal", "crop", "merchant"]: continue
		if G.done(id) or G.satisfied(id) or not M.ui_map._in_chapter(id): continue
		var mr: Array = G.missing_reqs(id)
		if mr.is_empty():
			if t == "sidequest": side.append(id)
			elif n.get("optional", false): opt.append(id)
			else: main.append(id)
		elif mr.size() == 1 and not n.get("optional", false) and t != "sidequest":
			soon.append([id, mr[0]])
	var key := func(a): return int(G.nodes[a].get("chapter", 1)) * 10 + (0 if G.can_unlock(a)["ok"] else 1)
	main.sort_custom(func(a, b): return key.call(a) < key.call(b))
	opt.sort_custom(func(a, b): return key.call(a) < key.call(b))
	var few: bool = G.friends().size() < 2
	if few and not side.is_empty():
		M.ui_widgets._section(M.tr("⭐ Recommended: help a neighbour"), M.tr("People you help become your friends — and friends send postcards with a gift when they hear of your successes."))
		for id in side: M.content.add_child(M.ui_widgets._node_row(id, true, true))
	M.ui_widgets._section(M.tr("🎯 Next goals"), M.tr("Build, make and deliver these to move the story on. Green costs you have, red ones you still need. 📍 shows where."))
	if main.is_empty(): M.content.add_child(UI.label(M.tr("Nothing open right now — learn a new card in the 📦 library, or keep farming."), 16, UI.MUTED, true))
	for id in main: M.content.add_child(M.ui_widgets._node_row(id, true, true))
	if not side.is_empty() and not few:
		M.ui_widgets._section(M.tr("🤝 Favours for neighbours"), M.tr("Friends send postcards with gifts."))
		for id in side: M.content.add_child(M.ui_widgets._node_row(id, true, true))
	if not opt.is_empty():
		M.ui_widgets._section(M.tr("🧰 Upgrades (optional)"), M.tr("Never required — they make work cheaper for good."))
		for id in opt: M.content.add_child(M.ui_widgets._node_row(id, true, true))
	if not soon.is_empty():
		M.ui_widgets._section(M.tr("🔒 Coming up"), M.tr("One thing missing for each of these."))
		for pair in soon.slice(0, 8):
			var n2: Dictionary = G.nodes[pair[0]]
			M.content.add_child(UI.label(M.tr("%s %s — needs %s") % [n2.get("emoji", ""), n2["name"], pair[1]], 15, UI.MUTED, true))

func _sheet_album() -> void:
	M.ui_widgets._section(tr("🐾 Pets"))
	M.ui_pets._part_pets()
	M.ui_widgets._section(tr("🖼️ Pictures"), tr("Every favour you do for a neighbour gives a picture."))
	for a in G.S["album"]:
		var pc := UI.card(Color("fff6e0"))
		var av := UI.vbox(4)
		pc.add_child(av)
		var atex: Texture2D = Art.first("album", [str(a.get("id", ""))])     # assets/album/<side quest>.png when drawn
		if atex:
			var tr := TextureRect.new()
			tr.texture = atex
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tr.custom_minimum_size = Vector2(0, 180)
			av.add_child(tr)
		av.add_child(UI.label("%s  %s" % [a.get("emoji", "🖼️"), a["text"]], 17, UI.INK, true))
		M.content.add_child(pc)
	M.ui_widgets._section(tr("🏅 Sum medals"), tr("🥉 level passed · 🥈 every task quick · 🥇 still quick a week later · 🏆 a whole section silver · 👑 all gold"))
	for cs in G.math.overview(G._learn()):
		if not cs["active"]: continue
		M.content.add_child(UI.label("%s %s — %s" % [cs["emoji"], cs["name"], cs["rank"]], 19, UI.INK, true))
		for ss in cs["sections"]:
			# the medals won so far, and only the next one to win (the level being learned now)
			M.content.add_child(UI.label("%s %s%s%s" % [ss["emoji"], ss["name"], "  🏆" if ss["trophy"] else "", " 👑" if ss["crown"] else ""], 16, UI.MUTED))
			var fl := HFlowContainer.new()
			fl.add_theme_constant_override("h_separation", 10)
			fl.add_theme_constant_override("v_separation", 10)
			var next_shown := false
			for lv in ss["levels"]:
				if lv["bronze"]:
					fl.add_child(_medal_tile("🥇" if lv["gold"] else ("🥈" if lv["silver"] else "🥉"), lv, false))
				elif lv["current"] and not next_shown:
					fl.add_child(_medal_tile("🥉", lv, true))
					next_shown = true
			if fl.get_child_count() > 0: M.content.add_child(fl)
	var acorns: Array = G.meta.get("acorns", {}).get("list", [])
	M.ui_widgets._section(tr("🌰 Golden acorns: %d / %d") % [G.S["acorns"].size(), acorns.size()], tr("Each one gives +3 energy max for good. They hide in different places."))
	var hidden_shown := false
	for a in acorns:
		if G.S["acorns"].has(a["id"]): M.content.add_child(UI.label("🌰 " + str(a["name"]), 17))
		elif not hidden_shown:
			M.content.add_child(UI.label(tr("❔ The next one is still hidden somewhere…"), 17, UI.MUTED))
			hidden_shown = true
	var fr: Array = G.friends()
	M.ui_widgets._section(tr("🤝 Friends: %d") % fr.size(), tr("The people you helped. When they hear of your successes, they send postcards with a gift."))
	if fr.is_empty(): M.content.add_child(UI.label(tr("No friends yet — help a neighbour (📖 Quest book)!"), 16, UI.MUTED, true))
	else:
		var ff := HFlowContainer.new()
		ff.add_theme_constant_override("h_separation", 6)
		ff.add_theme_constant_override("v_separation", 6)
		for f in fr: ff.add_child(UI.pill("%s %s" % [f["emoji"], f["name"]], 15))
		M.content.add_child(ff)
	var pcs: Array = G.S.get("postcards", [])
	if not pcs.is_empty():
		M.ui_widgets._section(tr("💌 Postcards: %d") % pcs.size())
		for i in range(pcs.size() - 1, -1, -1): M.content.add_child(M.ui_postcards._postcard(pcs[i], true))
	M.ui_widgets._section(tr("✨ Perks"), tr("Little extras for favours and achievements. Tap to switch one on or off."))
	var pg = M.ui_place._grid()
	M.content.add_child(pg)
	var next_perk := false      # only the next perk to earn is shown, as a surprise
	for p in G.meta.get("perks", {}).get("list", []):
		var pid: String = p["id"]
		if G.perk_owned(pid):
			var on: bool = G.perk_on(pid)
			var pv = M.ui_place._tile(null, str(p.get("emoji", "✨")), "%s\n%s\n🏅 %s" % [p["name"], p.get("desc", ""), _perk_reason(p)], Color("eef6e4") if on else Color("f1ede4"))
			if on: pv.add_child(UI.button(tr("✅ On"), G.toggle_perk.bind(pid), true, UI.GREEN, 16))
			else: pv.add_child(UI.soft_button(tr("💤 Off — switch on"), G.toggle_perk.bind(pid), true, 15))
			pg.add_child(pv.get_meta("panel"))
		elif not next_perk:
			var lv = M.ui_place._tile(null, "❔", tr("Next perk\n") + _perk_hint(p), Color("f1ede4"))
			pg.add_child(lv.get_meta("panel"))
			next_perk = true
	M.ui_widgets._section(tr("🎁 Gifts from postcards"), tr("%d gifts can work at the same time; the others rest here until you swap them in.") % G.gift_max())
	var gg = M.ui_place._grid()
	M.content.add_child(gg)
	for gid in G.S["gift_owned"]:
		var c: Dictionary = G.gift_card(gid)
		var on: bool = G.gift_is_active(gid)
		var v = M.ui_place._tile(null, str(c.get("emoji", "🎁")), "%s\n%s" % [c["name"], c.get("desc", "")], Color("eef6e4") if on else Color("f1ede4"))
		if on: v.add_child(UI.button(tr("✅ Working"), G.toggle_gift.bind(gid), true, UI.GREEN, 16))
		else: v.add_child(UI.soft_button(tr("💤 Resting — use it"), G.toggle_gift.bind(gid), true, 15))
		gg.add_child(v.get_meta("panel"))

## A big medal with the level's name under it; next = the medal still to win (faint).
func _medal_tile(md: String, lv: Dictionary, next: bool) -> Control:
	var v := UI.vbox(0)
	v.custom_minimum_size = Vector2(112, 0)
	v.mouse_filter = Control.MOUSE_FILTER_PASS
	v.tooltip_text = M.tr("%s · class %s") % [lv["example"], str(lv["class"])]
	var big := UI.label(md, 48)
	big.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if next: big.modulate = Color(1, 1, 1, 0.35)
	v.add_child(big)
	var nm := UI.label((M.tr("Next: ") if next else "") + "%s %s" % [lv["emoji"], lv["name"]], 13, UI.MUTED if next else UI.INK, true)
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.custom_minimum_size = Vector2(112, 0)
	v.add_child(nm)
	return v

## Why a perk was given (the pop-up and the album), e.g. "You harvested 40 times!" or the favour that earned it.
func _perk_reason(p: Dictionary) -> String:
	var w := str(p.get("when", ""))
	if w == "":
		for id in G.nodes:
			var q: Dictionary = G.nodes[id]
			if str(q.get("perk", "")) == str(p["id"]): return M.tr("A thank-you for helping: %s %s.") % [q.get("emoji", ""), q["name"]]
		return M.tr("A thank-you from a neighbour you helped.")
	var parts := w.split(">=")
	var n := parts[1] if parts.size() > 1 else ""
	match parts[0]:
		"rest_quick": return M.tr("You answered %s Rest sums quickly!") % n
		"medals": return M.tr("You won %s medals with the Rest sums!") % n
		"arith_level": return M.tr("You reached level %s of the Rest sums!") % n
		"sold_kinds": return M.tr("You sold %s different things!") % n
		"harvests": return M.tr("You harvested %s times!") % n
		"seasons": return M.tr("You lived through %s seasons!") % n
		"cards": return M.tr("You learned %s knowledge cards!") % n
		"sidequests": return M.tr("You helped %s neighbours!") % n
	return M.tr("You earned it by playing!")

## How a perk not yet owned is earned (shown in the album).
func _perk_hint(p: Dictionary) -> String:
	var w := str(p.get("when", ""))
	if w == "": return M.tr("A thank-you from a neighbour you help.")
	var parts := w.split(">=")
	var n := parts[1] if parts.size() > 1 else ""
	match parts[0]:
		"rest_quick": return M.tr("Answer %s Rest sums quickly.") % n
		"medals": return M.tr("Win %s medals with the Rest sums.") % n
		"arith_level": return M.tr("Reach level %s of the Rest sums.") % n
		"sold_kinds": return M.tr("Sell %s different things.") % n
		"harvests": return M.tr("Harvest %s times.") % n
		"seasons": return M.tr("Live through %s seasons.") % n
		"cards": return M.tr("Learn %s knowledge cards.") % n
		"sidequests": return M.tr("Help %s neighbours.") % n
	return M.tr("Keep playing!")

func _sheet_log() -> void:
	var lines: Array = G.S["log"].duplicate()
	lines.reverse()
	for t in lines: M.content.add_child(UI.label(str(t), 16, UI.INK, true))
