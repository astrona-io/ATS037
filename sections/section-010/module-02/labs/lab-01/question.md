# Question

Solve this question on: `terminal`

The `bridge` Deployment runs two Pods in `starfleet`, but nothing can reach it through its Service. `kubectl` already points at the cluster as the cluster administrator.

1. The Service `bridge` in `starfleet` has no endpoints. Fix the Service so that it selects the `bridge` Pods. Do not change the labels of the Pods or the Deployment.

2. The `bridge` Pods must also carry the label `tier=frontend`. Add it so that every running `bridge` Pod has it and the Service keeps its endpoints. In addition, add the annotation `contact=ops` to the Deployment `bridge` itself (in its own metadata, not in the Pod template).

3. Create a ConfigMap named `api-facts` in `starfleet` with these keys, each with the correct value for this cluster:
   - `pod-owner-kind`: the kind of the object that owns a `bridge` Pod
   - `deployment-api-version`: the `apiVersion` of a Deployment
   - `nodes-namespaced`: `true` or `false`, whether the resource type `nodes` is namespaced
