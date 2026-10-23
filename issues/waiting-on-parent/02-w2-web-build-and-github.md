# 02: W2: Get the web build published: GitHub repos, the double-click scripts, big pictures

**What to build:** The parent can build and publish the web version with the two double-click scripts, and the iPad opens the game from its Home Screen. GitHub refuses files over 100 MB, and `web-build/index.pck` is already 89 MB, so the next big batch of pictures needs a plan first.

**Blocked by:** None (can start immediately)

**Status:** needs-parent

**Note (23 Oct 2026):** the story pictures turned out small: lossy WebP, about 84 KB each in the pack, about 3 MB now and about 5 MB with all of them (`story/17`). The 100 MB question remains for other future pictures (a plan is still needed, but not because of the story pictures).

- [ ] A plan for files over 100 MB is chosen (compress the pictures for the web, or Git LFS)
- [ ] The public web repo exists (`00-READ-ME-FIRST.md` §4.7) and GitHub Pages is on
- [ ] `Build web version.command` has run once on the Mac
- [ ] `Publish web version.command` has run once on the Mac
- [ ] The iPad Home Screen link opens the game

---

**Id:** W2 · **Feature:** `waiting-on-parent` · **Moved from** `TODO.md` §1 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **W2. GitHub repos and the double-click scripts.** ⚠️ With the round 8 pictures `web-build/index.pck` is 89 MB; GitHub refuses
  files over 100 MB, so the next big batch of pictures needs a plan (compressing the pictures for the web, or Git LFS). The private repo exists. Still to do: the public web repo
  (`00-READ-ME-FIRST.md` §4.7), GitHub Pages, the first run of `Build web version.command` and `Publish web version.command` on the
  Mac, the iPad Home Screen link. Cloud sessions can push to the private repo (a 403 on 7 Oct 2026 went away once the Claude GitHub
  App had write access).
