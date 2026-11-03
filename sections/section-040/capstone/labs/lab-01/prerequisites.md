# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl`.
- You know memory limits and OOM kills, image tags and digests, init containers, native sidecars and shared volumes.

The lab starts a kind cluster (Kubernetes 1.35, single node) with the starting state described in the task. The commands for the lab are in the README of this folder.
