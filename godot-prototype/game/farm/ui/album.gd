extends RefCounted
class_name FarmUiAlbum
## The album: pets, friends, postcards, perks and golden acorns.

const UI = preload("res://kits/ui/ui.gd")
const Art = preload("res://kits/ui/art.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

# ------------------------------------------------------------------ quest book, album, log

func sheet_album() -> void:
	M.widgets.section(tr("🐾 Pets"))
	M.home.part_pets()
	M.widgets.section(tr("🖼️ Pictures"), tr("Every favour you do for a neighbour gives a picture."))
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
	M.widgets.section(tr("🏅 Sum medals"), tr("🥉 level passed · 🥈 every task quick · 🥇 still quick a week later · 🏆 a whole section silver · 👑 all gold"))
	for cs in G.math.overview(G.learn_record()):
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
					fl.add_child(medal_tile("🥇" if lv["gold"] else ("🥈" if lv["silver"] else "🥉"), lv, false))
				elif lv["current"] and not next_shown:
					fl.add_child(medal_tile("🥉", lv, true))
					next_shown = true
			if fl.get_child_count() > 0: M.content.add_child(fl)
	var acorns: Array = G.meta.get("acorns", {}).get("list", [])
	M.widgets.section(tr("🌰 Golden acorns: %d / %d") % [G.S["acorns"].size(), acorns.size()], tr("Each one gives +3 energy max for good. They hide in different places."))
	var hidden_shown := false
	for a in acorns:
		if G.S["acorns"].has(a["id"]): M.content.add_child(UI.label("🌰 " + str(a["name"]), 17))
		elif not hidden_shown:
			M.content.add_child(UI.label(tr("❔ The next one is still hidden somewhere…"), 17, UI.MUTED))
			hidden_shown = true
	var fr: Array = G.rewards.friends()
	M.widgets.section(tr("🤝 Friends: %d") % fr.size(), tr("The people you helped. When they hear of your successes, they send postcards with a gift."))
	if fr.is_empty(): M.content.add_child(UI.label(tr("No friends yet — help a neighbour (📖 Quest book)!"), 16, UI.MUTED, true))
	else:
		var ff := HFlowContainer.new()
		ff.add_theme_constant_override("h_separation", 6)
		ff.add_theme_constant_override("v_separation", 6)
		for f in fr: ff.add_child(UI.pill("%s %s" % [f["emoji"], f["name"]], 15))
		M.content.add_child(ff)
	var pcs: Array = G.S.get("postcards", [])
	if not pcs.is_empty():
		M.widgets.section(tr("💌 Postcards: %d") % pcs.size())
		for i in range(pcs.size() - 1, -1, -1): M.content.add_child(M.gifts.postcard(pcs[i], true))
	M.widgets.section(tr("✨ Perks"), tr("Little extras for favours and achievements. Tap to switch one on or off."))
	var pg := M.widgets.grid()
	M.content.add_child(pg)
	var next_perk := false      # only the next perk to earn is shown, as a surprise
	for p in G.meta.get("perks", {}).get("list", []):
		var pid: String = p["id"]
		if G.rewards.perk_owned(pid):
			var on: bool = G.rewards.perk_on(pid)
			var pv := M.widgets.tile(null, str(p.get("emoji", "✨")), "%s\n%s\n🏅 %s" % [p["name"], p.get("desc", ""), perk_reason(p)], Color("eef6e4") if on else Color("f1ede4"))
			if on: pv.add_child(UI.button(tr("✅ On"), G.rewards.toggle_perk.bind(pid), true, UI.GREEN, 16))
			else: pv.add_child(UI.soft_button(tr("💤 Off — switch on"), G.rewards.toggle_perk.bind(pid), true, 15))
			pg.add_child(pv.get_meta("panel"))
		elif not next_perk:
			var lv := M.widgets.tile(null, "❔", tr("Next perk\n") + _perk_hint(p), Color("f1ede4"))
			pg.add_child(lv.get_meta("panel"))
			next_perk = true
	M.widgets.section(tr("🎁 Gifts from postcards"), tr("%d gifts can work at the same time; the others rest here until you swap them in.") % G.rewards.gift_max())
	var gg := M.widgets.grid()
	M.content.add_child(gg)
	for gid in G.S["gift_owned"]:
		var c: Dictionary = G.rewards.gift_card(gid)
		var on: bool = G.rewards.gift_is_active(gid)
		var v := M.widgets.tile(null, str(c.get("emoji", "🎁")), "%s\n%s" % [c["name"], c.get("desc", "")], Color("eef6e4") if on else Color("f1ede4"))
		if on: v.add_child(UI.button(tr("✅ Working"), G.rewards.toggle_gift.bind(gid), true, UI.GREEN, 16))
		else: v.add_child(UI.soft_button(tr("💤 Resting — use it"), G.rewards.toggle_gift.bind(gid), true, 15))
		gg.add_child(v.get_meta("panel"))

## A big medal with the level's name under it; next = the medal still to win (faint).
func medal_tile(md: String, lv: Dictionary, next: bool) -> Control:
	var v := UI.vbox(0)
	v.custom_minimum_size = Vector2(112, 0)
	v.mouse_filter = Control.MOUSE_FILTER_PASS
	v.tooltip_text = tr("%s · class %s") % [lv["example"], str(lv["class"])]
	var big := UI.label(md, 48)
	big.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if next: big.modulate = Color(1, 1, 1, 0.35)
	v.add_child(big)
	var nm := UI.label((tr("Next: ") if next else "") + "%s %s" % [lv["emoji"], lv["name"]], 13, UI.MUTED if next else UI.INK, true)
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.custom_minimum_size = Vector2(112, 0)
	v.add_child(nm)
	return v

## Why a perk was given (the pop-up and the album), e.g. "You harvested 40 times!" or the favour that earned it.
func perk_reason(p: Dictionary) -> String:
	var w := str(p.get("when", ""))
	if w == "":
		for id in G.nodes:
			var q: Dictionary = G.nodes[id]
			if str(q.get("perk", "")) == str(p["id"]): return tr("A thank-you for helping: %s %s.") % [q.get("emoji", ""), q["name"]]
		return tr("A thank-you from a neighbour you helped.")
	var parts := w.split(">=")
	var n := parts[1] if parts.size() > 1 else ""
	match parts[0]:
		"rest_quick": return tr("You answered %s Rest sums quickly!") % n
		"medals": return tr("You won %s medals with the Rest sums!") % n
		"arith_level": return tr("You reached level %s of the Rest sums!") % n
		"sold_kinds": return tr("You sold %s different things!") % n
		"harvests": return tr("You harvested %s times!") % n
		"seasons": return tr("You lived through %s seasons!") % n
		"cards": return tr("You learned %s knowledge cards!") % n
		"sidequests": return tr("You helped %s neighbours!") % n
	return tr("You earned it by playing!")

## How a perk not yet owned is earned (shown in the album).
func _perk_hint(p: Dictionary) -> String:
	var w := str(p.get("when", ""))
	if w == "": return tr("A thank-you from a neighbour you help.")
	var parts := w.split(">=")
	var n := parts[1] if parts.size() > 1 else ""
	match parts[0]:
		"rest_quick": return tr("Answer %s Rest sums quickly.") % n
		"medals": return tr("Win %s medals with the Rest sums.") % n
		"arith_level": return tr("Reach level %s of the Rest sums.") % n
		"sold_kinds": return tr("Sell %s different things.") % n
		"harvests": return tr("Harvest %s times.") % n
		"seasons": return tr("Live through %s seasons.") % n
		"cards": return tr("Learn %s knowledge cards.") % n
		"sidequests": return tr("Help %s neighbours.") % n
	return tr("Keep playing!")
