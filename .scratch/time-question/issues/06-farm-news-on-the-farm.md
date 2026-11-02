# 06: What happened on the farm shows on the farm

**What to build:** Rain, the rainbow, the scarecrow chasing pests and pests eating show on the farm through the playback when the
question pop-up closes, picture or animation first with a short line under it, the same after every kind of question (also after a
walk, on coming home). The pop-up shows only right or wrong and time moving (⏳, the question number).

**Blocked by:** time-question/04

**Status:** needs-parent

**Milestone:** prototype

**Size:** quick

- [x] The farm news is built from the part's report and shown by the playback, the same for every purpose
- [x] The pop-up's news lines are gone; it shows right or wrong and ⏳ with the question number
- [x] Nothing is lost: a walk's news waits until the farm is seen again
- [x] Screenshots at iPad size in EN and DE; smoke test
- [ ] The parent play-tests it

**Feature:** `time-question` · **Source:** `.scratch/time-question/spec.md` and the grilling in `01-grill-and-spec.md`. Filed 2 Nov 2026. Words: `GLOSSARY.md`.

## Progress (2 Nov 2026)

Built and checked; only the play-test is left. The news (rain, rainbow, scarecrow, pests) is gathered by the playback from each step's
report and plays with its animation and a note under it; the pop-up shows the green answer and "⏳ Time moves on: question N". After a
walk the news waits until the sheet over the farm is closed. Screenshots: `Claude outputs/screens/tq06-*.png`. Screenshot flags `--answer`
and `--news`.

💡 **Play-test:** answer a few Time Quiz questions on the farm, walk to the village and back, into the forest and out. Does the child see
the rain, the scarecrow and the pests, and does the short line under them help or get in the way? "Yes, fine" closes this ticket.
