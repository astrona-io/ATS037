#!/usr/bin/env bash
# Check: PodDisruptionBudget convoy-budget keeps at least 2 convoy Pods available.
set -uo pipefail

min="$(kubectl -n starfleet get pdb convoy-budget -o jsonpath='{.spec.minAvailable}' 2>/dev/null || true)"
app="$(kubectl -n starfleet get pdb convoy-budget -o jsonpath='{.spec.selector.matchLabels.app}' 2>/dev/null || true)"

if [ -z "$app" ]; then
  echo "FAIL: PodDisruptionBudget convoy-budget was not found in starfleet"
  exit 1
fi
if [ "$app" != "convoy" ]; then
  echo "FAIL: the selector matches app='${app}', expected convoy"
  exit 1
fi
if [ "$min" != "2" ]; then
  echo "FAIL: minAvailable is '${min}', expected 2"
  exit 1
fi
echo "PASS: convoy-budget keeps at least 2 convoy Pods available"
