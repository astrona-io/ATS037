#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

NODES="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')"
NODE1="$(echo "$NODES" | grep -- '-worker$')"
NODE2="$(echo "$NODES" | grep -- '-worker2$')"

kubectl label nodes "$NODE1" disk=ssd
kubectl -n starfleet rollout status deployment dockyard --timeout=180s
kubectl taint nodes "$NODE2" dedicated=probe:NoSchedule

kubectl apply -f - <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: escort
  namespace: starfleet
spec:
  replicas: 2
  selector:
    matchLabels:
      app: escort
  template:
    metadata:
      labels:
        app: escort
    spec:
      tolerations:
        - key: dedicated
          operator: Equal
          value: probe
          effect: NoSchedule
      nodeSelector:
        kubernetes.io/hostname: "${NODE2}"
      containers:
        - name: escort
          image: ghcr.io/stefanprodan/podinfo:6.15.0
YAML
kubectl -n starfleet rollout status deployment escort --timeout=180s
echo "[solution] Applied."
