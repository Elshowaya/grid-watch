# Grid Watch

Grid Watch tracks where California's distribution grid is out of room. It regularly pulls PG&E's public grid capacity data (GRIP), scores every feeder for spare capacity, flags constrained feeders where truck and bus fleets are already asking for power, and tests how PG&E's forecasts for the same feeder drift from one snapshot to the next.

## Sample site power reports

The same public data, taken down to a single site. Each report finds the likely serving feeder and bank, estimates hour-by-hour grid headroom and flexible-connection limits, and models how many vehicles the site can charge per day and at what cost. Both are anonymized and built entirely from public data.

- [Sample Site Power Report A: California school bus depot](sample-reports/Sample_Site_Power_Report_A_School_Bus_Depot.pdf)
- [Sample Site Power Report B: California truck-charging hub](sample-reports/Sample_Site_Power_Report_B_Truck_Charging_Hub.pdf)

More on what each shows, the method and the caveats: [sample-reports/README.md](sample-reports/README.md).

## How it runs

A GitHub Actions workflow (`.github/workflows/grid-watch.yml`) checks PG&E's public GRIP data every 6 hours, with no API keys. It saves a new snapshot only when PG&E has changed something, reruns every experiment, and writes a short summary to `reports/DIGEST.md`. Tier rules are also restated in Bend and proof-checked in CI (see `bend/README.md`).

## Definitions
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
