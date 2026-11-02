---
draft: true
exam_objectives:
  - Administration
---
# Operating Responsibilities And Availability

A team buys a managed Kubernetes service and assumes it no longer needs to operate its applications. A managed service transfers selected infrastructure responsibilities to a provider, commonly including control plane maintenance. The team still needs to manage workload configuration, permissions, images, application data and the responsibilities specified by its service agreement.

A self-managed cluster gives the operator more direct control and more work. Installation, component upgrades, certificates, datastore backups and node lifecycle may all belong to the operator. Managed services differ in whether they also manage worker nodes, networking components and upgrade scheduling. The deployment model alone does not answer every responsibility question.

High availability means designing a service to keep functioning through expected component failures. Multiple API server instances can reduce dependence on one instance. The etcd datastore uses a quorum, a majority agreement needed for progress. A three-member deployment normally tolerates one member loss; losing two removes the majority. Adding replicas without understanding failure domains can leave them all exposed to one outage.

An available control plane does not make every application available. Application replicas, placement across nodes or zones, reachable dependencies and durable data all matter. Conversely, already running containers can continue during some control plane interruptions, while new scheduling and resource changes may fail or stall.

Backups and replicas also solve different problems. Replication helps tolerate member failures; a backup supports recovery from loss or unwanted changes. Restoring cluster configuration does not automatically restore every application's external database or volume data.

A sensible lifecycle plan covers upgrades, capacity, failure detection, recovery and ownership. Associate-level reasoning asks who performs an operation and what outcome it protects, rather than requiring a production installation procedure.

## A Responsibility Matrix For A Managed Cluster

Consider a managed service that maintains API servers and etcd but leaves worker nodes to the customer. The provider may handle control plane replacement and selected upgrades. The customer still needs to patch or replace workers, configure workload permissions, maintain images and protect application data. Another managed offering can allocate these responsibilities differently, so the service agreement is part of the operating model.

Separate infrastructure maintenance from application operation. A provider can restore a failed control plane while the application remains unavailable because its database credentials are wrong. A healthy cluster can run an outdated vulnerable image. A highly available API can store a deployment declaration that has no ready application replicas.

## Quorum And Failure Domains

A three-member etcd deployment needs a majority of two members to make normal consensus progress. Losing one leaves that majority; losing two does not. Placing all three members on machines subject to the same power or zone failure can defeat the intended redundancy. Count independent failure domains, not only process replicas.

API server redundancy has different requirements from datastore consensus. Multiple API servers need an accessible client entry point and working datastore connectivity. Multiple worker nodes need suitable workload spreading and spare resources. The availability of one layer does not establish the availability of another.

Recovery planning adds another dimension. A datastore backup captures cluster records, while application volumes and external databases can need independent backup mechanisms. A recovery objective must identify acceptable lost data and restoration time, then test a procedure that covers all necessary dependencies.

Managed infrastructure can reduce routine workload, but the application owner still needs to know which failures the provider handles, which remain local and what evidence proves recovery. This is the practical distinction behind managed versus self-managed operation.

## Common pitfalls

> [!WARNING]
> A managed control plane does not remove responsibility for application data and workload security. Replication is not a substitute for a recoverable backup.
