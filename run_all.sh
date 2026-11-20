#!/usr/bin/env bash
# Pull (only if PG&E changed) -> experiments -> digest. Free on GitHub Actions; zero model tokens.
set -e
cd "$(dirname "$0")"
python3 pipeline/pge_grip.py "$@"
for e in experiments/e*.py; do (cd experiments && python3 "$(basename "$e")"); done
python3 pipeline/digest.py
