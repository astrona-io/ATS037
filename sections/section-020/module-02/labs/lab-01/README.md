---
estimated_duration: 20m
---

# Lab: Configuration And Resource Management

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `ballast` Deployment has no resource settings. The learner creates a ConfigMap and a Secret, delivers them to a Pod as a variable and as files, sets requests and a limit on `ballast`, and creates a namespace quota. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-037-lab-020-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-config-objects.sh` | ConfigMap app-settings and Secret app-key hold the required values |
| `validate-reader-pod.sh` | reader is ready, takes LOG_LEVEL from the ConfigMap and mounts the Secret at /etc/key |
| `validate-ballast-resources.sh` | ballast has requests 50m and 64Mi, a 128Mi memory limit and 2 available replicas |
| `validate-outpost-quota.sh` | outpost-budget allows 5 Pods and 10 ConfigMaps in outpost |
