import json, statistics as st
d=json.load(open("/tmp/wv-scratch/sierra_rerun_segments.json"))
PH=[("A intro/small talk",0,91),("B company overview",91,336),("C background + Q&A (English)",336,1552),
    ("D Portuguese close",1552,1779),("E English tail",1779,1892)]
print("phase                          wpm    segs   median gap   max gap")
for name,a,b in PH:
    segs=[s for s in d if s["start"]>=a and s["start"]<b]
    if not segs: continue
    words=sum(len(s["text"].split()) for s in segs)
    wpm=words/((b-a)/60.0)
    gaps=[segs[i+1]["start"]-segs[i]["end"] for i in range(len(segs)-1)]
    gaps=[g for g in gaps if g>=0]
    med=st.median(gaps) if gaps else 0.0
    mx=max(gaps) if gaps else 0.0
    print("%-28s %6.1f  %5d   %8.2fs  %7.2fs" % (name, wpm, len(segs), med, mx))
allg=[]
for i in range(len(d)-1):
    g=d[i+1]["start"]-d[i]["end"]
    if g>=0: allg.append((g,d[i]["end"]))
allg.sort(reverse=True)
print("\nlongest silences (whisper segment gaps):")
for g,t in allg[:5]:
    print("   %5.2fs at %02d:%02d" % (g, int(t)//60, int(t)%60))
