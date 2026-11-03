---
estimated_duration: 20m
---

# Lab: Placement And Scaling

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `cargo` Deployment requests 64 cores of CPU, so its Pods stay Pending. The learner records the evidence in a ConfigMap, fixes and scales `cargo`, and creates a HorizontalPodAutoscaler for `engine`. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-02/labs/lab-01
astrona destroy ats-037-lab-030-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-pending-reason.sh` | capacity-notes records the scheduling failure reason and the live allocatable CPU |
| `validate-cargo-scheduled.sh` | cargo has 3 ready replicas, a CPU request of at most 500m and the original image |
| `validate-engine-hpa.sh` | HPA engine targets Deployment engine with 2 to 5 replicas and a 60 percent CPU target |
