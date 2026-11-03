#!/usr/bin/env bash
# Check: Pod exchange runs two ready containers that mount the same emptyDir.
set -uo pipefail

pod="$(kubectl -n starfleet get pod exchange -o json 2>/dev/null || true)"
if [ -z "$pod" ]; then
  echo "FAIL: the Pod exchange does not exist"
  exit 1
fi
names="$(echo "$pod" | jq -r '[.spec.containers[].name] | sort | join(",")')"
if [ "$names" != "consumer,producer" ]; then
  echo "FAIL: containers are '${names}', expected consumer and producer"
  exit 1
fi
shared="$(echo "$pod" | jq -r '[.spec.containers[] | .volumeMounts[]?.name] | group_by(.) | map(select(length == 2)) | .[0][0] // empty')"
if [ -z "$shared" ]; then
  echo "FAIL: the two containers do not mount the same volume"
  exit 1
fi
if [ "$(echo "$pod" | jq --arg v "$shared" '[.spec.volumes[] | select(.name == $v and .emptyDir != null)] | length')" != "1" ]; then
  echo "FAIL: the shared volume '${shared}' is not an emptyDir"
  exit 1
fi
ready="$(echo "$pod" | jq '[.status.containerStatuses[]? | select(.ready)] | length')"
if [ "${ready:-0}" != "2" ]; then
  echo "FAIL: ${ready:-0} of 2 containers are ready"
  exit 1
fi
echo "PASS: exchange shares the emptyDir '${shared}' and both containers are ready"
