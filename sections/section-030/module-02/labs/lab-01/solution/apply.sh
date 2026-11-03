#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

NODE="$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')"
CPU="$(kubectl get node "$NODE" -o jsonpath='{.status.allocatable.cpu}')"

kubectl -n starfleet patch deployment cargo --type=json \
  -p '[{"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/cpu","value":"100m"}]'
kubectl -n starfleet scale deployment cargo --replicas=3
kubectl -n starfleet rollout status deployment cargo --timeout=180s

kubectl -n starfleet create configmap capacity-notes \
  --from-literal=reason="Insufficient cpu" \
  --from-literal=allocatable-cpu="$CPU"

kubectl apply -f - <<YAML
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: engine
  namespace: starfleet
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: engine
  minReplicas: 2
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
YAML
echo "[solution] Applied."
