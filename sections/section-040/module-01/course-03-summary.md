---
draft: true
exam_objectives:
  - Containerization
---
# Summary

Linux namespaces isolate views of system resources, while cgroups account for and constrain usage. Containers normally share the host kernel; virtual machines normally have a guest kernel. Privileges and host access affect the strength of isolation.

The kubelet uses the Container Runtime Interface to request container operations. Node runtimes manage images and execution, while Open Container Initiative specifications support portability across compatible tools. Building an artifact and running it are separate stages.
