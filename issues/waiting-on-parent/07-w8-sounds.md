# 07: W8: Get the missing sounds and listen to all of them

**What to build:** The parent downloads the sounds listed in `sound-inbox/README.md` (the cloud machine cannot reach those sites), an agent imports them, and the parent listens to everything and adjusts volumes. Nobody has listened yet.

**Blocked by:** None (can start immediately)

**Status:** needs-parent

- [ ] Sounds exist for cow, sheep, goat, pony, bees, cat, birds, `extras/party` and `extras/wind` (stand-ins play until then)
- [ ] The licence question is answered: the CC-BY-SA Mudchute cow and sheep, or the CC0 ones
- [ ] `python3 tools/import_sounds.py` and the Godot import have run
- [ ] The parent has listened and the volumes in `data/sounds.json` are adjusted
- [ ] The success sound is more jubilant (parent's note [#23.39]): pick or make a livelier one
- [ ] A different music track for the chapter frames (`story/11`) if the parent wants one beyond a stand-in
- [ ] Track titles of the two music tracks added to `sound-inbox/SOURCES.json` if known

---

**Id:** W8 · **Feature:** `waiting-on-parent` · **Moved from** `TODO.md` §1 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **W8. Sounds still missing** (system done 7 Oct; 83 files in `assets/sounds/`, 31 of 40 effects and all 6 music tracks): cow,
  sheep, goat, pony, bees, cat, birds, `extras/party`, `extras/wind` (stand-ins play until then). The Mudchute cow and sheep in
  `sound-inbox/unused/` are CC-BY-SA (share-alike): use only if the parent accepts that licence; the BigSoundBank/OpenGameArt CC0
  cow and sheep are better. The two "for now" music tracks are credited by artist and site only (farm: Zane Little, OpenGameArt, CC0;
  quiz/Rest: Kevin MacLeod, incompetech, CC BY 4.0); add the track titles to `sound-inbox/SOURCES.json` if known. **Nobody has
  listened yet** (volumes in `data/sounds.json`). The cloud machine cannot reach kenney.nl, opengameart.org, bigsoundbank.com or
  incompetech.com (7 Oct 2026): the parent downloads what `sound-inbox/README.md` lists, or allows those domains; then
  `python3 tools/import_sounds.py` and `$G --headless --path . --import`, listen, adjust volumes.
