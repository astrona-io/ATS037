---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Workload Controllers

A bare Pod runs once and is not replaced if its node fails. Real applications need more: a number of identical copies that survive failures, one copy on every node, replicas with stable names and storage, or a task that must run to the end and stop. Kubernetes offers a different controller for each of these needs. Choosing the wrong one is a common mistake, and the exam asks you to choose by the requirement.

Keep one sentence in mind for this module: **a workload resource describes a pattern, and a controller keeps creating Pods that match it.** You will create a Deployment and watch its ReplicaSets during an update, run a DaemonSet and a StatefulSet and see how they differ, and run a Job and a CronJob that finish.

The module has two parts. **Managing Long-Running Workloads** covers Deployments, ReplicaSets, rolling updates, StatefulSets and DaemonSets. **Completion Tasks And Scheduled Tasks** covers Jobs and CronJobs and what a controller does not do for the application.

## Learning goals

After this module you can:

- Choose Deployment, StatefulSet or DaemonSet for a workload.
- Explain the Deployment and ReplicaSet relationship.
- Compare a Job with a CronJob.
- Identify what controllers do and what application logic must still do.

## Before you start

You need to know what a Pod, a label and a selector are, and the commands `kubectl get` and `kubectl apply`. Other terms are defined where they first appear.

Your playground is a `kind` cluster running Kubernetes 1.35 with one control plane node and one worker node:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, one replica each, with Services for `scout` and `probe` |
| `outpost` | The `drifter` client |

`kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
