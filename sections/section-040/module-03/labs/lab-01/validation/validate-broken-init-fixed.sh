#!/usr/bin/env bash
# Check: broken-init keeps its init container setup and its volume, and has 1 ready replica with a completed init container.
set -uo pipefail

name="$(kubectl -n starfleet get deployment broken-init -o jsonpath='{.spec.template.spec.initContainers[0].name}' 2>/dev/null || true)"
if [ "$name" != "setup" ]; then
  echo "FAIL: the init container setup was removed or renamed (found '${name}')"
  exit 1
fi
vol="$(kubectl -n starfleet get deployment broken-init -o jsonpath='{.spec.template.spec.volumes[?(@.name=="shared")].name}' 2>/dev/null || true)"
if [ "$vol" != "shared" ]; then
  echo "FAIL: the volume shared was removed"
  exit 1
fi
ready="$(kubectl -n starfleet get deployment broken-init -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
if [ "${ready:-0}" != "1" ]; then
  echo "FAIL: broken-init has ${ready:-0} ready replicas, expected 1"
  exit 1
fi
reason="$(kubectl -n starfleet get pods -l app=broken-init --field-selector=status.phase=Running -o jsonpath='{.items[0].status.initContainerStatuses[0].state.terminated.reason}' 2>/dev/null || true)"
if [ "$reason" != "Completed" ]; then
  echo "FAIL: init container setup finished with '${reason}', expected Completed"
  exit 1
fi
echo "PASS: broken-init runs and its init container completed"
