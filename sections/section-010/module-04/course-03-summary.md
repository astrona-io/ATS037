---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Summary

Deployments manage interchangeable replicas and rollouts through ReplicaSets. StatefulSets support stable member identities and storage associations. DaemonSets follow the set of eligible nodes.

Jobs manage work that should complete, while CronJobs request Jobs on a schedule. Controllers handle resource lifecycles; application code must still handle durable state, replication and safe retries. Choose a controller from the workload's intended lifetime and identity requirements.
