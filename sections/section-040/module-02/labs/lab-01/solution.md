# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-040/module-02/labs/lab-01
```

## Step 1: Fix the image reference

Read why the Pod does not start:

```sh
kubectl -n starfleet get pods -l app=courier
kubectl -n starfleet describe pod -l app=courier
```

The status is `ErrImagePull` or `ImagePullBackOff`, and the event says that the tag `6.15.99` was not found. Change the image of the Deployment to an existing tag:

```sh
kubectl -n starfleet set image deployment/courier courier=ghcr.io/stefanprodan/podinfo:6.15.0
kubectl -n starfleet rollout status deployment courier
```

The new Pod starts. Run `astrona submit`.

## Step 2: Create the Pod with an explicit pull policy

Save this as `pod-cached.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cached
  namespace: starfleet
spec:
  containers:
    - name: cached
      image: busybox:1.37.0
      imagePullPolicy: IfNotPresent
      command: ["sleep", "3600"]
```

Apply it and check it:

```sh
kubectl apply -f pod-cached.yaml
kubectl -n starfleet get pod cached
```

The Pod starts from the image that is already on the node. Run `astrona submit`.

## Step 3: Record the digest

Read the image identifier of the running `courier` Pod and keep the part after the `@` sign:

```sh
ID="$(kubectl -n starfleet get pods -l app=courier --field-selector=status.phase=Running -o jsonpath='{.items[0].status.containerStatuses[0].imageID}')"
echo "$ID"
kubectl -n starfleet create configmap image-facts --from-literal=repository=ghcr.io/stefanprodan/podinfo --from-literal=digest="${ID##*@}"
```

The digest starts with `sha256:`. Run `astrona submit`. All checks pass.
