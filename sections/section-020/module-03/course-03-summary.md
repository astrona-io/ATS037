---
draft: true
exam_objectives:
  - Administration
---
# Summary

In a managed cluster the provider runs, patches, upgrades and backs up the control plane. The customer still owns the workloads, access rules, network policies, resource settings and usually the node pools. In a self-managed cluster the team owns all of it, including certificates, upgrades and `etcd` backups.

A highly available control plane runs several API servers behind a load balancer. The scheduler and controller manager run on each control plane node, and leader election keeps one copy of each active. `etcd` uses a quorum: a write commits when a majority of members accepts it. Odd sizes such as three or five are used. A backup of `etcd` is a snapshot stored outside the cluster, and it restores cluster state but not the data in persistent volumes. Anything written after the snapshot is lost.

Control plane availability and application availability are separate. When the control plane stops, running Pods keep running, but nothing new is scheduled or replaced. An application survives a node failure through several replicas on several nodes, not through a healthy control plane.

For maintenance, `cordon` makes a node unschedulable, `drain` also evicts its Pods, and `uncordon` reverses it. A PodDisruptionBudget limits voluntary disruption, such as a drain, by stating how many Pods must stay available. It does not stop a node crash. Upgrades go in order: the API server first, and kubelets never newer than the API server.

A CustomResourceDefinition registers a new resource type with the API server, with a schema that validates each object. A custom resource is an instance of it and is only stored data. A custom controller watches those objects and acts on them. An Operator is a custom controller that carries the operating knowledge of one application.

Key facts:

- Managed service: the provider runs the control plane, the customer runs the workloads.
- `etcd` needs a quorum. Use three or five members.
- Running Pods survive a control plane outage. Change does not.
- CRD is the type, custom resource is the instance, controller does the work.

<!-- astrona:playground:destroy -->
