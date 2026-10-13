extends RefCounted
## Test and screenshot flags for the main screen (everything after `--` on the command line), kept out of main.gd.
## The full list with examples: godot-prototype/README.md. Rules-engine flags (--seed, --lang) are read by Game itself.
## main.gd calls DevFlags.apply(self, G) once in _ready; flags that open something wait until the screen is built.

static func apply(main, G) -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot="): main.shot_path = a.substr(7)
		elif a.begins_with("--demo="):
			for _i in range(int(a.substr(7))): G.cheat_max()
		elif a == "--quiz": main.call_deferred("_show_time_quiz")
		elif a.begins_with("--qid="): main.call_deferred("_show_quiz_id", a.substr(6))     # screenshots: one Time Quiz question
		elif a == "--rest": main.call_deferred("_show_rest")
		elif a.begins_with("--shotframes="): main.shot_at = int(a.substr(13))
		elif a.begins_with("--act="): main.call_deferred("_test_act", a.substr(6))   # screenshots: --act=weed@patch0, --act=cook@kitchen
		elif a == "--restgo": main.call_deferred("_rest_go")              # screenshots: past the Rest start page (after --rest)
		elif a == "--menu": main.call_deferred("_show_menu")            # screenshots: ⚙️ Settings
		elif a == "--grownup": main._grownup_until = 1e12                # screenshots: grown-up settings open
		elif a == "--password": main.call_deferred("_ask_password")     # screenshots: the grown-up password box
		elif a.begins_with("--card="): main.call_deferred("_show_card", a.substr(7))
		elif a.begins_with("--patch="): main.call_deferred("_on_patch", "field", int(a.substr(8)))
		elif a.begins_with("--pests="): G.S["pests"] = float(a.substr(8))
		elif a.begins_with("--water="): G.S["water"] = float(a.substr(8))   # screenshots: carried water
		elif a.begins_with("--timestep="): G.S["step"] = int(a.substr(11))   # e.g. 95 = winter (screenshots only)
		elif a.begins_with("--stepat="): main.step_at = int(a.substr(9))
		elif a.begins_with("--sheet="): main.call_deferred("_open_sheet", a.substr(8))
		elif a.begins_with("--spot="): main.call_deferred("_open_spot", a.substr(7))
		elif a.begins_with("--scroll="): main.call_deferred("_scroll_to", float(a.substr(9)), false)
		elif a == "--goal": main.call_deferred("_goal_pressed")
		elif a == "--newgame": G.reset_game()      # screenshots of the very start
		elif a.begins_with("--player="): G.set_player(a.substr(9))
		elif a.begins_with("--celebrate="): main.call_deferred("_celebrate", a.substr(12))     # screenshots of the big pop-up
		elif a == "--postcard":                    # screenshots: a friend (Granny Maud) and her postcard
			G.S["unlocked"]["sq_lost_goat"] = true
			G._dirty()
			G.S["gift_pending"].clear()
			G.S["postcards"] = []
			G._offer_gift(main.tr("your new bunny"))
		elif a.begins_with("--perks="):            # screenshots: --perks=all or --perks=perk_rainbow,perk_breeze
			for p in G.meta.get("perks", {}).get("list", []):
				if a == "--perks=all" or a.substr(8).split(",").has(p["id"]): G.perks()[p["id"]] = true
		elif a == "--rainbow": main.call_deferred("_rainbow_now")
		elif a.begins_with("--load="):             # screenshots: start from a saved farm (--load=res://tests/fixtures/ch3-seed1.json)
			G.load_game(a.substr(7))
			G.changed.emit()
		elif a.begins_with("--unlock="):           # screenshots: pretend these are done (--unlock=workbench,stone_axe)
			for id in a.substr(9).split(","): G.S["unlocked"][id] = true
			G._dirty()
		elif a.begins_with("--give="):             # screenshots: --give=rope:2,stick:5
			for kv in a.substr(7).split(","):
				var parts: PackedStringArray = kv.split(":")
				G.add_item(parts[0], float(parts[1]) if parts.size() > 1 else 1.0, true)
		elif a == "--built":                       # screenshots: pretend house, barn and workshop stand
			for b in ["cottage", "barn_1", "workshop_1"]: G.S["unlocked"][b] = true
			G._dirty()
