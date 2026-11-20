"""E02 Forecast drift: how PG&E's forecast for the same feeder moves between snapshots.
This is the prediction dataset: each snapshot is PG&E's guess; later snapshots grade it.
Feeders whose headroom keeps shrinking are the ones to get ahead of."""
from common import snapshots, classified, f, out
s = snapshots()
if len(s) < 2:
    print('E02 needs 2+ snapshots; have', len(s)); raise SystemExit
first = {r['feeder_id']: r for r in classified(s[0])}
rows = []
for r in classified(s[-1]):
    o = first.get(r['feeder_id'])
    if not o: continue
    a, b = f(o['eff_headroom_2027']), f(r['eff_headroom_2027'])
    if a is None or b is None: continue
    rows.append(dict(feeder=r['feeder'], division=r['division'], tier_then=o['tier'], tier_now=r['tier'], headroom_2027_then=a, headroom_2027_now=b, drift_mw=round(b - a, 2)))
rows.sort(key=lambda r: r['drift_mw'])
out('drift.csv', rows)
print('E02 drift rows:', len(rows), 'worsened >=0.5MW:', sum(r['drift_mw'] <= -0.5 for r in rows))
