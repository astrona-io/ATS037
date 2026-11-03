#!/usr/bin/env bash
# Check: hangar uses RollingUpdate with maxSurge 1 and maxUnavailable 0, and all replicas are available.
set -uo pipefail

type="$(kubectl -n starfleet get deployment hangar -o jsonpath='{.spec.strategy.type}' 2>/dev/null || true)"
surge="$(kubectl -n starfleet get deployment hangar -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null || true)"
unavail="$(kubectl -n starfleet get deployment hangar -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null || true)"
avail="$(kubectl -n starfleet get deployment hangar -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)"

if [ "$type" != "RollingUpdate" ]; then
  echo "FAIL: strategy type is '${type}', expected RollingUpdate"
  exit 1
fi
if [ "$surge" != "1" ]; then
  echo "FAIL: maxSurge is '${surge}', expected 1"
  exit 1
fi
if [ "$unavail" != "0" ] && [ "$unavail" != "0%" ]; then
  echo "FAIL: maxUnavailable is '${unavail}', expected 0"
  exit 1
fi
if [ "${avail:-0}" != "3" ]; then
  echo "FAIL: ${avail:-0} of 3 replicas are available"
  exit 1
fi
echo "PASS: hangar uses RollingUpdate (maxSurge 1, maxUnavailable 0) with 3 available replicas"
