import re,json,sys,os,glob
W=os.path.expanduser('~/work')
P=json.load(open(f'{W}/pieces.json'))
def parse(files):
    out=[]  # items: ('h',text) or ('b',meta,text)
    for f in files:
        cur=None
        for line in open(f):
            line=line.rstrip('\n')
            if line.startswith('@@ '):
                if cur: out.append(cur)
                parts=[x.strip() for x in line[3:].split('|')]
                cur={'type':'b','id':parts[0],'src':parts[1],'basis':parts[2],'opt':parts[3],'note':'','lines':[]}
            elif line.startswith('# ') or line.startswith('## '):
                if cur: out.append(cur); cur=None
                out.append({'type':'h','text':line})
            elif line.startswith('%% '):
                cur['note']+=(' ' if cur['note'] else '')+line[3:]
            else:
                if cur is not None: cur['lines'].append(line)
        if cur: out.append(cur)
    for b in out:
        if b['type']=='b':
            b['text']='\n'.join(b['lines']).strip()
    return out
def piece_ids(src):
    return [x for x in re.findall(r'\b(c[1-6]_[a-z0-9_]+)',src) if x in P]
def seed_ids(src):
    return re.findall(r'E-[0-9F]\.[A-Z]?\d+',src)
def render_story(items,title,intro):
    o=[f'# {title}\n',intro+'\n']
    for it in items:
        if it['type']=='h':
            t=it['text']
            o.append(('\n#'+t if t.startswith('# ') else '\n#'+t)+'\n')
        else:
            o.append(it['text']+'\n')
    return '\n'.join(o).replace('\n\n\n','\n\n')
if __name__=='__main__':
    mode=sys.argv[1]; files=sys.argv[2:]
    items=parse(files)
    json.dump(items,open(f'{W}/items-{mode}.json','w'),ensure_ascii=False,indent=0)
    print(len([i for i in items if i['type']=='b']),'blocks')
