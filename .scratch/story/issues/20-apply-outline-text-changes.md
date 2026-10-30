# 20: Decide and apply the story text-change requests

**What to build:** Go through the 55 rows of `story/game/text-change-requests.md` (frame 0, the chapter 2 letter, the telling in two halves, the supper, frame 6 and more), accept or strike each, and change `story/game/texts/` and the staged pieces for the accepted ones, English and German. Overlaps `story/10` (fire cause reword) and `story/08` (I15): do them together.

**Blocked by:** `story/19` and a play-test of the game with the child

**Status:** done

**Milestone:** story


- [ ] The parent has marked each row accept, strike or later
- [ ] Accepted rows are applied to the texts and the staged JSON; German written; `tools/i18n.py` coverage passes
- [ ] Smoke test and bot pass

## 💡 Recommendation (30 Oct 2026)

Close it: the novella replaces every current piece (story ADR-0001), so editing the stand-in texts row by row is wasted work. Keep the file for reference when compressing the novella.

## ✅ Parent's answer (30 Oct 2026)

Closed without building: the novella replaces every current piece (story ADR-0001). `story/game/text-change-requests.md` stays as reference for the compression.

---

**Id:** story outline · **Feature:** `story` · Source: the story outline run, 24 Oct 2026.
