# 01: Grill and spec: one condition language

**What to build:** Settle candidate 3 of `docs/architecture-review-2026-10-22.md` with the parent, then write the spec and the build tickets. One condition module owns the grammar (with `not:` and `<`), a registry in which each system registers its own words, and a way to list the vocabulary for the checker. The pets' WHEN cards become ordinary conditions. This is what the story timing issues C5 and C6 wait for (and probably C3). 

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** refactor


- [x] `/grill-with-docs` run with the parent on this candidate; the seams for testing agreed (the highest seam possible, ideally one)
- [x] `spec.md` written in this folder from the `/to-spec` template
- [x] Build tickets filed in this folder with `/to-tickets`, blockers set
- [x] The plan keeps the golden runs identical: this changes no game rule

## 💡 Recommendation (30 Oct 2026)

After `time-question`. It unblocks `story/07` (C5, C6); start from the review's Part B §3.

## Grilling

Facts found first (2 Nov 2026): the grammar is in `kits/core/conditions.gd`, every word in two `match` blocks in `game.gd` (27 counters,
9 terms); the pets' WHEN cards have their own little language (`weeds_max`, `empty_patches`, `water`, `pests`, items, `<`); the checker
reads the counter names from `game.gd`'s source and has two validators that disagree (`has:` and `season:` pass in story, fail in a
perk). Conditions are used by story pieces, reveals, golden acorns and perks; the data uses `done:` 41 times, then `seen:`, `chance:`,
`chapter:`, `step>=`. Only `>=` exists. The luck events' `"when": "weed"` means "right after this chore" (an event, not a condition).

**Round 1 (✅ parent, 2 Nov 2026: yes to all three)**
1. Scope: one condition module owns the language; it adds `not:` and "fewer than" (C5) and the words C6 asks for (pests, rain, frost,
   energy, water, `open:<node>`). No story piece is retimed here; golden runs stay identical. Parent: some timing was already late in
   the current version; that is tackled after the refactor (`story/07`), which this makes more straightforward.
2. Grammar: `<word> >= <n>`, `<word> < <n>`, `not:<condition>`, a word may carry one argument (`item:compost<3`); a list means all;
   the reveals' `whenAny` stays the only "one of these". The one `has:carrot:3` in the data becomes `item:carrot>=3` and `has:` goes.
   No `or`, brackets, `<=` or `==`.
3. Each system registers its own condition words next to the data they read; the Game keeps only its own (`step`, `chapter`, `coins`,
   `goals`, `start`, `chance`, `done:`, `seen:`). A word nobody registered is false in play and an error in the data checker.
   Glossary: condition, condition word.

**Round 2 (✅ parent, 2 Nov 2026: yes to all three)**
4. The pets' WHEN cards keep what the child sees (picture, name, slider min/max/start) and get one condition with a gap for the chosen
   number (`weeds_max>={n}`, `empty_patches>={n}`, `water<{n}`, `item:compost<{n}` …); the child's choice is saved as card + number as
   now (old saves unchanged). `weeds_max`, `empty_patches`, `water` become ordinary condition words.
5. The game writes its list of condition words (each with the kind of argument it takes) to a file next to the data; the Python checker
   reads it; a check fails when the file no longer matches the code (one command refreshes it).
6. The luck events' `"when": "<chore>"` becomes `"on": "<chore>"`; glossary: trigger.

**Round 3 (✅ parent, 2 Nov 2026: yes to all three)**
7. A condition with a word nobody owns is false as a whole, also behind `not:` (a typo never shows something at once).
8. New words: `pests` (on the field now), `rain` (it rained in this question), `energy`, `water`, `open:<goal>` (can be started now:
   what it needs is there and it is not done), `stones` (picked so far). No frost word (the game has only winter: `season:winter`),
   no general `stat:<name>` (each counted thing gets its own named word from its owner).
9. `chapter:` goes (one meaning per word): the 8 story pieces with `chapter:N` get `chapter<N+1` (their own `chapter` field already sets
   the earliest chapter). `season:<name>` stays.

**Round 4 (✅ parent, 2 Nov 2026: yes)**
10. One seam: the condition module (does this hold? which words are there?). One headless test walks every registered word on a new game
    and on the fixtures (answers without error, has a note and an example), checks the grammar, and checks each pet WHEN card answers
    as before; short and full golden runs identical. Story, reveals, acorns and perks get no tests of their own for this.

**Shared understanding confirmed by the parent (2 Nov 2026).** No ADR: this follows the architecture plan's "one condition language"
(§4.1) and reverses no decision. Spec: `.scratch/condition-language/spec.md`; tickets `02`–`05`.

---

**Feature:** `condition-language` · **Source:** `docs/architecture-review-2026-10-22.md`, Part B, candidate 3 (Strong). Read that section first: it has the problem, the deletion test, the solution and a before/after sketch. Filed 23 October 2026.
