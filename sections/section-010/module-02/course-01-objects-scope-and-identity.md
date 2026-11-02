---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Objects, Scope And Identity

Consider a Deployment named `scout` in a namespace named `starfleet`. A Kubernetes object is a stored record describing a resource. The object's API version identifies its API group and version. Its kind identifies the resource type. Metadata describes identity and other attributes; the specification describes requested behavior.

YAML is a text format often used to represent these records. Indentation expresses structure, and field names have precise meanings. A Deployment's `replicas` value belongs in its specification. Its Pod template describes the Pods to create, including container images and labels. Putting a field at the wrong level can cause rejection or produce a different configuration from the one intended.

A namespace scopes many resource names and permissions. Two Deployments named `scout` can exist in different namespaces. A node is a cluster-scoped resource and does not belong to a namespace. Namespaces organize resources, but they do not automatically isolate network traffic or provide a separate physical cluster.

An object's name identifies it within its resource type and scope. Its unique identifier distinguishes one particular object from another created later with the same name. This matters when a Pod is deleted and recreated: reusing the name does not preserve its identity or in-memory state.

The API server validates the request and stores accepted state. Other components report status as they act. The status of a Deployment may show fewer available replicas than the specification requests. That difference describes incomplete progress; changing the reported status is not the way to change the desired replica count.

Read an object by asking four questions: what type is it, where is its name scoped, what behavior is requested, and what has actually happened? Those questions separate identity, intent and evidence.

## Reading A Resource Without Confusing Its Fields

For a Deployment named `scout`, `apiVersion` identifies the API group and version that define its schema, and `kind` identifies it as a Deployment. The name and namespace belong to metadata. The replica count belongs to the Deployment specification. Container images and ports appear inside its Pod template because they describe the Pods the controller will create.

There are two distinct metadata locations worth recognizing: metadata on the Deployment and metadata on the template for its Pods. A label placed only on the Deployment does not automatically become the same label on every generated Pod. If a Service expects `app: scout` on Pods, the Pod template must supply the relevant label. Reading the indentation and containing field is therefore part of understanding the resource, not merely a formatting exercise.

Object status can include an observed generation, a record of which specification revision the controller has processed. A newer specification with older observed status suggests the controller has not yet reported the current intent. Conditions and replica counts add progress evidence; they are not fields an author should overwrite to pretend the application is healthy.

## Names And Stable Identity

A useful resource reference includes the cluster, resource type, namespace when applicable and object name. The name `scout` alone is insufficient when several namespaces or clusters contain that application. Cluster-scoped resources such as nodes require a different scope because they have no namespace.

The unique identifier matters when considering deletion and ownership. Suppose one Pod named `probe` is removed, then another uses the same name. They remain different objects, with different identifiers and potentially different addresses and storage lifecycle effects. A name can be reused; an object's historical identity cannot simply be transferred to its replacement.

These distinctions help read an example accurately. First locate the object and its scope. Then separate the workload's own metadata from its template, requested behavior from reported status, and a reusable name from a specific stored identity.

## Common pitfalls

> [!WARNING]
> A namespace is an organizational and authorization scope. Creating one does not automatically add network isolation.
