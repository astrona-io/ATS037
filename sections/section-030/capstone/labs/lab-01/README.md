---
estimated_duration: 40m
---

# Lab: Scheduling Capstone

Graded lab. **UNTESTED:** this lab was built from static checks only (`astrona validate`, `bash -n`, YAML parse). It has not been booted, solved or graded yet.

Two Deployments stay Pending: `mess` needs a node label and `hauler` requests too much CPU. The learner labels a node, reserves another with a taint, runs a Deployment on it, records the pending reason, fixes `hauler` and adds an autoscaler. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/capstone/labs/lab-01
astrona destroy ats-037-capstone-030
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-mess-placed.sh` | mess is unchanged and both Pods run on the -worker node, the only node with zone=east |
| `validate-worker2-reserved.sh` | The -worker2 node has the taint reserved=science:NoSchedule and no other node has it |
| `validate-lab-bench-tolerates.sh` | lab-bench has 2 running replicas that tolerate the taint and run only on the -worker2 node |
| `validate-placement-notes.sh` | placement-notes records the pending reason of the hauler Pods |
| `validate-hauler-fits.sh` | hauler has 2 ready replicas and a CPU request of at most 500m |
| `validate-hauler-hpa.sh` | HPA hauler targets Deployment hauler with 1 to 4 replicas and a 70 percent CPU target |
