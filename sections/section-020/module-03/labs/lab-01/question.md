# Question

Solve this question on: `terminal`

The cluster has one control plane node and one worker node. The worker node needs maintenance later today, and the `convoy` Deployment in `starfleet` has three replicas that must stay available while it happens. `kubectl` already points at the cluster as the cluster administrator. A CustomResourceDefinition named `missions.starfleet.example.com` is installed. Complete these tasks.

1. Create a PodDisruptionBudget named `convoy-budget` in `starfleet` that keeps at least 2 `convoy` Pods available during voluntary disruptions.

2. Mark the worker node as unschedulable so that no new Pods are placed on it. The Pods that already run on it must keep running. Do not change the control plane node.

3. Create a custom resource of the kind `Mission` named `survey-run` in `starfleet`. Its `spec.objective` must be `map the nebula` and its `spec.crewSize` must be `4`. Read the CustomResourceDefinition first to find the API group and version.
