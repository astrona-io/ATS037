# Overview: Container Application Design (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. The images `ghcr.io/stefanprodan/podinfo:6.15.0` and `busybox:1.37.0` are loaded on the node.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe` and `shuttle`, one replica each |
  | `outpost` | The `drifter` client |

## Helpers

`phase` prints the phase and the init container progress of a Pod. `logs_of` prints the log of one container of a Pod. `init_state` prints the state of the first init container.

```sh
phase() {
  kubectl -n "$1" get pod "$2" -o jsonpath='{.status.phase}{" "}{.status.initContainerStatuses[*].state}{"\n"}'
}
logs_of() {
  kubectl -n "$1" logs "$2" -c "$3"
}
init_state() {
  kubectl -n "$1" get pod "$2" -o jsonpath='{.status.initContainerStatuses[0].state}{"\n"}'
}
```

Use them like this: `phase starfleet builder`, `logs_of starfleet builder app` and `init_state starfleet stuck`.

## Practice tasks

- Create a Pod whose command array contains `>` and compare it with the same text under `sh -c`.
- Create a Pod with `env` from a ConfigMap, change the ConfigMap, and check that the running container keeps the old value until the Pod is replaced.
- Create a Pod with two init containers and watch them run in order with `kubectl get pod -w`.
- Make the first init container fail and read the log of the init container.
- Replace an ordinary second container with a native sidecar and compare the order of the container start times.
