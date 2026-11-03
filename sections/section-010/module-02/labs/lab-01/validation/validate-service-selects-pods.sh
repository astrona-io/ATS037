#!/usr/bin/env bash
# Check: the bridge Service has endpoints, the Pods keep their app=bridge label
# (the fix is on the Service, not on the Pods).
set -uo pipefail

selector="$(kubectl -n starfleet get service bridge -o jsonpath='{.spec.selector.app}' 2>/dev/null || true)"
if [ "$selector" != "bridge" ]; then
  echo "FAIL: the Service selector app is '${selector}', expected 'bridge'"
  exit 1
fi
template="$(kubectl -n starfleet get deployment bridge -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null || true)"
if [ "$template" != "bridge" ]; then
  echo "FAIL: the Pod template label app is '${template}', it must stay 'bridge'"
  exit 1
fi
count="$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=bridge -o json | jq '[.items[].endpoints[]? | select(.conditions.ready != false)] | length')"
if [ "${count:-0}" -lt 1 ]; then
  echo "FAIL: the bridge Service has no ready endpoints"
  exit 1
fi
echo "PASS: the bridge Service selects ${count} ready Pods"
