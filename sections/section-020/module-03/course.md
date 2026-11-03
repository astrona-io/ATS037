---
draft: true
exam_objectives:
  - Administration
---
# Operating Kubernetes

Running a cluster is a job with parts that never finish: upgrading versions, keeping the control plane available, recovering the datastore, taking a node out for maintenance without hurting the applications, and extending the API for needs that the built-in resources do not cover. Who does which part depends on whether the cluster is managed by a provider or run by your own team.

Keep one sentence in mind for this module: **the control plane and the applications fail separately, so protect each one with its own mechanism, and extend the API with custom resources instead of changing Kubernetes itself.** You will take a node out of scheduling, protect an application from voluntary disruption, and create a custom resource from a definition.

The module has two parts. **Operating Responsibilities And Availability** covers managed and self-managed clusters, control plane availability, etcd recovery, upgrades and node maintenance. **Custom Resources And Operators** covers CustomResourceDefinitions, custom controllers and the Operator pattern.

## Learning goals

After this module you can:

- Compare managed and self-managed operating responsibilities.
- Explain control plane availability and datastore recovery.
- Distinguish application availability from control plane availability.
- Describe how custom resources and Operators extend Kubernetes.

## Before you start

You need to know what a node, a Pod and a Deployment are. Other terms are defined where they first appear.

Your playground is a `kind` cluster running Kubernetes 1.35 with one control plane node and one worker node:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, and the Deployment `convoy` with three replicas |
| `outpost` | The `drifter` client |

The cluster also has a CustomResourceDefinition named `missions.starfleet.example.com`. `kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
