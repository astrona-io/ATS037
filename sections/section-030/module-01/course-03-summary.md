---
draft: true
exam_objectives:
  - Scheduling
---
# Summary

The scheduler places each Pod that has no node. It first filters out nodes that cannot run the Pod, because of too little free requested capacity, a node selector, a taint or a port conflict. It then scores the feasible nodes and binds the Pod to the best one. If filtering leaves nothing, the Pod stays `Pending` with a `FailedScheduling` event that explains why each node was rejected. The scheduler uses requests, not live usage.

A node selector names labels that a node must have. Node affinity extends this with operators and with a choice: the required form filters and the preferred form only adds to the score. Pod affinity and anti-affinity decide by the Pods that already run in a topology domain, which is the group of nodes that share one value of the `topologyKey` label. Topology spread constraints limit the difference in matching Pods between domains with `maxSkew`. The words `IgnoredDuringExecution` mean that running Pods are not moved when labels change.

A taint on a node repels Pods that do not tolerate it. The effect `NoSchedule` blocks new Pods only, `PreferNoSchedule` is a soft preference, and `NoExecute` also evicts running Pods. A toleration on a Pod allows a matching taint, by key, operator, value and effect. It does not attract the Pod. To pin a Pod to a tainted node, add a node selector or node affinity to the toleration. Kubernetes adds taints for node problems and gives Pods default tolerations that evict them after 300 seconds when a node is lost.

Key facts:

- Filter first, then score, then bind.
- Labels and selectors attract. Taints repel. Tolerations only allow.
- `NoSchedule` keeps new Pods out. `NoExecute` also removes running ones.
- A Pending Pod with `FailedScheduling` has been filtered out of every node.

<!-- astrona:playground:destroy -->
