# 01: Grill and spec: pets do the farmer's chores (automated chores)

**What to build:** Settle with the parent how a pet can be set to do the farmer's chores, then write the spec and the build tickets. An **automated chore** (see `GLOSSARY.md`) costs the farmer the effective cost, exactly as if the farmer had done it. It is separate from a **blessing**, the free work a pet does out of grace. Questions to grill: which chores can be automated; how the child sets it up and picks when it runs (the WHEN cards of the pets' levels 3–4 are the nearest thing); what happens when the farmer has too little energy at that moment; how it shows in the playback; whether the farmer's skill practice and tool wear apply (the parent chose "same effect, no farmer extras" for now; the reason to keep the extras off is that the farmer did nothing, the reason to keep them on is that the farmer paid); whether it makes the child's own play pointless and how to prevent that.

**Blocked by:** `farm-actions/13` (the module must be in place: check and perform take the doer as an input)

**Status:** done

**Milestone:** prototype

- [x] `/grill-with-docs` run with the parent (instead: Claude's recommendations on the parent's standing permission, 15 Nov 2026, written in `../spec.md`; each is data or one rule and can be changed after the first play-test)
- [x] `spec.md` written in this folder from the `/to-spec` template
- [x] Build tickets filed in this folder with `/to-tickets` (`02`–`05`)
- [x] `GLOSSARY.md` has the final word for an automated chore (builders: *automated chore*; the child's text: "Helps with", German "Hilft bei")

## 💡 Recommendation (30 Oct 2026)

Grill it after `condition-language`: a pet's automated chore is a farm-actions chore plus a condition (when to do it), so both modules should exist first.

## 💡 Order (14 Nov 2026)

Grill this after `action-budget` is built and play-tested: the budget decides what a pet's help is worth (an automated chore costs the farmer's energy but none of the farmer's time), and most of the open questions here answer themselves once the child has felt time run out. Claude prepares the summary then; nothing to do for the parent now.

---

**Feature:** `pets-automation` · **Source:** the `farm-actions` grilling, round 3 (`.scratch/farm-actions/issues/01-grill-and-spec.md`), 23 October 2026. Today the pets' "jobs" are blessings with their own effects (weeds, stones, pests, water, makes) and do not use the farmer's chores.

## ✅ Decided for the parent (15 Nov 2026)

All of it is in `../spec.md`. In short: a pet can help with one of seven care chores (weeds, stones, loose things, water, snow, muck, collecting from the pens); the farmer pays the energy, never moments, so a pet gives *time*; one chore per pet per question; a rule is a blessing **or** a chore; the WHEN card (level 3) protects the farmer's energy; same effect, no farmer extras; planting, harvesting, cooking and the forest stay the child's. 💡 Change any of it after the first play-test (`pets-automation/05`).
