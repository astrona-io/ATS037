#!/usr/bin/env bash
# Starting state. Environment only: it creates the workloads and the faults.
# It never creates the objects the learner must write.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for file in "$DIR"/manifests/*.yaml; do
  kubectl apply -f "$file"
done

kubectl -n starfleet rollout status deployment/bridge --timeout=180s
echo "[lab] Ready."
