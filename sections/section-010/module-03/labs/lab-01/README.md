---
estimated_duration: 20m
---

# Lab: Pods And Their Lifecycle

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `beacon` Deployment has a wrong liveness path and a wrong readiness port. The learner fixes the probes, adds a startup probe and builds a two-container Pod that shares an emptyDir volume. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-03/labs/lab-01
astrona destroy ats-037-lab-010-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-beacon-probes-fixed.sh` | beacon keeps both probes with the right path and port and both replicas are available |
| `validate-beacon-startup-probe.sh` | beacon has a startup probe on /healthz that allows at least 10 failures |
| `validate-exchange-shared-volume.sh` | The Pod exchange has two ready containers that mount the same emptyDir volume |
