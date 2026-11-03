#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

pod_of() { kubectl -n kube-system get pod -l "component=$1" -o jsonpath='{.items[0].metadata.name}'; }

kubectl -n starfleet create configmap control-plane-map \
  --from-literal=api-server="$(pod_of kube-apiserver)" \
  --from-literal=etcd="$(pod_of etcd)" \
  --from-literal=scheduler="$(pod_of kube-scheduler)" \
  --from-literal=controller-manager="$(pod_of kube-controller-manager)"

kubectl -n starfleet scale deployment scout --replicas=3
kubectl -n starfleet rollout status deployment scout --timeout=180s

kubectl -n starfleet create configmap node-evidence \
  --from-literal=shuttle-node="$(kubectl -n starfleet get pod -l app=shuttle -o jsonpath='{.items[0].spec.nodeName}')"
echo "[solution] Applied."
