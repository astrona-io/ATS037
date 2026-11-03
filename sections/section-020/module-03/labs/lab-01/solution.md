# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-03/labs/lab-01
```

## Step 1: Create the PodDisruptionBudget

Save this as `pdb-convoy.yaml`:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: convoy-budget
  namespace: starfleet
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: convoy
```

Apply it and check it:

```sh
kubectl apply -f pdb-convoy.yaml
kubectl -n starfleet get pdb convoy-budget
```

The budget shows one allowed disruption, because three Pods exist and two must stay. Run `astrona submit`.

## Step 2: Cordon the worker node

List the nodes. The worker is the node that has no `control-plane` role:

```sh
kubectl get nodes
kubectl cordon "$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')"
kubectl get nodes
```

The worker node shows `SchedulingDisabled`. The Pods on it keep running. Run `astrona submit`.

## Step 3: Create the custom resource

Read the definition to find the group, version and fields:

```sh
kubectl get crd missions.starfleet.example.com -o jsonpath='{.spec.group} {.spec.versions[0].name} {.spec.names.kind}{"\n"}'
kubectl explain mission.spec
```

Save this as `mission-survey-run.yaml`:

```yaml
apiVersion: starfleet.example.com/v1
kind: Mission
metadata:
  name: survey-run
  namespace: starfleet
spec:
  objective: map the nebula
  crewSize: 4
```

Apply it and check it:

```sh
kubectl apply -f mission-survey-run.yaml
kubectl -n starfleet get mission survey-run -o yaml
```

The API server validates the object against the schema and stores it. Run `astrona submit`. All checks pass.
