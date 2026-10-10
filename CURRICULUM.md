# Curriculum Coverage

Exam: Kubernetes and Cloud Native Associate (KCNA). Domain: Kubernetes Fundamentals (44%).

Verified against the [official objectives](https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/) on 2026-10-10. Module titles and questions are original teaching material, not official exam questions.

| Section | Official objective | Modules | Status |
| --- | --- | --- | --- |
| 010 | Kubernetes Core Concepts | 4 | Written; review pending |
| 020 | Administration | 3 | Written; review pending |
| 030 | Scheduling | 2 | Written; review pending |
| 040 | Containerization | 3 | Written; review pending |

| Section / module | Module | Teaching lessons | Measurable outcomes |
| --- | --- | --- | --- |
| 010 / 01 | Cluster Architecture | 2 | Identify the control plane components and their responsibilities.; Distinguish node agents from cluster controllers.; Trace a workload request from storage to container execution.; Explain how reconciliation restores a declared replica count. |
| 010 / 02 | Kubernetes API And Resources | 2 | Read the purpose of an object's API version, kind, metadata and specification.; Distinguish namespaced resources from cluster resources.; Explain labels, selectors and annotations.; Identify owner relationships and object identity. |
| 010 / 03 | Pods And Their Lifecycle | 2 | Explain which resources containers share inside a Pod.; Distinguish Pod phases from container states and waiting reasons.; Compare readiness, liveness and startup probes.; Distinguish a container restart from Pod replacement. |
| 010 / 04 | Workload Controllers | 2 | Choose Deployment, StatefulSet or DaemonSet for a workload.; Explain the Deployment and ReplicaSet relationship.; Compare a Job with a CronJob.; Identify what controllers do and what application logic must still do. |
| 020 / 01 | Working With A Cluster | 2 | Explain how a kubeconfig context selects a cluster and identity.; Choose resource, event or log evidence for a diagnostic question.; Compare declarative apply with imperative operations.; Predict how deletion interacts with workload controllers. |
| 020 / 02 | Configuration And Resource Management | 2 | Choose ConfigMap or Secret for application configuration.; Explain how configuration changes reach a running container.; Distinguish resource requests from limits.; Compare ResourceQuota with LimitRange. |
| 020 / 03 | Operating Kubernetes | 2 | Compare managed and self-managed operating responsibilities.; Explain control plane availability and datastore recovery.; Distinguish application availability from control plane availability.; Describe how custom resources and Operators extend Kubernetes. |
| 030 / 01 | Scheduling Decisions | 2 | Explain scheduler filtering and scoring.; Compare required placement rules with preferences.; Distinguish node affinity from Pod affinity.; Predict the effect of taints and tolerations. |
| 030 / 02 | Placement And Scaling | 2 | Explain why a resource request can leave a Pod Pending.; Distinguish replica changes from node capacity changes.; Explain the Horizontal Pod Autoscaler feedback loop.; Relate placement and disruption handling to application availability. |
| 040 / 01 | Containers And Isolation | 2 | Describe how namespaces and cgroups affect Linux processes.; Compare container isolation with virtual machine isolation.; Explain the container runtime's role.; Distinguish the CRI from image and runtime standards. |
| 040 / 02 | Images And Registries | 2 | Explain image layers and the container writable layer.; Distinguish a tag from a digest.; Describe build, publication and image pull stages.; Identify common causes of image pull failure. |
| 040 / 03 | Container Application Design | 2 | Explain command, arguments and environment settings at startup.; Choose durable storage for application state.; Distinguish init containers from sidecar patterns.; Explain graceful termination and safe workload replacement. |

Every section begins with an introduction. Every module ends with a summary before the next module. YAML question banks follow the final module summary of each section; a domain review bank closes the course. They are indexed separately for future application integration.

This course has no labs or playgrounds, as requested by the maintainer. All material is readable without a cluster. Technical content remains draft until review; no runtime execution or lab validation is claimed.
