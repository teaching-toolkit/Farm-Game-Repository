# 18: Decide what happens to the story pictures that were left out of the first import

**What to build:** Every story picture that `story/17` left out either shows on its piece, is regenerated, or is dropped, on the parent's word. Then the mapping is complete for everything the review called good.

**Blocked by:** None (can start immediately); the regenerated ones also belong to I11 (`story/06`)

**Status:** ready-for-agent

**Milestone:** story

What the parent has to decide (each with a 💡 recommendation):

- [ ] **The Lord's letter, the red seal with a stag (`c5_letter`).** The stag is not in canon. 💡 Regenerate without the stag (the `c6_lord` picture is already made without one); until then the piece shows no picture.
- [ ] **The alpaca at the gate (`c6_alpaca`).** A goat in the picture wears a collar bell, and the rule is no visible collar bells on animals. 💡 Regenerate with the existing picture as the reference, as for the other bell fixes.
- [ ] **Wren after the poisoning (`c5_poison`).** The picture shows Wren angry over spilled herbs on the still-room floor; the text is Wren at your bedside after you were poisoned. 💡 Use it on the page that fits better, or regenerate a bedside scene; the review had called it a fit.
- [ ] **The goat chewing the list (close-up).** It fits no piece today (`c3_goat` has its own picture waiting to be fixed). 💡 Use it for `c3_goat` once that picture is regenerated without the bell, or drop it.
- [ ] **The "no piece" scenes (about 25 everyday scenes), the two holds and the three end-of-story views.** 💡 Leave them out of the story box for now; they could become the picture of a favour or a season box later.
- [ ] Once each has an answer, the mapping in `tools/story_pictures.json` is updated and the import run again (`--force` is not needed)

## ✅ Parent's answer (14 Nov 2026)

"Yes, you can do this now that the openart loop works": every 💡 above is taken. Found the same day: the Lord's letter without the stag and the alpaca without the bell were already generated on 12 Oct 2026 (the regeneration queue, 38 pieces, two versions each) and never downloaded; all 76 files are now in `art-inbox/alternatives/story-<piece>/`. Still to generate: Wren at the bedside.

---

**Id:** none · **Feature:** `story` · **Where it came from:** `story/17` (the questions it left over); the review in `art-inbox/Story pictures/picture_review.csv`.
