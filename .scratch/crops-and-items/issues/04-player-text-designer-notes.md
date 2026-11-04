# 04: Remove designer notes from text the player sees

**What to build:** A line like "(Barter idea: also asks for 1 onion per salt.)" is a designer's note that leaked into the game. Remove such lines or rewrite them as information a player can use. One is known (`nodes/02-main-path-chapter-1.json`, and its German); look for more.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The known note, EN and DE, is removed or reworded into player information
- [x] All data texts are searched for notes ("idea", "TODO", "note", brackets with design talk); each hit is fixed
- [x] A data-checker rule flags such notes in text shown to the player

---

**Feature:** `crops-and-items` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.20]. Filed 23 October 2026.

The parent's words:

> [#23.20] stuff like "(Barter idea: also asks for 1 onion per salt.)" are artifacts that are not for the player of the game, remove such instances or reformulate so it's helpful info for a player.

## Result (3 Nov 2026)

- **The known note:** the Spice Merchant now reads "Sells salt for cooking." / "Verkauft Salz zum Kochen." (no barter exists in the game, so the note was dropped, not turned into a rule).
- **Searched** every text the player reads (all data texts as `tools/i18n.py` collects them, interface texts, and the German) for "idea", "note", TODO, brackets with design talk, "the player", "default name". Fixed, EN and DE:
  - the six pet descriptions: "Pet 1 (default name Pip; the player can rename)." → "Comes home as Pip; you can choose a new name." (the same for Mossy, Bramble, Hazel, Bracken, Alfie; "Pet 5" was on two pets);
  - Tomato: "Ingredient-threshold unlock (kept from the prototype): bring 2 eggs once." → "Opens when you bring 2 eggs once." (the German already said this);
  - Seed library: "(Seed-saving lesson.)" removed;
  - Weeder geese: "(Real old practice.)" → "(Farmers really did this long ago.)" (matches the German).
  - Left as they are (player information, not notes): "(unlocked by a dish)" on iron ore, "(expensive shortcut)", story texts that use "note" and "idea" in the story's sense.
- **Data-checker rule:** `tools/check_data.py` now fails on design talk in any player text (data texts, interface texts, every `data/i18n/*-*.json` translation): TODO/FIXME/TBD, brackets with idea/note/planned/placeholder/prototype/lesson, "the player", "default name", "Pet N", "threshold unlock", and in German Tauschidee, Standardname, "Haustier N", brackets with Idee/Notiz/geplant/Prototyp. On the baseline data it reports 25 errors (the notes above); now 0. Documented in `farm-game-check` §2.
- **Agent's choice:** the rule is an error, not a warning, so a new note fails `check_all.sh`. If it ever trips on a real player sentence, reword the sentence or narrow the pattern (`DESIGN_TALK` in `tools/check_data.py`).
- **Not done here:** `progression/` (the explorer's copy of the data) was already out of sync with `data/farm/` before this ticket (`sync_progression.py` changes ~150 lines unrelated to it), so it was not re-synced in this patch; run `python3 tools/sync_progression.py` after merging.
- **Checked:** `check_data.py` 0 errors; `i18n.py --check` exit 0 (de: data 3333/3333). A German screenshot of the bunny's celebration was tried (`--celebrate=pet_bunny --lang=de`), but the new-game welcome box covers it; the new German texts are about as long as the old ones.
- **Play-test:** read the pets' descriptions in the quest book and the Spice Merchant's in the market, in German too.
