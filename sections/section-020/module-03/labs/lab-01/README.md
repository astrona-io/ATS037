---
estimated_duration: 20m
---

# Lab: Operating Kubernetes

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

The worker node needs maintenance. The learner protects the `convoy` Deployment with a PodDisruptionBudget, cordons the worker node and creates a custom resource from an installed CustomResourceDefinition. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-03/labs/lab-01
astrona destroy ats-037-lab-020-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-convoy-pdb.sh` | convoy-budget selects app convoy and keeps at least 2 Pods available |
| `validate-worker-cordoned.sh` | The worker node is unschedulable, the control plane node is not, and Pods still run on the worker |
| `validate-mission-resource.sh` | Mission survey-run has objective map the nebula and crewSize 4 |
