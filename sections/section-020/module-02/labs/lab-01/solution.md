# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-02/labs/lab-01
```

## Step 1: Create the ConfigMap and the Secret

```sh
kubectl -n starfleet create configmap app-settings --from-literal=LOG_LEVEL=debug
kubectl -n starfleet create secret generic app-key --from-literal=token=orbit-7
```

The command line encodes the Secret value for you. Run `astrona submit`.

## Step 2: Deliver both to a Pod

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
      command: ["sh", "-c", "sleep 3600"]
      env:
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: app-settings
              key: LOG_LEVEL
      volumeMounts:
        - name: key
          mountPath: /etc/key
          readOnly: true
  volumes:
    - name: key
      secret:
        secretName: app-key
```

Apply it and read the values inside the container:

```sh
kubectl apply -f pod-reader.yaml
kubectl -n starfleet wait --for=condition=Ready pod/reader --timeout=120s
kubectl -n starfleet exec reader -- sh -c 'printenv LOG_LEVEL; cat /etc/key/token'
```

The container prints `debug` and `orbit-7`. Run `astrona submit`.

## Step 3: Add resource settings to ballast

```sh
kubectl -n starfleet set resources deployment ballast --requests=cpu=50m,memory=64Mi --limits=memory=128Mi
kubectl -n starfleet rollout status deployment ballast
```

The changed template makes the Deployment replace its Pods. Run `astrona submit`.

## Step 4: Create the quota

```sh
kubectl -n outpost create quota outpost-budget --hard=pods=5,configmaps=10
kubectl -n outpost describe resourcequota outpost-budget
```

The description shows the used and the hard values. Run `astrona submit`. All checks pass.
