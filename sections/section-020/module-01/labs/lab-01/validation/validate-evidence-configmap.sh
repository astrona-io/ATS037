#!/usr/bin/env bash
# Check: ConfigMap evidence records the context, a pull-failure reason and the failing image.
set -uo pipefail

get() { kubectl -n starfleet get configmap evidence -o jsonpath="$1" 2>/dev/null || true; }

if ! kubectl -n starfleet get configmap evidence >/dev/null 2>&1; then
  echo "FAIL: ConfigMap evidence was not found in starfleet"
  exit 1
fi
ctx="$(get '{.data.context}')"
reason="$(get '{.data.reason}')"
image="$(get '{.data.image}')"
want="$(kubectl config current-context)"

if [ "$ctx" != "$want" ]; then
  echo "FAIL: key context is '${ctx}', expected '${want}'"
  exit 1
fi
if [ "$reason" != "ErrImagePull" ] && [ "$reason" != "ImagePullBackOff" ]; then
  echo "FAIL: key reason is '${reason}', expected ErrImagePull or ImagePullBackOff"
  exit 1
fi
if [ "$image" != "ghcr.io/stefanprodan/podinfo:6.15.99" ]; then
  echo "FAIL: key image is '${image}', expected the image reference that failed to pull"
  exit 1
fi
echo "PASS: evidence records context ${ctx}, reason ${reason} and image ${image}"
