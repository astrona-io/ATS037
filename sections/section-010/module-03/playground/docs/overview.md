# Overview: Pods And Their Lifecycle (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe`, `shuttle`, and three Pods: `relay` (containers `writer` and `reader` share an `emptyDir`), `crashy` (exits after five seconds, restarts) and `once` (`restartPolicy: Never`, completes) |
  | `outpost` | The `drifter` client |

## Helpers

`pod_state` prints the phase, the ready flag, the restart count and the waiting or terminated reason of every container of a Pod. `restarts_of` prints the restart count only.

```sh
pod_state() {
  kubectl -n "$1" get pod "$2" -o jsonpath='phase={.status.phase}{"\n"}{range .status.containerStatuses[*]}{.name} ready={.ready} restarts={.restartCount} state={.state}{"\n"}{end}'
}
restarts_of() {
  kubectl -n "$1" get pod "$2" -o jsonpath='{.status.containerStatuses[0].restartCount}{"\n"}'
}
```

Use them like this: `pod_state starfleet crashy` and `restarts_of starfleet crashy`.

## Practice tasks

- Read the logs of `relay` for each container with `kubectl logs -c`. Explain which container prints and which one reads.
- Run `kubectl exec relay -c writer -- touch /tmp/mine` and look for `/tmp/mine` in the `reader` container.
- Run `pod_state starfleet crashy` twice, thirty seconds apart. Explain why the phase stays `Running`.
- Read `kubectl logs crashy --previous` and explain why the option is needed.
- Delete the Pod `scout-...` and the Pod `crashy`. Compare which one comes back, and say why.
- Add a `readinessProbe` on a path that does not exist to a Deployment and watch the READY column and the Service endpoints.
