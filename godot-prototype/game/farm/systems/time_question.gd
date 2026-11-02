extends RefCounted
class_name FarmTimeQuestion
## The Time Quiz question: the one rule that moves farm time. Two jobs:
##   next()                            the next question: a retry, a due knowledge-card review, or a question from the packs
##   answered(q, first_try, purpose)   records the answer and applies the first-try rule; returns one report
## Only a right FIRST answer moves farm time one step (and then the purpose's follow-up happens). After a wrong first answer time
## stays, nothing of the purpose happens, and the question comes back right after the next one.
## Questions are remembered by their permanent id (pack questions) or by card and question index (reviews), never by their
## position in a list. Picking uses this part's own random source, so the farm's rolls never depend on which question came up.
## Card reviews belong to the knowledge cards (G.knowledge); this part only asks it for a due review.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems
var rng = preload("res://kits/core/rng.gd").new()   # picks questions and the order of their answers (not the farm's rolls)

## The purposes a question can be answered for. Each names what happens after a right first answer, besides time moving
## (follow_up below). A walk's cost is paid before its question (the chores village_trip, visit_friend); the forest chores are the
## follow-ups themselves. home_from_village is reserved for the walk home (money-market/04) and has no follow-up yet.
const PURPOSES := ["farm", "to_village", "home_from_village", "visit", "into_forest", "out_of_forest"]

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game.
func save_defaults() -> Dictionary:
	return {"recent_q": [], "retry_q": {}}

## Seeds the own random source: from the test seed in tests and the bot (the same questions every run), else at random.
func seed_from(test_seed: int) -> void:
	if test_seed >= 0: rng.seed = hash("time-question %d" % test_seed)
	else: rng.randomize()

# ------------------------------------------------------------------ the one door for packs

## Adds a question pack: its questions (each under its permanent id) join the Time Quiz when the pack is active (settings
## activePacks; an empty list means every pack), its pool of extra wrong answers fills short questions up. The built-in packs come
## in here, and the parent's own pasted packs will too (parent-controls/02): nothing after this door asks where a pack came from.
## pack = {"id", "code", "questions": [{"id", "q", "answers", "correct" …}], "pool": [answers]}
func add_pack(pack: Dictionary) -> void:
	G.packs.append(pack)
	var code := str(pack.get("code", pack.get("id", "")))
	if pack.has("pool"):
		var tp = G.quiz_tr.get(code + "-POOL", {})
		var tpool: Array = tp.get("answers", []) if typeof(tp) == TYPE_DICTIONARY else []
		var pool: Array = pack["pool"].duplicate()
		for i in range(mini(pool.size(), tpool.size())):
			if str(tpool[i]) != "": pool[i] = tpool[i]
		G.pack_pools[code] = pool
	var active: Array = G.settings.get("activePacks", [])
	for q in pack.get("questions", []):
		q["pack"] = code
		G.quiz_keys[str(q.get("q", ""))] = G.quiz.key(q)
		if active.is_empty() or active.has(pack.get("id", "")):
			G.pack_questions.append(q)

# ------------------------------------------------------------------ job 1: the next question

## The next Time Quiz question: a question answered wrong comes back after the next one; otherwise, at the review share, a due
## knowledge card is reviewed; otherwise a question from the packs (not one of the last few, the player's record decides which).
func next() -> Dictionary:
	var rq: Dictionary = G.S.get("retry_q", {})
	if not rq.is_empty():
		if int(rq.get("wait", 0)) <= 0:
			G.S["retry_q"] = {}
			var again := _by_ref(rq)
			if not again.is_empty(): return again
		else:
			rq["wait"] = int(rq["wait"]) - 1
	var share: float = G.pace.review_share()
	if share > 0.0 and rng.randf() < share:
		var due: Array = G.knowledge.due_cards()
		if due.size() > 0:
			var cid: String = due[rng.randi_range(0, due.size() - 1)]
			var qs: Array = G.nodes[cid].get("questions", [])
			if qs.size() > 0:
				return review_question(cid, rng.randi_range(0, qs.size() - 1))
	var recent: Array = G.S["recent_q"]
	var pool := []
	for src in G.pack_questions:
		if not recent.has(str(src.get("id", ""))): pool.append(src)
	if pool.is_empty(): pool = G.pack_questions.duplicate()
	var pick: Dictionary = pool[rng.randi_range(0, pool.size() - 1)]
	# the player's own record (kits/learn/quiz_engine.gd): a question answered wrong comes back after a few others; new ones before known ones
	var ci: int = G.quiz.pick(G.learn_record(), pool, rng)
	if ci >= 0: pick = pool[ci]
	recent.append(str(pick.get("id", "")))
	while recent.size() > int(G.settings.get("avoidRepeatWithin", 3)): recent.pop_front()
	return pack_question(pick)

## A question from the packs, laid out for showing.
func pack_question(src: Dictionary) -> Dictionary:
	var q: Dictionary = G.knowledge.shuffled_q(src, "", -1, false, rng)
	q["wrong_text"] = q["wrong"]
	q["source"] = tr("⏳ Time Quiz")
	return q

## A review of a knowledge card the player already knows (question qi of card cid), laid out for showing.
func review_question(cid: String, qi: int) -> Dictionary:
	var q: Dictionary = G.knowledge.shuffled_q(G.nodes[cid]["questions"][qi], cid, qi, true, rng)
	q["source"] = tr("📚 Review: ") + G.nodes[cid]["name"]
	return q

## The pack question with this permanent id, laid out for showing ({} if no active pack has it).
func question_by_id(id: String) -> Dictionary:
	var src := _pack_source(id)
	return {} if src.is_empty() else pack_question(src)

func _pack_source(id: String) -> Dictionary:
	for src in G.pack_questions:
		if str(src.get("id", "")) == id: return src
	return {}

## A remembered question (a retry) laid out again: a review by card and question index, a pack question by id.
func _by_ref(rq: Dictionary) -> Dictionary:
	var cid := str(rq.get("card", ""))
	if cid != "":
		var qi := int(rq.get("qi", -1))
		if not G.nodes.has(cid) or qi < 0 or qi >= (G.nodes[cid].get("questions", []) as Array).size(): return {}
		return review_question(cid, qi)
	return question_by_id(str(rq.get("id", "")))

# ------------------------------------------------------------------ job 2: a question was answered

## A question was answered (first_try = right on the first pick) for a purpose. Records it, applies the first-try rule and returns
## the report the interface draws from: {"moved": time moved one step, "info": the step's report (rain, pests …), "step": the
## question number now, "purpose": the purpose, "follow": what the purpose's follow-up returned (a visit's scene; a forest chore's
## report; null for the others)}. After a wrong first answer nothing of the purpose happens: the walk waits for the next question.
func answered(q: Dictionary, first_try: bool, purpose := "farm") -> Dictionary:
	assert(PURPOSES.has(purpose), "unknown purpose " + purpose)
	record(q, first_try)
	var rep := {"moved": false, "info": {}, "step": int(G.S["step"]), "purpose": purpose, "follow": null}
	if not first_try: return rep
	rep["moved"] = true
	rep["info"] = G.step_time()
	rep["step"] = int(G.S["step"])
	rep["follow"] = follow_up(purpose)
	return rep

## What a purpose does after a right first answer (time has already moved one step).
func follow_up(purpose: String) -> Variant:
	match purpose:
		"to_village": G.trip.arrive()
		"visit": return G.well.visited()
		"into_forest": return G.actions.perform("forest_enter", G.actions.farmer)
		"out_of_forest": return G.actions.perform("forest_leave", G.actions.farmer)
	return null

## Records an answer: a review in its card (and the learning record), a pack question in the learning record. A wrong first answer
## sets the question to come back right after the next one.
func record(q: Dictionary, first_try: bool) -> void:
	if q.get("review", false): G.knowledge.record_card_answer(q, first_try)
	elif str(q.get("id", "")) != "":
		G.quiz.record(G.learn_record(), str(q["id"]), first_try)
		G.save_learning()
	if not first_try: _retry_after_next(q)

func _retry_after_next(q: Dictionary) -> void:
	if q.get("review", false): G.S["retry_q"] = {"card": str(q.get("card", "")), "qi": int(q.get("qi", 0)), "wait": 1}
	else: G.S["retry_q"] = {"id": str(q.get("id", "")), "wait": 1}

# ------------------------------------------------------------------ old saves

## Save version 4 -> 5: the recent questions and the retry were remembered by their position in the list of pack questions; now by
## permanent id (positions read against the packs as they load now). Running it twice changes nothing.
func upgrade_save_v4(save: Dictionary) -> void:
	var ids := []
	for x in save.get("recent_q", []):
		if typeof(x) == TYPE_STRING: ids.append(x)
		elif int(x) >= 0 and int(x) < G.pack_questions.size(): ids.append(str(G.pack_questions[int(x)].get("id", "")))
	save["recent_q"] = ids
	var rq = save.get("retry_q", {})
	if typeof(rq) != TYPE_DICTIONARY or rq.is_empty() or rq.has("id"): save["retry_q"] = rq if typeof(rq) == TYPE_DICTIONARY else {}; return
	if str(rq.get("card", "")) != "" and (rq.get("review", false) or not rq.has("review")):
		save["retry_q"] = {"card": str(rq["card"]), "qi": int(rq.get("qi", 0)), "wait": int(rq.get("wait", 0))}
		return
	var i := int(rq.get("qi", -1))
	save["retry_q"] = {"id": str(G.pack_questions[i].get("id", "")), "wait": int(rq.get("wait", 0))} if i >= 0 and i < G.pack_questions.size() else {}
