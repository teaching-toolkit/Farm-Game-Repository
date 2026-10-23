# Issues: how work is tracked in this project

Since **23 October 2026** the open work of the Farm Quiz Game lives here, one file per ticket. `TODO.md` is the index and the plan
(one line per open ticket); this folder is the tracker. This file is the tracker configuration that the skills `to-spec`,
`to-tickets` and `tdd` ask for ("the issue tracker and label vocabulary"): **if one of them says to run `/setup-matt-pocock-skills`,
that is this file instead.** Decided with the parent on 23 Oct 2026 (log §2.8).

## 1. Layout

```
issues/
  README.md                       this file
  <feature>/                      one folder per feature (a lowercase slug)
    spec.md                       the spec, when there is one (see §5)
    01-<slug>.md                  tickets, numbered in dependency order
    02-<id>-<slug>.md             tickets that came from an old TODO.md task carry the old id in the name
```

- The tracker is **local files**. A ticket is **always its own file**, never a combined file.
- Features so far: `waiting-on-parent` (what only the parent can do), `design-paper`, `pictures`, `crops-and-items`, `money-market`,
  `skills-quality`, `wellbeing`, `nature`, `people`, `curriculum`, `upgrades`, `story`, `later`, the play-test features
  `interface-feel`, `season-look` and `action-budget`, and the five features from the architecture review: `farm-actions`,
  `time-question`, `condition-language`, `interruption-queue`, `farm-numbers` (`farm-actions` is specified: `farm-actions/spec.md`), and `pets-automation` (from the farm-actions grilling).
- **Numbering** is per folder, blockers first. A feature that starts with a `01-grill-and-spec.md` ticket keeps it as `01`; the
  build tickets that `/to-tickets` writes after the spec continue from `02`.
- **A blocker is written** `folder/NN` (and the old id in brackets), for example `waiting-on-parent/02` (W2): the file
  `issues/waiting-on-parent/02-*.md`. "The whole `x` feature" means every ticket in that folder.

## 2. Status: three labels

The line `**Status:** <label>` in a ticket holds exactly one of these:

| Label | Meaning |
|---|---|
| `ready-for-agent` | Decided. An agent can build it now without asking the parent anything, and the checkboxes can be checked. |
| `needs-parent` | Waiting for the parent: a decision, a play-test, a review, a picture, material, or the grilling that turns an idea into a spec. The ticket says what the parent has to do. An agent may prepare (options with a 💡 recommendation, a draft) but does not build. |
| `done` | Built and checked, or done by the parent. Boxes ticked, log row added. |

There is **no `in-progress` label** (the parent chose three). A session that stops halfway ticks the boxes it finished and adds a
short `## Progress` note at the end of the ticket; the status stays as it was.

**The frontier** is every ticket whose status is `ready-for-agent` and whose blockers are all `done`. That is what an agent works on.
All statuses at a glance: `grep -rn "^\*\*Status:\*\*" issues --include='[0-9]*.md'`.

**Old labels** (✅ 💡 ❓ ⚠️ 🔗, kept in the text of older tasks) are notes, not statuses: ✅ means *decided by the parent* (not built),
💡 *proposed by Claude*, ❓ *a question*. A ticket whose point rests only on a 💡 or ❓ is `needs-parent`. If the parent is away,
an easy-to-undo 💡 may be taken: change the status to `ready-for-agent`, write the assumption into the ticket and into the log §2.6.

## 3. A ticket

```
# NN: <old id: >Title

**What to build:** the behaviour this makes work, from the child's or parent's side, not a list of layers.

**Blocked by:** folder/NN (id), or "None (can start immediately)".

**Status:** ready-for-agent | needs-parent | done

- [ ] acceptance criterion (checkable)

---
(Id, feature and where it came from; for old tasks the original text of TODO.md, unchanged, under "## Original notes")
```

- **Vertical slices.** A ticket cuts a narrow but complete path through everything it touches (data, rules, interface, bot, German,
  checks) and fits one fresh session. A prefactoring ticket comes first. A wide mechanical change goes expand → migrate → contract.
- **Words.** Use the project's vocabulary (the architecture review and plan: module, seam, interface, system, kit). The words
  are in `GLOSSARY.md`; there is no `docs/adr/` yet (`/grill-with-docs` may create it). New text avoids file paths and code (they go stale); the
  notes moved from `TODO.md` keep theirs.
- **Every game change still needs** what `claude-skills/farm-game-check/SKILL.md` and `farm-game-content/SKILL.md` ask for (German
  through `tools/i18n.py`, the smoke test, the bot, golden runs, the design document, old saves load). Put what applies as boxes.

## 4. The flow for new features

1. `/grill-with-docs` with the parent on the idea (multiple choice where possible).
2. `/to-spec` writes `issues/<feature>/spec.md` and sets its status.
3. `/to-tickets` writes the numbered tickets next to it, with their blockers.
4. Build each frontier ticket with `/tdd`, one at a time, each passing the checks before the next.

If a skill that is not installed is named (`/triage`, `/implement`, `/code-review`), do its job by hand with these rules.

## 5. Specs

`issues/<feature>/spec.md`, written from the `/to-spec` template: Problem Statement, Solution, User Stories, Implementation Decisions,
Testing Decisions, Out of Scope, Further Notes. The first lines are the title and `**Status:** ready-for-agent` (the label
`/to-spec` applies when it publishes). The seams for testing are named in the spec and agreed with the parent first. Specs for
refactors say that the golden runs must stay identical.

## 6. Working on a ticket (the standing rule, here)

- **Start:** take a ticket from the frontier, say in one line which one, read its notes. For a bigger step write the short plan
  into the ticket first (session skill §3).
- **As you go:** tick boxes, add a `## Progress` note if you stop. A new job becomes a new ticket (and a line in `TODO.md`); a
  question for the parent becomes a `needs-parent` ticket with a 💡 recommendation.
- **Done:** every box ticked and checked → `**Status:** done` → the ticket's line leaves `TODO.md` → one row in
  `PROJECT-LOG.md` §1 → the design document describes the game as it now is. **The file stays** (deleting is blocked on the linked Mac,
  and it is the history); `done` tickets are skipped by the frontier.
- **New ticket or status change** → update its line in `TODO.md` (the index). The line format is
  `- **<id>: <title>** · \`<status>\` · blocked by <folder/NN> · [path](path)`.

## 7. Old ids

Every open task of the old `TODO.md` became a ticket and kept its id (`M5`, `W9`, `I14` …) in its title and file name. Files that
point at "`TODO.md` M5" still work: `grep -n "M5" TODO.md` finds the index line, which links the ticket. To find a task anywhere:
`grep -rn "<id>" TODO.md issues`. Entries that are decided and built (for example J2–J9, M2–M13, S1–S5) stayed in `TODO.md` in
full as the record; if one still has a gap, make it a ticket. Moving those finished records to the log is a clean-up that has not been done.

## 8. Git

On the linked Mac no git commands that write (see the session skill §5); the parent commits. End a session with a ready commit message.
