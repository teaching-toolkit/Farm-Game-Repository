# 07: I14: Story shows up late: fix the timing issues C1–C9

**What to build:** The story timing problems found on 14 October (chapter gate, pile-ups at chapter turns, the chapter 5 low point that cannot fire, no negation, missing terms for pests, rain and energy, bark density, `pet_alpaca` before the garden) are fixed. The data-only retimes need the parent's yes. C5 and C6 need the new condition language; C2, C7 and C8 may be tuned in numbers or solved by the interruption queue.

**Blocked by:** `condition-language/01` (for C5 and C6); `interruption-queue/01` (for C2, C7 and C8)

**Status:** needs-parent

- [ ] The parent has said yes or no to each data-only retime in `story/code-issues-story-timing.md`
- [ ] Story windows in general no longer show up too late ([#23.9]): measured with the bot's longest silence per chapter and checked on the iPad
- [ ] C1, C3, C4 and C9 are fixed
- [ ] C5 and C6 are fixed through the condition language
- [ ] C2, C7 and C8 are fixed (numbers or queue)
- [ ] A story test and the bot pass; the chapter 5 low point fires

---

**Id:** I14 · **Feature:** `story` · **Moved from** `TODO.md` §15 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **I14. Story shows up late: code and data issues** 💡 found 14 Oct 2026; C1–C9 in `story/code-issues-story-timing.md` (chapter gate, pile-ups at chapter turns, the ch5 low point cannot fire, no negation, missing terms for pests/rain/energy, bark density, `pet_alpaca` before the garden). The data-only retimes are listed there and not applied. Needs the parent's yes. Consistency pass 14 Oct 2026: the `c4_frame4` re-key was dropped (it would tie the chapter frame to an optional favour, F-089), and a node's `chapter` is a label, not a gate (noted in the file).
