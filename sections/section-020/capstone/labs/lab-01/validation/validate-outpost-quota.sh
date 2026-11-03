#!/usr/bin/env bash
# Check: ResourceQuota outpost-budget in outpost limits Pods to 4.
set -uo pipefail

pods="$(kubectl -n outpost get resourcequota outpost-budget -o jsonpath='{.spec.hard.pods}' 2>/dev/null || true)"
if [ -z "$pods" ]; then
  echo "FAIL: no ResourceQuota named outpost-budget in outpost"
  exit 1
fi
if [ "$pods" != "4" ]; then
  echo "FAIL: the quota allows ${pods} Pods, expected 4"
  exit 1
fi
echo "PASS: outpost-budget allows 4 Pods"
