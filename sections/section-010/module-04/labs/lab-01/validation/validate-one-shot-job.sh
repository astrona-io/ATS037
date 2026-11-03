#!/usr/bin/env bash
# Check: the Job one-shot needs two completions, allows one retry, never restarts in place, and has finished.
set -uo pipefail

get() { kubectl -n starfleet get job one-shot -o jsonpath="$1" 2>/dev/null || true; }

completions="$(get '{.spec.completions}')"
backoff="$(get '{.spec.backoffLimit}')"
restart="$(get '{.spec.template.spec.restartPolicy}')"
succeeded="$(get '{.status.succeeded}')"

if [ -z "$completions" ]; then
  echo "FAIL: Job one-shot was not found in starfleet"
  exit 1
fi
if [ "$completions" != "2" ]; then
  echo "FAIL: completions is '${completions}', expected 2"
  exit 1
fi
if [ "$backoff" != "1" ]; then
  echo "FAIL: backoffLimit is '${backoff}', expected 1"
  exit 1
fi
if [ "$restart" != "Never" ]; then
  echo "FAIL: restartPolicy is '${restart}', expected Never"
  exit 1
fi
if [ "${succeeded:-0}" != "2" ]; then
  echo "FAIL: ${succeeded:-0} of 2 completions have succeeded"
  exit 1
fi
echo "PASS: one-shot finished with 2 successful completions"
