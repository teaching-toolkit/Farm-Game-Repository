import json,re,sys,os
sys.path.insert(0,'.')
from edits import EDITS
S=json.load(open('status.json'))
I=json.load(open('items-repaired.json'))
op={b['id']:' '.join(b['text'].split()[:6])+' …' for b in I if b['type']=='b'}
wa=json.load(open('wc-assembled.json')); wr=json.load(open('wc-repaired.json'))
def esc(s): return s.replace('|','\\|').replace('\n',' / ')
def ch(b): return 'Frame 0' if b.startswith('F0') else ('Ch'+b.split('.')[0])
o=['# Changes log','','All changes from `story-assembled.md` (the baseline) to `story-repaired.md`. Then the joins and convention edits made while assembling, the cold read, and the status of every item in Appendices A and B. Locations use the block ids of `source-map.md` (Loc column) and the passage\'s opening words. The decisions on B2 and B3 are in `open-questions.md` (D-B2, D-B3). Changes #1–#52 come from the appendix check; #53–#71 come from the cold read (§4).','',
'## 1. Word counts per chapter','','| Section | Assembled | Repaired | Growth |','|---|---:|---:|---:|']
for k in wa:
    g=(wr[k]-wa[k])/wa[k]*100 if wa[k] else 0
    o.append(f'| {k} | {wa[k]} | {wr[k]} | {g:+.1f} % |')
o+=['','Growth stays far under the 25 % limit everywhere. The frame grows most in relative terms (the name in F0.1).','',
'## 2. Repairs','','| # | Issue | Location | What changed | Why | Source | Game impact (phase 2) |','|---|---|---|---|---|---|---|']
for n,(iss,bid,old,new,why,src,imp) in enumerate(EDITS,1):
    if old=='@@INSERT_AFTER':
        what='New passage after 3.17: “A child at the gate says, “My mum says it was lightning.” “Did she?” says Fenna.”'; loc='Ch3 · new 3.17b'
    else:
        what=f'“{old}” → “{new}”'; loc=f'{ch(bid)} · {bid} · {op.get(bid,"")}'
    o.append(f'| {n} | {esc(iss)} | {esc(loc)} | {esc(what)} | {esc(why)} | {esc(src)} | {esc(imp)} |')
o+=open('joins.md').read().split('\n')
order=[f'A{i}' for i in range(1,70)]+[f'B{i}' for i in range(1,11)]
o+=['','## 5. Status of every item in Appendices A and B','','| Item | Status |','|---|---|']
for k in order: o.append(f'| {k} | {esc(S.get(k,"?"))} |')
o+=open('newitems.md').read().split('\n')
open(os.path.expanduser('~/mnt/Farm game/story-assembly/changes.md'),'w').write('\n'.join(o)+'\n')
