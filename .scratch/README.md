# Issue tracker: configuration

This is the configuration that `/setup-matt-pocock-skills` would write. When a skill (`to-spec`, `to-tickets`, `tdd`, `triage` …)
asks for the issue tracker or the label vocabulary, or says to run `/setup-matt-pocock-skills`, **this file is the answer**.
Why it is set up this way: [ADR-0001](../docs/adr/0001-refactor-first-and-project-layout.md) and [ADR-0012](../docs/adr/0012-local-file-tracker.md).

## Tracker

- **Local files.** One ticket per file: `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` in dependency order
  (blockers first). A spec sits at `.scratch/<feature-slug>/spec.md`.
- A blocker is written `<feature>/<NN>` (for example `farm-actions/14`), plus the old id in brackets where a ticket has one (`W9`).
  "The whole `x` feature" means every ticket in `.scratch/x/issues/`.
- A feature that starts with `01-grill-and-spec.md` keeps it as `01`; `/to-tickets` continues from `02`.
- Old ids (`M5`, `W9`, `I14` …) stay in titles and file names: `grep -rn "W9" .scratch` finds them.

## Ticket template

```
# NN: Title

**What to build:** the end-to-end behaviour this makes work, from the child's or parent's side.

**Blocked by:** <feature>/<NN>, or "None (can start immediately)".

**Status:** ready-for-agent | needs-parent | done

**Milestone:** refactor | prototype | story | later

**Size:** quick | short | sitting        (needs-parent tickets only)

- [ ] Acceptance criterion
```

No file paths or code in new tickets (they go stale), except a decision-rich snippet from a prototype. Use the words in
`GLOSSARY.md` (game) or `story/GLOSSARY.md` (story) and respect the ADRs. Every game change also gets the boxes the check skill asks
for (German through `i18n.py`, smoke test, bot, golden runs for refactors, old saves load, the `docs/design/` file it changes).

## Labels (exactly one per ticket, on the `**Status:**` line)

| Label | Meaning |
|---|---|
| `ready-for-agent` | Decided; an agent can build it without asking. |
| `needs-parent` | Waits for the parent: a decision, play-test, review, picture or a grilling. Carries a 💡 recommendation (options with trade-offs where the choice is not obvious) and a **Size**. An agent may prepare, not build. |
| `done` | Built and checked, or done by the parent. The file stays as history. |

No `in-progress` label: a session that stops halfway ticks what it finished and adds a `## Progress` note. Old marks in ticket text
(✅ decided, 💡 proposed, ❓ question) are notes, not statuses.

## Milestones

`refactor` (now), `prototype` (next), `story`, `later`. Only `refactor` and `prototype` appear in `ROADMAP.md`.

## Frontier and queue

`tools/tracker.py` prints the **frontier** (ready tickets whose blockers are all done) and the **parent's queue** (`needs-parent`,
quick ones first, blockers of the refactor milestone on top). `tools/check_docs.py` checks every ticket has a Status and a Milestone.

## Flow for new work

`/grill-with-docs` → `/to-spec` (writes `spec.md`) → `/to-tickets` → build each frontier ticket with `/tdd`. Skills that are not
installed (`/implement`, `/triage`, `/retro`, `/code-review`): do their job by hand with these rules.
