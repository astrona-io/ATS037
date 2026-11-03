#!/usr/bin/env bash
# Check: Pod reader is ready, takes LOG_LEVEL from the ConfigMap and mounts the Secret at /etc/key.
set -uo pipefail

ready="$(kubectl -n starfleet get pod reader -o jsonpath='{.status.containerStatuses[0].ready}' 2>/dev/null || true)"
if [ "$ready" != "true" ]; then
  echo "FAIL: Pod reader is not ready"
  exit 1
fi
ref="$(kubectl -n starfleet get pod reader -o jsonpath='{.spec.containers[0].env[?(@.name=="LOG_LEVEL")].valueFrom.configMapKeyRef.name}' 2>/dev/null || true)"
if [ "$ref" != "app-settings" ]; then
  echo "FAIL: LOG_LEVEL is not taken from the ConfigMap app-settings with configMapKeyRef"
  exit 1
fi
secret="$(kubectl -n starfleet get pod reader -o jsonpath='{.spec.volumes[*].secret.secretName}' 2>/dev/null || true)"
if [ "$secret" != "app-key" ]; then
  echo "FAIL: the Pod does not mount the Secret app-key as a volume"
  exit 1
fi
level="$(kubectl -n starfleet exec reader -- printenv LOG_LEVEL 2>/dev/null || true)"
token="$(kubectl -n starfleet exec reader -- cat /etc/key/token 2>/dev/null || true)"
if [ "$level" != "debug" ]; then
  echo "FAIL: LOG_LEVEL inside the container is '${level}', expected debug"
  exit 1
fi
if [ "$token" != "orbit-7" ]; then
  echo "FAIL: /etc/key/token inside the container is '${token}', expected orbit-7"
  exit 1
fi
echo "PASS: reader gets LOG_LEVEL from the ConfigMap and the token file from the Secret"
