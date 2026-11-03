# Question

Solve this question on: `terminal`

The Starfleet cluster has one control plane node and one worker node. `kubectl` already points at it as the cluster administrator. The Deployment `hangar` in `starfleet` has three replicas. Every update of it stops all Pods first, so the service has a gap. Complete these tasks in the `starfleet` namespace.

1. Change the update strategy of `hangar` so that an update never reduces the number of available Pods below three and creates at most one extra Pod at a time. The strategy type must be `RollingUpdate`. All three replicas must stay available.

2. Create a DaemonSet named `lookout` that uses the image `busybox:1.37.0` and a command that keeps the container running (for example `sleep 3600`). It must run exactly one Pod on every node of the cluster, including the control plane node. Add the toleration that the control plane taint needs.

3. Create a CronJob named `nightly-scan` that runs every five minutes, uses the image `busybox:1.37.0` and a command that prints the date and exits. A new run must be skipped while the previous run is still active. Keep only one successful Job in the history. Use `restartPolicy: Never` in the Pod template.

4. Create a Job named `one-shot` that uses the image `busybox:1.37.0` and a command that prints a message and exits. It must need two successful completions, allow at most one retry, and use `restartPolicy: Never`. Both completions must finish.
