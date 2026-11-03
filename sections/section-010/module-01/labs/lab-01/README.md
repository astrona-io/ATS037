---
estimated_duration: 15m
---

# Lab: Cluster Architecture

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

The cluster starts with one control plane node, one worker node and the Starfleet workloads. The learner maps the control plane components to their Pods, scales a Deployment and records the node of a Pod. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-037-lab-010-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-control-plane-map.sh` | The ConfigMap control-plane-map names the Pods of the four control plane components |
| `validate-scout-scaled.sh` | The Deployment scout asks for 3 replicas and 3 are ready |
| `validate-shuttle-node.sh` | The ConfigMap node-evidence records the node that runs shuttle |
