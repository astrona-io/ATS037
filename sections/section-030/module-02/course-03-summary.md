---
draft: true
exam_objectives:
  - Scheduling
---
# Summary

A node reports capacity, the total of the machine, and allocatable, what remains for Pods after the system reserve. The scheduler subtracts the requests of the Pods on a node from allocatable and places a new Pod only if its request fits the rest. It counts requests, not live usage, so an idle node can be full, and a Pod with no request counts as zero.

A Pod that does not fit stays Pending, and the `FailedScheduling` event says why: `Insufficient cpu` or `Insufficient memory`, a node selector or affinity mismatch, an untolerated taint, a port or Pod count limit, or an unbound claim. The remedy follows the reason: lower the request, free room, add nodes, or change the placement rules. A Pod rejected by a ResourceQuota is never created, which is different from Pending. Priority and preemption decide who gets scarce capacity. They do not create any.

Three autoscalers work at three layers. The HorizontalPodAutoscaler changes the replica count of a workload. The VerticalPodAutoscaler changes the size of each Pod. A cluster autoscaler changes the number of nodes. The HPA computes the desired replicas from a metric and a target, within `minReplicas` and `maxReplicas`, and scales down more slowly than up. CPU utilization is usage divided by the request, so a CPU request is required. The HPA needs a metrics server for its data.

Availability during scaling comes from readiness probes, rolling update limits, PodDisruptionBudgets, spreading across nodes and graceful shutdown. Autoscaling reacts in minutes, so the minimum replica count must cover the base load.

Key facts:

- Requests decide fit. Usage does not.
- Read the `FailedScheduling` event for a Pending Pod.
- HPA scales replicas, VPA scales Pod size, a cluster autoscaler scales nodes.
- No metrics server means no HPA data.

<!-- astrona:playground:destroy -->
