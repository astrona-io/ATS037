# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS037.git -c sections/section-010/module-01/labs/lab-01
```

## Step 1: Find the control plane Pods

The control plane components run as static Pods in `kube-system`. Each Pod carries a `component` label that names the program. List them with the label shown:

```sh
kubectl -n kube-system get pods -L component
```

The Pod for the API server has the label `kube-apiserver`, the one for `etcd` has `etcd`, and so on. The names end with the name of the control plane node.

## Step 2: Write the ConfigMap

Read each name with a label selector, then create the ConfigMap with the values:

```sh
kubectl -n kube-system get pod -l component=kube-apiserver -o name
kubectl -n starfleet create configmap control-plane-map \
  --from-literal=api-server="$(kubectl -n kube-system get pod -l component=kube-apiserver -o jsonpath='{.items[0].metadata.name}')" \
  --from-literal=etcd="$(kubectl -n kube-system get pod -l component=etcd -o jsonpath='{.items[0].metadata.name}')" \
  --from-literal=scheduler="$(kubectl -n kube-system get pod -l component=kube-scheduler -o jsonpath='{.items[0].metadata.name}')" \
  --from-literal=controller-manager="$(kubectl -n kube-system get pod -l component=kube-controller-manager -o jsonpath='{.items[0].metadata.name}')"
```

The values are Pod names without the `pod/` prefix. Run `astrona submit`. The `control-plane-map` check passes.

## Step 3: Scale scout through the Deployment

Scaling the Deployment changes `spec.replicas`. The ReplicaSet controller then creates the missing Pods:

```sh
kubectl -n starfleet scale deployment scout --replicas=3
kubectl -n starfleet rollout status deployment scout
```

Run `astrona submit`. Scaling the ReplicaSet or a Pod directly does not pass, because the Deployment controller would reset it.

## Step 4: Record the node of shuttle

The Pod object has the node name in `spec.nodeName`. The wide output shows it too:

```sh
kubectl -n starfleet get pod -l app=shuttle -o wide
kubectl -n starfleet create configmap node-evidence \
  --from-literal=shuttle-node="$(kubectl -n starfleet get pod -l app=shuttle -o jsonpath='{.items[0].spec.nodeName}')"
```

Run `astrona submit`. All three checks pass.
