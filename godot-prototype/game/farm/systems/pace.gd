extends RefCounted
class_name FarmPace
## Dynamic difficulty (settings dynamicDifficulty, off by default): a running 'pace' of what the player brings in per question,
## and the Goldilocks factors that make costs follow it.

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

# ------------------------------------------------------------------ dynamic difficulty

## Goldilocks prices. The game keeps a "pace": the worth of what this player brings in per Time Quiz question (a running
## average). When a goal first shows up, its coins and bigger material amounts are fitted to that pace compared with the
## pace planned for this point of the game (meta.flex.basePace): a strong farm gets a bit more to do, a farm that
## is struggling a bit less. Only part of the difference is followed (strength 0.5), so every upgrade still makes the
## farm feel quicker; the factor stays within meta.flex.range and is fixed from then on, so a price never changes in front
## of the child. Energy and the kinds of things never change. A goal that an improvement not yet made would make quicker
## asks a little more (tipBonus), and shows that improvement as a tip (flex_tip): exploring it is the way through.
func flex_on() -> bool:
	return bool(G.S.get("dynamic", G.settings.get("dynamicDifficulty", false)))

## Share of Time Quiz questions that review the knowledge cards already learned (0..1); the rest come from the parent's
## packs. Set per farm in ⚙️ Settings; data/settings.json gives the starting value.
func review_share() -> float:
	return clampf(float(G.S.get("review_share", G.settings.get("knowledgeReviewShare", 0.25))), 0.0, 1.0)

func set_review_share(v: float) -> void:
	G.S["review_share"] = clampf(snappedf(v, 0.05), 0.0, 1.0)
	G.invalidate_caps()

## Switches dynamic difficulty on or off for this farm (Settings). Prices already fitted keep their factor while on.
func toggle_flex() -> void:
	G.S["dynamic"] = not flex_on()
	G.invalidate_caps()
	G.save_game(); G.changed.emit()

func flex_cfg() -> Dictionary:
	return G.meta.get("flex", {})

## What one piece is worth for the pace (its value; things worth nothing to sell still count a little).
func flex_worth(k: String) -> float:
	return maxf(G.inventory.value_of(k), float(flex_cfg().get("minWorth", 0.25)))

func tick_pace(_info := {}) -> void:
	var n := float(flex_cfg().get("paceQuestions", 20))
	G.S["pace_n"] = int(G.S.get("pace_n", 0)) + 1
	# a running average over about n questions (a plain average while there are fewer)
	G.S["pace"] = lerpf(float(G.S.get("pace", 0.0)), G.produced, maxf(2.0 / (n + 1.0), 1.0 / float(G.S["pace_n"])))
	G.produced = 0.0

## The pace planned at this point of the game: meta.flex.basePace = [[goals done, pace], …] (from the test bot), in between
## a straight line.
func base_pace() -> float:
	var tab: Array = flex_cfg().get("basePace", [])
	if tab.is_empty(): return 0.0
	var gd := float(G.S.get("goals", 0))
	if gd <= float(tab[0][0]): return float(tab[0][1])
	for i in range(1, tab.size()):
		if gd <= float(tab[i][0]):
			var t := (gd - float(tab[i - 1][0])) / maxf(1.0, float(tab[i][0]) - float(tab[i - 1][0]))
			return lerpf(float(tab[i - 1][1]), float(tab[i][1]), t)
	return float(tab[tab.size() - 1][1])

## How far this player's pace is ahead (> 1) or behind (< 1) the pace planned for this point of the game.
func pace_ratio() -> float:
	var b := base_pace()
	if b <= 0.0: return 1.0
	return float(G.S.get("pace", 0.0)) / b

## The price factor of a goal (1 = as planned). Fixed the first time it is asked for while the goal is open.
func flex_factor(id: String) -> float:
	if not flex_on(): return 1.0
	if not G.S.has("flex"): G.S["flex"] = {}
	if G.S["flex"].has(id): return float(G.S["flex"][id])
	var F := flex_cfg()
	var n = G.nodes[id]
	if not (n["type"] in F.get("types", [])) or int(G.S.get("pace_n", 0)) < int(F.get("warmup", 15)): return 1.0
	if G.done(id) or G.satisfied(id) or not G.progression.missing_reqs(id).is_empty(): return 1.0
	var rg: Array = F.get("rangeSide", [0.75, 1.4]) if n["type"] == "sidequest" else F.get("range", [0.8, 1.3])
	var k := pow(maxf(0.05, pace_ratio()), float(F.get("strength", 0.5)))
	if flex_tip(id) != "": k *= 1.0 + float(F.get("tipBonus", 0.08))
	k = clampf(k, float(rg[0]), float(rg[1]))
	G.S["flex"][id] = snappedf(k, 0.01)
	return float(G.S["flex"][id])

func flexed(id: String, c: Dictionary) -> Dictionary:
	var k := flex_factor(id)
	if absf(k - 1.0) < 0.01: return c
	var out := {}
	for key in c:
		var v := float(c[key])
		if key == "coins": out[key] = maxf(1.0, roundf(v * k))
		elif key in ["energy", "read", "water"] or v < 2.0: out[key] = v
		else:
			# never more than the store can hold (else the goal could not be reached at all)
			var cap := G.needs.storage_cap() if G.items.has(key) and G.items[key].get("category", "") != "keeper" else 1.0e9
			out[key] = maxf(1.0, minf(roundf(v * k), maxf(v, cap)))
	return out

## An improvement not made yet that would make this goal quicker (its things cheaper to make, gather or grow), or "".
func flex_tip(id: String) -> String:
	var keys := {}
	for st in G.nodes[id].get("steps", []):
		for k in st.get("cost", {}): keys[k] = true
	for k in G.nodes[id].get("cost", {}): keys[k] = true
	var want := {}           # effect keys that would help: energy:<cat>, out:<station>, time:<station>, yield …
	for k in keys:
		if k in ["coins", "energy", "read", "water"] or not G.items.has(k): continue
		if G.items[k].get("category", "") == "crop":
			want["energy:harvest"] = true; want["yield:field"] = true; want["weeds"] = true
		for rid in G.recipes:
			if not G.recipes[rid]["outputs"].has(k): continue
			want["energy:" + G.crafting.recipe_cat(rid)] = true
			want["out:" + str(G.recipes[rid]["station"])] = true
			want["time:" + str(G.recipes[rid]["station"])] = true
	if keys.has("energy"): want["energy:" + G.progression.node_cat(id)] = true
	for nid in G.nodes:
		var n = G.nodes[nid]
		if not (n["type"] in ["helper", "tool", "gear", "polish"]): continue
		if n["type"] == "polish":
			if not G.crafting.polish_open(nid) or G.crafting.polish_level(nid) >= 1.0: continue
		elif not G.progression.is_open(nid): continue
		var e: Dictionary = n.get("effects", {})
		for part in ["mult", "add"]:
			for ek in e.get(part, {}):
				if want.has(ek): return nid
	return ""

## The cost of a node as {key: amount}, scaled for per-patch upgrades and energy upgrades.
## A node done in steps costs what its next step costs.
func node_cost(id: String) -> Dictionary:
	var raw: Dictionary = G.progression.raw_cost(id)
	var mul := 1.0   # per-patch upgrades are paid one patch at a time (see unlock)
	var out := {}
	for k in raw:
		if k == "read": continue
		var v := float(raw[k]) * mul
		if k == "energy": v = G.needs.ecost(G.progression.node_cat(id), v)
		out[k] = v
	return out

## The cost before any upgrade, practice star, meal or season makes it cheaper (the cube bars show what is saved).
func node_cost_base(id: String) -> Dictionary:
	var raw: Dictionary = G.progression.raw_cost(id)
	var out := {}
	for k in raw:
		if k != "read": out[k] = float(raw[k])
	return out

func missing_cost(c: Dictionary) -> Array:
	var miss := []
	for k in c:
		var need := float(c[k])
		var h := G.inventory.have(k)
		if h + 0.0001 < need:
			miss.append({"key": k, "need": need, "have": h})
	if c.has("coins") and float(c["coins"]) > 0.0 and G.lord.blocks_coins():      # the Lord's share comes first
		miss.append({"key": "lord", "need": 1.0, "have": 0.0})
	return miss

func pay(c: Dictionary) -> bool:
	if not missing_cost(c).is_empty(): return false
	for k in c:
		var v := float(c[k])
		if k == "energy": G.S["energy"] -= v
		elif k == "water": G.S["water"] -= v
		elif k == "coins": G.S["coins"] -= v
		else: G.inventory.take(k, v)
	return true

func cost_text(c: Dictionary) -> String:
	var parts := []
	for k in c:
		parts.append(G.money_up(float(c[k])) if k == "coins" else "%s%d" % [G.iemoji(k), G.up(float(c[k]))])
	return " ".join(parts)
