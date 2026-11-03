#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl -n starfleet patch deployment hangar --type=merge -p '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'
kubectl -n starfleet rollout status deployment hangar --timeout=180s

kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: lookout
  namespace: starfleet
spec:
  selector:
    matchLabels:
      app: lookout
  template:
    metadata:
      labels:
        app: lookout
    spec:
      tolerations:
        - key: node-role.kubernetes.io/control-plane
          operator: Exists
          effect: NoSchedule
      containers:
        - name: lookout
          image: busybox:1.37.0
          command: ["sh", "-c", "sleep 3600"]
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nightly-scan
  namespace: starfleet
spec:
  schedule: "*/5 * * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 1
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: scan
              image: busybox:1.37.0
              command: ["sh", "-c", "date"]
---
apiVersion: batch/v1
kind: Job
metadata:
  name: one-shot
  namespace: starfleet
spec:
  completions: 2
  backoffLimit: 1
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: one-shot
          image: busybox:1.37.0
          command: ["sh", "-c", "echo one-shot done"]
YAML
kubectl -n starfleet rollout status daemonset/lookout --timeout=180s
kubectl -n starfleet wait --for=condition=Complete job/one-shot --timeout=180s
echo "[solution] Applied."
