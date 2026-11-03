#!/usr/bin/env bash
# Check: tier=frontend is on the template and on every running Pod; the
# annotation is on the Deployment's own metadata, not only on the template.
set -uo pipefail

if [ "$(kubectl -n starfleet get deployment bridge -o jsonpath='{.spec.template.metadata.labels.tier}' 2>/dev/null)" != "frontend" ]; then
  echo "FAIL: the Pod template of bridge does not carry tier=frontend"
  exit 1
fi
total="$(kubectl -n starfleet get pods -l app=bridge --field-selector=status.phase=Running -o json | jq '.items | length')"
labelled="$(kubectl -n starfleet get pods -l app=bridge,tier=frontend --field-selector=status.phase=Running -o json | jq '.items | length')"
if [ "${total:-0}" -lt 1 ] || [ "$total" != "$labelled" ]; then
  echo "FAIL: ${labelled} of ${total} running bridge Pods have tier=frontend"
  exit 1
fi
if [ "$(kubectl -n starfleet get deployment bridge -o jsonpath='{.metadata.annotations.contact}' 2>/dev/null)" != "ops" ]; then
  echo "FAIL: the Deployment bridge has no annotation contact=ops in its own metadata"
  exit 1
fi
echo "PASS: all ${total} bridge Pods carry tier=frontend and the Deployment is annotated"
