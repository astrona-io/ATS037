# Question

Solve this question on: `terminal`

The cluster has one node. `kubectl` already points at it as the cluster administrator. The Deployment `hog` in `starfleet` has a container that keeps restarting. Read its last terminated state before you change anything.

1. Create a Pod named `inspector` in `starfleet` with two containers, `app` and `tools`, both running the image `busybox:1.37.0` with the command `sleep 3600`. The containers must share one process namespace, so that each of them can see the processes of the other. Both containers must be running.

2. Make the `hog` container stop restarting. Keep the Deployment name, the container name and the image. The container must keep a memory limit of at least 128Mi and the Deployment must have 1 ready replica.

3. Create a ConfigMap named `runtime-facts` in `starfleet` with two keys. The key `container-runtime` holds the name of the container runtime of the node, without its version and without the `://` part. The key `kernel-version` holds the kernel version of the node, exactly as the node reports it.
