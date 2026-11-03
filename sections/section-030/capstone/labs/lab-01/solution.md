# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/capstone/labs/lab-01
```

## Step 1: Label the first worker node

```sh
kubectl -n starfleet describe pod -l app=mess
kubectl get nodes
NODE="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep -- '-worker$')"
kubectl label nodes "$NODE" zone=east
kubectl -n starfleet rollout status deployment mess
```

The events say that no node matched the node selector. The Deployment asks for `zone=east`, and no node has the label. After the label is set, the scheduler retries and both Pods start on that node. Run `astrona submit`.

## Step 2: Taint the second worker node and run lab-bench there

```sh
NODE2="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep -- '-worker2$')"
kubectl taint nodes "$NODE2" reserved=science:NoSchedule
```

Save this as `deployment-lab-bench.yaml`, with the name of your second worker node in the selector:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: lab-bench
  namespace: starfleet
spec:
  replicas: 2
  selector:
    matchLabels:
      app: lab-bench
  template:
    metadata:
      labels:
        app: lab-bench
    spec:
      tolerations:
        - key: reserved
          operator: Equal
          value: science
          effect: NoSchedule
      nodeSelector:
        kubernetes.io/hostname: "NODE_NAME"
      containers:
        - name: lab-bench
          image: ghcr.io/stefanprodan/podinfo:6.15.0
```

```sh
kubectl apply -f deployment-lab-bench.yaml
kubectl -n starfleet get pods -l app=lab-bench -o wide
```

The toleration lets the Pods onto the tainted node, and the selector sends them there. Run `astrona submit`.

## Step 3: Record the pending reason

```sh
kubectl -n starfleet describe pod -l app=hauler
```

The event says `Insufficient cpu`, because the Deployment requests 64 cores. Record it:

```sh
kubectl -n starfleet create configmap placement-notes --from-literal=pending-reason="Insufficient cpu"
```

Run `astrona submit`.

## Step 4: Fix hauler

```sh
kubectl -n starfleet patch deployment hauler --type=json -p '[{"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/cpu","value":"100m"}]'
kubectl -n starfleet rollout status deployment hauler
```

The new Pods fit and start. Run `astrona submit`.

## Step 5: Create the autoscaler

Save this as `hpa-hauler.yaml`:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: hauler
  namespace: starfleet
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hauler
  minReplicas: 1
  maxReplicas: 4
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

```sh
kubectl apply -f hpa-hauler.yaml
kubectl -n starfleet get hpa hauler
```

The target shows `<unknown>`, because the cluster has no metrics server. That is expected. Run `astrona submit`. All checks pass.
