# Pods And Their Lifecycle - Playground

- **Slug:** ats-037-playground-010-03
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`, `bash -n`, YAML parse).

A single-node kind cluster (Kubernetes 1.35) with the Starfleet workloads and three Pods: `relay` (two containers share an emptyDir), `crashy` (restarts in a loop) and `once` (runs to completion).

## Run it

```sh
astrona run -c .
astrona destroy ats-037-playground-010-03
```

`astrona destroy` takes the environment name, not the config path. `astrona submit` does not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting state |
| `docs/overview.md` | What the environment contains and ideas to try |
