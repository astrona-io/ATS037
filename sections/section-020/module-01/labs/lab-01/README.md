---
estimated_duration: 20m
---

# Lab: Working With A Cluster

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `console` Deployment cannot pull its image and a `leftover` Deployment must be deleted without deleting its Pods. The learner records the evidence in a ConfigMap, fixes the image and deletes with the orphan mode. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-037-lab-020-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-evidence-configmap.sh` | ConfigMap evidence records the context, a pull-failure reason and the failing image |
| `validate-console-running.sh` | console uses the podinfo 6.15.0 image and its replica is available |
| `validate-leftover-orphaned.sh` | leftover is deleted, its ReplicaSet has no owner and its Pods keep running |
