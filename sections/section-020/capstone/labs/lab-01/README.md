---
estimated_duration: 40m
---

# Lab: Administration Capstone

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A Deployment `uplink` cannot pull its image. The learner repairs it, configures a Pod from a ConfigMap, sets resources, creates a quota and a PodDisruptionBudget, and cordons the worker node. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-037-capstone-020
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-uplink-fixed.sh` | uplink uses podinfo:6.15.0 and has 1 ready replica |
| `validate-reader-config.sh` | ship-settings holds LOG_LEVEL=debug and Pod reader takes it as an environment variable |
| `validate-engine-room-resources.sh` | engine-room has requests of 50m and 32Mi and a memory limit of 128Mi |
| `validate-outpost-quota.sh` | ResourceQuota outpost-budget in outpost allows 4 Pods |
| `validate-caravan-pdb.sh` | PodDisruptionBudget caravan keeps 2 Pods of app=caravan available |
| `validate-worker-cordoned.sh` | The worker node is cordoned, the control plane node is not, and caravan keeps 3 ready replicas |
