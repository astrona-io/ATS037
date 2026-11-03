#!/usr/bin/env bash
# Check: ConfigMap capacity-notes holds the scheduling failure reason and the live allocatable CPU of the node.
set -uo pipefail

reason="$(kubectl -n starfleet get configmap capacity-notes -o jsonpath='{.data.reason}' 2>/dev/null || true)"
if [ "$reason" != "Insufficient cpu" ]; then
  echo "FAIL: capacity-notes key reason is '${reason}', expected 'Insufficient cpu' (read the FailedScheduling event)"
  exit 1
fi
want="$(kubectl get nodes -o jsonpath='{.items[0].status.allocatable.cpu}' 2>/dev/null || true)"
have="$(kubectl -n starfleet get configmap capacity-notes -o jsonpath='{.data.allocatable-cpu}' 2>/dev/null || true)"
if [ -z "$want" ] || [ "$have" != "$want" ]; then
  echo "FAIL: capacity-notes key allocatable-cpu is '${have}', the node reports '${want}'"
  exit 1
fi
echo "PASS: capacity-notes records '${reason}' and allocatable CPU ${want}"
