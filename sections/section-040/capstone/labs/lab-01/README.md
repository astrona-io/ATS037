---
estimated_duration: 40m
---

# Lab: Containerization Capstone

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

Two Deployments fail: `leaky` is killed for exceeding its memory limit and `fetcher` cannot pull its image. The learner repairs both, builds a Pod with an init container, a native sidecar and an application, and records the live runtime and image digest. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/capstone/labs/lab-01
astrona destroy ats-037-capstone-040
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-leaky-fixed.sh` | leaky keeps its image, a memory limit of at least 128Mi and has 1 ready replica |
| `validate-fetcher-running.sh` | fetcher uses podinfo:6.15.0 and has 1 ready replica |
| `validate-pipeline-init.sh` | Pod pipeline has a completed init container generate and worker printed mode=night |
| `validate-pipeline-sidecar.sh` | pipeline has an init container watcher with restartPolicy Always, and watcher and worker run |
| `validate-container-notes.sh` | container-notes records the live runtime name and the digest of the running fetcher image |
