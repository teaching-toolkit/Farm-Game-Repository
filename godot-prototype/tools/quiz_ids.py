"""Question ids and translation files for every quiz question.

Run from the game folder after adding or changing questions:   python3 tools/quiz_ids.py

- Every question gets a unique id that never changes: <pack code>-<number>, e.g. CON-003. Packs in data/quiz_packs/ have
  their own "code" (3 capital letters); the knowledge cards' questions in data/farm/nodes/ use KNW.
  A new question gets the next free number. Never reuse or renumber an id: the learning record (how well the child
  knows each question) and the translations are stored under it.
- data/i18n/quiz-en.json is written fresh: all English texts by id (for translators to read). A pack's pool of extra
  answers is <code>-POOL.
- data/i18n/quiz-<lang>.json for every other language (de is created if missing) keeps what is translated and gets an
  empty entry for each new question. Empty texts fall back to English in the game. "answers" are in the same order as
  in the pack (the right one first, as written there).
"""
import json, os, re, sys, glob

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PACKS = os.path.join(ROOT, "data", "quiz_packs")
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import farm_data
I18N = os.path.join(ROOT, "data", "i18n")
FIELDS = ("q", "right", "wrong", "why")

def text(a):
    return a.get("text", "") if isinstance(a, dict) else str(a)

def main():
    groups = []          # (code, list of questions, save function)
    pools = {}           # code: the pack's pool of extra wrong answers (translated as <code>-POOL)
    for p in sorted(glob.glob(os.path.join(PACKS, "*.json"))):
        pack = json.load(open(p, encoding="utf-8"))
        code = pack.get("code") or re.sub(r"[^A-Z]", "", pack.get("id", "X").upper())[:3]
        pack["code"] = code
        if pack.get("pool"): pools[code] = pack["pool"]
        groups.append((code, pack["questions"], lambda p=p, pack=pack: open(p, "w", encoding="utf-8").write(json.dumps(pack, ensure_ascii=False, indent=1) + "\n")))
    D = farm_data.load()
    cardq = [q for n in D["nodes"].values() if n.get("type") == "knowledge" for q in n.get("questions", [])]
    groups.append(("KNW", cardq, lambda: farm_data.save(D)))

    seen, new = {}, 0
    for code, qs, _ in groups:
        for q in qs:
            if "id" in q:
                if q["id"] in seen: sys.exit(f"Double id {q['id']}: \"{q['q']}\" and \"{seen[q['id']]['q']}\"")
                seen[q["id"]] = q
    for code, qs, save in groups:
        top = max([int(i.split("-")[1]) for i in seen if i.startswith(code + "-")] + [0])
        changed = False
        for q in qs:
            if "id" not in q:
                top += 1
                q["id"] = f"{code}-{top:03d}"
                seen[q["id"]] = q
                new += 1; changed = True
            # put the id first, so it is easy to find in the file
            if list(q.keys())[0] != "id":
                items = list(q.items()); q.clear(); q["id"] = dict(items)["id"]
                q.update({k: v for k, v in items if k != "id"}); changed = True
        if changed: save()

    os.makedirs(I18N, exist_ok=True)
    en = {}
    for i, q in seen.items():
        e = {f: q[f] for f in FIELDS if q.get(f)}
        e["answers"] = [text(a) for a in q.get("answers", [])]
        en[i] = e
    for code, pool in pools.items():
        en[f"{code}-POOL"] = {"answers": [text(a) for a in pool]}
    open(os.path.join(I18N, "quiz-en.json"), "w", encoding="utf-8").write(json.dumps(en, ensure_ascii=False, indent=1) + "\n")
    langs = sorted(set(os.path.basename(f)[5:-5] for f in glob.glob(os.path.join(I18N, "quiz-*.json"))) - {"en"}) or ["de"]
    for lang in langs:
        path = os.path.join(I18N, f"quiz-{lang}.json")
        old = json.load(open(path, encoding="utf-8")) if os.path.exists(path) else {}
        out, todo = {}, 0
        for i, e in en.items():
            t = old.get(i, {})
            row = {f: t.get(f, "") for f in e if f != "answers"}
            ta = list(t.get("answers", []))
            row["answers"] = [(ta[j] if j < len(ta) else "") for j in range(len(e["answers"]))]
            if ("q" in e and row["q"] == "") or "" in row["answers"]: todo += 1
            out[i] = row
        for i in old:
            if i not in out: out[i] = old[i]          # questions taken out: their translation is kept
        open(path, "w", encoding="utf-8").write(json.dumps(out, ensure_ascii=False, indent=1) + "\n")
        print(f"quiz-{lang}.json: {len(en) - todo} of {len(en)} questions translated")
    print(f"{len(seen)} questions, {new} new ids:", ", ".join(f"{c} {len(qs)}" for c, qs, _ in groups))

if __name__ == "__main__":
    main()
