# Story folder

Everything about Hazelwood Harvest's **story**, sorted by role. Words: `GLOSSARY.md`; decisions: `docs/adr/`. **What happens next
is in the project's `../ROADMAP.md`** (Story track), the tickets in `../.scratch/story/issues/`, and every session adds a row to
`../PROJECT-LOG.md` (track: story).

Where things stand (30 Oct 2026, [ADR-0001](docs/adr/0001-novella-is-the-source.md)): the **novella** (`novella/story-retold.md`)
is the current story. Later it is compressed into new game pieces that replace every current piece. Until then the 63 shipped pieces
stay in the game as stand-ins and the 166 staged pieces stay on file, unbuilt. Story work waits for the prototype milestone.

## Labels used in every file

- ✅ **Decided by the parent.** Do not change without asking.
- 💡 **Proposed by Claude.** Waiting for the parent's yes or no.
- ❓ **Open question.**
- 🔒 **Hidden from the player.** The architects know it; the game reveals it slowly, or never.

## The folders

| Folder | Role | Start with |
|---|---|---|
| `canon/` | **What is true.** The story bible wins over every other file ([ADR-0002](docs/adr/0002-bible-is-canon.md)). | `canon/story-bible.md`; then `00-premise.md`, `book-file.md` (dials, fixed facts, flagged inventions), `characters/`, `world/`. `STORY-SYNOPSIS.md` is a plain spoiler-full summary of the outline. |
| `outline/` | **What happens, chapter by chapter.** | `outline/master/ch1.md … ch6.md`, `ending.md`; every story seed and its fate in `registry.md`; the ten open outline questions in `QUESTIONS.md` (ticket `story/19`). |
| `novella/` | **The story as prose**, for the developer to judge whether it grips. | `story-retold.md` (36,000 words); `story-retold-notes.md` (what changed, ten inventions: ticket `story/23`); `open-questions.md` (ticket `story/24`). |
| `game/` | **What the game runs on now** and what the story asks of it. | `story-delivery.md` (how pieces reach the player), `texts/` (the shipped `chN.md` and staged `more-chN.md` pieces), `staging/` (`md_to_story_json.py` turns texts into game JSON), `data-wishes.md` (✅ ones: ticket `story/21`), `text-change-requests.md` (paused since 27 Oct; ticket `story/20`), `code-issues-story-timing.md` (ticket `story/07`), `game-hooks.md`, `game-design-round4.md`. |
| `archive/` | **Working files of finished runs. Do not edit.** | The outline run of 23–24 Oct (`slices/` with the manager's `DECISIONS.md`, `reviews/`, `RUN-CHARTER.md`, `RUN-LOG.md`, `research/`), the 27 Oct assembly (`assembly-2026-10-27/`: inventory, assembled and repaired versions, source maps, changes, leftovers, `_build/` scripts), the consistency pass, older plans and the old outline ladder. |

## Working agreements

1. Anything invented without being asked is 💡 until the parent accepts it; accepted facts go into `canon/story-bible.md`, lasting
   rules into `docs/adr/`.
2. The hidden truth (🔒) is written only in canon files, never in player-facing text before its reveal.
3. Player-facing text: second person, the player's chosen name, no gendered word for the farmer, no counted game time; short (2–4
   sentences, about 35–45 words), words a six-year-old knows.
4. Where the story and the game data disagree, the data wins until a data wish is built
   ([ADR-0014](../docs/adr/0014-data-wins-until-a-data-wish-is-built.md)).
5. After a session: the ticket, one row in `../PROJECT-LOG.md`, and the roadmap only if "Now" changed.
