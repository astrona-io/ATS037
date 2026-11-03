# Question

Solve this question on: `terminal`

The cluster has one node. `kubectl` already points at it as the cluster administrator. The Deployment `broken-init` in `starfleet` has a Pod that never becomes ready. Read the status and the log of the failing container before you change anything.

1. Create a Pod named `builder` in `starfleet`. It has an `emptyDir` volume, an init container named `prepare` that writes the text `mission=ready` into the file `config.txt` on that volume, and an application container named `app` that mounts the same volume and prints that file to its log and then keeps running. Use the image `busybox:1.37.0` for both containers. The Pod must be running, and the log of `app` must contain `mission=ready`.

2. Create a Pod named `shipper` in `starfleet` with a native sidecar. The sidecar is an init container named `tail` with the image `busybox:1.37.0`, which keeps running for as long as the Pod runs. The application container is named `app` with the image `busybox:1.37.0` and keeps running too. Both containers must be running.

3. Repair the Deployment `broken-init` without removing its init container or its volume. The init container must succeed, and the Deployment must have 1 ready replica.
