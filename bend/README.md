# Tier laws (Bend)

`tiers.bend` restates the tier rules from `pipeline/pge_grip.py`. `LAWS.bend` holds the rules that must never break; `PROOF.bend` proves them by checking every combination of signals.

1. A feeder short on capacity in 2027 is never marked OPEN.
2. A feeder short in 2027 is never hidden as merely TIGHT.
3. PERSISTENT means short in every year 2026-2030, and nothing else.
4. OPEN means no shortfall in any year and loading under 90%, and nothing else.

`check.sh` runs the proof gate, then compares Bend's tiers with Python's on the newest snapshot. First run (2026-11-20_1839): 2,685 of 2,687 agree. The 2 that differ are rounding at exactly 90.0% in the CSV, not a logic bug.

Humans edit LAWS.bend. Code changes must keep `bend PROOF.bend` at ALL PROOFS CHECK.
