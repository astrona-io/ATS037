---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Summary

A workload resource describes a pattern, and a controller keeps creating Pods that match it. The right resource depends on the requirement, not on the application.

A Deployment runs interchangeable replicas of a stateless application. It does not create Pods directly. It creates one ReplicaSet for each version of the Pod template, and each ReplicaSet keeps a set number of Pods running. A change to the Pod template starts a rolling update: the Deployment scales the new ReplicaSet up and the old one down. The fields `maxSurge` and `maxUnavailable` set how many Pods may exist above, or be missing from, the desired count during the update. The old ReplicaSet stays with zero Pods so that a rollback is possible. A rollback restores the Pod template. It does not restore data.

A StatefulSet is for replicas that need a stable identity. Its Pods have ordered names such as `ledger-0`, and a replacement keeps the same name. Each Pod can have its own PersistentVolumeClaim from a template, and a headless Service gives each Pod a stable DNS name. A DaemonSet runs one Pod on each eligible node and adds a Pod when a node joins the cluster. It has no replica count.

A Job runs Pods until a set number of them succeed, and then it stops. The fields `completions`, `parallelism` and `backoffLimit` shape the run. The Pod template must use `restartPolicy` `OnFailure` or `Never`. A Job gives at-least-once execution, so the task must be safe to run twice. A CronJob creates a Job on a schedule. The fields `concurrencyPolicy`, `startingDeadlineSeconds` and the history limits control overlap, late runs and clean-up.

Controllers keep objects in the declared shape. They do not repair application data, replicate stored data or make a task safe to repeat. The application still needs honest readiness checks, idempotent work and its own replication.

Key facts:

- Deployment for stateless replicas, StatefulSet for stable names and storage, DaemonSet for one Pod per node.
- Job for work that finishes, CronJob for work on a schedule.
- A Deployment owns ReplicaSets, and a ReplicaSet owns Pods.
- A rollback is a rolling update back to an earlier Pod template.

<!-- astrona:playground:destroy -->
