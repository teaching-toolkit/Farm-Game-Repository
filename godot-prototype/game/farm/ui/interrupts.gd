extends RefCounted
class_name FarmUiInterrupts
## What takes the screen next on the farm (interruption-queue): sets up the interruption queue (kits/ui/interruptions.gd) with the
## order list in data/farm/rules/65-feel.json ("interruptions"), tells it how to ask whether a screen is busy, and hands it the lists
## kept elsewhere (the saved postcards, the story's next ready piece). Parts that want the screen hand their interruption over here (`celebration`, `note`) and
## never check each other's state. `request()` pumps once at the end of the frame; `pump()` now.

const Interruptions = preload("res://kits/ui/interruptions.gd")

var M: FarmMain   # the main screen: its widgets and the other parts
var G: FarmGame   # the rules (G.<system>.<function>)
const STORY_KINDS := ["discovery", "scene", "story", "bark"]      # the kinds the story box hands the queue (story.candidate, one source each)

var q = Interruptions.new()
var _notes := 0

func _init(main: FarmMain) -> void:
	M = main
	G = main.G
	q.configure(G.meta.get("interruptions", {}).get("order", []))
	# the busy screens (their meaning: "busy" in the order list)
	q.watch("popup", func(): return M.modal.visible)
	q.watch("rest", func(): return not M.rest_state.is_empty())
	q.watch("playback", func(): return M.playback.held)
	q.watch("catchup", func(): return M.playback.playing)
	q.watch("sheet", func(): return M.sheet.visible)
	q.watch("bubble", func(): return M.story.bubble_count() > 0)
	# lists kept elsewhere: a postcard waits in the save (G.rewards), the first one shows; the story's next ready piece (G.story)
	q.source("postcards", _postcard)
	for k in STORY_KINDS: q.source("story:" + k, M.story.candidate.bind(k))      # one source per kind: a Scene is not held back by a waiting box
	q.source("news", M.story.news_candidate)      # a box worth attention that is not a story piece (G.story.announce: seasons, acorns …)
	for n in q.unknown_names(): push_error("interrupts: the order list waits for '%s', which is neither a kind nor a watched screen" % n)
	for b in G.meta.get("interruptions", {}).get("busy", {}):
		if not b in q.watched(): push_error("interrupts: the busy screen '%s' of the order list is not watched" % b)

func _postcard() -> Dictionary:
	var pc: Dictionary = G.rewards.postcard_pending()
	if pc.is_empty(): return {}
	return {"kind": "postcard", "key": "%s@%d" % [pc.get("from", ""), int(pc.get("step", 0))], "show": M.gifts.show_gift}

## Something new was built or made: its big pop-up, once, in its turn.
func celebration(id: String, show: Callable) -> void:
	if q.submit("celebration", id, show): request()

## A short note for when the pop-up closes (a Rest medal …).
func note(text: String) -> void:
	if text == "": return
	_notes += 1
	if q.submit("note", str(_notes), M.notes.toast.bind(text)): request()

func waiting(kind: String) -> int:
	return q.waiting(kind)

func request() -> void:
	q.request()

func pump() -> Array:
	return q.pump()

## Shows only story pieces (a box, a Discovery or a bark) if it is their turn; the rest stays in line. True when one was shown.
## The start of a new game asks this before its welcome: anything else waiting comes after the welcome, as before.
func pump_story() -> bool:
	for key in q.pump(STORY_KINDS):
		if not G.story.piece(str(key)).is_empty(): return true
	return false
