# Overview: Scheduling Decisions (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A `kind` cluster running Kubernetes 1.35 with one control plane node and two worker nodes, named ending in `-worker` and `-worker2`. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe` and `shuttle`, one replica each |
  | `outpost` | The `drifter` client |

- The control plane node carries the taint `node-role.kubernetes.io/control-plane:NoSchedule`.

## Helpers

`workers` prints the names of the worker nodes. `placement` shows which node each Pod of a namespace runs on. `why_pending` prints the scheduling events of one Pod.

```sh
workers() {
  kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
}
placement() {
  kubectl -n "$1" get pods -o custom-columns=POD:.metadata.name,NODE:.spec.nodeName,PHASE:.status.phase
}
why_pending() {
  kubectl -n "$1" get events --field-selector "involvedObject.name=$2,reason=FailedScheduling" -o jsonpath='{range .items[*]}{.message}{"\n"}{end}'
}
```

Use them like this: `workers`, `placement starfleet` and `why_pending starfleet pinned`.

## Practice tasks

- Create a Pod with `nodeSelector: {disk: ssd}` and read `why_pending`. Label a worker node and watch the Pod start.
- Create a Deployment with four replicas and required Pod anti-affinity on `kubernetes.io/hostname`. Count how many replicas run and say why.
- Replace the anti-affinity with a topology spread constraint with `maxSkew: 1` and compare the result with `placement`.
- Taint one worker node with `NoSchedule`, create a Deployment and check where its Pods go. Add a toleration and compare.
- Change the taint to `NoExecute` and watch the running Pods without a toleration leave the node.
