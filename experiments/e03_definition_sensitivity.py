"""E03 Definition test: how many feeders count as constrained under different rules.
If the count swings wildly, the definition is doing the work, not the grid."""
from common import classified, f, out
rows = classified(); res = []
for label, test in [
    ('eff<0 in 2027', lambda r: (f(r['eff_headroom_2027']) or 1) < 0),
    ('eff<0.5MW in 2027', lambda r: (f(r['eff_headroom_2027']) or 9) < 0.5),
    ('eff<1MW in 2027', lambda r: (f(r['eff_headroom_2027']) or 9) < 1),
    ('peak>=85% 2027', lambda r: (f(r['peak_pct_2027']) or 0) >= 85),
    ('peak>=90% 2027', lambda r: (f(r['peak_pct_2027']) or 0) >= 90),
    ('peak>=100% 2027', lambda r: (f(r['peak_pct_2027']) or 0) >= 100),
    ('eff<0 any 2026-30', lambda r: any((f(r[f'eff_headroom_{y}']) or 1) < 0 for y in range(2026, 2031))),
]:
    res.append(dict(rule=label, feeders=sum(map(test, rows)), share=round(sum(map(test, rows)) / len(rows) * 100, 1)))
out('definition_sensitivity.csv', res)
for r in res: print('E03', r)
