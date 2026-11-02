---
draft: true
exam_objectives:
  - Scheduling
---
# Summary

Scheduling requires each Pod to fit a suitable node's allocatable resources. Requests, hard placement rules and storage constraints can all block placement. Spare capacity helps replace workloads after a node failure.

Horizontal scaling changes replica count through metrics-driven decisions. Node scaling changes infrastructure capacity, and vertical sizing changes per-workload resources. Availability also depends on placement, readiness, disruption handling and dependencies that can support the increased load.
