#!/usr/bin/env bash
# Check: ConfigMap placement-notes key pending-reason holds the scheduling failure reason.
set -uo pipefail

reason="$(kubectl -n starfleet get configmap placement-notes -o jsonpath='{.data.pending-reason}' 2>/dev/null || true)"
if [ "$reason" != "Insufficient cpu" ]; then
  echo "FAIL: placement-notes key pending-reason is '${reason}', expected 'Insufficient cpu' (read the FailedScheduling event of a hauler Pod)"
  exit 1
fi
echo "PASS: placement-notes records '${reason}'"
