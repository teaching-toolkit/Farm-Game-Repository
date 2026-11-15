# 04: The child sets a pet to help, and sees it work

**What to build:** In a pet's window a second group "Helps with" lists the pet's chores with the ⚡ symbol (no number, German "Hilft bei"); choosing one takes the pet's rule slot like a blessing. From level 3 the chore has a WHEN card whose default is "only when my energy is above …" (a slider). A waiting pet shows 💤 and the reason in words. In the playback the pet walks to the place, the chore's own effect happens there and the chore's emoji shows over the pet. Screenshots: the window with a chore chosen, a pet at work, a pet waiting tired.

**Blocked by:** `pets-automation/03`

**Status:** done

**Milestone:** prototype

- [x] The pet's window shows blessings and chores in two groups; a chore can be chosen as a pet's first or second rule
- [x] The WHEN card for a chore: energy above a slider, default leaves a third of the bar
- [x] The playback shows the pet at the patch or pen with the chore's emoji; a waiting pet shows 💤 with its reason
- [x] No number is shown to the child; every new text through `tr()` and German ("ss", never "ß") via `i18n.py`
- [x] Screenshots as above (window with a chore chosen, tired pet, pet at a patch; the pen walk is checked by node state); smoke test passes (`check_all.sh --short` runs once at the end of the wave); `docs/design/progression.md` §10.3 and `map-and-interface.md` describe it

---

**Feature:** `pets-automation` · **Spec:** `../spec.md`. Filed 15 November 2026.

## Result

Built in two slices (15 Nov 2026, Sonnet agents, checked by the main chat). **Rules (04a):** chore jobs are no longer hidden and not in `jobs_of`; the WHEN card `energy` (default a third of the bar, `choose` sets it for a chore when the WHEN was "always", a blessing puts an untouched default back); the act carries the chore's emoji and the pen's `aid`. **The child's side (04b):** `ui/places/home.gd` `_chore_group` (the "⚡ Helps with" group under the blessings and under OTHERWISE), the 💤 "waiting for you to rest" line, the energy card renamed "My energy" (so the row reads "⚡ My energy ≥ 13"), the energy "+" stops at the bar's size; playback places `water` and `pen` (`feedback.gd` `pen_place(aid)` through `Spots.spot_of`, the coop as fallback); the 12 chore names are bare words (German Unkraut, Aufraeumen, Wasser holen, Schnee, Steine, Ausmisten, Einsammeln); launch flags `--petjob=<pet>:<job>`, `--petwhy=<why>`, `--petstep` (one step with the playback) in `dev_flags.gd`. **Found on the way and fixed:** the `--gate` line in `dev_flags.gd` ended in an inline `if` that swallowed every later `elif` (so `--pets`, `--lord` and others never ran); it is now on its own line. Checks: ui_smoke clean (new `_pet_chores`), `pets_test` 107 checks, `check_data` 0 errors, `i18n --check` ok, golden short identical (228 and 250 steps). The bot's use of chore jobs and the numbers are `pets-automation/05`.
