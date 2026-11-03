---
estimated_duration: 20m
---

# Lab: Scheduling Decisions

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

A `dockyard` Deployment needs a node label that no node has, so its Pods stay Pending. The learner labels the right node, taints the second worker and creates a Deployment that tolerates the taint and runs only there. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-01/labs/lab-01
astrona destroy ats-037-lab-030-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-dockyard-on-ssd-node.sh` | dockyard is unchanged and both Pods run on the -worker node, the only node with disk=ssd |
| `validate-worker2-tainted.sh` | The -worker2 node has the taint dedicated=probe:NoSchedule and no other node has it |
| `validate-escort-on-tainted-node.sh` | escort has 2 running replicas that tolerate the taint and run only on the -worker2 node |
