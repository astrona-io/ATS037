#!/usr/bin/env bash
# Check: ConfigMap container-notes holds the live runtime name and the digest of the running fetcher image.
set -uo pipefail

full="$(kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.containerRuntimeVersion}' 2>/dev/null || true)"
runtime="${full%%://*}"
have_rt="$(kubectl -n starfleet get configmap container-notes -o jsonpath='{.data.container-runtime}' 2>/dev/null || true)"
if [ -z "$runtime" ] || [ "$have_rt" != "$runtime" ]; then
  echo "FAIL: container-runtime is '${have_rt}', expected '${runtime}' (the part before ://)"
  exit 1
fi
id="$(kubectl -n starfleet get pods -l app=fetcher --field-selector=status.phase=Running -o jsonpath='{.items[0].status.containerStatuses[0].imageID}' 2>/dev/null || true)"
id="${id#docker-pullable://}"
want="${id##*@}"
have="$(kubectl -n starfleet get configmap container-notes -o jsonpath='{.data.fetcher-digest}' 2>/dev/null || true)"
case "$want" in
  sha256:*) ;;
  *) echo "FAIL: no running fetcher container with a resolved image identifier yet"; exit 1 ;;
esac
if [ "$have" != "$want" ]; then
  echo "FAIL: fetcher-digest is '${have}', the running fetcher container reports '${want}'"
  exit 1
fi
echo "PASS: container-notes records ${runtime} and ${want}"
