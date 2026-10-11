---
draft: true
exam_objectives:
  - Scheduling
---
# Summary

The scheduler filters nodes using mandatory requirements and scores those that remain using preferences. Node and Pod affinity express different relationships, while topology rules control distribution across locations.

Taints restrict placement and can trigger eviction depending on their effect. Tolerations permit specific taints but do not require a node or bypass other constraints. A Pod remains Pending when no eligible node can satisfy all mandatory requirements.
