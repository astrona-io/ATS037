---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Summary

Every Kubernetes resource is an object that the API server stores. Four top-level fields describe it. `apiVersion` names the group and version of the schema, `kind` names the type, `metadata` holds the name, namespace, labels, annotations and unique identifier, and `spec` holds the requested behavior. Components write `status` to report what they observe. The command `kubectl explain` shows what each field means.

Scope decides where a name is valid. Most resources, such as Pods, Services and Deployments, belong to a namespace, so the same name can exist in two namespaces. Nodes, Namespaces and PersistentVolumes belong to the whole cluster. A namespace scopes names, access rules and quotas. It does not isolate network traffic by itself.

A name identifies an object at one moment. The unique identifier in the metadata identifies one object for its whole life. A replacement Pod can have the same name as the Pod it replaces, but it has a new identifier and a new address.

Labels are keys and values that selectors match. A Service selector chooses the Pods that receive traffic, and every requirement in the selector must match. Annotations hold information for people and tools and are never used for selection. Owner references are a separate link: a ReplicaSet owns its Pods, a Deployment owns its ReplicaSets, and the garbage collector removes dependents when their owner is deleted.

Key facts:

- A Deployment has metadata in two places: its own and its Pod template. Pod labels come from the template.
- A Service with a selector that matches no Pod has no endpoints.
- Selection uses labels. Management and garbage collection use owner references.

<!-- astrona:playground:destroy -->
