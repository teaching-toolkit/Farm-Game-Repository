#!/usr/bin/env python3
"""The beginner-and-master price rule (money-market/01, M1), as a report. Changes nothing.

For every made thing (a recipe's output) it compares the market's price (the item's `value`, what selling one pays) with what one costs
to make:

    a beginner:  inputs + energy + fuel + water + station time                    (rank Beginner, rules/48-skills.json)
    a master:    fewer inputs, less energy, less time                             (rank Master: `effects` of the same file)

The rule: the price lies between the two. Below the master's cost, making never pays; above the beginner's, it pays for everybody.

What a unit of energy, fuel, water and waiting is worth in bronze is `pricing` in rules/40-economy.json (perEnergy, perFuel, perWater,
perQuestion; written in old coins, so times `currency.factor`). An input is worth its own `value`; a raw thing without one (sticks,
stones) is worth what the cheapest merchant asks for it, else nothing. An input given as a kind (`tag:grain`) counts as its cheapest member.

    python3 tools/price_rule.py            the summary and every made thing outside the band
    python3 tools/price_rule.py --all      every made thing
    python3 tools/price_rule.py --csv      the same as CSV (for a spreadsheet)
"""
import sys
import farmdata

D = farmdata.load()
META, ITEMS, NODES, RECIPES = D["meta"], D["items"], D["nodes"], D["recipes"]
P = META.get("pricing", {})
F = float(META.get("currency", {}).get("factor", 1)) if META.get("currency", {}).get("rescaled") else 1.0
PER = {k: float(P.get(k, 0)) * F for k in ("perEnergy", "perFuel", "perWater", "perQuestion")}
SK = META.get("skills", {})
EFF = SK.get("effects", {})

def merchant_price(item):
    best = None
    for n in NODES.values():
        if n.get("type") != "merchant": continue
        p = n.get("sells", {}).get(item)
        if isinstance(p, dict): p = p.get("coins")
        if p is not None and (best is None or float(p) < best): best = float(p)
    return best

def tag_members(tag):
    return [k for k, it in ITEMS.items() if tag in it.get("tags", []) or it.get("tag") == tag]

def worth(key):
    if key.startswith("tag:"):
        ms = [worth(m) for m in tag_members(key[4:])]
        return min(ms) if ms else 0.0
    v = float(ITEMS.get(key, {}).get("value", 0) or 0)
    if v > 0: return v
    return merchant_price(key) or 0.0

def kind_of(station):
    fam = SK.get("stations", {}).get(station, "")
    return SK.get("families", {}).get(fam, {}).get("kind", "craft"), fam

def costs(rec):
    """(beginner, master) cost in bronze of one batch."""
    kind, _ = kind_of(rec.get("station", ""))
    inputs = sum(float(q) * worth(k) for k, q in rec.get("inputs", {}).items())
    energy = float(rec.get("energy", 0)) * PER["perEnergy"]
    rest = float(rec.get("fuel", 0)) * PER["perFuel"] + float(rec.get("water", 0)) * PER["perWater"]
    time = float(rec.get("time", 0)) * PER["perQuestion"]
    m_in = 1.0 - float((EFF.get("inputs", {}).get(kind) or [0])[-1])
    m_en = float((EFF.get("energy") or [1])[-1])
    m_ti = float((EFF.get("time") or [1])[-1])
    return inputs + energy + rest + time, inputs * m_in + energy * m_en + rest + time * m_ti

rows = []
for rid, rec in RECIPES.items():
    outs = rec.get("outputs", {})
    sold = sum(float(q) * float(ITEMS.get(k, {}).get("value", 0) or 0) for k, q in outs.items())
    beg, mas = costs(rec)
    if sold <= 0: verdict = "no price"
    elif sold < mas - 0.5: verdict = "never pays"
    elif sold > beg + 0.5: verdict = "pays for all"
    else: verdict = "in the band"
    rows.append({"recipe": rid, "station": rec.get("station", ""), "family": kind_of(rec.get("station", ""))[1], "outputs": " + ".join("%g %s" % (q, k) for k, q in outs.items()),
                 "price": sold, "beginner": beg, "master": mas, "ratio": sold / beg if beg > 0 else 0.0, "verdict": verdict})

if "--csv" in sys.argv:
    print("recipe,station,family,outputs,price,beginner_cost,master_cost,price_over_beginner_cost,verdict")
    for r in rows: print("%s,%s,%s,%s,%d,%d,%d,%.2f,%s" % (r["recipe"], r["station"], r["family"], r["outputs"], r["price"], round(r["beginner"]), round(r["master"]), r["ratio"], r["verdict"]))
    sys.exit(0)

count = {}
for r in rows: count[r["verdict"]] = count.get(r["verdict"], 0) + 1
print("worth of a unit in bronze: energy %(perEnergy)g, fuel %(perFuel)g, water %(perWater)g, a question of waiting %(perQuestion)g" % PER)
print("%d recipes: %s" % (len(rows), ", ".join("%s %d" % (k, v) for k, v in sorted(count.items()))))
priced = sorted(r["ratio"] for r in rows if r["verdict"] != "no price")
if priced: print("price / beginner's cost: lowest %.2f, middle %.2f, highest %.2f (the band is about %.2f to 1.00)" % (priced[0], priced[len(priced) // 2], priced[-1], sum(r["master"] / r["beginner"] for r in rows if r["beginner"] > 0) / max(1, sum(1 for r in rows if r["beginner"] > 0))))
print()
print("%-24s %-16s %7s %9s %8s %6s  %s" % ("recipe", "station", "price", "beginner", "master", "ratio", "verdict"))
for r in sorted(rows, key=lambda r: r["ratio"]):
    if "--all" not in sys.argv and r["verdict"] == "in the band": continue
    print("%-24s %-16s %7d %9d %8d %6.2f  %s" % (r["recipe"][:24], r["station"][:16], r["price"], round(r["beginner"]), round(r["master"]), r["ratio"], r["verdict"]))
