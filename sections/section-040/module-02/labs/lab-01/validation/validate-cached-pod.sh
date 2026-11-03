#!/usr/bin/env bash
# Check: Pod cached runs busybox:1.37.0 with imagePullPolicy IfNotPresent set explicitly and is running.
set -uo pipefail

policy="$(kubectl -n starfleet get pod cached -o jsonpath='{.spec.containers[?(@.name=="cached")].imagePullPolicy}' 2>/dev/null || true)"
image="$(kubectl -n starfleet get pod cached -o jsonpath='{.spec.containers[?(@.name=="cached")].image}' 2>/dev/null || true)"
if [ -z "$image" ]; then
  echo "FAIL: no Pod cached with a container named cached in starfleet"
  exit 1
fi
if [ "$image" != "busybox:1.37.0" ]; then
  echo "FAIL: cached image is '${image}', expected busybox:1.37.0"
  exit 1
fi
if [ "$policy" != "IfNotPresent" ]; then
  echo "FAIL: imagePullPolicy is '${policy}', expected IfNotPresent"
  exit 1
fi
phase="$(kubectl -n starfleet get pod cached -o jsonpath='{.status.phase}' 2>/dev/null || true)"
if [ "$phase" != "Running" ]; then
  echo "FAIL: Pod cached is ${phase}, expected Running"
  exit 1
fi
echo "PASS: cached runs busybox:1.37.0 with IfNotPresent"
