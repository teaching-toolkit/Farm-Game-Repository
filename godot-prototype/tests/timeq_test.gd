extends Node
## The time question (game/farm/systems/time_question.gd): the Time Quiz's one rule, through its two jobs next() and answered().
## A right first answer moves time, a wrong one doesn't and comes back after the next question, a card review is recorded as a
## review, questions are remembered by id, picking never touches the farm's random numbers. Rules only, no screen.
## Run:  godot --headless --path . res://tests/timeq_test.tscn -- --seed=1
var G
var fails := 0
var checks := 0

func _ready() -> void:
	G = get_node("/root/Game")
	G.reset_game()
	var T = G.timeq
	# a right first answer on the farm moves time one step
	var st: int = G.S["step"]
	var q: Dictionary = T.next()
	_check(not q.is_empty() and str(q.get("id", "")) != "" and q["answers"].size() >= 2, "next() gives a pack question with answers (%s)" % q.get("id", ""))
	var rep: Dictionary = T.answered(q, true, "farm")
	_check(rep["moved"] and int(G.S["step"]) == st + 1 and int(rep["step"]) == st + 1, "a right first answer moves time one step (%d -> %d)" % [st, G.S["step"]])
	_check(rep["info"].has("rain") and rep["purpose"] == "farm", "…and the report carries the step's info and the purpose")
	_check(G.learn_record()["quiz"]["items"].has(str(q["id"])), "…and the answer is in the learning record")
	# a wrong first answer: time stays, the question comes back right after the next one
	G.pace.set_review_share(0.0)
	st = G.S["step"]
	var qa: Dictionary = T.next()
	rep = T.answered(qa, false, "farm")
	_check(not rep["moved"] and int(G.S["step"]) == st and rep["info"].is_empty(), "a wrong first answer does not move time")
	_check(G.S["retry_q"].get("id", "") == qa["id"], "…and remembers the question by its id (%s)" % str(G.S["retry_q"]))
	var qb: Dictionary = T.next()
	var qc: Dictionary = T.next()
	_check(qb["id"] != qa["id"] and qc["id"] == qa["id"], "…it comes back after one other question (%s, %s, %s)" % [qa["id"], qb["id"], qc["id"]])
	_check(G.S["retry_q"].is_empty(), "…and is then forgotten")
	# the retry finds its question by id, wherever the question now stands in the packs
	T.answered(qc, false, "farm")
	G.pack_questions.reverse()
	T.next()
	_check(T.next().get("id", "") == qa["id"], "a retry finds its question by id after the packs changed order")
	G.pack_questions.reverse()
	# recent questions are ids too, and do not repeat within avoidRepeatWithin
	var seen := []
	for i in range(int(G.settings.get("avoidRepeatWithin", 3)) + 1): seen.append(str(T.next()["id"]))
	var dup := false
	for i in range(seen.size()): if seen.find(seen[i]) != i: dup = true
	_check(not dup and typeof(G.S["recent_q"][0]) == TYPE_STRING, "recent questions are ids and don't repeat right away (%s)" % str(seen))
	# picking questions never touches the farm's random numbers
	var before = G.rng.state
	for i in range(30): T.next()
	_check(G.rng.state == before, "picking questions leaves the farm's random numbers alone")
	# a card review is recorded as a review
	var cid := ""
	for c in G.card_ids:
		if (G.nodes[c].get("questions", []) as Array).size() > 0 and not G.done(c): cid = c; break
	G.knowledge.finish_card(cid, false)
	for c in G.card_ids:
		if G.S["cards"].has(c): G.S["cards"][c]["last"] = -1000
	G.pace.set_review_share(1.0)
	G.S["retry_q"] = {}
	var rq: Dictionary = T.next()
	_check(rq.get("review", false) and G.done(str(rq["card"])), "with the review share at 1 a due card is reviewed (%s)" % str(rq.get("card", "")))
	var rc := str(rq["card"])
	var box0 := int(G.S["cards"][rc].get("box", 1))
	st = G.S["step"]
	rep = T.answered(rq, true, "farm")
	_check(rep["moved"] and int(G.S["cards"][rc]["box"]) == mini(4, box0 + 1) and int(G.S["cards"][rc]["last"]) == st, "a right review moves time and moves the card up a box (%d -> %d)" % [box0, G.S["cards"][rc]["box"]])
	G.S["cards"][rc]["last"] = -1000
	var rq2: Dictionary = T.next()
	T.answered(rq2, false, "farm")
	_check(int(G.S["cards"][str(rq2["card"])]["box"]) == 1 and G.S["retry_q"].get("card", "") == str(rq2["card"]) and int(G.S["retry_q"]["qi"]) == int(rq2["qi"]), "a wrong review puts the card back in box 1 and comes back by card and question")
	T.next()
	var back: Dictionary = T.next()
	_check(back.get("review", false) and back["card"] == rq2["card"] and back["qi"] == rq2["qi"], "…after the next question")
	# a question shown by id (the testing flag --qid)
	_check(T.question_by_id(str(G.pack_questions[0]["id"])).get("id", "") == G.pack_questions[0]["id"] and T.question_by_id("NOPE-1").is_empty(), "question_by_id finds a pack question, and nothing for an unknown id")
	# a pack added through the one door (as the parent's pasted packs will be) is drawn and answered like a built-in one
	G.pace.set_review_share(0.0)
	G.S["retry_q"] = {}
	(G.settings["activePacks"] as Array).append("own-test")
	var n0: int = G.pack_questions.size()
	T.add_pack({"id": "own-test", "code": "OWN", "pool": ["Spoon", "Cloud", "Shoe"], "questions": [
		{"id": "OWN-001", "q": "What does a hen lay?", "answers": ["Eggs", "Milk"], "correct": 0}]})
	_check(G.pack_questions.size() == n0 + 1 and G.pack_pools.has("OWN"), "the new pack's question and pool are in")
	var own: Dictionary = {}
	for i in range(400):
		var x: Dictionary = T.next()
		if x.get("id", "") == "OWN-001": own = x; break
	_check(not own.is_empty() and own["answers"].size() == clampi(int(G.settings.get("quizOptions", 4)), 2, 6), "…its question is drawn, filled up from its pool (%d answers)" % (own.get("answers", []) as Array).size())
	st = G.S["step"]
	rep = T.answered(own, false, "farm")
	T.next()
	var own2: Dictionary = T.next()
	_check(not rep["moved"] and own2.get("id", "") == "OWN-001", "…a wrong answer keeps time and brings it back after the next one")
	rep = T.answered(own2, true, "farm")
	_check(rep["moved"] and int(G.S["step"]) == st + 1 and G.learn_record()["quiz"]["items"].has("OWN-001"), "…a right one moves time and is in the learning record")
	# the walks are named purposes: a right first answer moves time and runs the follow-up; a wrong one doesn't, and the walk waits
	G.S["retry_q"] = {}
	G.S["energy"] = 30.0
	G.S["trip"]["phase"] = "walk"
	_walk("to_village", func(): return G.trip.phase() == "square", "the trip arrives at the square")
	G.S["well"]["invite"] = "Tom"
	var vr: Dictionary = _walk("visit", func(): return G.well.invite() == "", "the visit happens")
	_check(typeof(vr.get("follow")) == TYPE_STRING and str(vr["follow"]) != "", "…and returns its scene")
	G.S["unlocked"]["ruins_stillroom"] = true
	G.invalidate_caps()
	_walk("into_forest", func(): return G.forest.inside(), "the farmer walks into the forest")
	_walk("out_of_forest", func(): return not G.forest.inside(), "the farmer walks out of the forest")
	st = G.S["step"]
	_check(T.answered(T.next(), true, "home_from_village")["moved"] and int(G.S["step"]) == st + 1, "home_from_village is a purpose already (it only moves time for now)")
	print("TIMEQ %s: %d checks, %d failed" % ["OK" if fails == 0 else "FAILED", checks, fails])
	get_tree().quit(1 if fails > 0 else 0)

## A walk: a wrong first answer leaves time and the walk as they were; a right one moves time and runs the purpose's follow-up.
func _walk(purpose: String, happened: Callable, what: String) -> Dictionary:
	var st: int = G.S["step"]
	var r: Dictionary = G.timeq.answered(G.timeq.next(), false, purpose)
	_check(not r["moved"] and int(G.S["step"]) == st and not happened.call(), "%s: a wrong first answer: time stays, the walk waits" % purpose)
	r = G.timeq.answered(G.timeq.next(), true, purpose)
	_check(r["moved"] and int(G.S["step"]) == st + 1 and happened.call(), "%s: a right first answer moves time and %s" % [purpose, what])
	return r

func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		fails += 1
		print("FAIL ", what)
