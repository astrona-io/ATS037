#!/usr/bin/env bash
# Check: mess is unchanged and both Pods run on the -worker node, the only node with zone=east.
set -uo pipefail

sel="$(kubectl -n starfleet get deployment mess -o jsonpath='{.spec.template.spec.nodeSelector.zone}' 2>/dev/null || true)"
if [ "$sel" != "east" ]; then
  echo "FAIL: the Deployment node selector was changed or removed; fix the cluster, not the Deployment"
  exit 1
fi
labeled="$(kubectl get nodes -l zone=east -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null)"
count="$(echo "$labeled" | grep -c . || true)"
if [ "$count" != "1" ] || ! echo "$labeled" | grep -q -- '-worker$'; then
  echo "FAIL: exactly the node whose name ends in -worker must have zone=east (found: $(echo "$labeled" | tr '\n' ' '))"
  exit 1
fi
node="$(echo "$labeled" | head -n1)"
nodes="$(kubectl -n starfleet get pods -l app=mess --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' 2>/dev/null)"
running="$(echo "$nodes" | grep -c . || true)"
if [ "$running" != "2" ]; then
  echo "FAIL: ${running} of 2 mess Pods are running"
  exit 1
fi
if echo "$nodes" | grep -qv "^${node}$"; then
  echo "FAIL: a mess Pod runs on a node other than ${node}"
  exit 1
fi
echo "PASS: both mess Pods run on ${node}"
