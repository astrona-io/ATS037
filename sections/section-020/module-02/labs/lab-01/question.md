# Question

Solve this question on: `terminal`

A team runs workloads in `starfleet` and `outpost`. `kubectl` already points at the cluster as the cluster administrator. Complete these tasks.

1. In `starfleet`, create a ConfigMap named `app-settings` with the key `LOG_LEVEL` set to `debug`, and a Secret named `app-key` with the key `token` set to `orbit-7`.

2. In `starfleet`, create a Pod named `reader` with one container named `reader`, using the image `busybox:1.37.0` and a command that keeps it running (for example `sleep 3600`). The container must get the environment variable `LOG_LEVEL` from the ConfigMap key `LOG_LEVEL`, and the Secret `app-key` must be mounted as files in the directory `/etc/key`. The Pod must be running.

3. The Deployment `ballast` in `starfleet` has no resource settings. Set a CPU request of `50m` and a memory request of `64Mi` on its container, and a memory limit of `128Mi`. Both replicas must be available after the change.

4. In `outpost`, create a ResourceQuota named `outpost-budget` that allows at most 5 Pods and at most 10 ConfigMaps in the namespace.
