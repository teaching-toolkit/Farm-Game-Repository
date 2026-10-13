#!/usr/bin/env python3
"""One-off: turns the game's coins into bronze (TODO M1/M2/D3). Every number in the data that is an amount of coins is multiplied by
FACTOR (15: one old coin = 15 bronze, 100 bronze = 1 gold, like Rappen and Franken), then a few familiar goods are set to a realistic
Swiss price (ANCHORS, in bronze). Run once from the godot-prototype folder:

    python3 tools/rescale_prices.py            (changes the files; refuses to run twice: data/farm/rules/40-economy.json "currency")
    python3 tools/rescale_prices.py --dry      (only prints the table)

Writes planning/price-table.md (every item: before, after, and the anchor if there is one).
"""
import json, os, sys, glob
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import farmdata

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
REPO = os.path.normpath(os.path.join(ROOT, ".."))
FACTOR = 15

# Real Swiss prices in bronze (Rappen), 2025/26, for things the child knows; "of" says what one unit in the game stands for.
ANCHORS = {
    "egg": (65, "a fresh egg, CHF 0.65"),
    "milk": (90, "about 5 dl, CHF 0.90"),
    "carrot": (30, "one carrot, about CHF 0.30"),
    "onion": (40, "one onion"),
    "potato": (35, "one potato"),
    "tomato": (70, "a tomato"),
    "apple": (50, "an apple"),
    "flour": (100, "a bag of flour, CHF 1"),
    "bread": (200, "a small loaf of bread, CHF 2"),
    "butter": (330, "250 g of butter, CHF 3.30"),
    "honey": (150, "a spoonful-sized portion; a whole jar is CHF 6"),
    "yogurt": (120, "a pot of yogurt, CHF 1.20"),
    "fresh_cheese": (300, "a tub of fresh cheese, CHF 3"),
    "aged_cheese": (800, "a piece of aged cheese, CHF 8"),
    "jam": (400, "a jar of jam, CHF 4"),
    "tomato_sauce": (350, "a jar of tomato sauce, CHF 3.50"),
    "cider": (300, "a bottle of cider, CHF 3"),
    "vinegar": (250, "a bottle of vinegar, CHF 2.50"),
    "pizza": (1500, "a pizza, CHF 15"),
    "cheese_board": (2500, "a cheese board, CHF 25"),
    "golden_honey_cake": (2000, "a fine cake, CHF 20"),
    "apple_carrot_cake": (1500, "a cake, CHF 15"),
    "candle": (150, "a candle, CHF 1.50"),
}
# merchants sell these: their value stays at FACTOR x the old one, so that buying to resell never pays
KEEP_FACTOR = set()

def load(p): return json.load(open(p, encoding="utf-8"))
def save(p, d, rows=False):
    """The data files keep their layout: items and nodes one entry per line, the rules indented (tools/farmdata.py)."""
    open(p, "w", encoding="utf-8").write(farmdata.entries(d) if rows else farmdata.pretty(d))

def scale_coins(o):
    """Multiplies every value under a key named "coins" in a node (cost, steps[].cost, price, barter)."""
    n = 0
    if isinstance(o, dict):
        for k, v in list(o.items()):
            if k == "coins" and isinstance(v, (int, float)):
                o[k] = round(v * FACTOR); n += 1
            else: n += scale_coins(v)
    elif isinstance(o, list):
        for v in o: n += scale_coins(v)
    return n

def main():
    dry = "--dry" in sys.argv
    econ_path = os.path.join(ROOT, "data", "farm", "rules", "40-economy.json")
    econ = load(econ_path)
    if econ.get("currency", {}).get("rescaled"):
        sys.exit("already rescaled (meta.currency.rescaled in rules/40-economy.json): not run again")
    items_path = os.path.join(ROOT, "data", "farm", "items.json")
    items = load(items_path)
    sold = set()
    node_files = sorted(glob.glob(os.path.join(ROOT, "data", "farm", "nodes", "*.json")))
    nodes = {f: load(f) for f in node_files}
    for d in nodes.values():
        for n in d.values():
            if n.get("type") == "merchant": sold.update(n.get("sells", {}).keys())
    rows = []
    for k, it in items.items():
        old = it.get("value", 0)
        if old <= 0 and "value" not in it: continue
        new = round(old * FACTOR)
        note = ""
        if k in ANCHORS and k not in sold:
            new = ANCHORS[k][0]; note = ANCHORS[k][1]
        elif k in ANCHORS and k in sold:
            note = "(a merchant sells it: kept at x%d)" % FACTOR
        it["value"] = new
        rows.append((it.get("category", ""), k, it.get("name", k), old, new, note))
    n_coins = 0; n_seed = 0; n_sells = 0
    for f, d in nodes.items():
        for n in d.values():
            n_coins += scale_coins(n)
            if "seedCost" in n: n["seedCost"] = round(n["seedCost"] * FACTOR); n_seed += 1
            if "sells" in n:
                for k in n["sells"]: n["sells"][k] = round(n["sells"][k] * FACTOR); n_sells += 1
    # rules
    rw_path = os.path.join(ROOT, "data", "farm", "rules", "50-rewards.json")
    rw = load(rw_path)
    rw["jobs"]["rewardCoinsPerChapter"] = round(rw["jobs"]["rewardCoinsPerChapter"] * FACTOR)
    for e in rw["luck"]["events"]:
        if "coins" in e.get("gives", {}): e["gives"]["coins"] = round(e["gives"]["coins"] * FACTOR)
    flex = econ["flex"]
    flex["basePace"] = [[g, round(p * FACTOR)] for g, p in flex["basePace"]]
    flex["minWorth"] = round(flex["minWorth"] * FACTOR, 2)
    start_path = os.path.join(ROOT, "data", "farm", "start.json")
    start = load(start_path)
    start["coins"] = round(start.get("coins", 0) * FACTOR)
    econ["currency"] = {"rescaled": True, "factor": FACTOR, "bronzePerGold": 100, "goldFrom": 100, "symbols": {"bronze": "🟤", "gold": "🟡"},
        "note": "Coins are counted in bronze: 100 bronze = 1 gold, like Rappen and Franken. The first rescale (13 Oct 2026) turned every old coin into 15 bronze, so the pace of the game stayed the same, and set familiar goods to realistic Swiss prices (planning/price-table.md). Amounts under goldFrom show as bronze only (35), from there as gold and bronze (2 gold 35 bronze)."}
    # the mark-up rule of made things: dishes made from dishes grow too fast; the table above is what the game uses now
    if "pricing" in econ: econ["pricing"]["note"] = econ["pricing"]["note"] + " (Informative only: the prices in items.json are the table in planning/price-table.md; the old formula over-priced dishes made from dishes: pizza 166, cheese board 204.)"
    # table
    rows.sort(key=lambda r: (r[0], r[4]))
    lines = ["# Price table (D3, 13 Oct 2026)", "", "Every item's value in **bronze** (100 bronze = 1 gold; like Rappen and Franken). *Before* = the old coins ×1; *After* = what the game uses now. "
             "Most things are the old value × %d (the same ratios, so the pace of the game is unchanged); the ones with a note are set to a realistic Swiss price. "
             "Made by `tools/rescale_prices.py`; change a price in `data/farm/items.json` and re-run the checks." % FACTOR, "",
             "Also scaled ×%d: every coin cost of goals, steps, animals, books, seeds (`seedCost`), what merchants sell for, coin barter, the start coins, the lost coin in the weeds and the little jobs' reward (%d nodes' costs, %d seed prices, %d merchant prices)." % (FACTOR, n_coins, n_seed, n_sells), "",
             "| Category | Item | Before (old coins) | After (bronze) | Note |", "|---|---|---:|---:|---|"]
    for c, k, name, old, new, note in rows:
        lines.append(f"| {c} | {name} (`{k}`) | {old} | {new} | {note} |")
    table = "\n".join(lines) + "\n"
    if dry:
        print(table); print("coins", n_coins, "seeds", n_seed, "sells", n_sells); return
    save(items_path, items, rows=True)
    for f, d in nodes.items(): save(f, d, rows=True)
    save(rw_path, rw); save(econ_path, econ); save(start_path, start)
    open(os.path.join(REPO, "planning", "price-table.md"), "w", encoding="utf-8").write(table)
    print("rescaled: %d coin amounts in nodes, %d seed prices, %d merchant prices, %d items" % (n_coins, n_seed, n_sells, len(rows)))

if __name__ == "__main__":
    main()
