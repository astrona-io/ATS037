#!/usr/bin/env bash
# Check: console uses the podinfo 6.15.0 image and its replica is available.
set -uo pipefail

image="$(kubectl -n starfleet get deployment console -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)"
avail="$(kubectl -n starfleet get deployment console -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)"

if [ "$image" != "ghcr.io/stefanprodan/podinfo:6.15.0" ]; then
  echo "FAIL: console image is '${image}', expected ghcr.io/stefanprodan/podinfo:6.15.0"
  exit 1
fi
if [ "${avail:-0}" != "1" ]; then
  echo "FAIL: console has ${avail:-0} of 1 replicas available"
  exit 1
fi
echo "PASS: console runs ${image}"
