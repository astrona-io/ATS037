# Overview: Placement And Scaling (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe` and `shuttle`, one replica each, and the Deployment `engine` with a CPU request of 100 millicores |
  | `outpost` | The `drifter` client |

- No metrics server is installed, so a HorizontalPodAutoscaler cannot read any metric here.

## Helpers

`capacity` prints the allocatable resources of each node. `requested` prints the CPU requests of every Pod in a namespace. `why_pending` prints the scheduling events of one Pod.

```sh
capacity() {
  kubectl get nodes -o custom-columns=NAME:.metadata.name,CPU:.status.allocatable.cpu,MEMORY:.status.allocatable.memory,PODS:.status.allocatable.pods
}
requested() {
  kubectl -n "$1" get pods -o custom-columns=POD:.metadata.name,CPU:.spec.containers[*].resources.requests.cpu
}
why_pending() {
  kubectl -n "$1" get events --field-selector "involvedObject.name=$2,reason=FailedScheduling" -o jsonpath='{range .items[*]}{.message}{"\n"}{end}'
}
```

Use them like this: `capacity`, `requested starfleet` and `why_pending starfleet <POD_NAME>`.

## Practice tasks

- Create a Deployment with a CPU request larger than the node allocatable CPU. Read `why_pending`, then lower the request and watch the Pods start.
- Scale `engine` up until the Pods stop fitting. Compare the sum of requests in `describe node` with the allocatable CPU.
- Create a Pod with no requests and a Pod with a large memory request. Compare how the scheduler treats them.
- Create a HorizontalPodAutoscaler for `engine` and read why its target shows `<unknown>`.
- Create a PriorityClass and two Deployments with different priorities and compare which one the scheduler places first.
