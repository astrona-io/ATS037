# Overview: Cluster Architecture (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with the example workloads and then waits. There is no task, no `astrona submit` and no pass or fail. Look at the components, break things, `astrona destroy`, start over.

## What's in the box

- A `kind` cluster running Kubernetes 1.35 with one control plane node and one worker node. Each node is a container on your machine. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `kube-system` | The control plane Pods (`kube-apiserver`, `etcd`, `kube-scheduler`, `kube-controller-manager`), CoreDNS, `kube-proxy` and the network agent |
  | `starfleet` | `scout` (`podinfo`), `probe` (`go-httpbin`) and `shuttle` (a client), one replica each, with Services for `scout` and `probe` |
  | `outpost` | The `drifter` client |

## Helpers

Paste these once in each new terminal. `events_of` prints the events of a namespace in time order. `replica_counts` prints the desired, observed and ready replica counts of a Deployment.

```sh
events_of() {
  kubectl -n "$1" get events --sort-by=.metadata.creationTimestamp
}
replica_counts() {
  kubectl -n "$1" get deployment "$2" -o jsonpath='desired={.spec.replicas} observed={.status.replicas} ready={.status.readyReplicas}{"\n"}'
}
```

Use them like this: `events_of starfleet` and `replica_counts starfleet scout`.

## Practice tasks

- List the Pods in `kube-system` and find the node of each control plane Pod. Explain why no control plane Pod runs on the worker node.
- Run `kubectl get nodes -o wide` and name the container runtime on each node.
- Create a Deployment with three replicas and read the events. Name the component behind each event.
- Delete one Pod of a Deployment and watch `replica_counts` until `ready` is back at the desired value.
- Scale `scout` to an image that does not exist (`kubectl -n starfleet set image deployment/scout scout=ghcr.io/stefanprodan/podinfo:0.0.0-missing`). Compare the three counts and find which component reports the problem.
