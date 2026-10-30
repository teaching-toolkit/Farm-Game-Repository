import re, sys
R = "00-READ-ME-FIRST.md"
s = open(R, encoding="utf-8").read()

def rep(old, new):
    global s
    assert old in s, old[:60]
    s = s.replace(old, new, 1)

# §3 table
rep("| `web-build/` | the latest web export",
    "| `Publish web version.command` | **double-click on the Mac** to push `web-build/` to the public GitHub repo as one fresh commit (see §4.7) |\n"
    "| `CLAUDE.md` | short pointer for Claude Code cloud sessions: read this file, keep the log and to-do list current, set up Godot |\n"
    "| `.gitignore` | what the private repo leaves out (`.godot/` caches, `web-build/`, big archive screenshots, `.DS_Store`) |\n"
    "| `web-build/` | its own **public** git repo, ignored by the private one; the latest web export")

# §4.1 cloud sessions
rep("### 4.2 Run the checks",
    "- **Claude Code cloud sessions** work on the private GitHub repo (a mirror of this folder). The machine starts empty, so first run\n"
    "  `bash godot-prototype/tools/setup_godot.sh` (Godot only; add `--screens` for Xvfb, `--art` for Pillow/numpy/scipy, `--web` for\n"
    "  the web export templates, ~1 GB download), then import once: `cd godot-prototype && $G --headless --path . --import`.\n"
    "  Tested 7 Oct 2026: smoke test, bot, screenshot and web export all work this way. `web-build/` is not in the private repo.\n\n"
    "### 4.2 Run the checks")

# §4.4
rep("The parent can do this alone: double-click `Build web version.command` (Mac).",
    "The parent can do this alone: double-click `Build web version.command` (Mac), then `Publish web version.command` (§4.7).")

# §4.7 repos (before §5)
rep("## 5. Where we left off",
    "### 4.7 GitHub repos\n\n"
    "- **Private repo** = a mirror of this whole folder (the parent pushes it from the Mac). The single root `.gitignore` decides\n"
    "  what stays out. Cloud sessions commit or open pull requests there; the parent pulls them to the Mac. The old\n"
    "  `Claude outputs/*.tgz` bundles are no longer needed for that.\n"
    "- **Public repo** = only `web-build/`, which is a separate git repo nested inside this folder (one-time setup:\n"
    "  `cd web-build && git init -b main && git remote add origin https://github.com/<you>/<public-repo>.git`). GitHub Pages serves it\n"
    "  (Settings → Pages → Deploy from a branch → `main`, root). `Publish web version.command` replaces the history with one commit\n"
    "  each time, because `index.pck` (~50 MB) and `index.wasm` (~40 MB) change with every build and would make the repo grow fast.\n"
    "- Everything in the web build (data, quiz packs, pictures) is public to anyone with the link (accepted for now; see §6).\n\n"
    "---\n\n"
    "## 5. Where we left off")

# §5
rep("Waiting on the parent: picking the round 8 pictures (see open task 1).",
    "Waiting on the parent: picking the round 8 pictures (see open task 1), and setting up the GitHub repos and trying the two\n"
    "double-click scripts on the Mac (open task 2).\n\n"
    "7 Oct 2026 (after 2.0): added `Build web version.command`, `Publish web version.command`, `CLAUDE.md`, the root `.gitignore`\n"
    "and `godot-prototype/tools/setup_godot.sh` for cloud sessions. No game changes; `web-build/` still matches the code.")

# §6: insert new task 2 and a final watch item, then renumber
i = s.index("## 6. Open tasks"); j = s.index("\n## 7.", i)
sec = s[i:j]
new2 = ("2. **GitHub repos and the double-click scripts.** Create the private repo (mirror of this folder) and the public web repo\n"
        "   (§4.7), turn on GitHub Pages, then try `Build web version.command` and `Publish web version.command` on the Mac for the\n"
        "   first time (both written and tested in Linux, not yet run on the Mac). Point the iPad's Home Screen app at the Pages link.\n")
k = sec.index("\n2. **Play-test")
sec = sec[:k+1] + new2 + sec[k+1:]
sec = sec.rstrip("\n").rstrip("-").rstrip("\n") + "\n"
sec += ("99. **Keep an eye on the public web build.** Everything in it (game data, quiz packs, pictures) can be downloaded by anyone\n"
        "    with the link. Fine for now (parent's decision, 7 Oct 2026); revisit if content becomes personal (e.g. the child's name,\n"
        "    photos, the learning record) or if the art should not be shared. Options then: a private host or a password-protected one.\n\n---\n")
n = [0]
def renum(m):
    n[0] += 1
    return f"\n{n[0]}. **"
sec = re.sub(r"\n\d+\. \*\*", renum, sec)
s = s[:i] + sec + s[j:]
open(R, "w", encoding="utf-8").write(s)

L = "PROJECT-LOG.md"
t = open(L, encoding="utf-8").read()
row = ("| **Repos & cloud** (7 Oct 2026) | Set up for GitHub: root `.gitignore`, `CLAUDE.md`, `Publish web version.command` (pushes "
       "`web-build/` to a public repo as one commit) and `godot-prototype/tools/setup_godot.sh` (installs Godot 4.7.2, optionally Xvfb, "
       "the art packages and web templates, in a fresh Linux session). Tested in a cloud container: smoke test passes, bot reaches "
       "chapter 5 after 729 questions, screenshot and web export work. Decision: private repo = the folder; public repo = `web-build/` "
       "only, served by GitHub Pages; the public web build is accepted for now (to-do to revisit). |\n")
a = t.index("| **Build script**"); b = t.index("\n", a)
t = t[:b+1] + row + t[b+1:]
t = t.replace("| 2.0 | The master design document describes the game only;",
  "| 2.0 (repos) | Two GitHub repos: a private mirror of the folder for work and cloud sessions, a public one with only `web-build/` for the iPad (GitHub Pages). The public build's contents are accepted as public for now. |\n| 2.0 | The master design document describes the game only;", 1) if False else t
# put the decision row after the 2.0 decision row
d = t.index("| 2.0 | The master design document"); e = t.index("\n", d)
t = t[:e+1] + "| 2.0 (repos) | Two GitHub repos: a private mirror of this folder (work, cloud sessions) and a public one with only `web-build/` (GitHub Pages, for the iPad). Its contents being public is accepted for now. |\n" + t[e+1:]
t = t.replace("- Code changes reach the project as bundles (`Claude outputs/<name>.tgz`) installed into `godot-prototype/`; use a new bundle\n  name every time.",
  "- Code changes reach the project directly (Cowork sessions edit the folder on the Mac; cloud sessions commit to the private\n  GitHub repo). The older way, bundles in `Claude outputs/<name>.tgz`, is no longer needed.")
open(L, "w", encoding="utf-8").write(t)
print("patched")
