# Story folder: Farm Quiz Game

Everything about the **story** lives here: the hidden truth, the world, the people, the outline, the run that produced the outline, and the texts that go into the game. The game's own documents stay in the project root (`00-READ-ME-FIRST.md`, `PROJECT-LOG.md`, the design document). **If the story and the game data disagree, the data wins until a data wish is built (`data-wishes.md`); do not fix one silently.**

Started 7 Oct 2026. The story outline run (23–24 Oct 2026) is **closed**: the outline is written. The real next step is wiring the staged pieces into the game (`TODO.md` I15), playing with the child, then deciding which text rewrites to make.

## Labels used in every file here

- ✅ **Decided by the parent.** Do not change without asking.
- 💡 **Proposed by Claude.** Waiting for the parent's yes or no; may still change.
- ❓ **Open question.** Needs an answer before the next round.
- 🔒 **Hidden from the player.** The architects know it; the game reveals it slowly, or never.

## Where to start (five minutes)

0. **Just want to read the story:** `STORY-SYNOPSIS.md` (a plain, spoiler-full, chapter-by-chapter retelling; no triggers or ids; a summary of the master outline, not canon).
1. **What is canon:** `outline/story-bible.md` (one document: premise, hidden truth, the Lord and the clock, clue ladder, silences, the parent's rulings). 
2. **What happens, chapter by chapter:** `outline/master/ch1.md … ch6.md` and `ending.md` (play order, charge audit, clue ledger, costs). Every seed and its fate: `outline/registry.md`.
3. **What the parent still has to decide:** `QUESTIONS.md` (one page, ten questions with 💡 defaults).
4. **What the game and the texts must change:** `data-wishes.md` and `text-change-requests.md` (lists only; nobody has edited data or texts).

## The files, by status

| Status | File or folder | What it holds |
|---|---|---|
| **Canon (read first)** | `outline/story-bible.md` | the canon in one place, pointing at the dossiers |
| Canon | `characters/` | `fenna.md`, `mumyo.md`, `lark.md`, `minena.md`, `berit-and-family.md`, `helpers.md`, `hazelwood-people.md` (older; each carries a note pointing at the bible) plus the new `village-arcs.md` (core 20, stance ladder, Quill) and `liv-tilda-berit.md` |
| Canon | `world/` | `00-timeline.md`, `hazelwood.md`, `lease-and-collapse.md`, `shell-and-magic.md`, `helpers-and-rhyme.md` (older; each carries a note pointing at the bible) |
| Canon | `00-premise.md`, `book-file.md` | the premise (Round 1) and the canon file with the fixed facts, flagged inventions, plants and payoffs, session log (append only) |
| **Outline** | `outline/master/` | `ch1.md … ch6.md`, `ending.md`: the master outline (24 Oct 2026) |
| Outline | `outline/registry.md` | one row per event seed (177), with its fate |
| Outline | `outline/ladder.md`, `outline/long-game.md` | the 8 Oct ladder and the 14 Oct long-game notes (superseded by `master/`; kept for history) |
| Lists for the parent and the game agents | `QUESTIONS.md`, `data-wishes.md`, `text-change-requests.md` | decisions open; data changes wanted; text changes wanted |
| How story reaches the player (engine and delivery) | `story-delivery.md`, `game-hooks.md`, `game-design-round4.md`, `immersion-triggers.md`, `code-issues-story-timing.md` | seven kinds of piece, timing, priorities; what the story asks of the game; the 166 staged pieces by kind; measured timing gaps. **Referenced from the root documents, the skills and `issues/`; paths unchanged** |
| Run history (frozen after 24 Oct 2026) | `RUN-CHARTER.md`, `RUN-LOG.md`, `slices/` (the dossiers 00–07 and `DECISIONS.md`), `reviews/`, `tickets/` | the rulebook, the round log, the design dossiers (about 126,000 words; the seeds are in the registry), the manager's binding rulings, the fresh-eye reviews, the tickets (05, 08a to 09 were not run; their work is in `outline/`) |
| Audit of the staged layer | `consistency-report.md`, `consistency-fixes.md` | the 14 Oct audit (109 findings) and what was done with each |
| **Frozen, untouched** | `texts/`, `staging/` | the shipped and staged story texts (`ch1.md … ch6.md`, `more-ch1.md … more-ch6.md`) and the generated JSON; sources of `godot-prototype/data/farm/story/*.json` |
| Archive | `archive/` | `STORY-PLAN-v0.md`; `run-2026-10-23/` with the snapshots `00-before-run`, `after-round-01`, `after-round-02`, `after-round-03` and `pre-merge/` (copies of the files edited on 24 Oct) |
| Background | `research/` | notes on how other story games do it |

## The rounds

| Round | What | Status |
|---|---|---|
| 0–7 | premise, world, characters, game design, ladder, texts for six chapters and the frames | done 7–14 Oct 2026 |
| 6b | long game, 166 staged pieces, consistency pass | done 14 Oct 2026 |
| Outline run (23–24 Oct) | digest and 20 contradictions; slices 01, 02, 03, 04, 06, 07 written, reviewed and revised; slice 05 not written; master outline written by the manager; registry, bible, wishes, change requests, questions | **closed 24 Oct 2026** (`RUN-LOG.md`) |
| Next | wire the staged pieces (I15); test-bot run over the opening hour; play with the child; decide on text rewrites | open |

## Working agreements

1. After every round, update this file, `book-file.md` (session log) and the project's log and to-do list.
2. Anything invented without being asked is 💡 until the parent accepts it; accepted ones go into `outline/story-bible.md`.
3. The hidden truth (🔒) is written only in the bible, the premise and the world files, never in player-facing texts before its reveal.
4. Player-facing texts: second person, the player's chosen name, no gendered word for the farmer; short (2–4 sentences, about 35–45 words), words a six-year-old knows, nothing that punishes the child.
5. Nobody edits `texts/` or `staging/` from an outline task: changes go through `text-change-requests.md`.
