#!/bin/bash
# ------------------------------------------------------------------
# Publish web version.command  -  double-click me on the Mac.
# Pushes web-build/ to its own (public) GitHub repo as ONE fresh commit,
# replacing the old history so the repo does not grow with every build.
# Run "Build web version.command" first.
# ------------------------------------------------------------------

cd "$(dirname "$0")/web-build" 2>/dev/null || { echo "❌ No web-build folder next to this file."; read -r -p "Press Enter to close..." _; exit 1; }

pause_and_exit() { echo; read -r -p "Press Enter to close this window..." _; exit "${1:-0}"; }
fail() { echo; echo "❌ $1"; pause_and_exit 1; }

echo "🌾 Farm Quiz Game: publishing the web version"
echo

if [ ! -d .git ]; then
  fail "web-build/ is not a git repo yet. One-time setup (in Terminal):
     cd \"$(pwd)\"
     git init -b main
     git remote add origin https://github.com/<you>/<public-repo>.git
   Then double-click this file again, and in the public repo on GitHub turn on
   Settings -> Pages -> Deploy from a branch -> main / (root)."
fi
git remote get-url origin >/dev/null 2>&1 || fail "web-build/ has no 'origin' remote. Run: git remote add origin https://github.com/<you>/<public-repo>.git"
[ -f index.pck ] || fail "web-build/ has no index.pck. Run 'Build web version.command' first."

touch .nojekyll   # tells GitHub Pages to serve the files as they are

STAMP="$(date '+%Y-%m-%d %H:%M')"
git checkout -q --orphan publish-tmp || fail "git checkout failed."
git add -A
git commit -q -m "Web build $STAMP" || fail "git commit failed (is git set up with your name and email?)."
git branch -D main >/dev/null 2>&1
git branch -m main
echo "⏳ Pushing to $(git remote get-url origin) ..."
git push -f origin main || fail "Push failed. Check your GitHub login and the remote address."
git gc -q --prune=now 2>/dev/null

echo
echo "✅ Published ($STAMP). GitHub Pages usually updates within a minute or two."
pause_and_exit 0
