# 02: What do rocks and weeds really do to a field? Decide if they should cost crops

**What to build:** The parent noticed that rocks and weeds do not seem to change the number of crops. They don't: in the code they slow growth (each weed and each stone by 4 %, down to half speed at worst), lower the grade of the whole harvest, and cost energy to clear. The number of plants is not affected. Decide whether they should also reduce the yield, or something else should hinder the player.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** prototype

- [x] The parent has decided: keep as is, or also reduce the number of plants (and by how much)
- [ ] Whatever is decided is shown to the child (the patch's note says what the weeds and stones cost)
- [ ] If the rules change: numbers in data, bot and golden runs re-checked, German

## ✅ Parent's answer (30 Oct 2026)

Swap: weeds and stones no longer slow growth; each one takes **4 % of the harvest, at most 75 %**. The effect on the grade stays. **Don't rely on reading:** the loss must be *seen*, not written: for example fewer plants drawn on a crowded patch, and at harvest the lost crops shown leaving or greyed out next to the weeds and stones. Text may follow, but the picture carries it.

---

**Feature:** `crops-and-items` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.13]. Filed 23 October 2026.

The parent's words:

> [#23.13] rocks and weeds don't seem to influence the number of crops growing on a field right now, do they only influence the speed of the growth or how do they hinder the player?
