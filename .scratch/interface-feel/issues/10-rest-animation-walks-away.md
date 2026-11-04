# 10: Rest: the farmer walks to the tent or house, disappears for a moment, and comes back

**What to build:** When Rest starts, the farmer walks to the tent or house and is gone for a moment; when Rest ends he walks out again. (J3 made him walk there; he does not yet vanish and return.)

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The farmer disappears at the door and reappears after the Rest window closes
- [x] A tap skips the animation; timing is data
- [x] Smoke test checks the farmer is back and visible afterwards

---

**Feature:** `interface-feel` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.27]. Filed 23 October 2026.

The parent's words:

> [#23.27] the animation for rest should be the farmer going to the tent/house and dissappearing for a moment and the reappearing

## Result (3 Nov 2026)

Built: the Rest button (energy bar, 😴 Rest in the tent or house) sends the farmer to the tent or house; when he is there (at least
`rest.walkMin` 0.4 s, at most `rest.walkMax` 1.6 s, then he is put at the door) he fades into the door (`rest.vanish` 0.35 s) and
the Rest window opens. When the window closes he stays inside `rest.inside` 0.3 s, appears at the door (`rest.appear` 0.35 s) and
walks `rest.stepOut` 22 pixels out. A tap anywhere during the walk opens Rest at once; a tap while he comes out shows him at once.
All six numbers are in `rules/65-feel.json` (`feel.rest`). The code is in `game/farm/ui/rest.gd` (`go_rest`, `come_back`, `skip`);
`modals.close_modal` calls `come_back` (any pop-up that closes while he is inside brings him out). New screenshot flag `--gorest`.

Agent's choices: he fades rather than snaps (easy to change: `vanish`/`appear` = 0); the tap catcher lies under the pop-up, so a
box that opens meanwhile still gets its taps; the old "sit to rest" act in `data/acts.json` is no longer played by Rest (kept as data).

Checked: smoke test new lines "rest farmer: hidden while resting true, still inside just after closing true, back and visible after
true" and "rest skip: … true … true"; all unit tests pass; golden short runs identical (seed 1: 332 steps, seed 2: 525 steps);
data checks 0 errors; screenshots `/home/claude/patches/places-shots/rest-walk-*.png` (he stands at the tent, then Rest opens).

Play-test: does the fade into the tent read as "he went inside"? Is 0.3 s inside after closing too short or too long?
