# Refactor first, then a playable prototype, then the story; the project layout that serves it

Agreed with the parent on 30 Oct 2026 (planning chat before the tidy-up). The milestones run in this order: **refactor** (make later
work easier and cheaper in tokens for the AI that codes), **prototype** (fully playable on the laptop, mostly self-explanatory for the
child, no major kinks: market screen, payments, the 23 Oct play-test fixes), **story** (compress the novella into game pieces).
The iPad, the web build and GitHub publishing are parked until the prototype stands.

The project is laid out for Matt Pocock's skill set (`ask-matt`): tickets in `.scratch/<feature>/issues/`, two glossary areas
(game at the root, story in `story/`) mapped by `GLOSSARY-MAP.md`, decision records in `docs/adr/` and `story/docs/adr/`, the design
split per system in `docs/design/`, one `ROADMAP.md` and one `PROJECT-LOG.md` for every track, and the working rules in
`.claude/skills/`.

## Rules that come with it

- **Every ticket has a milestone** (`refactor | prototype | story | later`); the roadmap shows only `refactor` and `prototype`.
- **End of every session, every track:** the ticket's status, one log row, the roadmap only if "Now" changed, and `docs/design/`
  when the game's behaviour changed. Then a ready commit message; the parent commits from the Mac.
- **Questions to the parent** come in rounds of at most three, each with a 💡 recommendation, worded so that "yes" accepts it.
  Every `needs-parent` ticket carries a recommendation and a size: *quick* (under a minute), *short* (a few minutes), *sitting*
  (a design interview or a play-test).
- **Deleting on the Mac** needs one permission request per session.

## Considered options

Keeping `TODO.md` as index and record (rejected: finishing a ticket meant editing five places, and the 88 KB file cost every
session tokens) and keeping one design document (rejected: 106 KB to load for a change to one system).
