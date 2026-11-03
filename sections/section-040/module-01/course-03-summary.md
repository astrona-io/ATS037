---
draft: true
exam_objectives:
  - Containerization
---
# Summary

A container is a normal Linux process that the kernel limits in two ways. Namespaces limit what the process sees: its process list, filesystem, network interfaces and other resources. Control groups limit what the process uses: CPU time, memory and the number of processes. A CPU limit throttles the process. A memory limit is a hard ceiling, and a process over it is ended by the kernel with the reason `OOMKilled`. A Linux namespace is not a Kubernetes namespace.

Containers on one node share the kernel of that node. A virtual machine has its own guest kernel, which gives a stronger boundary at a higher cost in startup time and resources. The two can be combined, and sandboxed runtimes place a lightweight virtual machine or a user-space kernel around a Pod. Privileged containers, host mounts and added capabilities weaken the boundary of any container.

The kubelet does not run containers. It calls a container runtime through the Container Runtime Interface, a gRPC API defined by Kubernetes. Containerd and CRI-O are runtimes that implement it. The runtime pulls images and calls a low-level runtime such as runc, which creates the namespaces and cgroups and starts the process. A network plugin attaches the Pod sandbox to the cluster network.

The Open Container Initiative defines the image, runtime and distribution specifications. These are separate from the Container Runtime Interface. Because of the image specification, an image built with one tool runs on any compatible runtime, as long as it has a variant for the node architecture and operating system.

When a Pod does not start, name the failing layer. No node means the scheduler or capacity. A node but no running container means the kubelet, the runtime or the image. A container that starts and exits means the application.

Key facts:

- Namespaces limit visibility. Control groups limit usage.
- Memory over the limit causes `OOMKilled`. CPU over the limit causes throttling.
- The CRI is the kubelet-to-runtime interface. OCI covers images, execution and registries.
- Containers share the node kernel.

<!-- astrona:playground:destroy -->
