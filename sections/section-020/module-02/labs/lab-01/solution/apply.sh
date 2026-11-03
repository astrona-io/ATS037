#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl -n starfleet create configmap app-settings --from-literal=LOG_LEVEL=debug
kubectl -n starfleet create secret generic app-key --from-literal=token=orbit-7

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
      command: ["sh", "-c", "sleep 3600"]
      env:
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: app-settings
              key: LOG_LEVEL
      volumeMounts:
        - name: key
          mountPath: /etc/key
          readOnly: true
  volumes:
    - name: key
      secret:
        secretName: app-key
YAML
kubectl -n starfleet wait --for=condition=Ready pod/reader --timeout=120s

kubectl -n starfleet set resources deployment ballast --requests=cpu=50m,memory=64Mi --limits=memory=128Mi
kubectl -n starfleet rollout status deployment ballast --timeout=180s

kubectl -n outpost create quota outpost-budget --hard=pods=5,configmaps=10
echo "[solution] Applied."
