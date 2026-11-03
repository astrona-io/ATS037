# Overview: Workload Controllers (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A `kind` cluster running Kubernetes 1.35 with one control plane node and one worker node. `kubectl` is already pointed at it, as the cluster administrator.

  | Namespace | What is in it |
  | --- | --- |
  | `starfleet` | `scout`, `probe`, `shuttle`, the Job `survey` (two completions) and the CronJob `sweep` (runs every minute) |
  | `outpost` | The `drifter` client |

## Helpers

`rs_of` lists the ReplicaSets of an application with their desired and ready counts. `job_state` prints the active, succeeded and failed counts of a Job.

```sh
rs_of() {
  kubectl -n starfleet get replicaset -l "app=$1" -o custom-columns=NAME:.metadata.name,DESIRED:.spec.replicas,READY:.status.readyReplicas
}
job_state() {
  kubectl -n starfleet get job "$1" -o jsonpath='active={.status.active} succeeded={.status.succeeded} failed={.status.failed}{"\n"}'
}
```

Use them like this: `rs_of scout` and `job_state survey`.

## Practice tasks

- Scale `scout` to three replicas, change an environment variable on it, and run `rs_of scout` during and after the rollout. Explain the two ReplicaSets.
- Run `kubectl -n starfleet rollout undo deployment scout` and say which ReplicaSet scales up.
- Create a StatefulSet with two replicas and delete `name-0`. Compare the name of the replacement with the name of a replaced Deployment Pod.
- Run `kubectl -n kube-system get daemonset` and explain why `kube-proxy` shows two Pods.
- Run `job_state survey` and read the Pod list for `job-name=survey`. Explain why the Pods stay in the `Completed` state.
- Wait two minutes and list the Jobs that `sweep` created. Explain why only two successful Jobs are kept.
- Set `kubectl -n starfleet patch cronjob sweep -p '{"spec":{"suspend":true}}'` and check that no new Job appears.
