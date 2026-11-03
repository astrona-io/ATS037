#!/usr/bin/env bash
# Check: escort has 2 running replicas, tolerates the dedicated taint, and every Pod runs on the -worker2 node.
set -uo pipefail

node2="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null | grep -- '-worker2$' | head -n1)"
key="$(kubectl -n starfleet get deployment escort -o jsonpath='{.spec.template.spec.tolerations[?(@.key=="dedicated")].key}' 2>/dev/null || true)"
if [ "$key" != "dedicated" ]; then
  echo "FAIL: the escort Pod template has no toleration for the key dedicated"
  exit 1
fi
nodes="$(kubectl -n starfleet get pods -l app=escort --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' 2>/dev/null)"
running="$(echo "$nodes" | grep -c . || true)"
if [ "$running" != "2" ]; then
  echo "FAIL: ${running} of 2 escort Pods are running"
  exit 1
fi
if echo "$nodes" | grep -qv "^${node2}$"; then
  echo "FAIL: an escort Pod runs on a node other than ${node2}"
  exit 1
fi
echo "PASS: both escort Pods run on ${node2}"
