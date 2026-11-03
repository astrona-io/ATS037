# Question

Solve this question on: `terminal`

The cluster has one node. `kubectl` already points at it as the cluster administrator. Two Deployments in `starfleet`, `leaky` and `fetcher`, do not run. Read the Pod status and events of each before you change anything.

1. Make `leaky` stable with 1 ready replica. Keep the image `busybox:1.37.0` and keep a memory limit of at least `128Mi` on its container.

2. Make `fetcher` run with 1 ready replica. Its Pod cannot pull the image, because the tag does not exist. Use the tag `6.15.0` of the same repository.

3. Create a Pod named `pipeline` in `starfleet` that uses the image `busybox:1.37.0` in every container and one `emptyDir` volume shared by all of them:
   - An init container named `generate` that runs to completion and writes the line `mode=night` into the file `settings.txt` on the shared volume.
   - A native sidecar named `watcher`, an init container that keeps running for the whole life of the Pod.
   - An application container named `worker` that prints the content of `settings.txt` and then keeps running.

4. Record two facts from the live cluster in a ConfigMap named `container-notes` in `starfleet`. The key `container-runtime` holds the name of the container runtime of the node, without the version and without the `://` part. The key `fetcher-digest` holds the digest, starting with `sha256:`, of the image that the running `fetcher` container uses.
