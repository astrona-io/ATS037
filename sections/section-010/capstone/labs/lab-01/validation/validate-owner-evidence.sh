#!/usr/bin/env bash
# Check: ConfigMap cluster-notes key owner-replicaset equals the ReplicaSet that owns the relay Pods.
set -uo pipefail

want="$(kubectl -n starfleet get pods -l app=relay -o jsonpath='{.items[0].metadata.ownerReferences[0].name}' 2>/dev/null || true)"
kind="$(kubectl -n starfleet get pods -l app=relay -o jsonpath='{.items[0].metadata.ownerReferences[0].kind}' 2>/dev/null || true)"
have="$(kubectl -n starfleet get configmap cluster-notes -o jsonpath='{.data.owner-replicaset}' 2>/dev/null || true)"
if [ -z "$want" ] || [ "$kind" != "ReplicaSet" ]; then
  echo "FAIL: no relay Pod owned by a ReplicaSet found yet"
  exit 1
fi
if [ "$have" != "$want" ]; then
  echo "FAIL: cluster-notes key owner-replicaset is '${have}', the relay Pods are owned by '${want}'"
  exit 1
fi
echo "PASS: cluster-notes names the owner ${want}"
