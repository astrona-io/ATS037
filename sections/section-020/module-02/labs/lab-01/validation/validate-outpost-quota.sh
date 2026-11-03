#!/usr/bin/env bash
# Check: ResourceQuota outpost-budget in outpost allows 5 Pods and 10 ConfigMaps.
set -uo pipefail

pods="$(kubectl -n outpost get resourcequota outpost-budget -o jsonpath='{.spec.hard.pods}' 2>/dev/null || true)"
cms="$(kubectl -n outpost get resourcequota outpost-budget -o jsonpath='{.spec.hard.configmaps}' 2>/dev/null || true)"

if [ -z "$pods" ] && [ -z "$cms" ]; then
  echo "FAIL: ResourceQuota outpost-budget was not found in outpost"
  exit 1
fi
if [ "$pods" != "5" ]; then
  echo "FAIL: hard pods is '${pods}', expected 5"
  exit 1
fi
if [ "$cms" != "10" ]; then
  echo "FAIL: hard configmaps is '${cms}', expected 10"
  exit 1
fi
echo "PASS: outpost-budget allows 5 Pods and 10 ConfigMaps"
