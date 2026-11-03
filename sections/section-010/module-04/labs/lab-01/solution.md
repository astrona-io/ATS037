# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-04/labs/lab-01
```

## Step 1: Switch the Deployment to a rolling update

Read the current strategy first:

```sh
kubectl -n starfleet get deployment hangar -o jsonpath='{.spec.strategy}{"\n"}'
```

The type is `Recreate`, which stops every old Pod before it starts a new one. Change it with a merge patch that sets the type and both limits:

```sh
kubectl -n starfleet patch deployment hangar --type=merge -p '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'
kubectl -n starfleet rollout status deployment hangar
```

With `maxUnavailable` 0 the controller starts a new Pod first and removes an old Pod only after the new one is ready. With `maxSurge` 1 there is at most one extra Pod. Run `astrona submit`.

## Step 2: Create the DaemonSet

The control plane node has the taint `node-role.kubernetes.io/control-plane` with the effect `NoSchedule`. A DaemonSet Pod runs there only if it tolerates that taint. Save this as `daemonset-lookout.yaml`:

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
      tolerations:
        - key: node-role.kubernetes.io/control-plane
          operator: Exists
          effect: NoSchedule
      containers:
        - name: lookout
          image: busybox:1.37.0
          command: ["sh", "-c", "sleep 3600"]
```

Apply it and check it:

```sh
kubectl apply -f daemonset-lookout.yaml
kubectl -n starfleet get daemonset lookout
kubectl -n starfleet get pods -l app=lookout -o wide
```

The desired and ready counts are both 2, and the Pods run on two different nodes. Run `astrona submit`.

## Step 3: Create the CronJob

Save this as `cronjob-nightly-scan.yaml`:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nightly-scan
  namespace: starfleet
spec:
  schedule: "*/5 * * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 1
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: scan
              image: busybox:1.37.0
              command: ["sh", "-c", "date"]
```

Apply it and check it:

```sh
kubectl apply -f cronjob-nightly-scan.yaml
kubectl -n starfleet get cronjob nightly-scan
```

The CronJob shows the schedule `*/5 * * * *`. Run `astrona submit`.

## Step 4: Create the Job

Save this as `job-one-shot.yaml`:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: one-shot
  namespace: starfleet
spec:
  completions: 2
  backoffLimit: 1
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: one-shot
          image: busybox:1.37.0
          command: ["sh", "-c", "echo one-shot done"]
```

Apply it and wait for it:

```sh
kubectl apply -f job-one-shot.yaml
kubectl -n starfleet wait --for=condition=Complete job/one-shot --timeout=120s
```

The Job reports two successful completions. Run `astrona submit`. All checks pass.
