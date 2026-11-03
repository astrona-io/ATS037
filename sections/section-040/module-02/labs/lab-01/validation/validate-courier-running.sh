#!/usr/bin/env bash
# Check: Deployment courier uses podinfo:6.15.0 and has 1 ready replica.
set -uo pipefail

image="$(kubectl -n starfleet get deployment courier -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)"
if [ "$image" != "ghcr.io/stefanprodan/podinfo:6.15.0" ]; then
  echo "FAIL: courier image is '${image}', expected ghcr.io/stefanprodan/podinfo:6.15.0"
  exit 1
fi
ready="$(kubectl -n starfleet get deployment courier -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
if [ "${ready:-0}" != "1" ]; then
  echo "FAIL: courier has ${ready:-0} ready replicas, expected 1"
  exit 1
fi
echo "PASS: courier runs ${image}"
