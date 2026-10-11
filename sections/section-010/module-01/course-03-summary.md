---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Summary

The control plane stores requests, manages resource relationships and assigns workloads to nodes. The kubelet and container runtime make assigned containers run. Networking components provide workload connectivity.

Controllers reconcile desired and observed state through repeated actions. A valid specification can still be blocked by unavailable capacity or dependencies. Replacement restores a managed workload's replica count, but application correctness needs its own evidence.
