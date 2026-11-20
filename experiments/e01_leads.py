"""E01 Leads: constrained or tight feeders where truck/bus fleets are already asking for power.
Hypothesis: a fleet requesting load on a short feeder is the customer who needs a fast-power answer."""
from common import classified, f, out
rows = [r for r in classified() if r['tier'] in ('PERSISTENT', 'CONSTRAINED_NOW', 'TIGHT', 'EMERGING') and int(r['ev_fleet_requests'] or 0) > 0]
rank = {'PERSISTENT': 0, 'CONSTRAINED_NOW': 1, 'TIGHT': 2, 'EMERGING': 3}
rows.sort(key=lambda r: (rank[r['tier']], -int(r['ev_fleet_requests']), f(r['eff_headroom_2027']) or 0))
out('leads.csv', [{k: r[k] for k in ('feeder', 'substation', 'division', 'tier', 'eff_headroom_2027', 'peak_pct_2027', 'ev_fleet_requests', 'need_date')} for r in rows])
print('E01 leads:', len(rows))
