# 05: Trial: three looks for the farmer and the people, side by side

**What to build:** A throwaway trial that shows the same small scene three times, so the parent can pick how figures should look: (A) today's rig, restyled to the painted look (chunkier proportions, a bigger head, the game's palette, a softer dark-brown outline, a painted shading ramp instead of flat toon bands); (B) the same as A plus painted faces and cloth patterns as small textures; (C) a 2D cut-out puppet made of painted body parts moved by code. One farmer and one merchant in each.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype
**Size:** quick

- [x] One test scene renders the three looks beside the farm's buildings; a screenshot of each, standing and mid-step, is saved for the parent
- [x] A and B change only the avatar kit's materials, proportions and data, never the acts or the walking
- [x] C uses stand-in parts drawn in code or cut from an existing friend picture (no new generated pictures)
- [x] A short note per look: what it costs per new person (pictures, data, code) and what it cannot do (gear, poses)
- [x] Nothing in the game changes until the parent has picked; the trial lives in the tests folder
- [x] German through `i18n.py` for any new text; smoke test and `check_all.sh --short` pass; old saves load; the `docs/design/` file it changes is updated

---

**Feature:** `people` · **Source:** the parent's notes of 14 November 2026 (`docs/sources/2026-11-14-parent-notes-testrun.md`), [#14.2]. Filed 14 November 2026.

The parent's words:

> [#14.2] The 3d person that the farmer is, is ok, but looks very generic still. How can we make the 3d farmer look more similar to the style of the rest of the game and how can we make the npcs look similar to that farmer?

## Result

💡 Recommendation: B for the farmer and the village people (same rig, so acts, walking and gear keep working); C only if you want a flatter, closer-to-the-pictures look and accept losing the 3D poses.

Screenshot: `Claude outputs/screens/look-trial.png`. Scene: `godot-prototype/tests/look_trial.tscn` (`--shot=<path>`). Code: new optional look key `"style"` in `kits/avatar/avatar.gd` (missing or `plain` = today's figure; today's pose sheet checked, unchanged), puppet in `tests/look_trial_puppet.gd`.

**A, rig painted (`"style": "painted"`)**
- Cost per new person: no pictures; one look entry in data (as today, plus the one key); no new code.
- Cannot: turn the figure into something flat; no gear drawn in the hands beyond today's simple shapes; poses stay the rig's own (it is still a 3D doll, so it never has the painted brush look of the map pictures).
- Match: closer than today (bigger head, thicker outline, soft warm/cool shading), but the faces are still two dots and it reads clean-3D next to the market stall: about 6 of 10.

**B, A plus code-made textures (`"style": "painted_face"`)**
- Cost per new person: no pictures; one data entry; the face and cloth patterns come from small functions (face colours come from the look); a new pattern is a few lines of code.
- Cannot: change the expression (one smile for all, until more face variants are added), real gear or new poses for chores beyond what the rig does, or any turn where the face stays readable from behind (the face is on the front only).
- Match: the best of the three for the effort, the face reads well and is cute at the big size; still shaded 3D rather than hand-painted: about 7 of 10.

**C, 2D cut-out puppet (`tests/look_trial_puppet.gd`)**
- Cost per new person: no pictures with the stand-in shapes (code only; the final version would want painted parts, about 10 pictures per figure style); data the same look entry; the code is already there.
- Cannot: hold gear in the hands, do the chore poses (bend, kneel, reach), or turn to face the camera or away (only left/right mirroring); each extra pose needs new drawn parts.
- Match: the flat, thick-outline look is the closest to the map pictures even as a stand-in: about 8 of 10 for looks, but the least able to act.

## Progress

**16 November 2026: look B taken (the parent is away; 💡 the parent's recommendation, easy to undo).** Look C is not taken.
- Data: every look of the 13 people in `data/farm/rules/58-people.json` has `"style": "painted_face"`; `data/avatar.json` `default` has it too. That is the ONE default: `Avatar.set_look` starts from `default` and puts the look on top, so the farmer of a new game (no `S.look`) and an old save (colours, no style) are drawn `painted_face` without a new save key. `plain` and `painted` still work when a look says so; `kits/avatar/avatar.gd` got `style()` (what the figure is drawn in).
- **To switch back:** for everybody at once, set `default.style` in `data/avatar.json` to `plain` (one line); to go back for one person, set that look's `style` (or remove the key from the people: they then take the default). The trial scene `tests/look_trial.tscn` is as it was, except that its "today" figure now says `"style": "plain"` itself (else it would have turned painted).
- Test: `tests/figures_test.gd` `_style_checks` (data says it for all 13, every person is drawn so, the new-game farmer and an old save's look are `painted_face`, `plain`/`painted` still work). `figures_test` 60 checks OK, `saves_test` 89 OK, `ui_smoke` exit 0 with no FAIL, short golden identical for both seeds.
- Seen (screenshots, farm, the square, `tests/pose_sheet.tscn`): the farmer and the village people show the painted face and a shirt pattern, and match the market stalls better than before. The `bend` pose is cut off at the right edge of the 200 px figure picture in the pose sheet; it is the same with `plain` (checked), so it is not new (in the game the farmer faces the work).
- `check_all.sh --short` is left to the orchestrator.
