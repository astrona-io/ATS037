# Question

Solve this question on: `terminal`

The cluster has one control plane node and two worker nodes. The worker names end in `-worker` and `-worker2`. `kubectl` already points at the cluster as the cluster administrator. The Deployment `dockyard` in `starfleet` has Pods that stay Pending. Read the scheduling events of one of them before you change anything.

1. Make the `dockyard` Pods run without editing the Deployment. They must run on the worker node whose name ends in `-worker`. Do not label any other node.

2. Reserve the worker node whose name ends in `-worker2` for the probe team. Add the taint `dedicated=probe` with the effect `NoSchedule` to it. The `dockyard` Pods must keep running.

3. Create a Deployment named `escort` in `starfleet` with 2 replicas of the image `ghcr.io/stefanprodan/podinfo:6.15.0`. Its Pods must tolerate the taint from task 2 and must run only on the node whose name ends in `-worker2`. Both replicas must be running.
