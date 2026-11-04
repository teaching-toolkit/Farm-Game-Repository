extends RefCounted
class_name FarmStory
## The story pieces (story/game/story-delivery.md; data in data/farm/story/): which are ready, in which order, how often, what has been seen.
## A piece: {"kind", "chapter", "when": [conditions, all must hold], "priority", "once", "speaker", "picture", "text" or "pages": [{"text", "picture"}]}.
## Kinds: frame · beat · discovery · letter · moment · visit · scene · bark · trace. This script only decides WHAT may be shown and WHEN;
## showing it (the story box, the speech bubble, the 📜 scroll) is the interface's job (game/farm/ui/storybox.gd).

const KINDS := ["frame", "beat", "discovery", "letter", "moment", "visit", "scene", "bark", "trace"]   # priority order: first wins
const RATIONED := ["moment", "visit", "letter"]       # unprompted pieces: at most one per story.rationSteps Time Quiz questions (rules/65-feel.json)

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"story_seen": {}, "story_taps": {}, "story_last": -99, "story_bark": {}, "story_news": []}

func pieces() -> Dictionary:
	return G.D.get("story", {})

func piece(id: String) -> Dictionary:
	return pieces().get(id, {})

func seen(id: String) -> bool:
	return G.S["story_seen"].has(id)

## The pages of a piece: [{"text", "picture"}]; a piece with just a "text" is one page. {player} is the player's name.
func pages(id: String) -> Array:
	var p := piece(id)
	var out := []
	if p.has("pages"):
		for pg in p["pages"]: out.append({"text": _fill(str(pg.get("text", ""))), "picture": str(pg.get("picture", p.get("picture", "")))})
	elif p.has("text"):
		out.append({"text": _fill(str(p["text"])), "picture": str(p.get("picture", ""))})
	return out

func _fill(t: String) -> String:
	return t.replace("{player}", G.player if G.player != "" else tr("friend"))

## Can this piece show now? Its chapter has come, it has not been seen (unless it is a bark that may come back) and its conditions hold.
func is_ready(id: String) -> bool:
	var p := piece(id)
	if p.is_empty() or pages(id).is_empty(): return false
	if int(p.get("chapter", 1)) > G.chapter(): return false
	var once: bool = bool(p.get("once", str(p.get("kind", "")) != "bark"))
	if seen(id):
		if once: return false
		if G.S["step"] - int(G.S["story_seen"][id]) < int(p.get("cooldown", bark_rest())): return false
	return G.conditions.holds_all(p.get("when", []))

## A bark does not come back within this many questions (rules/65-feel.json, story.barkRest), unless the piece sets its own cooldown.
func bark_rest() -> int:
	return int(G.feel("story.barkRest"))

## The pieces ready now, the one to show first at the front: by kind, then by priority, then by the order of the data;
## a bark that was seen longest ago comes before one seen lately. Rationed kinds wait out their three questions.
func ready() -> Array:
	var out := []
	var rationed_out: bool = G.S["step"] - int(G.S["story_last"]) < int(G.feel("story.rationSteps"))
	var order := 0
	for id in pieces():
		order += 1
		var p: Dictionary = pieces()[id]
		var kind := str(p.get("kind", ""))
		if kind == "trace" or not KINDS.has(kind): continue
		if rationed_out and RATIONED.has(kind): continue
		if is_ready(id): out.append({"id": id, "rank": KINDS.find(kind), "priority": int(p.get("priority", 50)), "order": order, "last": int(G.S["story_seen"].get(id, -999))})
	out.sort_custom(func(a, b):
		if a["rank"] != b["rank"]: return a["rank"] < b["rank"]
		if a["priority"] != b["priority"]: return a["priority"] > b["priority"]
		if a["last"] != b["last"]: return a["last"] < b["last"]
		return a["order"] < b["order"])
	var ids := []
	for r in out: ids.append(r["id"])
	return ids

## The next piece to show, or "" (the interface decides whether the farm is quiet enough).
func next_piece() -> String:
	var r := ready()
	return r[0] if r.size() > 0 else ""

func is_bark(id: String) -> bool:
	return str(piece(id).get("kind", "")) == "bark"

## A piece was shown.
func mark_seen(id: String) -> void:
	G.S["story_seen"][id] = int(G.S["step"])
	if RATIONED.has(str(piece(id).get("kind", ""))): G.S["story_last"] = int(G.S["step"])
	G.changed.emit()

## The player tapped something that has a story ("market", "board", "patch:weeds" …): story pieces with `tap:<place>` may now come.
func tapped(key: String) -> void:
	if G.S["story_taps"].has(key): return
	G.S["story_taps"][key] = true
	G.changed.emit()

## Everything seen so far, in the order of the data (what the 📜 scroll lists).
func seen_in_order() -> Array:
	var out := []
	for id in pieces():
		if seen(id) and str(piece(id).get("kind", "")) != "bark": out.append(id)
	return out

# ------------------------------------------------------------------ news boxes

## A box worth the child's attention that is not a story piece (story/13, story/14): a change of season, a golden acorn, a favour
## done, a party. box: {"key", "emoji", "title", "text", "more", "picture"} (texts already in the player's language). It waits in the
## save until the farm is quiet (the interruption queue, kind "news", in rules/65-feel.json) and then shows as a box with a picture.
## Boxes never pile up: a newer season box replaces a waiting one, the same key is in line once, and at most story.newsMax wait (the
## oldest goes; the bot never opens a box). The text also goes into the farm's log, as a note would.
func announce(box: Dictionary) -> void:
	var key := str(box.get("key", ""))
	var waiting: Array = G.S["story_news"]
	for b in waiting.duplicate():
		var k := str(b.get("key", ""))
		if k == key or (key.begins_with("season:") and k.begins_with("season:")): waiting.erase(b)
	waiting.append(box)
	while waiting.size() > int(G.feel("story.newsMax")): waiting.pop_front()
	G.S["log"].append("%s %s %s" % [str(box.get("emoji", "")), str(box.get("title", "")), str(box.get("text", ""))])
	if G.S["log"].size() > 40: G.S["log"].pop_front()

## The first box waiting, or {}.
func news_next() -> Dictionary:
	var waiting: Array = G.S["story_news"]
	return waiting[0] if waiting.size() > 0 else {}

## That box was shown: out of the line.
func news_shown(key: String) -> void:
	var waiting: Array = G.S["story_news"]
	for b in waiting.duplicate():
		if str(b.get("key", "")) == key: waiting.erase(b)

# ------------------------------------------------------------------ condition words

## The condition words this system owns (kits/core/conditions.gd; listed with the data checker's word list).
func register_words(c) -> void:
	c.register("story_seen", func(_a): return float(G.S["story_seen"].size()), "number", "", "Story pieces read.", "story_seen>=1")
	c.register("tap", func(a): return G.S["story_taps"].has(a), "yes", "place", "This place (or patch:<kind>) has been tapped.", "tap:market")
	c.register("after", _after, "yes", "after", "At least n Time Quiz questions have passed since this story piece was read (after:<piece>:<n>).", "after:c1_night:2")

## after:<piece>:<n>: n Time Quiz questions have passed since the piece was seen.
func _after(arg: String) -> bool:
	var q := arg.split(":")
	return q.size() == 2 and G.S["story_seen"].has(q[0]) and int(G.S["step"]) - int(G.S["story_seen"][q[0]]) >= int(q[1])
