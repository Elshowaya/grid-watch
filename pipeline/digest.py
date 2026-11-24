"""Writes reports/DIGEST.md: a short summary of each snapshot, so readers don't need the raw data."""
import os, json, csv, datetime
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
R = os.path.join(ROOT, 'reports')
import glob
p = os.path.join(R, 'latest_summary.json')
if not os.path.exists(p):
    p = os.path.join(sorted(glob.glob(os.path.join(ROOT, 'data', 'pge_grip', '*')))[-1], 'summary.json')
s = json.load(open(p))
def head(name, n):
    p = os.path.join(R, name)
    return list(csv.DictReader(open(p)))[:n] if os.path.exists(p) else []
L = [f"# Grid Watch digest ({datetime.date.today()})", '', f"Snapshot {s['snapshot']}; PG&E edit dates {s['edit_dates']}", '',
     f"Feeders scored {s['feeders_scored']}; tiers {s['tiers']}; changes since last snapshot {s['changes']}", '', '## Changes']
L += [f"- {c['feeder']}: {c['change']} ({c['tier']})" for c in s['change_list'][:40]] or ['- none']
L += ['', '## Top leads (constrained/tight + truck/bus requests)']
L += [f"- {r['feeder']} ({r['division']}): {r['tier']}, 2027 headroom {r['eff_headroom_2027']} MW, {r['ev_fleet_requests']} requests" for r in head('leads.csv', 15)]
L += ['', '## Biggest forecast deterioration']
L += [f"- {r['feeder']}: {r['headroom_2027_then']} -> {r['headroom_2027_now']} MW" for r in head('drift.csv', 10)] or ['- needs 2 snapshots']
open(os.path.join(R, 'DIGEST.md'), 'w').write('\n'.join(L) + '\n')
print('digest written')
