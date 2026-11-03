# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/capstone/labs/lab-01
```

## Step 1: Create the relay Deployment

Save this as `deployment-relay.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: relay
  namespace: starfleet
spec:
  replicas: 3
  selector:
    matchLabels:
      app: relay
  template:
    metadata:
      labels:
        app: relay
        tier: edge
    spec:
      containers:
        - name: relay
          image: ghcr.io/stefanprodan/podinfo:6.15.0
```

Apply it and check it:

```sh
kubectl apply -f deployment-relay.yaml
kubectl -n starfleet rollout status deployment relay
kubectl -n starfleet get pods -l app=relay --show-labels
```

All three Pods carry both labels. Run `astrona submit`.

## Step 2: Record the owner

Read the owner reference of a `relay` Pod. It names a ReplicaSet:

```sh
OWNER="$(kubectl -n starfleet get pods -l app=relay -o jsonpath='{.items[0].metadata.ownerReferences[0].name}')"
kubectl -n starfleet create configmap cluster-notes --from-literal=owner-replicaset="$OWNER"
```

The Deployment owns the ReplicaSet, and the ReplicaSet owns the Pods. Run `astrona submit`.

## Step 3: Repair the stalled Pod

```sh
kubectl -n starfleet get pod stalled
kubectl -n starfleet describe pod stalled
```

The container is running, but the readiness probe fails, and the events report a failed HTTP probe with status 404. The probe asks for `/nope`, which the application does not serve. The probe of a Pod cannot be edited in place, so replace the Pod. Save this as `pod-stalled.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: stalled
  namespace: starfleet
  labels:
    app: stalled
spec:
  containers:
    - name: stalled
      image: ghcr.io/stefanprodan/podinfo:6.15.0
      ports:
        - containerPort: 9898
      readinessProbe:
        httpGet:
          path: /healthz
          port: 9898
        periodSeconds: 5
```

```sh
kubectl -n starfleet delete pod stalled
kubectl apply -f pod-stalled.yaml
kubectl -n starfleet wait --for=condition=Ready pod/stalled --timeout=120s
```

Run `astrona submit`.

## Step 4: Create the DaemonSet

Save this as `daemonset-lookout.yaml`:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: lookout
  namespace: starfleet
spec:
  selector:
    matchLabels:
      app: lookout
  template:
    metadata:
      labels:
        app: lookout
    spec:
      containers:
        - name: lookout
          image: busybox:1.37.0
          command: ["sleep", "3600"]
```

```sh
kubectl apply -f daemonset-lookout.yaml
kubectl -n starfleet rollout status daemonset lookout
```

One Pod runs on each node. Run `astrona submit`.

## Step 5: Create the CronJob

Save this as `cronjob-nightly.yaml`:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nightly
  namespace: starfleet
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: nightly
              image: busybox:1.37.0
              command: ["echo", "nightly sweep"]
```

```sh
kubectl apply -f cronjob-nightly.yaml
kubectl -n starfleet get cronjob nightly
```

Run `astrona submit`. All checks pass.
