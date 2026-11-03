# Overview: Operating Kubernetes (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A `kind` cluster running Kubernetes 1.35 with one control plane node and one worker node. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe`, `shuttle`, the Deployment `convoy` (three replicas) |
  | `outpost` | The `drifter` client |

- The CustomResourceDefinition `missions.starfleet.example.com` with the required fields `objective` and `crewSize`.

## Helpers

`worker` prints the name of the worker node. `pods_on` lists the Pods of a namespace that run on a node.

```sh
worker() {
  kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}{"\n"}'
}
pods_on() {
  kubectl -n "$1" get pods -o wide --field-selector "spec.nodeName=$2"
}
```

Use them like this: `worker` and `pods_on starfleet "$(worker)"`.

## Practice tasks

- Cordon the worker node, scale `scout` to three replicas and see where the new Pods go. Then uncordon.
- Create a PodDisruptionBudget for `convoy` and read `ALLOWED DISRUPTIONS` with `kubectl get pdb`.
- Run `kubectl get leases -n kube-system` and find the leases of the scheduler and the controller manager.
- Run `kubectl explain mission.spec` and read the fields. Create a Mission from them and list it with `kubectl get missions -A`.
- Try to create a Mission with `crewSize: 0` and read the error. Explain who rejected it.
- Run `kubectl api-resources` and find three resources that come from the cluster and not from the core API.
