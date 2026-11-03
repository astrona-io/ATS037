#!/usr/bin/env bash
# Check: engine-room has cpu request 50m, memory request 32Mi, memory limit 128Mi and 1 ready replica.
set -uo pipefail

get() { kubectl -n starfleet get deployment engine-room -o jsonpath="$1" 2>/dev/null || true; }
cpu="$(get '{.spec.template.spec.containers[0].resources.requests.cpu}')"
mem="$(get '{.spec.template.spec.containers[0].resources.requests.memory}')"
lim="$(get '{.spec.template.spec.containers[0].resources.limits.memory}')"
if [ "$cpu" != "50m" ] || [ "$mem" != "32Mi" ] || [ "$lim" != "128Mi" ]; then
  echo "FAIL: cpu request '${cpu}', memory request '${mem}', memory limit '${lim}'; expected 50m, 32Mi and 128Mi"
  exit 1
fi
ready="$(get '{.status.readyReplicas}')"
if [ "${ready:-0}" != "1" ]; then
  echo "FAIL: engine-room has ${ready:-0} ready replicas, expected 1"
  exit 1
fi
echo "PASS: engine-room has the requested resources and runs"
