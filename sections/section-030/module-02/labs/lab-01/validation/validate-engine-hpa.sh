#!/usr/bin/env bash
# Check: HPA engine (autoscaling/v2) targets Deployment engine, 2 to 5 replicas, CPU utilization 60. Engine keeps its CPU request.
set -uo pipefail

get() { kubectl -n starfleet get hpa.v2.autoscaling engine -o jsonpath="$1" 2>/dev/null || true; }

if [ -z "$(get '{.metadata.name}')" ]; then
  echo "FAIL: no HorizontalPodAutoscaler named engine in starfleet"
  exit 1
fi
kind="$(get '{.spec.scaleTargetRef.kind}')"
name="$(get '{.spec.scaleTargetRef.name}')"
if [ "$kind" != "Deployment" ] || [ "$name" != "engine" ]; then
  echo "FAIL: scaleTargetRef is ${kind}/${name}, expected Deployment/engine"
  exit 1
fi
min="$(get '{.spec.minReplicas}')"
max="$(get '{.spec.maxReplicas}')"
if [ "$min" != "2" ] || [ "$max" != "5" ]; then
  echo "FAIL: replica range is ${min} to ${max}, expected 2 to 5"
  exit 1
fi
metric="$(get '{.spec.metrics[0].resource.name}')"
util="$(get '{.spec.metrics[0].resource.target.averageUtilization}')"
if [ "$metric" != "cpu" ] || [ "$util" != "60" ]; then
  echo "FAIL: metric is '${metric}' at '${util}' percent, expected cpu at 60 percent"
  exit 1
fi
req="$(kubectl -n starfleet get deployment engine -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null || true)"
if [ -z "$req" ]; then
  echo "FAIL: the engine Deployment has no CPU request, so utilization cannot be computed"
  exit 1
fi
echo "PASS: HPA engine keeps 2 to 5 replicas at 60 percent CPU"
