# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-020/module-01/labs/lab-01
```

## Step 1: Collect the evidence and record it

Read the context, the Pod status and the image:

```sh
kubectl config current-context
kubectl -n starfleet get pods -l app=console
kubectl -n starfleet get pod -l app=console -o jsonpath='{.items[0].status.containerStatuses[0].state.waiting.reason}{"\n"}'
kubectl -n starfleet get deployment console -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

The waiting reason is `ErrImagePull` or `ImagePullBackOff`, depending on the moment you read it. Both are accepted. The image is `ghcr.io/stefanprodan/podinfo:6.15.99`. Create the ConfigMap with the values you read:

```sh
kubectl -n starfleet create configmap evidence \
  --from-literal=context="$(kubectl config current-context)" \
  --from-literal=reason=ImagePullBackOff \
  --from-literal=image=ghcr.io/stefanprodan/podinfo:6.15.99
```

Run `astrona submit`. The `evidence-configmap` check passes.

## Step 2: Fix the image

```sh
kubectl -n starfleet set image deployment/console console=ghcr.io/stefanprodan/podinfo:6.15.0
kubectl -n starfleet rollout status deployment console
```

The Deployment controller replaces the failing Pod with one that pulls an image that exists. Run `astrona submit`.

## Step 3: Delete the Deployment and keep the Pods

Deleting the Deployment with the default mode would also delete its ReplicaSet and Pods. Use the orphan mode:

```sh
kubectl -n starfleet delete deployment leftover --cascade=orphan
kubectl -n starfleet get replicaset,pods -l app=leftover
```

The Deployment is gone. The ReplicaSet and both Pods are still listed, and the ReplicaSet has no owner. Run `astrona submit`. All checks pass.
