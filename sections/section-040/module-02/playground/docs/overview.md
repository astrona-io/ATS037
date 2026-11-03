# Overview: Images And Registries (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator. The images `ghcr.io/stefanprodan/podinfo:6.15.0`, `busybox:1.37.0`, `mccutchen/go-httpbin:2.25.0` and `curlimages/curl:8.22.0` are loaded on the node. No registry is installed.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe` and `shuttle`, one replica each |
  | `outpost` | The `drifter` client |

## Helpers

`image_of` prints the image reference from the Pod specification. `image_id` prints the image identifier that the runtime resolved, which includes the digest. `pull_events` prints the events of one Pod.

```sh
image_of() {
  kubectl -n "$1" get pod "$2" -o jsonpath='{.spec.containers[0].image}{"\n"}'
}
image_id() {
  kubectl -n "$1" get pod "$2" -o jsonpath='{.status.containerStatuses[0].imageID}{"\n"}'
}
pull_events() {
  kubectl -n "$1" get events --field-selector "involvedObject.name=$2" -o jsonpath='{range .items[*]}{.reason}{": "}{.message}{"\n"}{end}'
}
```

Use them like this: `image_of starfleet <POD_NAME>`, `image_id starfleet <POD_NAME>` and `pull_events starfleet courier`.

## Practice tasks

- Create a Pod with an image tag that does not exist. Read `pull_events` and compare the statuses `ErrImagePull` and `ImagePullBackOff`.
- Compare `image_of` and `image_id` for a running Pod and find the digest.
- Create a Pod that uses the digest from `image_id` in its reference, written as `repository@sha256:...`.
- Create Pods with `Never`, `IfNotPresent` and `Always` for an image that is on the node and one that is not, and compare the statuses.
- Create a Secret of type `kubernetes.io/dockerconfigjson` with `kubectl create secret docker-registry` and reference it in `imagePullSecrets`.
