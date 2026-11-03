#!/usr/bin/env bash
# Check: ConfigMap app-settings and Secret app-key hold the required values.
set -uo pipefail

level="$(kubectl -n starfleet get configmap app-settings -o jsonpath='{.data.LOG_LEVEL}' 2>/dev/null || true)"
token="$(kubectl -n starfleet get secret app-key -o jsonpath='{.data.token}' 2>/dev/null | base64 -d 2>/dev/null || true)"

if [ "$level" != "debug" ]; then
  echo "FAIL: ConfigMap app-settings key LOG_LEVEL is '${level}', expected debug"
  exit 1
fi
if [ "$token" != "orbit-7" ]; then
  echo "FAIL: Secret app-key key token is '${token}', expected orbit-7"
  exit 1
fi
echo "PASS: app-settings and app-key hold the required values"
