#!/usr/bin/env bash
# Check: Pod stalled is Ready, keeps its image and a readiness probe, and the probe path is /healthz.
set -uo pipefail

image="$(kubectl -n starfleet get pod stalled -o jsonpath='{.spec.containers[0].image}' 2>/dev/null || true)"
if [ "$image" != "ghcr.io/stefanprodan/podinfo:6.15.0" ]; then
  echo "FAIL: Pod stalled missing or image is '${image}'"
  exit 1
fi
path="$(kubectl -n starfleet get pod stalled -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null || true)"
if [ -z "$path" ]; then
  echo "FAIL: the readiness probe was removed; fix its path instead"
  exit 1
fi
if [ "$path" != "/healthz" ]; then
  echo "FAIL: the readiness probe path is '${path}', expected /healthz"
  exit 1
fi
ready="$(kubectl -n starfleet get pod stalled -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || true)"
if [ "$ready" != "True" ]; then
  echo "FAIL: Pod stalled is not Ready (condition: '${ready}')"
  exit 1
fi
echo "PASS: stalled is Ready with the probe on /healthz"
