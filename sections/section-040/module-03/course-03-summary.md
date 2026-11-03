---
draft: true
exam_objectives:
  - Containerization
---
# Summary

A container starts one command. The Pod field `command` replaces the image entrypoint and `args` replaces the image default arguments. A command array is run without a shell, so redirection, pipes and variable expansion work only when the command is a shell such as `sh -c`.

Configuration is delivered from outside the image. Environment variables come from fixed values or from ConfigMaps and Secrets, and mounted ConfigMaps and Secrets appear as files. A process reads its environment once at start, so a changed ConfigMap needs a Pod restart, while mounted files are updated by the kubelet and the application must read them again. The container filesystem is disposable, so a stateless application keeps no required data there. An `emptyDir` volume lasts as long as the Pod, and a PersistentVolumeClaim outlives it. At shutdown the kubelet sends `SIGTERM`, waits for the grace period and then sends `SIGKILL`, so the application must handle the first signal and, when started from a script, receive it through `exec`.

An init container runs to completion before the application containers start. Several init containers run one after another, and a failing one blocks the application and shows an `Init` status on the Pod. Init containers use their own images and hand files to the application through shared volumes. A sidecar runs beside the application for the life of the Pod, to ship logs, proxy traffic or refresh credentials. A native sidecar is an init container with `restartPolicy: Always`: it starts before the application, keeps running and is restarted when it exits. The adapter and ambassador patterns are sidecars that convert output or proxy connections.

Key facts:

- A command array has no shell.
- Environment variables are read at start. Restart to change them.
- Init containers run to completion, in order, before the application.
- A native sidecar is an init container with `restartPolicy: Always`.

<!-- astrona:playground:destroy -->
