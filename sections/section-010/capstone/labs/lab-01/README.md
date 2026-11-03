---
estimated_duration: 35m
---

# Lab: Core Concepts Capstone

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A Pod `stalled` never becomes ready. The learner creates a Deployment, records its owner chain, repairs the Pod, and adds a DaemonSet and a CronJob. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-037-capstone-010
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-relay-deployment.sh` | Deployment relay has 3 ready replicas and the labels app=relay and tier=edge |
| `validate-owner-evidence.sh` | cluster-notes records the ReplicaSet that owns the relay Pods |
| `validate-stalled-ready.sh` | Pod stalled is Ready with its readiness probe path set to /healthz |
| `validate-lookout-daemonset.sh` | DaemonSet lookout runs busybox on every node and all its Pods are ready |
| `validate-nightly-cronjob.sh` | CronJob nightly runs at 0 2 * * * with busybox, not suspended |
