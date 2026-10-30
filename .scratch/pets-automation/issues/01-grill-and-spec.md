# 01: Grill and spec: pets do the farmer's chores (automated chores)

**What to build:** Settle with the parent how a pet can be set to do the farmer's chores, then write the spec and the build tickets. An **automated chore** (see `GLOSSARY.md`) costs the farmer the effective cost, exactly as if the farmer had done it. It is separate from a **blessing**, the free work a pet does out of grace. Questions to grill: which chores can be automated; how the child sets it up and picks when it runs (the WHEN cards of the pets' levels 3–4 are the nearest thing); what happens when the farmer has too little energy at that moment; how it shows in the playback; whether the farmer's skill practice and tool wear apply (the parent chose "same effect, no farmer extras" for now; the reason to keep the extras off is that the farmer did nothing, the reason to keep them on is that the farmer paid); whether it makes the child's own play pointless and how to prevent that.

**Blocked by:** `farm-actions/13` (the module must be in place: check and perform take the doer as an input)

**Status:** needs-parent

**Milestone:** prototype

**Size:** sitting

- [ ] `/grill-with-docs` run with the parent
- [ ] `spec.md` written in this folder from the `/to-spec` template
- [ ] Build tickets filed in this folder with `/to-tickets`
- [ ] `GLOSSARY.md` has the final word for an automated chore (the name is not final)

## 💡 Recommendation (30 Oct 2026)

Grill it after `condition-language`: a pet's automated chore is a farm-actions chore plus a condition (when to do it), so both modules should exist first.

---

**Feature:** `pets-automation` · **Source:** the `farm-actions` grilling, round 3 (`.scratch/farm-actions/issues/01-grill-and-spec.md`), 23 October 2026. Today the pets' "jobs" are blessings with their own effects (weeds, stones, pests, water, makes) and do not use the farmer's chores.
