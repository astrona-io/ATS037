# Question

Solve this question on: `terminal`

The `beacon` Deployment in `starfleet` is unhealthy: its Pods restart again and again and none of them becomes ready. `kubectl` already points at the cluster as the cluster administrator. Read the container state, the restart count and the events before you change anything.

1. Fix the probes of the `beacon` container so that both replicas become ready and stop restarting. The application serves `/healthz` and `/readyz` on its container port named `http`. Keep both the liveness probe and the readiness probe, and keep using the named port.

2. Add a startup probe to the `beacon` container. It must use an HTTP GET on `/healthz` and tolerate a slow start: it must allow at least 10 failures before it gives up.

3. Create a Pod named `exchange` in `starfleet` with two containers named `producer` and `consumer`, both using the image `busybox:1.37.0` and a command that keeps them running (for example `sleep 3600`). Both containers must mount the same `emptyDir` volume, so a file that `producer` writes is visible to `consumer`. The Pod must be running with both containers ready.
