#!/usr/bin/env bash
# Check: ConfigMap ship-settings has LOG_LEVEL=debug and Pod reader takes LOG_LEVEL from it and is Ready.
set -uo pipefail

value="$(kubectl -n starfleet get configmap ship-settings -o jsonpath='{.data.LOG_LEVEL}' 2>/dev/null || true)"
if [ "$value" != "debug" ]; then
  echo "FAIL: ship-settings key LOG_LEVEL is '${value}', expected debug"
  exit 1
fi
cm="$(kubectl -n starfleet get pod reader -o jsonpath='{.spec.containers[0].env[?(@.name=="LOG_LEVEL")].valueFrom.configMapKeyRef.name}' 2>/dev/null || true)"
key="$(kubectl -n starfleet get pod reader -o jsonpath='{.spec.containers[0].env[?(@.name=="LOG_LEVEL")].valueFrom.configMapKeyRef.key}' 2>/dev/null || true)"
if [ "$cm" != "ship-settings" ] || [ "$key" != "LOG_LEVEL" ]; then
  echo "FAIL: reader takes LOG_LEVEL from '${cm}' key '${key}', expected ship-settings key LOG_LEVEL"
  exit 1
fi
ready="$(kubectl -n starfleet get pod reader -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || true)"
if [ "$ready" != "True" ]; then
  echo "FAIL: Pod reader is not Ready"
  exit 1
fi
echo "PASS: reader takes LOG_LEVEL=debug from ship-settings"
