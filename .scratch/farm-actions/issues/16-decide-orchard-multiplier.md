# 16: Decide: the orchard tree energy multiplier

**What to build:** Orchard trees use a different energy multiplier from the other field chores. Decide: keep it as a rule of the game, or unify it with the others.

**Blocked by:** farm-actions/13

**Status:** ready-for-agent

**Milestone:** refactor

- [x] A 💡 recommendation is written in this ticket
- [ ] The parent decided (✅ 30 Oct); the data entry matches
- [ ] If changed: full golden runs are re-saved on purpose and explained in the log

## 💡 Recommendation (30 Oct 2026)

**Unify it.** Cutting an orchard tree then gets cheaper with the same field upgrades and skills as every other field chore, which is
what a child expects. It removes the module's only special case (`no_mult`). The full golden runs change slightly and are re-saved on
purpose.

Other option: keep it as a rule ("orchard trees are hard work whatever your tools"). Only worth it if you meant that; nothing in the
design says so, and it is invisible to the child.

## ✅ Parent's answer (30 Oct 2026)

Yes: unify it with the other field chores. Full golden runs re-saved on purpose and explained in the log.

---

**Feature:** `farm-actions` · **Source:** `.scratch/farm-actions/spec.md` in this folder and the decisions in `.scratch/farm-actions/issues/01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
