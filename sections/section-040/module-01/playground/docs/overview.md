# Overview: Containers And Isolation (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. The node is a container on your machine and uses containerd as its runtime. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe` and `shuttle`, one replica each |
  | `outpost` | The `drifter` client |

## Helpers

`node_facts` prints the runtime, kernel, architecture and operating system of the node. `last_reason` prints why the container of a Pod last terminated. `procs` lists the processes visible inside one container of a Pod.

```sh
node_facts() {
  kubectl get nodes -o jsonpath='{range .items[*]}{.status.nodeInfo.containerRuntimeVersion}{" "}{.status.nodeInfo.kernelVersion}{" "}{.status.nodeInfo.architecture}{" "}{.status.nodeInfo.osImage}{"\n"}{end}'
}
last_reason() {
  kubectl -n "$1" get pod "$2" -o jsonpath='{.status.containerStatuses[0].lastState.terminated.reason}{"\n"}'
}
procs() {
  kubectl -n "$1" exec "$2" -c "$3" -- ps
}
```

Use them like this: `node_facts`, `last_reason starfleet greedy` and `procs starfleet inspector app`.

## Practice tasks

- Create a Pod with two containers and compare the `ps` output with and without `shareProcessNamespace: true`.
- Create a Pod with a memory limit smaller than its need and read `last_reason`. Raise the limit and watch the restarts stop.
- Create a Pod with a CPU limit of `100m` that runs a busy loop. Check that it keeps running and is only slowed down.
- Read the node facts and say which runtime serves the kubelet.
- Run a Pod with `hostNetwork: true` and compare its network namespace with a normal Pod.
