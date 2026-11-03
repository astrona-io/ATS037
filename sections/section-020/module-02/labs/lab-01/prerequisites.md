# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl`.
- You know ConfigMaps, Secrets, the ways to deliver them to a container, requests, limits and ResourceQuota.

The lab starts a kind cluster (Kubernetes 1.35, single node) with the starting state described in the task. The commands for the lab are in the README of this folder.
