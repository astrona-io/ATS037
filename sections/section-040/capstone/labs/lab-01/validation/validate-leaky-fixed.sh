#!/usr/bin/env bash
# Check: leaky keeps its image and a memory limit of at least 128Mi, and has 1 ready replica.
set -uo pipefail

image="$(kubectl -n starfleet get deployment leaky -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)"
if [ "$image" != "busybox:1.37.0" ]; then
  echo "FAIL: leaky image is '${image}', expected busybox:1.37.0"
  exit 1
fi
limit="$(kubectl -n starfleet get deployment leaky -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}' 2>/dev/null || true)"
if [ -z "$limit" ]; then
  echo "FAIL: leaky has no memory limit; raise the limit instead of removing it"
  exit 1
fi
bytes="$(awk -v v="$limit" 'BEGIN {
  n = v + 0
  if (v ~ /Ki$/) n *= 1024
  else if (v ~ /Mi$/) n *= 1048576
  else if (v ~ /Gi$/) n *= 1073741824
  else if (v ~ /M$/) n *= 1000000
  else if (v ~ /G$/) n *= 1000000000
  printf "%d", n }')"
if [ "$bytes" -lt 134217728 ]; then
  echo "FAIL: leaky memory limit is ${limit}, expected at least 128Mi"
  exit 1
fi
ready="$(kubectl -n starfleet get deployment leaky -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
if [ "${ready:-0}" != "1" ]; then
  echo "FAIL: leaky has ${ready:-0} ready replicas, expected 1"
  exit 1
fi
echo "PASS: leaky runs with a memory limit of ${limit}"
