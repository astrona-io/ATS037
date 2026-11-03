# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/capstone/labs/lab-01
```

## Step 1: Fix uplink

```sh
kubectl -n starfleet describe pod -l app=uplink
kubectl -n starfleet set image deployment/uplink uplink=ghcr.io/stefanprodan/podinfo:6.15.0
kubectl -n starfleet rollout status deployment uplink
```

The event says that the tag `6.15.99` was not found. After the change, the new Pod starts. Run `astrona submit`.

## Step 2: Create the ConfigMap and the reader Pod

Save this as `pod-reader.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: reader
  namespace: starfleet
spec:
  containers:
    - name: reader
      image: busybox:1.37.0
      command: ["sleep", "3600"]
      env:
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: ship-settings
              key: LOG_LEVEL
```

Create the ConfigMap, apply the Pod and check the variable:

```sh
kubectl -n starfleet create configmap ship-settings --from-literal=LOG_LEVEL=debug
kubectl apply -f pod-reader.yaml
kubectl -n starfleet wait --for=condition=Ready pod/reader --timeout=120s
kubectl -n starfleet exec reader -- printenv LOG_LEVEL
```

The command prints `debug`. Run `astrona submit`.

## Step 3: Set resources on engine-room

```sh
kubectl -n starfleet patch deployment engine-room --type=json -p '[{"op":"add","path":"/spec/template/spec/containers/0/resources","value":{"requests":{"cpu":"50m","memory":"32Mi"},"limits":{"memory":"128Mi"}}}]'
kubectl -n starfleet rollout status deployment engine-room
```

The change to the Pod template starts a new rollout. Run `astrona submit`.

## Step 4: Create the quota

```sh
kubectl -n outpost create quota outpost-budget --hard=pods=4
kubectl -n outpost describe quota outpost-budget
```

The description shows the used and the allowed number of Pods. Run `astrona submit`.

## Step 5: Create the PodDisruptionBudget

Save this as `pdb-caravan.yaml`:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: caravan
  namespace: starfleet
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: caravan
```

```sh
kubectl apply -f pdb-caravan.yaml
kubectl -n starfleet get pdb caravan
```

Run `astrona submit`.

## Step 6: Cordon the worker node

```sh
NODE="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')"
kubectl cordon "$NODE"
kubectl get nodes
```

The node shows `SchedulingDisabled`. Cordoning only stops new Pods from being placed there. The running `caravan` Pods stay. Run `astrona submit`. All checks pass.
