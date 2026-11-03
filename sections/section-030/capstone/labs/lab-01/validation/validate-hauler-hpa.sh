#!/usr/bin/env bash
# Check: HPA hauler (autoscaling/v2) targets Deployment hauler, 1 to 4 replicas, CPU utilization 70.
set -uo pipefail

get() { kubectl -n starfleet get hpa.v2.autoscaling hauler -o jsonpath="$1" 2>/dev/null || true; }

if [ -z "$(get '{.metadata.name}')" ]; then
  echo "FAIL: no HorizontalPodAutoscaler named hauler in starfleet"
  exit 1
fi
kind="$(get '{.spec.scaleTargetRef.kind}')"
name="$(get '{.spec.scaleTargetRef.name}')"
if [ "$kind" != "Deployment" ] || [ "$name" != "hauler" ]; then
  echo "FAIL: scaleTargetRef is ${kind}/${name}, expected Deployment/hauler"
  exit 1
fi
min="$(get '{.spec.minReplicas}')"
max="$(get '{.spec.maxReplicas}')"
if [ "$min" != "1" ] || [ "$max" != "4" ]; then
  echo "FAIL: replica range is ${min} to ${max}, expected 1 to 4"
  exit 1
fi
metric="$(get '{.spec.metrics[0].resource.name}')"
util="$(get '{.spec.metrics[0].resource.target.averageUtilization}')"
if [ "$metric" != "cpu" ] || [ "$util" != "70" ]; then
  echo "FAIL: metric is '${metric}' at '${util}' percent, expected cpu at 70 percent"
  exit 1
fi
echo "PASS: HPA hauler keeps 1 to 4 replicas at 70 percent CPU"
