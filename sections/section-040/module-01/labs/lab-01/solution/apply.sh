#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: inspector
  namespace: starfleet
spec:
  shareProcessNamespace: true
  containers:
    - name: app
      image: busybox:1.37.0
      command: ["sleep", "3600"]
    - name: tools
      image: busybox:1.37.0
      command: ["sleep", "3600"]
YAML
kubectl -n starfleet wait --for=condition=Ready pod/inspector --timeout=180s

kubectl -n starfleet patch deployment hog --type=json \
  -p '[{"op":"replace","path":"/spec/template/spec/containers/0/resources/limits/memory","value":"256Mi"}]'
kubectl -n starfleet rollout status deployment hog --timeout=180s

RUNTIME="$(kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.containerRuntimeVersion}')"
KERNEL="$(kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.kernelVersion}')"
kubectl -n starfleet create configmap runtime-facts \
  --from-literal=container-runtime="${RUNTIME%%://*}" \
  --from-literal=kernel-version="$KERNEL"
echo "[solution] Applied."
