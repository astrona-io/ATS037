#!/usr/bin/env bash
# Check: CronJob nightly has schedule "0 2 * * *", is not suspended and uses busybox:1.37.0.
set -uo pipefail

schedule="$(kubectl -n starfleet get cronjob nightly -o jsonpath='{.spec.schedule}' 2>/dev/null || true)"
if [ -z "$schedule" ]; then
  echo "FAIL: no CronJob named nightly in starfleet"
  exit 1
fi
if [ "$schedule" != "0 2 * * *" ]; then
  echo "FAIL: schedule is '${schedule}', expected '0 2 * * *'"
  exit 1
fi
suspend="$(kubectl -n starfleet get cronjob nightly -o jsonpath='{.spec.suspend}' 2>/dev/null || true)"
if [ "$suspend" = "true" ]; then
  echo "FAIL: the CronJob is suspended"
  exit 1
fi
image="$(kubectl -n starfleet get cronjob nightly -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}' 2>/dev/null || true)"
if [ "$image" != "busybox:1.37.0" ]; then
  echo "FAIL: CronJob image is '${image}', expected busybox:1.37.0"
  exit 1
fi
echo "PASS: nightly runs at 02:00 daily with busybox:1.37.0"
