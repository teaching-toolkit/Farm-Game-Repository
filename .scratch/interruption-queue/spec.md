# Spec: what takes the screen next (the interruption queue)

**Status:** done (3 Nov 2026; built in `02`–`04`)

Words are in `GLOSSARY.md` (interruption, quiet, postcard, chore). Background: the architecture review of 22 October 2026 (Part B,
candidate 4) and the grilling in `.scratch/interruption-queue/issues/01-grill-and-spec.md` (two rounds, parent's answers of
2 Nov 2026). **It is a refactor: nothing changes for the child, and the golden runs stay identical** (the bot draws no interface).
The story-timing fixes C2, C7 and C8 come after it, in `story/07`, as numbers.

## Problem Statement

Several things arrive on their own and want the screen: the celebration of something new, a postcard, a story box, a bark, the notes
after a pop-up closes. Each decides for itself whether it may show, by reading the others' state (is a pop-up open, is the Time Quiz's
playback holding the screen, is Rest open, is a celebration or postcard waiting, is a sheet open). The order between them is one
`if / elif` at the end of closing a pop-up, and the story box has its own six-part "is it quiet?" check. Tuning the story's timing
(C2 pile-ups at chapter turns, C7 barks waiting, C8 delays of up to 15 questions) means editing several parts and reasoning about how
they poll each other. The story tickets `story/13`, `14` and `15` would each add a new kind of box, and with it another flag to every check.

## Solution

One interruption queue on the interface side. Anything that arrives on its own submits a request (its kind, a key, how to show it).
The queue alone knows what is showing, the order of the kinds, what each kind waits for, and so when it is quiet. The screens the child
opens herself and the farm's catch-up animations only tell the queue that they are busy or done. The order and the waiting rules are one
list in `rules/65-feel.json`, today's order unchanged. `G.story` still decides which story piece is ready and how often (one unprompted
piece per 3 questions); the queue decides only when it shows.

## User Stories

1. As the child, I want everything to come in the same order and at the same moments as before, so nothing I know changes.
2. As the child, I want a celebration or a postcard never to cover a question I am answering, and never to be lost while the game runs.
3. As the parent tuning the story, I want the order of interruptions and what each waits for in one list of numbers and names, so fixing
   C2, C7 and C8 is a change in one place.
4. As a session building `story/13`, `14` or `15`, I want to add a new kind of box with one line in that list and one call, without
   touching the other kinds.
5. As anyone checking a change, I want to see the order of a pile-up (a chapter turn with a celebration, a postcard and two story
   pieces) in a test that draws nothing.

## Implementation Decisions

- **What the queue owns (interruptions):** celebrations (buildings, tools, Helpers, perks), postcards, story boxes, barks, the notes
  after a pop-up closes; later the boxes of `story/13–15`.
- **What only counts as busy:** the screens the child opens (Time Quiz, Rest, cards, sheets, menus, the welcome and name screens) and
  the farm's catch-up (the Time Quiz playback). They tell the queue when they open and close; the queue never reads their flags.
- **Outside the queue:** the flights of harvests to the store and the farm news playback (animations, settled in `time-question/06`).
- **The order list** in `rules/65-feel.json`: one entry per kind with its place and what it waits for. Today's behaviour, to be kept
  exactly: notes after a pop-up first (they never block); then a postcard; then a celebration; then a story box; a bark last and only
  when no other bubble is showing (a bubble blocks nothing). A celebration or postcard may come over an open sheet; a story box waits
  for the sheet to close unless it is a Discovery; nothing comes while a pop-up, Rest or the playback is busy.
- **Split with `G.story`:** which piece, its rank among story kinds, the ration and the bark rest stay in `G.story`. The queue asks
  `G.story` for the next piece only when a story box or bark could show.
- **Not saved.** Owners keep what must survive a restart (a waiting postcard in the rewards, story readiness in `G.story`). A
  celebration waiting when the game closes stays lost, as today (`interruption-queue/05`, later).
- **One kind per call site.** A part that wants the screen calls the queue once; the `if / elif` after closing a pop-up and the story
  box's own quiet check are gone. The queue never draws: each request carries how to show itself.

## Testing Decisions

- **One seam: the queue without drawing.** Requests in; told when a busy screen opens or closes; asked what shows next.
- **New headless test** `tests/interruption_test`, in `check_all.sh`: today's order for each pair of kinds; the real pile-ups (a chapter
  turn with a celebration, a postcard and two story pieces; a walk with news and a celebration); a sheet lets celebrations and
  postcards through and holds story boxes except a Discovery; a bark waits for another bubble only; nothing shows while busy; the same
  key submitted twice shows once; the order list in the data is read and every kind in it is known.
- **Unchanged on screen:** smoke test, EN/DE screenshots of a celebration, a postcard and a story box, before and after.
- **Golden runs** short and full identical; data checks; old saves load (no save change).

## Out of Scope

- Fixing C2, C7 and C8 (`story/07`), and the other story-timing issues.
- The new boxes of `story/13–15` (they add their line when they are built).
- Keeping a waiting celebration across a restart (`interruption-queue/05`).
- The farm news playback and the flights to the store.

## Further Notes

Facts found in the code (2 Nov 2026), for the builder:
- The order: `ui/modals.gd` `_after_close()` (store flights, notes, then postcard, else celebration, else story pump); it runs after the
  playback when the Time Quiz closes.
- Celebrations: `ui/celebrations.gd` `celebrate()` (dedupes by id, shows at once when no pop-up is open) and `show_celebration()`;
  the list is `main.gd` `celebration_queue`.
- Postcards: `ui/gifts.gd` `show_gift()`, called from the `offer_cards` signal, from `_after_close()` and on start (`main.gd`); the
  waiting postcards are saved in `G.S["gift_pending"]` (`systems/rewards.gd`).
- Story: `ui/storybox.gd` `queue_pump()` / `pump()` / `_quiet()`; called after every refresh and after a pop-up closes; at step 0
  `pump()` returning false shows the welcome instead (keep this).
- Busy flags read today: `M.modal.visible`, `M.playback.held`, `M.rest_state`, `M.sheet.visible`, the sticky bubbles in `M.toasts`.
- Notes after a pop-up: `main.gd` `after_close` (filled by Rest medals, rain …).
