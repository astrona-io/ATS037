#!/usr/bin/env bash
# Check: Deployment relay has 3 ready replicas, Pod labels app=relay and tier=edge, and the right image.
set -uo pipefail

image="$(kubectl -n starfleet get deployment relay -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)"
if [ "$image" != "ghcr.io/stefanprodan/podinfo:6.15.0" ]; then
  echo "FAIL: Deployment relay missing or image is '${image}'"
  exit 1
fi
app="$(kubectl -n starfleet get deployment relay -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null || true)"
tier="$(kubectl -n starfleet get deployment relay -o jsonpath='{.spec.template.metadata.labels.tier}' 2>/dev/null || true)"
if [ "$app" != "relay" ] || [ "$tier" != "edge" ]; then
  echo "FAIL: Pod template labels are app='${app}' tier='${tier}', expected app=relay tier=edge"
  exit 1
fi
ready="$(kubectl -n starfleet get deployment relay -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
want="$(kubectl -n starfleet get deployment relay -o jsonpath='{.spec.replicas}' 2>/dev/null || true)"
if [ "$want" != "3" ] || [ "${ready:-0}" != "3" ]; then
  echo "FAIL: relay has spec.replicas=${want} and ${ready:-0} ready, expected 3 and 3"
  exit 1
fi
echo "PASS: relay runs 3 ready replicas with the labels app=relay and tier=edge"
