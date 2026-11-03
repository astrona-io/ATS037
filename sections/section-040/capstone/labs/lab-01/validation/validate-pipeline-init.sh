#!/usr/bin/env bash
# Check: Pod pipeline has a finished init container generate, and worker printed mode=night from the shared volume.
set -uo pipefail

name="$(kubectl -n starfleet get pod pipeline -o jsonpath='{.spec.initContainers[?(@.name=="generate")].name}' 2>/dev/null || true)"
if [ "$name" != "generate" ]; then
  echo "FAIL: Pod pipeline is missing or has no init container named generate"
  exit 1
fi
policy="$(kubectl -n starfleet get pod pipeline -o jsonpath='{.spec.initContainers[?(@.name=="generate")].restartPolicy}' 2>/dev/null || true)"
if [ -n "$policy" ]; then
  echo "FAIL: generate must be a normal init container that runs to completion, found restartPolicy '${policy}'"
  exit 1
fi
reason="$(kubectl -n starfleet get pod pipeline -o jsonpath='{.status.initContainerStatuses[?(@.name=="generate")].state.terminated.reason}' 2>/dev/null || true)"
if [ "$reason" != "Completed" ]; then
  echo "FAIL: init container generate has not completed (reason '${reason}')"
  exit 1
fi
out="$(kubectl -n starfleet logs pipeline -c worker 2>/dev/null || true)"
if ! echo "$out" | grep -q '^mode=night$'; then
  echo "FAIL: the worker log does not contain the line mode=night"
  exit 1
fi
echo "PASS: generate completed and worker read mode=night from the shared volume"
