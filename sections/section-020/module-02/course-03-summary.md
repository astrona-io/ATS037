---
draft: true
exam_objectives:
  - Administration
---
# Summary

A ConfigMap stores non-confidential configuration. A Secret stores confidential data in the same key-value form. Secret values are base64 encoded, which is not encryption. Their protection comes from separate access rules and optional encryption at rest. Both objects are limited to 1 MiB, and `immutable: true` blocks later changes.

A container receives these objects as environment variables or as files. Environment variables are fixed when the container starts and never change in a running container. Files from a `configMap` or `secret` volume are refreshed by the kubelet after a delay, and the application must read them again. A file mounted with `subPath` is not refreshed. The safe rollout of a configuration change is to create a new object with a new name and point the Deployment at it, so that the Pod template changes and the Deployment replaces the Pods.

A request is the amount the scheduler reserves, and the sum of the requests on a node must fit its capacity. A limit is the maximum that is enforced at runtime. A container above its CPU limit is throttled. A container above its memory limit is killed and shows `OOMKilled`. From these numbers each Pod gets a quality of service class: Guaranteed when every request equals its limit, Burstable when some numbers are set, and BestEffort when none is set. Under memory pressure the kubelet evicts BestEffort Pods first.

A ResourceQuota caps the total consumption and the object counts of a namespace and rejects requests beyond the cap. A LimitRange sets defaults, minimums and maximums for a single container or Pod. A quota on CPU or memory needs every new Pod to state that resource, and a LimitRange can supply the default.

Key facts:

- ConfigMap for plain settings, Secret for confidential values.
- Environment variables need a restart to change. Mounted files refresh.
- Request for placement, limit for enforcement.
- ResourceQuota for the namespace total, LimitRange for per-container defaults and bounds.

<!-- astrona:playground:destroy -->
