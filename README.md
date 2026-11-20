# Grid Watch

Finds where California's distribution grid is out of room, who is asking for power there, and how utility forecasts move over time.

Loop: GitHub Actions pulls public data every 6 hours (no keys, no model tokens). It saves a snapshot only when the utility changed something, reruns every experiment, and writes `reports/DIGEST.md`. Hark reads only the digest.

## Definitions (Hark's working definitions)
- **Feeder**: one medium-voltage line (usually 12 or 21 kV) leaving a substation bank and serving an area.
- **Headroom** = rating - forecast peak load (MW). Effective headroom = the lower of the feeder's and its bank's.
- **Tiers**: PERSISTENT (short every year 2026-30), CONSTRAINED_NOW (short 2026 or 2027), TIGHT (>=90% loaded 2027), EMERGING (first short 2028-30), OPEN.
- GRIP is illustrative, not a capacity guarantee (PG&E AL 7899-E). -99.99 = redacted.

## Experiments
| # | Question | Output |
|---|---|---|
| E01 | Which short feeders already have truck/bus fleets asking for power? | reports/leads.csv |
| E02 | How do PG&E's forecasts for the same feeder drift between snapshots? (prediction ground truth) | reports/drift.csv |
| E03 | How sensitive is the "constrained" count to the definition? | reports/definition_sensitivity.csv |
| E04 | Which divisions have the most squeeze plus fleet demand? | reports/by_division.csv |

Add an experiment: drop `experiments/eNN_name.py` that reads snapshots through `common.py` and writes one CSV to `reports/`.

## Run locally
`./run_all.sh` (add `--force` to re-pull even if unchanged).
