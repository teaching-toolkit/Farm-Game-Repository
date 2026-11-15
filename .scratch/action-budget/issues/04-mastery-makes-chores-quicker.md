# 04: Skill ranks make chores quicker

**What to build:** Each rank of a skill family takes one moment off that family's middle and heavy chores, never below 1, so a master gets more done in a step than a beginner.

**Blocked by:** `action-budget/02`

**Status:** done

**Milestone:** prototype

- [x] The rule is one modifier in the actions module, with its numbers in the skills rules
- [x] The chores test checks a beginner and a master on one middle and one heavy chore
- [x] The skill's window shows it without numbers (a small clock that gets smaller per rank)
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; `docs/design/time-quiz.md` and `energy-and-wellbeing.md` describe it

---

**Feature:** `action-budget` · **Spec:** `../spec.md`. Filed 14 November 2026.

**Done 15 Nov 2026** (Sonnet agent; checked by the orchestrator): `"momentsPerRank": 1` in `data/farm/rules/48-skills.json`, applied inside `moments_of` (chores of 2 or more moments of a `practice` family lose one per rank, never below 1). The skill's window shows a 🕰️ per rank earned and the line "Quicker with every rank" (German "Mit jedem Rang schneller"), no numbers. The chores test checks a beginner and a master on one middle and one heavy chore.
