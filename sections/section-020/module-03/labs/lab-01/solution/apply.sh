#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl apply -f - <<'YAML'
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: convoy-budget
  namespace: starfleet
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: convoy
---
apiVersion: starfleet.example.com/v1
kind: Mission
metadata:
  name: survey-run
  namespace: starfleet
spec:
  objective: map the nebula
  crewSize: 4
YAML

kubectl cordon "$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')"
echo "[solution] Applied."
