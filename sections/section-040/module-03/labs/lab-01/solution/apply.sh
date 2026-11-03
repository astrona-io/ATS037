#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: builder
  namespace: starfleet
spec:
  volumes:
    - name: work
      emptyDir: {}
  initContainers:
    - name: prepare
      image: busybox:1.37.0
      command: ["sh", "-c", "echo mission=ready > /work/config.txt"]
      volumeMounts:
        - name: work
          mountPath: /work
  containers:
    - name: app
      image: busybox:1.37.0
      command: ["sh", "-c", "cat /work/config.txt; sleep 3600"]
      volumeMounts:
        - name: work
          mountPath: /work
---
apiVersion: v1
kind: Pod
metadata:
  name: shipper
  namespace: starfleet
spec:
  volumes:
    - name: logs
      emptyDir: {}
  initContainers:
    - name: tail
      image: busybox:1.37.0
      restartPolicy: Always
      command: ["sh", "-c", "touch /logs/app.log; tail -f /logs/app.log"]
      volumeMounts:
        - name: logs
          mountPath: /logs
  containers:
    - name: app
      image: busybox:1.37.0
      command: ["sh", "-c", "while true; do date >> /logs/app.log; sleep 5; done"]
      volumeMounts:
        - name: logs
          mountPath: /logs
YAML
kubectl -n starfleet wait --for=condition=Ready pod/builder pod/shipper --timeout=180s

kubectl -n starfleet patch deployment broken-init --type=json \
  -p '[{"op":"replace","path":"/spec/template/spec/initContainers/0/command","value":["sh","-c","echo ready > /shared/input.txt"]}]'
kubectl -n starfleet rollout status deployment broken-init --timeout=180s
echo "[solution] Applied."
