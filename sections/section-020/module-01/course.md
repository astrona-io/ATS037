---
draft: true
exam_objectives:
  - Administration
---
# Working With A Cluster

A cluster is reached through one API, and every command you type is a request to it. Two mistakes cause most of the damage in daily work: sending a request to the wrong cluster or namespace, and changing a resource before reading what is wrong with it. A short routine prevents both: check where you are, read the evidence, then change one thing.

Keep one sentence in mind for this module: **the kubeconfig file decides where a request goes, the evidence commands tell you what is true, and a declarative change states the end result you want.** You will read the current context, collect evidence from events and logs, change a resource from a file, and delete a resource with and without its dependents.

The module has two parts. **Contexts And Reading Cluster Evidence** covers kubeconfig, contexts, namespaces and the commands that show the state of an object. **Declarative Changes And Deletion** covers `apply` compared with `create`, previews, and how deletion cascades to dependents.

## Learning goals

After this module you can:

- Explain how a kubeconfig context selects a cluster and an identity.
- Choose between a list, a description, the events and the logs for a symptom.
- Compare declarative `apply` with imperative commands.
- Predict what happens to dependents when you delete a resource.

## Before you start

You need to know what a Pod and a Deployment are. Other terms are defined where they first appear.

Your playground is a `kind` cluster running Kubernetes 1.35 with one node:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, one replica each, with Services for `scout` and `probe`, and a Deployment `broken-image` that cannot start |
| `outpost` | The `drifter` client |

`kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
