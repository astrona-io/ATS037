#!/usr/bin/env bash
# Check: the CronJob nightly-scan has the required schedule, concurrency policy, history limit and restart policy.
set -uo pipefail

get() { kubectl -n starfleet get cronjob nightly-scan -o jsonpath="$1" 2>/dev/null || true; }

schedule="$(get '{.spec.schedule}')"
policy="$(get '{.spec.concurrencyPolicy}')"
history="$(get '{.spec.successfulJobsHistoryLimit}')"
restart="$(get '{.spec.jobTemplate.spec.template.spec.restartPolicy}')"
image="$(get '{.spec.jobTemplate.spec.template.spec.containers[0].image}')"

if [ -z "$schedule" ]; then
  echo "FAIL: CronJob nightly-scan was not found in starfleet"
  exit 1
fi
if [ "$schedule" != "*/5 * * * *" ]; then
  echo "FAIL: schedule is '${schedule}', expected '*/5 * * * *'"
  exit 1
fi
if [ "$policy" != "Forbid" ]; then
  echo "FAIL: concurrencyPolicy is '${policy}', expected Forbid"
  exit 1
fi
if [ "$history" != "1" ]; then
  echo "FAIL: successfulJobsHistoryLimit is '${history}', expected 1"
  exit 1
fi
if [ "$restart" != "Never" ]; then
  echo "FAIL: restartPolicy is '${restart}', expected Never"
  exit 1
fi
if [ "$image" != "busybox:1.37.0" ]; then
  echo "FAIL: image is '${image}', expected busybox:1.37.0"
  exit 1
fi
echo "PASS: nightly-scan runs every five minutes, forbids overlap and keeps one successful Job"
