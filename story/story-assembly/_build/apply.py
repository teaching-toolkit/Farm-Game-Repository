import re,os,sys,glob
sys.path.insert(0,os.path.expanduser('~/work'))
from edits import EDITS
D=os.path.expanduser('~/work/rep')
files={f:open(f).read() for f in glob.glob(D+'/*.txt')}
def find_block(bid):
    for f,t in files.items():
        m=re.search(r'^@@ '+re.escape(bid)+r' \|.*?(?=^@@ |^# |\Z)',t,re.M|re.S)
        if m: return f,m
    raise SystemExit('no block '+bid)
errs=0
for n,(iss,bid,old,new,why,src,imp) in enumerate(EDITS,1):
    f,m=find_block(bid); blk=m.group(0)
    if old=='@@INSERT_AFTER':
        nb=blk.rstrip('\n')+'\n\n'+new+'\n\n'
    else:
        c=blk.count(old)
        if c!=1: print('ERR',n,bid,c,old[:50]); errs+=1; continue
        nb=blk.replace(old,new)
        # tag note
        lines=nb.split('\n')
        tag=f'%% [changes.md #{n}]'
        lines.insert(1,tag)
        nb='\n'.join(lines)
    t=files[f]; files[f]=t[:m.start()]+nb+t[m.end():]
for f,t in files.items(): open(f,'w').write(t)
print('errors',errs,'edits',len(EDITS))
