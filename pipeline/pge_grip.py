#!/usr/bin/env python3
"""Constrained-feeder watch for PG&E GRIP (public ArcGIS feed behind grip.pge.com).

Usage: python3 watch.py [--force]
- Checks each layer's lastEditDate. If nothing changed since the last snapshot, exits (cheap).
- Otherwise pulls all layers, saves a dated snapshot, classifies every feeder, and diffs vs the previous snapshot.

Definition (Hark's working definition, from GRIP forecast fields):
  headroom_mw(year) = feeder rating - forecast peak loading. Negative = deficiency.
  A feeder's effective headroom is the lower of its own headroom and its bank's headroom.
  Tiers:
    CONSTRAINED_NOW   effective headroom < 0 in 2026 or 2027
    PERSISTENT        effective headroom < 0 in every year 2026-2030 (subset of constrained)
    TIGHT             not constrained, but loading >= 90% of rating (feeder or bank) in 2026/2027
    EMERGING          fine in 2026/2027, deficiency appears in 2028-2030
    OPEN              none of the above
  Plus: ev_fleet_requests = open truck/bus EV known+pending load requests on the feeder (demand signal).
GRIP is illustrative, not a capacity guarantee (PG&E AL 7899-E). -99.99 = redacted/blank.
"""
import json, os, sys, csv, time, datetime, urllib.request, urllib.parse, glob, gzip

B = "https://services2.arcgis.com/mJaJSax0KPHoCNB6/arcgis/rest/services/DRPComplianceRelProd/FeatureServer"
LAYERS = [(28, 'gna_sub'), (31, 'df_sub'), (11, 'gna_circ'), (13, 'df_circ'), (33, 'pending'), (19, 'known'), (2, 'feeders')]
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SNAP = os.path.join(ROOT, 'data', 'pge_grip')
YEARS = range(2026, 2031)


def get(url, tries=3):
    for t in range(tries):
        try:
            return json.load(urllib.request.urlopen(url, timeout=90))
        except Exception:
            if t == tries - 1:
                raise
            time.sleep(5 * (t + 1))


def edit_dates():
    out = {}
    for i, n in LAYERS:
        m = get(f"{B}/{i}?f=json")
        out[n] = (m.get('editingInfo') or {}).get('lastEditDate') or (m.get('editingInfo') or {}).get('dataLastEditDate')
    return out


def pull(i):
    out = []; off = 0
    while True:
        q = urllib.parse.urlencode(dict(where="1=1", outFields="*", returnGeometry="false",
                                        resultOffset=off, resultRecordCount=2000, f="json"))
        d = get(f"{B}/{i}/query?{q}")
        fs = [f['attributes'] for f in d.get('features', [])]; out += fs
        if not d.get('exceededTransferLimit') and len(fs) < 2000:
            break
        off += len(fs)
    return out


def num(v):
    try:
        v = float(v)
    except (TypeError, ValueError):
        return None
    return None if v <= -99 else v


def classify(data):
    banks = {}
    for r in data['df_sub']:
        if r.get('facilitytype') != 'BANK':
            continue
        rating = num(r.get('facilityratingmw'))
        banks[r['bankname'].strip()] = {y: (rating - num(r.get(f'facilityloadingmw{y}')) if rating and num(r.get(f'facilityloadingmw{y}')) is not None else None) for y in YEARS} | {'rating': rating, 'load27': num(r.get('facilityloadingmw2027'))}
    ev = {}
    for src in ('known', 'pending'):
        for r in data[src]:
            if r.get('Type') == 'Transportation' and any(k in str(r.get('Category')) for k in ('MD', 'HD')) and str(r.get('Status')).lower() != 'cancelled':
                ev[r.get('feeder_id')] = ev.get(r.get('feeder_id'), 0) + 1
    gna = {r.get('facilityid'): r for r in data['gna_circ']}
    rows = []
    for r in data['df_circ']:
        fid = r.get('circuitid') or r.get('idnumber')
        rating = num(r.get('facilityratingmw'))
        bank = (r.get('bankname') or '').strip(); b = banks.get(bank, {})
        fh = {y: (rating - num(r.get(f'facilityloadingmw{y}')) if rating and num(r.get(f'facilityloadingmw{y}')) is not None else None) for y in YEARS}
        eff = {}
        for y in YEARS:
            vals = [v for v in (fh[y], b.get(y)) if v is not None]
            eff[y] = min(vals) if vals else None
        if all(v is None for v in eff.values()):
            continue
        def neg(y): return eff[y] is not None and eff[y] < 0
        l27 = num(r.get('facilityloadingmw2027'))
        pct = max([p for p in ((l27 / rating * 100) if rating and l27 is not None else None,
                               (b['load27'] / b['rating'] * 100) if b.get('rating') and b.get('load27') is not None else None) if p is not None], default=None)
        if neg(2026) or neg(2027):
            tier = 'PERSISTENT' if all(neg(y) for y in YEARS) else 'CONSTRAINED_NOW'
        elif pct is not None and pct >= 90:
            tier = 'TIGHT'
        elif any(neg(y) for y in (2028, 2029, 2030)):
            tier = 'EMERGING'
        else:
            tier = 'OPEN'
        g = gna.get(fid, {})
        rows.append(dict(feeder_id=fid, feeder=r.get('circuitname') or r.get('gnafacilityname'), substation=(r.get('substationname') or '').strip(),
                         bank=bank, division=r.get('division'), tier=tier, rating_mw=rating,
                         **{f'eff_headroom_{y}': None if eff[y] is None else round(eff[y], 2) for y in YEARS},
                         peak_pct_2027=None if pct is None else round(pct, 1),
                         need_date=g.get('anticipatednecessarydate') or g.get('anticipatedneeddate'), driver=g.get('primarydriver'),
                         ev_fleet_requests=ev.get(fid, 0)))
    return rows


def main():
    force = '--force' in sys.argv
    os.makedirs(SNAP, exist_ok=True)
    dates = edit_dates()
    prev_dirs = sorted(glob.glob(os.path.join(SNAP, '*')))
    prev = prev_dirs[-1] if prev_dirs else None
    if prev and not force:
        old = json.load(open(os.path.join(prev, 'edit_dates.json')))
        if old == dates:
            print(json.dumps({'changed': False, 'checked': datetime.datetime.now().isoformat(timespec='minutes'), 'last_snapshot': os.path.basename(prev)}))
            return
    stamp = datetime.datetime.now().strftime('%Y-%m-%d_%H%M')
    d = os.path.join(SNAP, stamp); os.makedirs(d)
    data = {n: pull(i) for i, n in LAYERS}
    for n, v in data.items():
        with gzip.open(os.path.join(d, f'{n}.json.gz'), 'wt') as g:
            json.dump(v, g)
    json.dump(dates, open(os.path.join(d, 'edit_dates.json'), 'w'))
    rows = classify(data)
    with open(os.path.join(d, 'feeders_classified.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
    counts = {}
    for r in rows:
        counts[r['tier']] = counts.get(r['tier'], 0) + 1
    changes = []
    if prev and os.path.exists(os.path.join(prev, 'feeders_classified.csv')):
        old = {r['feeder_id']: r for r in csv.DictReader(open(os.path.join(prev, 'feeders_classified.csv')))}
        for r in rows:
            o = old.get(r['feeder_id'])
            if not o:
                changes.append(dict(feeder=r['feeder'], change='new feeder', tier=r['tier'])); continue
            if o['tier'] != r['tier']:
                changes.append(dict(feeder=r['feeder'], change=f"{o['tier']} -> {r['tier']}", tier=r['tier']))
            try:
                dh = float(r['eff_headroom_2027']) - float(o['eff_headroom_2027'])
                if abs(dh) >= 0.5:
                    changes.append(dict(feeder=r['feeder'], change=f"2027 headroom {dh:+.2f} MW", tier=r['tier']))
            except (TypeError, ValueError):
                pass
            if int(o.get('ev_fleet_requests') or 0) < r['ev_fleet_requests']:
                changes.append(dict(feeder=r['feeder'], change=f"+{r['ev_fleet_requests'] - int(o.get('ev_fleet_requests') or 0)} truck/bus EV requests", tier=r['tier']))
    constrained = [r for r in rows if r['tier'] in ('CONSTRAINED_NOW', 'PERSISTENT')]
    hot = sorted([r for r in constrained if r['ev_fleet_requests'] > 0], key=lambda r: (-r['ev_fleet_requests'], r['eff_headroom_2027'] or 0))
    summary = dict(snapshot=stamp, edit_dates={k: (datetime.datetime.fromtimestamp(v / 1000, datetime.timezone.utc).strftime('%Y-%m-%d') if v else None) for k, v in dates.items()},
                   feeders_scored=len(rows), tiers=counts, changes=len(changes),
                   top_constrained_with_fleet_demand=[{k: r[k] for k in ('feeder', 'substation', 'tier', 'eff_headroom_2027', 'ev_fleet_requests', 'division')} for r in hot[:15]],
                   change_list=changes[:200])
    json.dump(summary, open(os.path.join(d, 'summary.json'), 'w'), indent=1)
    json.dump(summary, open(os.path.join(ROOT, 'reports', 'latest_summary.json'), 'w'), indent=1)
    print(json.dumps({k: summary[k] for k in ('snapshot', 'feeders_scored', 'tiers', 'changes', 'edit_dates')}))


if __name__ == '__main__':
    main()
