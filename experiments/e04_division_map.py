"""E04 Where the squeeze is: constrained feeders and fleet demand by PG&E division (sales territory)."""
from common import classified, out
agg = {}
for r in classified():
    a = agg.setdefault(r['division'] or '?', dict(division=r['division'] or '?', feeders=0, constrained=0, tight=0, fleet_requests_on_constrained=0))
    a['feeders'] += 1
    if r['tier'] in ('PERSISTENT', 'CONSTRAINED_NOW'):
        a['constrained'] += 1; a['fleet_requests_on_constrained'] += int(r['ev_fleet_requests'] or 0)
    elif r['tier'] == 'TIGHT':
        a['tight'] += 1
rows = sorted(agg.values(), key=lambda a: -a['fleet_requests_on_constrained'])
out('by_division.csv', rows)
print('E04 top:', rows[:3])
