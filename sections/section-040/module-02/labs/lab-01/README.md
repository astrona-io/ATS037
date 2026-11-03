---
estimated_duration: 20m
---

# Lab: Images And Registries

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `courier` Deployment references an image tag that does not exist. The learner fixes the reference, creates a Pod with an explicit pull policy and records the digest of the running image. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-02/labs/lab-01
astrona destroy ats-037-lab-040-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-courier-running.sh` | courier uses ghcr.io/stefanprodan/podinfo:6.15.0 and has 1 ready replica |
| `validate-cached-pod.sh` | Pod cached runs busybox:1.37.0 with imagePullPolicy IfNotPresent set explicitly |
| `validate-image-facts.sh` | ConfigMap image-facts holds the repository and the digest of the running courier image |
