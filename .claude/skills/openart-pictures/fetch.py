#!/usr/bin/env python3
"""Download the versions of one OpenArt generation, keep every one, and mark the pick.

  get   python3 fetch.py get <sheet> --history ID --credits N --prompt-file P URL [URL ...]
        Saves every version to art-inbox/alternatives/<sheet>/<sheet>-v1.jpg, -v2 ... (kept for good, so the parent can swap),
        writes the prompt beside them (prompt.txt), adds one row per file to art-inbox/openart-runs.csv
        (date, sheet, version, file, credits, history id, url, picked) and rebuilds contact.html.
  pick  python3 fetch.py pick <sheet> <version> [--as NAME.png]
        Copies that version to art-inbox/<sheet>.png (as PNG, with macOS sips; Pillow if there is no sips), marks it in the
        csv and in contact.html. Picking again swaps the pick.
  spent python3 fetch.py spent
        Credits used so far, from the csv.

Only the standard library. Run from anywhere; paths are relative to the project folder. Only cdn.openart.ai addresses are fetched.
"""
import argparse, csv, datetime, html, os, shutil, subprocess, sys, urllib.parse, urllib.request

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
INBOX = os.path.join(ROOT, "art-inbox")
RUNS = os.path.join(INBOX, "openart-runs.csv")
COLS = ["date", "sheet", "version", "file", "credits", "history_id", "url", "picked"]


def rows():
    if not os.path.exists(RUNS):
        return []
    with open(RUNS, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def save(rs):
    with open(RUNS, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(rs)


def contact(sheet):
    d = os.path.join(INBOX, "alternatives", sheet)
    mine = [r for r in rows() if r["sheet"] == sheet]
    prompt = ""
    if os.path.exists(os.path.join(d, "prompt.txt")):
        prompt = open(os.path.join(d, "prompt.txt"), encoding="utf-8").read()
    out = ["<!doctype html><meta charset=utf-8><title>%s</title>" % html.escape(sheet),
           "<style>body{font:15px sans-serif;margin:16px}figure{display:inline-block;margin:8px;vertical-align:top}"
           "img{max-width:440px;border:6px solid #ddd}.pick img{border-color:#2a9d3a}pre{white-space:pre-wrap;max-width:900px}</style>",
           "<h1>%s</h1><p>Green frame = the pick used in the game. To swap: <code>python3 .claude/skills/openart-pictures/fetch.py "
           "pick %s &lt;version&gt;</code>, then import again.</p>" % (html.escape(sheet), html.escape(sheet))]
    for r in mine:
        cls = "pick" if r["picked"] else ""
        out.append('<figure class="%s"><img src="%s"><figcaption>version %s%s</figcaption></figure>'
                   % (cls, html.escape(os.path.basename(r["file"])), r["version"], " (picked)" if r["picked"] else ""))
    out.append("<h2>Prompt</h2><pre>%s</pre>" % html.escape(prompt))
    open(os.path.join(d, "contact.html"), "w", encoding="utf-8").write("\n".join(out))


def get(a):
    d = os.path.join(INBOX, "alternatives", a.sheet)
    os.makedirs(d, exist_ok=True)
    if a.prompt_file:
        shutil.copyfile(a.prompt_file, os.path.join(d, "prompt.txt"))
    rs = rows()
    start = len([r for r in rs if r["sheet"] == a.sheet])
    per = round(a.credits / len(a.urls), 2)
    for i, url in enumerate(a.urls, start + 1):
        u = urllib.parse.urlparse(url)
        if u.scheme != "https" or u.hostname != "cdn.openart.ai":
            sys.exit("not an OpenArt address: " + url)
        ext = os.path.splitext(u.path)[1].lower() or ".png"
        dest = os.path.join(d, "%s-v%d%s" % (a.sheet, i, ext))
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=120) as r, open(dest, "wb") as f:
            shutil.copyfileobj(r, f)
        if os.path.getsize(dest) < 10000:
            sys.exit("download too small, probably not a picture: " + dest)
        rs.append(dict(date=datetime.date.today().isoformat(), sheet=a.sheet, version=i, file=os.path.relpath(dest, ROOT),
                       credits=per, history_id=a.history, url=url, picked=""))
        print("saved", os.path.relpath(dest, ROOT), os.path.getsize(dest), "bytes")
    save(rs)
    contact(a.sheet)


def pick(a):
    rs = rows()
    mine = [r for r in rs if r["sheet"] == a.sheet]
    hit = [r for r in mine if str(r["version"]) == str(a.version)]
    if not hit:
        sys.exit("no version %s of %s" % (a.version, a.sheet))
    src = os.path.join(ROOT, hit[0]["file"])
    dest = os.path.join(INBOX, a.name or (a.sheet + ".png"))
    if src.lower().endswith(".png"):
        shutil.copyfile(src, dest)
    elif shutil.which("sips"):
        subprocess.run(["sips", "-s", "format", "png", src, "--out", dest], check=True, stdout=subprocess.DEVNULL)
    else:
        from PIL import Image
        Image.open(src).save(dest)
    for r in mine:
        r["picked"] = "yes" if r is hit[0] else ""
    save(rs)
    contact(a.sheet)
    print("picked version", a.version, "->", os.path.relpath(dest, ROOT))


def spent(_):
    rs = rows()
    print("credits used: %.0f in %d pictures" % (sum(float(r["credits"] or 0) for r in rs), len(rs)))


p = argparse.ArgumentParser()
sub = p.add_subparsers(dest="cmd", required=True)
g = sub.add_parser("get"); g.add_argument("sheet"); g.add_argument("--history", default=""); g.add_argument("--credits", type=float, default=0)
g.add_argument("--prompt-file"); g.add_argument("urls", nargs="+"); g.set_defaults(fn=get)
k = sub.add_parser("pick"); k.add_argument("sheet"); k.add_argument("version"); k.add_argument("--as", dest="name"); k.set_defaults(fn=pick)
s = sub.add_parser("spent"); s.set_defaults(fn=spent)
a = p.parse_args()
a.fn(a)
