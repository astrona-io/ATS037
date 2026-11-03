# Question

Solve this question on: `terminal`

The cluster has one control plane node and two worker nodes. The worker names end in `-worker` and `-worker2`. `kubectl` already points at the cluster as the cluster administrator. Two Deployments in `starfleet`, `mess` and `hauler`, have Pods that stay Pending. Read the scheduling events of a Pod from each before you change anything.

1. Make the `mess` Pods run without editing the Deployment. They must run on the worker node whose name ends in `-worker`. Do not label any other node.

2. Reserve the worker node whose name ends in `-worker2` for science workloads. Add the taint `reserved=science` with the effect `NoSchedule` to it. Then create a Deployment named `lab-bench` in `starfleet` with 2 replicas of the image `ghcr.io/stefanprodan/podinfo:6.15.0`. Its Pods must tolerate the taint and must run only on the `-worker2` node. The `mess` Pods must keep running.

3. Record why the `hauler` Pods are Pending. Create a ConfigMap named `placement-notes` in `starfleet` with the key `pending-reason`. Its value is the failure reason from the scheduling event, written as `Insufficient cpu` or `Insufficient memory`.

4. Make `hauler` run with its 2 replicas ready. Keep a CPU request on its container, no larger than 500 millicores.

5. Create a HorizontalPodAutoscaler named `hauler` in `starfleet` for the Deployment `hauler`. It must keep between 1 and 4 replicas and aim for an average CPU utilization of 70 percent. Use the `autoscaling/v2` API. The cluster has no metrics server, so the autoscaler will not report a metric value.
