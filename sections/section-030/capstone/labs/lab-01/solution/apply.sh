#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

NODES="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')"
NODE1="$(echo "$NODES" | grep -- '-worker$')"
NODE2="$(echo "$NODES" | grep -- '-worker2$')"

kubectl label nodes "$NODE1" zone=east
kubectl -n starfleet rollout status deployment mess --timeout=180s

kubectl taint nodes "$NODE2" reserved=science:NoSchedule
kubectl apply -f - <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: lab-bench
  namespace: starfleet
spec:
  replicas: 2
  selector:
    matchLabels:
      app: lab-bench
  template:
    metadata:
      labels:
        app: lab-bench
    spec:
      tolerations:
        - key: reserved
          operator: Equal
          value: science
          effect: NoSchedule
      nodeSelector:
        kubernetes.io/hostname: "${NODE2}"
      containers:
        - name: lab-bench
          image: ghcr.io/stefanprodan/podinfo:6.15.0
YAML
kubectl -n starfleet rollout status deployment lab-bench --timeout=180s

kubectl -n starfleet create configmap placement-notes --from-literal=pending-reason="Insufficient cpu"

kubectl -n starfleet patch deployment hauler --type=json \
  -p '[{"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/cpu","value":"100m"}]'
kubectl -n starfleet rollout status deployment hauler --timeout=180s

kubectl apply -f - <<'YAML'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: hauler
  namespace: starfleet
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hauler
  minReplicas: 1
  maxReplicas: 4
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
YAML
echo "[solution] Applied."
