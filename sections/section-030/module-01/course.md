---
draft: true
exam_objectives:
  - Scheduling
---
# Scheduling Decisions

A Pod is created without a node. Something must choose the node, and the choice has consequences: the Pod needs enough free capacity, it may need a special disk, it should not share a machine with its own replicas, and some machines are reserved for other work. Kubernetes makes this choice in one component, the scheduler, with rules that you write on the Pod and on the node.

Keep one sentence in mind for this module: **the scheduler filters out nodes that cannot run the Pod, scores the rest, and binds the Pod to the best one; labels attract Pods and taints repel them.** You will label a node and attract a Pod to it, taint a node and see which Pods may enter, and read the scheduling events of a Pod that stays Pending.

The module has two parts. **Filtering, Scoring And Placement Rules** covers the scheduler steps, node selectors, affinity and spread constraints. **Taints, Tolerations And Eligibility** covers how a node refuses Pods and how a Pod accepts that.

## Learning goals

After this module you can:

- Describe the filtering and scoring phases of scheduling.
- Choose a node selector, affinity or a spread constraint for a placement need.
- Explain how a taint and a toleration decide eligibility.
- Read the scheduling events of a Pod that stays Pending.

## Before you start

You need to know what a Pod, a label and a selector are. Other terms are defined where they first appear.

Your playground is a `kind` cluster running Kubernetes 1.35 with one control plane node and two worker nodes:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, one replica each, with Services for `scout` and `probe` |
| `outpost` | The `drifter` client |

The worker nodes are named after the cluster, ending in `-worker` and `-worker2`. `kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
