# Story folder: Farm Quiz Game

Everything about the **story** lives here: the hidden truth, the world, the people, the outline, and (later) the texts that
go into the game. The game's own documents stay in the project root (`00-READ-ME-FIRST.md`, `PROJECT-LOG.md`, the design
document). **If the story and the game data disagree, say so in `game-hooks.md`; do not fix one silently.**

Started 7 Oct 2026. Written with the children's-story skill *live-wire-style* (plan the people, then the structure, then the
texture; read aloud is the final test).

## Labels used in every file here

- ✅ **Decided by the parent.** Do not change without asking.
- 💡 **Proposed by Claude.** Waiting for the parent's yes or no; may still change.
- ❓ **Open question.** Needs an answer before the next round.
- 🔒 **Hidden from the player.** The architects know it; the game reveals it slowly, or never.

## Files

| File | What it holds | Status |
|---|---|---|
| `README.md` | this index and the round status | live |
| `00-premise.md` | the premise: the present-day story vs the hidden mystery, the frame, the clue ladder, the decisions to take | Round 1 |
| `book-file.md` | the canon file: dials, book sentence, protagonist and cast spines, fixed facts, flagged inventions, plants and payoffs | Round 1, grows every round |
| `story-delivery.md` | how story reaches the player: seven kinds of piece, timing, priority, the chapter shape, the data | Round 4 part 1 |
| `game-design-round4.md` | six chapters, the pets' job board, the medicine chapter, the forest screen, build order | Round 4 part 2 |
| `research/` | notes on how other story games do it, with sources | Round 4 part 1 |
| `game-hooks.md` | what the story asks of the game and what the game asks of the story (six chapters, pets as helpers, the forest, the scroll) | Round 1, grows every round |
| `world/` | world bible: `00-timeline.md`, `hazelwood.md`, `lease-and-collapse.md`, `shell-and-magic.md`, `helpers-and-rhyme.md` | Round 2 draft 1 |
| `characters/` | `fenna.md`, `mumyo.md`, `lark.md`, `berit-and-family.md`, `helpers.md`, `hazelwood-people.md`, `minena.md` | Round 3 draft 1 |
| `outline/` | `ladder.md`: the six-chapter ladder, beats mapped onto the game's goal nodes, running snags | Round 5 draft 1 |
| `texts/` | the short in-game story texts and the bedside frame scenes (English, then German): `ch1.md` … `ch6.md` are the sources of `godot-prototype/data/farm/story/*.json` and the German in `data/i18n/data-de.json` | Round 7, chapters 1–6 built |
| `outline/long-game.md` | the long game: dials, charge per chapter, the Keeper's moves, running snags, motif ladder | Round 6b draft 1 |
| `immersion-triggers.md` | the trigger kinds, the 166 new pieces by kind, measured gaps | Round 6b draft 1 |
| `code-issues-story-timing.md` | why story still shows late: code and data issues C1–C9 and the retimes (not applied) | Round 6b draft 1 |
| `texts/more-ch1.md … more-ch6.md` | 166 new pieces, English only (51 / 29 / 29 / 19 / 14 / 24 by chapter); `staging/` holds the generated JSON and `md_to_story_json.py` | Round 6b, consistency pass 14 Oct 2026 |
| `consistency-report.md` | the audit: 109 findings F-001 … F-109 and the fix list for the editor | 14 Oct 2026 |
| `consistency-fixes.md` | what the editor did with each finding (applied, skipped, parent's question, build step), the questions for the parent, the build-step list, the new inventions, the checks | Round 6b, consistency pass 14 Oct 2026 |
| `archive/` | earlier drafts, kept for reference | – |

## The rounds (see also `TODO.md`, group I)

| Round | What | Status |
|---|---|---|
| 0 | Set up this folder; log and to-do entries | done 7 Oct 2026 |
| 1 | Premise, book file, decisions | done 7 Oct 2026 (D9 chosen: split family) |
| 2 | World bible | done 7 Oct 2026 (D11: years never counted); tidied in the critical pass |
| 3 | Character profiles | draft 1 done 7 Oct 2026; updated 8 Oct for the second-person, gender-open farmer |
| 4 | Game design pass. Part 1: story delivery. Part 2: pets' jobs, medicine, forest, six chapters (`game-design-round4.md`) | done 8 Oct 2026 |
| 5 | Outline (ladder with cliffhangers) | draft 1 written 8 Oct 2026 (`outline/ladder.md`); five questions for the parent |
| 6 | Loop back: story and game reconciled | – |
| 7 | Texts, chapter 1 first, read aloud; German | chapter 1 written 13 Oct 2026 (`texts/ch1.md`), built into the game (phase 5); chapters 2–6 and the frames written and built 13 Oct 2026 (`texts/ch2.md` … `ch6.md`, 💡 until read) |
| 8 | Build into the game | – |

## Working agreements

1. After every round, update this file, `book-file.md` (session log, flagged inventions) and the project's log and to-do list.
2. Anything invented without being asked goes into the **flagged inventions** list in `book-file.md` until the parent accepts it.
3. The hidden truth (🔒) is written only in `00-premise.md` §3 and the world bible, never in player-facing texts before its reveal.
4. Player-facing texts: second person, the player's chosen name, no gendered word for the farmer; short (2–4 sentences, about 35–45
   words), words a six-year-old knows, nothing that punishes the child.
