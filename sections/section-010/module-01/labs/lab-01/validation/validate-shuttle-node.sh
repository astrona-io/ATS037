#!/usr/bin/env bash
# Check: node-evidence records the node that runs shuttle.
set -uo pipefail

expected="$(kubectl -n starfleet get pod -l app=shuttle -o jsonpath='{.items[0].spec.nodeName}' 2>/dev/null || true)"
actual="$(kubectl -n starfleet get configmap node-evidence -o jsonpath='{.data.shuttle-node}' 2>/dev/null || true)"
if [ -z "$expected" ]; then
  echo "FAIL: the shuttle Pod has no node"
  exit 1
fi
if [ "$actual" != "$expected" ]; then
  echo "FAIL: shuttle-node is '${actual}', expected '${expected}'"
  exit 1
fi
echo "PASS: node-evidence records ${expected}"
