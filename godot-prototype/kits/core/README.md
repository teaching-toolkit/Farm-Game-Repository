# kits/core — the core every game builds on

Small, farm-free building blocks (phase 2, slice R3, 12 Oct 2026). Each file explains itself at the top.

| File | Does |
|---|---|
| `modifiers.gd` | folds effects (`set`, `add`, `mult`, `produces`) from many sources, with weights for diminishing returns |
| `conditions.gd` | one language for "when" in the data: `kind:arg`, `counter>=N`, `a & b`; the game registers kinds and counters |
| `rng.gd` | the one random source for the rules, seedable (`--seed=N`) |
| `clock.gd` | one step of time: systems registered in a fixed order, a shared report |

Still to come (see `planning/2026-10-12-architecture-plan.md` §4.1): data loading, versioned saves (R7), an event hub
(when the rules are split into systems, R4). Tests: `tests/core_test.tscn`. Rules: no `class_name`, no autoloads,
relative preloads inside the kit, nothing about farming.
