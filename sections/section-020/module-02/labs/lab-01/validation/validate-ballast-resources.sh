#!/usr/bin/env bash
# Check: ballast has the required requests and memory limit and both replicas are available.
set -uo pipefail

get() { kubectl -n starfleet get deployment ballast -o jsonpath="$1" 2>/dev/null || true; }

cpu="$(get '{.spec.template.spec.containers[0].resources.requests.cpu}')"
mem="$(get '{.spec.template.spec.containers[0].resources.requests.memory}')"
lim="$(get '{.spec.template.spec.containers[0].resources.limits.memory}')"
avail="$(get '{.status.availableReplicas}')"

if [ "$cpu" != "50m" ]; then
  echo "FAIL: CPU request is '${cpu}', expected 50m"
  exit 1
fi
if [ "$mem" != "64Mi" ]; then
  echo "FAIL: memory request is '${mem}', expected 64Mi"
  exit 1
fi
if [ "$lim" != "128Mi" ]; then
  echo "FAIL: memory limit is '${lim}', expected 128Mi"
  exit 1
fi
if [ "${avail:-0}" != "2" ]; then
  echo "FAIL: ${avail:-0} of 2 replicas are available"
  exit 1
fi
echo "PASS: ballast has requests 50m/64Mi and a 128Mi memory limit with 2 available replicas"
