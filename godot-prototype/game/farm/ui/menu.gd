extends RefCounted
class_name FarmUiMenu
## Settings: language, sound, credits, the grown-up part (password, review share, learning record), reset.

const UI = preload("res://kits/ui/ui.gd")


var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)

func _init(main: FarmMain) -> void:
	M = main
	G = main.G

const GROWNUP_SECONDS := 300.0

var grownup_until := 0.0

# ------------------------------------------------------------------ gift cards, names, menu, welcome

func show_menu() -> void:
	var box := M.modals.open_modal(tr("⚙️ Settings"))
	if G.player != "": box.add_child(UI.soft_button(tr("👤 %s — someone else is playing") % G.player, M.welcome.ask_player, true, 18))
	else: box.add_child(UI.soft_button(tr("👤 Who is playing?"), M.welcome.ask_player, true, 18))
	# the language of this iPad: the whole game (interface, farm, cards, quiz packs and sums) switches
	var lr := HFlowContainer.new()
	lr.add_theme_constant_override("h_separation", 8)
	lr.add_child(UI.label("🌍", 24))
	var langs: Dictionary = I18n.languages()
	for code in langs:
		var nm := "%s %s" % [langs[code].get("flag", ""), langs[code].get("name", code)]
		if code == I18n.lang: lr.add_child(UI.button("✔ " + nm, Callable(), true, UI.GREEN, 17))
		else: lr.add_child(UI.soft_button(nm, _set_language.bind(code), true, 17))
	box.add_child(lr)
	# music and sound effects, each on or off (this device)
	var sr := HFlowContainer.new()
	sr.add_theme_constant_override("h_separation", 8)
	sr.add_child(UI.soft_button((tr("🎵 Music: on") if Sound.music_on else tr("🔇 Music: off")), _toggle_music, true, 17))
	sr.add_child(UI.soft_button((tr("🔔 Sounds: on") if Sound.sfx_on else tr("🔕 Sounds: off")), _toggle_sfx, true, 17))
	sr.add_child(UI.soft_button(tr("🎼 Credits"), _show_credits, true, 17))
	box.add_child(sr)
	box.add_child(UI.soft_button(tr("📜 What happened (log)"), M.questlog.open_log, true, 18))
	box.add_child(UI.label(_version_text(), 14, UI.MUTED, true))
	if not grownup_open():
		box.add_child(UI.button(tr("🔒 Grown-up settings"), ask_password, true, UI.BLUE, 18))
		return
	box.add_child(UI.label(tr("🔓 Grown-up settings (open for a few minutes)"), 17, UI.MUTED, true))
	_part_review_share(box)
	box.add_child(UI.label(tr("Question packs and the size of Rest sums are set in data/settings.json and data/quiz_packs/."), 15, UI.MUTED, true))
	box.add_child(UI.soft_button(tr("📊 Learning record (sums and questions)"), _show_learning, true, 18))
	box.add_child(UI.soft_button(tr("%s 🎚️ Prices fit my farm (dynamic difficulty)") % ("✅" if G.pace.flex_on() else "⬜"), M.stations.toggle_flex, true, 16))
	box.add_child(UI.button(tr("🗑️ Start a new game (deletes the save)"), _reset, true, UI.RED, 17))
	box.add_child(UI.soft_button(tr("🔒 Lock again"), _lock_grownup, true, 16))

func _toggle_music() -> void:
	Sound.set_music(not Sound.music_on)
	if Sound.music_on: Sound.music("farm", G.seasons.season())
	M.modals.close_modal()
	show_menu()

func _toggle_sfx() -> void:
	Sound.set_sfx(not Sound.sfx_on)
	M.modals.close_modal()
	show_menu()

## Who made the music and the sounds (data/sounds.json "credits", filled by tools/import_sounds.py).
func _show_credits() -> void:
	var box := M.modals.open_modal(tr("🎼 Credits"))
	var cr: Array = Sound.credits()
	if cr.is_empty():
		box.add_child(UI.label(tr("No sound files yet: the little sounds you hear are made by the game itself."), 17, UI.MUTED, true))
	for c in cr:
		var pc := UI.card()
		var v := UI.vbox(2)
		pc.add_child(v)
		v.add_child(UI.label(str(c.get("what", "")), 17, UI.INK, true))
		v.add_child(UI.label("%s · %s" % [c.get("author", ""), c.get("licence", "")], 15, UI.MUTED, true))
		if str(c.get("source", "")) != "": v.add_child(UI.label(str(c["source"]), 14, UI.BLUE, true))
		box.add_child(pc)
	box.add_child(UI.label(tr("Fonts: Andika (SIL International) and Noto Color Emoji (Google), both under the SIL Open Font License."), 15, UI.MUTED, true))
	box.add_child(UI.label(_version_text(), 14, UI.MUTED, true))
	box.add_child(UI.soft_button(tr("⬅️ Back"), func(): M.modals.close_modal(); show_menu(), true, 16))

## The game's name and version (project.godot) and the data's version, e.g. "Hazelwood Harvest · version 0.9.0 · data 0.8".
## Shown in ⚙️ Settings and the credits, so the parent can see which build the iPad has loaded.
func _version_text() -> String:
	return tr("%s · version %s · data %s") % [str(ProjectSettings.get_setting("application/config/name", "")),
		str(ProjectSettings.get_setting("application/config/version", "?")), str(G.meta.get("version", "?"))]

## Switches the language and builds the screen again in it (the farm stays as it is).
func _set_language(code: String) -> void:
	G.set_language(code)
	M.get_tree().reload_current_scene()

func grownup_open() -> bool:
	return Time.get_ticks_msec() / 1000.0 < grownup_until

func _lock_grownup() -> void:
	grownup_until = 0.0
	M.modals.close_modal()
	show_menu()

func ask_password() -> void:
	var box := M.modals.open_modal(tr("🔒 For grown-ups"))
	box.add_child(UI.label(tr("Please type the password."), 18, UI.INK, true))
	var le := LineEdit.new()
	le.placeholder_text = tr("Password")
	le.custom_minimum_size = Vector2(0, 58)
	le.add_theme_font_size_override("font_size", 26)
	box.add_child(le)
	var hint := str(G.settings.get("parentHint", ""))
	if hint != "": box.add_child(UI.label(tr("Hint: ") + hint, 16, UI.MUTED, true))
	var msg := UI.label("", 16, UI.RED, true)
	var ok := UI.button(tr("Open 🔓"), _check_password.bind(le, msg), true, UI.GREEN, 22)
	ok.custom_minimum_size = Vector2(0, 58)
	le.text_submitted.connect(func(_t): _check_password(le, msg))
	box.add_child(ok)
	box.add_child(msg)
	box.add_child(UI.soft_button(tr("⬅️ Back"), func(): M.modals.close_modal(); show_menu(), true, 16))
	le.grab_focus.call_deferred()

func _check_password(le: LineEdit, msg: Label) -> void:
	if password_ok(le.text):
		grownup_until = Time.get_ticks_msec() / 1000.0 + GROWNUP_SECONDS
		M.modals.close_modal()
		show_menu()
	else:
		msg.text = tr("That's not it. Try again.")
		le.text = ""

## Not case-sensitive, spaces at the ends ignored (easy to type on an iPad).
func password_ok(t: String) -> bool:
	return t.strip_edges().to_lower() == str(G.settings.get("parentPassword", "farm")).strip_edges().to_lower()

## Settings: where the Time Quiz questions come from — reviews of the cards read, or the parent's packs (5% steps).
func _part_review_share(box: Control) -> void:
	var pc := UI.card(Color("f3f7ea"))
	var v := UI.vbox(4)
	pc.add_child(v)
	v.add_child(UI.label(tr("❓ Where the Time Quiz questions come from"), 18, UI.INK, true))
	var pct := int(round(G.pace.review_share() * 100.0))
	var row := UI.hbox(8)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_child(UI.soft_button("➖", _change_review_share.bind(-0.05), pct > 0, 20))
	var bar := UI.bar(G.pace.review_share(), 220, 16, UI.BLUE)
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(bar)
	row.add_child(UI.soft_button("➕", _change_review_share.bind(0.05), pct < 100, 20))
	v.add_child(row)
	v.add_child(UI.label(tr("📚 %d%% from the books read   ·   📦 %d%% from your question packs") % [pct, 100 - pct], 16, UI.INK, true))
	v.add_child(UI.label(tr("A book question only comes when a card is due for review; otherwise a pack question takes its place."), 14, UI.MUTED, true))
	box.add_child(pc)

func _change_review_share(d: float) -> void:
	G.pace.set_review_share(G.pace.review_share() + d)
	M.modals.close_modal()
	show_menu()

## For parents: the player's learning record — a plain JSON file (kits/learn/learner.gd) that can be opened, copied,
## edited (kits/learn/tools/learning-editor.html) and pasted back; and which maths categories are practised.
func _show_learning() -> void:
	var box := M.modals.open_modal(tr("📊 Learning record"))
	var L: Dictionary = G.learn_record()
	var r: Dictionary = G.needs.math_record()
	var qs: Dictionary = G.quiz.stats(L)
	box.add_child(UI.label(tr("%s — Rest sums: %d answered, %d known by heart, %d medals.  Time Quiz: %d questions seen, %d known.") % [
		G.player if G.player != "" else tr("(no name yet)"), int(r.get("n", 0)), G.math.known_count(L), G.math.medal_count(L), int(qs["seen"]), int(qs["known"])], 17, UI.INK, true))
	var folder: String = G.learner.folder()
	if folder != "":
		box.add_child(UI.label(tr("The file: ") + folder + "/learning.json", 14, UI.MUTED, true))
		box.add_child(UI.soft_button(tr("📂 Open the folder"), func(): OS.shell_open(folder), true, 17))
	box.add_child(UI.label(tr("Copy it out to look at it or change it (kits/learn/tools/learning-editor.html opens it), then paste it back in."), 15, UI.MUTED, true))
	box.add_child(UI.soft_button(tr("📋 Copy the record"), _copy_learning, true, 17))
	var te := TextEdit.new()
	te.placeholder_text = tr("Paste a learning record here …")
	te.custom_minimum_size = Vector2(0, 90)
	box.add_child(te)
	box.add_child(UI.soft_button(tr("📥 Use the pasted record"), _paste_learning.bind(te), true, 17))
	_section_in(box, tr("➕ What the Rest sums practise"))
	for cat in G.math.C.get("categories", []):
		var on: bool = r["active"].has(cat["id"])
		var b := UI.soft_button(tr("%s %s %s  (classes %s)") % ["✅" if on else "⬜", cat.get("emoji", ""), cat.get("name", ""), cat.get("classes", "")], _toggle_category.bind(str(cat["id"])), true, 17)
		box.add_child(b)
	M.modals.fit_modal.call_deferred()

func rainbow_now() -> void:
	M.map.rainbow()

func _copy_learning() -> void:
	DisplayServer.clipboard_set(G.learner.export_text())
	M.notes.toast(tr("📋 Copied."))

func _section_in(box: VBoxContainer, title: String) -> void:
	box.add_child(UI.label(title, 19, UI.INK, true))

func _paste_learning(te: TextEdit) -> void:
	if G.learner.import_text(te.text):
		G.L = G.learner.data
		M.notes.toast(tr("📥 Learning record loaded."))
		_show_learning()
	else: M.notes.toast(tr("❌ That is not a learning record."))

func _toggle_category(id: String) -> void:
	var r: Dictionary = G.needs.math_record()
	if r["active"].has(id):
		if r["active"].size() > 1: r["active"].erase(id)
	else: r["active"].append(id)
	G.save_learning()
	_show_learning()

func _reset() -> void:
	G.reset_game()
	M.field_idx = 0
	for f in range(M.map.fields.size()): M.map.fields[f].show_area("field", f)
	M.sheets.close_sheet()
	M.modals.close_modal()
	M.welcome.show_welcome()
