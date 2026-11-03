#!/usr/bin/env bash
# Check: lab-bench has 2 running replicas that tolerate the reserved taint and run only on the -worker2 node.
set -uo pipefail

node2="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null | grep -- '-worker2$' | head -n1)"
key="$(kubectl -n starfleet get deployment lab-bench -o jsonpath='{.spec.template.spec.tolerations[?(@.key=="reserved")].key}' 2>/dev/null || true)"
if [ "$key" != "reserved" ]; then
  echo "FAIL: the lab-bench Pod template has no toleration for the key reserved"
  exit 1
fi
nodes="$(kubectl -n starfleet get pods -l app=lab-bench --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' 2>/dev/null)"
running="$(echo "$nodes" | grep -c . || true)"
if [ "$running" != "2" ]; then
  echo "FAIL: ${running} of 2 lab-bench Pods are running"
  exit 1
fi
if echo "$nodes" | grep -qv "^${node2}$"; then
  echo "FAIL: a lab-bench Pod runs on a node other than ${node2}"
  exit 1
fi
echo "PASS: both lab-bench Pods run on ${node2}"
