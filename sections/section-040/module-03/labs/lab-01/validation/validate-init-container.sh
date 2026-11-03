#!/usr/bin/env bash
# Check: Pod builder has an init container prepare and a container app sharing an emptyDir; app logs mission=ready; both finished/running.
set -uo pipefail

init="$(kubectl -n starfleet get pod builder -o jsonpath='{.spec.initContainers[?(@.name=="prepare")].image}' 2>/dev/null || true)"
if [ -z "$init" ]; then
  echo "FAIL: Pod builder missing or has no init container named prepare"
  exit 1
fi
vol="$(kubectl -n starfleet get pod builder -o jsonpath='{range .spec.volumes[*]}{.emptyDir}{"\n"}{end}' 2>/dev/null | grep -c . || true)"
if [ "$vol" -lt 1 ]; then
  echo "FAIL: builder has no emptyDir volume"
  exit 1
fi
reason="$(kubectl -n starfleet get pod builder -o jsonpath='{.status.initContainerStatuses[?(@.name=="prepare")].state.terminated.reason}' 2>/dev/null || true)"
if [ "$reason" != "Completed" ]; then
  echo "FAIL: init container prepare finished with '${reason}', expected Completed"
  exit 1
fi
if ! kubectl -n starfleet logs builder -c app 2>/dev/null | grep -q 'mission=ready'; then
  echo "FAIL: the log of container app does not contain mission=ready"
  exit 1
fi
phase="$(kubectl -n starfleet get pod builder -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [ "$phase" != "Running" ]; then
  echo "FAIL: Pod builder is ${phase}, expected Running"
  exit 1
fi
echo "PASS: builder ran its init container and app printed mission=ready"
