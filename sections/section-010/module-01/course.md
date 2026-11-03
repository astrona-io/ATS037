---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Cluster Architecture

A Kubernetes cluster is a group of machines that run containers on behalf of one API. When a team asks for three copies of the `scout` application, no single program starts three processes. The request passes through several components. Each one has one job, and each one can fail on its own. If you cannot name the component that owns a step, you cannot explain a symptom or answer an exam question about it.

Keep one sentence in mind for this module: **the control plane records and decides, the worker nodes execute, and controllers keep closing the gap between what was asked for and what exists.** You will list the real control plane components in a running cluster, follow one Deployment from the API server to a running container, and watch a controller replace a deleted Pod.

The module has two parts. **Control Plane And Worker Responsibilities** names every component, says where it runs and traces one request through them. **Desired State And Reconciliation** explains the specification and status fields, the control loop, and what self-healing does and does not cover.

## Learning goals

After this module you can:

- Identify the control plane components and their responsibilities.
- Distinguish node agents from cluster controllers.
- Trace a workload request from storage to container execution.
- Explain how reconciliation restores a declared replica count.

## Before you start

You need to know what a container is and have seen the command `kubectl get`. Every other term is defined where it first appears. The terms the module uses are these: a cluster (all the machines and components together), a node (one machine in the cluster), a Pod (the smallest deployable unit, one or more containers that run together) and a Deployment (a resource that manages replaceable copies of an application).

Your playground is a `kind` cluster that runs Kubernetes 1.35. It has one control plane node and one worker node. Each node is a container on your machine, so the cluster is small but the components are the real ones.

| Namespace | What is in it |
| --- | --- |
| `kube-system` | The control plane components as Pods, the cluster DNS and the network agent on each node |
| `starfleet` | The example workloads `scout` (a web service), `probe` (an HTTP test service) and `shuttle` (a client that only waits), each with one replica, and a Service for `scout` and `probe` |
| `outpost` | The `drifter` client, a second client in a separate namespace |

`kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
