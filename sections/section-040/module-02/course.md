---
draft: true
exam_objectives:
  - Containerization
---
# Images And Registries

A team deploys `scout` and the same workload behaves differently after a restart, although nobody edited the Deployment. Or a Pod stays in `ImagePullBackOff` for an hour. Both problems start at the image reference: what the string names, whether the name can change meaning, and which step of build, publish and pull has failed. If you cannot read an image reference and name the stage that failed, you cannot fix either problem.

Keep one sentence in mind for this module: **an image is a stack of immutable layers named by content, a tag is a movable label on that content, a digest is the content identity, and a pull is a separate step that can fail on its own.** You will read the digest of a running container, see that a container writable layer disappears with the container, and fix a Pod that cannot pull its image.

The module has two parts. **Layers, Tags And Digests** covers what an image contains and how a reference names it. **From Build To Image Pull** covers how an image is built, published and pulled, and how pull failures are read.

## Learning goals

After this module you can:

- Explain image layers and the writable container layer.
- Distinguish a tag from a digest.
- Describe the path from a build to a pulled image.
- Diagnose common image pull failures.

## Before you start

You need to know what a container and a Pod are. Other terms are defined where they first appear.

Your playground is a `kind` cluster running Kubernetes 1.35 with one node. The images `ghcr.io/stefanprodan/podinfo:6.15.0` and `busybox:1.37.0` are already loaded on the node, so Pods that use them start without a download. The playground has no image registry of its own.

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The example workloads `scout`, `probe` and `shuttle`, one replica each, with Services for `scout` and `probe` |
| `outpost` | The `drifter` client |

`kubectl` already points at the playground cluster, as the cluster administrator.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
