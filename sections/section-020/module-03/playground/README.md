# Operating Kubernetes - Playground

- **Slug:** ats-037-playground-020-03
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED. Built from static checks only (`astrona validate`, `bash -n`, YAML parse).

A two-node kind cluster (one control plane node, one worker, Kubernetes 1.35) with the Starfleet workloads, the `convoy` Deployment and a `Mission` CustomResourceDefinition.

## Run it

```sh
astrona run -c .
astrona destroy ats-037-playground-020-03
```

`astrona destroy` takes the environment name, not the config path. `astrona submit` does not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/` | Starting state |
| `docs/overview.md` | What the environment contains and ideas to try |
