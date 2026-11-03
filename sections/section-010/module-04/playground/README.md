# Workload Controllers - Playground

- **Slug:** ats-037-playground-010-04
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`, `bash -n`, YAML parse).

A two-node kind cluster (one control plane node, one worker, Kubernetes 1.35) with the Starfleet workloads, a Job `survey` and a CronJob `sweep` that runs every minute.

## Run it

```sh
astrona run -c .
astrona destroy ats-037-playground-010-04
```

`astrona destroy` takes the environment name, not the config path. `astrona submit` does not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting state |
| `docs/overview.md` | What the environment contains and ideas to try |
