#!/usr/bin/env bash
# Check: beacon keeps both probes, uses the right path and port, and is available.
set -uo pipefail

get() { kubectl -n starfleet get deployment beacon -o jsonpath="$1" 2>/dev/null || true; }

live="$(get '{.spec.template.spec.containers[0].livenessProbe.httpGet.path}')"
ready_path="$(get '{.spec.template.spec.containers[0].readinessProbe.httpGet.path}')"
ready_port="$(get '{.spec.template.spec.containers[0].readinessProbe.httpGet.port}')"
if [ "$live" != "/healthz" ]; then
  echo "FAIL: liveness path is '${live}', expected /healthz (do not remove the probe)"
  exit 1
fi
if [ "$ready_path" != "/readyz" ] || { [ "$ready_port" != "http" ] && [ "$ready_port" != "9898" ]; }; then
  echo "FAIL: readiness probe is '${ready_path}' on port '${ready_port}', expected /readyz on the http port"
  exit 1
fi
available="$(get '{.status.availableReplicas}')"
if [ "${available:-0}" != "2" ]; then
  echo "FAIL: ${available:-0} of 2 replicas are available"
  exit 1
fi
echo "PASS: beacon probes are correct and 2 replicas are available"
