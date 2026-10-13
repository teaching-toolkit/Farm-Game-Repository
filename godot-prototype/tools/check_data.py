#!/usr/bin/env python3
"""Static checks of the farm's data (data/farm/, see tools/farmdata.py): every id that something names exists, costs and effects use
known keys, conditions parse, questions are well-formed, every node lands in a known place. Exit code 1 if there is an error.

    python3 tools/check_data.py            (from the godot-prototype folder)

Errors are things that would break or silently do nothing in the game; warnings are things worth a look.
"""
import json, os, re, sys, glob
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import farmdata

ROOT = farmdata.ROOT
D = farmdata.load()
N, ITEMS, RECIPES = D["nodes"], D["items"], D["recipes"]
META = D["meta"]
PLACES = json.load(open(os.path.join(ROOT, "data", "farm", "places.json"), encoding="utf-8"))
errors, warnings = [], []
def err(where, msg): errors.append(f"{where}: {msg}")
def warn(where, msg): warnings.append(f"{where}: {msg}")

NODE_TYPES = {"building", "station", "tool", "gear", "helper", "land", "patch", "delivery", "pet", "sidequest", "knowledge", "polish",
              "book", "crop", "merchant", "animal"}
ITEM_CATEGORIES = {"dish", "crop", "ingredient", "material", "textile", "pet-item", "byproduct", "keeper", "animal", "seed", "fertilizer",
                   "feed", "find", "fuel", "container", "craft"}
SPECIAL_COST = {"coins", "energy", "water"}
EFFECT_BLOCKS = {"set", "add", "mult", "produces"}
TAGS = {t for i in ITEMS.values() for t in i.get("tags", [])}
chapters = len(D["chapters"])

def cost_keys(where, d, what="cost", extra=()):
    """Keys of a cost, price, gives or inputs dictionary: items, coins, energy, water, or tag:<tag>."""
    if not isinstance(d, dict):
        return err(where, f"{what} is not a dictionary")
    for k, v in d.items():
        if not isinstance(v, (int, float)) or isinstance(v, bool): err(where, f"{what}.{k} is not a number ({v!r})")
        elif v < 0: err(where, f"{what}.{k} is negative")
        if k in SPECIAL_COST or k in extra: continue
        if k.startswith("tag:"):
            if k[4:] not in TAGS: err(where, f"{what} names the tag {k[4:]}, which no item has")
        elif k not in ITEMS: err(where, f"{what} names {k}, which is not an item")

def node_id(where, nid, what):
    if nid not in N: err(where, f"{what} names {nid}, which is not a node")

# ---------------------------------------------------------------- items
for iid, it in ITEMS.items():
    w = f"item {iid}"
    for k in ("name", "emoji", "category", "value"):
        if k not in it: err(w, f"missing {k}")
    if it.get("category") not in ITEM_CATEGORIES: err(w, f"unknown category {it.get('category')!r}")
    if not isinstance(it.get("value", 0), (int, float)): err(w, "value is not a number")
    if "chapter" in it and not (1 <= int(it["chapter"]) <= chapters): err(w, f"chapter {it['chapter']} does not exist")

# ---------------------------------------------------------------- chapters and start
for c in D["chapters"]:
    w = f"chapter {c.get('id')}"
    if c.get("pet") not in N or N[c["pet"]]["type"] != "pet": err(w, f"its pet {c.get('pet')} is not a pet node")
    elif int(N[c["pet"]]["chapter"]) != int(c["id"]): warn(w, f"its pet {c['pet']} says chapter {N[c['pet']]['chapter']}")
ids = [c["id"] for c in D["chapters"]]
if ids != list(range(1, chapters + 1)): err("chapters", f"ids are {ids}, not 1..{chapters}")
st = D["start"]
for nid in st.get("unlocked", []): node_id("start", nid, "unlocked")
for k in st.get("inventory", {}):
    if k not in ITEMS: err("start", f"inventory names {k}, which is not an item")
for k in st.get("seeds", {}):
    if k not in N or N[k]["type"] != "crop": err("start", f"seeds names {k}, which is not a crop")

# ---------------------------------------------------------------- nodes
def effects_ok(where, e):
    if not isinstance(e, dict): return err(where, "effects is not a dictionary")
    for blk, d in e.items():
        if blk not in EFFECT_BLOCKS: err(where, f"effects has an unknown block {blk}"); continue
        if not isinstance(d, dict): err(where, f"effects.{blk} is not a dictionary"); continue
        for k, v in d.items():
            if blk == "set": continue
            if not isinstance(v, (int, float)) or isinstance(v, bool): err(where, f"effects.{blk}.{k} is not a number ({v!r})")
            if blk == "produces" and k not in ITEMS: err(where, f"effects.produces names {k}, which is not an item")
            if blk == "mult" and not (0 <= v <= 3): warn(where, f"effects.mult.{k} = {v} is an odd factor")

perk_ids = {p["id"] for p in META.get("perks", {}).get("list", [])}
for nid, n in N.items():
    w = f"node {nid}"
    if n.get("type") not in NODE_TYPES: err(w, f"unknown type {n.get('type')!r}")
    for k in ("name", "emoji", "chapter", "slot"):
        if k not in n: err(w, f"missing {k}")
    if "chapter" in n and not (1 <= int(n["chapter"]) <= chapters): err(w, f"chapter {n['chapter']} does not exist")
    for r in n.get("requires", []): node_id(w, r, "requires")
    if nid in n.get("requires", []): err(w, "requires itself")
    for k in ("replaces", "attach"):
        if k in n: node_id(w, n[k], k)
    for u in n.get("unlocks", []):
        if u not in N and u not in RECIPES: err(w, f"unlocks names {u}, which is neither a node nor a recipe")
    if "target" in n: node_id(w, n["target"], "target")
    if "cost" in n: cost_keys(w, n["cost"], extra=(("read",) if n.get("type") == "knowledge" else ()))   # a card costs reading time
    if "price" in n: cost_keys(w, n["price"], "price")
    if "gives" in n: cost_keys(w, n["gives"], "gives")
    for i, s in enumerate(n.get("steps", [])):
        if "cost" in s: cost_keys(w, s["cost"], f"steps[{i}].cost")
        if "gives" in s: cost_keys(w, s["gives"], f"steps[{i}].gives")
    if "effects" in n: effects_ok(w, n["effects"])
    for k in ("yields", "sells", "produces", "needs", "feed", "barterGives"):
        if k in n:
            for key in n[k]:
                if key.startswith("tag:"):
                    if key[4:] not in TAGS: err(w, f"{k} names the tag {key[4:]}, which no item has")
                elif key not in ITEMS: err(w, f"{k} names {key}, which is not an item")
    for m, price in n.get("barter", {}).items():
        if m not in ITEMS: err(w, f"barter sells {m}, which is not an item")
        cost_keys(w, price, f"barter.{m}")
    for k in ("discover",):
        for i in n.get(k, []):
            if i not in ITEMS: err(w, f"{k} names {i}, which is not an item")
    if "seedItem" in n and n["seedItem"] not in ITEMS: err(w, f"seedItem {n['seedItem']} is not an item")
    if "perk" in n and n["perk"] not in perk_ids: err(w, f"perk {n['perk']} is not in meta.perks")
    h = n.get("reward", {}).get("helper") if isinstance(n.get("reward"), dict) else None
    if h: node_id(w, h, "reward.helper")
    if "openAfter" in n and "steps" in n and not (0 <= int(n["openAfter"]) <= len(n["steps"])): err(w, "openAfter is more than the number of steps")

# ---------------------------------------------------------------- cards and their questions
qids = {}
for nid, n in N.items():
    if n["type"] != "knowledge": continue
    w = f"card {nid}"
    if not n.get("page"): err(w, "has no page")
    if not n.get("questions"): err(w, "has no questions")
    for i, q in enumerate(n.get("questions", [])):
        qw = f"{w} question {i}"
        if not q.get("q"): err(qw, "has no text")
        a = q.get("answers", [])
        if len(a) < 2: err(qw, "has fewer than two answers")
        if not (0 <= int(q.get("correct", 0)) < len(a)): err(qw, "'correct' is not one of the answers")
        if "id" not in q: warn(qw, "has no id yet (run tools/quiz_ids.py)")
        elif q["id"] in qids: err(qw, f"id {q['id']} is also used by {qids[q['id']]}")
        else: qids[q["id"]] = qw
for p in sorted(glob.glob(os.path.join(ROOT, "data", "quiz_packs", "*.json"))):
    pack = json.load(open(p, encoding="utf-8"))
    for q in pack.get("questions", []):
        w = f"quiz pack {os.path.basename(p)} {q.get('id', q.get('q', '?'))}"
        if "id" not in q: warn(w, "has no id yet (run tools/quiz_ids.py)"); continue
        if q["id"] in qids: err(w, f"id {q['id']} is also used by {qids[q['id']]}")
        qids[q["id"]] = w
        if not (0 <= int(q.get("correct", 0)) < len(q.get("answers", []))): err(w, "'correct' is not one of the answers")

# ---------------------------------------------------------------- recipes
for rid, r in RECIPES.items():
    w = f"recipe {rid}"
    st_id = r.get("station")
    if st_id not in N: err(w, f"station {st_id} is not a node")
    for k in ("inputs", "outputs"):
        if k not in r: err(w, f"missing {k}")
        else: cost_keys(w, r[k], k)
    for k in r.get("keeps", []):
        if k not in ITEMS: err(w, f"keeps names {k}, which is not an item")
    for q in r.get("requires", []): node_id(w, q, "requires")
    if not isinstance(r.get("energy", 0), (int, float)): err(w, "energy is not a number")
    for k in ("verb",):
        if k not in r: err(w, f"missing {k}")

# ---------------------------------------------------------------- conditions (perks, golden acorns)
counters = set()
src = open(os.path.join(ROOT, "game", "farm", "game.gd"), encoding="utf-8").read()
m = re.search(r"func counter\(name: String\) -> float:(.*?)\n\treturn NAN", src, re.S)
for l in (m.group(1) if m else "").split("\n"):
    mm = re.match(r'\t\t"(\w+)":', l)
    if mm: counters.add(mm.group(1))
if not counters: warn("conditions", "could not read the counters from game/farm/game.gd")
reveal_ids = set(META.get("reveal", {}).get("elements", {}))
def condition_ok(w, expr):
    if expr.startswith("unlocked:") or expr.startswith("done:"):
        node_id(w, expr.split(":", 1)[1], "condition")
    elif expr.startswith("seen:"):
        if expr[5:] not in reveal_ids: err(w, f"condition {expr!r}: {expr[5:]} is not an element of rules/60-reveal.json")
    else:
        p = expr.split(">=")
        if len(p) != 2 or p[0] not in counters: err(w, f"condition {expr!r} is not 'unlocked:<node>' or '<counter>>=<n>' with a counter of the game ({', '.join(sorted(counters))})")
        else:
            try: float(p[1])
            except ValueError: err(w, f"condition {expr!r}: {p[1]!r} is not a number")
for p in META.get("perks", {}).get("list", []):
    if p.get("when"): condition_ok(f"perk {p['id']}", str(p["when"]))
for a in META.get("acorns", {}).get("list", []):
    if a["when"] != "luck": condition_ok(f"acorn {a['id']}", str(a["when"]))     # "luck": found by a luck event (meta.luck.events)
for rid, r in META.get("reveal", {}).get("elements", {}).items():
    if not isinstance(r.get("when", []), list): err(f"reveal {rid}", "'when' must be a list of conditions (all must hold)")
    for expr in r.get("when", []): condition_ok(f"reveal {rid}", str(expr))

# ---------------------------------------------------------------- weights (rules/45-weight.json)
W = META.get("weights", {})
classes = W.get("classes", {})
if not classes: err("weights", "no classes in rules/45-weight.json")
for c, v in classes.items():
    if not isinstance(v, (int, float)) or v <= 0: err(f"weights class {c}", "the load of a class must be a number above 0")
if W.get("seed") not in classes: err("weights", f"seed class {W.get('seed')!r} is not one of the classes")
for iid, c in W.get("items", {}).items():
    if iid not in ITEMS: err("weights", f"item {iid} is not an item")
    if c not in classes: err("weights", f"item {iid}: class {c!r} is not one of {sorted(classes)}")
for cat, c in W.get("byCategory", {}).items():
    if c not in classes: err("weights", f"category {cat}: class {c!r} is not one of {sorted(classes)}")
for iid, it in ITEMS.items():
    if iid not in W.get("items", {}) and it.get("category") not in W.get("byCategory", {}):
        err("weights", f"item {iid} (category {it.get('category')}) has no weight class: give it an entry in items or its category one in byCategory")

# ---------------------------------------------------------------- the bag and the trip (rules/49-trip.json)
TR = META.get("trip", {})
if not TR: err("trip", "no 'trip' in rules/49-trip.json")
if float(TR.get("base", 0)) <= 0: err("trip", "base capacity must be above 0")
for nid, cap in TR.get("devices", {}).items():
    if nid not in N: err("trip", f"device {nid} is not a node")
    elif float(cap) <= float(TR.get("base", 0)): err("trip", f"device {nid}: capacity {cap} is not above the base {TR.get('base')}")
_filter_cats = set()
for f in TR.get("storeFilters", []):
    for c in f.get("cats", []):
        if c in _filter_cats: err("trip", f"store filter {f.get('id')}: category {c} is in two filters")
        _filter_cats.add(c)
for c in {it.get("category", "") for it in ITEMS.values()}:
    if c and c not in _filter_cats and c not in ("seed",): warn("trip", f"items of category {c!r} are in no store filter (they show under All only)")

# ---------------------------------------------------------------- the travelling merchant (rules/50-gate.json)
GT = META.get("gate", {})
if not GT: err("gate", "no 'gate' in rules/50-gate.json")
if not 0 < float(GT.get("chance", 0)) <= 1: err("gate", "chance must be between 0 and 1")
if not 0 < float(GT.get("cut", 0)) <= 1: err("gate", "cut (the share of the village price he pays) must be between 0 and 1")
if int(GT.get("stay", 0)) < 1: err("gate", "stay must be at least 1 question")
for k, b in GT.get("barter", {}).items():
    if k not in ITEMS: err("gate", f"barter: {k} is not an item")
    for x in b.get("cost", {}):
        if x != "coins" and x not in ITEMS: err("gate", f"barter {k}: cost {x} is not an item")
_cats = {it.get("category", "") for it in ITEMS.values()}
for c in GT.get("cats", []):
    if c not in _cats: err("gate", f"category {c!r} has no items")

# ---------------------------------------------------------------- trust (rules/51-trust.json) and season prices (rules/52-season-prices.json)
TRU = META.get("trust", {})
if not TRU: err("trust", "no 'trust' in rules/51-trust.json")
for pid, person in TRU.get("people", {}).items():
    if pid not in N or N[pid].get("type") != "merchant": err("trust", f"{pid} is not a merchant")
    for d in person.get("deeds", []):
        if d not in N or N[d].get("type") != "delivery": err("trust", f"{pid}: deed {d} is not a delivery")
    if int(person.get("max", 0)) < 1: err("trust", f"{pid}: max must be at least 1")
for mid, n in N.items():
    if n.get("type") == "merchant" and mid not in TRU.get("people", {}) and mid != "book_cart": warn("trust", f"merchant {mid} has no trust entry (its prices follow the village's reputation only)")
_disc = TRU.get("reputation", {}).get("discount", [])
if len(_disc) != int(TRU.get("reputation", {}).get("max", 0)) + 1: err("trust", "reputation.discount needs one entry per level, 0 to max")
if not 0.5 <= float(TRU.get("floor", 0)) <= 1: err("trust", "floor must be between 0.5 and 1")
SP_ = META.get("seasonPrices", {})
for s_ in ("spring", "summer", "autumn", "winter"):
    if s_ not in SP_: err("seasonPrices", f"no entry for {s_}")
    for it, f in SP_.get(s_, {}).get("items", {}).items():
        if it not in ITEMS: err("seasonPrices", f"{s_}: {it} is not an item")
    for c, f in list(SP_.get(s_, {}).get("cats", {}).items()) + list(SP_.get(s_, {}).get("items", {}).items()):
        if not 0.5 <= float(f) <= 2.0: err("seasonPrices", f"{s_}: factor {f} for {c} is outside 0.5 … 2")

# ---------------------------------------------------------------- quality (rules/47-quality.json)
Qd = META.get("quality", {})
cats_known = {it.get("category") for it in ITEMS.values()}
for c in Qd.get("categories", []):
    if c not in cats_known: err("quality", f"category {c} has no item")
if len(Qd.get("levels", [])) < 2: err("quality", "needs at least two grades")
for lv in Qd.get("levels", []):
    if not lv.get("name") or not isinstance(lv.get("price"), (int, float)) or lv["price"] <= 0: err("quality", f"grade {lv}: a name and a price above 0")
if not 0 <= Qd.get("default", 1) < len(Qd.get("levels", [])): err("quality", "default grade is not one of the grades")
for nid in Qd.get("crop", {}).get("bonusNodes", {}): node_id("quality crop bonus", nid, "node")
for sid in Qd.get("stationBonus", {}): node_id("quality station bonus", sid, "station")
for rid, r in RECIPES.items():
    if any(ITEMS.get(k, {}).get("category") in Qd.get("categories", []) for k in r["outputs"]) and r["station"] not in Qd.get("stationBonus", {}):
        warn("quality", f"recipe {rid} makes something with a grade at {r['station']}, which has no stationBonus (it counts 0)")

# ---------------------------------------------------------------- skills (rules/48-skills.json)
Sk = META.get("skills", {})
fams = Sk.get("families", {})
rk = Sk.get("ranks", [])
if len(fams) == 0 or len(rk) < 2: err("skills", "needs families and at least two ranks")
for a, b in zip(rk, rk[1:]):
    if b.get("batches", 0) <= a.get("batches", 0): err("skills", f"rank {b.get('name')} must need more batches than {a.get('name')}")
for kind, arr in Sk.get("effects", {}).get("inputs", {}).items():
    if len(arr) != len(rk): err("skills", f"effects.inputs.{kind} needs {len(rk)} numbers, one per rank")
for key in ("grade", "energy", "time"):
    if len(Sk.get("effects", {}).get(key, [])) != len(rk): err("skills", f"effects.{key} needs {len(rk)} numbers, one per rank")
for f, info in fams.items():
    if info.get("kind") not in Sk.get("effects", {}).get("inputs", {}): err(f"skills family {f}", f"kind {info.get('kind')!r} has no input effects")
    for r in rk:
        g = r.get("gate")
        if g:
            nid = Sk.get("gates", {}).get(f, {}).get(g)
            if not nid: err(f"skills family {f}", f"rank {r['name']} needs a {g} gate")
            else: node_id(f"skills gate {f}/{g}", nid, g)
for st, f in Sk.get("stations", {}).items():
    node_id("skills station", st, "station")
    if f not in fams: err("skills", f"station {st}: family {f} does not exist")
for job, f in Sk.get("jobs", {}).items():
    if f not in fams: err("skills", f"job {job}: family {f} does not exist")
def _root(s):
    n = 0
    while N.get(s, {}).get("replaces") and n < 10: s = N[s]["replaces"]; n += 1
    return s
for rid, r in RECIPES.items():
    root = _root(r["station"])
    if root not in Sk.get("stations", {}) and N.get(root, {}).get("cat") != "gather":
        warn("skills", f"recipe {rid} is made at {root}, which trains no skill family")

# ---------------------------------------------------------------- story (data/farm/story/*.json)
STORY = D.get("story", {}) if "D" in globals() else {}
KINDS = ["frame", "beat", "discovery", "letter", "moment", "visit", "scene", "bark", "trace"]
SEASONS = {"spring", "summer", "autumn", "winter"}
def story_condition(w, expr):
    if expr.startswith("seen:"):
        if expr[5:] not in STORY and expr[5:] not in reveal_ids: err(w, f"condition {expr!r}: {expr[5:]} is neither a story piece nor an interface element")
        return
    if expr.startswith("unlocked:") or expr.startswith("done:"): node_id(w, expr.split(":", 1)[1], "condition"); return
    if ">=" in expr: condition_ok(w, expr); return
    name, _, arg = expr.partition(":")
    if name == "start": return
    if name == "has":
        item, _, n = arg.partition(":")
        if item not in ITEMS: err(w, f"condition {expr!r}: {item} is not an item")
        try: float(n)
        except ValueError: err(w, f"condition {expr!r}: {n!r} is not a number")
    elif name == "season":
        if arg not in SEASONS: err(w, f"condition {expr!r}: {arg} is not a season")
    elif name == "chapter":
        if not arg.isdigit() or not 1 <= int(arg) <= 6: err(w, f"condition {expr!r}: chapter 1 to 6")
    elif name == "tap":
        if arg not in spots_for_story and not arg.startswith("patch:"): err(w, f"condition {expr!r}: {arg} is not a place (places.json spots) or patch:<kind>")
    elif name == "page":
        if arg not in N or N[arg].get("type") != "knowledge": err(w, f"condition {expr!r}: {arg} is not a card")
    elif name == "after":
        pid, _, n = arg.partition(":")
        if pid not in STORY: err(w, f"condition {expr!r}: {pid} is not a story piece")
        if not n.isdigit(): err(w, f"condition {expr!r}: after:<piece>:<number of questions>")
    elif name == "chance":
        try:
            if not 0 <= float(arg) <= 1: err(w, f"condition {expr!r}: a chance between 0 and 1")
        except ValueError: err(w, f"condition {expr!r}: {arg!r} is not a number")
    else: err(w, f"condition {expr!r}: unknown term {name!r}")
spots_for_story = set(PLACES["spots"]) | {"board"}
for sid, pc in STORY.items():
    w = f"story {sid}"
    if pc.get("kind") not in KINDS: err(w, f"kind {pc.get('kind')!r} is not one of {KINDS}")
    if not isinstance(pc.get("chapter"), int) or not 1 <= pc["chapter"] <= 6: err(w, "chapter must be 1 to 6")
    if pc.get("kind") != "trace" and not (pc.get("text") or pc.get("pages")): err(w, "needs a text or pages")
    for pg in pc.get("pages", []):
        if not pg.get("text"): err(w, "a page without text")
    if not isinstance(pc.get("when", []), list): err(w, "'when' must be a list of conditions (all must hold)")
    for expr in pc.get("when", []): story_condition(w, str(expr))
    txt = " ".join([str(pc.get("text", ""))] + [str(pg.get("text", "")) for pg in pc.get("pages", [])])
    if "ß" in txt: err(w, "ß: German text uses ss")
    if len(txt.split()) > 70 and pc.get("kind") not in ("frame", "scene"): warn(w, f"{len(txt.split())} words: boxes are 2-4 sentences, about 35-45 words")

# ---------------------------------------------------------------- money (rules/40-economy.json currency; prices in bronze)
cur = META.get("economy", META).get("currency", {}) if False else META.get("currency", {})
if not cur.get("rescaled"): warn("money", "meta.currency.rescaled is missing: the prices are not in bronze yet (tools/rescale_prices.py)")
for nid, n in N.items():
    for it, price in n.get("sells", {}).items():
        v = ITEMS.get(it, {}).get("value", 0)
        if price < 1.3 * v: err(f"merchant {nid}", f"sells {it} for {price}, below 1.3 x its worth ({v}): buying to resell would pay")
for it, row in ITEMS.items():
    if row.get("value", 0) < 0 or row.get("value", 0) != int(row.get("value", 0)): err(f"item {it}", "the value must be a whole number of bronze")

# ---------------------------------------------------------------- places (data/farm/places.json)
spots = set(PLACES["spots"])
rules = PLACES["nodeSpots"]
def spot_of(nid, depth=0):
    n = N[nid]
    if nid.startswith(rules["ruinsPrefix"]):
        p = nid[len(rules["ruinsPrefix"]):]
        return rules["ruinsAt"].get(p, p)
    if "attach" in n and depth < 3 and n["attach"] in N: return spot_of(n["attach"], depth + 1)
    s = str(n.get("slot", ""))
    for pre, spot in rules["slotPrefixes"].items():
        if s.startswith(pre): return spot
    e = rules["slots"].get(s)
    if e is None: return None
    if isinstance(e, str): return e
    for spot, ids in e.get("ids", {}).items():
        if nid in ids: return spot
    for pre, spot in e.get("prefixes", {}).items():
        if nid.startswith(pre): return spot
    return e.get("default", rules["default"])
for nid in N:
    s = spot_of(nid)
    if s is None: warn(f"node {nid}", f"slot {N[nid].get('slot')!r} has no rule in places.json nodeSpots (it falls back to {rules['default']!r})")
    elif s not in spots: err(f"node {nid}", f"lands at place {s}, which is not in places.json spots")
for parent, info in PLACES["interiors"].items():
    node_id(f"interior {parent}", info["built"], "built")
    for mbr in info["members"]:
        if mbr not in spots: err(f"interior {parent}", f"member {mbr} is not in spots")
for sid, chain in PLACES["artChains"].items():
    if sid not in spots: err("artChains", f"{sid} is not a place")
    for nid in chain: node_id(f"artChains {sid}", nid, "chain")
for sid, chain in PLACES["cornerArt"].items():
    for nid in chain: node_id(f"cornerArt {sid}", nid, "corner picture")
for b in PLACES["bench"]:
    if not b.get("item") and b["id"] not in N: err("bench", f"{b['id']} is not a node")
    if b.get("item") and b["id"] not in ITEMS: err("bench", f"{b['id']} is not an item")
layout = json.load(open(os.path.join(ROOT, "data", "map_layout.json"), encoding="utf-8"))
for sid in layout.get("places", {}):
    if sid not in spots: err("map_layout", f"place {sid} is not in places.json spots")

print(f"data: {len(ITEMS)} items, {len(N)} nodes, {len(RECIPES)} recipes, {len(qids)} question ids, {chapters} chapters")
for w in warnings: print("  warning:", w)
for e in errors: print("  ERROR:", e)
print(f"{len(errors)} errors, {len(warnings)} warnings")
sys.exit(1 if errors else 0)
