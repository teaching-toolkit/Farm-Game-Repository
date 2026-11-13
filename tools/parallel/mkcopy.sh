#!/bin/bash
# Usage: [S=/some/scratch/dir] bash tools/parallel/mkcopy.sh <name>  -> $S/w/<name>/{work,base,home}: a private copy of the real project (uncommitted edits included), a pristine base, a throwaway HOME for Godot.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"; R="$(cd "$HERE/../.." && pwd)"; S="${S:-${TMPDIR:-/tmp}/farm-parallel}"; mkdir -p "$S"
N="$1"; [ -n "$N" ] || { echo "usage: mkcopy.sh <name>"; exit 2; }
W="$S/w/$N"
rm -rf "$W"; mkdir -p "$W/work" "$W/home"
rsync -a --exclude .git --exclude .godot --exclude web-build --exclude "Claude outputs" --exclude archive --exclude art-inbox --exclude sound-inbox --exclude reference-art --exclude "handoff-*.md" --exclude __pycache__ --exclude .DS_Store "$R/" "$W/work/"
rsync -a "$W/work/" "$W/base/"
for d in archive art-inbox sound-inbox reference-art; do ln -s "$R/$d" "$W/work/$d"; ln -s "$R/$d" "$W/base/$d"; done
echo "$W ready"
