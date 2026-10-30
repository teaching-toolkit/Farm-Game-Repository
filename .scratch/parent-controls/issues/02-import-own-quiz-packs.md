# 02: The parent can import their own Time Quiz questions (flash cards)

**What to build:** A parent who wants the child (or another player) to learn something else adds their own Time Quiz questions without touching the game's files: they import a pack in the grown-up settings and switch it on for this farm. The questions then come up in the Time Quiz like the built-in packs, with the learning record keeping track of them.

**Blocked by:** None (can start immediately)

**Status:** needs-parent

**Milestone:** later

**Size:** sitting (a short grilling)

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
