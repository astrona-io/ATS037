---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Kubernetes API And Resources

Everything in Kubernetes is an object in one API. A Deployment, a Pod, a Service and a node are all records that the API server stores and that components read. To work in the cluster, or to answer an exam question about it, you must read these records correctly: which type an object is, where its name is valid, what behavior it requests, what has happened to it and which other objects it is connected to.

Keep one sentence in mind for this module: **every object has a type, a scope, an identity, a requested state and an observed state, and labels and owner references are two separate ways that objects relate to each other.** You will read the fields of a real Deployment, find which resources belong to a namespace and which do not, and follow a Service selector and an owner reference to the Pods behind them.

The module has two parts. **Objects, Scope And Identity** reads the fields of an object, separates namespaced resources from cluster resources and explains names and unique identifiers. **Labels, Selectors And Ownership** explains how a Service finds Pods through labels, what annotations are for and how owner references connect a Deployment, a ReplicaSet and a Pod.

## Learning goals

After this module you can:

- Read the purpose of an object's API version, kind, metadata and specification.
- Distinguish namespaced resources from cluster resources.
- Explain labels, selectors and annotations.
- Identify owner relationships and object identity.

## Before you start

You need to know what a Pod and a Deployment are, and the commands `kubectl get` and `kubectl describe`. YAML is a text format for records: indentation shows which field belongs to which parent. Every other term is defined where it first appears.

Your playground is a single-node `kind` cluster running Kubernetes 1.35, with no extra tools:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | `scout`, `probe` and `shuttle` Deployments with one replica each, a Service for `scout` and `probe`, and a ConfigMap `crew-notes` that carries an annotation |
| `outpost` | The `drifter` client |

`kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
