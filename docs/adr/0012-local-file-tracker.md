# The tracker is local files with three statuses

Open work is one Markdown file per ticket in `.scratch/<feature>/issues/`, with exactly one of three statuses: `ready-for-agent`,
`needs-parent`, `done`. There is no `in-progress`: a session that stops halfway adds a `## Progress` note instead. Done tickets keep
their files as history. Chosen by the parent on 23 Oct 2026 (in `.scratch/` then; moved to `.scratch/` on 30 Oct, ADR-0001).
