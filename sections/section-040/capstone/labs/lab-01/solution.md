# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/capstone/labs/lab-01
```

## Step 1: Fix leaky

```sh
kubectl -n starfleet get pods -l app=leaky
kubectl -n starfleet describe pod -l app=leaky
```

The container state shows that the last termination reason was `OOMKilled`. The container uses more memory than its limit of `16Mi`, so the kernel stops it, and the kubelet restarts it in a loop. Raise the limit:

```sh
kubectl -n starfleet set resources deployment leaky --limits=memory=256Mi
kubectl -n starfleet rollout status deployment leaky
```

The new Pod stays running. Run `astrona submit`.

## Step 2: Fix fetcher

```sh
kubectl -n starfleet describe pod -l app=fetcher
```

The events report a failed image pull, because the tag `6.15.99` does not exist. Set the correct tag:

```sh
kubectl -n starfleet set image deployment/fetcher fetcher=ghcr.io/stefanprodan/podinfo:6.15.0
kubectl -n starfleet rollout status deployment fetcher
```

Run `astrona submit`.

## Step 3: Create the pipeline Pod

Save this as `pod-pipeline.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pipeline
  namespace: starfleet
spec:
  volumes:
    - name: work
      emptyDir: {}
  initContainers:
    - name: generate
      image: busybox:1.37.0
      command: ["sh", "-c", "echo mode=night > /work/settings.txt"]
      volumeMounts:
        - name: work
          mountPath: /work
    - name: watcher
      image: busybox:1.37.0
      restartPolicy: Always
      command: ["sh", "-c", "touch /work/events.log; tail -f /work/events.log"]
      volumeMounts:
        - name: work
          mountPath: /work
  containers:
    - name: worker
      image: busybox:1.37.0
      command: ["sh", "-c", "cat /work/settings.txt; while true; do date >> /work/events.log; sleep 5; done"]
      volumeMounts:
        - name: work
          mountPath: /work
```

```sh
kubectl apply -f pod-pipeline.yaml
kubectl -n starfleet wait --for=condition=Ready pod/pipeline --timeout=120s
kubectl -n starfleet logs pipeline -c worker
```

The init container `generate` runs first and ends. The sidecar `watcher` starts next and keeps running because of `restartPolicy: Always`. The worker then starts and prints `mode=night`. Run `astrona submit`.

## Step 4: Record the live facts

```sh
kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.containerRuntimeVersion}{"\n"}'
kubectl -n starfleet get pods -l app=fetcher -o jsonpath='{.items[0].status.containerStatuses[0].imageID}{"\n"}'
```

The first value looks like `containerd://` followed by a version. Keep only the part before `://`. In the second value keep only the part after `@`, which starts with `sha256:`. Then create the ConfigMap with your two values:

```sh
kubectl -n starfleet create configmap container-notes \
  --from-literal=container-runtime=<RUNTIME> \
  --from-literal=fetcher-digest=<DIGEST>
```

Run `astrona submit`. All checks pass.
