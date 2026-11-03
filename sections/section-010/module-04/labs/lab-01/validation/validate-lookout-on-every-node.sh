#!/usr/bin/env bash
# Check: the DaemonSet lookout runs one ready Pod on every node, control plane included.
set -uo pipefail

nodes="$(kubectl get nodes --no-headers 2>/dev/null | wc -l | tr -d ' ')"
desired="$(kubectl -n starfleet get daemonset lookout -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null || true)"
ready="$(kubectl -n starfleet get daemonset lookout -o jsonpath='{.status.numberReady}' 2>/dev/null || true)"
image="$(kubectl -n starfleet get daemonset lookout -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)"

if [ -z "$desired" ]; then
  echo "FAIL: DaemonSet lookout was not found in starfleet"
  exit 1
fi
if [ "$image" != "busybox:1.37.0" ]; then
  echo "FAIL: image is '${image}', expected busybox:1.37.0"
  exit 1
fi
if [ "$desired" != "$nodes" ]; then
  echo "FAIL: DaemonSet wants ${desired} Pods but the cluster has ${nodes} nodes (is the control plane toleration missing?)"
  exit 1
fi
if [ "${ready:-0}" != "$nodes" ]; then
  echo "FAIL: ${ready:-0} of ${nodes} lookout Pods are ready"
  exit 1
fi
cp_pods="$(kubectl -n starfleet get pods -l app=lookout -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' 2>/dev/null | grep -c control-plane || true)"
if [ "${cp_pods:-0}" -lt 1 ]; then
  echo "FAIL: no lookout Pod runs on the control plane node"
  exit 1
fi
echo "PASS: lookout runs ${ready} ready Pods, one on every node"
