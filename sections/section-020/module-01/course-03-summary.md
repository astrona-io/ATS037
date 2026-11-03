---
draft: true
exam_objectives:
  - Administration
---
# Summary

A kubeconfig file holds clusters, users and contexts. A context ties one cluster, one user and an optional default namespace together, and `current-context` selects the one that `kubectl` uses. Switching the context changes where requests go. It does not move workloads or change permissions. A namespace scopes names for most resources, and some resources, such as nodes, are cluster-scoped.

Four kinds of evidence answer four questions. A list shows which objects exist. A description shows the fields, conditions and recent events of one object. Events record what components reported, and they expire. Logs show what the container process wrote. Pick the evidence by the stage of the Pod: no node means events, a failed pull means the waiting reason and events, a running container with errors means logs. Compare `spec` with `status` to see the gap between the requested and the observed state.

An imperative command performs an action. A declarative `apply` states the end result and can run repeatedly. Preview a change with `kubectl diff` and with a server-side dry run before you apply it. A file in version control becomes the record of the desired state, and an edit made only to the live object is lost at the next apply.

Deletion follows ownership. Deleting an owner removes its dependents through the garbage collector. Deleting a dependent, such as a Pod of a Deployment, only triggers a replacement. The modes `background`, `foreground` and `orphan` decide when and whether the dependents go. A deleted Pod gets a grace period to stop, and a finalizer blocks removal until clean-up has run.

Key facts:

- Check the context and namespace before every change.
- Choose evidence by lifecycle stage: events before logs when nothing has started.
- `apply` is declarative and repeatable. `create` fails when the object exists.
- Delete the owner to remove a workload. Deleting its Pods only makes the controller replace them.

<!-- astrona:playground:destroy -->
