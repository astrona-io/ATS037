# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-03/labs/lab-01
```

## Step 1: Create the Pod with an init container

Save this as `pod-builder.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: builder
  namespace: starfleet
spec:
  volumes:
    - name: work
      emptyDir: {}
  initContainers:
    - name: prepare
      image: busybox:1.37.0
      command: ["sh", "-c", "echo mission=ready > /work/config.txt"]
      volumeMounts:
        - name: work
          mountPath: /work
  containers:
    - name: app
      image: busybox:1.37.0
      command: ["sh", "-c", "cat /work/config.txt; sleep 3600"]
      volumeMounts:
        - name: work
          mountPath: /work
```

Apply it and check it:

```sh
kubectl apply -f pod-builder.yaml
kubectl -n starfleet wait --for=condition=Ready pod/builder --timeout=120s
kubectl -n starfleet logs builder -c app
```

The log shows `mission=ready`. The init container ran first and wrote the file through the shared volume. Run `astrona submit`.

## Step 2: Create the Pod with a native sidecar

Save this as `pod-shipper.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: shipper
  namespace: starfleet
spec:
  volumes:
    - name: logs
      emptyDir: {}
  initContainers:
    - name: tail
      image: busybox:1.37.0
      restartPolicy: Always
      command: ["sh", "-c", "touch /logs/app.log; tail -f /logs/app.log"]
      volumeMounts:
        - name: logs
          mountPath: /logs
  containers:
    - name: app
      image: busybox:1.37.0
      command: ["sh", "-c", "while true; do date >> /logs/app.log; sleep 5; done"]
      volumeMounts:
        - name: logs
          mountPath: /logs
```

```sh
kubectl apply -f pod-shipper.yaml
kubectl -n starfleet wait --for=condition=Ready pod/shipper --timeout=120s
```

The `restartPolicy: Always` on the init container makes it a sidecar that keeps running. Run `astrona submit`.

## Step 3: Repair the failing init container

Read why the application does not start:

```sh
kubectl -n starfleet get pods -l app=broken-init
kubectl -n starfleet logs -l app=broken-init -c setup
```

The Pod shows an `Init` state with errors. The init container fails because it copies a file from `/seed`, which does not exist. Replace its command with one that creates the file:

```sh
kubectl -n starfleet patch deployment broken-init --type=json -p '[{"op":"replace","path":"/spec/template/spec/initContainers/0/command","value":["sh","-c","echo ready > /shared/input.txt"]}]'
kubectl -n starfleet rollout status deployment broken-init
```

The new Pod runs the init container to completion and then starts the application. Run `astrona submit`. All checks pass.
