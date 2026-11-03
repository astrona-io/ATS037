---
estimated_duration: 20m
---

# Lab: Containers And Isolation

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `hog` Deployment is OOMKilled because its memory limit is too small. The learner fixes the limit, creates a Pod whose containers share a process namespace, and records the runtime and kernel facts of the node. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-01/labs/lab-01
astrona destroy ats-037-lab-040-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-shared-process-namespace.sh` | Pod inspector has containers app and tools, both running, with shareProcessNamespace true |
| `validate-hog-stable.sh` | hog keeps its image, has a memory limit of at least 128Mi and 1 ready replica |
| `validate-runtime-facts.sh` | ConfigMap runtime-facts records the runtime name and the kernel version of the node |
