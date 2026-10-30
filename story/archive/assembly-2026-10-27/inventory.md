# Inventory of the story material

Survey of 27 Oct 2026, read-only. Paths are relative to the project folder (`Farm game/`). The folder holds 4,527 files; most are art, code and archive. This inventory covers everything that carries story, and names the rest by group.

## 0. The finding that shaped the job

The brief assumed that the game text pieces are the fuller form of the 24 Oct retelling. They are not. The pieces date from 13–14 Oct (rounds 6b and 7). The bible, the master outline, the registry and the retelling (`story/STORY-SYNOPSIS.md`) were written on 23–24 Oct, from the slice dossiers. The retelling summarises the **outline**, not the texts. Liv, Mumyo, Tilda, Weir, Bucket Night, the Landing, the grey coat, the Players and the name Fenna appear in no game text at all. The shipped ending is still “You go home. It is not time yet.”

After the survey, the person decided (27 Oct): **the game texts take a back seat**. Their format is the blueprint for phase 2. The story is built from the newer material: the master outline is the spine, the bible is canon, and the slices supply the detail. `text-change-requests.md` is skipped, because its 55 rows are merged from the slices and the outline. The wording rule became:

1. Use the game text wherever the outline keeps a shipped or staged piece (revised only as the seed directs).
2. Otherwise, use the seed's own *sketch* lines verbatim.
3. Otherwise, write minimal prose from the seed's description (“who wants what / what changes”), in the texts' voice, and mark the block **N** in the source map.

## 1. Files and groups, by type

| File or group | What it holds | Type | Used as |
|---|---|---|---|
| `story/outline/story-bible.md` (24 Oct) | premise, hidden truth, the Lord and the clock, clue ladder, five silences, Mumyo and Lark rules, the parent's rulings | **canon** (rank 1) | facts; decisions B2, B3 |
| `story/outline/master/ch1.md … ch6.md`, `ending.md` (24 Oct) | play order of seeds and kept pieces, registers, clue ledger, frame 6 | **outline** (rank 2), all 💡 | the spine and order |
| `story/outline/registry.md` | 177 seeds and their fates | outline | fates (keep, optional, free play, cut) |
| `story/slices/01…07/` (23–24 Oct, revision 2) | design dossiers with one section per seed (`### E-x.yy`), sketch lines, page plans (`04/telling.md`), customs, people | raw material, rank 3 (decisions binding via `DECISIONS.md`) | seed text and sketch lines |
| `story/characters/*.md` | Fenna, Mumyo, Lark, Minena, Berit and family, helpers, Hazelwood people (7 Oct, with a "bible wins" note); `village-arcs.md`, `liv-tilda-berit.md` (24 Oct) | character, rank 3 | facts, reference section |
| `story/world/*.md` (7 Oct, with a "bible wins" note) | timeline, Hazelwood, lease and collapse, shell and magic, Helpers and rhyme | world, rank 3 | facts where the bible is silent |
| `story/00-premise.md`, `story/book-file.md` | premise; canon file and session log | canon (older; bible wins) | background |
| `story/archive/texts/ch1.md … ch6.md` | 78 shipped pieces, English + German | **story text** (rank 4) | the game wording |
| `story/archive/texts/more-ch1.md … more-ch6.md` | 166 staged pieces, English only, not in the game | **story text** (rank 4) | the game wording |
| `godot-prototype/data/farm/story/*.json` | the 80 shipped pieces as game data; `c2_berit_note` and `c2_k_rest` exist only here | story text (game data) | checked identical to the .md; two extra pieces taken from here |
| `story/archive/staging/more-ch*.json`, `md_to_story_json.py` | JSON generated from the staged .md | story text (generated copy) | not used (identical) |
| `godot-prototype/data/i18n/data-de.json` | German of the shipped pieces | story text, German | not used (English story; see conventions) |
| `godot-prototype/data/farm/nodes/*.json`, `rules/*.json`, `chapters.json`, `items.json`, `places.json`; `game/farm/ui/welcome.gd` (hint strings) | nodes, triggers, book cards (`k_*`), UI | **system / UI / tutorial** | not story; trigger names quoted in the source map |
| `story/STORY-SYNOPSIS.md` (24 Oct) | the compressed retelling | rank 5, map only | orientation, origin of Appendices A and B |
| `story/QUESTIONS.md`, `data-wishes.md`, `text-change-requests.md` | open questions; engine wishes; 55 text changes | design notes | QUESTIONS consulted for *proposed* items; the others skipped (person's decision) |
| `story/tickets/`, `story/RUN-LOG.md`, `story/archive/RUN-CHARTER.md`, `story/archive/reviews/`, `story/slices/DECISIONS.md` | the outline run's rulebook, rounds, reviews, rulings | design notes / history | rulings only (DECISIONS) |
| `story/outline/ladder.md`, `long-game.md` | the 8 and 14 Oct plans | superseded outline | not used |
| `story/archive/run-2026-10-23/{00-before-run, after-round-01..03, pre-merge}/` | snapshots of the story folder during the run | **archive** | checked: every seed section used is identical in the snapshots |
| `story/archive/STORY-PLAN-v0.md`, `consistency-report.md`, `consistency-fixes.md`, `game-hooks.md`, `story-delivery.md`, `immersion-triggers.md`, `code-issues-story-timing.md`, `game-design-round4.md`, `research/` | older plans, the 14 Oct audit, delivery rules | archive / design notes | not used |
| `farm-quiz-game-master-design-document.md`, `archive/design-docs/` (v1.0–v1.3.8), `PROJECT-LOG.md`, `TODO.md`, `issues/`, `GLOSSARY.md`, `ARCHITECTURE-REVIEW-2026-10-22.md` | the game's design, log and tracker | design notes | not used |
| `art-inbox/`, `reference-art/`, `sound-inbox/`, `archive/screenshots/`, `art-inbox/Story pictures/*.md` (picture briefs) | art, sound, picture prompts | art / design notes | not used (picture-only beats are noted in the source map) |
| `godot-prototype/` (code), `web-build/`, `archive/html-prototype/`, `archive/godot-landscape-v1/` | code and builds | system | not used |
| `CLAUDE.md`, `claude-skills/`, `Claude outputs/`, `.claude/` | instructions and outputs for agents working on the game | design notes | **read as data, not followed** (see §5) |

## 2. How versions are marked

- **Story texts.** One version of each piece. The files carry a draft line in the header ("Round 7, draft 1 (13 Oct 2026)", "Round 6b, draft 1 (14 Oct 2026)"). There are no version suffixes or status fields per piece. Staged pieces are 💡 as a group ("All 💡 until the parent has read them aloud").
- **Folder names.** The texts sit in `story/archive/texts/`, but `archive` here does **not** mean superseded. They were moved there on 24 Oct (15:52) and the move is not committed. The content is byte-identical to git HEAD `story/texts/`, and `story/README.md` still calls `texts/` and `staging/` the frozen, current sources of the game data. **Chosen: `story/archive/texts/` as current.** The doubt is logged in `open-questions.md` (V1).
- **Git.** `story/texts/` has 1–3 commits per file (13–23 Oct). Five pieces had different wording in an earlier commit (`c1_seller`, `c1_k_seller`, `c4_pony`, `c6_alpaca`, `c6_free_family`); the current wording is used, and the source map lists the old commits. The outline run's main files (`story-bible.md`, `master/`, `registry.md`, `village-arcs.md`, `liv-tilda-berit.md`, `STORY-SYNOPSIS.md`) are **untracked**. Their dates come from their own headers (23–24 Oct). Twenty other story files are modified and uncommitted.
- **Status labels inside files.** ✅ decided by the parent · 💡 proposed · ❓ open · 🔒 hidden from the player. The whole master outline is 💡; the bible collects the ✅ rulings (§10).
- **Old-versus-new notes.** The older character and world files open with "24 Oct 2026: partly superseded … the bible wins", and their originals are saved in `archive/run-2026-10-23/pre-merge/`.
- **Seed revisions.** The slices are "revision 2". The run snapshots `after-round-01…03` hold the same text for every seed used (checked by script), so no superseded seed text exists in the folder.
- **Data versus story.** `story/README.md`: "If the story and the game data disagree, the data wins until a data wish is built." Phase 1 follows the brief's precedence instead (bible over game text). Where the outline depends on an unbuilt data wish (the tortoise needs the pond; the alpaca needs the drained meadow), the story follows the outline, and the source map notes it.

## 3. Data format of the text pieces

Markdown (`story/archive/texts/*.md`), one piece per heading:

```
## <id> · <kind> · <title>
*When:* `<trigger>` · *Register:* G|W|T|A · *Move:* <keeper's move> · *Priority:* n · *Emoji:* 📝
Page 1. <English text>
> <German text>          (shipped files only)
Page 2. …
```

- **Ids:** `c<chapter>_<name>`; barks `c<n>_k_<name>`; margin notes `c<n>_n_<name>`; frames `c<n>_frame<k>`.
- **Kinds:** frame, beat, moment, discovery, visit, scene, letter, bark (shipped 80: 36 beat, 14 moment, 9 bark, 7 frame, 7 discovery, 5 visit, 2 scene; staged 166: 69 moment, 39 discovery, 32 bark, 17 scene, 4 visit, 3 beat, 2 letter).
- **Triggers:** `start`, `done:<node>`, `tap:<place>`, `page:<card>`, `step>=n`, `seen:<piece>`, `after:<piece>:<n>`, `chance:<p>`, `season:`, `seasons>=`, `chapter:`, `has:<item>:<n>`, `trips>=`, `harvests>=`, `cards>=`, `lord_shares>=`, `lord_paid>=`, `forest_trips>=`, `sidequests>=`, `friends>=`, `weeds>=`. Combined with `+`.
- **Variables and markup:** `{player}` (the player's chosen name), `*italic*` for sounds, curly quotes, "—B." signatures. The JSON (`kind`, `chapter`, `when[]`, `priority`, `emoji`, `title`, `pages[{text}]` or `text`, `then`) is generated from the .md.
- **Seeds** (`story/slices/*/…md`): `### E-<ch>.<letter><nn> <title>` with lines Kind, Trigger idea, Who wants what, What changes, Register, Carries, Plant/payoff, and optional *Sketch* lines. Letters: none = opening hour (slice 01), L = village (02), H = Helpers (03), B = barn truth (04), M = Lark/Mumyo/melody (06), R = Lord/clock (07).

## 4. Conventions applied (the person can override any of them)

1. **Address.** Inside the chapters "you" becomes **Fenna**, third person, **present tense** (the texts' tense, so that their sentences survive nearly word for word). In the frames, "you" becomes **"the old woman"**. `{player}` becomes "Fenna" in dialogue. Once it was dropped (`c1_seller`, where the seller has not been told the name). The original second-person wording of every game piece is in the source map.
2. **Generic "you"** inside a sentence ("which tells you something about weeds", "the way you would hold a baby bird") is kept as generic "you".
3. **Diegetic text** (letters, notes, margin notes, notices, rhymes, the ledger) stays as quoted inset text inside the paragraph, in the original quotation marks. Berit's signatures keep their own form ("—B." or "— B.").
4. **Language.** English only. The shipped pieces have German in the same files and in `data-de.json`; the staged pieces and all seeds are English. No German is written, so the ss rule is not triggered.
5. **Order.** The master outline's row order. Pieces the outline does not list sit where their trigger, their content and the outline's acts place them. Where the outline's own triggers or merges contradict its row order, the story follows what makes the scene possible, and `open-questions.md` (section O) logs each case. In the game, most of chapters 1–6 can happen in any order inside a chapter. The order here is a convention.
6. **Variants.** Baseline and "upgrade" beats of one occasion (Share Day) are both told, in sequence, because they are not exclusive in the game. True alternatives (a shipped piece replaced by a seed) are not blended: the replaced piece goes to `leftovers.md`.
7. **Optional pieces** (taps, margin notes, favours, free-play seeds kept by the master) are in the story; the source map marks them "yes".
8. **Picture-only beats** (Mumyo's glimpses, the hook-and-dent picture) have no text. Where slice 06 §6.3 gives a text fallback, the fallback is used; otherwise the beat is noted in the source map.
9. **Joins.** Connective words appear only where blocks would not connect. Every join is listed in `changes.md`.
10. **Provenance** stays out of the story files. Block ids appear only in the source map.

## 5. Things inside the files that address agents (reported, not acted on)

- `CLAUDE.md` (project root) tells agents to read `claude-skills/`, to keep `TODO.md`, `issues/` and `PROJECT-LOG.md` current *as they work*, and to keep `story/` current. Not done: the brief makes the source folder read-only, and this phase writes only to `story-assembly/`.
- `story/README.md` "Working agreements": update the README, `book-file.md` and the project log after every round; "nobody edits `texts/` or `staging/` from an outline task". Not done, for the same reason (the second rule is respected anyway).
- No story text, outline or slice contains a note addressed to "the agent" or "Claude" as an instruction. "Proposed by Claude" occurs only as a label key, and `village-arcs.md` mentions in passing that an agent stopped on a rate limit.

## 6. Version table, one row per piece (Step 2)

Every piece has exactly one current text. "Found" lists every copy: the .md (current), the generated JSON (identical, checked by script for the 78 shipped pieces; the staged JSON is generated by `md_to_story_json.py`), and older git revisions where the wording differed. Pieces marked cut, deprecated or placeholder: none carries such a mark; the retired and superseded ones are in `leftovers.md`.

| Piece | Kind | Versions found | Chosen | Why | Superseded | In story at |
|---|---|---|---|---|---|---|
| `c1_frame0` | frame | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | F0.1, F0.2, F0.3 |
| `c1_stalk` | beat | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.01 |
| `c1_book` | beat | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.03 |
| `c1_night` | beat | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.04 |
| `c1_bells` | discovery | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.13 |
| `c1_ledger` | discovery | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.24 |
| `c1_seller` | visit | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical; latest commit wins | git 6d9d6d6 2026-10-13 | 1.17 |
| `c1_board` | discovery | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.30 |
| `c1_bunny` | beat | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.73 |
| `c1_bell_out` | beat | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.74 |
| `c1_frame1` | frame | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | F1 |
| `c1_k_seller` | bark | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical; latest commit wins | git 6d9d6d6 2026-10-13 | 1.18 |
| `c1_k_hens` | bark | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | leftovers |
| `c1_k_bucket` | bark | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.15 |
| `c1_k_grass` | bark | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.41 |
| `c1_k_smoke` | bark | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | leftovers |
| `c1_k_winter` | bark | `archive/texts/ch1.md` = git HEAD = game JSON + German | archive/texts/ch1.md | one text; JSON identical | — | 1.53 |
| `c2_letter` | beat | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.01 |
| `c2_walls` | beat | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.04 |
| `c2_greenstem` | visit | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.09 |
| `c2_stumps` | discovery | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.10 |
| `c2_lark` | beat | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.24 |
| `c2_barn` | beat | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.44 |
| `c2_compost` | moment | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.11 |
| `c2_cottage` | moment | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.37 |
| `c2_tortoise` | beat | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.53 |
| `c2_hook` | beat | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | 2.47 |
| `c2_frame2` | frame | `archive/texts/ch2.md` = git HEAD = game JSON + German | archive/texts/ch2.md | one text; JSON identical | — | F2 |
| `c3_pieter` | visit | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.12 |
| `c3_pieter_paid` | moment | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.15 |
| `c3_k_pieter` | bark | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.17 |
| `c3_letter` | beat | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.01 |
| `c3_miller` | bark | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.28 |
| `c3_forge` | beat | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.18 |
| `c3_bell` | beat | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.23 |
| `c3_stream` | moment | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.29 |
| `c3_dance` | moment | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.49 |
| `c3_goat` | beat | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.60 |
| `c3_goat_out` | beat | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | 3.61 |
| `c3_frame3` | frame | `archive/texts/ch3.md` = git HEAD = game JSON + German | archive/texts/ch3.md | one text; JSON identical | — | F3 |
| `c4_quill` | beat | `archive/texts/ch4.md` = git HEAD = game JSON + German | archive/texts/ch4.md | one text; JSON identical | — | 4.01 |
| `c4_count` | visit | `archive/texts/ch4.md` = git HEAD = game JSON + German | archive/texts/ch4.md | one text; JSON identical | — | 4.03 |
| `c4_lease` | discovery | `archive/texts/ch4.md` = git HEAD = game JSON + German | archive/texts/ch4.md | one text; JSON identical | — | 4.16 |
| `c4_no` | beat | `archive/texts/ch4.md` = git HEAD = game JSON + German | archive/texts/ch4.md | one text; JSON identical | — | 4.21 |
| `c4_library` | moment | `archive/texts/ch4.md` = git HEAD = game JSON + German | archive/texts/ch4.md | one text; JSON identical | — | 4.12 |
| `c4_pizza` | scene | `archive/texts/ch4.md` = git HEAD = game JSON + German | archive/texts/ch4.md | one text; JSON identical | — | 4.33 |
| `c4_pony` | beat | `archive/texts/ch4.md` = git HEAD = game JSON + German | archive/texts/ch4.md | one text; JSON identical; latest commit wins | git aa9fd2f 2026-10-13 | 4.44 |
| `c4_quill_out` | beat | `archive/texts/ch4.md` = git HEAD = game JSON + German | archive/texts/ch4.md | one text; JSON identical | — | 4.49 |
| `c4_frame4` | frame | `archive/texts/ch4.md` = git HEAD = game JSON + German | archive/texts/ch4.md | one text; JSON identical | — | F4 |
| `c5_cough` | beat | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.01 |
| `c5_stillroom` | discovery | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.04 |
| `c5_wren_check` | visit | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.08 |
| `c5_conch` | beat | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.18 |
| `c5_first_tea` | moment | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.20 |
| `c5_poison` | scene | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.23 |
| `c5_page` | beat | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.26 |
| `c5_collapse` | beat | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.27 |
| `c5_badger` | beat | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.31 |
| `c5_letter` | beat | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | 5.42 |
| `c5_frame5` | frame | `archive/texts/ch5.md` = git HEAD = game JSON + German | archive/texts/ch5.md | one text; JSON identical | — | F5 |
| `c6_free_family` | moment | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical; latest commit wins | git 2bc03b1 2026-10-13 | leftovers |
| `c6_free_quill` | moment | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | leftovers |
| `c6_free_greenstem` | moment | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | leftovers |
| `c6_free_miller` | moment | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | leftovers |
| `c6_free_lark` | moment | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | leftovers |
| `c6_free_garden` | moment | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | leftovers |
| `c6_lord` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | 6.01 |
| `c6_broker` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | 6.04 |
| `c6_garden` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | 6.06 |
| `c6_fair_letter` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | 6.26 |
| `c6_fair_tables` | moment | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | 6.29 |
| `c6_crisis` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | 6.37 |
| `c6_bend` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | 6.38 |
| `c6_quill_answer` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | 6.40 |
| `c6_alpaca` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical; latest commit wins | git aa9fd2f 2026-10-13 | 6.41 |
| `c6_supper` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | 6.43, 6.46 |
| `c6_ajar` | beat | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | leftovers |
| `c6_frame6` | frame | `archive/texts/ch6.md` = git HEAD = game JSON + German | archive/texts/ch6.md | one text; JSON identical | — | F6 |
| `c1_fire` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.10 |
| `c1_first_harvest` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.37 |
| `c1_first_card` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | leftovers |
| `c1_weeds` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.11 |
| `c1_rocks_tap` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.39 |
| `c1_forest_tap` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.08 |
| `c1_road_tap` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.25b |
| `c1_market_tap` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.27 |
| `c1_bookcart_tap` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.30b |
| `c1_first_trip` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.26 |
| `c1_coin` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.29 |
| `c1_bench` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.25 |
| `c1_axe` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.36 |
| `c1_summer` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.34 |
| `c1_tower` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.40 |
| `c1_cleared` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.49 |
| `c1_quern` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.42 |
| `c1_scarecrow` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.46 |
| `c1_autumn` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.45 |
| `c1_coop` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.57 |
| `c1_fence` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.55 |
| `c1_winter` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.51 |
| `c1_hunger` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.52 |
| `c1_trips10` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.56 |
| `c1_spring2` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.59 |
| `c1_well2` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.47 |
| `c1_tom` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.31 |
| `c1_soup` | scene | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.50 |
| `c1_maud` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.33 |
| `c1_ella` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.32 |
| `c1_hens` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.60 |
| `c1_trips20` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.65 |
| `c1_egg` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.63 |
| `c1_winch` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.68 |
| `c1_hutch` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.70 |
| `c1_bowl` | moment | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.72 |
| `c1_n_fire` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.09 |
| `c1_n_weeds` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.12 |
| `c1_n_ash` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.38 |
| `c1_n_chickens` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.61 |
| `c1_n_market` | discovery | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.28 |
| `c1_k_spring` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | leftovers |
| `c1_k_summer` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.35 |
| `c1_k_autumn` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | leftovers |
| `c1_k_crow` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.46b |
| `c1_k_tent` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.07 |
| `c1_k_stars` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.05 |
| `c1_k_wave` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | leftovers |
| `c1_k_bell` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | leftovers |
| `c1_k_nibbled` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.71 |
| `c1_k_hands` | bark | `archive/texts/more-ch1.md` = git HEAD `texts/more-ch1.md` = `archive/staging/more-ch1.json` | archive/texts/more-ch1.md | one text; JSON generated from it | — | 1.69 |
| `c2_kiln` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.18 |
| `c2_bench` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.19 |
| `c2_stove` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.35 |
| `c2_stall` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.23 |
| `c2_bees` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.27 |
| `c2_reply` | letter | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.39 |
| `c2_greenstem_hands` | visit | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.22 |
| `c2_honey` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.29 |
| `c2_pond` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.51 |
| `c2_barn_frame` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.46 |
| `c2_cow` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.05 |
| `c2_barn_done` | beat | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.49 |
| `c2_kitten` | scene | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.31 |
| `c2_jan` | scene | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.30 |
| `c2_hilde` | scene | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.25 |
| `c2_otto` | scene | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.33 |
| `c2_snug` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.41 |
| `c2_tortoise_omen` | moment | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.52 |
| `c2_n_bread` | discovery | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.20 |
| `c2_n_bees` | discovery | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.28 |
| `c2_n_frost` | discovery | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.40 |
| `c2_n_play` | discovery | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.32 |
| `c2_n_sleep` | discovery | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.43 |
| `c2_board` | discovery | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.13 |
| `c2_k_spring` | bark | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | leftovers |
| `c2_k_hive` | bark | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | leftovers |
| `c2_k_cow` | bark | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.07 |
| `c2_k_roof` | bark | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | 2.36 |
| `c2_k_kitten` | bark | `archive/texts/more-ch2.md` = git HEAD `texts/more-ch2.md` = `archive/staging/more-ch2.json` | archive/texts/more-ch2.md | one text; JSON generated from it | — | leftovers |
| `c3_pieter2` | visit | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.32 |
| `c3_pieter3` | visit | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 4.24b |
| `c3_sheep` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.36 |
| `c3_cellar` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.40 |
| `c3_loom` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.37 |
| `c3_blanket` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.39 |
| `c3_tower` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.22 |
| `c3_sails` | beat | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.25 |
| `c3_scarecrow2` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.43 |
| `c3_iron` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.20 |
| `c3_goat_shed` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.55 |
| `c3_north` | discovery | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.59 |
| `c3_maud_goat` | scene | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.46 |
| `c3_baby` | scene | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.47 |
| `c3_dread1` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.02 |
| `c3_dread2` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.04 |
| `c3_pond_sun` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.51 |
| `c3_n_wind` | discovery | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.21 |
| `c3_n_ferment` | discovery | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.41 |
| `c3_n_weaving` | discovery | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.38 |
| `c3_n_pests` | discovery | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.45 |
| `c3_n_irrigation` | discovery | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.53 |
| `c3_board` | discovery | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.48 |
| `c3_k_wind` | bark | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.27 |
| `c3_k_pieter2` | bark | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.34 |
| `c3_k_nibbled` | bark | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.03 |
| `c3_k_forge` | bark | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.19 |
| `c3_k_summer` | bark | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.50 |
| `c3_swing` | moment | `archive/texts/more-ch3.md` = git HEAD `texts/more-ch3.md` = `archive/staging/more-ch3.json` | archive/texts/more-ch3.md | one text; JSON generated from it | — | 3.44 |
| `c4_pieter4` | visit | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.25 |
| `c4_receipt` | beat | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.26 |
| `c4_glass` | moment | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.14 |
| `c4_greenhouse` | moment | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.23 |
| `c4_scarecrow3` | moment | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.36 |
| `c4_window` | scene | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.30 |
| `c4_wedding` | scene | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.32 |
| `c4_watch` | scene | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.42 |
| `c4_mei` | letter | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.27 |
| `c4_birthday` | moment | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.43 |
| `c4_n_steel` | discovery | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.39 |
| `c4_n_glass` | discovery | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.15 |
| `c4_n_mulch` | discovery | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.24 |
| `c4_n_masonry` | discovery | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.09 |
| `c4_board` | discovery | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.35 |
| `c4_k_winter` | bark | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.40 |
| `c4_k_lease` | bark | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.17 |
| `c4_k_pony` | bark | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.46 |
| `c4_k_school` | bark | `archive/texts/more-ch4.md` = git HEAD `texts/more-ch4.md` = `archive/staging/more-ch4.json` | archive/texts/more-ch4.md | one text; JSON generated from it | — | 4.31 |
| `c5_board` | discovery | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.06 |
| `c5_dry` | moment | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.16 |
| `c5_salve` | moment | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.17 |
| `c5_lookalike` | discovery | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.09 |
| `c5_n_foxglove` | discovery | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.10 |
| `c5_n_grownup` | discovery | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.24 |
| `c5_petals` | discovery | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.39 |
| `c5_lamp` | scene | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.37 |
| `c5_tea_set` | moment | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.30 |
| `c5_badger_job` | moment | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.35 |
| `c5_k_still` | bark | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.03 |
| `c5_k_rain` | bark | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.41 |
| `c5_k_wren` | bark | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.11 |
| `c5_k_tea` | bark | `archive/texts/more-ch5.md` = git HEAD `texts/more-ch5.md` = `archive/staging/more-ch5.json` | archive/texts/more-ch5.md | one text; JSON generated from it | — | 5.21 |
| `c6_board` | discovery | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.24 |
| `c6_terraces` | moment | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.08 |
| `c6_seed_library` | moment | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.09 |
| `c6_oven` | moment | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.11 |
| `c6_whirligig` | moment | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.12 |
| `c6_dye` | moment | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.13 |
| `c6_theatre` | scene | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.23 |
| `c6_agnes` | scene | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.17 |
| `c6_flags` | moment | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.28 |
| `c6_orphanage` | scene | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.18 |
| `c6_well` | moment | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.19 |
| `c6_telescope` | scene | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.20 |
| `c6_poet` | scene | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.21 |
| `c6_painter` | scene | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.22 |
| `c6_quilt` | moment | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.16 |
| `c6_eve` | moment | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.49 |
| `c6_n_seed` | discovery | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.10 |
| `c6_n_worms` | discovery | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.14 |
| `c6_n_soil` | discovery | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.15 |
| `c6_n_last` | discovery | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.47 |
| `c6_k_summer` | bark | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.25 |
| `c6_k_fair` | bark | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.27 |
| `c6_k_alpaca` | bark | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.42 |
| `c6_k_garden` | bark | `archive/texts/more-ch6.md` = git HEAD `texts/more-ch6.md` = `archive/staging/more-ch6.json` | archive/texts/more-ch6.md | one text; JSON generated from it | — | 6.07 |
| `c2_berit_note` | discovery | game JSON only (`15-chapter-2.json`) | game JSON | the only copy (added in build step 4, `consistency-fixes.md`) | — | 2.03 |
| `c2_k_rest` | bark | game JSON only (`15-chapter-2.json`) | game JSON | the only copy (added in build step 4, `consistency-fixes.md`) | — | leftovers |
