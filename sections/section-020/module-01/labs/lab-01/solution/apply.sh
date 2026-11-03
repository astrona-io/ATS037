#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl -n starfleet create configmap evidence \
  --from-literal=context="$(kubectl config current-context)" \
  --from-literal=reason=ImagePullBackOff \
  --from-literal=image=ghcr.io/stefanprodan/podinfo:6.15.99

kubectl -n starfleet set image deployment/console console=ghcr.io/stefanprodan/podinfo:6.15.0
kubectl -n starfleet rollout status deployment console --timeout=180s

kubectl -n starfleet delete deployment leftover --cascade=orphan
echo "[solution] Applied."
