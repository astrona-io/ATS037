#!/usr/bin/env bash
# Check: PodDisruptionBudget caravan selects app=caravan with minAvailable 2.
set -uo pipefail

min="$(kubectl -n starfleet get pdb caravan -o jsonpath='{.spec.minAvailable}' 2>/dev/null || true)"
app="$(kubectl -n starfleet get pdb caravan -o jsonpath='{.spec.selector.matchLabels.app}' 2>/dev/null || true)"
if [ -z "$app" ]; then
  echo "FAIL: no PodDisruptionBudget named caravan with a matchLabels selector in starfleet"
  exit 1
fi
if [ "$app" != "caravan" ] || [ "$min" != "2" ]; then
  echo "FAIL: selector app='${app}' minAvailable='${min}', expected app=caravan and 2"
  exit 1
fi
echo "PASS: caravan keeps at least 2 Pods available"
