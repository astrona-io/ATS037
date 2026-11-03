#!/usr/bin/env bash
# Check: dockyard is unchanged, its Pods run, and they run on the -worker node that carries disk=ssd (only that node).
set -uo pipefail

sel="$(kubectl -n starfleet get deployment dockyard -o jsonpath='{.spec.template.spec.nodeSelector.disk}' 2>/dev/null || true)"
if [ "$sel" != "ssd" ]; then
  echo "FAIL: the Deployment node selector was changed or removed; fix the cluster, not the Deployment"
  exit 1
fi
labeled="$(kubectl get nodes -l disk=ssd -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null)"
count="$(echo "$labeled" | grep -c . || true)"
if [ "$count" != "1" ] || ! echo "$labeled" | grep -q -- '-worker$'; then
  echo "FAIL: exactly the node whose name ends in -worker must have disk=ssd (found: $(echo "$labeled" | tr '\n' ' '))"
  exit 1
fi
node="$(echo "$labeled" | head -n1)"
nodes="$(kubectl -n starfleet get pods -l app=dockyard --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' 2>/dev/null)"
running="$(echo "$nodes" | grep -c . || true)"
if [ "$running" != "2" ]; then
  echo "FAIL: ${running} of 2 dockyard Pods are running"
  exit 1
fi
if echo "$nodes" | grep -qv "^${node}$"; then
  echo "FAIL: a dockyard Pod runs on a node other than ${node}"
  exit 1
fi
echo "PASS: both dockyard Pods run on ${node}"
