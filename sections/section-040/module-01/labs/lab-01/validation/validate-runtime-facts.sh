#!/usr/bin/env bash
# Check: ConfigMap runtime-facts holds the live runtime name and kernel version of the node.
set -uo pipefail

full="$(kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.containerRuntimeVersion}' 2>/dev/null || true)"
kernel="$(kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.kernelVersion}' 2>/dev/null || true)"
runtime="${full%%://*}"
have_rt="$(kubectl -n starfleet get configmap runtime-facts -o jsonpath='{.data.container-runtime}' 2>/dev/null || true)"
have_kv="$(kubectl -n starfleet get configmap runtime-facts -o jsonpath='{.data.kernel-version}' 2>/dev/null || true)"
if [ -z "$runtime" ] || [ "$have_rt" != "$runtime" ]; then
  echo "FAIL: container-runtime is '${have_rt}', expected '${runtime}' (the part before ://)"
  exit 1
fi
if [ -z "$kernel" ] || [ "$have_kv" != "$kernel" ]; then
  echo "FAIL: kernel-version is '${have_kv}', the node reports '${kernel}'"
  exit 1
fi
echo "PASS: runtime-facts records ${runtime} and kernel ${kernel}"
