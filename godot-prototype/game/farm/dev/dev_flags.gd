extends RefCounted
## Test and screenshot flags for the main screen (everything after `--` on the command line), kept out of main.gd.
## The full list with examples: godot-prototype/README.md. Rules-engine flags (--seed, --lang) are read by Game itself.
## main.gd calls DevFlags.apply(self, G) once in _ready; flags that open something wait until the screen is built.

static func apply(main, G) -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot="): main.shot_path = a.substr(7)
		elif a.begins_with("--demo="):
			for _i in range(int(a.substr(7))): G.cheat_max()
		elif a == "--quiz": main.timequiz.show_time_quiz.call_deferred()
		elif a.begins_with("--qid="): main.timequiz.show_quiz_id.call_deferred(a.substr(6))     # screenshots: one Time Quiz question
		elif a == "--rest": main.rest.show_rest.call_deferred()
		elif a.begins_with("--shotframes="): main.shot_at = int(a.substr(13))
		elif a.begins_with("--act="): main.feedback.test_act.call_deferred(a.substr(6))   # screenshots: --act=weed@patch0, --act=cook@kitchen
		elif a == "--restgo": main.rest.rest_go.call_deferred()              # screenshots: past the Rest start page (after --rest)
		elif a == "--menu": main.menu.show_menu.call_deferred()            # screenshots: ⚙️ Settings
		elif a == "--grownup": main.menu.grownup_until = 1e12                # screenshots: grown-up settings open
		elif a == "--password": main.menu.ask_password.call_deferred()     # screenshots: the grown-up password box
		elif a.begins_with("--card="): main.cards.show_card.call_deferred(a.substr(7))
		elif a.begins_with("--patch="): main.patches.on_patch.call_deferred("field", int(a.substr(8)))
		elif a.begins_with("--pests="): G.S["pests"] = float(a.substr(8))
		elif a.begins_with("--water="): G.S["water"] = float(a.substr(8))   # screenshots: carried water
		elif a.begins_with("--timestep="): G.S["step"] = int(a.substr(11))   # e.g. 95 = winter (screenshots only)
		elif a.begins_with("--stepat="): main.step_at = int(a.substr(9))
		elif a.begins_with("--sheet="): main.sheets.open_sheet.call_deferred(a.substr(8))
		elif a.begins_with("--spot="): main.sheets.open_spot.call_deferred(a.substr(7))
		elif a.begins_with("--scroll="): main.mapview.scroll_to.call_deferred(float(a.substr(9)), false)
		elif a == "--goal": main.goalbar.goal_pressed.call_deferred()
		elif a == "--newgame": G.reset_game()      # screenshots of the very start
		elif a.begins_with("--player="): G.set_player(a.substr(9))
		elif a.begins_with("--celebrate="): main.celebrations.celebrate.call_deferred(a.substr(12))     # screenshots of the big pop-up
		elif a == "--postcard":                    # screenshots: a friend (Granny Maud) and her postcard
			G.S["unlocked"]["sq_lost_goat"] = true
			G.invalidate_caps()
			G.S["gift_pending"].clear()
			G.S["postcards"] = []
			G.rewards.offer_gift(main.tr("your new bunny"))
		elif a.begins_with("--perks="):            # screenshots: --perks=all or --perks=perk_rainbow,perk_breeze
			for p in G.meta.get("perks", {}).get("list", []):
				if a == "--perks=all" or a.substr(8).split(",").has(p["id"]): G.rewards.perks()[p["id"]] = true
		elif a == "--rainbow": main.menu.rainbow_now.call_deferred()
		elif a.begins_with("--sheetscroll="):      # screenshots: the open sheet scrolled down by N pixels (9999 = to the end)
			main.get_tree().create_timer(0.4).timeout.connect(func(): main.sheet_scroll.scroll_vertical = int(a.substr(14)))
		elif a == "--nostory": main.story.enabled = false          # tests and screenshots of other things: no story boxes or bubbles
		elif a.begins_with("--story="): main.story.show_piece.call_deferred(a.substr(8), true)     # screenshots: one story piece (the id)
		elif a == "--pulse": for t in [0.2, 0.5, 0.8, 1.1, 1.4, 1.7, 2.0, 2.3]: main.get_tree().create_timer(t).timeout.connect(func(): main.playback._pulse(main.energy_bar, -4.0))     # screenshots: the bar pulse with a number floating up (J4)
		elif a == "--toasts":                      # screenshots: a stack of notification cards
			for t in ["🐰 A bunny came home!", "🌱 The carrots are ready to pick.", "💧 The watering can is empty. The well is behind the barn."]: main.notes.toast.call_deferred(t, 60.0)
		elif a.begins_with("--load="):             # screenshots: start from a saved farm (--load=res://tests/fixtures/ch3-seed1.json)
			G.load_game(a.substr(7))
			G.changed.emit()
		elif a.begins_with("--unlock="):           # screenshots: pretend these are done (--unlock=workbench,stone_axe)
			for id in a.substr(9).split(","): G.S["unlocked"][id] = true
			G.invalidate_caps()
		elif a.begins_with("--give="):             # screenshots: --give=rope:2,stick:5
			for kv in a.substr(7).split(","):
				var parts: PackedStringArray = kv.split(":")
				G.inventory.add_item(parts[0], float(parts[1]) if parts.size() > 1 else 1.0, true)
		elif a.begins_with("--pack="):             # screenshots: --pack=rope:2,stone:1 (packs what the store holds)
			for kv in a.substr(7).split(","):
				var parts2: PackedStringArray = kv.split(":")
				G.trip.pack(parts2[0], int(parts2[1]) if parts2.size() > 1 else 1)
		elif a == "--square": G.S["trip"] = {"phase": "square", "bought": 0.0}       # screenshots: standing on the village square (use with --give, --pack, --spot=market)
		elif a == "--built":                       # screenshots: pretend house, barn and workshop stand
			for b in ["cottage", "barn_1", "workshop_1"]: G.S["unlocked"][b] = true
			G.invalidate_caps()
