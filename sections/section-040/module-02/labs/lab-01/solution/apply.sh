#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl -n starfleet set image deployment/courier courier=ghcr.io/stefanprodan/podinfo:6.15.0
kubectl -n starfleet rollout status deployment courier --timeout=180s

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: cached
  namespace: starfleet
spec:
  containers:
    - name: cached
      image: busybox:1.37.0
      imagePullPolicy: IfNotPresent
      command: ["sleep", "3600"]
YAML
kubectl -n starfleet wait --for=condition=Ready pod/cached --timeout=180s

ID="$(kubectl -n starfleet get pods -l app=courier --field-selector=status.phase=Running -o jsonpath='{.items[0].status.containerStatuses[0].imageID}')"
ID="${ID#docker-pullable://}"
kubectl -n starfleet create configmap image-facts \
  --from-literal=repository=ghcr.io/stefanprodan/podinfo \
  --from-literal=digest="${ID##*@}"
echo "[solution] Applied."
