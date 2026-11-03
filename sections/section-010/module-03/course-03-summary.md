---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Summary

The containers of one Pod run on the same node and share one network namespace, so they have one IP address, share ports and reach each other on `localhost`. They share the volumes that the Pod declares and nothing else. Each container keeps its own root file system. An `emptyDir` volume lives as long as the Pod, so it survives a container restart.

Three fields describe the life of a Pod. The phase is a coarse summary: `Pending`, `Running`, `Succeeded`, `Failed` or `Unknown`. The container state is `Waiting`, `Running` or `Terminated`, with a reason or an exit code. A waiting reason such as `ImagePullBackOff` or `CrashLoopBackOff` names the cause. `CrashLoopBackOff` is not a phase. A crashing Pod has the phase `Running`.

The restart policy tells the kubelet what to do when a container exits: `Always`, `OnFailure` or `Never`. The kubelet restarts the container inside the same Pod with a growing delay. A restart keeps the Pod name, the `uid` and the IP address.

Three probes check a container. The startup probe protects a slow start. The liveness probe restarts a container that is stuck. The readiness probe removes a Pod from Service endpoints without restarting it. A probe must fail `failureThreshold` times in a row before the kubelet acts.

A replacement is different from a restart. When a Pod is deleted or its node is lost, a controller such as a ReplicaSet creates a new Pod with a new name, a new `uid` and a new address. A Pod without a controller is not replaced.

Key facts:

- Restart is done by the kubelet. Replacement is done by a controller.
- Liveness failures restart. Readiness failures only stop traffic.
- Use the container state, the waiting reason and the events to find the cause, not the phase alone.

<!-- astrona:playground:destroy -->
