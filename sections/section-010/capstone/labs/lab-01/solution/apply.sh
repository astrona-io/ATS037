#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: relay
  namespace: starfleet
spec:
  replicas: 3
  selector:
    matchLabels:
      app: relay
  template:
    metadata:
      labels:
        app: relay
        tier: edge
    spec:
      containers:
        - name: relay
          image: ghcr.io/stefanprodan/podinfo:6.15.0
YAML
kubectl -n starfleet rollout status deployment relay --timeout=180s

OWNER="$(kubectl -n starfleet get pods -l app=relay -o jsonpath='{.items[0].metadata.ownerReferences[0].name}')"
kubectl -n starfleet create configmap cluster-notes --from-literal=owner-replicaset="$OWNER"

kubectl -n starfleet delete pod stalled --wait=true
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: stalled
  namespace: starfleet
  labels:
    app: stalled
spec:
  containers:
    - name: stalled
      image: ghcr.io/stefanprodan/podinfo:6.15.0
      ports:
        - containerPort: 9898
      readinessProbe:
        httpGet:
          path: /healthz
          port: 9898
        periodSeconds: 5
YAML
kubectl -n starfleet wait --for=condition=Ready pod/stalled --timeout=180s

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
      containers:
        - name: lookout
          image: busybox:1.37.0
          command: ["sleep", "3600"]
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nightly
  namespace: starfleet
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: nightly
              image: busybox:1.37.0
              command: ["echo", "nightly sweep"]
YAML
kubectl -n starfleet rollout status daemonset lookout --timeout=180s
echo "[solution] Applied."
