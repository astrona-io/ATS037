# Question

Solve this question on: `terminal`

The cluster has one node. `kubectl` already points at it as the cluster administrator. The Deployment `courier` in `starfleet` has a Pod that cannot start. Read its events before you change anything.

1. Make `courier` run. Fix the image reference so that the Pod pulls `ghcr.io/stefanprodan/podinfo:6.15.0`. The Deployment must have 1 ready replica.

2. Create a Pod named `cached` in `starfleet` with one container named `cached`. It runs the image `busybox:1.37.0` with the command `sleep 3600`. Its image pull policy must be `IfNotPresent`, set explicitly in the Pod specification. The Pod must be running.

3. Create a ConfigMap named `image-facts` in `starfleet` with two keys. The key `repository` holds the repository of the `courier` image without a tag, `ghcr.io/stefanprodan/podinfo`. The key `digest` holds the digest, starting with `sha256:`, of the image that the running `courier` container uses, as the container status reports it.
