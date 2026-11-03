#!/usr/bin/env bash
# Check: the Deployment (not a Pod or ReplicaSet) asks for 3 replicas and 3 are ready.
set -uo pipefail

desired="$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.replicas}' 2>/dev/null || true)"
ready="$(kubectl -n starfleet get deployment scout -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
if [ "$desired" != "3" ]; then
  echo "FAIL: deployment scout has spec.replicas '${desired}', expected 3"
  exit 1
fi
if [ "${ready:-0}" != "3" ]; then
  echo "FAIL: deployment scout has '${ready:-0}' ready replicas, expected 3"
  exit 1
fi
echo "PASS: deployment scout asks for 3 replicas and 3 are ready"
