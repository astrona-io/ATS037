---
draft: true
exam_objectives:
  - Administration
---
# Contexts And Reading Cluster Evidence

An administrator has access to a development cluster and a production cluster. The same resource name exists in both. Before making a request, the administrator must identify the target and the credentials used. A kubeconfig file describes clusters, user credentials and contexts. A context associates a cluster, a user entry and an optional default namespace.

The kubectl command-line client uses that configuration to contact the Kubernetes application programming interface (API). Selecting a context changes the default target; it does not change the permissions granted to the identity. A namespace choice scopes namespaced requests but does not grant access or prevent a cluster-scoped request.

Different evidence answers different questions. A resource list gives an overview of objects and their reported state. A detailed description combines important fields, conditions and related events. Events describe actions or problems reported by components, such as failed scheduling or image pulls. Application logs describe what a container's process wrote. None is a substitute for the others.

Suppose a Pod has never started a container because its image cannot be pulled. Events and container waiting details are useful; application logs may not exist. If a running application returns a database connection error, its logs and configuration may be more useful than the scheduler's decision.

Viewing complete object fields can clarify a misleading summary. Inspect the requested specification separately from observed status. Resource type, name and namespace must all be correct before interpreting the evidence. Cluster-wide listing can help compare scopes, but it requires the corresponding permission.

A safe workflow starts by checking the selected context and namespace, then reading evidence before changing state. A local configuration tells the client where to send a request; the server decides whether that request is allowed.

## Choosing Evidence From A Specific Symptom

Suppose `scout` has fewer available replicas than requested. Start with the Deployment's desired and observed counts rather than immediately inspecting one arbitrary process. The controller's conditions can show whether an update is progressing, while the related ReplicaSet and Pods show where the missing capacity is located.

If a Pod has not obtained a node assignment, examine scheduling conditions and events. Application logs cannot describe a process that has never executed. If it has an assignment but an image pull fails, the runtime's reported failure and artifact reference become relevant. If it runs and returns errors, application logs and request evidence become more useful. The transition from one evidence source to another follows the lifecycle stage.

A resource list is efficient for discovering the affected set, but abbreviated columns can hide distinctions. A detailed object view exposes fields such as container restart counts, waiting reasons and owner references. A description can gather important events, though event retention is limited and old events may no longer explain current state. Match timestamps to the actual incident.

## Context Is Part Of The Evidence

Now assume the operator accidentally selected the production context while investigating a development failure. A Pod with the same name might appear healthy, leading to a false conclusion that the problem disappeared. The resource observation is real but belongs to the wrong environment. Cluster, namespace and identity must be recorded alongside the result.

Permissions can also limit the view. An identity allowed to read Pods might not be allowed to read Secrets or list resources across every namespace. A forbidden diagnostic request is not proof that the object is absent. It means the server did not permit that action by that caller.

The reliable reasoning sequence is to establish the target, choose evidence suited to the stage and interpret both the result and any access error. This produces a diagnosis grounded in the system the user actually reported rather than in a familiar-looking resource elsewhere.

## Common pitfalls

> [!WARNING]
> A familiar resource name does not identify the cluster. A context change selects a target and credentials, not a new authorization policy.
