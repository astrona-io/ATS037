# Overview: Configuration And Resource Management (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe`, `shuttle`, the ConfigMap `crew-settings` (keys `LOG_LEVEL` and `greeting.txt`) and the Secret `crew-key` (key `token`) |
  | `outpost` | The `drifter` client |

## Helpers

`decode` prints the decoded value of one Secret key. `qos_of` prints the quality of service class of a Pod.

```sh
decode() {
  kubectl -n "$1" get secret "$2" -o jsonpath="{.data.$3}" | base64 -d; echo
}
qos_of() {
  kubectl -n "$1" get pod "$2" -o jsonpath='{.status.qosClass}{"\n"}'
}
```

Use them like this: `decode starfleet crew-key token` and `qos_of outpost drifter`.

## Practice tasks

- Print `crew-settings` with `-o yaml` and `crew-key` with `-o yaml`. Explain what the base64 text proves about protection.
- Create a Pod that takes `LOG_LEVEL` from `crew-settings` as an environment variable and mounts the ConfigMap as files. Change the ConfigMap and compare the variable with the file after a minute.
- Create three Pods that are Guaranteed, Burstable and BestEffort. Check each with `qos_of`.
- Create a Pod that allocates more memory than its limit and read the container state. Find the reason `OOMKilled`.
- Add a ResourceQuota for `pods` in `outpost` and try to create more Pods than it allows. Read the error.
