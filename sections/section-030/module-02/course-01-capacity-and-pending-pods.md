---
draft: true
exam_objectives:
  - Scheduling
---
# Capacity And Pending Pods

The `scout` Pod requests two CPUs, but each eligible node has only one CPU of unallocated requested capacity. The total across four nodes is four CPUs, yet no individual node fits the Pod. A normal Pod is assigned to one node; its resource demand cannot be divided arbitrarily across the cluster.

Node capacity describes total resources, while allocatable capacity excludes resources reserved for the system and other purposes. The scheduler considers existing requests against allocatable resources. Low current CPU use does not imply that requested capacity is available for another Pod.

Pending is a broad phase. A Pod may be waiting for a scheduling decision, an image or storage preparation. Scheduling evidence such as an insufficient-resource event narrows the diagnosis. A placement restriction can also produce Pending behavior even when a node has sufficient capacity.

Several remedies are possible, but they have different tradeoffs. Reducing an excessive request can improve fit when measurements justify the change. Adding a suitably sized node can provide capacity. Removing unnecessary hard placement constraints can make more nodes eligible. Increasing a limit alone does not reduce the request used for scheduling.

Node autoscaling adds or removes nodes through a separate component and its infrastructure provider. It may react to unschedulable Pods, but provisioning takes time and depends on quotas, available machine types and configuration. It cannot make an impossible affinity rule true unless an appropriate new node can be created.

Capacity planning needs both fit and resilience. If all nodes are filled to their requested capacity, losing one can leave replacement Pods Pending. Available spare capacity and distribution across failure domains help applications recover from node loss.

## Fit Is Per Node, Not Only Cluster Total

Assume three eligible nodes each have 700 millicores left after current requests. Their combined remainder is 2.1 CPUs. A new Pod requesting one CPU still does not fit any of them. The scheduler needs one suitable node, not a sum that can be divided across the Pod's containers on different machines.

If a Pod has several containers, their requests contribute to its overall placement demand according to Kubernetes resource calculation rules. Initialization and supporting containers can therefore affect fit even when the main process appears small. Read the complete admitted Pod rather than calculating from only the main container's image or measured usage.

Storage can further reduce the candidate set. A volume available only in zone A makes spare capacity in zone B irrelevant for that consumer. A hard affinity rule can have the same effect. A reported resource shortage should be interpreted after identifying which nodes remain eligible.

## Choosing A Capacity Correction

Reducing a request is appropriate when measurements and expected peaks show it was excessive. It is not a universal fix: understating demand can permit placement that later overloads the node. Changing a hard affinity rule may widen the candidate set but can violate latency, hardware or resilience requirements.

Adding a suitable node can solve real capacity shortage, but the node must match required labels, architecture and storage topology. Provisioning also depends on infrastructure quota, available machine types and the configured node groups. A node autoscaler cannot necessarily create every imaginable combination of properties.

Plan failure capacity as well as normal capacity. If one worker disappears, its managed replicas need room on the surviving eligible nodes or newly provisioned ones. A cluster fully committed under normal conditions can be unable to restore availability after a loss even though the controller correctly creates replacement objects. The relevant spare capacity belongs in the right failure domains and eligibility groups.

## Common pitfalls

> [!WARNING]
> A low utilization graph is not proof that a Pod fits. Scheduling uses requests and eligibility, and one Pod must fit on one suitable node.
