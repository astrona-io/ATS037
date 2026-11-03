# Overview: Kubernetes API And Resources (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with the example workloads and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe` and `shuttle` (one replica each), Services for `scout` and `probe`, and the ConfigMap `crew-notes` with the annotation `contact: ops` |
  | `outpost` | The `drifter` client |

## Helpers

`endpoints_of` prints the addresses behind a Service. `owner_of` prints the kind and name of the owner of a Pod.

```sh
endpoints_of() {
  kubectl -n "$1" get endpointslices -l "kubernetes.io/service-name=$2" -o jsonpath='{.items[*].endpoints[*].addresses}{"\n"}'
}
owner_of() {
  kubectl -n "$1" get pod "$2" -o jsonpath='{.metadata.ownerReferences[0].kind}/{.metadata.ownerReferences[0].name}{"\n"}'
}
```

Use them like this: `endpoints_of starfleet scout` and `owner_of starfleet <POD_NAME>`.

## Practice tasks

- Run `kubectl explain pod.spec.containers` and find the fields `image`, `ports` and `resources`.
- Run `kubectl api-resources` and name three resources that are not namespaced.
- Change the selector of the `probe` Service to `app: probe-v2` and watch `endpoints_of starfleet probe`. Then change it back.
- Create a bare Pod with the label `app=scout`. Check that the `scout` Service lists its address and that `owner_of` finds no owner.
- Delete the `probe` Deployment with `--cascade=orphan` and check that its ReplicaSet and Pod remain. Then delete the ReplicaSet and watch the Pod.
