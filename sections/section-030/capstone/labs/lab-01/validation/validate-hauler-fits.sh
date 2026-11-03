#!/usr/bin/env bash
# Check: hauler has 2 ready replicas, still requests CPU (no more than 500m) and keeps its image.
set -uo pipefail

image="$(kubectl -n starfleet get deployment hauler -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)"
if [ "$image" != "ghcr.io/stefanprodan/podinfo:6.15.0" ]; then
  echo "FAIL: hauler image is '${image}', expected ghcr.io/stefanprodan/podinfo:6.15.0"
  exit 1
fi
cpu="$(kubectl -n starfleet get deployment hauler -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null || true)"
if [ -z "$cpu" ]; then
  echo "FAIL: hauler has no CPU request; lower the request instead of removing it"
  exit 1
fi
case "$cpu" in
  *m) milli="${cpu%m}" ;;
  *) milli="$(awk -v v="$cpu" 'BEGIN { printf "%d", v * 1000 }')" ;;
esac
if [ "$milli" -gt 500 ] 2>/dev/null; then
  echo "FAIL: hauler requests ${cpu} CPU, expected at most 500m"
  exit 1
fi
replicas="$(kubectl -n starfleet get deployment hauler -o jsonpath='{.spec.replicas}' 2>/dev/null || true)"
ready="$(kubectl -n starfleet get deployment hauler -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
if [ "$replicas" != "2" ] || [ "${ready:-0}" != "2" ]; then
  echo "FAIL: hauler has spec.replicas=${replicas} and ${ready:-0} ready, expected 2 and 2"
  exit 1
fi
echo "PASS: hauler runs 2 ready replicas with a CPU request of ${cpu}"
