extends Node
## The story engine (TODO Phase 5.1): which pieces are ready, in which order, rationing, once/bark, taps, {player}. Rules only, injected pieces.
## Run:  godot --headless --path . res://tests/story_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	G.player = "Mia"
	var ST = G.story
	# the real chapter 1 (data/farm/story): the opening is the frame, then the beat; later pieces wait for their game events
	_check(ST.next_piece() == "c1_frame0", "a new game opens with the bedside frame (got %s)" % ST.next_piece())
	ST.mark_seen("c1_frame0")
	_check(ST.next_piece() == "c1_stalk", "then the nibbled stalk")
	ST.mark_seen("c1_stalk")
	_check(ST.next_piece() == "", "then nothing until the player does something (%s)" % ST.next_piece())
	G.S["step"] = 2
	_check(ST.is_ready("c1_night"), "after two questions: the first night")
	G.S["unlocked"]["pet_bunny"] = true
	_check(ST.is_ready("c1_bunny") and not ST.is_ready("c1_bell_out"), "the bunny's beat comes with the bunny; the bell waits for the next night")
	ST.mark_seen("c1_bunny")
	G.S["step"] = 3
	_check(ST.is_ready("c1_bell_out"), "…one question after")
	# story/12: the hens argue only when there are two of them; one hen gets her own bark (chance left out: it is the same every question)
	var hens_when: Array = ST.piece("c1_k_hens")["when"].filter(func(c): return not str(c).begins_with("chance:"))
	var alone_when: Array = ST.piece("c1_k_hen_alone")["when"].filter(func(c): return not str(c).begins_with("chance:"))
	G.S["animals"]["animal_chicken"] = {"count": 1, "ready": 0, "muck": 0.0}
	_check(not G.conditions.holds_all(hens_when) and G.conditions.holds_all(alone_when), "one hen: no arguing hens, the lonely hen may speak")
	G.S["animals"]["animal_chicken"]["count"] = 2
	_check(G.conditions.holds_all(hens_when) and not G.conditions.holds_all(alone_when), "two hens: they may argue; the lonely hen is quiet")
	# every bark of the real data has a chance and at least one condition besides it (story/12: each says when it makes sense)
	var bad := []
	for id in ST.pieces():
		if not ST.is_bark(id): continue
		var w: Array = ST.piece(id).get("when", [])
		if w.filter(func(c): return str(c).begins_with("chance:")).is_empty() or w.size() < 2: bad.append(id)
	_check(bad.is_empty(), "every bark has a chance and a real condition (%s)" % ", ".join(bad))
	# story/15: feeding the travelling merchant the first time is a Scene: ready the moment the delivery is done (not rationed), once
	_check(str(ST.piece("c1_seller").get("kind", "")) == "scene" and not ST.is_ready("c1_seller"), "the merchant's scene waits for the porridge")
	G.S["story_last"] = int(G.S["step"])      # a moment was just read: rationed pieces would wait now
	G.S["unlocked"]["d_porridge"] = true
	_check(ST.is_ready("c1_seller") and ST.ready().has("c1_seller"), "…handed over: ready at once, even right after another piece")
	ST.mark_seen("c1_seller")
	G.S["step"] += 50
	_check(not ST.is_ready("c1_seller"), "…and it shows only once")
	# story/14: a change of season is one box (what changes, the plenty, the market news), not three notes; boxes never pile up
	G.reset_game()
	var notes := []
	var on_note := func(t): notes.append(t)
	G.toast.connect(on_note)
	G.S["step"] = G.seasons.season_len() - 1
	G.step_time()
	var nb: Dictionary = ST.news_next()
	_check(G.seasons.season() == "summer" and str(nb.get("key", "")) == "season:summer" and str(nb.get("text", "")) != "", "summer comes with its box (%s)" % str(nb))
	_check(str(nb.get("more", "")).contains("🪙") and str(nb.get("picture", "")) == "season_summer", "…with the market news and the season's picture name")
	_check(notes.filter(func(t): return str(t).contains("Market news") or str(t).contains(str(G.meta["seasons"]["mods"]["summer"]["intro"]))).is_empty(), "…and the news is not said again as a note")
	G.toast.disconnect(on_note)
	ST.announce(G.seasons.season_box("autumn"))
	_check(G.S["story_news"].size() == 1 and str(ST.news_next()["key"]) == "season:autumn", "a newer season box replaces one still waiting")
	for i in range(10): ST.announce({"key": "acorn:a%d" % i, "title": "x", "text": "y"})
	_check(G.S["story_news"].size() == int(G.feel("story.newsMax")), "at most story.newsMax boxes wait (%d)" % G.S["story_news"].size())
	ST.news_shown(str(ST.news_next()["key"]))
	_check(G.S["story_news"].size() == int(G.feel("story.newsMax")) - 1, "a shown box leaves the line")
	# story/13: a golden acorn and a party are boxes, not notes
	G.reset_game()
	G.rewards.acorn_box("acorn_first_pet")
	_check(str(ST.news_next().get("key", "")) == "acorn:acorn_first_pet" and str(ST.news_next().get("text", "")).contains("First pet home"), "a golden acorn waits as a box")
	G.reset_game()
	G.player = "Mia"
	G.D["story"] = {
		"f0": {"kind": "frame", "chapter": 1, "when": ["start"], "text": "Hello {player}."},
		"b1": {"kind": "beat", "chapter": 1, "when": ["tap:market"], "pages": [{"text": "One."}, {"text": "Two.", "picture": "x"}]},
		"m1": {"kind": "moment", "chapter": 1, "when": [], "text": "A moment."},
		"m2": {"kind": "moment", "chapter": 1, "when": [], "text": "Another."},
		"v2": {"kind": "visit", "chapter": 2, "when": [], "text": "Later chapter."},
		"k1": {"kind": "bark", "chapter": 1, "when": [], "text": "Cluck."},
		"t1": {"kind": "trace", "chapter": 1, "when": [], "text": "A trace."},
		"e1": {"kind": "discovery", "chapter": 1, "when": ["item:carrot>=2"], "text": "Carrots!", "priority": 70},
		"e2": {"kind": "discovery", "chapter": 1, "when": ["item:carrot>=2"], "text": "Carrots again.", "priority": 80},
		"empty": {"kind": "beat", "chapter": 1, "when": []},
	}
	# the start piece is ready at step 0 only; a piece without text is never ready
	_check(ST.is_ready("f0") and ST.next_piece() == "f0", "the opening frame is first at the start")
	_check(ST.pages("f0")[0]["text"] == "Hello Mia.", "{player} is filled in")
	_check(not ST.is_ready("empty"), "a piece without text is never ready")
	_check(not ST.is_ready("b1"), "a piece waits for its tap")
	ST.tapped("market")
	_check(ST.is_ready("b1") and ST.pages("b1").size() == 2 and ST.pages("b1")[1]["picture"] == "x", "after the tap: ready, with its pages")
	_check(ST.next_piece() == "f0", "frame before beat")
	ST.mark_seen("f0")
	_check(not ST.is_ready("f0"), "a seen piece does not come back")
	_check(ST.next_piece() == "b1", "then the beat")
	ST.mark_seen("b1")
	# the rationing: unprompted pieces wait three questions
	G.S["step"] = 1
	var first: String = ST.next_piece()
	_check(first == "k1" or first == "m1", "something is ready: %s" % first)
	ST.mark_seen("m1")
	_check(not ST.ready().has("m2"), "a second moment waits")
	G.S["step"] = 4
	_check(ST.ready().has("m2"), "…three questions later it may come")
	_check(not ST.ready().has("v2"), "a piece of a later chapter waits")
	_check(not ST.ready().has("t1"), "a trace is not shown by itself")
	# discoveries: higher priority first
	G.S["inv"]["carrot"] = [[1, 5.0]]
	var r: Array = ST.ready()
	_check(r.find("e2") < r.find("e1") and r.find("e1") >= 0, "priority orders pieces of one kind")
	_check(r.find("e2") < r.find("m2"), "a discovery comes before a moment")
	# a bark may come back after its cooldown, once pieces are unrationed
	ST.mark_seen("k1")
	_check(not ST.is_ready("k1"), "a bark rests after it spoke")
	G.S["step"] = 4 + ST.bark_rest()
	_check(ST.is_ready("k1") and ST.is_bark("k1"), "…and comes back later")
	_check(not ST.seen_in_order().has("k1") and ST.seen_in_order() == ["f0", "b1", "m1"], "the scroll lists seen pieces in data order, no barks")
	# the chapter
	G.D["story"]["v2"]["chapter"] = 1
	_check(ST.is_ready("v2"), "…a piece whose chapter has come is ready")
	# the save keys
	var save: Dictionary = G.S.duplicate(true)
	_check(save.has("story_seen") and save.has("story_taps") and save.has("story_last") and save.has("story_bark"), "the story's save keys exist")
	# determinism of chance
	var a: bool = G.conditions.holds("chance:0.5")
	_check(a == G.conditions.holds("chance:0.5"), "chance gives one answer per question")
	print("STORY %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
