---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Pods And Their Lifecycle

A Pod is the smallest unit that Kubernetes schedules. It holds one or more containers that run on the same node and share some resources. Almost every question about a running application ends at a Pod: why is it not starting, why does it keep restarting, why does it receive no traffic? To answer, you must know what the containers in a Pod share, which status field says what, and which component reacts to a failure.

Keep one sentence in mind for this module: **a Pod does not restart and does not heal; the kubelet restarts containers inside it, and a controller replaces the Pod itself.** You will run a Pod with two containers that share a volume, read the phase and container state of a failing Pod, and separate what a probe does from what a restart policy does.

The module has two parts. **Shared Resources And Lifecycle Evidence** explains what the containers of a Pod share and how to read the phase, the container state and the waiting reason. **Restart Policies, Probes And Replacement** compares the three probes and shows the difference between a container restart and a replacement of the Pod.

## Learning goals

After this module you can:

- Explain which resources containers share inside a Pod.
- Distinguish Pod phases from container states and waiting reasons.
- Compare readiness, liveness and startup probes.
- Distinguish a container restart from Pod replacement.

## Before you start

You need to know what a container and a Deployment are, and the commands `kubectl get`, `kubectl describe` and `kubectl logs`. The words used here are defined where they first appear.

Your playground is a single-node `kind` cluster running Kubernetes 1.35, with no extra tools:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, and three Pods made for this module: `relay` (two containers that share a volume), `crashy` (a container that exits after five seconds and keeps restarting) and `once` (a Pod that runs to completion with `restartPolicy: Never`) |
| `outpost` | The `drifter` client |

`kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
