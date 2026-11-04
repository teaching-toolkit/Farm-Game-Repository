# 05: A celebration waiting when the game closes shows after loading

**What to build:** If the game closes while a celebration of something new is still waiting for its turn, it shows after the game is
loaded again, instead of being lost. Today it is lost (rare: it shows as soon as a pop-up closes).

**Blocked by:** `interruption-queue/04`

**Status:** needs-parent

**Milestone:** later

**Size:** quick

- [ ] A waiting celebration is kept in the save and shows after loading, once
- [ ] Old saves load; save fixtures pass

## 💡 Recommendation (2 Nov 2026)

Build it as described, but only when the prototype stands: it is rare and nothing is lost but the confetti. Alternative: drop it.

**Feature:** `interruption-queue` · **Source:** grilling round 2, question 5 (`01-grill-and-spec.md`). Filed 2 Nov 2026.
