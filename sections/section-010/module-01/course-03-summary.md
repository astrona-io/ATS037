---
draft: true
exam_objectives:
  - Kubernetes Core Concepts
---
# Summary

A Kubernetes cluster has a control plane and worker nodes. The API server receives and checks every request and is the only component that talks to the `etcd` datastore. The scheduler assigns a node to each Pod that has none. The controller manager runs the controllers. On each node the kubelet makes assigned Pods run, the container runtime starts the containers and a network component forwards Service traffic.

A single Deployment request passes through several components in a fixed order. The API server stores the Deployment. The Deployment controller creates a ReplicaSet. The ReplicaSet controller creates Pod objects. The scheduler assigns nodes. The kubelet and the runtime start the containers. Each step can fail on its own, so the last completed step points to the component that needs attention.

Every resource separates desired state, in `spec`, from observed state, in `status`. A controller reads both, takes the smallest action that closes the difference and repeats. It acts through the API, so its work appears as objects and events. A deleted Pod is replaced by a new Pod with a new identity, built from the template in the Deployment.

Reconciliation has limits. An accepted request does not mean a finished one. A new Pod object does not mean an available replica. Controllers cannot restore application data or repair a dependency that they do not manage.

Key facts:

- The control plane stores state and decides. The worker nodes run containers.
- Only the API server reads and writes `etcd`.
- The scheduler writes a node name. The kubelet and the runtime run the containers.
- Compare desired count, observed count and available count before you decide what is broken.

<!-- astrona:playground:destroy -->
