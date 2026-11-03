#!/usr/bin/env bash
# Check: ConfigMap image-facts holds the repository and the live digest of the running courier container.
set -uo pipefail

repo="$(kubectl -n starfleet get configmap image-facts -o jsonpath='{.data.repository}' 2>/dev/null || true)"
if [ "$repo" != "ghcr.io/stefanprodan/podinfo" ]; then
  echo "FAIL: image-facts key repository is '${repo}', expected ghcr.io/stefanprodan/podinfo"
  exit 1
fi
id="$(kubectl -n starfleet get pods -l app=courier --field-selector=status.phase=Running -o jsonpath='{.items[0].status.containerStatuses[0].imageID}' 2>/dev/null || true)"
id="${id#docker-pullable://}"
want="${id##*@}"
have="$(kubectl -n starfleet get configmap image-facts -o jsonpath='{.data.digest}' 2>/dev/null || true)"
case "$want" in
  sha256:*) ;;
  *) echo "FAIL: no running courier container with a resolved image identifier yet"; exit 1 ;;
esac
if [ "$have" != "$want" ]; then
  echo "FAIL: image-facts key digest is '${have}', the running courier container reports '${want}'"
  exit 1
fi
echo "PASS: image-facts records ${repo} at ${want}"
