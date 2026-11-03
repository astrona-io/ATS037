# Question

Solve this question on: `terminal`

The cluster has one node. `kubectl` already points at it as the cluster administrator. The Deployment `cargo` in `starfleet` has Pods that stay Pending. Read the scheduling events of one of them before you change anything.

1. Record the evidence in a ConfigMap named `capacity-notes` in `starfleet` with two keys. The key `reason` holds the scheduling failure reason from the Pod event, written as `Insufficient cpu` or `Insufficient memory`. The key `allocatable-cpu` holds the allocatable CPU of the node, exactly as the node reports it.

2. Make `cargo` run with 3 ready replicas. Keep a CPU request on its container, no larger than 500 millicores, and keep the image and the Deployment name.

3. Create a HorizontalPodAutoscaler named `engine` in `starfleet` for the Deployment `engine`. It must keep between 2 and 5 replicas and aim for an average CPU utilization of 60 percent. Use the `autoscaling/v2` API. The cluster has no metrics server, so the autoscaler will not report a metric value. That is expected.
