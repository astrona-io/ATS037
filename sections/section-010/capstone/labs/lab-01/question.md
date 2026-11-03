# Question

Solve this question on: `terminal`

The cluster has one node. `kubectl` already points at it as the cluster administrator. The Starfleet namespace `starfleet` holds a Pod named `stalled` that is running but never becomes ready. Work through the tasks in order.

1. Create a Deployment named `relay` in `starfleet` with 3 replicas of the image `ghcr.io/stefanprodan/podinfo:6.15.0`. The label `app=relay` selects its Pods, and the Pod template must also carry the label `tier=edge`. All 3 replicas must be ready.

2. Find the ReplicaSet that owns the `relay` Pods. Record its name in a ConfigMap named `cluster-notes` in `starfleet`, in the key `owner-replicaset`.

3. Read the Pod `stalled` and find out why it is not ready. Make it ready. The Pod must keep its name, its image and its readiness probe, and the probe must use an HTTP path that the application serves. The application answers on `/healthz`.

4. Create a DaemonSet named `lookout` in `starfleet` that runs the image `busybox:1.37.0` with the command `sleep 3600` on every node. Its Pods must be ready.

5. Create a CronJob named `nightly` in `starfleet` that runs at 02:00 every day (schedule `0 2 * * *`) with the image `busybox:1.37.0` and a command of your choice. The CronJob must not be suspended.
