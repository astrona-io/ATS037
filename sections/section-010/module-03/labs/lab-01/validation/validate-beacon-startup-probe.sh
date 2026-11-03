#!/usr/bin/env bash
# Check: a startup probe on /healthz that tolerates at least 10 failures.
set -uo pipefail

path="$(kubectl -n starfleet get deployment beacon -o jsonpath='{.spec.template.spec.containers[0].startupProbe.httpGet.path}' 2>/dev/null || true)"
threshold="$(kubectl -n starfleet get deployment beacon -o jsonpath='{.spec.template.spec.containers[0].startupProbe.failureThreshold}' 2>/dev/null || true)"
if [ "$path" != "/healthz" ]; then
  echo "FAIL: startupProbe httpGet path is '${path}', expected /healthz"
  exit 1
fi
if [ "${threshold:-0}" -lt 10 ]; then
  echo "FAIL: startupProbe failureThreshold is '${threshold:-unset}', expected at least 10"
  exit 1
fi
echo "PASS: startup probe on /healthz with failureThreshold ${threshold}"
