extends RefCounted
## Knowledge: knowledge cards, reading, card quizzes and reviews, the Time Quiz questions and the first-try rule. (Kit to be: knowledge, with the learn kit.)
## Split out of game.gd in R4 (12 Oct 2026). Everything else of the game is reached through G, the front door
## (the Game autoload), which still answers to every function name, so callers did not change.

var G

func card_status(cid: String) -> String:
	if G.done(cid): return "learned"
	var n = G.nodes[cid]
	var book: String = n["requires"][0]
	if not G.done(book): return "nobook"
	for r in n.get("requires", []):
		if r != book and not G.satisfied(r): return "prereq"
	for k in n.get("discover", []):
		if not G.S["seen"].has(k): return "discover"
	if G.S["reading"] == cid: return "reading"
	var rd := float(n.get("cost", {}).get("read", 0))
	if rd <= 0.0 or G.S["read_done"].has(cid): return "quiz"
	return "readable"

func read_needed(cid: String) -> float:
	return float(G.nodes[cid].get("cost", {}).get("read", 0))

func start_reading(cid: String) -> bool:
	if G.card_status(cid) != "readable": return false
	if G.S["reading"] != "" and G.S["reading"] != cid:
		G.say(tr("📖 You're already reading \"%s\". One book page at a time!") % G.nodes[G.S["reading"]]["name"]); return false
	G.S["reading"] = cid; G.S["read_progress"] = 0.0
	G.say((tr("📖 Reading \"%s\": it takes %d Time Quiz question.") if G.up(G.read_needed(cid) * G.m("read")) == 1 else tr("📖 Reading \"%s\": it takes %d Time Quiz questions.")) % [G.nodes[cid]["name"], G.up(G.read_needed(cid) * G.m("read"))])
	G.save_game(); G.changed.emit()
	return true

func _tick_reading() -> void:
	var cid: String = G.S["reading"]
	if cid == "": return
	G.S["read_progress"] = float(G.S["read_progress"]) + 1.0 / maxf(0.1, G.m("read"))
	if float(G.S["read_progress"]) + 0.0001 >= G.read_needed(cid):
		G.S["read_done"][cid] = true
		G.S["reading"] = ""
		G.say(tr("📖 Finished reading \"%s\" — take its quiz in the Library!") % G.nodes[cid]["name"])

func card_ancestors(cid: String) -> Array:
	var out := []
	var stack: Array = G.nodes[cid].get("requires", []).duplicate()
	var seen := {}
	while stack.size() > 0:
		var r = stack.pop_back()
		if seen.has(r) or not G.nodes.has(r): continue
		seen[r] = true
		if G.nodes[r]["type"] == "knowledge":
			out.append(r)
			for x in G.nodes[r].get("requires", []): stack.append(x)
	return out

## A question laid out for showing (kits/learn/quiz_engine.gd present): settings quizOptions answers (3–4; the right one and
## wrong ones, filled up from the pack's pool), pictures, the texts in settings language. answers = [{"text", "img", "emoji"}].
func _shuffled_q(src: Dictionary, cid: String, qi: int, review: bool) -> Dictionary:
	var q: Dictionary = G.quiz.present(src, G.rng, clampi(int(G.settings.get("quizOptions", 4)), 2, 6), G.quiz_tr, G.pack_pools.get(str(src.get("pack", "")), []))
	q["card"] = cid; q["qi"] = qi; q["review"] = review
	if q["why"] == "": q["why"] = q["right"]
	return q

func card_quiz(cid: String) -> Array:
	var n = G.nodes[cid]
	var qs: Array = n.get("questions", [])
	var seen: Array = G.S["card_qseen"].get(cid, [])
	var idx := range(qs.size())
	idx.sort_custom(func(a, b): return (1 if seen.has(a) else 0) < (1 if seen.has(b) else 0))
	var out := []
	var newq = int(G.meta.get("knowledge", {}).get("newQuestions", 2))
	for j in range(mini(newq, idx.size())):
		out.append(G._shuffled_q(qs[idx[j]], cid, idx[j], false))
	var anc := []
	for a in G.card_ancestors(cid):
		if G.done(a): anc.append(a)
	anc.sort_custom(func(a, b): return G._card_key(a) < G._card_key(b))
	for j in range(mini(int(G.meta.get("knowledge", {}).get("maxReviewQuestions", 3)), anc.size())):
		var rq: Array = G.nodes[anc[j]].get("questions", [])
		if rq.is_empty(): continue
		var qi = G.rng.randi_range(0, rq.size() - 1)
		out.append(G._shuffled_q(rq[qi], anc[j], qi, true))
	return out

func _card_key(cid: String) -> int:
	var c = G.S["cards"].get(cid, {})
	return int(c.get("box", 1)) * 100000 + int(c.get("last", 0))

## Called once per question when it is finally answered right. first_try = right on the first pick.
func record_card_answer(q: Dictionary, first_try: bool) -> void:
	var cid: String = q["card"]
	# every question is also kept in the learning record by its id (how well the child knows it)
	if str(q.get("id", "")) != "":
		G.quiz.record(G._learn(), str(q["id"]), first_try)
		G.save_learning()
	if not G.S["card_qseen"].has(cid): G.S["card_qseen"][cid] = []
	if not G.S["card_qseen"][cid].has(int(q["qi"])): G.S["card_qseen"][cid].append(int(q["qi"]))
	if q.get("review", false) and G.done(cid):
		var c = G.S["cards"].get(cid, {"box": 1})
		c["box"] = mini(4, int(c.get("box", 1)) + 1) if first_try else 1
		c["last"] = G.S["step"]; c["time"] = G.now()
		G.S["cards"][cid] = c

func finish_card(cid: String, all_first_try: bool) -> void:
	if G.done(cid): return
	G.S["cards"][cid] = {"box": 2 if all_first_try else 1, "last": G.S["step"], "time": G.now()}
	G.S["read_done"].erase(cid)
	G.S["unlocked"][cid] = true
	G._dirty()
	var n = G.nodes[cid]
	var unl := []
	for u in n.get("unlocks", []):
		if G.nodes.has(u): unl.append(G.nodes[u].get("emoji", "") + " " + G.nodes[u]["name"])
		elif G.recipes.has(u): unl.append("🍳 " + str(G.recipes[u].get("name", G.iname(G.recipes[u]["outputs"].keys()[0]))))
	G.say(tr("🎓 You know: %s!%s") % [n["name"], (tr(" Now possible: ") + ", ".join(unl)) if unl.size() > 0 else ""])
	G.S["goals"] = int(G.S["goals"]) + 1
	if int(G.S["goals"]) % 12 == 0: G._offer_gift(G._news("goals"))
	G._check_acorns()
	G._auto_unlocks()
	G.save_game(); G.changed.emit()

func due_cards() -> Array:
	var out := []
	var t_now = G.now()
	for cid in G.card_ids:
		if not G.done(cid): continue
		var c = G.S["cards"].get(cid, {"box": 1, "last": 0, "time": t_now})
		var b := clampi(int(c.get("box", 1)), 1, 4)
		if G.S["step"] - int(c.get("last", 0)) >= G.STEP_GAPS[b - 1] or t_now - float(c.get("time", t_now)) >= G.DAY_GAPS[b - 1] * 86400.0:
			out.append(cid)
	return out

## The next Time Quiz question: mostly the parent's packs, sometimes a due knowledge review.
func next_time_question() -> Dictionary:
	# a question answered wrong at the first try comes back right after the next one (retry_after_next)
	var rq: Dictionary = G.S.get("retry_q", {})
	if not rq.is_empty():
		if int(rq.get("wait", 0)) <= 0:
			G.S["retry_q"] = {}
			var again = G._retry_question(rq)
			if not again.is_empty(): return again
		else:
			rq["wait"] = int(rq["wait"]) - 1
	var share = G.review_share()
	if share > 0.0 and G.rng.randf() < share:
		var due = G.due_cards()
		if due.size() > 0:
			var cid: String = due[G.rng.randi_range(0, due.size() - 1)]
			var qs: Array = G.nodes[cid].get("questions", [])
			if qs.size() > 0:
				var qi = G.rng.randi_range(0, qs.size() - 1)
				var q = G._shuffled_q(qs[qi], cid, qi, true)
				q["source"] = tr("📚 Review: ") + G.nodes[cid]["name"]
				return q
	var recent: Array = G.S["recent_q"]
	var pool := []
	for i in range(G.pack_questions.size()):
		if not recent.has(i): pool.append(i)
	if pool.is_empty(): pool = range(G.pack_questions.size())
	var pick: int = pool[G.rng.randi_range(0, pool.size() - 1)]
	# the player's own record (kits/learn/quiz_engine.gd): a question answered wrong comes back after a few others;
	# new ones come before known ones
	var cands := []
	for i in pool: cands.append(G.pack_questions[i])
	var ci: int = G.quiz.pick(G._learn(), cands, G.rng)
	if ci >= 0: pick = pool[ci]
	recent.append(pick)
	while recent.size() > int(G.settings.get("avoidRepeatWithin", 3)): recent.pop_front()
	var src: Dictionary = G.pack_questions[pick]
	var q2 = G._shuffled_q(src, "", pick, false)
	q2["wrong_text"] = q2["wrong"]
	q2["source"] = tr("⏳ Time Quiz")
	return q2

## A Time Quiz question answered wrong at the first try: ask it again right after the next question.
func retry_after_next(q: Dictionary) -> void:
	G.S["retry_q"] = {"review": q.get("review", false), "card": str(q.get("card", "")), "qi": int(q.get("qi", 0)), "wait": 1}

func _retry_question(rq: Dictionary) -> Dictionary:
	var qi := int(rq.get("qi", 0))
	if rq.get("review", false):
		var cid := str(rq.get("card", ""))
		if not G.nodes.has(cid): return {}
		var qs: Array = G.nodes[cid].get("questions", [])
		if qi < 0 or qi >= qs.size(): return {}
		var q = G._shuffled_q(qs[qi], cid, qi, true)
		q["source"] = tr("📚 Review: ") + G.nodes[cid]["name"]
		return q
	if qi < 0 or qi >= G.pack_questions.size(): return {}
	var q2 = G._shuffled_q(G.pack_questions[qi], "", qi, false)
	q2["wrong_text"] = q2["wrong"]
	q2["source"] = tr("⏳ Time Quiz")
	return q2

## Remembers how a Time Quiz question went for this player, under its id (wrong: back after 3 others; right: 12, 32, 80 … later).
func time_result(q: Dictionary, first_try: bool) -> void:
	if q.get("review", false) or str(q.get("id", "")) == "": return
	G.quiz.record(G._learn(), str(q["id"]), first_try)
	G.save_learning()
