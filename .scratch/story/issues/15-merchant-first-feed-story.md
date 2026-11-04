# 15: Feeding the travelling merchant the first time gets a story box with a picture, right after the hand-over

**What to build:** The first time the child hands over the porridge to the travelling merchant, a story box with a picture appears right at that tap, not later when the player taps Back home.

**Blocked by:** `interruption-queue/04` (the new box is one more kind in the queue's order list)

**Status:** done

**Milestone:** prototype

- [x] A story piece with text (EN, DE) exists for the first successful feeding
- [x] It opens right after the hand-over tap, before the square is left
- [x] It has a picture (listed in `pictures/10`; stand-in until then)
- [x] Story test covers the trigger and `once`

---

**Feature:** `story` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.41]. Filed 23 October 2026.

The parent's words:

> [#23.41] stuff like successfully feeding the traveling merchant needs story text and a picture. Each story text needs a picture. We can make a list of necessary pictures with the characters, places and objects that should be visible in them. Also, the story text for feeding the merchant the first time should pop up right after you tap the "hand over the porridge" and not as you tap the back home button, that's to late.

## Result (3 Nov 2026)

Built: `c1_seller` is now a Scene (new story kind in the queue, `scene`, in `rules/65-feel.json`): it opens over the village square right after the *Hand over* tap on the first porridge, not at *Back home*. It is not rationed, shows once, and has the picture name `market_stall` (stand-in picture until `pictures/10` has a painted one). Each queue kind has its own source so a waiting story box does not hold the Scene back. Dev flag `--handover=d_porridge` makes the screenshot. Tests: story test (ready the moment the delivery is done, once), interruption test (Scene over the square, other box after *Back home*).

Checked: story test 40 checks, interruption test 142 checks, short golden runs identical. Screenshots `/home/claude/patches/story-shots/15-merchant-en.png`, `15-merchant-de.png`.

Play-test: tap Hand over on the first porridge: the box should come at once, and Back home should go straight back to the farm.
