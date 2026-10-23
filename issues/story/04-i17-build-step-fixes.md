# 04: I17: Apply the build-step fixes the consistency pass could not make

**What to build:** The ten text and data fixes listed in the notes are applied in the game: the village hall roof (with 🔔), the German greeting without a gender, the Lord's share easing once Quill answers, two missing pieces in chapter 2, and the small wording fixes.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] F-072, F-073, F-075, F-078, F-079, F-080, F-081, F-082, F-083 and F-097 are applied as worded in `story/consistency-fixes.md` §5
- [ ] German through `tools/i18n.py`; checks, smoke test and bot pass
- [ ] Each fix is marked APPLIED in `story/consistency-fixes.md`

---

**Id:** I17 · **Feature:** `story` · **Moved from** `TODO.md` §15 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **I17. Build-step fixes the consistency pass could not make** 💡 (14 Oct 2026; exact files and wording in `story/consistency-fixes.md` §5): `sq_chapel_roof` to "Fix the village hall roof" with 🔔 (node, German, picture prompt; F-072); German greeting in `c2_greenstem` without a gender (F-073); `lord.gd` `fraction()` eases the share when `c6_quill_answer` is seen (F-075); add `c2_berit_note` and `c2_k_rest` to `texts/ch2.md` (F-078); `c1_seller` "on the track by your field" (F-079); `c2_cottage` "thatch"/„Strohdach“ (F-080); `c2_greenstem` `+ seen:c2_walls` (F-081); `c4_no` "your best field" (F-082); cut a line from `c6_free_garden` (F-083); `c6_ajar` gets "a very small light goes out" (F-097); then the data edits that follow the parent's answers (Q5–Q10).
