# Outline run: charter

Started 23 Oct 2026. The parent asked for a rich, layered outline of the whole story (with character profiles, world building, story bible) built by rounds of fresh-eyed agents, running on its own for a long while. This file is the rulebook every agent in the run reads first. The "story manager" is the Claude session that started the run; it schedules, merges, snapshots and decides.

## 1. What the parent decided (grilling, 23 Oct 2026)

- Agents may edit anything in `story/` **except** the frozen zone (§2). Anything that contradicts a ✅ decision is written as a 💡 proposal in `QUESTIONS.md`, never edited in silently. Agents never settle a ❓ themselves.
- "Richer" means, in this order: (1) people who want something from the player; (2) a deadline that bites; (3) mystery steps, one per clue; (4) giggles, so the warm beats are earned. **Plus immersion:** a world that feels lived in, which needs far more world building and background (the village goes on without the player).
- Each chapter aims at roughly **25–40 event seeds** (§5), mapped onto the game's trigger kinds.
- **Structure:** six chapters, six pets, the hidden truth and the frame stay. *Some restructuring is allowed* (merging, splitting, reordering beats or acts) if an author, a reviewer or the manager judges the story needs it. The manager approves it and logs it in `slices/DECISIONS.md` with the reason. Restructuring never overrides a ✅ fact in §3.
- The opening proposal (say "fifteen" aloud, name Berit, the box, Moonedge; spread the exposition over the first six boxes) is OK for now and may be reworked if the story calls for it.
- The run goes **without waiting for the parent** for many rounds. Every round is snapshotted (§7) so the parent can roll back.

## 2. The frozen zone (never touch)

`story/texts/` (all of it), `story/staging/`, `godot-prototype/`, every `data/` folder, `data/i18n`, the root `TODO.md`, `PROJECT-LOG.md`, `00-READ-ME-FIRST.md`, `issues/`, `web-build/`. Other agents are working on the game in the same checkout. **No git command that writes** (no add, commit, stash, checkout, pull, reset). Read-only git is fine.

Existing story docs outside the frozen zone (`characters/`, `world/`, `outline/`, `book-file.md`, `00-premise.md`, ...) are live canon. Only the manager and the integration tickets edit them. Slice authors write into their own slice folder (§4).

No player-facing prose is produced in this run. Events are described in beat language. Dialogue sketches (a line or two, marked *sketch*) are allowed inside dossiers to fix a person's voice, never as final text.

## 3. Locked facts ✅ (propose changes in QUESTIONS.md, do not edit)

- The player is the farmer: second person, the player's chosen name, no gendered word, no looks. For the architects the farmer is **Fenna, female, 15 at the start** (born Y−8, 8 at the fire, Y+7 at the start). She is Minena's grandmother; Minena is a child in the frame; the grown-up farmer is never described.
- Six Helpers (bunny, tortoise, goat, pony, badger, alpaca) come home one by one; they do not talk; the six-line farm rhyme runs through the story.
- The hidden truth: the fire began in the hay barn while the girl played with Mumyo; the Lord (Lord Wexley) took more each year and owes upward; the chain reaction dried the land; the family split (parents, siblings, cousin to a river town; Fenna and grandmother Berit to a hill cottage). Fenna never sees Mumyo again; the player sometimes does.
- The one wheat stalk with one grain; the bunny kept the patch alive.
- The melody comes from the conch in the Moonstone Forest (deepest layer 🔒🔒, never in any text).
- The frame ends with: *"If you meet a little fellow with bells, tell him I was never angry."*
- Steward arrives in chapter 4; no religion (light pagan folk belief); game time is never counted in player texts (D11).
- Full list and labels: `00-premise.md`, `book-file.md`, `story/README.md`.

## 4. How the run is organised

```
story/
  RUN-CHARTER.md       this file
  RUN-LOG.md           one row per round: what ran, what was merged, snapshot name
  QUESTIONS.md         the parent's queue: ❓ questions and 💡 proposals that touch a ✅ fact
  tickets/             one file per ticket (format of issues/README.md §3), numbered, blocking edges written
  slices/              one folder per slice: slices/<id>-<slug>/dossier.md (+ more files if needed)
    DECISIONS.md       the manager's decisions (restructuring, merges, conflicts)
  reviews/             fresh-eye reviews, one per slice or round
  archive/run-2026-10-23/   snapshots (00-before-run, then after-round-NN)
```

- A **slice** is a *vertical* tracer bullet: one thread or one stretch of play taken from the idea down to concrete events, people, places and facts, touching character, world, outline and bible only as far as that thread needs. Not "all characters, then all world".
- **Parallel safety:** an author writes only inside its own `slices/<id>-<slug>/` folder (and may append to `QUESTIONS.md`, one block, at the end). It reads other slices' dossiers but never edits them. The integration tickets later merge dossiers into canon.
- **Fresh eye:** each author and reviewer starts cold. No agent gets the previous agent's reasoning, only files.

## 5. The shape of an event seed

Every slice dossier that proposes events lists them in this form (one block each, 4–6 lines):

```
### E-<chapter>.<nn> <short name>
Kind: moment | discovery | visit | scene | letter | bark | beat | trace   (see ../story-delivery.md)
Trigger idea: a game condition in plain words (done:<node>, tap:<place>, season, trips>=n, seen:<piece> ...)
Who wants what / what is in the way: ...
What changes (a fact, a person's stance, an object, a clock): ...
Register: G | W | T | A   (dominant)      Carries: <exposition fact or clue, if any>
Plant/payoff: plants X, pays off Y (event ids)
```

Craft rules from live-wire-style apply to the *design* of events: every event is a want meeting an obstacle; the spine of the farmer drives the joke; comedy is the carrier wave and warm/tense/awe punctuate; no three identical registers in a row; every warm beat has a giggle or tension just before it; awe 2–4 times per chapter ladder at most, never adjacent; the tension line rises across the book; stakes persist and cost something.

## 6. The skills agents use

- **live-wire-style** (children's early chapter-book craft). Files to read before working, as plain files:
  `/Users/amirmoye/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/a39a8dc8-0d64-448e-a901-2083849777ae/ecc1131f-ad6a-45c8-9442-d9cd991d5e36/skills/live-wire-style/` → `SKILL.md`, then `reference/character.md`, `reference/structure.md` (authors), `reference/diagnose.md` (reviewers), `reference/texture.md` and `reference/calibration.md` only if the ticket asks. Do not load `FIELD_GUIDE.md`. Three dials for this book: language comfortable for a six-year-old, story built for an eight-year-old, texture dialogue-forward with people, narration-forward for wonder.
- **Vertical slices and tickets** (from ask-matt: grill → spec → tickets of tracer-bullet slices with blocking edges): one ticket = one slice = one agent. Blocking edges are real: do not start a ticket whose blockers are not `done`.
- Labels: ✅ decided by the parent · 💡 proposed (everything new) · ❓ open · 🔒 hidden from the player. Anything invented goes into the dossier's **Inventions** list, so the manager can accept or overrule it.

## 7. Rounds, reviews, snapshots

1. The manager picks the ready tickets (blockers `done`), at most 3 at a time, on disjoint files.
2. Each author writes its dossier, ticks the ticket's boxes and sets `Status: done`.
3. A fresh reviewer reads the dossier against the digest and the diagnose lens (charge audit, bottleneck, leaks, the "lived-in" test) and writes `reviews/<id>.md`: what holds, what is thin, concrete fixes ranked, contradictions found.
4. The manager reads the review, applies or queues the fixes (a short follow-up ticket if big), updates `RUN-LOG.md`, and takes a snapshot: `rsync -a --exclude archive ./ archive/run-2026-10-23/after-round-NN/` run from `story/`, but with `texts/` and `staging/` left out (they are frozen and already in `00-before-run`).
5. When all slices S1–S8 are done, the integration ticket merges dossiers into canon and a whole-book review runs; then the manager sets the next cycle (deepening) and continues.

## 8. When the run stops

The manager stops and reports when: a cycle's reviewer says the outline is rich enough and the remaining notes are polish; the same fault comes back in two consecutive reviews (change method, not effort); QUESTIONS.md holds a ❓ that blocks more than half the remaining tickets; or the parent says stop. The honest end state is a rich outline plus a child reading it. If more reviewing would not help, say so.
