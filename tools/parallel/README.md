# Parallel ticket agents (how wave 1 of 9 Nov 2026 was run)

Several agents build separate tickets at the same time, each in its own private copy of the project, and the orchestrator merges their
patches. No git writes anywhere. Used on the Mac, where the parent commits.

1. `S=/some/scratch bash tools/parallel/mkcopy.sh <name>`: makes `$S/w/<name>/{work,base,home}` (the project with uncommitted edits, a pristine base,
   a throwaway `HOME` for Godot so tests can never touch the parent's real saves in `~/Library/Application Support/Godot/`).
2. Start one agent per ticket (or per chain of tickets that touch the same files) with a short prompt that says: *read `tools/parallel/PROTOCOL.md`
   first, your NAME is `<name>`, your tickets are ...*. Tickets that change the same files, the pace or the golden runs go in one chain or in a later wave.
3. When an agent reports: `S=$S python3 tools/parallel/export_patch.py <name>` (the agent does this itself), then `S=$S python3 tools/parallel/apply_patch.py <name> --dry-run`
   and without `--dry-run`; `--force` applies what it can and leaves `.rej` files to fix by hand (shared files: `README.md`, `ui_smoke.gd`, `ui_driver.gd`, `ui-de.json`).
4. Re-check the **merged** tree in a fresh copy (`check_all.sh --short`, golden runs, the bot to chapter 5), record golden files once, add the log rows.

Agents stopped by an API limit keep their copy: resume them with `SendMessage` instead of starting new ones. Agents never touch `PROJECT-LOG.md` or `ROADMAP.md`.
