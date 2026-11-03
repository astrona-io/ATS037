#!/usr/bin/env bash
# Starting state. Environment only: it creates the workloads and the faults.
# It never creates the objects the learner must write.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for file in "$DIR"/manifests/*.yaml; do
  kubectl apply -f "$file"
done

for name in scout probe shuttle; do
  kubectl -n starfleet rollout status "deployment/$name" --timeout=180s
done
kubectl -n outpost rollout status deployment/drifter --timeout=180s
echo "[lab] Ready."
