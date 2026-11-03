# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory.
- `kubectl`.
- You know the difference between a Deployment, a StatefulSet and a DaemonSet, how a rolling update works, and how a Job and a CronJob differ.

The lab starts a kind cluster (Kubernetes 1.35, one control plane node and 1 workers) with the starting state described in the task. The commands for the lab are in the README of this folder.
