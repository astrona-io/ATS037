#!/usr/bin/env bash
# Check: Pod pipeline has an init container watcher with restartPolicy Always, and watcher and worker both run.
set -uo pipefail

name="$(kubectl -n starfleet get pod pipeline -o jsonpath='{.spec.initContainers[?(@.name=="watcher")].name}' 2>/dev/null || true)"
if [ "$name" != "watcher" ]; then
  echo "FAIL: Pod pipeline is missing or has no init container named watcher"
  exit 1
fi
policy="$(kubectl -n starfleet get pod pipeline -o jsonpath='{.spec.initContainers[?(@.name=="watcher")].restartPolicy}' 2>/dev/null || true)"
if [ "$policy" != "Always" ]; then
  echo "FAIL: init container watcher has restartPolicy '${policy}', a native sidecar needs Always"
  exit 1
fi
side="$(kubectl -n starfleet get pod pipeline -o jsonpath='{.status.initContainerStatuses[?(@.name=="watcher")].state.running.startedAt}' 2>/dev/null || true)"
app="$(kubectl -n starfleet get pod pipeline -o jsonpath='{.status.containerStatuses[?(@.name=="worker")].state.running.startedAt}' 2>/dev/null || true)"
if [ -z "$side" ]; then
  echo "FAIL: sidecar watcher is not running"
  exit 1
fi
if [ -z "$app" ]; then
  echo "FAIL: container worker is not running"
  exit 1
fi
echo "PASS: pipeline runs the native sidecar watcher and the application worker"
