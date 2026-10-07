#!/usr/bin/env python3
"""Copies sounds and music from ../sound-inbox/ into assets/sounds/ and fills in data/sounds.json.

    python3 tools/import_sounds.py          (from the godot-prototype folder; then run Godot once with --import)

How it finds the files: every sound in data/sounds.json has "from", a list of glob patterns inside sound-inbox/
(e.g. "kenney_rpg-audio/**/chop.ogg", "animals/chicken*"). Up to 4 matches per sound are copied to
assets/sounds/sfx/<name>_<n>.<ext>; a music track takes its first match as assets/sounds/music/<track>.<ext>.
Where they come from: sound-inbox/SOURCES.json lists each folder (or file) with its author, licence and web page; the
credits page in ⚙️ Settings is made from it. A file in a folder without a SOURCES entry is not copied (no credit, no use).
Sounds with nothing found keep their stand-in (a sound the game makes itself, or silence); the tool lists them.
"""
import glob, json, os, shutil

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
INBOX = os.path.normpath(os.path.join(ROOT, "..", "sound-inbox"))
OUT = os.path.join(ROOT, "assets", "sounds")
CAT = os.path.join(ROOT, "data", "sounds.json")
EXT = (".ogg", ".wav", ".mp3")

def source_of(rel, sources):
    """The SOURCES entry whose "path" is the longest start of rel (a folder or a file inside sound-inbox)."""
    best = None
    for s in sources:
        p = s.get("path", "").rstrip("/")
        if rel == p or rel.startswith(p + "/"):
            if best is None or len(p) > len(best["path"].rstrip("/")): best = s
    return best

def matches(patterns):
    out = []
    for pat in patterns:
        for f in sorted(glob.glob(os.path.join(INBOX, pat), recursive=True)):
            if f.lower().endswith(EXT) and f not in out: out.append(f)
    return out

def main():
    cat = json.load(open(CAT, encoding="utf-8"))
    src_file = os.path.join(INBOX, "SOURCES.json")
    sources = json.load(open(src_file, encoding="utf-8")) if os.path.exists(src_file) else []
    os.makedirs(os.path.join(OUT, "sfx"), exist_ok=True)
    os.makedirs(os.path.join(OUT, "music"), exist_ok=True)
    used = {}            # source path -> [files in assets/sounds]
    missing, uncredited = [], set()

    def take(f, dest_rel):
        rel = os.path.relpath(f, INBOX).replace(os.sep, "/")
        s = source_of(rel, sources)
        if s is None:
            uncredited.add(rel.split("/")[0])
            return False
        shutil.copyfile(f, os.path.join(OUT, dest_rel))
        used.setdefault(s["path"], []).append(dest_rel)
        return True

    for name, e in cat.get("sfx", {}).items():
        files = []
        for f in matches(e.get("from", []))[:4]:
            dest = f"{name}_{len(files) + 1}{os.path.splitext(f)[1].lower()}"
            if take(f, "sfx/" + dest): files.append(dest)
        e["files"] = files
        if not files: missing.append(name)
    for tid, t in cat.get("music", {}).get("tracks", {}).items():
        t["file"] = ""
        for f in matches(t.get("from", []))[:1]:
            dest = tid + os.path.splitext(f)[1].lower()
            if take(f, "music/" + dest): t["file"] = dest
        if not t["file"]: missing.append("music: " + tid)
    cat["credits"] = [{"what": s.get("what", s["path"]), "author": s.get("author", ""), "licence": s.get("licence", ""),
                       "source": s.get("source", ""), "files": used[s["path"]]} for s in sources if s["path"] in used]
    json.dump(cat, open(CAT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    n = sum(len(v) for v in used.values())
    print(f"copied {n} files into assets/sounds/; credits for {len(cat['credits'])} sources")
    if uncredited: print("not copied (no entry in sound-inbox/SOURCES.json): " + ", ".join(sorted(uncredited)))
    if missing: print(f"still without a file ({len(missing)}): " + ", ".join(missing))

if __name__ == "__main__":
    main()
