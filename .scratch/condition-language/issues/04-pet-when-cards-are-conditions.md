# 04: The pets' WHEN cards are ordinary conditions

**What to build:** Each pet WHEN card keeps what the child sees (picture, name, slider with its smallest, largest and starting number) and
gets one condition with a gap for the chosen number (`weeds_max>={n}`, `empty_patches>={n}`, `water<{n}`, `item:compost<{n}` …). The
pets' own little language goes; `weeds_max`, `empty_patches` and `water` become ordinary condition words. The child's choices are saved
as before, so old saves load unchanged. Nothing changes for the child.

**Blocked by:** condition-language/02

**Status:** done

**Milestone:** refactor

- [x] Every WHEN card has one condition with `{n}`; the old stat / item / op fields are gone; the checker checks the cards' conditions
- [x] `weeds_max`, `empty_patches`, `water` are registered by their owners
- [x] Headless test: every card answers as the old code did for each number of its slider, on a new game and on the fixtures
- [x] Short and full golden runs identical; smoke test; save fixtures; the pets' screen looks as before (screenshot)

**Feature:** `condition-language` · **Source:** `.scratch/condition-language/spec.md` and the grilling in `01-grill-and-spec.md`. Filed 2 Nov 2026. Words: `GLOSSARY.md`.

## Result (2 Nov 2026)

Each card has `"when"` with `{n}` (weeds_max, empty_patches, water, pests, item:compost/stick/log/herbs); the pets fill `{n}` with the
child's number less 0.0001, the tolerance the old code had (a store amount or water a hair under a whole number counts as that number).
`weeds_max`, `empty_patches`, `water` and `pests` are registered by the fields (`pests` here instead of 05, the pests card needs it).
The card's label takes "≥" or "<" from its condition. Checked: every card × every number of its slider gives the same answer with the old
and the new code on 15 farm states (1,200 answers, including amounts a hair under a whole number); the checker reports a card with old
fields, without `{n}` or with an unknown word or item; screenshots of the pet corner in EN and DE look as before (`--pets` now also sets two
WHEN cards). The bot sets no WHEN cards, so the golden runs (identical) don't cover them; the comparison and the pets test do.
