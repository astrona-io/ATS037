# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-02/labs/lab-01
```

## Step 1: Fix the Service selector

Compare the selector of the Service with the labels of the Pods:

```sh
kubectl -n starfleet get service bridge -o jsonpath='{.spec.selector}{"\n"}'
kubectl -n starfleet get pods -l app=bridge --show-labels
```

The Service selects `app: bridge-web`, but the Pods have `app=bridge`. Change the Service, because the Pods are correct:

```sh
kubectl -n starfleet patch service bridge -p '{"spec":{"selector":{"app":"bridge"}}}'
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=bridge
```

The EndpointSlice now lists two addresses. Run `astrona submit`. The `service-selects-pods` check passes.

## Step 2: Add the label and the annotation

Pod labels belong in the Pod template. Patch the template, then annotate the Deployment's own metadata:

```sh
kubectl -n starfleet patch deployment bridge -p '{"spec":{"template":{"metadata":{"labels":{"tier":"frontend"}}}}}'
kubectl -n starfleet annotate deployment bridge contact=ops
kubectl -n starfleet rollout status deployment bridge
```

The patch changes the Pod template, so the Deployment controller rolls out new Pods that carry the label. Run `astrona submit`. Labelling the existing Pods by hand does not pass, because the next replacement would lose the label.

## Step 3: Read the facts from the API

Each value comes from the cluster:

```sh
kubectl -n starfleet get pod -l app=bridge -o jsonpath='{.items[0].metadata.ownerReferences[0].kind}{"\n"}'
kubectl explain deployment | head -n 5
kubectl api-resources | grep -w nodes
```

The owner kind is `ReplicaSet`. `kubectl explain deployment` shows `VERSION: v1` and the group `apps`, which gives `apps/v1`. The `NAMESPACED` column for `nodes` is `false`. Create the ConfigMap:

```sh
kubectl -n starfleet create configmap api-facts \
  --from-literal=pod-owner-kind=ReplicaSet \
  --from-literal=deployment-api-version=apps/v1 \
  --from-literal=nodes-namespaced=false
```

Run `astrona submit`. All checks pass.
