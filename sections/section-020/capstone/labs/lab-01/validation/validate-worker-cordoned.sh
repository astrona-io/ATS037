#!/usr/bin/env bash
# Check: the worker node is cordoned, the control plane node is not, and caravan still has 3 ready replicas.
set -uo pipefail

worker="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
if [ -z "$worker" ]; then
  echo "FAIL: no worker node found"
  exit 1
fi
unsched="$(kubectl get node "$worker" -o jsonpath='{.spec.unschedulable}' 2>/dev/null || true)"
if [ "$unsched" != "true" ]; then
  echo "FAIL: node ${worker} is not cordoned"
  exit 1
fi
cp_unsched="$(kubectl get nodes -l node-role.kubernetes.io/control-plane -o jsonpath='{.items[0].spec.unschedulable}' 2>/dev/null || true)"
if [ "$cp_unsched" = "true" ]; then
  echo "FAIL: the control plane node was cordoned as well"
  exit 1
fi
ready="$(kubectl -n starfleet get deployment caravan -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
if [ "${ready:-0}" != "3" ]; then
  echo "FAIL: caravan has ${ready:-0} ready replicas, expected 3 (do not delete Pods)"
  exit 1
fi
echo "PASS: ${worker} is cordoned and caravan keeps 3 ready replicas"
