---
draft: true
exam_objectives:
  - Containerization
---
# Container Application Design

A team moves an application into a container and it fails in ways it never did on a server: a command with a redirection prints the redirection instead of obeying it, configuration is baked into the image, files written at run time vanish, and a setup step runs at the wrong moment. These are design problems, not cluster problems. The container is a process with an explicit start command, an environment and a short-lived filesystem, and the application has to fit that shape.

Keep one sentence in mind for this module: **a container runs one explicit command with injected configuration and disposable local state, and anything that must happen before it or beside it is a separate container in the same Pod.** You will see how a command array is run without a shell, deliver configuration to a container, run an init container before an application and run a sidecar beside it.

The module has two parts. **Startup, Configuration And Application State** covers the start command, configuration delivery, state and shutdown. **Init Containers And Sidecar Patterns** covers containers that prepare, assist or adapt an application inside a Pod.

## Learning goals

After this module you can:

- Explain how the `command` and `args` fields start a container.
- Deliver configuration to a container without rebuilding the image.
- Distinguish stateless application design from persistent state.
- Choose between init containers and sidecar containers.

## Before you start

You need to know what a Pod, a container and an image are. Other terms are defined where they first appear.

Your playground is a `kind` cluster running Kubernetes 1.35 with one node. The images `ghcr.io/stefanprodan/podinfo:6.15.0` and `busybox:1.37.0` are loaded on the node.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, one replica each, with Services for `scout` and `probe` |
| `outpost` | The `drifter` client |

`kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
