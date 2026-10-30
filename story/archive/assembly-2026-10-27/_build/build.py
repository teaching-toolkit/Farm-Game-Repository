import re,json,os,sys
sys.path.insert(0,os.path.expanduser('~/work'))
from render import parse
W=os.path.expanduser('~/work')
P=json.load(open(f'{W}/pieces.json')); S=json.load(open(f'{W}/seeds.json'))
PH=json.load(open(f'{W}/piecehist.json'))
SEC={'slices/01-opening-hour/dossier.md':'§5','slices/02-lived-in-hazelwood/dossier.md':'§ seeds','slices/03-helpers-and-rhyme/dossier.md':'seed section','slices/04-barn-truth-thread/dossier.md':'seed section','slices/06-lark-mumyo-melody-awe/dossier.md':'§6.1','slices/07-lord-lease-clock/dossier.md':'seed section'}
BASIS={'S':'shipped game text','W':'staged game text (not yet in the game)','N':'no game text: built from the seed (sketch lines verbatim where the seed has them)','canon':'reference section written from canon files'}
def pfile(k):
    p=P[k]; f=p['file']
    if 'godot-prototype' in f: return 'godot-prototype/data/farm/story/'+f.split('/')[-1]+' only'
    fn=f.split('/')[-1]
    if fn.startswith('more-'):
        return f'story/archive/texts/{fn} (staged; JSON copy story/archive/staging/{fn[:-3]}.json)'
    ch=fn[2]
    js={'1':'10-chapter-1','2':'15-chapter-2','3':'20-chapter-3','4':'22-chapter-4','5':'25-chapter-5','6':'30-chapter-6'}[ch]
    return f'story/archive/texts/{fn} (shipped; = godot-prototype/data/farm/story/{js}.json)'
def esc(s): return s.replace('|','\\|').replace('\n',' / ')
def chap(bid):
    if bid.startswith('F'): return 'Frame '+bid[1:].split('.')[0]
    if bid.startswith('R'): return 'Reference'
    return 'Ch'+bid.split('.')[0]
def srcmap(items,title,note):
    o=[f'# {title}\n',note,'']
    o.append('Basis codes: **S** shipped game text · **W** staged game text · **N** no game text (built from the outline seed; sketch lines verbatim where they exist) · **-rev** game text revised as the seed directs · **-bark** an ambient line · **canon** a reference section. All game text is rendered in the third person (convention 1 in `inventory.md`); the original second-person wording is in the last-but-one column.\n')
    o.append('Seed files: every seed id (`E-…`) lives in one slice dossier, named in the column; the play order is `story/outline/master/chN.md`. Piece versions: every piece exists in one version only (`story/archive/texts/*.md`, identical to git HEAD `story/texts/`, and to the game JSON); older git revisions are listed where the text differed. Seed sections are identical in the run snapshots `story/archive/run-2026-10-23/after-round-0[1-3]/` (no superseded seed text).\n')
    cur=None
    for it in items:
        if it['type']=='h':
            if it['text'].startswith('# '):
                o.append('\n## '+it['text'][2:]+'\n'); o.append('| Loc | Opening words | Source (file, piece / seed id) | Basis / version used | Superseded versions | Original game wording (2nd person) | Optional in-game? | Note |'); o.append('|---|---|---|---|---|---|---|---|')
            continue
        b=it; bid=b['id']
        words=' '.join(b['text'].split()[:7])+' …'
        srcs=[]
        for sid in re.findall(r'E-[0-9F]\.[A-Z]?\d+',b['src']):
            f=S[sid][0]['file'] if sid in S else '?'
            srcs.append(f'{sid} ({f.replace("slices/","story/slices/")})')
        pk=[x for x in re.findall(r'\b(c[1-6]_[a-z0-9_]+)',b['src'])]
        for k in pk:
            if k in P: srcs.append(f'`{k}` ({pfile(k)})')
            else: srcs.append(f'new piece `{k}` (planned by the seed; no text exists)')
        if b['basis']=='canon': srcs=[b['src']]
        base=b['basis'].split('-')[0]
        ver=BASIS.get(base,base)+(' , revised per the seed' if 'rev' in b['basis'] else '')
        if base in('S','W'): ver+=' · texts 13–14 Oct 2026'
        if any(s.startswith('E-') for s in re.findall(r'E-[0-9F]\.[A-Z]?\d+',b['src'])): ver+=' · seed: slice rev. 2, 23–24 Oct 2026'
        sup=[]
        for k in pk:
            if k in PH: sup.append(f'`{k}`: '+', '.join('git '+x for x in PH[k]))
        sup='; '.join(sup) or '—'
        orig=' // '.join(f'`{k}`: '+P[k]['text'] for k in pk if k in P) or '—'
        o.append(f"| {chap(bid)} · {bid} | {esc(words)} | {esc('; '.join(srcs))} | {esc(ver)} | {esc(sup)} | {esc(orig)} | {b['opt']} | {esc(b['note'])} |")
    return '\n'.join(o)+'\n'
def story(items,title,intro):
    o=[f'# {title}\n',f'*{intro}*\n']
    for it in items:
        if it['type']=='h':
            t=it['text']
            o.append(('## '+t[2:]) if t.startswith('# ') else ('### '+t[3:]))
            o.append('')
        else:
            o.append(it['text']); o.append('')
    s='\n'.join(o)
    s=re.sub(r'\n{3,}','\n\n',s)
    return s
def wc(items):
    d={};cur=None
    for it in items:
        if it['type']=='h' and it['text'].startswith('# '): cur=it['text'][2:]; d[cur]=0
        elif it['type']=='b': d[cur]+=len(it['text'].split())
    return d
if __name__=='__main__':
    mode=sys.argv[1]; out=sys.argv[2]; files=sys.argv[3:]
    items=parse(files)
    json.dump(items,open(f'{W}/items-{mode}.json','w'),ensure_ascii=False,indent=0)
    if mode=='assembled':
        open(f'{out}/story-assembled.md','w').write(story(items,'The farm that burned down','Assembled story, before repairs: the master outline in play order, built from the game texts and the outline seeds. Baseline for comparison with story-repaired.md.'))
        open(f'{out}/source-map-assembled.md','w').write(srcmap(items,'Source map (assembled baseline)',''))
    else:
        open(f'{out}/story-repaired.md','w').write(story(items,'The farm that burned down','The story, assembled and repaired.'))
        open(f'{out}/source-map.md','w').write(srcmap(items,'Source map','For every passage of `story-repaired.md`, in order. Block ids (the Loc column) are not printed in the story; the Opening words column finds the passage. Passages changed by a repair are marked in the Note column with their `changes.md` number.'))
    json.dump(wc(items),open(f'{W}/wc-{mode}.json','w'),indent=0)
    print(wc(items))
