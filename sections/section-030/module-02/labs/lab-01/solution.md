# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-030/module-02/labs/lab-01
```

## Step 1: Read the evidence

List the Pods and read the events of one of them:

```sh
kubectl -n starfleet get pods -l app=cargo
kubectl -n starfleet describe pod -l app=cargo
kubectl get nodes -o custom-columns=NAME:.metadata.name,CPU:.status.allocatable.cpu
```

The Pods are Pending and have no node. The `FailedScheduling` event says `Insufficient cpu`, because the Deployment requests 64 cores and the node has far fewer. Copy the allocatable CPU value of the node exactly as printed, then create the ConfigMap:

```sh
CPU="$(kubectl get nodes -o jsonpath='{.items[0].status.allocatable.cpu}')"
kubectl -n starfleet create configmap capacity-notes --from-literal=reason="Insufficient cpu" --from-literal=allocatable-cpu="$CPU"
```

Run `astrona submit`.

## Step 2: Fix and scale cargo

Lower the CPU request so that it fits, and scale to three replicas:

```sh
kubectl -n starfleet patch deployment cargo --type=json -p '[{"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/cpu","value":"100m"}]'
kubectl -n starfleet scale deployment cargo --replicas=3
kubectl -n starfleet rollout status deployment cargo
```

The change to the Pod template starts a new rollout, and the new Pods fit on the node. Removing the request would also let the Pods start, but the check requires a request. Run `astrona submit`.

## Step 3: Create the autoscaler

Save this as `hpa-engine.yaml`:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: engine
  namespace: starfleet
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: engine
  minReplicas: 2
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
```

Apply it and check it:

```sh
kubectl apply -f hpa-engine.yaml
kubectl -n starfleet get hpa engine
```

The object is stored. Its target column shows `<unknown>` because the cluster has no metrics server, which is expected. Run `astrona submit`. All checks pass.
