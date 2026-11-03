#!/usr/bin/env bash
# Check: the Mission survey-run exists with the required objective and crew size.
set -uo pipefail

get() { kubectl -n starfleet get missions.starfleet.example.com survey-run -o jsonpath="$1" 2>/dev/null || true; }

obj="$(get '{.spec.objective}')"
crew="$(get '{.spec.crewSize}')"

if [ -z "$obj" ] && [ -z "$crew" ]; then
  echo "FAIL: Mission survey-run was not found in starfleet"
  exit 1
fi
if [ "$obj" != "map the nebula" ]; then
  echo "FAIL: objective is '${obj}', expected 'map the nebula'"
  exit 1
fi
if [ "$crew" != "4" ]; then
  echo "FAIL: crewSize is '${crew}', expected 4"
  exit 1
fi
echo "PASS: Mission survey-run has objective '${obj}' and crewSize ${crew}"
