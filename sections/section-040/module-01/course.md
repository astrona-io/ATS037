---
draft: true
exam_objectives:
  - Containerization
---
# Containers And Isolation

A team runs `scout` in a container and asks how isolated it is from the other containers on the same node. The answer is not a single switch. A container is a normal Linux process that the kernel limits in two ways: what it can see, and how much it can use. A virtual machine draws the line in a different place, with its own kernel. If you cannot say which mechanism provides which limit, you cannot judge what a container protects and what it does not.

Keep one sentence in mind for this module: **namespaces limit what a process can see, control groups limit what it can use, and the container runtime sets both up when the kubelet asks through the Container Runtime Interface.** You will look at the processes and limits of a running container, trigger an out-of-memory kill on purpose, and read which runtime a node uses.

The module has two parts. **Processes, Namespaces And Control Groups** explains the two kernel mechanisms and compares containers with virtual machines. **Runtimes And Kubernetes Integration** explains the layers between the kubelet and the container process, and the standards that connect them.

## Learning goals

After this module you can:

- Describe how namespaces and control groups affect Linux processes.
- Compare container isolation with virtual machine isolation.
- Explain the role of the container runtime.
- Distinguish the Container Runtime Interface from the image and runtime standards.

## Before you start

You need to know what a Pod and a container are. Other terms are defined where they first appear.

Your playground is a `kind` cluster running Kubernetes 1.35 with one node. The node is itself a container on your machine, and it runs containerd as its runtime.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, one replica each, with Services for `scout` and `probe` |
| `outpost` | The `drifter` client |

`kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
