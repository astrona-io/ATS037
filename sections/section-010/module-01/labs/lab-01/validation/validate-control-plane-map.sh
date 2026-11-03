#!/usr/bin/env bash
# Check: the ConfigMap names the real static Pod of each control plane component.
set -uo pipefail

fail=0
check_key() {
  local key="$1" component="$2"
  local expected actual
  expected="$(kubectl -n kube-system get pod -l "component=${component}" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
  actual="$(kubectl -n starfleet get configmap control-plane-map -o jsonpath="{.data.${key}}" 2>/dev/null || true)"
  if [ -z "$expected" ]; then
    echo "FAIL: no Pod with component=${component} found in kube-system"
    fail=1
  elif [ "$actual" != "$expected" ]; then
    echo "FAIL: key '${key}' is '${actual}', expected '${expected}'"
    fail=1
  fi
}

check_key api-server kube-apiserver
check_key etcd etcd
check_key scheduler kube-scheduler
check_key controller-manager kube-controller-manager

if [ "$fail" -ne 0 ]; then exit 1; fi
echo "PASS: control-plane-map names all four control plane Pods"
