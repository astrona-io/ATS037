---
estimated_duration: 15m
---

# Lab: Kubernetes API And Resources

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `bridge` Deployment runs in `starfleet` behind a Service whose selector does not match its Pods. The learner fixes the selector, adds a Pod label and an annotation, and records API facts. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-037-lab-010-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-service-selects-pods.sh` | The Service bridge has ready endpoints and the Pod labels are unchanged |
| `validate-tier-label-and-annotation.sh` | Every running bridge Pod has tier=frontend and the Deployment has the annotation contact=ops |
| `validate-api-facts.sh` | The ConfigMap api-facts holds the owner kind, the Deployment apiVersion and the scope of nodes |
