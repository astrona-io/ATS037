# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-01/labs/lab-01
```

## Step 1: Create the Pod with a shared process namespace

Save this as `pod-inspector.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: inspector
  namespace: starfleet
spec:
  shareProcessNamespace: true
  containers:
    - name: app
      image: busybox:1.37.0
      command: ["sleep", "3600"]
    - name: tools
      image: busybox:1.37.0
      command: ["sleep", "3600"]
```

Apply it and check it:

```sh
kubectl apply -f pod-inspector.yaml
kubectl -n starfleet wait --for=condition=Ready pod/inspector --timeout=120s
kubectl -n starfleet exec inspector -c tools -- ps
```

The process list shows the `sleep` processes of both containers. Run `astrona submit`.

## Step 2: Fix the memory limit

Read why the container restarts:

```sh
kubectl -n starfleet get pods -l app=hog
kubectl -n starfleet get pods -l app=hog -o jsonpath='{.items[0].status.containerStatuses[0].lastState.terminated.reason}{"\n"}'
```

The reason is `OOMKilled`. The command needs more memory than the limit of 16Mi allows, so the kernel ends it. Raise the limit:

```sh
kubectl -n starfleet patch deployment hog --type=json -p '[{"op":"replace","path":"/spec/template/spec/containers/0/resources/limits/memory","value":"256Mi"}]'
kubectl -n starfleet rollout status deployment hog
```

The new Pod stays running. Run `astrona submit`.

## Step 3: Record the node facts

```sh
RUNTIME="$(kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.containerRuntimeVersion}')"
KERNEL="$(kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.kernelVersion}')"
kubectl -n starfleet create configmap runtime-facts --from-literal=container-runtime="${RUNTIME%%://*}" --from-literal=kernel-version="$KERNEL"
```

The runtime value is the part of `containerRuntimeVersion` before `://`. Run `astrona submit`. All checks pass.
