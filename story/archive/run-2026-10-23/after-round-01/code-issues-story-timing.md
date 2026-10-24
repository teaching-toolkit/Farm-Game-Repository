# Code and data issues that make story show up late

Round 6b, draft 1 (14 Oct 2026). Separate from the story work, as the parent asked. Found with an instrumented copy of `tests/bot.gd` that logs node completions and story pieces by step. Chapter lengths in steps: ch1 1–244, ch2 245–420, ch3 422–648, ch4 649–844, ch5 845–905, ch6 906–1069. None of this is applied.

## Verdict

Most lateness was a **trigger-density** problem (solved by new pieces on existing triggers). The rest is code and data:

| # | Issue | Evidence | Proposed fix |
|---|---|---|---|
| C1 | The chapter gate (`chapter > G.chapter()`) holds back pieces whose real condition is met earlier | `c2_lark`, `c2_compost`, `c3_stream` fire in the wrong chapter | data: set `chapter` to 1 (lark, compost) and 2 (stream) |
| C2 | A pile-up at chapter turns; pieces are rationed, so the player waits through the avalanche | several beats on one step at chapter changes | raise the ration or let two non-frame pieces through per quiet period |
| C3 | `c5_page` waits for `has:healers_chest:1`, which is consumed by the pet cost, so the low point cannot fire | the bot never sees `c5_page` or `c5_collapse` | `c5_page` → `forest_trips>=5`; `c5_collapse` → `seen:c5_page + forest_trips>=9` |
| C4 | `tap:` and `page:` pieces cannot be tested headless | ~40 pieces never fire in the bot | let the bot open cards and tap the map in a test mode |
| C5 | No negation in the condition language | cannot say "not yet done" | add `not:<cond>` |
| C6 | No terms for pests, rain, frost, energy, `open:<node>`, or a generic stats counter | see `immersion-triggers.md` §3 | add the terms to `conditions.gd` |
| C7 | Bark density: a bark needs the quiet gate, so most barks wait | barks fire late in busy stretches | allow barks while a quiet period of N steps has passed |
| C8 | Quiet-gate delays (`storybox.gd` waits for the box to be idle) | delays of up to 15 steps | log, then lower |
| C9 | `pet_alpaca` can come home before the garden | `c6_alpaca` fires at step 1069 with the end frames | require `river_meadow_drain` |

## Data-only retimes (list, not applied)

- `c2_lark`, `c2_compost`: chapter → 1. `c3_stream`: chapter → 2.
- `c5_page`: when → `forest_trips>=5`. `c5_collapse`: when → `seen:c5_page + forest_trips>=9`; text revised so Greenstem runs for Wren.
- `c6_quill_answer`: when → `seen:c6_bend + after:c6_bend:2`, with "Probably fine" added.
- New `c4_window` scene (the piece is in `more-ch4.md`). `c4_frame4` is **not** re-keyed to it: that would make the chapter frame wait for an optional favour (consistency pass, 14 Oct 2026, F-089).
- Note from the same pass: a node's `chapter` field is a design label, not a gate. Only a piece's own `chapter` gates (as a minimum), and `G.chapter()` is 1 + the pets home. `north_field_clear` is labelled chapter 4 and the bot completed it in engine chapter 3 (step 629), so pieces should not be retimed by a node's label.
- `c6_garden` is skippable: either make `river_meadow_drain` a main goal or tie the ending to it.
