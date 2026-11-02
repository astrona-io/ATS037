---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Restart Policies, Probes And Replacement

The `scout` process exits after an error. Its kubelet may restart the container according to the Pod's restart policy. A container restart normally keeps the same Pod identity and scheduling assignment. A Deployment replacing a deleted Pod creates a new object, which may run on another node and receive another network address.

A readiness probe checks whether a container should receive traffic. When it fails, the Pod becomes unready and ordinary Service traffic should stop reaching that backend. A readiness failure does not itself restart the container. This lets an application temporarily stop accepting work while it recovers or warms up.

A liveness probe checks whether the container should be restarted. Repeated failure triggers termination and restart according to the restart policy. A startup probe gives a slow-starting application time to initialize; when configured, readiness and liveness checks wait until startup succeeds. Repeated startup failure can also cause a restart.

Probes are configured checks, not automatic knowledge of application health. An endpoint that always returns success can hide failures. A liveness endpoint that fails whenever a database is briefly unavailable can cause unnecessary restart cycles. Readiness can reflect dependency availability without requiring every dependency failure to kill the process.

Pod termination also needs application cooperation. Kubernetes provides a grace period, and processes should handle termination signals so they stop taking new work and finish or safely cancel current work. Container-local files and memory are not a durable way to preserve work across replacement.

For a slow application that needs ninety seconds to initialize, protect startup before enabling aggressive liveness checks. For a process that is alive but temporarily unable to serve requests, readiness is usually the relevant traffic control. Choose the check according to the action its failure causes.

## Designing Probes From Their Consequences

Suppose `scout` needs ninety seconds to prepare a local index. A liveness check that starts early and repeatedly fails can kill the process before initialization finishes. A startup probe can allow enough attempts over an appropriate interval for the normal startup duration. After startup succeeds, the regular health checks begin doing their intended work.

Probe settings include the interval between checks, the timeout for an attempt and thresholds for failure or recovery where supported. Their combined timing determines how quickly Kubernetes reacts. A probe interval alone is not the full tolerated failure duration. Network delay, application load and initialization variability need consideration when setting thresholds.

A readiness endpoint should reflect whether the instance can safely accept its assigned work. A liveness endpoint should detect a condition where restarting is an appropriate remedy. These may deliberately check different things. If the database is briefly unavailable, marking a request handler unready can reduce failed requests, while killing all handlers might add startup load without restoring the database.

## Comparing Restart And Replacement

A restart can leave the same Pod address, name and volume association in place. Its in-memory process state is lost, and its container-local writable state should not be treated as a durable recovery contract. An explicitly mounted `emptyDir` can remain for the Pod's lifetime even when a container restarts.

Replacement is broader. The old Pod object is gone and the new one can have another identifier, address and node. Pod-lifetime temporary storage is not inherited. A persistent claim can reconnect durable storage when its access and topology requirements allow it, but the application still must recover consistently from interrupted work.

A health design should therefore be evaluated through the action it triggers and the state that action loses. Use readiness for traffic eligibility, liveness for justified restart and an adequate startup allowance for initialization. Then make the application robust to both restart and replacement rather than assuming probes prevent every interruption.

## Common pitfalls

> [!WARNING]
> Readiness controls eligibility for traffic; liveness controls restarting. A probe that tests the wrong condition can remove healthy capacity or repeatedly restart a recoverable process.
