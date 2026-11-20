"""Shared helpers: load snapshots without re-pulling (zero API calls, zero tokens)."""
import os, glob, csv, json, gzip
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SNAP = os.path.join(ROOT, 'data', 'pge_grip')

def snapshots():
    return sorted(glob.glob(os.path.join(SNAP, '*')))

def classified(snap=None):
    snap = snap or snapshots()[-1]
    return list(csv.DictReader(open(os.path.join(snap, 'feeders_classified.csv'))))

def raw(layer, snap=None):
    snap = snap or snapshots()[-1]
    with gzip.open(os.path.join(snap, f'{layer}.json.gz'), 'rt') as f:
        return json.load(f)

def f(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return None

def out(name, rows):
    p = os.path.join(ROOT, 'reports', name)
    if rows:
        with open(p, 'w', newline='') as fh:
            w = csv.DictWriter(fh, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
    return p
