# 02: M5: Carrying grows with strength; boots and a borrowed donkey make trips cheaper

**What to build:** How much the farmer can carry also depends on strength, and the trip's energy gets cheaper with boots or a borrowed donkey (a favour). Today only the carrying device and the road count; strength is not used in the trip at all. The notes also hold a 💡 question (does the room count each way separately?); if the parent is there, ask it first.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] Strength (from the wellbeing model) raises carrying capacity
- [ ] Boots lower the trip's energy cost; a borrowed donkey does too, as a favour from someone helped
- [ ] The each-way question is answered and what the game does is written down
- [ ] Pace re-checked with the bot (trips); golden runs identical or re-recorded on purpose
- [ ] German through `tools/i18n.py`; the data checker passes

---

**Id:** M5 · **Feature:** `money-market` · **Moved from** `TODO.md` §7 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **M5. Carrying and the trip's energy** [#1], [#2]: how much the farmer can carry depends on the carrying device (backpack → basket →
  cart; the existing carrying gear for gathering can count too), and on **strength** (L2). The trip's energy is a farmer number too: a
  flat cost that gets cheaper with a better road, a better cart, boots, strength, or a borrowed donkey (a favour). Later: the wheelbarrow,
  the hand cart, the **pony** (job card "carry surplus to market and sell it", S2).
  💡 The room counts **each way separately** (a full load there, a full load back), the same size both ways (proposed in R1; the
  answer reshaped the trip and didn't say; confirm when D1 is written).
