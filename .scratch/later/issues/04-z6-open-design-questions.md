# 04: Z6: Still-open design questions from the old documents

**What to build:** A collection of questions the parent has not yet answered: village projects, whether cider is renamed "apple must", art for the card pages, gear and pests, play-testing with real 8-year-olds, and the assumptions in the log §2.6.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** later

**Size:** quick

- [x] Each question in the notes is answered or routed (see Decision; the real-child play-test and the log §2.6 assumptions stay with the parent)
- [x] Answers go to the log §2.8 and to the right tickets

---

**Id:** Z6 · **Feature:** `later` · **Moved from** `archive/todo-2026-10.md` §17 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **Z6. Still-open design questions** (from the old documents; was Later 6):
  - village projects (bundles with substitutes): still a maybe;
  - cider is alcoholic; rename it "apple must" for young players?
  - art for the 67 card pages, gear and pests (album pictures for favours came in round 8);
  - play-test with real 8-year-olds: how many review questions they tolerate, whether 30 questions per season feels right, whether pest
    pressure is noticeable but not annoying;
  - the assumptions listed in `archive/log-2026-10.md` §2.6.

## Decision (17 Nov 2026, parent away, easy to undo)

- [x] Every question has an answer or a route:
  - **Village projects:** stay a maybe; not built, not filed. Why: no play-test has asked for them.
  - **Cider:** keep the name "cider" (it is an ingredient the farm ages into vinegar; nobody drinks it) and give the item one description line so a child and a parent can see that: "Fermented apple juice, an ingredient for vinegar. Not a drink." Why: "apple must" is a worse word for a child and wrong for a fermented juice; the description does the job and is only a text change.
  - **Art for the 67 card pages, gear and pests:** none made now. Spending OpenArt credits stays the parent's call; the pictures tickets already hold what the parent wants first.
  - **Play-test with real 8-year-olds** (questions tolerated, 30 questions per season, pest pressure): the parent's; covered by `waiting-on-parent/08` and the play-tests after it.
  - **Assumptions in the log §2.6:** the parent's own; they stay there for when the parent is back.

Build (the only build in this ticket; then mark it done): the cider description in English and in German through `i18n.py`; the new text goes on the parent's reading list with the other new texts (`waiting-on-parent/08`).

## Progress

Built 17 Nov 2026 (Sonnet agent). Short golden runs identical (seeds 1 and 2); `tools/i18n.py --check` clean (data 4078/4078); `check_data.py`: 0 errors; `ui_smoke`: no FAIL.

- **Cider line**: `desc` added to `cider` in `data/farm/items.json` ("Fermented apple juice, an ingredient for vinegar. Not a drink."); German through `tools/set_de.py` ("Vergorener Apfelsaft, eine Zutat für Essig. Kein Getränk."). Name stays "Cider" / "Apfelmost"; no new art. It shows where an item's `desc` already shows (the info window `ui/info.gd` and the pantry `ui/places/pantry.gd`).
- **On the parent's list**: one line "the new cider line (later/04)" under the reading box of `waiting-on-parent/08`.
- **Second box**: the answers are routed (this ticket's Decision, `waiting-on-parent/08` for the play-test and the new text). The PROJECT-LOG row is the orchestrator's. The log §2.6 assumptions have no ticket of their own: they stay in the archived log for the parent, as the Decision says.
- 💡 Same emoji 🍶 as vinegar: left as is (no new art; the description tells them apart).
