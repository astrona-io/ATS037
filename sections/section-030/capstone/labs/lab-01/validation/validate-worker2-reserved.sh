#!/usr/bin/env bash
# Check: the -worker2 node has the taint reserved=science:NoSchedule and no other node has a reserved taint.
set -uo pipefail

nodes="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null)"
node2="$(echo "$nodes" | grep -- '-worker2$' | head -n1)"
if [ -z "$node2" ]; then
  echo "FAIL: no node whose name ends in -worker2"
  exit 1
fi
value="$(kubectl get node "$node2" -o jsonpath='{.spec.taints[?(@.key=="reserved")].value}' 2>/dev/null || true)"
effect="$(kubectl get node "$node2" -o jsonpath='{.spec.taints[?(@.key=="reserved")].effect}' 2>/dev/null || true)"
if [ "$value" != "science" ] || [ "$effect" != "NoSchedule" ]; then
  echo "FAIL: ${node2} has taint value '${value}' effect '${effect}', expected reserved=science:NoSchedule"
  exit 1
fi
others="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.spec.taints[?(@.key=="reserved")].key}{"\n"}{end}' 2>/dev/null | grep -v "^${node2} " | grep -c ' reserved' || true)"
if [ "$others" != "0" ]; then
  echo "FAIL: another node also has the reserved taint"
  exit 1
fi
echo "PASS: ${node2} carries reserved=science:NoSchedule"
