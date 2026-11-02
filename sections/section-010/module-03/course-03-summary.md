---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Summary

A Pod groups containers that share scheduling and network resources. Shared volumes must be configured explicitly. Pod phases, container states and conditions describe different levels of lifecycle evidence.

Readiness controls whether a workload should receive traffic. Liveness can trigger a restart, and startup checks protect initialization. Restarting a container preserves its Pod identity; replacing a Pod creates a new identity. Application state must account for both events.
