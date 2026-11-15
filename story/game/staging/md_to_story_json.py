#!/usr/bin/env python3
"""Convert story/game/texts/more-chN.md to staging JSON (same schema as data/farm/story/*.json).
Also reads ../texts/moments.md (story/25: chapter from a `*Chapter:* N` token, `*Picture:* name` becomes one page with that picture) and writes ./moments.json.
Usage: python3 md_to_story_json.py   (run from story/game/staging; reads ../texts, writes ./more-chN.json and ./moments.json)
Also validates conditions against nodes, cards, counters and piece ids."""
import json, re, glob, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
TEXTS = os.path.join(HERE, '..', 'texts')
DATA = os.path.join(HERE, '..', '..', '..', 'godot-prototype', 'data', 'farm')
MOMENT_PRIO = 45
PRIO = {'frame':100,'beat':80,'discovery':60,'letter':55,'moment':50,'visit':50,'scene':55,'bark':40}
EMOJI = {'frame':'🛏️','beat':'📖','discovery':'🔎','letter':'✉️','moment':'✨','visit':'🚪','scene':'🎭','bark':'💬'}
COUNTERS = set('chapter sidequests seasons weeds cards harvests rest_quick medals sold_kinds friends coins album chapter step goals trips packed skill_ranks well_mood forest_trips forest_poisoned forest_checked lord_owed lord_paid lord_shares pests energy water stones animals'.split())

def parse(path, chapter=None):
    out = {}; cur = None
    for line in open(path, encoding='utf-8'):
        line = line.rstrip('\n')
        m = re.match(r'## (\w+) · (\w+)(?: · (.*))?$', line)
        if m:
            cur = dict(id=m[1], kind=m[2], title=(m[3] or '').strip(), body=[], when=None, prio=None, emoji=None, chapter=None, picture=None)
            out[m[1]] = cur; continue
        if cur is None: continue
        if line.startswith('*When:*'):
            w = re.search(r'\*When:\* `([^`]+)`', line); cur['when'] = [c.strip() for c in w[1].split(' + ')]
            p = re.search(r'\*Priority:\* (\d+)', line); cur['prio'] = int(p[1]) if p else None
            e = re.search(r'\*Emoji:\* (\S+)', line); cur['emoji'] = e[1] if e else None
            c = re.search(r'\*Chapter:\* (\d+)', line); cur['chapter'] = int(c[1]) if c else None
            pc = re.search(r'\*Picture:\* (\w+)', line); cur['picture'] = pc[1] if pc else None
        elif line.strip():
            cur['body'].append(line.strip())
    res = {}
    for id_, c in out.items():
        k = c['kind']; paras = c['body']
        pages = []
        if any(re.match(r'Page \d+\.', p) for p in paras):
            for p in paras:
                pages.append({'text': re.sub(r'^Page \d+\.\s*', '', p)})
        if c['picture'] and not pages: pages = [{'text': ' '.join(paras), 'picture': c['picture']}]
        elif c['picture']: pages[0]['picture'] = c['picture']
        d = {'kind': k, 'chapter': c['chapter'] or chapter, 'when': c['when'], 'priority': c['prio'] or (MOMENT_PRIO if chapter is None else PRIO[k]), 'emoji': c['emoji'] or EMOJI[k]}
        if k == 'bark': d['once'] = False
        if c['title']: d['title'] = c['title']
        if pages: d['pages'] = pages
        else: d['text'] = ' '.join(paras)
        res[id_] = d
    return res

def validate(allp):
    nodes = set(); cards = set(); items = set()
    for f in glob.glob(DATA + '/nodes/*.json'):
        d = json.load(open(f)); d = d.get('nodes', d) if isinstance(d, dict) else {}; nodes |= set(d.keys())
    existing = set()
    for f in glob.glob(DATA + '/story/*.json'):
        if f.endswith('-more.json') or f.endswith('40-moments.json'): continue      # the built copies of these very pieces (story/08)
        existing |= set(json.load(open(f)))
    try: items = set(json.load(open(DATA + '/items.json')))
    except Exception: pass
    pieces = existing | set(allp)
    errs = []
    for id_, d in allp.items():
        if id_ in existing: errs.append(f'{id_}: duplicates an existing id')
        for c in d['when']:
            h, _, r = c.partition(':')
            if c in ('start', 'rain') or h == 'chance': continue
            if h == 'done':
                if r not in nodes: errs.append(f'{id_}: unknown node {r}')
            elif h == 'page':
                if r not in nodes: errs.append(f'{id_}: unknown card {r}')
            elif h == 'seen':
                if r not in pieces and r not in {'coins','album','bag','scroll','face','skills'}: errs.append(f'{id_}: unknown piece {r}')
            elif h == 'after':
                pp = r.rsplit(':', 1)[0]
                if pp not in pieces: errs.append(f'{id_}: after unknown piece {pp}')
            elif h == 'has':
                it = r.split(':')[0]
                if items and it not in items: errs.append(f'{id_}: item {it} not in items.json')
            elif h in ('season', 'tap', 'item', 'unlocked', 'open'): pass
            else:
                m = re.match(r'(\w+)(?:>=|<=|<|>|=)(\d+)$', c)
                if not m or m[1] not in COUNTERS: errs.append(f'{id_}: cannot parse condition {c}')
        if not d['when']: errs.append(f'{id_}: no When')
    return errs

if __name__ == '__main__':
    allp = {}
    for f in sorted(glob.glob(TEXTS + '/more-ch*.md')):
        n = int(re.search(r'more-ch(\d)', f)[1])
        r = parse(f, n); allp.update(r)
        json.dump(r, open(os.path.join(HERE, f'more-ch{n}.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print(os.path.basename(f), len(r), 'pieces')
    mf = os.path.join(TEXTS, 'moments.md')
    if os.path.exists(mf):
        r = parse(mf); allp.update(r)
        json.dump(r, open(os.path.join(HERE, 'moments.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print('moments.md', len(r), 'pieces')
    errs = validate(allp)
    print('\n'.join(errs) if errs else 'no validation errors')
    sys.exit(1 if errs else 0)
