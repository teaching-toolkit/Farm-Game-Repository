extends RefCounted
class_name FarmStory
## The story pieces (story/story-delivery.md; data in data/farm/story/): which are ready, in which order, how often, what has been seen.
## A piece: {"kind", "chapter", "when": [conditions, all must hold], "priority", "once", "speaker", "picture", "text" or "pages": [{"text", "picture"}]}.
## Kinds: frame · beat · discovery · letter · moment · visit · scene · bark · trace. This script only decides WHAT may be shown and WHEN;
## showing it (the story box, the speech bubble, the 📜 scroll) is the interface's job (game/farm/ui/storybox.gd).

const KINDS := ["frame", "beat", "discovery", "letter", "moment", "visit", "scene", "bark", "trace"]   # priority order: first wins
const RATIONED := ["moment", "visit", "letter"]       # unprompted pieces: at most one per `RATION_STEPS` Time Quiz questions
const RATION_STEPS := 3
const BARK_COOLDOWN := 12                              # a bark does not come back within this many questions

var G: FarmGame   # the Game: the farm's state (G.S), its data and the other systems

func _init(game: FarmGame) -> void:
	G = game

## The save keys this system owns, with their values in a new game (kits/core/saves.gd fills missing ones into older saves).
func save_defaults() -> Dictionary:
	return {"story_seen": {}, "story_taps": {}, "story_last": -99, "story_bark": {}}

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
		if G.S["step"] - int(G.S["story_seen"][id]) < int(p.get("cooldown", BARK_COOLDOWN)): return false
	return G.cond_all(p.get("when", []))

## The pieces ready now, the one to show first at the front: by kind, then by priority, then by the order of the data;
## a bark that was seen longest ago comes before one seen lately. Rationed kinds wait out their three questions.
func ready() -> Array:
	var out := []
	var rationed_out: bool = G.S["step"] - int(G.S["story_last"]) < RATION_STEPS
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
