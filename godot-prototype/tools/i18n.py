#!/usr/bin/env python3
"""Collects every text the player can see and keeps the language files in data/i18n/ up to date.

    python3 tools/i18n.py            (from the godot-prototype folder)
    python3 tools/i18n.py --check    only report (nothing written); exit code 1 if a language misses texts

Interface: every literal in tr("…") or T("…") in scripts/*.gd and learnkit/*.gd  →  data/i18n/ui-<lang>.json
    {"English text": "translation"}. A new text is added with "" (= still English); texts no longer in the code move
    to "_unused" (kept for a while, so a reworded text can take its old translation back by hand).
Game data: names, descriptions, card pages and questions, steps, album pictures, postcards … (the rules below)
    →  data/i18n/data-<lang>.json   {"nodes/crop_wheat/name": {"en": "Wheat", "de": "Weizen"}}
Rest sums: level names, kind words, titles, medals in learnkit/curriculum/math.json  →  data/i18n/learn-<lang>.json
When the English of a data text changes, its entry gets "stale": true: the old translation is still used until someone
checks it and removes the flag. Languages come from data/i18n/languages.json; English is the source and needs no file.
"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
I18N = os.path.join(ROOT, "data", "i18n")
CALL = re.compile(r'\b(?:tr|T)\(\s*"((?:[^"\\]|\\.)*)"\s*\)')

def gd_unescape(s):
    return re.sub(r'\\(.)', lambda m: {"n": "\n", "t": "\t", '"': '"', "\\": "\\"}.get(m.group(1), m.group(0)), s)

def ui_texts():
    out = {}
    for d in ("scripts", "learnkit"):
        for f in sorted(os.listdir(os.path.join(ROOT, d))):
            if not f.endswith(".gd"): continue
            src = "\n".join(l for l in open(os.path.join(ROOT, d, f), encoding="utf-8").read().split("\n") if not l.lstrip().startswith("#"))
            for m in CALL.finditer(src):
                out.setdefault(gd_unescape(m.group(1)), f"{d}/{f}")
            # constant tables marked "# i18n": their text values (not the keys before a ":") are shown with tr() where used
            for line in open(os.path.join(ROOT, d, f), encoding="utf-8").read().split("\n"):
                if "# i18n" not in line or line.lstrip().startswith("#"): continue
                code = line.split("# i18n")[0]
                for m in re.finditer(r'"((?:[^"\\]|\\.)*)"(\s*:)?', code):
                    if not m.group(2) and has_words(m.group(1)): out.setdefault(gd_unescape(m.group(1)), f"{d}/{f}")
    return out

def has_words(s):
    return isinstance(s, str) and re.search(r"[A-Za-z]{2,}", s) is not None

def data_texts():
    D = json.load(open(os.path.join(ROOT, "data", "farm-progression.json"), encoding="utf-8"))
    out = {}
    def put(path, v):
        if has_words(v): out[path] = v
    for nid, n in D.get("nodes", {}).items():
        for k in ("name", "desc", "page"): put(f"nodes/{nid}/{k}", n.get(k))
        put(f"nodes/{nid}/reward/picture", n.get("reward", {}).get("picture") if isinstance(n.get("reward"), dict) else None)
        for i, st in enumerate(n.get("steps", [])): put(f"nodes/{nid}/steps/{i}/name", st.get("name"))
        for i, q in enumerate(n.get("questions", [])):
            put(f"nodes/{nid}/questions/{i}/q", q.get("q"))
            put(f"nodes/{nid}/questions/{i}/why", q.get("why"))
            for j, a in enumerate(q.get("answers", [])): put(f"nodes/{nid}/questions/{i}/answers/{j}", a)
    for iid, it in D.get("items", {}).items():
        for k in ("name", "desc"): put(f"items/{iid}/{k}", it.get(k))
    for rid, r in D.get("recipes", {}).items():
        for k in ("name", "verb"): put(f"recipes/{rid}/{k}", r.get(k))
    ch = D.get("chapters", [])
    for key, c in (enumerate(ch) if isinstance(ch, list) else ch.items()):
        put(f"chapters/{key}/name", c.get("name"))
    # meta: names, descriptions and messages of perks, gift cards, acorns, jobs, luck finds, postcards, seasons …
    SKIP = {"note", "rules", "rule", "status", "title", "units", "note_on_numbers", "pacing", "targets", "numbers"}
    def walk(o, path):
        if isinstance(o, dict):
            for k, v in o.items():
                if k in SKIP or k.endswith("Note"): continue
                p = f"{path}/{k}"
                if k in ("name", "desc", "text", "abundance") or path.endswith("/news"): put(p, v)
                elif k in ("messages", "names") and isinstance(v, list):
                    for i, s in enumerate(v): put(f"{p}/{i}", s)
                else: walk(v, p)
        elif isinstance(o, list):
            for i, v in enumerate(o): walk(v, f"{path}/{i}")
    walk(D.get("meta", {}), "meta")
    return out

def learn_texts():
    C = json.load(open(os.path.join(ROOT, "learnkit", "curriculum", "math.json"), encoding="utf-8"))
    out = {}
    def put(path, v):
        if has_words(v): out[path] = v
    for i, cat in enumerate(C.get("categories", [])):
        put(f"categories/{i}/name", cat.get("name"))
        for j, sec in enumerate(cat.get("sections", [])):
            put(f"categories/{i}/sections/{j}/name", sec.get("name"))
            for k, lv in enumerate(sec.get("levels", [])): put(f"categories/{i}/sections/{j}/levels/{k}/name", lv.get("name"))
    for key, v in C.get("comments", {}).items():
        if isinstance(v, list):
            for i, s in enumerate(v): put(f"comments/{key}/{i}", s)
        else: put(f"comments/{key}", v)
    for i, r in enumerate(C.get("ranks", [])): put(f"ranks/{i}/title", r.get("title"))
    for k, m in C.get("medals", {}).items(): put(f"medals/{k}/name", m.get("name"))
    return out

def load(path):
    return json.load(open(path, encoding="utf-8")) if os.path.exists(path) else {}

def save(path, d):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(d, f, ensure_ascii=False, indent=1)
        f.write("\n")

def main():
    check = "--check" in sys.argv
    langs = [l for l in load(os.path.join(I18N, "languages.json")) if l != "en"]
    ui, data, learn = ui_texts(), data_texts(), learn_texts()
    print(f"texts: interface {len(ui)}, data {len(data)}, rest sums {len(learn)}")
    missing_any = False
    for lang in langs:
        # interface
        p = os.path.join(I18N, f"ui-{lang}.json")
        old = load(p)
        unused = dict(old.get("_unused", {}))
        new = {}
        for k in ui: new[k] = old.get(k, unused.pop(k, ""))
        for k, v in old.items():
            if k != "_unused" and k not in ui and v: unused[k] = v
        if unused: new["_unused"] = unused
        miss_ui = sum(1 for k in ui if not new[k])
        # data and rest sums
        report = [f"ui {len(ui) - miss_ui}/{len(ui)}"]
        outs = [(p, new)]
        for kind, src in (("data", data), ("learn", learn)):
            pk = os.path.join(I18N, f"{kind}-{lang}.json")
            oldk = load(pk)
            nk = {}
            stale = 0
            for path, en in src.items():
                e = oldk.get(path, {})
                t = e.get(lang, "") if isinstance(e, dict) else ""
                entry = {"en": en, lang: t}
                if t and (e.get("en") != en or e.get("stale")):
                    entry["stale"] = True
                    stale += 1
                nk[path] = entry
            done = sum(1 for e in nk.values() if e[lang])
            report.append(f"{kind} {done}/{len(nk)}" + (f" ({stale} to re-check)" if stale else ""))
            if done < len(nk): missing_any = True
            outs.append((pk, nk))
        if miss_ui: missing_any = True
        print(f"{lang}: " + ", ".join(report))
        if not check:
            for path, d in outs: save(path, d)
    if check and missing_any: sys.exit(1)

if __name__ == "__main__":
    main()
