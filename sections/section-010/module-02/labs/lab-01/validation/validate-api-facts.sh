#!/usr/bin/env bash
# Check: the ConfigMap holds the facts the API reports.
set -uo pipefail

fail=0
expect() {
  local key="$1" want="$2" got
  got="$(kubectl -n starfleet get configmap api-facts -o jsonpath="{.data.${key//./\\.}}" 2>/dev/null || true)"
  if [ "$got" != "$want" ]; then
    echo "FAIL: ${key} is '${got}', expected '${want}'"
    fail=1
  fi
}
owner="$(kubectl -n starfleet get pod -l app=bridge -o jsonpath='{.items[0].metadata.ownerReferences[0].kind}' 2>/dev/null || true)"
namespaced="$(kubectl api-resources --namespaced=false -o name 2>/dev/null | grep -qx nodes && echo false || echo true)"
expect pod-owner-kind "${owner:-ReplicaSet}"
expect deployment-api-version "apps/v1"
expect nodes-namespaced "$namespaced"
if [ "$fail" -ne 0 ]; then exit 1; fi
echo "PASS: api-facts is correct"
