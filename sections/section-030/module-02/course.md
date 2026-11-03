---
draft: true
exam_objectives:
  - Scheduling
---
# Placement And Scaling

A Pod can stay Pending because the cluster has no room for it. A workload can fall over because it has too few replicas for the traffic of the hour. Both problems come from capacity: how much a node can offer, how much Pods ask for, and how the number of Pods follows the load. Kubernetes has rules to read the first and controllers to automate the second.

Keep one sentence in mind for this module: **capacity is the sum of requests against what nodes offer, and autoscalers change replicas, resource sizes or the number of nodes to keep that sum workable.** You will read why a Pod is Pending, compare the capacity of a node with the requests on it, and create a HorizontalPodAutoscaler.

The module has two parts. **Capacity And Pending Pods** covers allocatable capacity, requests and the reasons a Pod stays Pending. **Replica Autoscaling And Availability** covers the HorizontalPodAutoscaler, the other autoscalers and the mechanisms that keep an application available while it scales.

## Learning goals

After this module you can:

- Explain how requests and allocatable capacity decide whether a Pod fits.
- Diagnose a Pending Pod from its events.
- Compare horizontal scaling, vertical scaling and cluster scaling.
- Explain what keeps replicas available during scaling and disruptions.

## Before you start

You need to know what a Pod, a Deployment and a resource request are. Other terms are defined where they first appear.

Your playground is a `kind` cluster running Kubernetes 1.35 with one node:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, one replica each, with Services for `scout` and `probe`, and the Deployment `engine` with a CPU request of 100 millicores |
| `outpost` | The `drifter` client |

The playground does not run a metrics server. `kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
