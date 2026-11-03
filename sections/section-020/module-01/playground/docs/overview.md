# Overview: Working With A Cluster (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe`, `shuttle` and `broken-image`, a Deployment whose image tag does not exist |
  | `outpost` | The `drifter` client |

## Helpers

`where` prints the active context, the cluster and the default namespace. `warnings` prints the Warning events of a namespace in time order.

```sh
where() {
  kubectl config view --minify -o jsonpath='context={.current-context} cluster={.contexts[0].context.cluster} namespace={.contexts[0].context.namespace}{"\n"}'
}
warnings() {
  kubectl -n "$1" get events --field-selector type=Warning --sort-by=.metadata.creationTimestamp
}
```

Use them like this: `where` and `warnings starfleet`.

## Practice tasks

- Run `where`, then set the default namespace to `outpost` and run `where` again.
- Find out why `broken-image` does not start with `describe`, then with `get events`. Explain why `kubectl logs` shows nothing useful.
- Print the image of `broken-image` with `-o jsonpath`. Fix it with `kubectl set image`, then compare with `kubectl diff` on a file.
- Run `kubectl explain deployment.spec.strategy.rollingUpdate` and read the field descriptions.
- Delete the Pod of `scout`, then delete the Deployment `scout` with `--cascade=foreground`. Describe what stays visible and for how long.
