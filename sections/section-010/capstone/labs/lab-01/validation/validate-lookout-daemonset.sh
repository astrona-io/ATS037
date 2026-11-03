#!/usr/bin/env bash
# Check: DaemonSet lookout runs busybox on every node, with all desired Pods ready.
set -uo pipefail

image="$(kubectl -n starfleet get daemonset lookout -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)"
if [ "$image" != "busybox:1.37.0" ]; then
  echo "FAIL: DaemonSet lookout missing or image is '${image}'"
  exit 1
fi
desired="$(kubectl -n starfleet get daemonset lookout -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null || true)"
ready="$(kubectl -n starfleet get daemonset lookout -o jsonpath='{.status.numberReady}' 2>/dev/null || true)"
nodes="$(kubectl get nodes --no-headers 2>/dev/null | grep -c . || true)"
if [ "${desired:-0}" -lt 1 ] || [ "${ready:-0}" != "$desired" ]; then
  echo "FAIL: lookout has ${ready:-0} ready of ${desired:-0} desired Pods"
  exit 1
fi
if [ "$desired" != "$nodes" ]; then
  echo "FAIL: lookout is scheduled on ${desired} nodes, the cluster has ${nodes}"
  exit 1
fi
echo "PASS: lookout runs on all ${nodes} node(s)"
