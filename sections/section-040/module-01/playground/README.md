# Containers And Isolation - Playground

- **Slug:** ats-037-playground-040-01
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`, `bash -n`, YAML parse).

A single-node kind cluster (Kubernetes 1.35, containerd runtime) with the Starfleet workloads.

## Run it

```sh
astrona run -c .
astrona destroy ats-037-playground-040-01
```

`astrona destroy` takes the environment name, not the config path. `astrona submit` does not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting state |
| `docs/overview.md` | What the environment contains and ideas to try |
