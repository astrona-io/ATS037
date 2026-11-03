#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl -n starfleet set resources deployment leaky --limits=memory=256Mi
kubectl -n starfleet rollout status deployment leaky --timeout=180s

kubectl -n starfleet set image deployment/fetcher fetcher=ghcr.io/stefanprodan/podinfo:6.15.0
kubectl -n starfleet rollout status deployment fetcher --timeout=180s

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: pipeline
  namespace: starfleet
spec:
  volumes:
    - name: work
      emptyDir: {}
  initContainers:
    - name: generate
      image: busybox:1.37.0
      command: ["sh", "-c", "echo mode=night > /work/settings.txt"]
      volumeMounts:
        - name: work
          mountPath: /work
    - name: watcher
      image: busybox:1.37.0
      restartPolicy: Always
      command: ["sh", "-c", "touch /work/events.log; tail -f /work/events.log"]
      volumeMounts:
        - name: work
          mountPath: /work
  containers:
    - name: worker
      image: busybox:1.37.0
      command: ["sh", "-c", "cat /work/settings.txt; while true; do date >> /work/events.log; sleep 5; done"]
      volumeMounts:
        - name: work
          mountPath: /work
YAML
kubectl -n starfleet wait --for=condition=Ready pod/pipeline --timeout=180s

FULL="$(kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.containerRuntimeVersion}')"
ID="$(kubectl -n starfleet get pods -l app=fetcher --field-selector=status.phase=Running -o jsonpath='{.items[0].status.containerStatuses[0].imageID}')"
ID="${ID#docker-pullable://}"
kubectl -n starfleet create configmap container-notes \
  --from-literal=container-runtime="${FULL%%://*}" \
  --from-literal=fetcher-digest="${ID##*@}"
echo "[solution] Applied."
