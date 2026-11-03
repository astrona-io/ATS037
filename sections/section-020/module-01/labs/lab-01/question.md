# Question

Solve this question on: `terminal`

The `console` Deployment in `starfleet` does not start. The Deployment `leftover` in the same namespace is no longer needed, but its Pods are still serving a few old requests and must stay up until they are replaced later. `kubectl` already points at the cluster as the cluster administrator. Read the evidence before you change anything.

1. Create a ConfigMap named `evidence` in `starfleet` with three keys. The key `context` holds the name of the active `kubectl` context. The key `reason` holds the waiting reason that the Pod of `console` reports. The key `image` holds the exact image reference that fails to be pulled.

2. Fix `console` so that its Pod runs. Use the image `ghcr.io/stefanprodan/podinfo:6.15.0`.

3. Remove the Deployment `leftover`, but keep its Pods and its ReplicaSet running.
