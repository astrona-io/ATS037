#!/usr/bin/env bash
# Check: Pod shipper has an init container tail with restartPolicy Always (native sidecar) and an app container; both running.
set -uo pipefail

policy="$(kubectl -n starfleet get pod shipper -o jsonpath='{.spec.initContainers[?(@.name=="tail")].restartPolicy}' 2>/dev/null || true)"
if [ -z "$(kubectl -n starfleet get pod shipper -o jsonpath='{.spec.initContainers[?(@.name=="tail")].name}' 2>/dev/null || true)" ]; then
  echo "FAIL: Pod shipper missing or has no init container named tail"
  exit 1
fi
if [ "$policy" != "Always" ]; then
  echo "FAIL: init container tail has restartPolicy '${policy}', a native sidecar needs Always"
  exit 1
fi
app="$(kubectl -n starfleet get pod shipper -o jsonpath='{.status.containerStatuses[?(@.name=="app")].state.running.startedAt}' 2>/dev/null || true)"
side="$(kubectl -n starfleet get pod shipper -o jsonpath='{.status.initContainerStatuses[?(@.name=="tail")].state.running.startedAt}' 2>/dev/null || true)"
if [ -z "$app" ]; then
  echo "FAIL: container app of shipper is not running"
  exit 1
fi
if [ -z "$side" ]; then
  echo "FAIL: sidecar tail of shipper is not running"
  exit 1
fi
echo "PASS: shipper runs a native sidecar and its application"
