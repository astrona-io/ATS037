---
draft: true
exam_objectives:
  - Administration
---
# Configuration And Resource Management

The same container image runs in development, test and production, but the settings differ: a log level, a database address, a password. If the settings are baked into the image, every environment needs its own image. Kubernetes keeps the settings outside the image, in ConfigMaps and Secrets, and delivers them to the container when it starts. A second problem is sharing a cluster: one workload that takes all the memory harms every other. Resource requests, limits and quotas control that.

Keep one sentence in mind for this module: **configuration lives in API objects and is delivered into the Pod, and resource numbers tell the scheduler what to reserve and the kubelet what to enforce.** You will create a ConfigMap and a Secret, deliver them as environment variables and as files, observe which delivery updates a running container, and read the effect of requests and limits on a Pod.

The module has two parts. **ConfigMaps, Secrets And Configuration Delivery** covers the two objects and the ways to deliver them. **Requests, Limits And Namespace Budgets** covers the scheduler and kubelet use of resource numbers, quality of service classes, ResourceQuota and LimitRange.

## Learning goals

After this module you can:

- Choose a ConfigMap or a Secret for a setting.
- Explain how a configuration change reaches a running container.
- Distinguish a resource request from a limit.
- Compare a ResourceQuota with a LimitRange.

## Before you start

You need to know what a Pod and a namespace are. Other terms are defined where they first appear.

Your playground is a `kind` cluster running Kubernetes 1.35 with one node:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, a ConfigMap `crew-settings`, and a Secret `crew-key` |
| `outpost` | The `drifter` client |

`kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
