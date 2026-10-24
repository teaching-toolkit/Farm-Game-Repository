# 00: Digest and gap survey (the fresh eye on what exists)

**What to build:** Read everything in `story/` (not `archive/`; `texts/` and `staging/` are read-only), plus the game's data that tells you what the player really meets: `godot-prototype/data/farm/story/*.json` (the 80 pieces that ship), the chapter nodes and ruins (`godot-prototype/data/farm/nodes/`, `farm-progression.json`), `recipes.json`, and the pets file. Produce three files in `slices/00-digest/`:
1. `dossier.md`: **Canon digest** (at most 2500 words: people, places, time, rules, the ✅ list, the clue ladder Q1–Q13, the six chapters at a glance, the rhyme), then **Contradictions** found between files (file, line, what disagrees, which should win), then **Gap survey**: what a *lived-in* world and a rich outline still lack (missing world and background areas, character holes, thin chapters, flat stretches in registers), ranked. Plus a list of the facts the player never receives in the shipped texts (the diagnosis of 23 Oct is in `RUN-CHARTER.md` §1 and the opening ladder; re-check it yourself).
2. `node-map.md`: per chapter, the real goal nodes, ruins, pets, buildings, dishes and favours the game has, with their ids, so event seeds can name real triggers. Include the trigger vocabulary (`story-delivery.md` §6, `godot-prototype/game/farm/` condition code if you need to confirm) and any triggers the engine cannot read yet.
3. `shipped-vs-written.md`: per chapter, counts of pieces shipped vs written (`texts/more-*.md`), by kind and register, and the longest silences.

**Read first:** `RUN-CHARTER.md` (all of it), then `slices/00-digest/dossier.md` (the digest) once it exists, then the live-wire-style files named in the charter §6.

**Output:** `slices/00-digest/dossier.md` (and the files named above)

**Blocked by:** None (can start immediately)

**Status:** done

- [x] Dossier written in the slice folder; every new thing labelled 💡; inventions listed in an **Inventions** section; ❓ and ✅-touching proposals appended (one block) to `QUESTIONS.md`.
- [x] Nothing in the frozen zone or in live canon files was edited.
- [x] Event seeds use the charter §5 shape and name a trigger the game can read (see `slices/00-digest/node-map.md`).
- [x] Self-check against live-wire-style: every event is a want meeting an obstacle; registers vary; the farmer's spine drives at least some of the jokes; nothing explains itself.
- [x] Ticket status set to `done` and one line added to `RUN-LOG.md`.
