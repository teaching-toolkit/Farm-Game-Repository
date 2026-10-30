# Roadmap

One page. What the project is working on now, next and later, per track. It lists only the `refactor` and `prototype` milestones;
the tickets themselves are in `.scratch/` and `python3 tools/tracker.py` prints the frontier (what an agent can start) and the
parent's queue. Change this page only when "Now" changes. Why the order: [ADR-0001](docs/adr/0001-refactor-first-and-project-layout.md).

**Milestones in order:** refactor (now) → prototype → story. Parked: iPad, web build, GitHub publishing (W2, W9) until the
prototype stands.

## Game

- **Now (refactor):** the parent's review pass is finished (30 Oct 2026). Two things run side by side:
  - **With the parent there:** the design interview for `time-question` (`time-question/01`, `/grill-with-docs`), then
    `/to-spec` and `/to-tickets`.
  - **Without the parent, or between rounds:** build the ready refactor tickets: `farm-actions/15` (remove the seed-buying path),
    `farm-actions/16` (orchard trees use the field multiplier), `farm-actions/14` (Wren never takes coins), `tuning/01` (timing
    numbers into one data file). `python3 tools/tracker.py` lists them first.
- **Next (refactor):** `condition-language`, then `interruption-queue`, each through the same flow
  (`docs/architecture-review-2026-10-22.md` Part B §3–4).
- **Then (prototype):** a laptop game the child can play alone without major kinks: the 23 Oct play-test tickets
  (`interface-feel`, `season-look`, `money-market`, `nature/04–05`, `crops-and-items`), the village square as its own screen with
  working payments, `action-budget` and `pets-automation` (both start with a grilling).
- **Later:** `farm-numbers`, curriculum, wellbeing levers, people as figures, iPad and web.

## Story

- **Now:** nothing; the story waits for the prototype. The 63 shipped pieces stay as stand-ins.
- **Next (story milestone):** the parent reads the novella and answers `story/19`, `story/23` and `story/24`; then the novella is
  compressed into new pieces that replace every current one ([story ADR-0001](story/docs/adr/0001-novella-is-the-source.md)).
- **Prototype work touching the story:** `story/07` (timing), `story/10–15` (frames, season boxes, funny messages; `story/13` is delegated to Claude).

## Pictures

- **Now:** nothing.
- **Next (prototype):** the window pictures (`pictures/08` → `09`), the village sign (`pictures/11`), the village square and merchants
  (`pictures/04`, `06`), straw, flour and hay (`pictures/01`), building stages (`pictures/05`), season pictures (`pictures/12`).

## Sounds

- **Next (prototype):** the missing sounds (`waiting-on-parent/07`, W8).

## Docs

- **Now:** nothing (the tidy-up finished on 30 Oct 2026).
- **Next (prototype):** bring `docs/design/` up to date for everything built since 0.10.0 (`design-paper/01`, D1).
