---
draft: true
exam_objectives:
  - Administration
---
# Summary

Managed and self-managed clusters allocate operational responsibilities differently. Availability needs redundant components in suitable failure domains, and recovery needs backups that cover the relevant data. Application availability has requirements beyond control plane availability.

Custom resource definitions extend the API. Custom controllers implement reconciliation, and Operators can encode application-specific operations. An accepted custom resource cannot produce results without a working controller and its required permissions.
