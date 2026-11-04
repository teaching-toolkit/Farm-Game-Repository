# 02: One condition module owns the grammar and the words

**What to build:** The condition module gets the full grammar (at least, fewer than, `not:`, one argument per word, lists) and a
register of condition words that lists itself. Every word the game understands today moves from the front door's two big lists to the
system that owns what it reads; the Game keeps only its own words. Nothing changes for the child.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** refactor

- [x] The module: grammar with `>=`, `<`, `not:`, a word with one argument, yes-or-no words, lists; a register with a note, an example and the kind of argument per word; it lists its words
- [x] A condition with a word nobody registered is false as a whole, also behind `not:`
- [x] Every word of today is registered by its owner; the Game keeps `step`, `chapter`, `coins`, `goals`, `start`, `chance:`, `done:`, `seen:`; the two big lists in the front door are gone
- [x] Headless test: every word answers on a new game and on the fixtures and has a note and an example; the grammar cases
- [x] Short and full golden runs identical (if not: stop and find the cause); smoke test; save fixtures; core kit test still passes

**Feature:** `condition-language` · **Source:** `.scratch/condition-language/spec.md` and the grilling in `01-grill-and-spec.md`. Filed 2 Nov 2026. Words: `GLOSSARY.md`.

## Result (2 Nov 2026)

Built as planned, plus the two data changes the stricter grammar needs at once (moved here from 03): `has:healers_chest:1` → `item:healers_chest>=1`
(`c5_page`), `chapter:N` → `chapter<N+1` (8 story pieces, each with its own `chapter` field N). 38 words. `G.conditions` replaces `G.cond`,
`cond_all`, `counter`, `term` and `seen`. Checked: core kit test, new `tests/conditions_test` (85 checks), short and full golden runs
identical in strict mode (whole state), and every condition in the data (story pieces' readiness with their chapter field, reveals, acorns,
perks) gives the same answer with the old and new code on 18 farm states (new game, both fixtures, after steps, chapters 5 and 6).
