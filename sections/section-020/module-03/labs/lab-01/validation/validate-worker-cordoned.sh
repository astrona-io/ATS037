#!/usr/bin/env bash
# Check: the worker node is unschedulable, the control plane node is not, and the worker Pods still run.
set -uo pipefail

worker="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
if [ -z "$worker" ]; then
  echo "FAIL: no worker node found"
  exit 1
fi
w="$(kubectl get node "$worker" -o jsonpath='{.spec.unschedulable}' 2>/dev/null || true)"
if [ "$w" != "true" ]; then
  echo "FAIL: node ${worker} is still schedulable"
  exit 1
fi
cp="$(kubectl get nodes -l 'node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.unschedulable}' 2>/dev/null || true)"
if [ "$cp" = "true" ]; then
  echo "FAIL: the control plane node was cordoned too"
  exit 1
fi
running="$(kubectl get pods -A --field-selector "spec.nodeName=${worker},status.phase=Running" -o name 2>/dev/null | wc -l | tr -d ' ')"
if [ "$running" -lt 1 ]; then
  echo "FAIL: no Pods run on ${worker}; the node was drained instead of cordoned"
  exit 1
fi
echo "PASS: ${worker} is cordoned and ${running} Pods keep running on it"
