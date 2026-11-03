#!/usr/bin/env bash
# Check: Pod inspector shares one process namespace and both containers (app, tools) run busybox with sleep.
set -uo pipefail

share="$(kubectl -n starfleet get pod inspector -o jsonpath='{.spec.shareProcessNamespace}' 2>/dev/null || true)"
if [ "$share" != "true" ]; then
  echo "FAIL: Pod inspector missing or shareProcessNamespace is '${share}', expected true"
  exit 1
fi
names="$(kubectl -n starfleet get pod inspector -o jsonpath='{range .spec.containers[*]}{.name}{" "}{.image}{"\n"}{end}' 2>/dev/null)"
for want in "app busybox:1.37.0" "tools busybox:1.37.0"; do
  if ! echo "$names" | grep -qx "$want"; then
    echo "FAIL: expected a container '${want}' in inspector"
    exit 1
  fi
done
running="$(kubectl -n starfleet get pod inspector -o jsonpath='{range .status.containerStatuses[*]}{.state.running.startedAt}{"\n"}{end}' 2>/dev/null | grep -c . || true)"
if [ "$running" != "2" ]; then
  echo "FAIL: ${running} of 2 containers of inspector are running"
  exit 1
fi
echo "PASS: inspector shares a process namespace and both containers run"
