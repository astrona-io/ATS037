#!/usr/bin/env bash
# Check: the -worker2 node has the taint dedicated=probe:NoSchedule and no other node has it.
set -uo pipefail

nodes="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null)"
node2="$(echo "$nodes" | grep -- '-worker2$' | head -n1)"
if [ -z "$node2" ]; then
  echo "FAIL: no node whose name ends in -worker2"
  exit 1
fi
effect="$(kubectl get node "$node2" -o jsonpath='{.spec.taints[?(@.key=="dedicated")].effect}' 2>/dev/null || true)"
value="$(kubectl get node "$node2" -o jsonpath='{.spec.taints[?(@.key=="dedicated")].value}' 2>/dev/null || true)"
if [ "$value" != "probe" ] || [ "$effect" != "NoSchedule" ]; then
  echo "FAIL: ${node2} has taint value '${value}' effect '${effect}', expected dedicated=probe:NoSchedule"
  exit 1
fi
others="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.spec.taints[?(@.key=="dedicated")].key}{"\n"}{end}' 2>/dev/null | grep -v "^${node2} " | grep -c ' dedicated' || true)"
if [ "$others" != "0" ]; then
  echo "FAIL: another node also has the dedicated taint"
  exit 1
fi
echo "PASS: ${node2} carries dedicated=probe:NoSchedule"
