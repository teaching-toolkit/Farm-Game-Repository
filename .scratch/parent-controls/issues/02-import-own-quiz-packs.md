# 02: The parent can import their own Time Quiz questions (flash cards)

**What to build:** A parent who wants the child (or another player) to learn something else adds their own Time Quiz questions without touching the game's files: they import a pack in the grown-up settings and switch it on for this farm. The questions then come up in the Time Quiz like the built-in packs, with the learning record keeping track of them.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** later

**Size:** sitting

Today the packs are files built into the game (`data/quiz_packs/`), and which are on is set in the game's settings data, not in the game. The learning record (sums **and** questions, one file per child) can already be copied out and pasted back in ⚙️ → 📊 Learning record; there is no import from a file.

## 💡 Recommendation

- **Format:** a simple table the parent can write in a spreadsheet: one row per question: question, right answer, two or three wrong answers, optional explanation. The game turns it into a pack. The full pack format (pictures, pools) stays for built-in packs.
- **Way in:** ✅ paste the table in the grown-up settings; **no file import** (parent, 30 Oct 2026). A short check says what was read and what was skipped.
- **Ids:** every imported question gets a permanent id from the pack's own code (ADR-0007), so rewording does not lose the record.
- **Switching on:** the grown-up settings list every pack (built-in and imported) with an on/off switch per farm.
- **Milestone:** ✅ `later` (parent, 30 Oct 2026). Modular packs are a design constraint for the `time-question` refactor now.

Questions for the grilling: table or JSON; one language or both; can imported questions have pictures; per farm or per device.

---
Parent's question, 30 Oct 2026 (review pass, round 2).

## Note from time-question/03 (2 Nov 2026)

Imported packs come in through `G.timeq.add_pack()` (the one door). Two things the import must settle: every question needs an id
that is unique across all packs (retry and recent questions are remembered by id; questions without one would be mixed up), and a pack
counts as switched on only when its id is in `activePacks`, so importing must also switch it on.

## Decision (17 Nov 2026, parent away, easy to undo)

- [x] The four grilling questions are answered; the parent's earlier answers stand (paste, no file import, milestone `later`):
  - **Table, not JSON.** Rows pasted from a spreadsheet (tab-separated, as a spreadsheet copies them): question, right answer, wrong answer 1, wrong answer 2, wrong answer 3 (optional), explanation (optional). A first row that looks like a header is skipped.
  - **One language per pack.** The parent says which when importing; the game does not translate and shows the question as written, whatever language the game is in.
  - **No pictures** in imported questions (the full pack format stays for built-in packs).
  - **Per device and per farm.** An imported pack is kept once on the device (the farms there share it); the on/off switch is per farm. Why: one copy to keep, and each child can learn something different.
- [x] Ids: the pack code (from the pack name the parent types, made unique) plus the row number at first import. Importing the same pack name again keeps the ids by row and appends new rows at the end; an id is never reused (ADR-0007).
- [ ] Build: an "Import questions" box in the grown-up settings (paste, pack name, language); a check that says what was read and what was skipped ("12 read, 2 skipped: row 4 has one answer"); then the pack goes in through `G.timeq.add_pack()` and is switched on for this farm. The pack list shows every pack (built-in and imported) with an on/off switch per farm.
- [ ] German through `i18n.py`; smoke test and `check_all.sh --short` pass; old saves load; the learning record shows imported questions; `docs/design/` updated.
- Out of the first build: deleting an imported pack (a pack can be switched off; deleting data stays the parent's), file import, pictures.
