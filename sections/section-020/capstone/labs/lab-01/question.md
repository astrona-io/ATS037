# Question

Solve this question on: `terminal`

The cluster has one control plane node and one worker node. `kubectl` already points at it as the cluster administrator. Work through the tasks in order and do the last task last. The control plane node carries the default taint, so Pods run on the worker node.

1. The Deployment `uplink` in `starfleet` has a Pod that cannot start. Read its events and fix the problem so that it pulls `ghcr.io/stefanprodan/podinfo:6.15.0`. It must have 1 ready replica.

2. Create a ConfigMap named `ship-settings` in `starfleet` with the key `LOG_LEVEL` set to `debug`. Create a Pod named `reader` in `starfleet` with the image `busybox:1.37.0` and the command `sleep 3600`. The Pod must get the environment variable `LOG_LEVEL` from that ConfigMap key. The Pod must be ready.

3. The Deployment `engine-room` in `starfleet` has no resource settings. Give its container a CPU request of `50m`, a memory request of `32Mi` and a memory limit of `128Mi`. The Deployment must keep 1 ready replica.

4. Create a ResourceQuota named `outpost-budget` in the namespace `outpost` that allows at most 4 Pods.

5. The Deployment `caravan` in `starfleet` has 3 replicas. Create a PodDisruptionBudget named `caravan` in `starfleet` that keeps at least 2 Pods of `caravan` available during voluntary disruptions.

6. Do this last. Prepare the worker node for maintenance by cordoning it. The `caravan` Pods must keep running.
