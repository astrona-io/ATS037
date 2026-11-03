# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-03/labs/lab-01
```

## Step 1: Read the evidence and fix the probes

Look at the Pods, then at the events of one of them:

```sh
kubectl -n starfleet get pods -l app=beacon
kubectl -n starfleet describe pod -l app=beacon
```

The events show two problems. The liveness probe fails with a 404 response because the path `/nope` does not exist, so the kubelet restarts the container. The readiness probe cannot connect to port 8080, because the container listens on 9898, so the Pod is never ready. Patch both probes in the Pod template:

```sh
kubectl -n starfleet patch deployment beacon --type=json -p '[
  {"op":"replace","path":"/spec/template/spec/containers/0/livenessProbe/httpGet/path","value":"/healthz"},
  {"op":"replace","path":"/spec/template/spec/containers/0/livenessProbe/failureThreshold","value":3},
  {"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/port","value":"http"}
]'
kubectl -n starfleet rollout status deployment beacon
```

The Deployment controller replaces the Pods with Pods that use the corrected template. Run `astrona submit`. The `beacon-probes-fixed` check passes when both replicas are available and no probe was removed.

## Step 2: Add the startup probe

```sh
kubectl -n starfleet patch deployment beacon --type=json -p '[
  {"op":"add","path":"/spec/template/spec/containers/0/startupProbe","value":{"httpGet":{"path":"/healthz","port":"http"},"periodSeconds":2,"failureThreshold":30}}
]'
kubectl -n starfleet rollout status deployment beacon
```

A new rollout starts with the new template. Run `astrona submit`.

## Step 3: Create the Pod with a shared volume

Save this as `pod-exchange.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: exchange
  namespace: starfleet
spec:
  containers:
    - name: producer
      image: busybox:1.37.0
      command: ["sh", "-c", "while true; do date >> /data/log; sleep 5; done"]
      volumeMounts:
        - name: data
          mountPath: /data
    - name: consumer
      image: busybox:1.37.0
      command: ["sh", "-c", "touch /data/log; tail -f /data/log"]
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      emptyDir: {}
```

Apply it and check it:

```sh
kubectl apply -f pod-exchange.yaml
kubectl -n starfleet get pod exchange
kubectl -n starfleet logs exchange -c consumer
```

The Pod shows `READY 2/2`, and the consumer prints the lines that the producer writes. Run `astrona submit`. All checks pass.
