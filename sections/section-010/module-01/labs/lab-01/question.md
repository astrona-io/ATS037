# Question

Solve this question on: `terminal`

The `starfleet` namespace is running on a cluster with one control plane node and one worker node. The crew needs a short record of how the cluster is built, and the `scout` service needs more capacity. `kubectl` already points at the cluster as the cluster administrator.

1. Create a ConfigMap named `control-plane-map` in `starfleet` with four keys. Each value is the exact name of the Pod in `kube-system` that runs that component:
   - `api-server`: the Pod that runs `kube-apiserver`
   - `etcd`: the Pod that runs `etcd`
   - `scheduler`: the Pod that runs `kube-scheduler`
   - `controller-manager`: the Pod that runs `kube-controller-manager`

2. Scale the Deployment `scout` in `starfleet` to 3 replicas and wait until all 3 are ready. Change the Deployment, not the Pods.

3. Create a ConfigMap named `node-evidence` in `starfleet` with the key `shuttle-node`. Its value is the name of the node on which the `shuttle` Pod runs right now.
