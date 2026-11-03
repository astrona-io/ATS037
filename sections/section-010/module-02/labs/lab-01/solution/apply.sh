#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl -n starfleet patch service bridge -p '{"spec":{"selector":{"app":"bridge"}}}'
kubectl -n starfleet patch deployment bridge -p '{"spec":{"template":{"metadata":{"labels":{"tier":"frontend"}}}}}'
kubectl -n starfleet annotate deployment bridge contact=ops --overwrite
kubectl -n starfleet rollout status deployment bridge --timeout=180s
kubectl -n starfleet create configmap api-facts \
  --from-literal=pod-owner-kind=ReplicaSet \
  --from-literal=deployment-api-version=apps/v1 \
  --from-literal=nodes-namespaced=false
echo "[solution] Applied."
