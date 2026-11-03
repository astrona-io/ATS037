#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl -n starfleet set image deployment/uplink uplink=ghcr.io/stefanprodan/podinfo:6.15.0
kubectl -n starfleet rollout status deployment uplink --timeout=180s

kubectl -n starfleet create configmap ship-settings --from-literal=LOG_LEVEL=debug
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: reader
  namespace: starfleet
spec:
  containers:
    - name: reader
      image: busybox:1.37.0
      command: ["sleep", "3600"]
      env:
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: ship-settings
              key: LOG_LEVEL
YAML
kubectl -n starfleet wait --for=condition=Ready pod/reader --timeout=180s

kubectl -n starfleet patch deployment engine-room --type=json -p '[{"op":"add","path":"/spec/template/spec/containers/0/resources","value":{"requests":{"cpu":"50m","memory":"32Mi"},"limits":{"memory":"128Mi"}}}]'
kubectl -n starfleet rollout status deployment engine-room --timeout=180s

kubectl -n outpost create quota outpost-budget --hard=pods=4

kubectl apply -f - <<'YAML'
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: caravan
  namespace: starfleet
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: caravan
YAML

NODE="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')"
kubectl cordon "$NODE"
echo "[solution] Applied."
