---
estimated_duration: 25m
---

# Lab: Workload Controllers

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `hangar` Deployment uses the Recreate strategy. The learner switches it to a rolling update, then creates a DaemonSet that also runs on the control plane node, a CronJob that forbids overlap and a Job with two completions. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-04/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-04/labs/lab-01
astrona destroy ats-037-lab-010-04
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-hangar-rolling-update.sh` | hangar uses RollingUpdate with maxSurge 1 and maxUnavailable 0 and all 3 replicas are available |
| `validate-lookout-on-every-node.sh` | The DaemonSet lookout runs one ready Pod on every node, including the control plane |
| `validate-nightly-scan-cronjob.sh` | nightly-scan runs every five minutes, forbids overlap, keeps one successful Job and uses restartPolicy Never |
| `validate-one-shot-job.sh` | one-shot has 2 completions, backoffLimit 1, restartPolicy Never and has finished |
