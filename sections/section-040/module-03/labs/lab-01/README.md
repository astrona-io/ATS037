---
estimated_duration: 25m
---

# Lab: Container Application Design

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `broken-init` Deployment never starts because its init container fails. The learner repairs it, builds a Pod with an init container that hands a file to the application, and a Pod with a native sidecar. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-03/labs/lab-01
astrona destroy ats-037-lab-040-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-init-container.sh` | Pod builder runs an init container prepare, and app prints mission=ready from the shared volume |
| `validate-native-sidecar.sh` | Pod shipper has an init container tail with restartPolicy Always, and both containers run |
| `validate-broken-init-fixed.sh` | broken-init keeps its init container and volume and has 1 ready replica |
