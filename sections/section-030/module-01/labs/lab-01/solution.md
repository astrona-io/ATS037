# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-01/labs/lab-01
```

## Step 1: Label the first worker node

Read why the Pods are Pending, then list the nodes:

```sh
kubectl -n starfleet get pods -l app=dockyard
kubectl -n starfleet describe pod -l app=dockyard
kubectl get nodes
```

The events say that no node matched the node selector. The Deployment asks for the label `disk=ssd`, and no node has it. Label the worker node whose name ends in `-worker`:

```sh
NODE="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep -- '-worker$')"
kubectl label nodes "$NODE" disk=ssd
kubectl -n starfleet rollout status deployment dockyard
```

The scheduler retries after the label change, and both Pods start on that node. Run `astrona submit`.

## Step 2: Taint the second worker node

```sh
NODE2="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep -- '-worker2$')"
kubectl taint nodes "$NODE2" dedicated=probe:NoSchedule
kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
```

The `NoSchedule` effect keeps new Pods without a toleration away and leaves running Pods alone. Run `astrona submit`.

## Step 3: Create the Deployment with a toleration

Save this as `deployment-escort.yaml`, with the name of your second worker node in the selector:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: escort
  namespace: starfleet
spec:
  replicas: 2
  selector:
    matchLabels:
      app: escort
  template:
    metadata:
      labels:
        app: escort
    spec:
      tolerations:
        - key: dedicated
          operator: Equal
          value: probe
          effect: NoSchedule
      nodeSelector:
        kubernetes.io/hostname: "NODE_NAME"
      containers:
        - name: escort
          image: ghcr.io/stefanprodan/podinfo:6.15.0
```

Apply it and check it:

```sh
kubectl apply -f deployment-escort.yaml
kubectl -n starfleet get pods -l app=escort -o wide
```

Both Pods run on the tainted node. The toleration lets them in, and the selector sends them there. Run `astrona submit`. All checks pass.
