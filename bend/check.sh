#!/bin/sh
# Proof gate for the tier rules, then a cross-check against the newest snapshot.
set -eu
cd "$(dirname "$0")"
bend PROOF.bend | tee /tmp/proof.out
grep -q "ALL PROOFS CHECK" /tmp/proof.out
bend tiers.bend -o tiers.mjs
latest=$(ls -d ../data/pge_grip/*/ | sort | tail -1)
node crosscheck.mjs "${latest}feeders_classified.csv"
