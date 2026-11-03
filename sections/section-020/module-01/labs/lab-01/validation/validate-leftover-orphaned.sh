#!/usr/bin/env bash
# Check: Deployment leftover is gone, but its ReplicaSet (now without owner) and Pods still exist.
set -uo pipefail

if kubectl -n starfleet get deployment leftover >/dev/null 2>&1; then
  echo "FAIL: Deployment leftover still exists"
  exit 1
fi
rs="$(kubectl -n starfleet get replicaset -l app=leftover -o name 2>/dev/null | wc -l | tr -d ' ')"
if [ "$rs" -lt 1 ]; then
  echo "FAIL: the ReplicaSet of leftover was deleted; use --cascade=orphan"
  exit 1
fi
owners="$(kubectl -n starfleet get replicaset -l app=leftover -o jsonpath='{range .items[*]}{.metadata.ownerReferences}{"\n"}{end}' 2>/dev/null | tr -d ' \n')"
if [ -n "$owners" ]; then
  echo "FAIL: the ReplicaSet still has an owner reference"
  exit 1
fi
pods="$(kubectl -n starfleet get pods -l app=leftover --field-selector=status.phase=Running -o name 2>/dev/null | wc -l | tr -d ' ')"
if [ "$pods" -lt 2 ]; then
  echo "FAIL: ${pods} of 2 leftover Pods are running"
  exit 1
fi
echo "PASS: leftover is deleted and ${pods} orphaned Pods keep running"
