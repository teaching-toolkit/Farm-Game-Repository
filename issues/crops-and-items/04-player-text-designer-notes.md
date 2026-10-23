# 04: Remove designer notes from text the player sees

**What to build:** A line like "(Barter idea: also asks for 1 onion per salt.)" is a designer's note that leaked into the game. Remove such lines or rewrite them as information a player can use. One is known (`nodes/02-main-path-chapter-1.json`, and its German); look for more.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] The known note, EN and DE, is removed or reworded into player information
- [ ] All data texts are searched for notes ("idea", "TODO", "note", brackets with design talk); each hit is fixed
- [ ] A data-checker rule flags such notes in text shown to the player

---

**Feature:** `crops-and-items` · **Source:** the parent's notes of 23 October 2026 (`planning/2026-10-23-parent-notes-playtest.md`), [#23.20]. Filed 23 October 2026.

The parent's words:

> [#23.20] stuff like "(Barter idea: also asks for 1 onion per salt.)" are artifacts that are not for the player of the game, remove such instances or reformulate so it's helpful info for a player.
